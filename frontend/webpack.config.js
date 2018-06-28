var webpack = require("webpack");
var path = require('path');
var Clean = require('clean-webpack-plugin');
var UglifyJsPlugin = require('uglifyjs-webpack-plugin');
var DotEnv = require('dotenv-webpack');

var env = process.env.NODE_ENV || "development";
var isProd = env === "production";

var plugins = [
  new Clean(["dist"], { verbose: false, exclude: [".keep"] }),
  new DotEnv(),
];
if (isProd) {
  plugins.push(
    new webpack.LoaderOptionsPlugin({ minimize: true, debug: false }),
    new UglifyJsPlugin({
      output: {
        comments: false
      },
      compress: {
        unused: true,
        warnings: false,
        comparisons: true,
        conditionals: true,
        negate_iife: false,
        dead_code: true,
        if_return: true,
        join_vars: true,
        evaluate: true,
        drop_debugger: true,
        drop_console: false
      },
      sourceMap: true
    })
  );
}
else {
  plugins.push(
    // prevent emitting assets with errors
    new webpack.NoEmitOnErrorsPlugin()
  );
}


module.exports = {
  mode: env,
  plugins: plugins,

  entry: {
    app: [
      './src/index.js'
    ]
  },

  output: {
    path: path.resolve(__dirname + '/dist'),
    filename: '[name].js',
  },

  module: {
    rules: [
      {
        test: /\.(css|scss)$/,
        use: [
          'style-loader',
          'css-loader',
        ]
      },
      {
        test:    /\.html$/,
        exclude: /node_modules/,
        loader:  'file-loader?name=[name].[ext]',
      },
      {
        test:    /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        loader:  'elm-webpack-loader?verbose=true&warn=true',
      },
      {
        test: /\.woff(2)?(\?v=[0-9]\.[0-9]\.[0-9])?$/,
        loader: 'url-loader?limit=10000&mimetype=application/font-woff',
      },
      {
        test: /.(ttf|eot|svg)(\?v=[0-9]\.[0-9]\.[0-9])?$/,
        loader: 'file-loader',
      },
    ],

    noParse: /\.elm$/,
  },

  devServer: {
    inline: true,
    stats: { colors: true },
  }
}
