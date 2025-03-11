<template>
  <div class="max-w-md mx-auto">
    <h1 class="text-3xl font-bold mb-6 text-center">Login</h1>
    
    <div class="bg-white rounded-lg shadow-md p-6">
      <div v-if="error" class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-4">
        {{ error }}
      </div>
      
      <form @submit.prevent="login">
        <div class="mb-4">
          <label class="block text-gray-700 mb-1">Email</label>
          <input 
            v-model="email"
            type="email" 
            class="w-full px-3 py-2 border border-gray-300 rounded focus:outline-none focus:border-blue-500"
            required
          />
        </div>
        
        <div class="mb-6">
          <label class="block text-gray-700 mb-1">Password</label>
          <input 
            v-model="password"
            type="password" 
            class="w-full px-3 py-2 border border-gray-300 rounded focus:outline-none focus:border-blue-500"
            required
          />
        </div>
        
        <button 
          type="submit"
          class="w-full bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700"
          :disabled="loading"
        >
          {{ loading ? 'Logging in...' : 'Login' }}
        </button>
      </form>
      
      <div class="mt-4 text-center">
        <p>Don't have an account? <NuxtLink to="/register" class="text-blue-600 hover:text-blue-800">Register</NuxtLink></p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useAuthStore } from '~/store/auth'

const authStore = useAuthStore()

const email = ref('')
const password = ref('')
const error = ref('')
const loading = ref(false)

const login = async () => {
  error.value = ''
  loading.value = true
  
  try {
    await authStore.login(email.value, password.value)
    navigateTo('/')
  } catch (err) {
    error.value = err.message || 'Failed to login. Please check your credentials.'
  } finally {
    loading.value = false
  }
}
</script>
