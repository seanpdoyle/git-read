module.exports = {
  entry: {
    site: __dirname + "/source/javascripts/site.js",
  },
  output: {
    path: __dirname + "/tmp/dist",
    filename: "javascripts/[name].js",
  }
};
