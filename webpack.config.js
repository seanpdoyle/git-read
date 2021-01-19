module.exports = {
  entry: {
    site: __dirname + "/source/javascripts/site.js",
  },
  output: {
    path: __dirname + "/tmp/dist",
    filename: "javascripts/[name].js",
  },
  module: {
    rules: [
      {
        test: /\.css$/i,
        use: ["style-loader", "css-loader", "postcss-loader"],
      },
    ],
  }
}
