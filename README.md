## InstaClone App
InstaClone is a social media app inspired by Instagram, built using Flutter and Firebase. This app allows users to create posts, comment on posts, like posts, perform seamless login and logout using Firebase authentication, search for other user profiles in real-time, and view their own profile.

The project is designed to be cross-platform, supporting iOS, Android, macOS, Windows, Web, and Linux platforms using Flutter's multi-platform capabilities.

## Features
### User Authentication
- Login and Registration: Users can sign up for a new account or log in with existing credentials.
- Logout: Users can securely log out of their accounts.
### Post Management
- Create Posts: Users can create new posts with images and captions.
- Like Posts: Users can like posts from other users.
- Comment on Posts: Users can add comments to posts.
### User Profiles
- View Own Profile: Users can view their own profile with their posts and other information.
- Search Other Profiles: Users can search for and view profiles of other users.
### Real-Time Features
- Real-Time Searching: Search functionality is implemented using Firebase Firestore to show live search results as the user types.
- Real-Time Post Updates: Posts, likes, and comments are updated in real-time using Firebase Firestore and Firebase  Realtime Database.

## Technologies Used
- Flutter: Cross-platform framework for building native interfaces on iOS, Android, macOS, Windows, Web, and Linux.
- Firebase Authentication: For user authentication and secure login/logout functionality.
- Firebase Firestore: Real-time NoSQL database for storing and syncing app data.
- Firebase Storage: For storing user-uploaded images for posts.
- Firebase Realtime Database: Real-time database to handle likes, comments, and real-time updates.
- Flutter Packages: Utilized various Flutter packages for UI design, state management, and Firebase integration.
Getting Started

#### To run this project locally and test it on your device or simulator, follow these steps:

- Clone this repository to your local machine:


```bash
git clone https://github.com/abhishekbiswas772/instagram_clone.git
```

- Navigate to project dir
```bash
cd instagram_clone
```

- Ensure Flutter is installed on your system. If not, follow the Flutter installation guide.

- Set up Firebase project and add Firebase configuration files (google-services.json for Android, GoogleService-Info.plist for iOS) to the project. Follow the Firebase setup guide for Flutter for detailed instructions.

- Run the app on your preferred device (emulator, simulator, or physical device):

```bash
flutter run
```

### Contributing
- Contributions are welcome! If you have suggestions, feature requests, or want to report a bug, please open an issue or submit a pull request.
