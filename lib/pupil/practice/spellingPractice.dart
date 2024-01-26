import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';
import 'dart:convert';
import 'package:namer_app/custom_color.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:namer_app/main.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:fluttertoast/fluttertoast.dart';



class SpellingPractice extends StatefulWidget {
  const SpellingPractice({ Key? key }) : super(key: key);

  @override
  _NounPracticeState createState() => _NounPracticeState();
}


class _NounPracticeState extends State<SpellingPractice> with RouteAware {


  var scrollController = ScrollController();


  FToast fToast = FToast();
  AudioPlayerState? audioPlayerState;
  AnswerState? answerState;
  EyeLhearnAppState? eyeLhearnAppState;

  List<Lyric> lyrics = [];
  List<LessonImage> lessonImages = [];
  List<String> choices = [];
  String? practiceTitle;

  bool isRecording = false;
  bool isPracticeDisposed = false;



 @override
  initState() {

    getlesson();

    fToast.init(navigatorKey.currentContext!);
    super.initState();

  }

  
  @override
  void dispose() {
    // _pageController.dispose();
    // timer.cancel();
    super.dispose();
    routeObserver.unsubscribe(this);

    isPracticeDisposed = true;

    stopaudio();
    audioPlayerState!.stop();
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
      onTap: () {
        context.pop();
      },
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
  
                       ? Colors.black
  
                       : Colors.blue,
  
                   fontSize: 62,
  
                 ),
  
               ),
  
             );
  
           }).toList(),
  
         ),
  
       )
  
     : Center(child: Text('Please wait.')),



  
      ),
 
  
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
  Completer<void> instructionCompleter = Completer<void>();

  try {
      final response = await http.get(Uri.parse("${apiUrl}/api/practices/grammar/practice-grammar-spelling"));
    
  if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      List<AudioPracticeItem> items = jsonResponse.map((itemMap) {
      return AudioPracticeItem.fromJson(itemMap);
        }).toList();
      
      // print(items);
    try {

      await playaudio('assets/guide_speaker/spelling_instruction.mp3', instructionCompleter);
      await instructionCompleter.future;
      await platform.invokeMethod('stopPocketPhinx');

    } catch (e) {
      print(e);
    }


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

      if(!isPracticeDisposed){
      await audioPlayerState!.playLesson(item.lessonAudioUrl, completer);

      await completer.future;

      await Future.delayed(Duration(seconds: 3)).timeout(Duration(seconds: 5),onTimeout: () async {
        print('timeout');
      });

      answerState!.isRecording != true ? await answerState!.startRecording(eyeLhearnAppState!.user_Token,item.id,recordingCompleter) : null;
      

      await recordingCompleter.future;
      }




    }


  if (isPracticeDisposed) {
      return;
    }

    showToast('Awesome you got ${answerState!.userscore}',Colors.green);
    resetScore(practiceTitle!,eyeLhearnAppState!.user_Token);
    answerState!.speak('Awesome you got ${answerState!.userscore}');
    
    Future.delayed(Duration(seconds: 3), () async {
      context.pop();
    });
       

       
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

