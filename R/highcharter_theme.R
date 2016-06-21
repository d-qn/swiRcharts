##' Highchart(er) SWI theme
##'
##' @import swiTheme 
##' @importFrom highcharter hc_theme
##' @export
##' @seealso http://jkunst.com/highcharter/themes.html#create-themes
##' @examples
##' \dontrun{
##' require(highcharter)
##' hc_demo() %>% hc_add_theme(hc_theme_swi)
##' }

hc_theme_swi <- highcharter::hc_theme(
  colors = swiTheme::swi_rpal,
  chart = list(
    backgroundColor = "#FBF8F3",
    style = list (
      fontFamily = 'Open Sans Condensed'
    )
  ),
  title = list(
    align = "left",
    x = 50, 
    style = list(
      color = '#1a1a1a',
      fontFamily = "Open Sans Condensed",
      fontSize = "2em"
    )
  ),
  subtitle = list(
    align = "left",
    x = 50, 
    style = list(
      color = '#666666',
      fontFamily = 'Open Sans Condensed',
      fontSize = "1.2em",
      fontWeight = "italic"
    )
  ),
  legend = list(
    itemStyle = list(
      fontFamily = 'Open Sans Condensed',
      color = 'black'
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
      tickWidth = 1
    ),
    title = list(
      style = list (
        fontSize = '1.4em'
      )
    )
  ),
  xAxis = list(
    lineColor =  "#CEC6B9",
    title = list(
      margin = 17,
      style = list (
        fontSize = '1.4em'
      )
    )
  ),
  tooltip = list(
    style = list (
      fontFamily = 'Open Sans',
      fontSize = "0.9em"
    )
  )
)