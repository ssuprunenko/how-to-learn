const defaultTheme = require('tailwindcss/defaultTheme')
const colors = require('tailwindcss/colors')

module.exports = {
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans]
      },
      colors: {
        'light-blue': colors.lightBlue
      },
      gridTemplateColumns: {
        'repeat-40': 'repeat(auto-fit, 10rem)',
        'repeat-48': 'repeat(auto-fit, 12rem)'
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
    require('tailwindcss-truncate-multiline')(),
    require('@tailwindcss/forms'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/aspect-ratio')
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
