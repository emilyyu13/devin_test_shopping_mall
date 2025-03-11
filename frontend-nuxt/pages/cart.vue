<template>
  <div>
    <h1 class="text-3xl font-bold mb-6">Shopping Cart</h1>
    
    <div v-if="cartItems.length === 0" class="text-center py-8 bg-gray-50 rounded-lg">
      <p class="text-gray-500 mb-4">Your cart is empty.</p>
      <NuxtLink to="/" class="text-blue-600 hover:text-blue-800">Continue Shopping</NuxtLink>
    </div>
    
    <div v-else>
      <div class="bg-white rounded-lg shadow-md overflow-hidden mb-6">
        <table class="w-full">
          <thead class="bg-gray-100">
            <tr>
              <th class="py-3 px-4 text-left">Product</th>
              <th class="py-3 px-4 text-center">Quantity</th>
              <th class="py-3 px-4 text-right">Price</th>
              <th class="py-3 px-4 text-right">Subtotal</th>
              <th class="py-3 px-4 text-center">Actions</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="item in cartItems" :key="item.id" class="border-t border-gray-200">
              <td class="py-3 px-4">{{ item.name }}</td>
              <td class="py-3 px-4 text-center">
                <div class="flex items-center justify-center">
                  <button 
                    @click="decrementQuantity(item.id)"
                    class="bg-gray-200 text-gray-700 px-2 py-1 rounded-l hover:bg-gray-300"
                  >
                    -
                  </button>
                  <span class="px-3">{{ item.quantity }}</span>
                  <button 
                    @click="incrementQuantity(item.id)"
                    class="bg-gray-200 text-gray-700 px-2 py-1 rounded-r hover:bg-gray-300"
                  >
                    +
                  </button>
                </div>
              </td>
              <td class="py-3 px-4 text-right">${{ parseFloat(item.price).toFixed(2) }}</td>
              <td class="py-3 px-4 text-right">${{ (item.price * item.quantity).toFixed(2) }}</td>
              <td class="py-3 px-4 text-center">
                <button 
                  @click="removeFromCart(item.id)"
                  class="text-red-600 hover:text-red-800"
                >
                  Remove
                </button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
      
      <div class="flex justify-between items-center mb-6">
        <NuxtLink to="/" class="text-blue-600 hover:text-blue-800">Continue Shopping</NuxtLink>
        <div class="text-right">
          <p class="text-lg mb-2">Total: <span class="font-bold">${{ cartTotal.toFixed(2) }}</span></p>
          <NuxtLink 
            to="/checkout"
            class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700 inline-block"
          >
            Proceed to Checkout
          </NuxtLink>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue'
import { useCartStore } from '~/store/cart'

const cartStore = useCartStore()

const cartItems = computed(() => cartStore.cart)
const cartTotal = computed(() => cartStore.cartTotal)

const incrementQuantity = (id) => {
  const item = cartItems.value.find(item => item.id === id)
  if (item) {
    cartStore.updateQuantity(id, item.quantity + 1)
  }
}

const decrementQuantity = (id) => {
  const item = cartItems.value.find(item => item.id === id)
  if (item && item.quantity > 1) {
    cartStore.updateQuantity(id, item.quantity - 1)
  }
}

const removeFromCart = (id) => {
  cartStore.removeFromCart(id)
}
</script>
