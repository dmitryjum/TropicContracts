const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}'
  ],
    theme: {
    extend: {
      colors: {
        purple: {
          50: "#f8f8ff",
          100: "#f1f0ff",
          200: "#b1acfc",
          300: "#9D98F0",
          500: "#6b63e8",
          600: "#564fba",
          700: "#403b8b",
          800: "#2b285d",
        },
        gray: {
          50: "#f7fafc",
          100: "#edf2f7",
          200: "#e2e8f0",
          300: "#cbd5e0",
          400: "#a0aec0",
          500: "#6A778A",
          600: "#4a5568",
          700: "#2d3748",
          800: "#1a202c",
        },
        red: {
          100: "#fff5f5",
          150: "#ffe1e1",
          200: "#feb2b2",
          500: "#d82c0d",
          600: "#c53030",
          700: "#9b2c2c",
          800: "#822727",
        },
      },
      fontFamily: {
        sans: ["Inter var", ...defaultTheme.fontFamily.sans],
      },
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/container-queries'),
  ]
}
