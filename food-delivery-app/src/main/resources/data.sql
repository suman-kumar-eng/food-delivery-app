-- Sample Categories
INSERT IGNORE INTO categories (id, name) VALUES (1, 'Pizza'), (2, 'Burger'), (3, 'Biryani'), (4, 'Chinese'), (5, 'South Indian'), (6, 'Drinks'), (7, 'Desserts'), (8, 'Snacks');

-- Sample User (Admin and Customer)
-- Admin
INSERT IGNORE INTO users (id, first_name, last_name, email, password, mobile_number, role) 
VALUES (1, 'Admin', 'User', 'admin@fooddelivery.com', 'admin123', '9876543210', 'ADMIN');

-- Customer
INSERT IGNORE INTO users (id, first_name, last_name, email, password, mobile_number, role) 
VALUES (2, 'John', 'Doe', 'john@gmail.com', 'password123', '9000000001', 'CUSTOMER');

-- Sample Restaurants
INSERT IGNORE INTO restaurants (id, name, description, image_url, address, phone_number, rating, active) 
VALUES (1, 'Pizza Palace', 'Best pizzas in town with fresh ingredients.', 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=800', '123 Main St, Hyderabad', '040-1234567', 4.5, true);

INSERT IGNORE INTO restaurants (id, name, description, image_url, address, phone_number, rating, active) 
VALUES (2, 'Burger King', 'Flame-grilled burgers and crispy fries.', 'https://images.unsplash.com/photo-1571091718767-18b5b1457add?w=800', '456 Oak St, Hyderabad', '040-7654321', 4.2, true);

INSERT IGNORE INTO restaurants (id, name, description, image_url, address, phone_number, rating, active) 
VALUES (3, 'Paradise Biryani', 'World famous Hyderabadi Biryani.', 'https://images.unsplash.com/photo-1563379091339-03b21bc4a4f8?w=800', 'Secunderabad', '040-1112223', 4.8, true);

-- Sample Menu Items
INSERT IGNORE INTO menu_items (id, name, description, price, offer_price, image_url, food_type, available, active, restaurant_id, category_id)
VALUES (1, 'Margherita Pizza', 'Classic cheese pizza with tomatoes.', 299.0, 249.0, 'https://images.unsplash.com/photo-1574071318508-1cdbcd80ad55?w=500', 'VEG', true, true, 1, 1);

INSERT IGNORE INTO menu_items (id, name, description, price, offer_price, image_url, food_type, available, active, restaurant_id, category_id)
VALUES (2, 'Pepperoni Pizza', 'Spicy pepperoni with mozzarella.', 399.0, null, 'https://images.unsplash.com/photo-1628840042765-356cda07504e?w=500', 'NON_VEG', true, true, 1, 1);

INSERT IGNORE INTO menu_items (id, name, description, price, offer_price, image_url, food_type, available, active, restaurant_id, category_id)
VALUES (3, 'Chicken Burger', 'Juicy chicken patty with lettuce.', 199.0, 149.0, 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=500', 'NON_VEG', true, true, 2, 2);

INSERT IGNORE INTO menu_items (id, name, description, price, offer_price, image_url, food_type, available, active, restaurant_id, category_id)
VALUES (4, 'Chicken Dum Biryani', 'Classic Hyderabadi Dum Biryani.', 350.0, null, 'https://images.unsplash.com/photo-1589302168068-964664d93dc0?w=500', 'NON_VEG', true, true, 3, 3);
