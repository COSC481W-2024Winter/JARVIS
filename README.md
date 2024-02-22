## Introduction

# J.A.R.V.I.S
JARVIS is a Flutter-based phone app AI assistant designed to help people handle all their daily tasks like a human assistant, allowing them to focus more on important matters. The software may include, but is not limited to, summarizing and sending emails, assisting users in answering and making phone calls, and helping with the payment of utilities and insurance bills, among other tasks. Just as the name JARVIS suggests, we aim to make this software a comprehensive AI assistant like JARVIS in Iron Man, helping Tony Stark solve problems and manage daily activities.

## Project Layout

- **README.md**: This file, providing an overview of the project and setup instructions.
- **analysis_options.yaml**: Specifies the Dart analysis options for maintaining code quality.
- **android/**: Android application project files and configurations.
- **assets/**: Used to store static resources needed by the application, such as images, icons, fonts, videos, etc.
- **ios/**: iOS application project files and configurations.
- **lib/**: Contains Dart source files for the Flutter app, the core of the application logic.
- **lib/theme**: Contains a style.dart with my app theme which I access in the main.dart file
- **lib/services**: Holds some web APIs and native interaction code
- **lib/widgets**: Contains custom widgets which are used in multiple different screens
- **linux/**: Linux desktop application project files.
- **macos/**: MacOS desktop application project files.
- **module_design/**: Contains module design
- **profile/**: Configuration files used for profiling the app's performance.
- **pubspec.yaml** & **pubspec.lock**: Manage Flutter project dependencies and lock them to specific versions, respectively.
- **test/**: Test code for the application ensuring functionality works as expected.
- **web/**: Web application project files enabling the app to run in a browser.
- **windows/**: Windows desktop application project files.

## Setup Instructions

### Prerequisites

- Flutter SDK (Version: As per `pubspec.yaml` dependency, requires Flutter >=3.1.5 <4.0.0)
- Dart SDK (Version: Compatible with Flutter SDK version)
- Recommended Development Environment: Visual Studio Code

### Dependencies

The project uses the following main dependencies:

- `firebase_core: ^2.24.2`
- `cloud_firestore: ^4.14.0`
- `flutter: sdk`
- `cupertino_icons: ^1.0.2`

They will be downloaded in the 'Getting Started' Section. 

#### Optional Dependencies:
To modify the back-end database FlutterFire and Firebase CLI are required. To emulate an android phone Android Studio is required.
- FlutterFire: [FlutterFire Documentation](https://firebase.flutter.dev/docs/overview)
- Firebase CLI: [Firebase Command Line Interface Setup](https://firebase.google.com/docs/cli)
- Android Studio: [Download Android Studio](https://developer.android.com/studio)


### Getting Started

1. **Clone the Repository**
   ```bash
   git clone https://github.com/COSC481W-2024Winter/JARVIS.git
   cd JARVIS
   ```

2. **Setup Flutter Environment**
   - Ensure Flutter is installed and set up on your system. If not, follow the instructions on the [Flutter official website](https://flutter.dev/docs/get-started/install). We recommend following the VSCode path.
   - Run `flutter doctor` to ensure your environment is ready for Flutter development.

3. **Install Dependencies**
   ```bash
   flutter pub get
   ```
   This command installs all the necessary dependencies as defined in `pubspec.yaml`.

4. **Add google-services.json & GoogleService-Info.plist**
   - The project uses Firebase, ensure you have the ```google-services.json``` for Android and ```GoogleService-Info.plist``` for iOS in the appropriate directories. (You may need to acquire these files from a project administrator or set up Firebase for your own clone.)

6. **Open in VSCode**
   - Open the project folder in Visual Studio Code.
   - Ensure the Flutter and Dart extensions are installed in VSCode for the best development experience.

### Preferred Method of running the App

1. **Start an Emulator or Connect a Device**
   - Open your preferred emulator or connect a physical device to your computer.

2. **Run the App**
   ```bash
   flutter run
   ```
   This command compiles the app and launches it on the connected device or emulator. 

### Secondary Method of running the App

- **Web**: To run the app in a web browser, use `flutter run -d chrome` (ensure you have Chrome installed).


## The Team: J.A.R.V.I.S

### [Haohua Zheng](https://github.com/haohuazheng3) - Team Leader

I am a senior student at EMU, pursuing dual degrees in Computer Science and Entrepreneurship. I am proficient in languages like Java, Python, Javascript, Swift, and Dart. Additionally, I have initiated and developed several entrepreneurial projects with my business partners where my responsibilities include business development, UI design, and website development. These projects are showcased on my personal website www.haohuazheng.com.

### [Emily Marron](https://github.com/emarron) - Deputy Team Leader

I am a student of Data Science at EMU. I am graduating in April 2024. I have experience in adapting cutting-edge ML models (particularly image-based models) for end-users using component based development. I'm good with Python, R, Java, C++, etc., but am always looking to learn more languages. My personal projects are mostly in video game modding and I take commissions from there from time to time.

### [Jacob Yankee](https://github.com/JacobYankee) - Team Member

I am a Computer Science student at EMU with an expected graduation in April 2024. I am a transfer student from Michigan Technological University and a former member of Husky Game Development. I am familiar with Java, C#, Unity, Agile development, HTMl, CSS, JavaScript, PHP, and some AWS. My personal projects tend to be small games made in Unity.

### [Tyler Flinchum](https://github.com/TFlinchu) - Team Member

I am a Computer Science student at EMU, with an expected graduation in Winter 2024. Embracing the exciting world of AI and mobile app development, I'm eager to dive into new challenges and expand my skill set. A few languages I am proficient in are  Java, Python, C#, and MySQL, but I'm actively learning more. Beyond coding, I enjoy reading and gaming, which I have made a few mods for popular games such as 7DTD or Minecraft. Let's make an amazing experience!

### [Dayshia Sweet](https://github.com/dayshsweet) - Team Member

I am a Computer Science student at EMU and will be graduating Winter 2024. My interest is in backend development and I really enjoy working with Java and Python. Outside of school I also do commission artwork focusing on realism and I enjoy competitive gaming. Really excited to learn more about AI and Machine Learning with my team!

### [Luna Jia](https://github.com/Luna-Jia) - Team Member

I am a Computer Science student at Eastern Michigan University, graduating in Spring 2024, specializing in software engineering and database management. Skilled in Java, Python, and web development languages, I enjoy applying my knowledge to practical projects. Outside coding, my world revolves around cooking and gardening.
