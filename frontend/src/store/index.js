import { createStore } from 'vuex'
import axios from 'axios'

// Configure axios
axios.defaults.baseURL = 'http://localhost:3001/api/v1'

export default createStore({
  state: {
    user: JSON.parse(localStorage.getItem('user')) || null,
    token: localStorage.getItem('token') || null,
    cart: JSON.parse(localStorage.getItem('cart')) || [],
    products: []
  },
  mutations: {
    setUser(state, user) {
      state.user = user
    },
    setToken(state, token) {
      state.token = token
    },
    clearAuth(state) {
      state.user = null
      state.token = null
    },
    setProducts(state, products) {
      state.products = products
    },
    addToCart(state, { product, quantity }) {
      const existingItem = state.cart.find(item => item.id === product.id)
      
      if (existingItem) {
        existingItem.quantity += quantity
      } else {
        state.cart.push({
          id: product.id,
          name: product.name,
          price: product.price,
          quantity
        })
      }
      localStorage.setItem('cart', JSON.stringify(state.cart))
    },
    removeFromCart(state, id) {
      state.cart = state.cart.filter(item => item.id !== id)
      localStorage.setItem('cart', JSON.stringify(state.cart))
    },
    clearCart(state) {
      state.cart = []
      localStorage.setItem('cart', JSON.stringify(state.cart))
    }
  },
  actions: {
    async login({ commit }, { email, password }) {
      try {
        const response = await axios.post('/login', { email, password })
        commit('setToken', response.data.token)
        commit('setUser', {
          id: response.data.user_id,
          name: response.data.name,
          role: response.data.role
        })
        localStorage.setItem('token', response.data.token)
        localStorage.setItem('user', JSON.stringify({
          id: response.data.user_id,
          name: response.data.name,
          role: response.data.role
        }))
        return response
      } catch (error) {
        throw error
      }
    },
    
    logout({ commit }) {
      commit('clearAuth')
      localStorage.removeItem('token')
      localStorage.removeItem('user')
    },
    
    async fetchProducts({ commit }) {
      try {
        const response = await axios.get('/products')
        commit('setProducts', response.data)
        return response.data
      } catch (error) {
        throw error
      }
    }
  },
  getters: {
    isAuthenticated(state) {
      return !!state.token
    },
    cartTotal(state) {
      return state.cart.reduce((total, item) => total + (item.price * item.quantity), 0)
    },
    cartItemCount(state) {
      return state.cart.reduce((count, item) => count + item.quantity, 0)
    }
  }
})
