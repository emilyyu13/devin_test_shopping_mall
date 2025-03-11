<template>
  <div class="container mx-auto px-4 py-8">
    <h1 class="text-3xl font-bold mb-6">All Products</h1>
    
    <div v-if="loading" class="text-center py-8">
      <p class="text-lg">Loading products...</p>
    </div>
    
    <div v-else-if="error" class="text-center py-8 text-red-600">
      <p>{{ error }}</p>
    </div>
    
    <div v-else-if="products.length === 0" class="text-center py-8">
      <p>No products available at the moment.</p>
    </div>
    
    <div v-else class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
      <div v-for="product in products" :key="product.id" class="border rounded-lg overflow-hidden shadow-md hover:shadow-lg transition-shadow">
        <div class="h-48 bg-gray-200 flex items-center justify-center">
          <img v-if="product.image" :src="product.image" :alt="product.name" class="max-h-full max-w-full object-cover" />
          <div v-else class="text-gray-400">No image available</div>
        </div>
        
        <div class="p-4">
          <h2 class="text-xl font-semibold mb-2">{{ product.name }}</h2>
          <p class="text-gray-600 mb-2 line-clamp-2">{{ product.description }}</p>
          <div class="flex justify-between items-center mt-4">
            <span class="text-lg font-bold">${{ product.price.toFixed(2) }}</span>
            <span class="text-sm" :class="product.stock_quantity > 0 ? 'text-green-600' : 'text-red-600'">
              {{ product.stock_quantity > 0 ? `${product.stock_quantity} in stock` : 'Out of stock' }}
            </span>
          </div>
          <button 
            @click="addToCart(product)" 
            class="mt-4 w-full bg-blue-600 text-white py-2 px-4 rounded hover:bg-blue-700 transition-colors"
            :disabled="product.stock_quantity <= 0"
            :class="{'opacity-50 cursor-not-allowed': product.stock_quantity <= 0}"
          >
            Add to Cart
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { useCartStore } from '~/store/cart';

const cartStore = useCartStore();
const products = ref([]);
const loading = ref(true);
const error = ref(null);

// Mock products data for demonstration
const mockProducts = [
  {
    id: 1,
    name: 'Smartphone X',
    description: 'Latest smartphone with advanced features and high-resolution camera.',
    price: 799.99,
    stock_quantity: 15,
    category: 'Electronics',
    image: 'https://via.placeholder.com/300x300.png?text=Smartphone'
  },
  {
    id: 2,
    name: 'Laptop Pro',
    description: 'Powerful laptop for professionals with high performance and long battery life.',
    price: 1299.99,
    stock_quantity: 8,
    category: 'Electronics',
    image: 'https://via.placeholder.com/300x300.png?text=Laptop'
  },
  {
    id: 3,
    name: 'Wireless Headphones',
    description: 'Premium noise-cancelling wireless headphones with crystal clear sound.',
    price: 249.99,
    stock_quantity: 20,
    category: 'Audio',
    image: 'https://via.placeholder.com/300x300.png?text=Headphones'
  },
  {
    id: 4,
    name: 'Smart Watch',
    description: 'Track your fitness and stay connected with this advanced smart watch.',
    price: 199.99,
    stock_quantity: 12,
    category: 'Wearables',
    image: 'https://via.placeholder.com/300x300.png?text=SmartWatch'
  },
  {
    id: 5,
    name: 'Wireless Earbuds',
    description: 'Compact wireless earbuds with amazing sound quality and long battery life.',
    price: 129.99,
    stock_quantity: 25,
    category: 'Audio',
    image: 'https://via.placeholder.com/300x300.png?text=Earbuds'
  },
  {
    id: 6,
    name: 'Tablet Ultra',
    description: 'Thin and lightweight tablet with stunning display and powerful processor.',
    price: 499.99,
    stock_quantity: 10,
    category: 'Electronics',
    image: 'https://via.placeholder.com/300x300.png?text=Tablet'
  },
  {
    id: 7,
    name: 'Digital Camera',
    description: 'Professional digital camera with high-resolution sensor and interchangeable lenses.',
    price: 899.99,
    stock_quantity: 5,
    category: 'Photography',
    image: 'https://via.placeholder.com/300x300.png?text=Camera'
  },
  {
    id: 8,
    name: 'Portable Speaker',
    description: 'Waterproof portable speaker with 360-degree sound and deep bass.',
    price: 79.99,
    stock_quantity: 18,
    category: 'Audio',
    image: 'https://via.placeholder.com/300x300.png?text=Speaker'
  }
];

const fetchProducts = async () => {
  loading.value = true;
  error.value = null;
  
  try {
    // In a real app, this would be an API call
    // const response = await fetch(`${config.public.apiBase}/products`);
    // if (!response.ok) throw new Error('Failed to fetch products');
    // products.value = await response.json();
    
    // Using mock data for demonstration
    await new Promise(resolve => setTimeout(resolve, 500)); // Simulate network delay
    products.value = mockProducts;
  } catch (err) {
    console.error('Error fetching products:', err);
    error.value = 'Failed to load products. Please try again later.';
  } finally {
    loading.value = false;
  }
};

const addToCart = (product) => {
  if (product.stock_quantity > 0) {
    cartStore.addToCart({
      id: product.id,
      name: product.name,
      price: product.price,
      quantity: 1,
      image: product.image
    });
  }
};

onMounted(() => {
  fetchProducts();
});
</script>
