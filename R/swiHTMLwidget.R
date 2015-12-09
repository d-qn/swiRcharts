##' Helper functions for htmlwidget
##'
##' Helper functions to create a container for htmlwidget with javascript library files
##' @param widget.html,output.html character file path to the input widget html and the output reponsive html
##' @param output a path to a folder where the output html file and the js library folder will be saved
##' @param source,author,h2,descr,h3,footer characters
##' @export
##' @examples
##' \dontrun{
##' TO DO !!!!!!
##' }
swi_widget <- function(
  widget.html,
  output.html = "parset_swi.html", 
  output = ".",
  source = "source:",
  author = "Duc-Quang Nguyen | swissinfo.ch", 
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

  # check input html and library
  if(!file.exists(widget.html)) { stop("\n", widget.html, " does not exist!")}
    
  ## Load widget.html and get everything between the tag <div rChart highcharts> until the last <script>
  x <- readLines(widget.html)
  istart <- grep("htmlwidget_container", x)
  iend <- max(grep("</script>", x))

  # append javacript code to output.html
  sink(output.html, append = T)

  # write all the code before the widget
  cat(x[1:(istart-1)])

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
  cat(x[istart:iend])

  # add the footer: source & author
  cat('\n\n<!-- Source -->\n<div id="cite">', source, "|", author, "</div>")
  
  if(footer != "") {
    cat('\n<!-- Footer -->\n<div id="footer">', footer, "</div>")
  }
  
  cat("\n\n\n</body>\n</html>")

  sink()

  ## For parsetR: overwrite the javacsript d3.parset.css file if in the javacript folder
  original <- list.files("js", "d3.parsets.css", full.names = T, recursive = T)
  if(!identical(original, character(0))) {
    file.copy( from = list.files(system.file("extdata", package="swiRcharts"),
      "d3.parsets.css", full.names = T),
      to = original, overwrite = T)
  }
  ## For streamgraphR: overwrite the javascript code and its css file
  # modified streamgraph.js where the select dropdown has no text by default!
  original <- list.files("js", "streamgraph.js", full.names = T, recursive = T)
  if(!identical(original, character(0))) {
    file.copy( from = list.files(system.file("extdata", package="swiRcharts"),
    "streamgraph.js", full.names = T),
    to = original, overwrite = T)
  }
  original <- list.files("js", "streamgraph.css", full.names = T, recursive = T)
  if(!identical(original, character(0))) {
    file.copy( from = list.files(system.file("extdata", package="swiRcharts"),
    "streamgraph.css", full.names = T),
    to = original, overwrite = T)
  }
}
