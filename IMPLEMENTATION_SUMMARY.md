# Online Shopping Mall System Implementation

## Overview
This project implements a comprehensive online shopping mall system with:
- **Frontend**: Vue.js with Vite, Vuex state management, and Tailwind CSS
- **Backend**: Ruby on Rails API with SQLite3 database
- **Features**: Stock management, payment processing, and logistics functionality

## Backend Implementation (Ruby on Rails)

### Core Models
- **User**: Authentication and user management
- **Product**: Inventory and stock management
- **Order & OrderItem**: Purchase tracking and management
- **Payment**: Transaction processing with multiple payment methods
- **Shipment**: Logistics tracking with carrier integration
- **ShippingAddress**: Customer delivery information

### API Endpoints
- **Products API**: Browse and manage inventory
- **Orders API**: Purchase management
- **Payments API**: Transaction processing
- **Shipments API**: Logistics tracking
- **Authentication API**: User login and registration

### Key Features
- **Stock Management**: Automatic inventory tracking and updates
- **Payment Processing**: Multiple payment methods with status tracking
- **Logistics Handling**: Shipment tracking with delivery estimation

## Frontend Implementation (Vue.js)

### Pages
- **Home**: Product browsing and filtering
- **Cart**: Shopping cart management
- **Checkout**: Order placement with shipping and payment
- **Login**: User authentication

### State Management
- **Vuex Store**: Centralized state management for products, cart, and user
- **Local Storage**: Persistent cart and authentication

### UI Components
- **Product Cards**: Display product information with add-to-cart functionality
- **Cart Summary**: Show cart items with quantity management
- **Checkout Form**: Collect shipping and payment information
- **Navigation**: User-friendly site navigation

## How to Run

### Backend
```bash
cd backend
bin/rails server -p 3001
```

### Frontend
```bash
cd frontend
npm run dev
```

Access the application at http://localhost:8001

## Testing
The system includes comprehensive testing for both frontend and backend:
- Backend API endpoints tested with curl commands
- Frontend functionality tested through browser interaction

## Future Enhancements
- User registration and profile management
- Product search and filtering
- Order history and tracking
- Admin dashboard for inventory management
- Payment gateway integration