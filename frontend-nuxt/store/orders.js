import { defineStore } from 'pinia'

export const useOrdersStore = defineStore('orders', {
  state: () => ({
    orders: [],
    loading: false,
    error: null
  }),
  getters: {
    getOrderById: (state) => (id) => {
      return state.orders.find(order => order.id === id)
    }
  },
  actions: {
    async fetchOrders() {
      this.loading = true
      this.error = null
      
      try {
        const config = useRuntimeConfig()
        const response = await $fetch(`${config.public.apiBase}/orders`, {
          headers: {
            'Authorization': `Bearer ${localStorage.getItem('token')}`
          }
        })
        
        this.orders = response
        return response
      } catch (error) {
        this.error = 'Failed to fetch orders'
        console.error('Error fetching orders:', error)
        throw error
      } finally {
        this.loading = false
      }
    },
    
    async fetchOrderById(id) {
      this.loading = true
      this.error = null
      
      try {
        const config = useRuntimeConfig()
        const response = await $fetch(`${config.public.apiBase}/orders/${id}`, {
          headers: {
            'Authorization': `Bearer ${localStorage.getItem('token')}`
          }
        })
        
        // Update the order in the store if it exists
        const index = this.orders.findIndex(order => order.id === id)
        if (index !== -1) {
          this.orders[index] = response
        } else {
          this.orders.push(response)
        }
        
        return response
      } catch (error) {
        this.error = 'Failed to fetch order details'
        console.error('Error fetching order details:', error)
        throw error
      } finally {
        this.loading = false
      }
    },
    
    async createOrder(orderData) {
      this.loading = true
      this.error = null
      
      try {
        const config = useRuntimeConfig()
        const response = await $fetch(`${config.public.apiBase}/orders`, {
          method: 'POST',
          body: orderData,
          headers: {
            'Authorization': `Bearer ${localStorage.getItem('token')}`
          }
        })
        
        this.orders.push(response)
        return response
      } catch (error) {
        this.error = 'Failed to create order'
        console.error('Error creating order:', error)
        throw error
      } finally {
        this.loading = false
      }
    }
  }
})
