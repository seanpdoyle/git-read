const screens = ["DEFAULT", "sm", "md", "lg", "xl"]

module.exports = {
  theme: {
    extend: {
      typography: {
        ...screens.reduce((overrides, screen) => ({
          ...overrides,
          [screen]: {
            css: {
              pre: {
                color: null,
                backgroundColor: null,
                marginTop: null,
                marginBottom: null,
              }
            },
          },
        }), {}),
      },
    },
  },
  purge: [
    "./source/**/*.erb",
  ],
  plugins: [
    require("@tailwindcss/typography")
  ],
}
