import 'package:flutter/material.dart';
import 'package:namer_app/custom_color.dart';
import 'package:namer_app/pupil/lesson/GRAMMAR/grammar_lessons/adjectives.dart';
import 'package:namer_app/pupil/lesson/GRAMMAR/grammar_lessons/nouns.dart';
import 'package:namer_app/pupil/lesson/GRAMMAR/grammar_lessons/pronoun.dart';
import 'package:namer_app/pupil/lesson/GRAMMAR/grammar_lessons/verb.dart';
import 'package:namer_app/main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:stroke_text/stroke_text.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';



class GrammarLandingPage extends StatefulWidget {
  const GrammarLandingPage({ Key? key }) : super(key: key);

  @override
  _GrammarLandingPageState createState() => _GrammarLandingPageState();
}

class _GrammarLandingPageState extends State<GrammarLandingPage> with RouteAware {
  VoiceNavigationState? voiceNavigationState;
  AudioPlayerState? audioPlayerState;
  EyeLhearnAppState? eyeLhearnAppState;

  Completer<void>? completer;
  Completer<void>? completer2;


  @override
  void initState() {
    super.initState();



  }

  @override
  void dispose() {
    super.dispose();
  routeObserver.unsubscribe(this);

  }

  
@override
void didPush() {
// Route was pushed onto navigator and is now topmost route.
   super.didPush();

  }

  @override
  void didPopNext() {
  super.didPushNext();

   
  }

@override
void didChangeDependencies() {
  super.didChangeDependencies();
  audioPlayerState = Provider.of<AudioPlayerState>(context, listen: false);
  eyeLhearnAppState = Provider.of<EyeLhearnAppState>(context, listen: true);
  voiceNavigationState = Provider.of<VoiceNavigationState>(context, listen: false);
  // loggedInUserState!.iconData == Icons.record_voice_over ? playWelcomeMessage() : null;
  routeObserver.subscribe(this, ModalRoute.of(context)!);

}




  
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        voiceNavigationState!.setIsNavigatedGrammar(false);
        voiceNavigationState!.setPreviousPage('');
        voiceNavigationState!.setCurrentPage('');

            
        await platform.invokeMethod('resetPocketPhinx');
   
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
    
                GestureDetector(
                  onTapDown: (details) async {
                  // Handle onTapDown event for Intonation button
              try {
                completer = Completer<void>();
                playaudio('assets/navigationguide/grammar.mp3',completer);
                await completer!.future;
                } catch(e) {
                    if(!completer!.isCompleted) {
                    completer!.completeError(e);
                    
                    }
                }
                
                 finally {
                    if(!completer!.isCompleted) {
                    completer!.complete();
                    
                    }
                }

                },
                      child: StrokeText(
                            strokeColor: Colors.white,
                            strokeWidth: 3,
                            text: "GRAMMAR",
                            textStyle: GoogleFonts.purplePurse(
                                  fontSize: 48.0,
                                  fontWeight: FontWeight.w700,
                                  fontStyle: FontStyle.italic,
                                  color: textColor,
                                ),
                    
                            ),
                    ),
              _buildCustomButton(
                label: "NOUN",
                textStyle: GoogleFonts.pressStart2p(
                  fontSize: 28.0,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.italic,
                  color: levelColor,
                ),
                onTap: () {
                  context.push('/pupilHompage/grammar/noun');
                },
                  onTapDown: (details) async {

              try {
                completer = Completer<void>();
                playaudio('assets/navigationguide/noun.mp3',completer);
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
              ),
              SizedBox(height: 12.0),
              _buildCustomButton(
                label: "PRONOUN",
                textStyle: GoogleFonts.pressStart2p(
                  fontSize: 28.0,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.italic,
                  color: levelColor,
                ),
                onTap: () {
                  context.push('/pupilHompage/grammar/pronoun');
    
                },
              onTapDown: (details) async {

              try {
                completer = Completer<void>();
                playaudio('assets/navigationguide/pronoun.mp3',completer);
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
              ),
              SizedBox(height: 12.0),
              _buildCustomButton(
                label: "VERB",
                textStyle: GoogleFonts.pressStart2p(
                  fontSize: 28.0,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.italic,
                  color: levelColor,
                ),
                onTap: () {
                    context.push('/pupilHompage/grammar/verb');
    
                },
                onTapDown: (details) async {
              try {
                completer = Completer<void>();
                playaudio('assets/navigationguide/verb.mp3',completer);
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
              ),
              SizedBox(height: 12.0),
              _buildCustomButton(
                label: "ADJECTIVES",
                textStyle: GoogleFonts.pressStart2p(
                  fontSize: 28.0,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.italic,
                  color: levelColor,
                ),
                onTap: () {
                  context.push('/pupilHompage/grammar/adjectives');
    
                },
                  onTapDown: (details) async {

             try {
                completer = Completer<void>();
                playaudio('assets/navigationguide/adjectives.mp3',completer);
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
              ),
              SizedBox(height: 12.0),
            ],
          ),
        ),
      ),
      ],
    )
    
                ]
              ),
            );
          }
        )
      ),
    );
  }
}


Widget _buildCustomButton({
  required String label,
  required TextStyle textStyle,
  required VoidCallback onTap,
  required GestureTapDownCallback onTapDown,

}) {
  return GestureDetector(
    onTap: onTap,
    onTapDown: onTapDown,

    child: Container(
      width: 300,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: secondaryColor,
        border: Border.all(
          color: Colors.black,
          width: 2.0,
        ),
      ),
      
      child: Center(
        child: StrokeText(
          strokeColor: Colors.black,
          strokeWidth: 3,
          text: label,
          textStyle: textStyle,
        ),
      ),
    ),
  );
}