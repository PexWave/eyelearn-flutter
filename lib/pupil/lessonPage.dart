import 'package:flutter/material.dart';
import 'package:namer_app/custom_color.dart';
import 'lesson/GRAMMAR/grammarLandingPage.dart';
import 'lesson/VOCABULARY/vocabularyLandingPage.dart';
import 'lesson/ORAL/oralLandingPage.dart';
import 'lesson/INTONATION/intonationLandingPage.dart';
import 'package:flutter/services.dart';
import 'package:namer_app/main.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stroke_text/stroke_text.dart';


class LessonPage extends StatefulWidget {
  const LessonPage({ Key? key }) : super(key: key);

  @override
  _LessonPageState createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> with RouteAware {

VoiceNavigationState? voiceNavigationState;
AudioPlayerState? audioPlayerState;
VoiceActivationState? voiceActivationState;

MethodChannel platform = MethodChannel('com.learnhear/speechrecognition');
String? message = "";

@override
void initState() {
  super.initState();
}

@override
void didPush() {
// Route was pushed onto navigator and is now topmost route.
   playWelcomeMessage();

    print('wow');// your func goes here
  }

  @override
  void didPopNext() {
    // Covering route was popped off the navigator.
  print('shesh');// your func goes here
   playWelcomeMessage();

  }

Future<void> playWelcomeMessage() async {

 playaudio('guide_speaker/lesson_choices.mp3');

if (mounted) {
  voiceActivationState!.iconData == Icons.record_voice_over ? voiceNavigationState!.startRecording() : null;
}

}

@override
void didChangeDependencies() {
  super.didChangeDependencies();
  voiceNavigationState = Provider.of<VoiceNavigationState>(context, listen: true);
  audioPlayerState = Provider.of<AudioPlayerState>(context, listen: false);
  voiceActivationState = Provider.of<VoiceActivationState>(context, listen: true);
  // loggedInUserState!.iconData == Icons.record_voice_over ? playWelcomeMessage() : null;
  routeObserver.subscribe(this, ModalRoute.of(context)!);

}


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Scaffold(
            drawer: CustomDrawer(),
            body: Stack(
              children: [
                buildBackgroundImage('assets/images/bg4.jpg'),
                buildAppBar(context),

Row(
  children: [
    Expanded(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
StrokeText(
                          strokeColor: Colors.white,
                          strokeWidth: 3,
                          text: "LESSON",
                          textStyle: GoogleFonts.purplePurse(
                                fontSize: 48.0,
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.italic,
                                color: textColor,
                              ),
                  
                          ),


                    SizedBox(height: 12.0),


            SizedBox(height: 12.0),
            _buildCustomButton(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VocabularyLandingPage()),
                );
              },
              onTapDown: (details) {
                // Handle onTapDown event for Vocabulary button
                playaudio('navigationguide/vocabulary.mp3');
              },
              imageAsset: "assets/images/lesson_bg2.jpg",
              label: "VOCABULARY",
            ),
            SizedBox(height: 12.0),
            _buildCustomButton(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OralLandingPage()),
                );
              },
              onTapDown: (details) {
                // Handle onTapDown event for Oral button
                playaudio('navigationguide/oral.mp3');
              },
              imageAsset: "assets/images/lesson_bg1.jpg",
              label: "ORAL",
            ),
            SizedBox(height: 12.0),
            _buildCustomButton(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => IntonationLandingPage()),
                );
              },
              onTapDown: (details) {
                // Handle onTapDown event for Intonation button
                playaudio('navigationguide/intonation.mp3');
              },
              imageAsset: "assets/images/lesson_bg4.jpg",
              label: "INTONATION",
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