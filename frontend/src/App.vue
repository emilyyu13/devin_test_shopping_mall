<template>
  <div class="min-h-screen flex flex-col">
    <header class="bg-blue-600 text-white shadow-md">
      <div class="container mx-auto px-4 py-4 flex justify-between items-center">
        <router-link to="/" class="text-2xl font-bold">Shopping Mall</router-link>
        <nav class="flex items-center space-x-6">
          <router-link to="/" class="hover:text-blue-200">Home</router-link>
          <router-link to="/cart" class="flex items-center hover:text-blue-200">
            <span>Cart ({{ cartItemCount }})</span>
          </router-link>
          <template v-if="isAuthenticated">
            <span>{{ user.name }}</span>
            <button @click="logout" class="hover:text-blue-200">Logout</button>
          </template>
          <template v-else>
            <router-link to="/login" class="hover:text-blue-200">Login</router-link>
          </template>
        </nav>
      </div>
    </header>
    
    <main class="flex-grow container mx-auto px-4 py-6">
      <router-view />
    </main>
    
    <footer class="bg-gray-800 text-white py-6">
      <div class="container mx-auto px-4">
        <p class="text-center">&copy; 2025 Shopping Mall. All rights reserved.</p>
      </div>
    </footer>
  </div>
</template>

<script>
import { computed } from 'vue'
import { useStore } from 'vuex'

export default {
  name: 'App',
  setup() {
    const store = useStore()
    
    const isAuthenticated = computed(() => store.getters.isAuthenticated)
    const user = computed(() => store.state.user)
    const cartItemCount = computed(() => store.getters.cartItemCount)
    
    const logout = () => {
      store.dispatch('logout')
    }
    
    return {
      isAuthenticated,
      user,
      cartItemCount,
      logout
    }
  }
}
</script>
