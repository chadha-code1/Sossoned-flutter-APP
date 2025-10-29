# SosSoned - Water Service Management

A comprehensive Flutter mobile application for water service management, reclamation tracking, and technician coordination. This platform connects citizens, administrators, and technicians to efficiently manage water-related issues and service requests.

## 📱 App Preview

| User Reclamation | Technician View | Admin Dashboard | Real-time Tracking |
|------------------|-----------------|-----------------|-------------------|


## 👥 User Roles & Features

### 🏠 Citizens/Users
- **Submit Reclamations** with detailed issue reporting
- **Location Integration** - Automatic GPS capture of problem locations
- **Photo Evidence** - Upload images of water issues (leaks, damages, etc.)
- **Dossier Tracking** - Real-time status updates on reclamation progress
- **Push Notifications** - Receive alerts about water cuts and updates
- **History View** - Access all past reclamations

### 🔧 Technicians
- **Assigned Reclamations** - View tasks assigned by administrators
- **Appointment Management** - Schedule and manage site visits
- **Location Navigation** - GPS directions to problem locations
- **Status Updates** - Change reclamation status (In Progress, Completed, etc.)
- **Field Reporting** - Add notes and photos from site visits
- **Work Schedule** - Daily task list and calendar integration

### ⚙️ Administrators
- **User Management** - Add/remove users and technicians
- **Reclamation Oversight** - Review and validate all submitted claims
- **Technician Assignment** - Assign reclamations to specific technicians
- **Status Management** - Update dossier progression stages
- **Push Notification System** - Broadcast emergency alerts (water cuts, etc.)
- **Analytics Dashboard** - View statistics and performance metrics
- **Priority Management** - Set urgency levels for different reclamations

## ✨ Key Features

### 📋 Reclamation System
- **Multi-type Issues**: Water leaks, quality problems, service interruptions
- **Location-based Reporting**: Automatic GPS coordinates and address capture
- **Photo Documentation**: Upload multiple images as evidence
- **Detailed Descriptions**: Categorized issue reporting
- **Priority Assignment**: Urgent, High, Normal priority levels

### 🔄 Dossier Management
- **Status Tracking**: 
  - `Submitted` → `Under Review` → `Assigned` → `In Progress` → `Resolved` → `Closed`
- **Real-time Updates**: Live status changes across all users
- **Progress History**: Complete timeline of reclamation handling
- **Transparency**: Citizens can see exactly where their request stands

### 📢 Notification System
- **Water Cut Alerts**: Emergency notifications about service interruptions
- **Status Updates**: Notify users about dossier progress
- **Appointment Reminders**: Technician visit notifications
- **Broadcast Messages**: Company-wide announcements

### 🗺️ Location Services
- **GPS Integration**: Automatic location capture for reclamations
- **Map Views**: Visual representation of all active reclamations
- **Navigation Support**: Technicians get directions to problem sites
- **Zone Management**: Service area mapping and management

## 🛠 Tech Stack

**Frontend:**
- **Flutter** - Cross-platform framework
- **Dart** - Programming language
- **Provider/Bloc** - State management
- **Google Maps** - Location services

**Backend:**
- **Firebase Authentication** - Multi-role user management
- **Cloud Firestore** - Real-time database for reclamations
- **Firebase Storage** - Photo and file storage
- **Cloud Messaging** - Push notifications
- **Cloud Functions** - Backend logic and automation

**Key Packages:**
- `google_maps_flutter` - Map integration
- `image_picker` - Photo capture and selection
- `geolocator` - Location services
- `flutter_local_notifications` - Push notifications
- `cached_network_image` - Image caching
- `intl` - Date/time formatting
- `provider` - State management

## 🚀 Installation & Setup

### Prerequisites
- Flutter SDK (>=3.0.0)
- Firebase project setup
- Google Maps API key
- Physical device or emulator with location services
