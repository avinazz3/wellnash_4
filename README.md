# WellNash

## Introduction
WellNash is an automated workout generator tailored for the Utown gym at the National University of Singapore (NUS). This application customizes workout routines based on workout duration, past performances, injuries, and the gym equipment available.

## Features
- **User Authentication:** Implemented using Supabase Authentication to manage user access.
- **Custom Workout Generation:** Automatically generates workouts based on user profiles.
- **Injury Management:** Provides injury-conscious workout recommendations.
- **Performance Tracking:** Integrates with fitness tracking data to adapt workouts to user progress.
- **Workout Customisation:** Ability to edit workouts (add set, exercise) and allows for rest in between exercises as well
- **Workout Log:** Ability to access past workouts and data to observe progress 


## Technology Stack
- **Flutter:** For cross-platform mobile application development.
- **Supabase:** Provides backend services including authentication, database management, and hosting.
- **Dart:** The programming language used for developing the application.

# How to Run the App

Ensure that you have Flutter installed on your console.

To install Flutter, follow these steps:

### On macOS
```brew install --cask flutter```

### On Windows
```choco install flutter```

### On Linux
```sudo snap install flutter --classic```

## Install Dependencies
```flutter pub get```

## Run Flutter
```flutter run```

If you are using the iOS emulator, ensure that you use R (hot restart) or Q (Quit) if the app is not functioning.

# How to Launch an App on GitHub Pages

## Prerequisites

- A GitHub account
- Git installed on your local machine

## Steps to Launch

1. **Create a GitHub Repository**:
   - Go to [GitHub](https://github.com) and create a new repository.
   - Name your repository (e.g., `my-app`).
   - Initialize the repository with a README file.

2. **Add Your App Files**:
   - Clone your repository to your local machine:
     ```sh
     git clone https://github.com/your-username/my-app.git
     cd my-app
     ```
   - Add your app files (HTML, CSS, JS) to the repository folder.

3. **Push Your Files to GitHub**:
   - Add and commit your changes:
     ```sh
     git add .
     git commit -m "Initial commit"
     ```
   - Push the changes to your GitHub repository:
     ```sh
     git push origin main
     ```

4. **Configure GitHub Pages**:
   - Go to your repository on GitHub.
   - Click on the `Settings` tab.
   - Scroll down to the `Pages` section.
   - Under `Source`, select the branch you want to use (e.g., `main`) and the folder (e.g., `/root` or `/docs`).
   - Click `Save`.

5. **Access Your Published Site**:
   - GitHub Pages will build and publish your site. This can take a few minutes.
   - Once published, GitHub will provide a URL for your site (e.g., `https://your-username.github.io/my-app`).

## Additional Resources

- [GitHub Pages Documentation](https://docs.github.com/en/pages)
- [GitHub Pages Configurations](https://pages.github.com/)


## Contact
For more information, questions, or feedback, please contact us at [avimcm77@gmail.com]
