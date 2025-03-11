import { defineStore } from 'pinia'

export const useProductStore = defineStore('products', {
  state: () => ({
    products: [],
    loading: false,
    error: null,
  }),
  getters: {
    getProductById: (state) => (id) => {
      return state.products.find(product => product.id === id)
    }
  },
  actions: {
    async fetchProducts() {
      this.loading = true
      this.error = null
      
      try {
        const config = useRuntimeConfig()
        const products = await $fetch(`${config.public.apiBase}/products`)
        this.products = products
        return products
      } catch (error) {
        this.error = error.message || 'Failed to fetch products'
        throw error
      } finally {
        this.loading = false
      }
    },
    
    async fetchProductById(id) {
      this.loading = true
      this.error = null
      
      try {
        const config = useRuntimeConfig()
        const product = await $fetch(`${config.public.apiBase}/products/${id}`)
        
        // Update the product in the products array if it exists
        const index = this.products.findIndex(p => p.id === id)
        if (index !== -1) {
          this.products[index] = product
        } else {
          this.products.push(product)
        }
        
        return product
      } catch (error) {
        this.error = error.message || 'Failed to fetch product'
        throw error
      } finally {
        this.loading = false
      }
    }
  }
})
