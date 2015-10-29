##' Helper functions for rCharts
##'
##' Misc helper functions to create interactive charts with rCharts
##'
##' @rdname swi_rcharts
##' @param x,y,z a numeric of same length
##' @param color,name,series a character of same length
##' @import rCharts
##' @export
##' @examples
##'
##' \dontrun{
##' #Example for hSeries to create a labelled bubble scatterchart with rCharts/highcharts
##'
##' library(swiTheme)
##' a <- rCharts::Highcharts$new()
##' x <- 1:10
##' y <- seq(1, 100, 10)
##' z <- 10:1
##' color <- rep(c("grey", "red"), 5)
##' name <- c("a", "b", "c", "d", "e", "f", "g", "h", "i", "j")
##' series <- c(rep(c("blob", "poop", "doop"), 3), "asdf")
##' a$series(hSeries(x,y,z,name, color, series))
##'
##' # tweak the bubble plot
##' a$chart(zoomType = "xy", type = "bubble")
##' a$plotOptions(bubble = list(dataLabels = list(enabled = T, style = list(textShadow = 'none') ,
##' color = '#aa8959', formatter = "#! function() { return this.point.name; } !#")))
##'
##' a$colors(swi_rpal)
##' a$tooltip(formatter = "#! function() { return this.point.name + ':' +this.x + ', ' + this.y; } !#")
##' a$xAxis(title = list(text = "important indicator", align = "high"), lineColor = list ('#FF0000'))
##' a
##'
##' hChart.html <- tempfile("hchart_labelledBubble.html")
##' a$save(hChart.html)
##' }

hSeries <- function(x, y, z, name, color = NULL, series) {
  warning("\n", "hSeries is deprecated! Use hSeries2 instead\n")
  # Check input
  stopifnot(length(x) == length(y), length(z) == length(x), length(name) == length(x),
            length(series) == length(x))
  stopifnot(is.null(color) || length(color) == length(x))
  
  if(!is.numeric(x)) stop("x needs to be numeric")
  if(!is.numeric(y)) stop("y needs to be numeric")
  if(!is.numeric(z)) stop("z needs to be numeric")

  df <- data.frame (x = as.numeric(x), y = as.numeric(y), z = as.numeric(z), color = color, name = name, series = series)

  # TODO: use  rCharts::toJSONArray2 (http://stackoverflow.com/questions/26507326/rcharts-change-the-individual-point-colors-of-a-time-series-plot-highcharts)
  # !!!!!!!!!!!!!!!!!
  seriesList <- by(df, as.factor(df$series), function(df.s) {
    list(
      data = lapply(1:nrow(df.s), function(i) {
        res <- list(x = df.s[i,'x'], y = df.s[i,'y'], z = as.character(df.s[i,'z']), name = as.character(df.s[i,'name']))
        if(!is.null(color)) res$color <- df.s[i,'color']
        res
      }),
      name = as.character(df.s$series[1])
    )
  }, simplify = F)

  # very important: needs to get rid of the attributes, otherwise highchart will not plot it!
  attributes(seriesList) <- NULL
  seriesList
}

##' @rdname swi_rcharts
##' @param df a data.frame
##' @param series a character, the column name in \code{df} to split the data in different highcharts' series
##' @import rCharts
##' @export
##' @examples
##' hSeries2 <- hSeries2(data.frame(x = x, y = y, z = z, color = color, name = name, series = series), "series")
##'  b <- rCharts::Highcharts$new()  
##' b$series(hSeries2)
##' 
hSeries2 <- function(df, series) {
  # Check input (that series is a character and is in the given data.frame)
  stopifnot(is.data.frame(df))
  stopifnot(is.character(series))
  stopifnot(series %in% colnames(df))
  
  seriesList <- by(df, as.factor(df[,series]), function(df.s) {
    # remove the column series of the data.frame
    seriesName <- as.character(df.s[1,series])
    df.s <- df.s[,-which(colnames(df.s) == series)]
    list(data = rCharts::toJSONArray2(df.s, json = F, names = T), name = seriesName)
  }, simplify = F)
  attributes(seriesList) <- NULL
  
  seriesList
}



##' Save highcharts from rCharts into a responsive html webpage
##'
##' Create a responsive html page along with javascript library files
##'
##' @rdname swi_rcharts
##' @param hChart.html,output.html character file path to the input highchart html and the output reponsive html 
##' @param output a path to a folder where the reponsive html file and depending js libraries will be saved
##' @param source,author,h2,descr,h3 characters
##' @param overwrite a logical, should the \code{output} file be overwritten?
##' @export
##' @examples
##' \dontrun{
##' # Example of converting a highcharts-rCharts html chart into a responsive one
##' 
##' hChart2responsiveHTML(hChart.html, source = "source: stupid data")
##' browseURL(hChart.html)
##' }
hChart2responsiveHTML <- function(hChart.html, output.html = "rHighchart.html", output = ".", source = "source:",
    author = "Duc-Quang Nguyen | swissinfo.ch", h2 = "title", descr = "descriptive text",
    h3 = "subtitle") {

  output.html <- file.path(output, output.html)
  #change the output file name if already exists
  if(file.exists(output.html)) {
    file.rename(output.html, gsub("\\.html$", "_init\\.html", output.html))
    warning("\n Existing output html renamed to:", gsub("\\.html$", "_init\\.html", output.html), "\n")
  }
  
  # copy the responsive header to the output file
  fpath <- system.file("extdata", "responsiveHeader.html", package="swiRcharts")
  status <- file.copy(fpath, output.html, FALSE)
  if(!status) {"Could not copy header file!"}
  
  ## Load highcharts'html and get everything between the tag <div rChart highcharts> until the last <script>
  x <- readLines(hChart.html)
  istart <- grep("rChart highcharts", x)
  scriptStartEnd <- data.frame(start = grep("<script", x), end = grep("\\/script>", x))
  scriptStartEnd$length <- scriptStartEnd$end - scriptStartEnd$start

  # append javacript code to output.html
  sink(output.html, append = T)
  
  if(h2 != "") {
    cat("<h2>",h2,"</h2>\n")
  }
  if(descr != "") {
    cat('<div class="descr">', descr, "</div>\n")
  }
  if(h3 != "") {
    cat("<h3>",h3,"</h3>\n")
  }
  # get and sink the div with rChart highcharts
  cat(x[istart:scriptStartEnd[which.max(scriptStartEnd$length),'end']])
    
  # add the footer: source & author
  cat('\n\n<!-- Source -->\n<div id="cite">', source, "|", author, "</div>")
  cat("\n\n\n</body>\n</html>")
  
  sink()
   
  ## copy the javacript library in a folder ".js"
  lib.js <- list.files(system.file("extdata", package="swiRcharts"), ".js", full.names = T)
  if(!file.exists(file.path(output, "js"))) {
    dir.create(file.path(output, 'js'), showWarnings = FALSE)
  }
  lib.js.exists <- file.exists(file.path(output, "js", basename(lib.js)))
  if(any(!lib.js.exists)) {
    file.copy(lib.js[!lib.js.exists], file.path(output, "js"))
  }
  
}