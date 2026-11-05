
USE indian_ecommerce;

-- 1. Customers
CREATE TABLE IF NOT EXISTS customers (
    customer_id VARCHAR(20) PRIMARY KEY,
    customer_signup_date DATE NOT NULL,
    gender VARCHAR(20),
    age DECIMAL(5,2),
    age_group VARCHAR(20),
    state VARCHAR(100),
    city VARCHAR(100),
    pincode_prefix VARCHAR(10),
    customer_segment VARCHAR(30),
    preferred_device VARCHAR(30),
    preferred_payment_method VARCHAR(50),
    acquisition_channel VARCHAR(100),
    total_orders INT,
    total_spend DECIMAL(14,2),
    last_order_date DATE,
    average_order_value DECIMAL(14,2),
    customer_status VARCHAR(30),
    loyalty_tier VARCHAR(30)
);

-- 2. Products
CREATE TABLE IF NOT EXISTS products (
    product_id VARCHAR(20) PRIMARY KEY,
    product_name VARCHAR(255),
    category VARCHAR(100),
    subcategory VARCHAR(100),
    brand VARCHAR(100),
    price DECIMAL(12,2),
    cost_price DECIMAL(12,2),
    discount_range VARCHAR(30),
    rating_average DECIMAL(3,2),
    rating_count INT,
    stock_quantity INT,
    product_launch_date DATE,
    product_type VARCHAR(50),
    return_rate_baseline DECIMAL(8,5)
);

-- 3. Marketing campaigns
CREATE TABLE IF NOT EXISTS marketing_campaigns (
    campaign_id VARCHAR(20) PRIMARY KEY,
    campaign_name VARCHAR(255),
    channel VARCHAR(100),
    campaign_start_date DATE,
    campaign_end_date DATE,
    campaign_type VARCHAR(100),
    target_segment VARCHAR(50),
    discount_percentage DECIMAL(5,2),
    conversions INT,
    revenue_generated DECIMAL(16,2),
    impressions INT,
    clicks INT,
    campaign_cost DECIMAL(16,2),
    roi DECIMAL(12,3)
);

-- 4. Orders
CREATE TABLE IF NOT EXISTS orders (
    order_id VARCHAR(20) PRIMARY KEY,
    customer_id VARCHAR(20) NOT NULL,
    order_date DATE NOT NULL,
    order_time TIME,
    order_status VARCHAR(40),
    shipping_method VARCHAR(80),
    delivery_city VARCHAR(100),
    delivery_state VARCHAR(100),
    coupon_code VARCHAR(50),
    discount_percentage DECIMAL(5,2),
    marketing_channel VARCHAR(100),
    subtotal DECIMAL(14,2),
    shipping_fee DECIMAL(12,2),
    tax_amount DECIMAL(12,2),
    final_amount DECIMAL(14,2),
    campaign_id VARCHAR(20),

    CONSTRAINT fk_orders_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id),

    CONSTRAINT fk_orders_campaign
        FOREIGN KEY (campaign_id)
        REFERENCES marketing_campaigns(campaign_id),

    INDEX idx_orders_date (order_date),
    INDEX idx_orders_status (order_status)
);

-- 5. Order items
CREATE TABLE IF NOT EXISTS order_items (
    order_item_id VARCHAR(25) PRIMARY KEY,
    order_id VARCHAR(20) NOT NULL,
    product_id VARCHAR(20) NOT NULL,
    quantity INT,
    unit_price DECIMAL(12,2),
    discount_percentage DECIMAL(5,2),
    item_revenue DECIMAL(14,2),
    item_cost DECIMAL(14,2),
    profit DECIMAL(14,2),

    CONSTRAINT fk_items_order
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id),

    CONSTRAINT fk_items_product
        FOREIGN KEY (product_id)
        REFERENCES products(product_id),

    INDEX idx_items_product (product_id)
);

-- 6. Payments
CREATE TABLE IF NOT EXISTS payments (
    payment_id VARCHAR(25) PRIMARY KEY,
    order_id VARCHAR(20) NOT NULL,
    payment_date DATE,
    payment_method VARCHAR(50),
    payment_status VARCHAR(40),
    amount_paid DECIMAL(14,2),
    transaction_fee DECIMAL(12,2),
    refund_amount DECIMAL(14,2),

    CONSTRAINT fk_payments_order
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
);

-- 7. Shipments
CREATE TABLE IF NOT EXISTS shipments (
    shipment_id VARCHAR(25) PRIMARY KEY,
    order_id VARCHAR(20) NOT NULL,
    warehouse_city VARCHAR(100),
    delivery_city VARCHAR(100),
    shipping_method VARCHAR(80),
    dispatch_date DATE,
    expected_delivery_date DATE,
    actual_delivery_date DATE,
    delivery_days DECIMAL(8,2),
    delivery_status VARCHAR(40),
    delayed_flag TINYINT,

    CONSTRAINT fk_shipments_order
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id),

    INDEX idx_shipments_delay (delayed_flag)
);

-- 8. Returns
CREATE TABLE IF NOT EXISTS `returns` (
    return_id VARCHAR(25) PRIMARY KEY,
    order_id VARCHAR(20) NOT NULL,
    customer_id VARCHAR(20) NOT NULL,
    product_id VARCHAR(20) NOT NULL,
    return_date DATE,
    return_reason VARCHAR(100),
    refund_amount DECIMAL(14,2),
    return_status VARCHAR(50),

    CONSTRAINT fk_returns_order
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id),

    CONSTRAINT fk_returns_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id),

    CONSTRAINT fk_returns_product
        FOREIGN KEY (product_id)
        REFERENCES products(product_id)
);

-- 9. Customer reviews
CREATE TABLE IF NOT EXISTS customer_reviews (
    review_id VARCHAR(25) PRIMARY KEY,
    order_id VARCHAR(20) NOT NULL,
    customer_id VARCHAR(20) NOT NULL,
    product_id VARCHAR(20) NOT NULL,
    review_date DATE,
    rating INT,
    review_sentiment VARCHAR(30),
    verified_purchase BOOLEAN,

    CONSTRAINT fk_reviews_order
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id),

    CONSTRAINT fk_reviews_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id),

    CONSTRAINT fk_reviews_product
        FOREIGN KEY (product_id)
        REFERENCES products(product_id),

    INDEX idx_reviews_rating (rating)
);

SHOW TABLES;
