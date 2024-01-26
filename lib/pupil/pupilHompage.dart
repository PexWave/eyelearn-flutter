import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:namer_app/pupil/lessonPage.dart';
import 'package:provider/provider.dart';
import 'package:namer_app/custom_color.dart';
import 'package:namer_app/main.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'practice/intonationPractice.dart';
import 'practicePage.dart';
import 'package:namer_app/main.dart';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/io.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:stroke_text/stroke_text.dart';

import 'lesson/GRAMMAR/grammarLandingPage.dart';
import 'lesson/VOCABULARY/vocabularyLandingPage.dart';
import 'lesson/ORAL/oralLandingPage.dart';
import 'lesson/INTONATION/intonationLandingPage.dart';



class PupilHompage extends StatefulWidget {
  const PupilHompage({ Key? key }) : super(key: key);

  @override
  _PupilHompageState createState() => _PupilHompageState();
}

class _PupilHompageState extends State<PupilHompage> with RouteAware {
  final coquiTTS = dotenv.env['COQUI_TTS']!;


  VoiceNavigationState? voiceNavigationState;
  AudioPlayerState? audioPlayerState;
  EyeLhearnAppState? eyeLhearnAppState;


  Completer<void>? completer;


  bool check_internet_connection = false;
  
  int retry = 3;
  
  final random = Random();
  late final IOWebSocketChannel channel;


@override
void initState() {  
  super.initState();
  completer = Completer<void>();
  checkNetwork();
}

  Future<void> checkNetwork() async {
      FlutterTts flutterTts = FlutterTts();

      while(check_internet_connection == false && retry != 0) {
      bool isConnected = await checkInternetConnection().timeout(Duration(seconds:10), onTimeout: () {
        print('timeuout');
        return false;
      });

      if (mounted) {
        setState(() {
        check_internet_connection = isConnected;
        });
      }

      retry--;
    }

    if(check_internet_connection == true){
          grantUserToken();
    }
    else{
      showToast('Internet Connection Error.',Colors.red);
      // await flutterTts.speak("Internet Connection Error.");

    }

  }

@override
void didPush() {
// Route was pushed onto navigator and is now topmost route.
 

  }

  @override
  void didPopNext() {
    // Covering route was popped off the navigator.


  }



@override
void didChangeDependencies() {
  super.didChangeDependencies();
  voiceNavigationState = Provider.of<VoiceNavigationState>(context, listen: false);
  audioPlayerState = Provider.of<AudioPlayerState>(context, listen: false);
  eyeLhearnAppState = Provider.of<EyeLhearnAppState>(context, listen: true);
  routeObserver.subscribe(this, ModalRoute.of(context)!);

}


@override
void dispose() {
  routeObserver.unsubscribe(this);

  super.dispose();
}

  
  @override
  Widget build(BuildContext context) {
  audioPlayerState = Provider.of<AudioPlayerState>(context, listen: true);

  //NAVIGATE THROUGH THE APP USING VOICE COMMANDS

    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Scaffold(
            drawer: CustomDrawer(),
            body: Stack(
              children:[
                
                buildBackgroundImage('assets/images/bg4.jpg'),
                buildAppBar(context),
    
    Row(
    children: [
    Expanded(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
    
            
            _buildCustomButton(
              onTap: () {
                context.push('/pupilHompage/grammar');
                 voiceNavigationState!.setPreviousPage('grammar');
                 voiceNavigationState!.setIsNavigatedGrammar(true);
              },
              onTapDown: (details) async {
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
              imageAsset: "assets/images/lesson_bg3.jpg",
              label: "GRAMMAR",
            ),
    
            SizedBox(height: 12.0),
    
                        _buildCustomButton(
              onTap: () {
                context.push('/pupilHompage/vocabulary');

              },
              onTapDown: (details) async {
              try {
                completer = Completer<void>();
                playaudio('assets/navigationguide/vocabulary.mp3',completer);
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
              imageAsset: "assets/images/lesson_bg2.jpg",
              label: "VOCABULARY",
            ),
    
            SizedBox(height: 12.0),
    
    
            _buildCustomButton(
              onTap: () {
                context.push('/pupilHompage/oral');

              },
              onTapDown: (details) async {
              try {
                completer = Completer<void>();
                playaudio('assets/navigationguide/oral.mp3',completer);
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
              imageAsset: "assets/images/lesson_bg1.jpg",
              label: "ORAL",
            ),
    
            SizedBox(height: 12.0),
    
            _buildCustomButton(
              onTap: () {

                context.push('/pupilHompage/intonation');

              },
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
              imageAsset: "assets/images/lesson_bg4.jpg",
              label: "INTONATION",
            ),
    
            SizedBox(height: 12.0),
            
            GestureDetector(
              onTap: () {
                context.push('/pupilHompage/practice');
                voiceNavigationState!.setPreviousPage('practice');
                voiceNavigationState!.setIsNavigatedPractice(true);
              },
              onTapDown: (details) async {
              try {
                completer = Completer<void>();
                playaudio('assets/navigationguide/practice.mp3',completer);
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
                onTapUp: (details) {
                  print("I relaxed, oh.");
                },
              child: Container(
                width: 300,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  image: DecorationImage(
                    image: AssetImage("assets/images/kidlearning2.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Center(
                  child: StrokeText(
                    strokeColor: Colors.white,
                    strokeWidth: 3,
                    text: "Practice",
                    textStyle: GoogleFonts.spicyRice(
                      fontSize: 48.0,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.italic,
                      color: textColor,
                    ),
                  ),
                ),
              ),
            ),
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
    );

    
  }



  Future<void> grantUserToken() async {

  try {
      final response = await http.post(Uri.parse("${apiUrl}/api/accounts/generateJwtToken"));
    
  if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      TokenResponse tokenResponse = TokenResponse.fromJson(jsonResponse);
      eyeLhearnAppState!.setToken(tokenResponse.token);
      
  } else {
    // Handle non-200 status code
    print('Request failed with status: ${response.statusCode}');
    // You might want to throw an exception or handle it based on your needs
  }

  } catch (e) {
    print(e);

    showToast('Internet Connection Error.',Colors.red);
    await Future.delayed(Duration(seconds: 2)).timeout(Duration(seconds: 5), onTimeout: () {
      print('timeuout');
      return;
    });

    grantUserToken();
    return Future.error(e);
  }

}

}

class TokenResponse {
  final String token;

  TokenResponse({required this.token});

  factory TokenResponse.fromJson(Map<String, dynamic> json) {
    return TokenResponse(
      token: json['token'] as String,
    );
  }
}


Widget _buildCustomButton({
  required VoidCallback onTap,
  required GestureTapDownCallback onTapDown,
  required String imageAsset,
  required String label,
}) {
  return GestureDetector(
    onTap: onTap,
    onTapDown: onTapDown,
    child: Container(
      width: 300,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        image: DecorationImage(
          image: AssetImage(imageAsset),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: StrokeText(
          strokeColor: Colors.white,
          strokeWidth: 3,
          text: label,
          textStyle: GoogleFonts.purplePurse(
            fontSize: 41.0,
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.italic,
            color: textColor,
          ),
        ),
      ),
    ),
  );
}