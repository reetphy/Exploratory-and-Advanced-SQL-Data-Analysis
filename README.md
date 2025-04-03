# **Motogear International - Sales & Customer Analysis** 🏍️💰  
🚀 **Project Type**: SQL Analysis | MySQL | Data Analytics  

📊 **Objective**: Perform **exploratory and advanced data analysis** to extract insights from customer, product, and sales data, helping to drive business decisions.  

---

## **📊 Key Business Metrics**  

Here are some key performance indicators derived from the dataset:  

- 📈 **Total Sales:** $29,356,250  
- 📦 **Total Quantity Sold:** 60,423 units  
- 💰 **Average Price per Unit:** $486  
- 🛒 **Total Orders Processed:** 27,659  
- 🏷️ **Total Products Available:** 295  
- 👥 **Total Customers:** 18,484

---

## **📌 Technologies Used**  
- **Database:** MySQL  
- **Querying & Analysis:** SQL   
- **Version Control:** Git & GitHub    

---

## **📂 Dataset Overview**  
The dataset represents **Motogear International’s** customer base, product catalog, and sales transactions from **2010-12-29 to 2014-01-28**, with products sold across **six countries**:  
🇦🇺 Australia | 🇺🇸 USA | 🇨🇦 Canada | 🇩🇪 Germany | 🇬🇧 UK | 🇫🇷 France   

It consists of three key tables:  

### **1️⃣ dim_customers** (Customer Dimension)  
Stores customer details, including demographics and account creation data.  

| Column Name        | Data Type | Description |
|--------------------|----------|-------------|
| `customer_key`    | Integer  | Unique identifier for each customer (Primary Key). |
| `customer_id`     | Integer  | Internal customer ID. |
| `customer_number` | String   | Unique customer number used for tracking. |
| `first_name`      | String   | Customer's first name. |
| `last_name`       | String   | Customer's last name. |
| `country`         | String   | Customer's country of residence. |
| `marital_status`  | String   | Marital status (Single/Married). |
| `gender`         | String   | Gender (Male/Female). |
| `birthdate`       | Date     | Customer’s date of birth. |
| `create_date`     | Date     | Date of account creation. |

---

### **2️⃣ dim_products** (Product Dimension)  
Contains details about the products sold, including pricing and categorization.  

| Column Name       | Data Type | Description |
|-------------------|----------|-------------|
| `product_key`    | Integer  | Unique identifier for each product (Primary Key). |
| `product_id`     | Integer  | Internal product ID. |
| `product_number` | String   | Unique product number for tracking. |
| `product_name`   | String   | Name of the product. |
| `category_id`    | String   | Product category ID. |
| `category`       | String   | Product category (Bikes, Components, Accessories, Clothing). |
| `subcategory`    | String   | Subcategory of the product (e.g., Mountain Bikes, Road Frames). |
| `maintenance`    | String   | Indicates if the product requires maintenance (Yes/No). |
| `cost`          | Integer  | Cost of the product. |
| `product_line`   | String   | Product line (e.g., Road, Mountain). |
| `start_date`     | Date     | Date when the product was introduced. |

---

### **3️⃣ fact_sales** (Sales Fact Table)  
Records sales transactions, linking customers and products.  

| Column Name      | Data Type | Description |
|------------------|----------|-------------|
| `order_number`  | Integer  | Sales transaction identifier (Primary Key). |
| `customer_key`  | Integer  | Foreign Key linking to `dim_customers`. |
| `product_key`   | Integer  | Foreign Key linking to `dim_products`. |
| `order_date`    | Date     | Date when the order was placed. |
| `quantity`      | Integer  | Number of units sold. |
| `price`         | Integer  | Price per unit of the product. |
| `sales_amount`  | Integer  | Total revenue generated (quantity * unit_price). |
| `shipping_date` | Date     | Date when the order was shipped.|

---

### 📖 Data Dictionary  
- **Dimension Tables (`dim_*`)**: Contain descriptive attributes about customers and products.  
- **Fact Table (`fact_sales`)**: Stores transactional data related to customer purchases.  
- **Primary Keys (`*_key`)**: Uniquely identify rows in dimension tables.  
- **Foreign Keys (`customer_key`, `product_key`)**: Establish relationships between tables.  

---

### 🛠️ How to Use the Dataset  
1. Load the data into a **SQL database** (MySQL, PostgreSQL, or SQLite).  
2. Perform **exploratory data analysis (EDA)** using SQL queries.  
3. Use **Python (Pandas, Matplotlib, Seaborn)** to visualize trends.  

---

## **🛠️ Project Workflow** 
The project is divided into three major phases:

  ### **1️⃣ Exploratory Data Analysis (EDA)** 
  Objective: Understand the structure and characteristics of the dataset.

    ✅ Basic Database Exploration – Identifying missing values, duplicates, and inconsistencies.
    ✅ Dimension Exploration – Analyzing customer and product attributes.
    ✅ Date Exploration – Examining sales trends over time.
    ✅ Measure Exploration – Assessing key metrics like total revenue and order count.
    ✅ Magnitude Analysis – Identifying high-value customers and top-selling products.
    ✅ Ranking Analysis – Ranking customers, products, and sales regions based on performance.

  ### **2️⃣ Advanced Data Analysis** 
  Objective: Derive deeper insights into customer behavior and sales trends.

    ✅ Changes Over Time Analysis – Examining year-over-year growth and seasonality.
    ✅ Cumulative Analysis – Tracking cumulative revenue and customer acquisition.
    ✅ Performance Analysis – Measuring sales efficiency and customer retention.
    ✅ Part-to-Whole Analysis – Understanding contributions of different products and regions.
    ✅ Data Segmentation – Categorizing customers into segments based on spending patterns.

  ### **3️⃣ Report Creation** 
  Objective: Summarize findings in a structured format for business decision-making.

  #### **📊 Customer Report**
  Purpose: Consolidates key customer metrics and behaviors.

  ✅ Key Features:
  - 1️⃣ Demographics & Transaction Details – Names, ages, and spending patterns.
  - 2️⃣ Customer Segmentation – Classification into VIP, Regular, and New customers.
  - 3️⃣ Aggregated Customer Metrics:
      - Total Orders – Number of purchases made.
      - Total Sales – Overall revenue contribution.
      - Total Quantity Purchased – Units bought over time.
      - Total Products Purchased – Diversity in purchases.
      - Lifespan (Months) – Duration of customer activity.
  - 4️⃣ Key Performance Indicators (KPIs):
      - Recency 
      - Average Order Value (AOV) 
      - Average Monthly Spend  

  #### **📊 Product Report**
  Purpose: Consolidates key product metrics and behaviors.

  ✅ Key Features:
  - 1️⃣ Product Spicifications – Name, category, subcategory, and cost.
  - 2️⃣ Product Segmentation – Classification into High-Performers, Mid-Range, or Low-Performers.-
  - 3️⃣ Aggregated Customer Metrics:
      - Total Orders – Number of purchases made.
      - Total Sales – Overall revenue contribution.
      - Total Quantity Sold – Units bought over time.
      - Lifespan (Months) – Duration of product activity.
  - 4️⃣ Key Performance Indicators (KPIs):
      - Recency 
      - Average Order Revenue (AOR) 
      - Average Monthly Revenue 

---

## **📈 Key Insights**  

### **1️⃣ Customer Segmentation** 🏆  
✅ **Insight:** **New customers generate the highest revenue (37.81%)**, indicating strong acquisition efforts, while **VIPs (36.59%) provide sustained value**, and Regular customers (25.59%) may need engagement strategies to boost spending. 

---

### **2️⃣ Sales Trend Over Time** 📅   
✅ **Insight:** **Sales experienced a significant rise from 2010 to 2013, peaking in 2013 with over 16 million in total sales.**  

---

### **3️⃣ Best-Selling Products** 🏍️    
✅ **Insight:** **Bikes dominate total sales, contributing 96.46% of revenue, while Accessories and Clothing combined account for less than 4%**. This suggests that the business is heavily reliant on bike sales, and there may be opportunities to diversify revenue streams by improving the sales strategy for Accessories and Clothing.

---

## **📝 Business Recommendations**  
📌 **Customer Retention Strategies** 🚀  
🔹 Target **VIP customers** with exclusive offers  
🔹 Engage **New customers** with onboarding discounts  
🔹 Improve **Regular customer** frequency through loyalty programs  

📌 **Product Optimization** 🏍️  
🔹 Focus on **Bikes & Accessories** for revenue maximization  
🔹 Reduce inventory for **Low-Performing items**  

📌 **Market Expansion** 🌍  
🔹 Highest sales in 🇺🇸 USA – expand marketing efforts  
🔹 **Emerging markets** in 🇦🇺 Australia need localized campaigns  

---

## **🛠️ Future Improvements**  
✅ **More Advanced Analytics**: Machine learning predictions for future sales.  
✅ **More Visuals**: Interactive PowerBI dashboards.  

---

## 📝 Author
👤 **Reet Chandra**  
📧 reetphy@gmail.com  
🔗 [LinkedIn](https://www.linkedin.com/in/reet-chandra/)  

---
