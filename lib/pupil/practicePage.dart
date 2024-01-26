import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:namer_app/custom_color.dart';
import 'lesson/VOCABULARY/vocabularyLandingPage.dart';
import 'lesson/ORAL/oralLandingPage.dart';
import 'lesson/INTONATION/intonationLandingPage.dart';
import 'package:flutter/services.dart';
import 'package:namer_app/main.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stroke_text/stroke_text.dart';
import 'practice/grammarPractice.dart';
import 'practice/intonationPractice.dart';
import 'practice/listeningComprehensionPractice.dart';
import 'dart:async';


class PracticePage extends StatefulWidget {
  const PracticePage({ Key? key }) : super(key: key);

  @override
  _PracticePageState createState() => _PracticePageState();
}

class _PracticePageState extends State<PracticePage> with RouteAware {

VoiceNavigationState? voiceNavigationState;
AudioPlayerState? audioPlayerState;
EyeLhearnAppState? eyeLhearnAppState;
VoiceActivationState? voiceActivationState;
MethodChannel platform = MethodChannel('com.learnhear/speechrecognition');
String? message = "";
  
Completer<void>? completer;


@override
void initState() {
  super.initState();
}

@override
void didPush() {
// Route was pushed onto navigator and is now topmost route.

  print('bowow oushed!!!!!!!!!!!!!!');// your func goes here
  }

  @override
  void didPopNext() {
    // Covering route was popped off the navigator.
  print('sheeeeeshhhhhsh');// your func goes here

  }



@override
void didChangeDependencies() {
  super.didChangeDependencies();
  voiceNavigationState = Provider.of<VoiceNavigationState>(context, listen: false);
  audioPlayerState = Provider.of<AudioPlayerState>(context, listen: false);
  voiceActivationState = Provider.of<VoiceActivationState>(context, listen: true);
  routeObserver.subscribe(this, ModalRoute.of(context)!);

}

  @override
  void dispose() {
    // audioPlayerState!.audioPlayer.stop();
    super.dispose();
    // stopaudio();
      routeObserver.unsubscribe(this);

  }




  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        voiceNavigationState!.setPreviousPage('');
        voiceNavigationState!.setCurrentPage('');
        voiceNavigationState!.setIsNavigatedPractice(false);

       context.pop();

       return true;
        },
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Scaffold(
              drawer: CustomDrawer(),
              body: Stack(
                children: [
                  buildBackgroundImage('assets/images/bg3.jpg'),
                  buildAppBar(context),
    
                  Row(
                  children: [
              
                    Expanded(
                      child: Container(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center, // Center the button vertically
                          children: [
              
                    GestureDetector(
                            onTapDown: (details) {
                              // Handle onTapDown event for Oral button
                              // playaudio('assets/navigationguide/practice.mp3');
                            },
                      child: StrokeText(
                            strokeColor: Colors.white,
                            strokeWidth: 3,
                            text: "PRACTICE",
                            textStyle: GoogleFonts.purplePurse(
                                  fontSize: 48.0,
                                  fontWeight: FontWeight.w700,
                                  fontStyle: FontStyle.italic,
                                  color: textColor,
                                ),
                    
                            ),
                    ),
              
                             SizedBox(height: 20.0),
    
                          GestureDetector(
                            onTapDown: (details) async {
                                try {
                                completer = Completer<void>();
                                playaudio('assets/navigationguide/intonation.mp3',completer);
                                await completer!.future;
                                } catch(e) {
                                  print(e); 
                                }
                                finally {
                                    if(!completer!.isCompleted) {
                                    completer!.complete();
                                    }
                                }
                            },
                            child: ElevatedButton(onPressed: (){

                            context.push('/pupilHompage/practice/intonation');

                            }, 
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              minimumSize: Size(300, 100), // Adjust the size
                              padding: EdgeInsets.all(0), // Remove padding to have the image fill the button
                              textStyle: TextStyle(fontSize: 18), // Adjust the text size
                              backgroundColor: secondaryColor,
                            ), 
                                                child: Container(
                            width: 300,
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0), // Set the same radius as your button
                              image: DecorationImage(
                                image: AssetImage("assets/images/practice_bg2.jpg"), // Replace with the path to your image
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Center(
                              child: 
                                  StrokeText(
                                        strokeColor: Colors.white,
                                        strokeWidth: 3,
                                        text: "INTONATION",
                                        textStyle: GoogleFonts.purplePurse(
                                              fontSize: 41.0,
                                              fontWeight: FontWeight.w700,
                                              fontStyle: FontStyle.italic,
                                              color: textColor,
                                            ),
                          
                            ),
                            ),
                                                ),
                            ),
                          ),
              
                            SizedBox(height: 12.0),
              
    
                          GestureDetector(
                              onTapDown: (details) async {
                              // Handle onTapDown event for Oral button
                                try {
                                completer = Completer<void>();
                                playaudio('assets/navigationguide/listeningComprehension.mp3',completer);
                                await completer!.future;
                                } catch(e) {
                                  print(e); 
                                }
                                finally {
                                    if(!completer!.isCompleted) {
                                    completer!.complete();
                                    }
                                }
                            },
                            child: ElevatedButton(onPressed: (){
                              context.push('/pupilHompage/practice/listeningcomprehension');

                            }, 
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              minimumSize: Size(300, 100), // Adjust the size
                              padding: EdgeInsets.all(0), // Remove padding to have the image fill the button
                              textStyle: TextStyle(fontSize: 18), // Adjust the text size
                              backgroundColor: secondaryColor,
                            ), 
                                                child: Container(
                            width: 300,
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0), // Set the same radius as your button
                              image: DecorationImage(
                                image: AssetImage("assets/images/practice_bg1.jpg"), // Replace with the path to your image
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Center(
                              child: 
                                  Column(
                                    children: [
                                      StrokeText(
                                            strokeColor: Colors.white,
                                            strokeWidth: 3,
                                            text: "LISTENING",
                                            textStyle: GoogleFonts.purplePurse(
                                                  fontSize: 35.0,
                                                  fontWeight: FontWeight.w700,
                                                  fontStyle: FontStyle.italic,
                                                  color: textColor,
                                                ),
                                            ),
                                      StrokeText(
                                            strokeColor: Colors.white,
                                            strokeWidth: 3,
                                            text: "COMPREHENSION",
                                            textStyle: GoogleFonts.purplePurse(
                                                  fontSize: 29.0,
                                                  fontWeight: FontWeight.w700,
                                                  fontStyle: FontStyle.italic,
                                                  color: textColor,
                                                ),
                                            ),
                                    ],
                                  ),
                            ),
                                                ),
                            ),
                          ),
              
                          SizedBox(height: 12.0),
    
                          GestureDetector(
                            onTapDown: (details) async {
                              // Handle onTapDown event for Oral button
                                try {
                                completer = Completer<void>();
                                playaudio('assets/navigationguide/grammar.mp3',completer);
                                await completer!.future;
                                } catch(e) {
                                  print(e); 
                                }
                                finally {
                                    if(!completer!.isCompleted) {
                                    completer!.complete();
                                    }
                                }
                            },
                            child: ElevatedButton(onPressed: (){
                        
                             context.push('/pupilHompage/practice/grammar');
                            
                            }, 
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              minimumSize: Size(300, 100), // Adjust the size
                              padding: EdgeInsets.all(0), // Remove padding to have the image fill the button
                              textStyle: TextStyle(fontSize: 18), // Adjust the text size
                              backgroundColor: secondaryColor,
                            ), 
                                                child: Container(
                            width: 300,
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0), // Set the same radius as your button
                              image: DecorationImage(
                                image: AssetImage("assets/images/practice_bg4.jpg"), // Replace with the path to your image
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Center(
                              child: 
                                  StrokeText(
                                        strokeColor: Colors.white,
                                        strokeWidth: 3,
                                        text: "GRAMMAR",
                                        textStyle: GoogleFonts.purplePurse(
                                              fontSize: 42.0,
                                              fontWeight: FontWeight.w700,
                                              fontStyle: FontStyle.italic,
                                              color: textColor,
                                            ),
                          
                            ),
                            ),
                                                ),
                            ),
                          ),


                                                    SizedBox(height: 12.0),
    
                          GestureDetector(
                            onTapDown: (details) async {
                              // Handle onTapDown event for Oral button
                                try {
                                completer = Completer<void>();
                                playaudio('assets/navigationguide/spelling.mp3',completer);
                                await completer!.future;
                                } catch(e) {
                                  print(e); 
                                }
                                finally {
                                    if(!completer!.isCompleted) {
                                    completer!.complete();
                                    }
                                }
                            },
                            child: ElevatedButton(onPressed: (){
                        
                             context.push('/pupilHompage/practice/spelling');
                            
                            }, 
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              minimumSize: Size(300, 100), // Adjust the size
                              padding: EdgeInsets.all(0), // Remove padding to have the image fill the button
                              textStyle: TextStyle(fontSize: 18), // Adjust the text size
                              backgroundColor: secondaryColor,
                            ), 
                                                child: Container(
                            width: 300,
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0), // Set the same radius as your button
                              image: DecorationImage(
                                image: AssetImage("assets/images/practice_bg2.jpg"), // Replace with the path to your image
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Center(
                              child: 
                                  StrokeText(
                                        strokeColor: Colors.white,
                                        strokeWidth: 3,
                                        text: "SPELLING",
                                        textStyle: GoogleFonts.purplePurse(
                                              fontSize: 42.0,
                                              fontWeight: FontWeight.w700,
                                              fontStyle: FontStyle.italic,
                                              color: textColor,
                                            ),
                          
                            ),
                            ),
                                                ),
                            ),
                          ),


                          ],
                        ),  // ← Here.
                      ),
                    ),
                  ],
                ),
                ]
              ),
            );
          }
        )
      ),
    );
  }
}