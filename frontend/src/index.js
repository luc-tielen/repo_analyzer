'use strict';

// Require index.html so it gets copied to dist
require('./index.html');
require('./js/chart_helpers.js');

var API_URL = process.env.ELM_APP_API_URL;
var Elm = require('./elm/Main.elm');
var app = Elm.Main.fullscreen({ apiUrl: API_URL });
app.ports.drawChart.subscribe(drawChart);
