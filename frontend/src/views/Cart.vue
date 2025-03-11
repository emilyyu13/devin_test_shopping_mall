<template>
  <div>
    <h1 class="text-3xl font-bold mb-6">Shopping Cart</h1>
    
    <div v-if="cart.length === 0" class="bg-white rounded-lg shadow p-6 text-center">
      <p class="text-gray-500 mb-4">Your cart is empty.</p>
      <router-link to="/" class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700">
        Continue Shopping
      </router-link>
    </div>
    
    <div v-else>
      <div class="bg-white rounded-lg shadow overflow-hidden mb-6">
        <table class="w-full">
          <thead class="bg-gray-100">
            <tr>
              <th class="py-3 px-4 text-left">Product</th>
              <th class="py-3 px-4 text-left">Price</th>
              <th class="py-3 px-4 text-left">Quantity</th>
              <th class="py-3 px-4 text-left">Subtotal</th>
              <th class="py-3 px-4 text-left">Actions</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="item in cart" :key="item.id" class="border-t border-gray-200">
              <td class="py-3 px-4">{{ item.name }}</td>
              <td class="py-3 px-4">${{ parseFloat(item.price).toFixed(2) }}</td>
              <td class="py-3 px-4">{{ item.quantity }}</td>
              <td class="py-3 px-4">${{ (parseFloat(item.price) * item.quantity).toFixed(2) }}</td>
              <td class="py-3 px-4">
                <button 
                  @click="removeItem(item.id)"
                  class="text-red-600 hover:text-red-800"
                >
                  Remove
                </button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
      
      <div class="flex justify-between items-start">
        <router-link to="/" class="bg-gray-200 text-gray-800 px-4 py-2 rounded hover:bg-gray-300">
          Continue Shopping
        </router-link>
        
        <div class="bg-white rounded-lg shadow p-4 w-64">
          <div class="flex justify-between mb-2">
            <span>Subtotal:</span>
            <span>${{ cartTotal.toFixed(2) }}</span>
          </div>
          <div class="border-t border-gray-200 my-2 pt-2">
            <div class="flex justify-between font-bold">
              <span>Total:</span>
              <span>${{ cartTotal.toFixed(2) }}</span>
            </div>
          </div>
          <router-link 
            to="/checkout" 
            class="block w-full bg-blue-600 text-white text-center px-4 py-2 rounded mt-4 hover:bg-blue-700"
          >
            Proceed to Checkout
          </router-link>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { computed } from 'vue'
import { useStore } from 'vuex'

export default {
  name: 'Cart',
  setup() {
    const store = useStore()
    
    const cart = computed(() => store.state.cart)
    const cartTotal = computed(() => store.getters.cartTotal)
    
    const removeItem = (id) => {
      store.commit('removeFromCart', id)
    }
    
    return {
      cart,
      cartTotal,
      removeItem
    }
  }
}
</script>
