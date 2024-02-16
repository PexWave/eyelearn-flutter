# eyelearn-flutter
 An e-learning app based on flutter

This Android app is designed to facilitate learning basic grammar for primary school pupils, specifically catering to grades 1 to 4. It leverages OpenAI's Whisper model for accurate and natural speech synthesis, creating a dynamic learning experience. The app incorporates voice commands for intuitive navigation and uses PocketSphinx for reliable voice recognition.

As part of the app's functionality, text from the synthesized lessons is displayed on the screen, providing a visual reinforcement of the spoken content. The combination of interactive voice commands and visually presented text enhances the learning process, making it both educational and fun for primary school students.

 CONTENTS:
     Lessons:
         Grammar
         Vocabulary
         Oral
         Intonation
         
     Practices:
         Intonation
         Listening Comprehension
         Grammar
         Spelling

 HOW IT WORKS:
In my Flutter app, I employ PocketSphinx to actively listen for a designated keyword. When the keyword is detected, a corresponding function in Flutter is invoked to initiate the audio recording process. The recorded audio is subsequently transmitted to a Django Ninja API for advanced processing.

This approach forms the foundation for implementing voice commands within the app, serving both navigation and quiz-related functionalities. Users can effortlessly interact with the app using voice prompts, creating a more intuitive and engaging user experience.

The Django Ninja API plays a crucial role in handling the received audio data. It processes the information, allowing the app to interpret and respond to voice commands effectively. This mechanism not only facilitates seamless navigation but also enables users to provide spoken answers during quizzes, enhancing the app's versatility.



TECH STACK:
Django Ninja
Flutter
Postgresql


HARDWARE REQUIREMENTS:
   ANDROID 11 and above 

