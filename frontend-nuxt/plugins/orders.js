import { useOrdersStore } from '~/store/orders'

export default defineNuxtPlugin(nuxtApp => {
  const ordersStore = useOrdersStore()
  
  // Initialize orders state from localStorage if available
  if (process.client) {
    const savedOrders = localStorage.getItem('orders')
    if (savedOrders) {
      try {
        const parsedOrders = JSON.parse(savedOrders)
        ordersStore.orders = parsedOrders
      } catch (error) {
        console.error('Error parsing saved orders:', error)
      }
    }
  }
  
  // Watch for changes to orders and save to localStorage
  watch(() => ordersStore.orders, (newOrders) => {
    if (process.client) {
      localStorage.setItem('orders', JSON.stringify(newOrders))
    }
  }, { deep: true })
})
