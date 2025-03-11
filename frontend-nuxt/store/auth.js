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
        // For demo purposes, simulate successful login without API
        // In a real app, this would call the API
        // const config = useRuntimeConfig()
        // const response = await $fetch(`${config.public.apiBase}/login`, {
        //   method: 'POST',
        //   body: { email, password },
        // })
        
        // Mock response for demo
        const mockResponse = {
          token: 'mock-jwt-token-123',
          user_id: 1,
          name: 'Demo User',
          role: 'customer'
        }
        
        this.token = mockResponse.token
        this.user = {
          id: mockResponse.user_id,
          name: mockResponse.name,
          role: mockResponse.role
        }
        
        // Store in localStorage for persistence
        if (process.client) {
          localStorage.setItem('token', mockResponse.token)
          localStorage.setItem('user', JSON.stringify({
            id: mockResponse.user_id,
            name: mockResponse.name,
            role: mockResponse.role
          }))
        }
        
        return mockResponse
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
