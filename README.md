# EyeLearn Flutter

![img1](https://github.com/PexWave/eyelearn-flutter/assets/139829241/88574452-19a8-44fd-87a4-4528f2c23246)
![img2](https://github.com/PexWave/eyelearn-flutter/assets/139829241/4df18ef3-8523-4042-8442-f0c5e8bfa3f9)'
![img3](https://github.com/PexWave/eyelearn-flutter/assets/139829241/4029e818-a6b1-47f2-a7f5-f49a5299fed8)
![img4](https://github.com/PexWave/eyelearn-flutter/assets/139829241/de6d6a61-6d45-4acd-a69a-3bbfb1777497)

EyeLearn is a Flutter app designed to facilitate learning basic grammar for primary school pupils with visual impairment, specifically catering to grades 1 to 4. It leverages OpenAI's Whisper model for accurate and natural speech synthesis, creating a dynamic and engaging learning experience. The app incorporates voice commands for intuitive navigation and uses PocketSphinx for reliable voice recognition.

## Key Features

- **Voice Commands**: Use voice prompts for navigation and interaction, making the app intuitive and user-friendly.
- **Text-to-Speech**: OpenAI's Whisper model provides accurate and natural speech synthesis.
- **Visual Reinforcement**: Synthesized lesson text is displayed on the screen for better understanding and retention.

## Contents

### Lessons
- Grammar
- Vocabulary
- Oral Skills
- Intonation

### Practices
- Intonation
- Listening Comprehension
- Grammar
- Spelling

## How It Works

1. **Voice Command Detection**:
   - The app uses PocketSphinx to actively listen for a designated keyword.
   - Upon detecting the keyword, a corresponding function in Flutter is triggered to initiate the audio recording process.

2. **Audio Processing**:
   - The recorded audio is transmitted to a Django Ninja API for advanced processing.
   - The API handles the received audio data, interpreting and responding to voice commands effectively.

3. **Interactive Learning**:
   - Users can navigate the app and participate in quizzes using voice commands.
   - Spoken answers during quizzes are processed by the Django Ninja API, enhancing the app's versatility.

## Tech Stack

- **Frontend**: Flutter
- **Backend**: Django Ninja
- **Database**: PostgreSQL
- **Voice Recognition**: PocketSphinx
- **Text-to-Speech**: OpenAI Whisper

## Hardware Requirements

- **Operating System**: Android 11 and above

## Getting Started

### Prerequisites

- Flutter SDK
- Django Ninja setup
- PostgreSQL database

### Installation

1. **Clone the Repository**:
    ```bash
    git clone https://github.com/PexWave/eyelearn-flutter.git
    cd eyelearn-flutter
    ```

2. **Install Dependencies**:
    ```bash
    flutter pub get
    ```

3. **Set Up Environment Variables**:
    Create a `.env` file and add your configuration details, including the Django Ninja API URL and database credentials.

4. **Run the App**:
    ```bash
    flutter run
    ```

