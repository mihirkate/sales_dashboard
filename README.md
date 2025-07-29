# sales_dashboard_app

# Sales Dashboard App

A comprehensive Flutter dashboard application for sales data visualization and management. This app provides responsive design across mobile, tablet, and desktop platforms with interactive charts, advanced filtering, and data export capabilities.

## 🚀 Features

### 📱 Responsive Design
- **Mobile**: Optimized single-column layout with bottom navigation
- **Tablet**: Two-column layout for better space utilization
- **Desktop**: Multi-column layout with enhanced navigation

### 📊 Interactive Charts & Analytics
- **Revenue Charts**: Line charts showing monthly revenue trends
- **Sales Trends**: Interactive bar charts with touch/hover feedback
- **Pie Charts**: Revenue distribution by city/region
- **Monthly Leads**: Lead generation performance tracking

### 🔍 Advanced Search & Filtering
- **Real-time Search**: Search across names, cities, industries, and more
- **Smart Suggestions**: API-powered search suggestions
- **Multi-criteria Filters**:
  - Cities, Status, Industries
  - Date range picker
  - Revenue and probability ranges
  - Advanced filter combinations

### 📋 Data Management
- **Sortable Tables**: Click column headers to sort by any field
- **Pagination**: Configurable rows per page (5, 10, 25, 50)
- **Responsive Tables**: Card layout on mobile, full table on desktop
- **Status Indicators**: Color-coded status chips

### 📤 Data Export
- **CSV Export**: Export filtered data to CSV format
- **Custom Fields**: Select specific fields for export
- **Local Fallback**: Works offline with local data

### 🌙 Theme Support
- **Dark/Light Mode**: Toggle between themes
- **Persistent Settings**: Theme preference saved locally
- **Smooth Transitions**: Animated theme switching

### 📱 Navigation
- **Bottom Navigation** (Mobile): Dashboard, Analytics, Data tabs
- **Tab Interface**: Organized content sections
- **Breadcrumbs**: Clear navigation hierarchy

## 🏗️ Architecture

### Project Structure
```
lib/
├── main.dart                    # App entry point with theme provider
├── models/
│   └── sales_data.dart         # Data models and filters
├── screens/
│   ├── dashboard_screen.dart            # Original dashboard
│   ├── dashboard_screen_new.dart        # Alternative dashboard
│   └── enhanced_dashboard_screen.dart   # Main enhanced dashboard
├── services/
│   ├── api_service.dart        # API communication
│   ├── theme_service.dart      # Theme management
│   └── export_service.dart     # Data export utilities
├── utils/
│   └── responsive_helper.dart  # Responsive design utilities
└── widgets/
    ├── metrics_card.dart       # Metric display cards
    ├── metrics_overview.dart   # Metrics summary widget
    ├── search_bar_widget.dart  # Search with suggestions
    ├── filter_dialog.dart      # Advanced filter interface
    ├── sort_dropdown.dart      # Sorting controls
    ├── sales_data_table.dart   # Data table with pagination
    └── [chart widgets...]      # Various chart components
```

### Key Services

#### ApiService
Handles all backend communication:
- `fetchSalesDashboard()` - Get sales data with filters
- `fetchMetrics()` - Dashboard summary metrics
- `fetchMonthlySales()` - Monthly sales trends
- `fetchTrends()` - Sales trends data
- `fetchAdvancedFilters()` - Available filter options
- `fetchSearchSuggestions()` - Search autocomplete
- `exportData()` - Server-side CSV export

#### ThemeService
Manages application themes:
- Persistent theme storage
- Light/dark theme definitions
- Smooth theme transitions

#### ExportService
Local data export functionality:
- CSV generation from filtered data
- Custom field selection
- File system management

### Responsive Breakpoints
- **Mobile**: < 600px width
- **Tablet**: 600px - 900px width
- **Desktop**: > 900px width

## 🔗 API Integration

### Backend Endpoints
The app integrates with the following API endpoints:

- `GET /api/v1/dashboard/sales-dashboard` - Sales data with filtering
- `GET /api/v1/dashboard/metrics` - Summary metrics
- `GET /api/v1/dashboard/monthly-sales` - Monthly trends
- `GET /api/v1/dashboard/trends` - Sales trends
- `GET /api/v1/dashboard/advanced-filter` - Filter options
- `GET /api/v1/dashboard/search-suggestions` - Search suggestions
- `GET /api/v1/dashboard/analytics` - Custom analytics
- `GET /api/v1/dashboard/export` - Data export

### Query Parameters
- `search` - Text search across fields
- `cities`, `statuses`, `industries` - Multi-select filters
- `startDate`, `endDate` - Date range filtering
- `minRevenue`, `maxRevenue` - Revenue range
- `minProbability`, `maxProbability` - Probability range
- `sortBy`, `sortOrder` - Sorting configuration
- `limit`, `offset` - Pagination

## 📦 Dependencies

### Core Dependencies
```yaml
dependencies:
  flutter: sdk
  http: ^1.1.0              # API communication
  fl_chart: ^0.66.0         # Interactive charts
  google_fonts: ^6.1.0     # Typography
  intl: ^0.19.0            # Internationalization
  provider: ^6.1.1         # State management
  shared_preferences: ^2.2.2 # Local storage
  
  # File & Export
  file_picker: ^8.0.0+1    # File selection
  path_provider: ^2.1.1    # Path utilities
  csv: ^6.0.0              # CSV generation
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>= 3.8.1)
- Dart SDK
- Android Studio / VS Code
- Android/iOS device or emulator

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd sales_dashboard_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the application**
   ```bash
   # Debug mode
   flutter run
   
   # Release mode
   flutter run --release
   
   # Specific platform
   flutter run -d chrome        # Web
   flutter run -d android       # Android
   flutter run -d ios          # iOS
   ```

### Configuration

#### API Base URL
Update the base URL in `lib/services/api_service.dart`:
```dart
static const String baseUrl = 'YOUR_API_BASE_URL/api/v1/dashboard';
```

#### Theme Customization
Modify themes in `lib/services/theme_service.dart`:
```dart
ThemeData get lightTheme => ThemeData(
  // Your light theme configuration
);

ThemeData get darkTheme => ThemeData(
  // Your dark theme configuration
);
```

## 🎯 Usage

### Dashboard Navigation
1. **Dashboard Tab**: Overview with metrics and key charts
2. **Analytics Tab**: Detailed charts and trend analysis
3. **Data Tab**: Full data table with advanced controls

### Search & Filter
1. Use the search bar for quick text-based filtering
2. Click the filter icon for advanced multi-criteria filtering
3. Use sort dropdown to order data by any field
4. Clear filters with the "Clear Filters" button

### Data Export
1. Apply desired filters and search criteria
2. Click the export button (download icon)
3. Data will be exported as CSV to your device
4. Success message shows file location

### Theme Switching
- Click the sun/moon icon in the app bar
- Theme preference is automatically saved
- Supports system theme detection

## 🔧 Customization

### Adding New Chart Types
1. Create widget in `lib/widgets/`
2. Integrate with `fl_chart` package
3. Add to appropriate dashboard section
4. Connect to API data source

### Extending Filters
1. Add filter fields to `DashboardFilter` model
2. Update `FilterDialog` widget
3. Modify API service query parameters
4. Test with backend integration

### Custom Export Formats
1. Extend `ExportService` class
2. Add format options to export dialog
3. Implement format-specific generation
4. Update file extension handling

## 🐛 Troubleshooting

### Common Issues

#### Build Errors
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter run
```

#### API Connection Issues
- Verify base URL in `api_service.dart`
- Check network connectivity
- Validate API endpoint responses
- Review CORS settings for web deployment

#### Chart Rendering Issues
- Ensure `fl_chart` dependency is updated
- Check data format compatibility
- Verify responsive layout constraints

### Performance Optimization
- Use `const` constructors where possible
- Implement proper list pagination
- Optimize image assets
- Use `RepaintBoundary` for complex charts

## 📱 Platform Support

- **Android**: API level 21+ (Android 5.0+)
- **iOS**: iOS 11.0+
- **Web**: Modern browsers with ES6 support
- **Windows**: Windows 10+
- **macOS**: macOS 10.14+
- **Linux**: Ubuntu 18.04+

## 🤝 Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- fl_chart package for interactive charts
- Google Fonts for typography
- Contributors and testers

---

**Built with ❤️ using Flutter**

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
