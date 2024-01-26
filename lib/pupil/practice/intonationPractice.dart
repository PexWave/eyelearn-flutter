import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:go_router/go_router.dart';
import 'package:namer_app/custom_color.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:namer_app/main.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';


class IntonationPractice extends StatefulWidget {
  const IntonationPractice({ Key? key }) : super(key: key);

  @override
  _IntonationPracticeState createState() => _IntonationPracticeState();
}


class _IntonationPracticeState extends State<IntonationPractice> with RouteAware {
  var scrollController = ScrollController();

  FToast fToast = FToast();

  AudioPlayerState? audioPlayerState;
  VoiceNavigationState? voiceNavigationState;
  EyeLhearnAppState? eyeLhearnAppState;
  AnswerState? answerState;

  Completer<void>? recordingCompleter;
  Completer<void>? completer;



  List<String> choices = [];
  String? practiceTitle;
  List<Lyric> lyrics = [];
  List<LessonImage> lessonImages = [];

  bool isPracticeDisposed = false;


 @override
  initState() {
    getlesson();
   platform.invokeMethod('stopPocketPhinx');

    fToast.init(navigatorKey.currentContext!);
    super.initState();
  }

  
  @override
  void dispose() {
    super.dispose();
    isPracticeDisposed = true;
    stopaudio();
    // audioPlayerState!.audioPlayer.stop();

// if (!recordingCompleter!.isCompleted)  {
//     recordingCompleter!.complete();  
//    }

  if(answerState!.mRecorder.isRecording){
    answerState!.mRecorder.stopRecorder();
  }

    routeObserver.unsubscribe(this);

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
    answerState = Provider.of<AnswerState>(context, listen: true);
    audioPlayerState = Provider.of<AudioPlayerState>(context, listen: true);
    voiceNavigationState = Provider.of<VoiceNavigationState>(context, listen: true);
    eyeLhearnAppState = Provider.of<EyeLhearnAppState>(context, listen: true);
    if (lyrics.isNotEmpty) {
      audioPlayerState!.onPositionChanged(audioPlayerState!.currentPosition, lyrics, eyeLhearnAppState!.fontSize,800,scrollController);
    }
    routeObserver.subscribe(this, ModalRoute.of(context)!);
}


  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async {
        await platform.invokeMethod('resetPocketPhinx');
        return true;
      },
      child: GestureDetector(
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
      height: choices.isEmpty ? 600.0 : 200.0,
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
      
                     fontSize: eyeLhearnAppState!.fontSize,
      
                   ),
      
                 ),
      
               );
      
             }).toList(),
      
           ),
      
         )
      
       : Center(child: Text('Please wait.')),
    
    
    
      
        ),
    
        if(choices.isNotEmpty)
    Container(
      height: 420.0, // Adjust the height as needed
      width: 400.0,
      child:  GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: choices.length,
      itemBuilder: (BuildContext context, int index) {
        return ElevatedButton(
          onPressed: () {
            // Handle button press for choices[index]
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: index.isEven ? Colors.black : Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32.0),
            ),
                      minimumSize: Size(150.0, 50.0), // Adjust the button size (width, height)
    
          ),
          child: Text(
            choices[index],
            style: TextStyle(color: Colors.white, fontSize: 20.0),
            textAlign: TextAlign.center,
          ),
        );
      },
      ),
    )
    
      
      
      
        ],
      
      ),
      
      ),
      ],
    )
    
    
        ),
      ),
    );

}

// FUTURE BUILDER FOR GRAMMAR LESSONS

   //fetch grammar

Future<void> getlesson() async {
  
  Completer<void> instructionCompleter = Completer<void>();
  Completer<void> instructionCompleter2 = Completer<void>();

  try {
      final response = await http.get(Uri.parse("${apiUrl}/api/practices/intonation/practice-intonation"));
    
  if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      List<AudioPracticeItem> items = jsonResponse.map((itemMap) {
      return AudioPracticeItem.fromJson(itemMap);
        }).toList();
      

      try {

        await playaudio('assets/guide_speaker/intonation_instructions.mp3',instructionCompleter);
        await instructionCompleter.future;
        if (!isPracticeDisposed) {
          await playaudio('assets/navigationguide/instruction_in_practice.mp3',instructionCompleter2);
          await instructionCompleter2.future;
        }

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


      
      // audioPlayerState!.playLesson(item.lessonAudioUrl, completer!);
    if(!isPracticeDisposed){
    await audioPlayerState!.playLesson(item.lessonAudioUrl, completer!);
    await completer!.future;

      await Future.delayed(Duration(seconds: 3)).timeout(Duration(seconds: 5),onTimeout: () async {
        print('timeout');
      });

    do{
        if(!answerState!.isRecording){
        recordingCompleter = Completer<void>();

        await answerState!.startRecording(eyeLhearnAppState!.user_Token,item.id,recordingCompleter!);
        await recordingCompleter!.future;
        }
    }while(!answerState!.isChoiceAvailable);


    }
      
    }

    if (isPracticeDisposed) {
      return;
    }


    showToast('Awesome you got ${answerState!.userscore}',Colors.red);
    resetScore(practiceTitle!,eyeLhearnAppState!.user_Token);

    if(answerState!.userscore <= 3) {
        await answerState!.speak('You are doing great keep learning!');
    } else {
        await answerState!.speak('Awesome you got ${answerState!.userscore}');
    }

    await Future.delayed(Duration(seconds: 5), () {
    context.pop();
    });



  } else {
    // Handle non-200 status code
    print('Request failed with status: ${response.statusCode}');
    // You might want to throw an exception or handle it based on your needs
  }
  
   await platform.invokeMethod('resetPocketPhinx');


  Future.delayed(Duration(seconds: 1), () {
       Navigator.pop(context);
    });


  } catch (e) {
    print(e);
    showToast('Internet connection error, please check your internet connection', Colors.red);

    return Future.error(e);
  }

}

}

