<template>
  <div>
    <section class="mb-8">
      <h1 class="text-3xl font-bold mb-4">Welcome to Shopping Mall</h1>
      <p class="text-lg text-gray-600">Browse our latest products and find great deals!</p>
    </section>
    
    <section>
      <h2 class="text-2xl font-semibold mb-4">Products</h2>
      
      <div v-if="loading" class="text-center py-8">
        <p class="text-gray-500">Loading products...</p>
      </div>
      
      <div v-else-if="products.length === 0" class="text-center py-8">
        <p class="text-gray-500">No products available.</p>
      </div>
      
      <div v-else class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
        <div v-for="product in products" :key="product.id" class="bg-white rounded-lg shadow-md overflow-hidden">
          <div class="p-4">
            <h3 class="text-lg font-semibold mb-2">{{ product.name }}</h3>
            <p class="text-gray-600 mb-2 text-sm">{{ product.description }}</p>
            <div class="flex justify-between items-center mb-2">
              <span class="text-blue-600 font-bold">${{ parseFloat(product.price).toFixed(2) }}</span>
              <span class="text-sm text-gray-500">Stock: {{ product.stock_quantity }}</span>
            </div>
            <div class="flex justify-between items-center">
              <button 
                @click="addToCart(product)"
                :disabled="product.stock_quantity <= 0"
                class="bg-blue-600 text-white px-3 py-1 rounded hover:bg-blue-700 disabled:bg-gray-400 disabled:cursor-not-allowed text-sm"
              >
                Add to Cart
              </button>
            </div>
          </div>
        </div>
      </div>
    </section>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useProductStore } from '~/store/products'
import { useCartStore } from '~/store/cart'

const productStore = useProductStore()
const cartStore = useCartStore()

const products = ref([])
const loading = ref(true)

onMounted(async () => {
  try {
    await productStore.fetchProducts()
    products.value = productStore.products
  } catch (error) {
    console.error('Error fetching products:', error)
  } finally {
    loading.value = false
  }
})

const addToCart = (product) => {
  cartStore.addToCart(product, 1)
}
</script>
