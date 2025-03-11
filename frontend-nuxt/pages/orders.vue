<template>
  <div class="container mx-auto px-4 py-8">
    <h1 class="text-3xl font-bold mb-6">My Orders</h1>
    
    <div v-if="loading" class="text-center py-8">
      <p class="text-lg">Loading your orders...</p>
    </div>
    
    <div v-else-if="error" class="text-center py-8 text-red-600">
      <p>{{ error }}</p>
    </div>
    
    <div v-else-if="!isAuthenticated" class="text-center py-8 bg-gray-50 rounded-lg">
      <p class="text-gray-500 mb-4">Please log in to view your orders.</p>
      <NuxtLink to="/login" class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700">
        Login
      </NuxtLink>
    </div>
    
    <div v-else-if="orders.length === 0" class="text-center py-8 bg-gray-50 rounded-lg">
      <p class="text-gray-500 mb-4">You haven't placed any orders yet.</p>
      <NuxtLink to="/products" class="text-blue-600 hover:text-blue-800">
        Browse Products
      </NuxtLink>
    </div>
    
    <div v-else>
      <div v-for="order in orders" :key="order.id" class="bg-white rounded-lg shadow-md overflow-hidden mb-6">
        <div class="bg-gray-100 px-4 py-3 flex justify-between items-center">
          <div>
            <span class="font-semibold">Order #{{ order.id }}</span>
            <span class="ml-4 text-sm text-gray-600">{{ formatDate(order.created_at) }}</span>
          </div>
          <div>
            <span 
              class="px-3 py-1 rounded-full text-xs font-medium"
              :class="getStatusClass(order.status)"
            >
              {{ order.status }}
            </span>
          </div>
        </div>
        
        <div class="p-4">
          <div class="mb-4">
            <h3 class="text-lg font-semibold mb-2">Items</h3>
            <div class="overflow-x-auto">
              <table class="w-full">
                <thead class="bg-gray-50">
                  <tr>
                    <th class="py-2 px-3 text-left">Product</th>
                    <th class="py-2 px-3 text-center">Quantity</th>
                    <th class="py-2 px-3 text-right">Price</th>
                    <th class="py-2 px-3 text-right">Subtotal</th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-for="item in order.order_items" :key="item.id" class="border-t border-gray-200">
                    <td class="py-2 px-3">{{ item.product_name }}</td>
                    <td class="py-2 px-3 text-center">{{ item.quantity }}</td>
                    <td class="py-2 px-3 text-right">${{ parseFloat(item.price).toFixed(2) }}</td>
                    <td class="py-2 px-3 text-right">${{ (item.price * item.quantity).toFixed(2) }}</td>
                  </tr>
                </tbody>
                <tfoot class="bg-gray-50">
                  <tr>
                    <td colspan="3" class="py-2 px-3 text-right font-semibold">Total:</td>
                    <td class="py-2 px-3 text-right font-semibold">${{ parseFloat(order.total_amount).toFixed(2) }}</td>
                  </tr>
                </tfoot>
              </table>
            </div>
          </div>
          
          <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div>
              <h3 class="text-lg font-semibold mb-2">Shipping</h3>
              <div class="bg-gray-50 p-3 rounded">
                <p v-if="order.shipment">
                  <span class="font-medium">Status:</span> 
                  <span :class="getShipmentStatusClass(order.shipment.status)">
                    {{ order.shipment.status }}
                  </span>
                </p>
                <p v-if="order.shipment && order.shipment.tracking_number">
                  <span class="font-medium">Tracking:</span> 
                  {{ order.shipment.tracking_number }} 
                  ({{ order.shipment.carrier }})
                </p>
                <p v-if="order.shipment && order.shipment.estimated_delivery">
                  <span class="font-medium">Estimated Delivery:</span> 
                  {{ formatDate(order.shipment.estimated_delivery) }}
                </p>
                <p v-if="!order.shipment">
                  <span class="text-gray-500">Shipping information not available</span>
                </p>
              </div>
            </div>
            
            <div>
              <h3 class="text-lg font-semibold mb-2">Payment</h3>
              <div class="bg-gray-50 p-3 rounded">
                <p v-if="order.payment">
                  <span class="font-medium">Status:</span> 
                  <span :class="getPaymentStatusClass(order.payment.status)">
                    {{ order.payment.status }}
                  </span>
                </p>
                <p v-if="order.payment">
                  <span class="font-medium">Method:</span> 
                  {{ order.payment.payment_method }}
                </p>
                <p v-if="order.payment">
                  <span class="font-medium">Amount:</span> 
                  ${{ parseFloat(order.payment.amount).toFixed(2) }}
                </p>
                <p v-if="!order.payment">
                  <span class="text-gray-500">Payment information not available</span>
                </p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useAuthStore } from '~/store/auth'
import { useOrdersStore } from '~/store/orders'

const authStore = useAuthStore()
const ordersStore = useOrdersStore()

const isAuthenticated = computed(() => authStore.isAuthenticated)
const orders = ref([])
const loading = ref(true)
const error = ref(null)

// Mock orders data for demonstration
const mockOrders = [
  {
    id: 1001,
    user_id: 1,
    status: 'delivered',
    total_amount: 1049.98,
    created_at: '2025-03-01T10:30:00Z',
    order_items: [
      {
        id: 1,
        product_id: 1,
        product_name: 'Smartphone X',
        quantity: 1,
        price: 799.99
      },
      {
        id: 2,
        product_id: 3,
        product_name: 'Wireless Headphones',
        quantity: 1,
        price: 249.99
      }
    ],
    payment: {
      id: 1,
      order_id: 1001,
      amount: 1049.98,
      payment_method: 'Credit Card',
      status: 'completed',
      transaction_id: 'txn_123456789'
    },
    shipment: {
      id: 1,
      order_id: 1001,
      status: 'delivered',
      tracking_number: 'TRK123456789',
      carrier: 'FedEx',
      estimated_delivery: '2025-03-05T00:00:00Z'
    }
  },
  {
    id: 1002,
    user_id: 1,
    status: 'processing',
    total_amount: 579.98,
    created_at: '2025-03-08T15:45:00Z',
    order_items: [
      {
        id: 3,
        product_id: 6,
        product_name: 'Tablet Ultra',
        quantity: 1,
        price: 499.99
      },
      {
        id: 4,
        product_id: 8,
        product_name: 'Portable Speaker',
        quantity: 1,
        price: 79.99
      }
    ],
    payment: {
      id: 2,
      order_id: 1002,
      amount: 579.98,
      payment_method: 'PayPal',
      status: 'completed',
      transaction_id: 'txn_987654321'
    },
    shipment: {
      id: 2,
      order_id: 1002,
      status: 'shipped',
      tracking_number: 'TRK987654321',
      carrier: 'UPS',
      estimated_delivery: '2025-03-12T00:00:00Z'
    }
  }
]

const fetchOrders = async () => {
  loading.value = true
  error.value = null
  
  try {
    // In a real app, this would be an API call
    // const response = await fetch(`${config.public.apiBase}/orders`, {
    //   headers: {
    //     'Authorization': `Bearer ${authStore.token}`
    //   }
    // })
    // if (!response.ok) throw new Error('Failed to fetch orders')
    // orders.value = await response.json()
    
    // Using mock data for demonstration
    await new Promise(resolve => setTimeout(resolve, 500)) // Simulate network delay
    orders.value = mockOrders
  } catch (err) {
    console.error('Error fetching orders:', err)
    error.value = 'Failed to load orders. Please try again later.'
  } finally {
    loading.value = false
  }
}

const formatDate = (dateString) => {
  const date = new Date(dateString)
  return date.toLocaleDateString('en-US', {
    year: 'numeric',
    month: 'short',
    day: 'numeric'
  })
}

const getStatusClass = (status) => {
  const statusClasses = {
    'pending': 'bg-yellow-100 text-yellow-800',
    'processing': 'bg-blue-100 text-blue-800',
    'shipped': 'bg-purple-100 text-purple-800',
    'delivered': 'bg-green-100 text-green-800',
    'cancelled': 'bg-red-100 text-red-800'
  }
  return statusClasses[status] || 'bg-gray-100 text-gray-800'
}

const getShipmentStatusClass = (status) => {
  const statusClasses = {
    'pending': 'text-yellow-600',
    'shipped': 'text-blue-600',
    'in_transit': 'text-purple-600',
    'out_for_delivery': 'text-indigo-600',
    'delivered': 'text-green-600',
    'failed': 'text-red-600'
  }
  return statusClasses[status] || 'text-gray-600'
}

const getPaymentStatusClass = (status) => {
  const statusClasses = {
    'pending': 'text-yellow-600',
    'processing': 'text-blue-600',
    'completed': 'text-green-600',
    'failed': 'text-red-600',
    'refunded': 'text-purple-600'
  }
  return statusClasses[status] || 'text-gray-600'
}

onMounted(() => {
  if (isAuthenticated.value) {
    fetchOrders()
  } else {
    loading.value = false
  }
})
</script>
