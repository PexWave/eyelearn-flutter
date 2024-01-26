import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:namer_app/custom_color.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:namer_app/main.dart';
import 'package:card_swiper/card_swiper.dart';



class PronounPractice extends StatefulWidget {
  const PronounPractice({ Key? key }) : super(key: key);

  @override
  _PronounPracticeState createState() => _PronounPracticeState();
}


class _PronounPracticeState extends State<PronounPractice> with RouteAware {

  var scrollController = ScrollController();

  AudioPlayerState? audioPlayerState;
  AnswerState? answerState;

  VoiceNavigationState? voiceNavigationState;
  EyeLhearnAppState? eyeLhearnAppState;
  
  
  List<String> choices = [];
  String? practiceTitle;

  List<Lyric> lyrics = [];
  List<LessonImage> lessonImages = [];


 @override
  initState() {

    getlesson();
    super.initState();

  }

  
  @override
  void dispose() {
    // _pageController.dispose();
    // timer.cancel();
    audioPlayerState!.stop();
    super.dispose();
  }


  

@override
void didPush() {
// Route was pushed onto navigator and is now topmost route.
   stopaudio();
    print('wow');// your func goes here
  }

  @override
  void didPopNext() {
    // Covering route was popped off the navigator.
  print('shesh');// your func goes here

  }


    @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    audioPlayerState = Provider.of<AudioPlayerState>(context, listen: true);
    voiceNavigationState = Provider.of<VoiceNavigationState>(context, listen: true);
    answerState = Provider.of<AnswerState>(context, listen: true);
    eyeLhearnAppState = Provider.of<EyeLhearnAppState>(context, listen: true);

    if (lyrics.isNotEmpty) {
      audioPlayerState!.onPositionChanged(audioPlayerState!.currentPosition, lyrics, eyeLhearnAppState!.fontSize,800,scrollController);
    }
    routeObserver.subscribe(this, ModalRoute.of(context)!);
}

 

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {},
      child: Scaffold(

body: Stack(


  children:
  [
    buildBackgroundImage('assets/images/grammar_bg.png'),

     
    Container(
  
    width: double.infinity,
    
    child: Column(
  
      children: [
  

  
    Container(
    margin: EdgeInsets.only(top: 80.0),
    alignment: Alignment.center,
     width: double.infinity,
    height: 400.0,
     child: lyrics.isNotEmpty
  
     ? SingleChildScrollView(
  
         controller: scrollController,
  
         child: Wrap(
  
           alignment: WrapAlignment.center,
  
           children: lyrics.map((lyric) {
  
             return Padding(
  
               padding: const EdgeInsets.all(2.0),
  
               child: Text(
  
                 lyric.text,
  
                 textAlign: TextAlign.justify,
  
                 softWrap: true,
  
                 style: TextStyle(
  
                   color: audioPlayerState!.currentPosition >= lyric.timestamp
  
                       ? Colors.blue
  
                       : Colors.black,
  
                   fontSize: eyeLhearnAppState!.fontSize,
  
                 ),
  
               ),
  
             );
  
           }).toList(),
  
         ),
  
       )
  
     : Center(child: Text('Please wait.')),
  
      ),
  
    
Container(
  height: 50.0, // Adjust the height as needed
  child: Wrap(
    alignment: WrapAlignment.center,
    crossAxisAlignment: WrapCrossAlignment.start,
    children: [
      for (int i = 0; i < choices.length; i += 2)
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  // Handle button press for choices[i]
                },
                child: Text(choices[i],style: TextStyle(color: Colors.white, fontSize: 40.0)),
                style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                    foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.0),
                  ),
                ),
              ),

            ),
            if (i + 1 < choices.length)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  
                  onPressed: () {
                    // Handle button press for choices[i + 1]
                  },
                  child: Text(choices[i + 1],style: TextStyle(color: Colors.white, fontSize: 40.0)),

                  style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                      foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                )
              ),

                

                
              ),
          ],
        ),
    ],
  ),
)

  
      ],
  
    ),
  
  ),
  ],
)


      ),
    );

}


// FUTURE BUILDER FOR GRAMMAR LESSONS

   //fetch grammar

Future<void> getlesson() async {

  try {
      final response = await http.get(Uri.parse("${apiUrl}/api/practices/grammar/practice-pronoun"));
    
  if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      List<AudioPracticeItem> items = jsonResponse.map((itemMap) {
      return AudioPracticeItem.fromJson(itemMap);
        }).toList();
      
      
      await playaudio('guide_speaker/grammar_instructions.mp3');


      for(var item in items) {
      Completer<void> completer = Completer<void>();
      Completer<void> recordingCompleter = Completer<void>();

        if(mounted){
        setState(() {
          choices = item.choices.split(',');
          lyrics = item.lessonLyrics;
          lessonImages = item.lessonImages;

          practiceTitle = item.item;
        });
        }
      

      await audioPlayerState!.playLesson(item.lessonAudioUrl, completer);

      
      await completer.future;

      await Future.delayed(Duration(seconds: 3)).timeout(Duration(seconds: 5),onTimeout: () async {
        print('timeout');
      });

      answerState!.isRecording != true ? await answerState!.startRecording(eyeLhearnAppState!.user_Token,item.id,recordingCompleter) : null;
      

      await recordingCompleter.future;

    }

    showToast('Awesome you got ${answerState!.userscore}',Colors.green);
    resetScore(practiceTitle!,eyeLhearnAppState!.user_Token);
      answerState!.speak('Awesome you got ${answerState!.userscore}');

  } else {
    // Handle non-200 status code
    print('Request failed with status: ${response.statusCode}');
    // You might want to throw an exception or handle it based on your needs
  }
  } catch (e) {
    print(e);

    return Future.error(e);
  }

}

}

