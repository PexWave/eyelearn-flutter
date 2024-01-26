import 'package:go_router/go_router.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:namer_app/custom_color.dart';
import 'package:namer_app/pupil/lesson/GRAMMAR/grammar_lessons/adjectives.dart';
import 'package:namer_app/pupil/lesson/ORAL/oralLandingPage.dart';
import 'package:namer_app/pupil/lesson/VOCABULARY/vocabularyLandingPage.dart';
import 'package:namer_app/pupil/pupilHompage.dart';
import 'main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stroke_text/stroke_text.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'pupil/lesson/GRAMMAR/grammarLandingPage.dart';

import 'package:namer_app/pupil/lesson/GRAMMAR/grammar_lessons/nouns.dart';
import 'package:namer_app/pupil/lesson/GRAMMAR/grammar_lessons/pronoun.dart';
import 'package:namer_app/pupil/lesson/GRAMMAR/grammar_lessons/verb.dart';
import 'package:namer_app/pupil/lesson/GRAMMAR/grammar_lessons/adjectives.dart';


import 'pupil/lesson/GRAMMAR/grammar_lessons/verb.dart' as grammarVerb;
import 'pupil/lesson/INTONATION/intonationLandingPage.dart';
import 'pupil/practice/grammarPractice.dart';
import 'pupil/practice/intonationPractice.dart';
import 'pupil/practice/listeningComprehensionPractice.dart';
import 'pupil/practice/grammar_practice/nounPractice.dart';
import 'pupil/practice/grammar_practice/pronounPractice.dart';
import 'pupil/practice/grammar_practice/verbPractice.dart';
import 'pupil/lessonPage.dart';
import 'pupil/practicePage.dart';



class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
  
}

class _LandingPageState extends State<LandingPage> {
  MethodChannel platform = MethodChannel('com.learnhear/speechrecognition');


  VoiceNavigationState? voiceNavigationState;
  
  Completer<void>? completer;
  Completer<void>? completer2;


  int maxTries = 3;

  String? command = '';


  bool check_internet_connection = false;

@override
  void initState() {
  super.initState();
  completer = Completer<void>();
  completer2 = Completer<void>();
  navigateForward();
  } 


@override
void didChangeDependencies() {
  super.didChangeDependencies();
    voiceNavigationState = Provider.of<VoiceNavigationState>(context, listen: true);

  WidgetsBinding.instance!.addPostFrameCallback((_) {
    voiceNavigation();
  });

}


void voiceNavigation() {
   command = voiceNavigationState!.navigationCommand;


  if (command == '') {
    return;
  }

  // previousPage == '' || previousPage == 'none' ? previousPage = command : previousPage = previousPage;

  if(voiceNavigationState!.previousPage == '' || voiceNavigationState!.previousPage == 'none') {
    voiceNavigationState!.setPreviousPage(command);
  }
  else{
    voiceNavigationState!.setPreviousPage(voiceNavigationState!.previousPage);
  }


    print("current ${voiceNavigationState!.previousPage}");


  switch (voiceNavigationState!.previousPage) {

    case "main menu":
      _navigateToMainMenu();
      break;

    case "grammar":
      _navigateToGrammar();
      break;

    case "vocabulary":
      _navigateToVocabulary();
      break;

    case "oral":
      _navigateToOral();
      break;

    case "intonation":
      _navigateToIntonation();
      break;

    case "practice":
      _navigateToPractice();
      break;


    case "none":
      wrongChoice();
      break;
      
  }
}

void switchToManual() async {
   completer = Completer<void>();
   await playaudio('assets/guide_speaker/switch_to_manual.mp3',completer);
   await completer!.future;
   return;
}

void wrongChoice() async {
  
 
    switchToManual();
    return;
  


}

void _navigateToMainMenu() {
  context.push('/');

}

void _navigateToGrammar() {
  if (!voiceNavigationState!.isNavigatedGrammar) {
    context.push('/pupilHompage/grammar');
    voiceNavigationState!.setIsNavigatedGrammar(true);

    return;
  }

  voiceNavigationState!.setCurrentPage(command);

      print("current ${voiceNavigationState!.currentPage}");


  if (voiceNavigationState!.currentPage == 'noun') {
     context.push('/pupilHompage/grammar/noun');
  }

  if (voiceNavigationState!.currentPage == 'pronoun') {
    context.push('/pupilHompage/grammar/pronoun');
  }

  if (voiceNavigationState!.currentPage == 'verb') {
     context.push('/pupilHompage/grammar/verb');

  }

   if (voiceNavigationState!.currentPage == 'adjectives' || voiceNavigationState!.currentPage == 'adjective') {
     context.push('/pupilHompage/grammar/adjectives');
  }

  if (voiceNavigationState!.currentPage == 'back' || voiceNavigationState!.currentPage == 'main menu') {
    voiceNavigationState!.setPreviousPage('');
    voiceNavigationState!.setCurrentPage('');
    voiceNavigationState!.setIsNavigatedGrammar(false);
    
    Navigator.pop(context);
  }

}

void _navigateToPractice() {
  if (!voiceNavigationState!.isNavigatedPractice) {
     context.push('/pupilHompage/practice');
    voiceNavigationState!.setIsNavigatedPractice(true);
     return;
  }

   voiceNavigationState!.setCurrentPage(command);

  if (voiceNavigationState!.currentPage == 'intonation') {
    context.push('/pupilHompage/practice/intonation');

  }

  if (voiceNavigationState!.currentPage == 'listening comprehension') {
    context.push('/pupilHompage/practice/listeningcomprehension');

  }

  if (voiceNavigationState!.currentPage == 'grammar') {
   context.push('/pupilHompage/practice/grammar');

  }

    if (voiceNavigationState!.currentPage == 'spelling') {
   context.push('/pupilHompage/practice/spelling');

  }

  if (voiceNavigationState!.currentPage == 'back' || voiceNavigationState!.currentPage == 'main menu') {
   voiceNavigationState!.setPreviousPage('');
   voiceNavigationState!.setCurrentPage('');
    voiceNavigationState!.setIsNavigatedPractice(false);
    Navigator.pop(context);
  }

  if (voiceNavigationState!.currentPage == 'none') {
    wrongChoice();
  }

  

}

void _navigateToVocabulary() {
  // if (!voiceNavigationState!.isNavigatedPractice) {
  //   voiceNavigationState!.isNavigatedPractice = true;
  // }
      context.push('/pupilHompage/vocabulary');

   voiceNavigationState!.setPreviousPage('');
}
void _navigateToOral() {
  // if (!voiceNavigationState!.isNavigatedPractice) {
  //   voiceNavigationState!.isNavigatedPractice = true;
  // }
      context.push('/pupilHompage/oral');


   voiceNavigationState!.setPreviousPage('');

}
void _navigateToIntonation() {
  // if (!voiceNavigationState!.isNavigatedPractice) {
  //   voiceNavigationState!.isNavigatedPractice = true;
  // }
      context.push('/pupilHompage/intonation');

   voiceNavigationState!.setPreviousPage('');
}



void _navigateBack() {
    Navigator.pop(context);
  }


Future<void> navigateForward() async {

  // await playaudio('assets/navigationguide/intro.mp3',completer);
  // await completer!.future;

  // await playaudio('assets/navigationguide/after_intro.mp3',completer2);
  // await completer2!.future;


  await Future.delayed(Duration(seconds: 2), () async => {
  context.push('/pupilHompage')
}).timeout(Duration(seconds: 30), onTimeout: onTimeout());



}

@override
void dispose() {
  
  super.dispose();
  if(!completer!.isCompleted) {
    completer!.complete();
  }
  if(!completer2!.isCompleted) {
    completer2!.complete();
  }
}


  
  
  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Scaffold(
            // appBar: buildAppBar(context),
            body: GestureDetector(
              child: Stack(
                children: [
                  buildBackgroundImage('assets/images/bg4.jpg'),
                  Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                     buildAppBar(context),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(

                            onTapDown: (details) {
                            // playaudio('navigationguide/eyelhearn.mp3');
                          },
                            child: StrokeText(
                            strokeColor: Colors.white,
                            strokeWidth: 3,
                            text: "EyeLhearn",
                            textStyle: GoogleFonts.spicyRice(
                                  fontSize: 56.0,
                                  fontWeight: FontWeight.w700,
                                  fontStyle: FontStyle.italic,
                                  color: textColor,
                                ),
                          
                            ),
                          ),
                        ],
                      ),
                    ),
              
                  ],
                ),
                ]
              ),
                    onHorizontalDragEnd: (dragEndDetails) {
                    if (dragEndDetails.primaryVelocity! < 0) {
                      // Page forwards

                        } else if (dragEndDetails.primaryVelocity! > 0) {
                      // Page backwards
                      print('Move page backwards');
                    }
                  },
            ),
          backgroundColor: primaryColor,
                  drawer: CustomDrawer()
          );
        }
      ),
    );
  }






}

