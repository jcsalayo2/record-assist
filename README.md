# Record Assist - Employee Management System

A modern, professional Flutter-based employee management system with real-time data synchronization and role-based access control.

## 🚀 Features

### 👥 User Management

- **Secure Authentication**: Email/password login with Firebase Auth
- **Role-Based Access**: Admin and Employee user roles
- **Automatic Routing**: Direct users to appropriate interface based on role

### 👔 Employee Management

- **Complete CRUD Operations**: Add, view, edit, and delete employee records
- **Real-Time Search**: Instant search by name, ID, or position
- **Organization Filtering**: Filter employees by assigned organization
- **Professional UI**: Material Design 3 with modern card-based layout

### 🏢 Organization Management (Admin Only)

- **Organization CRUD**: Create, view, edit, and delete organizations
- **Auto-Generated IDs**: Automatic document ID generation
- **Employee Assignment**: Link employees to organizations

### 🎨 Modern Design

- **Material Design 3**: Latest Material Design principles
- **Professional Typography**: Inter font family for clean readability
- **Responsive Layout**: Optimized for web deployment
- **Consistent Theming**: Professional blue color scheme with cyan accents

## 🛠 Technology Stack

- **Frontend**: Flutter (Web)
- **Backend**: Firebase (Firestore, Authentication)
- **Database**: Cloud Firestore
- **Authentication**: Firebase Auth
- **Styling**: Material Design 3 + Google Fonts (Inter)

## 📋 Prerequisites

- Flutter SDK (>=3.6.2)
- Firebase project with Firestore and Authentication enabled
- Google Fonts package

## 🚀 Quick Start

### 1. Clone the Repository

```bash
git clone <repository-url>
cd record_assist
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Firebase Configuration

1. Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
2. Enable Firestore Database and Authentication
3. Download the configuration files and place them in the project
4. Update `lib/firebase_options.dart` with your Firebase configuration

### 4. Run the Application

```bash
# For development
flutter run -d chrome

# For production build
flutter build web --release
```

### 5. Deploy to Firebase Hosting

```bash
firebase deploy --only hosting
```

## 📁 Project Structure

```
lib/
├── main.dart                 # App entry point and theme
├── firebase_options.dart     # Firebase configuration
└── screen/
    ├── page/
    │   ├── login_page.dart    # User authentication
    │   ├── employee_page.dart # Employee management
    │   ├── admin_page.dart   # Organization management
    │   └── register_page.dart # User registration
    └── widget/
        ├── employee_card.dart # Employee display card
        ├── add_employee_dialog.dart # Add employee modal
        ├── edit_employee_dialog.dart # Edit employee modal
        ├── organization_card.dart # Organization display card
        ├── add_organization_dialog.dart # Add organization modal
        └── edit_organization_dialog.dart # Edit organization modal
```

## 🗄 Database Schema

### Users Collection

```javascript
{
  email: string,
  uid: string,
  isAdmin: boolean,
  createdAt: timestamp,
  updatedAt: timestamp
}
```

### Employees Collection

```javascript
{
  employee_id: string,
  first_name: string,
  middle_name: string,
  last_name: string,
  address: string,
  position: string,
  civil_status: string,
  org_id: string,
  createdAt: timestamp,
  updatedAt: timestamp
}
```

### Organizations Collection

```javascript
{
  name: string,
  address: string,
  createdAt: timestamp,
  updatedAt: timestamp
}
```

## 👤 User Roles

### Employee User

- View and manage employee records
- Search and filter employees
- Add, edit, and delete employees
- Assign employees to organizations

### Admin User

- All employee user capabilities
- Manage organizations (CRUD operations)
- View system-wide organization data

## 🎯 Key Features Explained

### Real-Time Data Synchronization

- Live updates across all connected clients
- Stream-based architecture for instant data reflection
- Organization name resolution from foreign keys

### Advanced Filtering

- **Search**: Case-insensitive search across multiple fields
- **Organization Filter**: Dropdown to filter by specific organizations
- **Combined Filtering**: Both filters work together simultaneously

### Professional UI/UX

- Material Design 3 components
- Consistent spacing and typography
- Smooth animations and transitions
- Responsive card-based layouts

## 🔧 Development

### Adding New Features

1. Create widgets in `lib/screen/widget/` for reusable components
2. Add pages in `lib/screen/page/` for full-screen components
3. Follow Material Design 3 guidelines
4. Use consistent theming and styling

### Code Style

- Follow Flutter/Dart conventions
- Use descriptive variable and function names
- Implement proper error handling
- Add comments for complex logic

### Testing

```bash
# Run tests
flutter test

# Run widget tests
flutter test integration_test/
```

## 📱 Deployment

### Web Deployment

1. Build the application:

```bash
flutter build web --release
```

2. Deploy to Firebase Hosting:

```bash
firebase deploy --only hosting
```

3. Access your application at the provided URL

### Environment Configuration

- Development: Use `flutter run` for hot reload
- Production: Use `flutter build web --release` for optimized build
- Firebase: Configure project settings in Firebase Console

## 🔒 Security

- Firebase Authentication handles user verification
- Role-based access control for admin features
- Input validation on all forms
- Firestore security rules (to be implemented)

## 🐛 Troubleshooting

### Common Issues

**Build Errors**

```bash
flutter clean
flutter pub get
```

**Firebase Connection Issues**

- Verify Firebase configuration
- Check Firebase project settings
- Ensure proper authentication setup

**Data Not Loading**

- Check Firestore security rules
- Verify collection names match code
- Check network connectivity

### Debug Tips

- Use Flutter DevTools for debugging
- Check browser console for web-specific issues
- Verify Firebase project configuration

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 📞 Support

For support and questions:

- Create an issue in the repository
- Check the [Documentation](DOCUMENTATION.md) for detailed information
- Refer to [Flutter Documentation](https://flutter.dev/docs)
- Refer to [Firebase Documentation](https://firebase.google.com/docs)

## 🗺 Roadmap

### Version 1.1

- [ ] Mobile app deployment (iOS/Android)
- [ ] Advanced search and sorting
- [ ] Export functionality (CSV/PDF)
- [ ] User profile management

### Version 1.2

- [ ] Bulk operations (import/export)
- [ ] Audit trail for changes
- [ ] Email notifications
- [ ] Offline data synchronization

### Version 2.0

- [ ] Advanced analytics dashboard
- [ ] Multi-tenant support
- [ ] API integration capabilities
- [ ] Advanced reporting

---

**Built with ❤️ using Flutter and Firebase**

_Record Assist v1.0.0_
