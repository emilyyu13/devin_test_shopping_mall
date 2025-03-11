import { defineStore } from 'pinia'

export const useCartStore = defineStore('cart', {
  state: () => ({
    cart: [],
  }),
  getters: {
    cartTotal: (state) => state.cart.reduce((total, item) => total + (item.price * item.quantity), 0),
    cartItemCount: (state) => state.cart.reduce((count, item) => count + item.quantity, 0),
  },
  actions: {
    addToCart(product, quantity = 1) {
      const existingItem = this.cart.find(item => item.id === product.id)
      
      if (existingItem) {
        existingItem.quantity += quantity
      } else {
        this.cart.push({
          id: product.id,
          name: product.name,
          price: product.price,
          quantity
        })
      }
      
      // Store in localStorage for persistence
      if (process.client) {
        localStorage.setItem('cart', JSON.stringify(this.cart))
      }
    },
    
    removeFromCart(id) {
      this.cart = this.cart.filter(item => item.id !== id)
      
      // Update localStorage
      if (process.client) {
        localStorage.setItem('cart', JSON.stringify(this.cart))
      }
    },
    
    updateQuantity(id, quantity) {
      const item = this.cart.find(item => item.id === id)
      if (item) {
        item.quantity = quantity
        
        // Update localStorage
        if (process.client) {
          localStorage.setItem('cart', JSON.stringify(this.cart))
        }
      }
    },
    
    clearCart() {
      this.cart = []
      
      // Update localStorage
      if (process.client) {
        localStorage.setItem('cart', JSON.stringify(this.cart))
      }
    },
    
    // Initialize cart from localStorage on client-side
    initializeCart() {
      if (process.client) {
        const cart = JSON.parse(localStorage.getItem('cart'))
        
        if (cart) {
          this.cart = cart
        }
      }
    }
  }
})
