# 🍽️ Flutter Restaurant Delivery App

**Built with GetX | Web-First UI | Responsive via ****************`flutter_bootstrap5`**************** | MVC Single-File Structure**

Welcome to the **next-gen delivery platform** for restaurants. This Flutter project is engineered for **scalability, modularity, and speed** — whether you're serving food across a city or scaling to an entire country.

It ships with:

* **💻 Customer Web App** – Browse menus, order food, track deliveries
* **📊 Admin Panel** – Control the business with precision
* **🛵 Driver App** – Get meals from A to B, fast
* **🧾 POS System** – Take in-person orders with style

> ⚙️ Built on **GetX** for streamlined state & navigation, styled with `flutter_bootstrap5` for mobile-first responsiveness, and organized using a **clean, scalable MVC single-file architecture**.

---

## 📚 Table of Contents

1. [🚀 Overview](#-overview)
2. [✨ Features](#-features)

   * [📱 Customer App](#customer-app)
   * [🛠️ Admin Panel](#admin-panel)
   * [🚚 Driver Panel](#driver-panel)
   * [🏧 POS System](#pos-system)
3. [⚙️ Installation & Setup](#-installation--setup)

   * [🧰 Flutter Setup](#flutter-setup)
   * [🔥 Firebase Integration](#firebase-integration)
   * [📦 Project Configuration](#project-configuration)
4. [🧪 How to Use](#-how-to-use)
5. [🤝 Contributing](#-contributing)
6. [🖼️ Screenshots](#-screenshots)

---

## 🚀 Overview

This isn't just an app — it's an **ecosystem**. A **full-stack Flutter-powered platform** that handles online orders, deliveries, dine-in traffic, and everything in between.

* 💡 **Web-first UI** that adapts beautifully across screens
* ⚡ Powered by **GetX** for state & navigation
* 🧱 **MVC** with each screen in a single file — no more messy folders
* 🧩 Modular, intuitive, and dev-friendly

---

## ✨ Features

Each feature now uses its own scaffold built with `CustomScrollView`, located under `widgets/`:

### 📱 Customer App

* 🍔 **Menu Browsing** – with filters and categories
* 🛍️ **Smart Checkout** – payment, promo codes, address book
* 🔔 **Real-time Order Updates** via Firebase Messaging
* 🧑 **User Accounts** – order history and saved data
* 🧱 **CustomerScaffold** – Layout built with `CustomScrollView`

### 🛠️ Admin Panel

* 📦 **Order Management** – live updates, drag-and-drop driver assignment
* 📋 **Menu CRUD** – full control over restaurant items
* 🧭 **Driver Tracker** – real-time tracking and logs
* 📊 **Analytics Dashboard** – graphs, charts, and downloadable reports
* 🧱 **AdminScaffold** – Admin layout using `CustomScrollView`

### 🚚 Driver Panel

* 🗂️ **Task Queue** – new jobs, assigned deliveries
* 🗺️ **Navigation** – Google Maps integration
* 💵 **Earnings Log** – see past gigs and payouts
* 🧱 **DriverScaffold** – Driver layout with `CustomScrollView`

### 🏧 POS System

* 🖥️ **Responsive UI** – fits mobile kiosks and desktops
* 📋 **Dine-in / Takeaway Toggle**
* 🧾 **Print-Ready Receipts**
* 📈 **Daily Sales Overview**
* 🧱 **PosScaffold** – POS interface using `CustomScrollView`

---

## ⚙️ Installation & Setup

### 🧰 Flutter Setup

1. Install [Flutter SDK](https://flutter.dev)
2. Run `flutter doctor`
3. Use VS Code or Android Studio with Flutter plugins

### 🔥 Firebase Integration

1. Set up a Firebase project
2. Register Android, iOS, and Web platforms
3. Add the config files:

   * `google-services.json` (Android)
   * `GoogleService-Info.plist` (iOS)
   * `firebase_options.dart` (Web)
4. Enable Firebase services:

   * Firestore
   * Authentication
   * Messaging (for push notifications)

### 📦 Project Configuration

1. Clone the repo
2. Run `flutter pub get`
3. Verify dependencies in `pubspec.yaml`:

   * `firebase_core`
   * `cloud_firestore`
   * `firebase_auth`
   * `get`
   * `flutter_bootstrap5`
4. Project structure:

```bash
lib/
├── main.dart                  # Entry point with GetMaterialApp
├── routes/                   # App routing via GetX
│   └── app_pages.dart
│   └── app_routes.dart
├── core/                     # Config, themes, constants
├── modules/                  # MVC Single-file screens
│   ├── customer/             # Customer-facing UI
│   ├── admin/                # Admin dashboard logic
│   ├── driver/               # Driver tools
│   └── pos/                  # Point-of-sale modules
├── widgets/                  # Shared components and layouts
│   ├── customer_scaffold.dart
│   ├── admin_scaffold.dart
│   ├── driver_scaffold.dart
│   ├── pos_scaffold.dart
│   └── etc
├── controllers/              # Global controllers (e.g., auth)
├── services/                 # Firebase helpers, APIs, etc.
```

---

## 🧪 How to Use

### 👨‍🍳 Customer App

```bash
flutter run -d chrome
```

* Explore menus
* Add items to cart
* Place orders and watch the magic happen (in real-time)

### 👩‍💼 Admin Panel

* Launch the admin route
* Manage every detail from menus to drivers
* View live analytics

### 🚴 Driver App

* Log in
* Accept orders
* Use integrated maps to navigate
* Track your income

### 🧾 POS System

* Open the POS module (preferably in kiosk/fullscreen mode)
* Process walk-ins or table orders
* Print receipts and track sales

---

## 🤝 Contributing

We’re building something big — and we’d love your help.

1. Fork the repo
2. Create a branch (use a smart name!)
3. Make magic ✨
4. Submit a PR

📌 Follow the MVC single-file rule
📝 Document your code
💬 Don’t be shy — leave clear comments

---

## 🖼️ Screenshots

Coming soon. Want to flex your setup? Submit a screenshot and we’ll showcase it here. 🚀
