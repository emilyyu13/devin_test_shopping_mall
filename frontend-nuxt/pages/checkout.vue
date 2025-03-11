<template>
  <div>
    <h1 class="text-3xl font-bold mb-6">Checkout</h1>
    
    <div v-if="cartItems.length === 0" class="text-center py-8 bg-gray-50 rounded-lg">
      <p class="text-gray-500 mb-4">Your cart is empty. Please add items before checkout.</p>
      <NuxtLink to="/" class="text-blue-600 hover:text-blue-800">Continue Shopping</NuxtLink>
    </div>
    
    <div v-else class="grid grid-cols-1 md:grid-cols-3 gap-6">
      <div class="md:col-span-2">
        <div class="bg-white rounded-lg shadow-md p-6 mb-6">
          <h2 class="text-xl font-semibold mb-4">Shipping Information</h2>
          
          <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
            <div>
              <label class="block text-gray-700 mb-1">Full Name</label>
              <input 
                v-model="shippingInfo.name"
                type="text" 
                class="w-full px-3 py-2 border border-gray-300 rounded focus:outline-none focus:border-blue-500"
              />
            </div>
            <div>
              <label class="block text-gray-700 mb-1">Email</label>
              <input 
                v-model="shippingInfo.email"
                type="email" 
                class="w-full px-3 py-2 border border-gray-300 rounded focus:outline-none focus:border-blue-500"
              />
            </div>
          </div>
          
          <div class="mb-4">
            <label class="block text-gray-700 mb-1">Address</label>
            <input 
              v-model="shippingInfo.address"
              type="text" 
              class="w-full px-3 py-2 border border-gray-300 rounded focus:outline-none focus:border-blue-500"
            />
          </div>
          
          <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
            <div>
              <label class="block text-gray-700 mb-1">City</label>
              <input 
                v-model="shippingInfo.city"
                type="text" 
                class="w-full px-3 py-2 border border-gray-300 rounded focus:outline-none focus:border-blue-500"
              />
            </div>
            <div>
              <label class="block text-gray-700 mb-1">State</label>
              <input 
                v-model="shippingInfo.state"
                type="text" 
                class="w-full px-3 py-2 border border-gray-300 rounded focus:outline-none focus:border-blue-500"
              />
            </div>
            <div>
              <label class="block text-gray-700 mb-1">Postal Code</label>
              <input 
                v-model="shippingInfo.postalCode"
                type="text" 
                class="w-full px-3 py-2 border border-gray-300 rounded focus:outline-none focus:border-blue-500"
              />
            </div>
          </div>
        </div>
        
        <div class="bg-white rounded-lg shadow-md p-6">
          <h2 class="text-xl font-semibold mb-4">Payment Information</h2>
          
          <div class="mb-4">
            <label class="block text-gray-700 mb-1">Card Number</label>
            <input 
              v-model="paymentInfo.cardNumber"
              type="text" 
              class="w-full px-3 py-2 border border-gray-300 rounded focus:outline-none focus:border-blue-500"
              placeholder="**** **** **** ****"
            />
          </div>
          
          <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
            <div>
              <label class="block text-gray-700 mb-1">Expiration Month</label>
              <input 
                v-model="paymentInfo.expiryMonth"
                type="text" 
                class="w-full px-3 py-2 border border-gray-300 rounded focus:outline-none focus:border-blue-500"
                placeholder="MM"
              />
            </div>
            <div>
              <label class="block text-gray-700 mb-1">Expiration Year</label>
              <input 
                v-model="paymentInfo.expiryYear"
                type="text" 
                class="w-full px-3 py-2 border border-gray-300 rounded focus:outline-none focus:border-blue-500"
                placeholder="YY"
              />
            </div>
            <div>
              <label class="block text-gray-700 mb-1">CVV</label>
              <input 
                v-model="paymentInfo.cvv"
                type="text" 
                class="w-full px-3 py-2 border border-gray-300 rounded focus:outline-none focus:border-blue-500"
                placeholder="***"
              />
            </div>
          </div>
        </div>
      </div>
      
      <div class="md:col-span-1">
        <div class="bg-white rounded-lg shadow-md p-6 sticky top-6">
          <h2 class="text-xl font-semibold mb-4">Order Summary</h2>
          
          <div class="mb-4">
            <div v-for="item in cartItems" :key="item.id" class="flex justify-between py-2 border-b border-gray-200">
              <div>
                <p>{{ item.name }}</p>
                <p class="text-sm text-gray-500">Qty: {{ item.quantity }}</p>
              </div>
              <p>${{ (item.price * item.quantity).toFixed(2) }}</p>
            </div>
          </div>
          
          <div class="flex justify-between py-2 font-semibold">
            <p>Total</p>
            <p>${{ cartTotal.toFixed(2) }}</p>
          </div>
          
          <button 
            @click="placeOrder"
            class="w-full bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700 mt-4"
            :disabled="!formIsValid"
          >
            Place Order
          </button>
          
          <p v-if="orderSuccess" class="text-green-600 mt-4 text-center">
            Order placed successfully!
          </p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { useCartStore } from '~/store/cart'
import { useOrdersStore } from '~/store/orders'

const cartStore = useCartStore()
const ordersStore = useOrdersStore()

const cartItems = computed(() => cartStore.cart)
const cartTotal = computed(() => cartStore.cartTotal)

const shippingInfo = ref({
  name: '',
  email: '',
  address: '',
  city: '',
  state: '',
  postalCode: ''
})

const paymentInfo = ref({
  cardNumber: '',
  expiryMonth: '',
  expiryYear: '',
  cvv: ''
})

const orderSuccess = ref(false)

const formIsValid = computed(() => {
  return (
    shippingInfo.value.name &&
    shippingInfo.value.email &&
    shippingInfo.value.address &&
    shippingInfo.value.city &&
    shippingInfo.value.state &&
    shippingInfo.value.postalCode &&
    paymentInfo.value.cardNumber &&
    paymentInfo.value.expiryMonth &&
    paymentInfo.value.expiryYear &&
    paymentInfo.value.cvv
  )
})

const placeOrder = async () => {
  // In a real app, this would send the order to the backend
  try {
    const orderData = {
      items: cartItems.value.map(item => ({
        product_id: item.id,
        quantity: item.quantity,
        price: item.price
      })),
      shipping_info: shippingInfo.value,
      payment_info: paymentInfo.value
    }
    
    // Create a mock order in the orders store
    const mockOrderId = Math.floor(1000 + Math.random() * 9000)
    const mockOrder = {
      id: mockOrderId,
      user_id: 1,
      status: 'processing',
      total_amount: cartTotal.value,
      created_at: new Date().toISOString(),
      order_items: cartItems.value.map(item => ({
        id: Math.floor(Math.random() * 1000),
        product_id: item.id,
        product_name: item.name,
        quantity: item.quantity,
        price: item.price
      })),
      payment: {
        id: Math.floor(Math.random() * 1000),
        order_id: mockOrderId,
        amount: cartTotal.value,
        payment_method: 'Credit Card',
        status: 'completed',
        transaction_id: `txn_${Math.random().toString(36).substring(2, 15)}`
      },
      shipment: {
        id: Math.floor(Math.random() * 1000),
        order_id: mockOrderId,
        status: 'processing',
        tracking_number: `TRK${Math.random().toString(36).substring(2, 15).toUpperCase()}`,
        carrier: 'UPS',
        estimated_delivery: new Date(Date.now() + 4 * 24 * 60 * 60 * 1000).toISOString()
      }
    }
    
    // Add the mock order to the orders store
    ordersStore.orders.push(mockOrder)
    
    // Simulate API call delay
    await new Promise(resolve => setTimeout(resolve, 1000))
    
    // Clear cart and show success message
    cartStore.clearCart()
    orderSuccess.value = true
    
    // Navigate to orders page after successful order placement
    // Use a shorter timeout and direct navigation to ensure it works
    setTimeout(() => {
      // Use both methods to ensure navigation works
      try {
        window.location.href = '/orders'
      } catch (e) {
        console.error('Error with window.location:', e)
        navigateTo('/orders')
      }
    }, 500)
  } catch (error) {
    console.error('Error creating order:', error)
  }
}
</script>
