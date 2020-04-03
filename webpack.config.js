module.exports = {
  entry: {
    application: __dirname + "/source/javascripts/site.js",
  },
  output: {
    path: __dirname + "/tmp/dist",
    filename: "javascripts/[name].js",
  }
};
