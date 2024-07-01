# WellNash

## Introduction
WellNash is an automated workout generator tailored for the Utown gym at the National University of Singapore (NUS). This application customizes workout routines based on workout duration, past performances, injuries, and the gym equipment available.

## Motivation

As undergraduate students at the National University of Singapore (NUS), we have dealt with the constraints imposed by our hectic schedules and the limits of the UTown Gym. Due to responsibilities, the amount of time available for gym use varies greatly each day. Furthermore, the UTown Gym is overcrowded, and equipment is frequently unavailable, resulting in long waits. This makes it difficult for gymgoers to maintain a viable regiment that maximises their benefits.

Recognizing these limitations, we intend to use technology to make the gym experience more accessible, efficient, and personalised for all.

## Aim

Our main goal is to make the gymgoing experience more enjoyable and effective. We will achieve this by automating the process of machine/weight selection and creating personalised workout plans through our intelligent workout plan generator and real-time adaptive workout modifier. This not only enhances the gym experience but also maximises workout effectiveness for individuals. The app keeps track of past performance and future body goals as it suggests the workout in real-time.

Our long-term goal would be to branch out to other gyms besides the UTown gym. This could be achieved by coordinating with major gym franchises (Anytime Fitness, Fitness First etc.) to receive information regarding the types and number of machines across different branches.

## User Stories

### New Gymgoer
As a brand new gymgoer, I want the personalised workout plan generator to create beginner-friendly routines that introduce me to different types of exercises and gradually increase in intensity, so I can build confidence and see progress in my fitness journey.

### Experienced Athlete
As an experienced athlete, I want the personalised workout plan generator to offer advanced training routines that challenge me and help me break through plateaus, incorporating periodization and advanced techniques to optimise my performance and gains.

### Recovering from Serious Injury
As someone recovering from a serious injury, I want the progress tracking feature to monitor my rehabilitation exercises and provide adaptive workouts that gradually reintroduce intensity and volume, ensuring I regain strength and mobility safely and efficiently.

### Busy Professional
As a busy professional, I want the real-time equipment availability feature to notify me of crowded times at the gym and suggest alternative exercises or equipment to use, so I can maximise my workout time and adapt my routine to fit my schedule.

### Fitness Enthusiast with Limited Time
As a fitness enthusiast with limited time, I want the personalised workout plan generator to create efficient, time-sensitive routines that deliver maximum results in minimum time, allowing me to stay consistent with my workouts despite a busy lifestyle.

### Travelling Fitness Buff
As a fitness enthusiast who travels frequently, I want the real-time equipment availability feature to help me find gyms with the necessary equipment for my workout plan in unfamiliar locations, ensuring I can stick to my fitness regimen no matter where I am.

### Social Fitness Competitor
As someone who thrives on social interaction and competition, I want the progress tracking feature to allow me to compare my workout stats and achievements with friends or other users, motivating me to push harder and achieve better results.


# Features

## 1. Personalised Workout Plan Generator

**Overview:** 
The Personalised Workout Plan Generator utilises AI to create daily workout plans tailored to the user’s fitness goals, preferences, and the equipment they have access to. It adjusts the difficulty and variety of exercises over time based on user progress, providing a dynamic and personalised fitness journey. Background research shows that personalised plans significantly increase user engagement and adherence to fitness routines.

**Strategic Alignment:** 
This feature aligns with our goal to offer a highly personalised fitness experience, increasing user engagement and satisfaction. By catering to individual needs, we aim to boost retention and expand our user base.

**Who it Benefits:**
- **New Gymgoer:** Helps build confidence and progress in their fitness journey.
- **Experienced Athlete:** Offers advanced routines to challenge and optimise performance.
- **Fitness Enthusiast with Limited Time:** Creates efficient routines for busy lifestyles.

**User Challenge:** 
Users often struggle with creating effective workout plans that align with their goals and experience level. Many resort to generic plans or lack structure, leading to suboptimal results and loss of motivation.

**Value Score:** 9/10  
**Design / UX:** 



![Activities](https://github.com/avinazz3/wellnash_4/assets/47024210/1d2caa0c-aef2-459d-a129-077d2b5dd0d9)




**Notes:** 

## 2. Progress Tracking and Adaptive Workouts

**Feature Name:** Progress Tracking and Adaptive Workouts

**Overview:** 
Tracks user progress in terms of exercises completed, weights used, and personal achievements. The system uses this data to adapt future workout plans, applying the principle of progressive overload for consistent improvement. Background research highlights the importance of tracking progress for sustained motivation and goal achievement.

**Strategic Alignment:** 
Supports our commitment to personalised fitness experiences and continuous improvement. By adapting workouts based on progress, we help users achieve their fitness goals more effectively, driving user retention and satisfaction.

**Who it Benefits:**
- **Recovering from Serious Injury:** Monitors rehabilitation and ensures safe progress.
- **Social Fitness Competitor:** Allows comparison with friends and enhances motivation.

**User Challenge:** 
Users often lack a systematic way to track and adapt their progress, leading to plateaus and loss of motivation. Current solutions include manual logging, which can be inconsistent and time-consuming.

**Value Score:** 9/10  
**Design / UX:** 



![Fitness App (Community)](https://github.com/avinazz3/wellnash_4/assets/47024210/f9aba401-8169-41fd-afa9-45cf1f29103c)



**Notes:** We would like to implement social sharing features to boost community engagement.

## Technology Stack
- **Flutter:** For cross-platform mobile application development.
- **PostgreSQL:** Provides backend services including authentication, database management, and hosting.
- **Dart:** The programming language used for developing the application.


## Other Mockups

# Project Setup

### Prerequisites
- Ensure you have Flutter installed on your machine. Follow the [Flutter installation guide](https://flutter.dev/docs/get-started/install).
- 
### Install dependencies:
```bash
flutter pub get
```
## Running the Project

To get the project up and running on your local machine, follow these steps:

### Clone the repository:
```bash
git clone https://github.com/yourgithub/wellnash4.git
```

### Ensure the backend is running:
```bash
cd wellnash4/backend_server
node src/index.js
```

### Run the application:
```bash
flutter run
```
## Current Progress
Currently, WellNash has a fully functional login system that enables users to sign up and log in. We have also completed the core functionalities such as workout generation, injury management, and profile creation.

## Contact
For more information, questions, or feedback, please contact us at [avimcm77@gmail.com]

