##' Highchart(er) SWI theme
##' 
##' Some helpers to get a SWI look for highcharter
##'
##' @import swiTheme 
##' @rdname swi_highcharter
##' @importFrom highcharter hc_theme
##' @export
##' @seealso http://jkunst.com/highcharter/themes.html#create-themes
##' @examples
##' \dontrun{
##' require(highcharter)
##' data(diamonds, mpg, package = "ggplot2")
##' hchart(mpg, "scatter", x = displ, y = hwy, group = class) %>% hc_add_theme(hc_theme_swi)
##' }

hc_theme_swi <- highcharter::hc_theme(
  colors = swiTheme::swi_rpal,
  chart = list(
   # backgroundColor = "#f2f2f2",
    style = list (
      fontFamily = 'Open Sans Condensed'
    )
  ),
  title = list(
    align = "left",
    x = 4, 
    style = list(
      color = '#1a1a1a',
      fontFamily = "Open Sans Condensed",
      fontSize = "1.6em",
      fontWeight = "bold"
    )
  ),
  subtitle = list(
    align = "left",
    x = 4, 
    style = list(
      color = '#262626',
      fontFamily = 'Open Sans Condensed',
      fontSize = "1.2em"
    )
  ),
  legend = list(
    itemStyle = list(
      fontFamily = 'Open Sans Condensed',
      fontSize = "1em",
      color = 'black',
      fontWeight = 300
    ),
    itemHoverStyle = list(
      color = 'gray'
    )   
  ),
  # copied from the FT theme hc_theme_ft()
  yAxis = list(
    gridLineColor = "#CEC6B9",
    lineColor =  "#CEC6B9",
    gridLineDashStyle = "Dot",
    labels = list(
      algn = "left",
      x = 0,
      y = -2,
      tickLength = 0,
      tickColor = "#CEC6B9",
      tickWidth = 1,
      style = list (
        fontSize = '1em',
        color = "#333333"
      )
    ),
    title = list(
      style = list (
        fontSize = '1.5em',
        color = "#333333"
      )
    )
  ),
  xAxis = list(
    lineColor =  "#CEC6B9",
    labels = list(
      style = list (
        fontSize = '1em',
        color = "#333333"
      )
    ),
    title = list(
      margin = 17,
      style = list (
        fontSize = '1.5em',
        color = "#333333"
      )
    )
  ),
  tooltip = list(
    borderRadius = 10,
    padding = 3,
    style = list (
      fontFamily = 'Open Sans Condensed',
      fontSize = "0.8em"
    )
  )
)


##' @rdname swi_highcharter
##' @export
##' @examples
##' style_swi_highcharter()

style_swi_highcharter <- function() {
  list.files(system.file("extdata", package="swiRcharts"), 'stylesHighcharter.html', full.names = T)
}