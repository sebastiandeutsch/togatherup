const defaultTheme = require("tailwindcss/defaultTheme");

module.exports = {
  content: [
    "./app/helpers/**/*.rb",
    "./app/assets/stylesheets/**/*.css",
    "./app/views/**/*.{erb,html,html.erb}",
    "./app/javascript/**/*.js"
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ["Inter", ...defaultTheme.fontFamily.sans]
      },
      colors: {
        midnight: {
          950: "#020617"
        }
      },
      boxShadow: {
        glow: "0 0 60px -15px rgba(168, 85, 247, 0.45)",
        cyan: "0 0 45px -12px rgba(45, 212, 191, 0.4)",
        slate: "0 20px 60px rgba(2, 6, 23, 0.55)"
      },
      borderRadius: {
        xl: "1.5rem",
        "2xl": "2rem",
        "3xl": "2.5rem"
      }
    }
  },
  plugins: []
};
