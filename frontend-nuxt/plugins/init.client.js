import { useAuthStore } from '~/store/auth'
import { useCartStore } from '~/store/cart'
import { useOrdersStore } from '~/store/orders'

export default defineNuxtPlugin(nuxtApp => {
  const authStore = useAuthStore()
  const cartStore = useCartStore()
  const ordersStore = useOrdersStore()
  
  // Initialize auth state from localStorage
  authStore.initializeAuth()
  
  // Initialize cart state from localStorage
  cartStore.initializeCart()
  
  // Orders are initialized in orders.client.js plugin
  // This prevents duplicate initialization which can cause hydration mismatches
})
