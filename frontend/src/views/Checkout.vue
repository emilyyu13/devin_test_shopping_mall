<template>
  <div>
    <h1 class="text-3xl font-bold mb-6">Checkout</h1>
    
    <div v-if="cart.length === 0" class="bg-white rounded-lg shadow p-6 text-center">
      <p class="text-gray-500 mb-4">Your cart is empty. Please add items before checkout.</p>
      <router-link to="/" class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700">
        Continue Shopping
      </router-link>
    </div>
    
    <div v-else class="grid grid-cols-1 lg:grid-cols-3 gap-6">
      <div class="lg:col-span-2">
        <div class="bg-white rounded-lg shadow p-6 mb-6">
          <h2 class="text-xl font-semibold mb-4">Shipping Information</h2>
          
          <form @submit.prevent="submitOrder">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
              <div>
                <label for="firstName" class="block text-sm font-medium text-gray-700 mb-1">First Name</label>
                <input 
                  type="text" 
                  id="firstName" 
                  v-model="shippingInfo.firstName" 
                  required
                  class="w-full px-3 py-2 border border-gray-300 rounded-md"
                />
              </div>
              
              <div>
                <label for="lastName" class="block text-sm font-medium text-gray-700 mb-1">Last Name</label>
                <input 
                  type="text" 
                  id="lastName" 
                  v-model="shippingInfo.lastName" 
                  required
                  class="w-full px-3 py-2 border border-gray-300 rounded-md"
                />
              </div>
            </div>
            
            <div class="mb-4">
              <label for="address" class="block text-sm font-medium text-gray-700 mb-1">Address</label>
              <input 
                type="text" 
                id="address" 
                v-model="shippingInfo.address" 
                required
                class="w-full px-3 py-2 border border-gray-300 rounded-md"
              />
            </div>
            
            <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-4">
              <div>
                <label for="city" class="block text-sm font-medium text-gray-700 mb-1">City</label>
                <input 
                  type="text" 
                  id="city" 
                  v-model="shippingInfo.city" 
                  required
                  class="w-full px-3 py-2 border border-gray-300 rounded-md"
                />
              </div>
              
              <div>
                <label for="state" class="block text-sm font-medium text-gray-700 mb-1">State</label>
                <input 
                  type="text" 
                  id="state" 
                  v-model="shippingInfo.state" 
                  required
                  class="w-full px-3 py-2 border border-gray-300 rounded-md"
                />
              </div>
              
              <div>
                <label for="zipCode" class="block text-sm font-medium text-gray-700 mb-1">Zip Code</label>
                <input 
                  type="text" 
                  id="zipCode" 
                  v-model="shippingInfo.zipCode" 
                  required
                  class="w-full px-3 py-2 border border-gray-300 rounded-md"
                />
              </div>
            </div>
            
            <h2 class="text-xl font-semibold mb-4">Payment Information</h2>
            
            <div class="mb-4">
              <label for="paymentMethod" class="block text-sm font-medium text-gray-700 mb-1">Payment Method</label>
              <select 
                id="paymentMethod" 
                v-model="paymentInfo.method" 
                required
                class="w-full px-3 py-2 border border-gray-300 rounded-md"
              >
                <option value="">Select Payment Method</option>
                <option value="credit_card">Credit Card</option>
                <option value="paypal">PayPal</option>
                <option value="bank_transfer">Bank Transfer</option>
              </select>
            </div>
            
            <div v-if="paymentInfo.method === 'credit_card'" class="mb-6">
              <div class="mb-4">
                <label for="cardNumber" class="block text-sm font-medium text-gray-700 mb-1">Card Number</label>
                <input 
                  type="text" 
                  id="cardNumber" 
                  v-model="paymentInfo.cardNumber" 
                  placeholder="**** **** **** ****"
                  required
                  class="w-full px-3 py-2 border border-gray-300 rounded-md"
                />
              </div>
              
              <div class="grid grid-cols-2 gap-4">
                <div>
                  <label for="expiryDate" class="block text-sm font-medium text-gray-700 mb-1">Expiry Date</label>
                  <input 
                    type="text" 
                    id="expiryDate" 
                    v-model="paymentInfo.expiryDate" 
                    placeholder="MM/YY"
                    required
                    class="w-full px-3 py-2 border border-gray-300 rounded-md"
                  />
                </div>
                
                <div>
                  <label for="cvv" class="block text-sm font-medium text-gray-700 mb-1">CVV</label>
                  <input 
                    type="text" 
                    id="cvv" 
                    v-model="paymentInfo.cvv" 
                    placeholder="123"
                    required
                    class="w-full px-3 py-2 border border-gray-300 rounded-md"
                  />
                </div>
              </div>
            </div>
            
            <button 
              type="submit"
              class="w-full bg-blue-600 text-white py-2 px-4 rounded-md hover:bg-blue-700"
              :disabled="processing"
            >
              {{ processing ? 'Processing...' : 'Place Order' }}
            </button>
          </form>
        </div>
      </div>
      
      <div class="lg:col-span-1">
        <div class="bg-white rounded-lg shadow p-6 sticky top-6">
          <h2 class="text-xl font-semibold mb-4">Order Summary</h2>
          
          <div class="mb-4">
            <div v-for="item in cart" :key="item.id" class="flex justify-between py-2 border-b border-gray-200">
              <div>
                <span class="font-medium">{{ item.name }}</span>
                <span class="block text-sm text-gray-500">Qty: {{ item.quantity }}</span>
              </div>
              <span>${{ (parseFloat(item.price) * item.quantity).toFixed(2) }}</span>
            </div>
          </div>
          
          <div class="py-2 border-b border-gray-200">
            <div class="flex justify-between">
              <span>Subtotal</span>
              <span>${{ cartTotal.toFixed(2) }}</span>
            </div>
          </div>
          
          <div class="py-2 border-b border-gray-200">
            <div class="flex justify-between">
              <span>Shipping</span>
              <span>Free</span>
            </div>
          </div>
          
          <div class="py-2 mt-2">
            <div class="flex justify-between font-bold">
              <span>Total</span>
              <span>${{ cartTotal.toFixed(2) }}</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { ref, computed } from 'vue'
import { useStore } from 'vuex'
import { useRouter } from 'vue-router'

export default {
  name: 'Checkout',
  setup() {
    const store = useStore()
    const router = useRouter()
    
    const cart = computed(() => store.state.cart)
    const cartTotal = computed(() => store.getters.cartTotal)
    
    const shippingInfo = ref({
      firstName: '',
      lastName: '',
      address: '',
      city: '',
      state: '',
      zipCode: '',
    })
    
    const paymentInfo = ref({
      method: '',
      cardNumber: '',
      expiryDate: '',
      cvv: ''
    })
    
    const processing = ref(false)
    
    const submitOrder = async () => {
      processing.value = true
      
      try {
        // In a real app, this would create an order and process payment
        // For demo purposes, just clear the cart and redirect
        setTimeout(() => {
          store.commit('clearCart')
          alert('Order placed successfully!')
          router.push('/')
        }, 1500)
      } catch (error) {
        console.error('Error placing order:', error)
        alert('Failed to place order. Please try again.')
      } finally {
        processing.value = false
      }
    }
    
    return {
      cart,
      cartTotal,
      shippingInfo,
      paymentInfo,
      processing,
      submitOrder
    }
  }
}
</script>
