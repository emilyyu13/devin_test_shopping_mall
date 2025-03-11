<template>
  <div class="min-h-screen flex flex-col">
    <header class="bg-blue-600 text-white shadow-md">
      <div class="container mx-auto px-4 py-4 flex justify-between items-center">
        <NuxtLink to="/" class="text-2xl font-bold">Shopping Mall</NuxtLink>
        <nav class="flex items-center space-x-6">
          <NuxtLink to="/" class="hover:text-blue-200">Home</NuxtLink>
          <NuxtLink to="/cart" class="flex items-center hover:text-blue-200">
            <span>Cart ({{ cartItemCount }})</span>
          </NuxtLink>
          <template v-if="isAuthenticated">
            <span>{{ user?.name }}</span>
            <button @click="logout" class="hover:text-blue-200">Logout</button>
          </template>
          <template v-else>
            <NuxtLink to="/login" class="hover:text-blue-200">Login</NuxtLink>
          </template>
        </nav>
      </div>
    </header>
    
    <main class="flex-grow container mx-auto px-4 py-6">
      <slot />
    </main>
    
    <footer class="bg-gray-800 text-white py-6">
      <div class="container mx-auto px-4">
        <p class="text-center">&copy; 2025 Shopping Mall. All rights reserved.</p>
      </div>
    </footer>
  </div>
</template>

<script setup>
import { computed } from 'vue'
import { useAuthStore } from '~/store/auth'
import { useCartStore } from '~/store/cart'

const authStore = useAuthStore()
const cartStore = useCartStore()

const isAuthenticated = computed(() => authStore.isAuthenticated)
const user = computed(() => authStore.user)
const cartItemCount = computed(() => cartStore.cartItemCount)

const logout = () => {
  authStore.logout()
}
</script>
