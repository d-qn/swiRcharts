##' Helper function to create html link
##'
##' @param url, a character string the target URL
##' @param text, a character string the text displayed as HTML link
##' @param target, a character valid attribute for target 
##' @export
##' @seealso http://www.w3schools.com/tags/att_a_target.asp
##' @examples
##' \dontrun{
##' htmlLink("http://www.swissinfo.ch/eng", "swi")
##' }
htmlLink <- function(url, text, target = "_blank") {
  paste0('<a href="', url, '" target="', target, '">', text, '</a>')
}