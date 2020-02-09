const path = require('path')

module.exports = {
  entry: "javascripts/main.js",
  mode: "development",
  output: {
    path: path.resolve(__dirname, "source/javascripts")
  },
}
