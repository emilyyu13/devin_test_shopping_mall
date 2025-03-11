// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  devtools: { enabled: true },
  css: ['~/assets/css/main.css'],
  postcss: {
    plugins: {
      '@tailwindcss/postcss7-compat': {},
      autoprefixer: {},
    },
  },
  modules: [
    '@pinia/nuxt',
  ],
  compatibilityDate: '2025-03-11',
  runtimeConfig: {
    public: {
      apiBase: process.env.API_BASE_URL || 'https://example-api.com/api/v1' // Configurable API URL
    }
  }
})
