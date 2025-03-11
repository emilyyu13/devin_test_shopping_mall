import { useAuthStore } from '~/store/auth'
import { useCartStore } from '~/store/cart'

export default defineNuxtPlugin(nuxtApp => {
  const authStore = useAuthStore()
  const cartStore = useCartStore()
  
  // Initialize auth state from localStorage
  authStore.initializeAuth()
  
  // Initialize cart state from localStorage
  cartStore.initializeCart()
})
