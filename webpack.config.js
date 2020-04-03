module.exports = {
  entry: {
    application: __dirname + "/source/javascripts/packs/application.js",
  },
  output: {
    path: __dirname + "/tmp/dist",
    filename: "javascripts/packs/[name].js",
  }
};
