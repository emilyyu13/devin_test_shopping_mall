import { defineStore } from 'pinia'

export const useAuthStore = defineStore('auth', {
  state: () => ({
    user: null,
    token: null,
  }),
  getters: {
    isAuthenticated: (state) => !!state.token,
  },
  actions: {
    async login(email, password) {
      try {
        const config = useRuntimeConfig()
        const response = await $fetch(`${config.public.apiBase}/login`, {
          method: 'POST',
          body: { email, password },
        })
        
        this.token = response.token
        this.user = {
          id: response.user_id,
          name: response.name,
          role: response.role
        }
        
        // Store in localStorage for persistence
        if (process.client) {
          localStorage.setItem('token', response.token)
          localStorage.setItem('user', JSON.stringify({
            id: response.user_id,
            name: response.name,
            role: response.role
          }))
        }
        
        return response
      } catch (error) {
        throw error
      }
    },
    
    logout() {
      this.user = null
      this.token = null
      
      // Remove from localStorage
      if (process.client) {
        localStorage.removeItem('token')
        localStorage.removeItem('user')
      }
    },
    
    // Initialize state from localStorage on client-side
    initializeAuth() {
      if (process.client) {
        const token = localStorage.getItem('token')
        const user = JSON.parse(localStorage.getItem('user'))
        
        if (token && user) {
          this.token = token
          this.user = user
        }
      }
    }
  }
})
