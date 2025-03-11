# Create admin user
admin = User.find_or_initialize_by(email: 'admin@example.com')
admin.update!(
  name: 'Admin User',
  password: 'password123',
  password_confirmation: 'password123',
  role: 'admin'
)

# Create regular user
user = User.find_or_initialize_by(email: 'user@example.com')
user.update!(
  name: 'Regular User',
  password: 'password123',
  password_confirmation: 'password123',
  role: 'customer'
)

# Create products
products = [
  {
    name: 'Smartphone',
    description: 'Latest model with high-resolution camera',
    price: 699.99,
    stock_quantity: 50,
    category: 'Electronics'
  },
  {
    name: 'Laptop',
    description: 'Powerful laptop for work and gaming',
    price: 1299.99,
    stock_quantity: 25,
    category: 'Electronics'
  },
  {
    name: 'Headphones',
    description: 'Noise-cancelling wireless headphones',
    price: 199.99,
    stock_quantity: 100,
    category: 'Electronics'
  },
  {
    name: 'T-shirt',
    description: 'Cotton t-shirt with logo',
    price: 19.99,
    stock_quantity: 200,
    category: 'Clothing'
  },
  {
    name: 'Jeans',
    description: 'Classic blue jeans',
    price: 49.99,
    stock_quantity: 150,
    category: 'Clothing'
  }
]

products.each do |product_attrs|
  Product.find_or_create_by!(name: product_attrs[:name]) do |product|
    product.assign_attributes(product_attrs)
  end
end

puts "Seed data created successfully!"
