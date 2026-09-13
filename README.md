# Shopify Flutter E-Commerce Catalog App

A new Flutter project and modular e-commerce application built as part of a technical assessment. The application consumes the **DummyJSON API** to deliver a smooth, responsive shopping catalog experience with clean architecture, robust error handling, and server-side search optimization.

---
## Key Features

* **Product Catalog & Grid View:** Displays products in a responsive 2-column grid with custom styling and optimized image caching.
* **Server-Side Search with Debouncing:** Integrates the DummyJSON search endpoint with a **500ms client-side debounce** to minimize network overhead and provide a snappy search experience.
* **Infinite Scroll Pagination:** Seamlessly loads more products as the user scrolls down, complete with a dedicated pagination loader and inline error/retry recovery.
* **Modular "Widgets-First" Architecture:** Presentation components are cleanly decoupled into standalone reusable widget files (`product_card`, `empty_state_widget`, `error_state_widget`, `pagination_loader_widget`).
* **Rich Product Detail View:** Detailed breakdown of product imagery, descriptions, pricing, and aggregate ratings.
* **Comprehensive State Management:** Gracefully handles **Loading**, **Success**, **Empty**, **Network Error (with Retry)**, and **Pagination Error** states.
* **UX Polish:**
    * Tap the App Bar title ("Shopify") to instantly animate and scroll back to the top of the list.
    * Dynamic item counter that gracefully resets to 0 during network errors.
* **Unit Testing:** Includes automated unit testing for model deserialization to verify API data mapping integrity.


---

## Tech Stack & Architecture

* **Framework:** Flutter / Dart
* **Network & Parsing:** `http` / Custom `ApiService` with robust exception handling.
* **Image Caching:** `cached_network_image` for memory-efficient loading, placeholders, and error-fallback handling.
* **Testing:** `flutter_test` framework.

---

## Key Engineering Decisions

### 1. Search Strategy: Server-Side with 500ms Debounce
* **Why Server-Side?** Production catalogs scale to thousands of items. Offloading search queries to the backend (`/products/search?q={query}`) ensures the client remains lightweight and scalable instead of filtering locally in memory.
* **Why Debounce?** A 500ms delay protects backend resources and avoids redundant API calls during rapid user keystrokes.

### 2. State-Driven UI Decomposition
* Separating UI states into isolated widget components keeps `ProductListScreen` lightweight and focused exclusively on business logic, routing, and lifecycle management.

### 3. Testing Scope
* Unit testing is focused entirely on **Model JSON Deserialization**. Isolating data mapping ensures fast, deterministic tests without network flakiness.

### 4. Bottom-Up Architecture
* **Approach:** Adopted a component-driven workflow, building isolated, single-responsibility atomic widgets (`ProductCard`, `EmptyStateWidget`, `ErrorStateWidget`, `PaginationLoaderWidget`) *before* composing them into full-screen views (`ProductListScreen`, `ProductDetailScreen`).
* **Why:** This bottom-up strategy ensures high modularity and reusability, cleanly separating presentation building blocks from layout containers and making individual components straightforward to maintain and test.

---

## Getting Started

### Prerequisites
* **Flutter SDK** (Stable Channel)
* **Android Studio / Xcode** (for emulator or physical device execution)

### Installation & Execution
1. Clone the repository and navigate to the project directory.
2. Install dependencies:
   ```bash
   flutter pub get
3. Run the application:
    ```bash
   flutter run
4. Running Tests
   Execute the automated test suite via terminal:
    ```bash
   flutter test
---

## How to Use the App

1. **Browse the Catalog:** Upon launching, the app fetches and displays products in a clean 2-column grid layout with image loading placeholders.
2. **Search Products:** Type keywords (e.g., *"phone"*, *"shoes"*) into the search bar at the top. The app debounces input for 500ms before querying the server and dynamically updates the item count header.
3. **View Product Details:** Tap on any product card to open the **Product Detail Screen**, which shows high-resolution images, pricing, ratings, and descriptions. Use the back arrow to return to the catalog.
4. **Infinite Scrolling:** Scroll down near the bottom of the catalog to automatically trigger pagination and load more products.
5. **Quick Return to Top:** Tap the **"Shopify"** title in the top App Bar at any time to smoothly animate and scroll back to the top of the list.
6. **Pull-to-Refresh:** Pull down from the top of the product grid to refresh the catalog feed.
7. **Error & Empty States:**
    * Search for a non-existent item (e.g., *"xyzabc"*) to view the **Empty State**.
    * Disconnect your internet and pull-to-refresh to test the **Network Error State** with a functional **Retry** button.

---   


## Acknowledgments & AI Usage

AI tooling was utilized as a collaborative assistant for the following tasks:
* **Research & Learning:** Exploring and understanding unfamiliar engineering concepts and terminology, such as implementing server-side search debouncing.
* **Visual Prototyping:** Utilizing mockups created in Google Stitch to visualize the layout and user experience flow prior to implementation.
* **Documentation:** Assisting in structuring and drafting the project README documentation.

---


## TODO / Future Improvements


* **Offline Caching**: Integrate a local database (like Hive or SQLite/sqflite) to cache API responses, allowing users to browse previously loaded products even when completely offline.

* **Shopping Cart Module**: Implement local cart state management to allow users to add items, adjust quantities, and view a mock checkout flow.

---------------------------------------------------------------------