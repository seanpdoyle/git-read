module.exports = {
  entry: {
    application: __dirname + "/source/javascripts/packs/application.js",
  },
  output: {
    path: __dirname + "/tmp/dist",
    filename: "javascripts/packs/[name].js",
  },
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: {
          loader: "babel-loader"
        },
      },
    ],
  },
};
