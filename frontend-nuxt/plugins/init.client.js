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
  
  // Initialize orders from localStorage
  if (process.client) {
    const savedOrders = localStorage.getItem('orders')
    if (savedOrders) {
      try {
        const parsedOrders = JSON.parse(savedOrders)
        console.log('Initializing orders from localStorage:', parsedOrders)
        ordersStore.orders = parsedOrders
      } catch (error) {
        console.error('Error parsing saved orders:', error)
      }
    }
  }
})
