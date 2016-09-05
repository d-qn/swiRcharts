##' Helper functions for htmlwidget
##'
##' Helper functions to create a container for htmlwidget with javascript library files
##' @rdname swi_HTMLwidget
##' @param widget.html,output.html character file path to the input widget html and the output reponsive html
##' @param output a path to a folder where the output html file and the js library folder will be saved
##' @param source,author,h2,descr,h3,footer characters
##' @export
##' @examples
##' \dontrun{
##' library(swiRcharts)
##' require(htmlwidgets)
##' require(parsetR)
##' 
##' widget <- parset(HairEyeColor, tension = 0.5)
##' 
##' tmp.dir <- tempdir()
##' widget.tmp.file <- paste0(tmp.dir, "/tmp.html")
##' widget.swi.file <- "output.html"
##' saveWidget(widget, file = widget.tmp.file, selfcontained = F, libdir = "js")
##' swi_widget(widget.tmp.file, widget.swi.file, output=tmp.dir)
##' 
##' viewer <- getOption("viewer")
##' viewer(widget.tmp.file)
##' viewer(paste0(tmp.dir, "/", widget.swi.file))
##' }
swi_widget <- function(
  widget.html,
  output.html = "parset_swi.html",
  output = ".",
  source = "source:",
  author = " swissinfo.ch",
  h2 = "title",
  descr = "descriptive text",
  h3 = "subtitle",
  footer = "")  {

  output.html <- file.path(output, output.html)
  #change the output file name if already exists
  if(file.exists(output.html)) {
    file.rename(output.html, gsub("\\.html$", "_init\\.html", output.html))
    warning("\n Existing output html renamed to:", gsub("\\.html$", "_init\\.html", output.html), "\n")
  }
  ## Load widget.html code and fînd the tag "htmlwidget_container" (istart) until the last <script> (iend)
  html.code <- grab_widgetHTML(widget.html)
  
  # append javacript code to output.html
  sink(output.html, append = T)

  # write all the code before the widget
  cat( html.code[['html']][1:(html.code[['istart']]-1)])

  if(h2 != "") {
    cat("<h2>",h2,"</h2>\n")
  }
  if(descr != "") {
    cat('<div class="descr">', descr, "</div>\n")
  }
  if(h3 != "") {
    cat("<h3>",h3,"</h3>\n")
  }
  # get and sink the div with the widget
  cat(html.code[['html']][html.code[['istart']]:html.code[['iend']]])

  # add the footer: source & author
  cat('\n\n<!-- Source -->\n<div id="cite">', source, "|", author, "</div>")

  if(footer != "") {
    cat('\n<!-- Footer -->\n<div id="footer">', footer, "</div>")
  }

  cat("\n</body>\n</html>")
  sink()
  
  swi_libWidget_overwrite(file.path(output, "js"))
}

##' @rdname swi_HTMLwidget
##' @export
grab_widgetHTML <- function(widget.html) {
  # check input html and library
  if(!file.exists(widget.html)) { stop("\n", widget.html, " does not exist!")}
  
  ## Load widget.html and get everything between the tag <div rChart highcharts> until the last <script>
  x <- readLines(widget.html)
  istart <- grep("htmlwidget_container", x)
  iend <- max(grep("</script>", x))
  list(html = x, istart = istart, iend = iend)
}

##' @rdname swi_HTMLwidget
##' @param dir a path to a folder where all the js, css, ... assets on which the htmlwidget depends on
##' @export
swi_libWidget_overwrite <- function(dirPath = ".") {

  ## For parsetR: overwrite the javacsript d3.parset.css file if in the javacript folder
  original <- list.files(dirPath, "d3.parsets.css", full.names = T, recursive = T)
  if(!identical(original, character(0))) {
    file.copy( from = list.files(system.file("extdata", package="swiRcharts"),
      "d3.parsets.css", full.names = T), to = original, overwrite = T)
    
    # copy the RTL files, the .js and .css files !
    file.copy( from = list.files(system.file("extdata", package="swiRcharts"),
       "d3.parsets_rtl.css", full.names = T), to = dirname(original), overwrite = T)
    file.copy( from = list.files(system.file("extdata", package="swiRcharts"),
      "d3.parsets_rtl.min.js", full.names = T), to = dirname(original), overwrite = T)
  }
  
  ## For streamgraphR: overwrite the javascript code and its css file
  # modified streamgraph.js where the select dropdown has no text by default!
  original <- list.files(dirPath, "streamgraph.js", full.names = T, recursive = T)
  if(!identical(original, character(0))) {
    file.copy( from = list.files(system.file("extdata", package="swiRcharts"),
      "streamgraph.js", full.names = T), to = original, overwrite = T)
    
    # copy the RTL variant
    file.copy( from = list.files(system.file("extdata", package="swiRcharts"),
    "streamgraph_rtl.js", full.names = T), to = dirname(original), overwrite = T)
  }
  original <- list.files(dirPath, "streamgraph.css", full.names = T, recursive = T)
  if(!identical(original, character(0))) {
    file.copy( from = list.files(system.file("extdata", package="swiRcharts"),
      "streamgraph.css", full.names = T), to = original, overwrite = T)
    
    # copy the RTL variant
    file.copy( from = list.files(system.file("extdata", package="swiRcharts"),
      "streamgraph_rtl.css", full.names = T), to = dirname(original), overwrite = T)
  }
  
  ## For sunburstR: overwrite its CSS "sequences.css" and sunburst.js in the javacript folder
  original <- list.files(dirPath, "sequences.css", full.names = T, recursive = T)
  if(!identical(original, character(0))) {
    file.copy( from = list.files(system.file("extdata", package="swiRcharts"),
      'sequences.css', full.names = T), to = original, overwrite = T)
    
    # file.copy( from = list.files(system.file("extdata", package="swiRcharts"),
    #   "sunburst.js", full.names = T), to = dirname(original), overwrite = T)
  }
  
  ## For chord diagram: overwrite its CSS "chorddiag.css" and its js "chorddiag.js"
  ## (to not set the font family via d3.js and to not have "total" in the arc tooltip) in the javacript folder
  original <- list.files(dirPath, "chorddiag.css", full.names = T, recursive = T)
  if(!identical(original, character(0))) {
    file.copy( from = list.files(system.file("extdata", package="swiRcharts"),
      'chorddiag.css', full.names = T), to = original, overwrite = T)
    file.copy( from = list.files(system.file("extdata", package="swiRcharts"),
      'chorddiag_rtl.css', full.names = T), to = dirname(original), overwrite = T)
    file.copy( from = list.files(system.file("extdata", package="swiRcharts"),
       "chorddiag.js", full.names = T), to = dirname(original), overwrite = T)
  }
  
}
