# VegNonVeg App Clone 👟

A premium, high-fidelity Flutter clone of the VegNonVeg sneaker store application. This project demonstrates modern Flutter UI development, complex animations, and real-time data integration using Google Sheets as a backend CMS.

![Banner](https://img.shields.io/badge/Flutter-3.x-blue?style=for-the-badge&logo=flutter)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

## ✨ Features

- **Google Sheets CMS**: Dynamic product inventory managed entirely via Google Sheets API. App syncs titles, prices, images, and brand data in real-time.
- **Premium UI/UX**:
  - Custom "Shop the Look" horizontal card-fan animation (physics-based scroll effects).
  - Smooth transitions and hero animations for product details.
  - Minimalist, brand-aligned design using _Anton_ and _Inter_ typography.
- **Product Discovery**:
  - **Home**: Curated sections for Sneaker Launches, Apparel, and Trending items.
  - **Search**: Real-time search with brand aggregation and dynamic result counts.
  - **Shop**: Filterable grid view with lazy loading and cached network images.
- **E-Commerce Flow**:
  - Product Details: Size selection, "True to Size" fit slider, and related products.
  - Cart & Wishlist management (Provider-based state).
  - Checkout UI flow.

## 🛠️ Tech Stack

- **Framework**: [Flutter](https://flutter.dev/)
- **State Management**: [Provider](https://pub.dev/packages/provider)
- **Networking**: [Dio](https://pub.dev/packages/dio) & [Google APIs](https://pub.dev/packages/googleapis)
- **UI Components**:
  - `google_fonts` for typography.
  - `cached_network_image` for optimized image loading.
  - `flutter_animate` for entrance animations.
  - `go_router` for navigation.

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.0 or higher)
- Android Studio / Xcode for mobile emulation

### Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/chetan2921/vegnonveg-app.git
   cd vegnonveg
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

## 📱 Screenshots

| Home & Shop the Look |   Product Detail    |    Search & Shop    |
| :------------------: | :-----------------: | :-----------------: |
| _(Add screenshots)_  | _(Add screenshots)_ | _(Add screenshots)_ |

## 📁 Project Structure

```
lib/
├── core/             # Constants, theme, utility functions
├── data/             # Models, Providers, Services (GoogleSheetsService)
├── presentation/     # UI Layer
│   ├── screens/      # Home, Shop, Product Detail, Search, etc.
│   └── widgets/      # Reusable components
└── routes/           # App navigation config
```

## 🔧 Configuration

- **Android**: `INTERNET` permission and `usesCleartextTraffic` are configured for release builds.
- **iOS**: `NSAppTransportSecurity` allows arbitrary loads for maximum compatibility with image CDNs.

## 🤝 Contributing

Contributions are welcome! Please open an issue or submit a pull request for any improvements.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request
