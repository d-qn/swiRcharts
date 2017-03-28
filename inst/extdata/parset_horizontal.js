// ------------- Was modified to accomodate a horizontal view  !!!! ---
// Rotate the whole chart and inversed height and width settings
// ----------------------------------------------------------------------------------------
// ---> should replace parset-binding-0.0.1/parset.js
HTMLWidgets.widget({
  name: 'parset',
  type: 'output',
  initialize: function(el, width, height) {
    return {}
  },

  renderValue: function(el, x, instance) {

    // size based on container
    var width = el.getBoundingClientRect().height;
    var height = el.getBoundingClientRect().width;

    // empty container in case of dynamic/Shiny situation
    el.innerHTML = "";
    var parset = d3.parsets()
                  .width(width-18)
                  .height(height-35);

    // set options for parset with x.options from R arguments
    Object.keys(x.options).forEach(
      function(ky){
        if(parset[ky]){
          parset[ky](x.options[ky]);
        }
      }
    )

    // convert data to array of objects/rows
    var data = HTMLWidgets.dataframeToD3(x.data);

    var vis = d3.select(el).append("svg")
                  .attr("width", height)
                  .attr("height", width)
                  // Following 2 lines to make horizontal parset https://www.jasondavies.com/parallel-sets/rotate.html
                  .append("g")
                  .attr("transform", "translate(-30,0)translate(0," + width + ")rotate(-90)");

    vis.datum(data).call(parset);

    vis.selectAll(".category text")
          .attr("dx", 1)
          .attr("transform", "rotate(90)");

    vis.selectAll(".category-background")
          .selectAll("text")
          .attr("dx", -100);

    vis.selectAll("text.dimension")
          .attr("y", -(width-25))
          .attr("transform", "rotate(90)");

    instance.parset = parset;
  },

  resize: function(el, width, height, instance) {

  }

});
