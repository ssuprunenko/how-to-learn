const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans]
      }
    },
    truncate: {
      lines: {
        2: '2',
        3: '3'
      }
    }
  },
  plugins: [
    require('@tailwindcss/ui'),
    require('tailwindcss-truncate-multiline')()
  ],
  future: {
    removeDeprecatedGapUtilities: true,
    purgeLayersByDefault: true
  },
  purge: [
    '../lib/app_web/templates/**/*.html.eex',
    '../lib/app_web/templates/**/*.html.leex',
    '../lib/app_web/views/**/*.ex',
    '../lib/app_web/live/**/*.ex'
  ]
}
