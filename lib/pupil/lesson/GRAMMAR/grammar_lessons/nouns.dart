import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';
import 'dart:convert';
import 'package:namer_app/custom_color.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:namer_app/main.dart';
import 'package:card_swiper/card_swiper.dart';
// import 'package:audioplayers/audioplayers.dart';



class Noun extends StatefulWidget {
  const Noun({ Key? key }) : super(key: key);

  @override
  _NounState createState() => _NounState();
}


class _NounState extends State<Noun> with RouteAware {



  late ScrollController scrollController;
  Completer<void>? completer;
  Completer<void>? bridgeCompleter;
  Completer<void>? recordingCompleter;
  Completer<void>? playAudioCompleter;
  Completer<void>? lessonCompleter;

  AudioPlayerState? audioPlayerState;
  EyeLhearnAppState? eyeLhearnAppState;
  ConfirmationState? confirmationState;


  List<Lyric> lyrics = [];
  List<LessonImage> lessonImages = [];

  bool isLessonDisposed = false;
  bool isDisposed = false;
  bool isLyricsEmpty = false;


 @override
  initState() {
    super.initState();
    scrollController = ScrollController();



  }

  
@override
void dispose() {
  super.dispose();
  stopaudio();

  isDisposed = true;

  if (isDisposed) {
    completer?.complete();
    bridgeCompleter?.complete();
    recordingCompleter?.complete();
    playAudioCompleter?.complete();
    lessonCompleter!.complete();

  }


  if (confirmationState?.mRecorder.isRecording == true) {
    confirmationState!.mRecorder.stopRecorder();
  }


  if (audioPlayerState != null) {
    audioPlayerState!.stop();
  }

  isLessonDisposed = true;

  routeObserver.unsubscribe(this);

}

  

@override
void didPush() {
// Route was pushed onto navigator and is now topmost route.
    print('wow');// your func goes here

    Future.delayed(Duration(milliseconds: 100), () async {
      platform.invokeMethod('stopPocketPhinx');
      lessonCompleter = Completer<void>();

      if (!mounted) return;
      getlesson(lessonCompleter!);
      await lessonCompleter!.future;

      print('Async task completed');
    });
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
    eyeLhearnAppState = Provider.of<EyeLhearnAppState>(context, listen: false);
    confirmationState = Provider.of<ConfirmationState>(context, listen: false);


    if (lyrics.isNotEmpty && !isLyricsEmpty)  {
      audioPlayerState!.onPositionChanged(audioPlayerState!.currentPosition, lyrics, eyeLhearnAppState!.fontSize, 800,scrollController);
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
  child:   GestureDetector(
  
        onTap: () {},
  
        child: Scaffold(
  
  
  
  body: Stack(
  
  
  
    children: 
  
    [
  
                    buildBackgroundImage('assets/images/grammar_bg.png'),
  
  
  
      Container(
  
      margin: EdgeInsets.only(top: 60.0),
  
      alignment: Alignment.center,
  
       width: double.infinity,
  
      height: 700.0,
  
       child: lyrics.isNotEmpty
  
    
  
       ? SingleChildScrollView(
  
    
  
           controller: scrollController,
  
    
  
           child: Wrap(
  
    
  
             alignment: WrapAlignment.center,
  
    
  
             children: lyrics.map((lyric) {
  
    
  
               return Padding(
  
    
  
                 padding: const EdgeInsets.all(8.0),
  
    
  
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
  
    
  
       : Center(child: Text('PLEASE WAIT.')),
  
    
  
        ),
  
    ],
  
  )
  
  
  
  
  
        ),
  
      ),
);

}


// FUTURE BUILDER FOR GRAMMAR LESSONS

   //fetch grammar

Future<void> getlesson(Completer<void> lessonCompleter) async {

  EasyLoading.show(status: 'loading...',maskType: EasyLoadingMaskType.black);


  try {
      final response = await http.get(Uri.parse("${apiUrl}/api/lessons/level 1/grammar/L-G-L1-NOUN"));
    
  if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      List<AudioLessonItem> items = jsonResponse.map((itemMap) {
      return AudioLessonItem.fromJson(itemMap);
        }).toList();
      



      for(var item in items) {
        if(mounted){
        setState(() {
        completer = Completer<void>();
        bridgeCompleter = Completer<void>();
        recordingCompleter = Completer<void>();
        playAudioCompleter = Completer<void>();

        lyrics = item.lessonLyrics;
        });
        }

        if (!isLessonDisposed){
        await audioPlayerState!.playLesson(item.lessonAudioUrl, completer!).then((value) => EasyLoading.dismiss());
        await completer!.future;

        if(mounted){
       setState(() {
          lyrics = [Lyric(text: 'Please wait.', timestamp: Duration(seconds: 0))];
        });
        }

        await audioPlayerState!.playLesson(item.bridgeAudioUrl, bridgeCompleter!).then((value) => EasyLoading.dismiss());
        await bridgeCompleter!.future;

        if(!isDisposed){
        await playaudio('assets/guide_speaker/lesson_confirmation.mp3',playAudioCompleter);
        await playAudioCompleter!.future;


          if(!confirmationState!.isRecording){
            await confirmationState!.startRecording(eyeLhearnAppState!.user_Token,item.id,recordingCompleter!);
            await recordingCompleter!.future;

            if(confirmationState!.isCancelled && !confirmationState!.isRecording){
              confirmationState!.setIscancelled(false);
              context.pop();
            }

          }

        }



      
  }

        

    }

   await platform.invokeMethod('resetPocketPhinx');

  lessonCompleter.complete();

  Navigator.pop(context);

  
  } else {
    // Handle non-200 status code
    print('Request failed with status: ${response.statusCode}');
    // You might want to throw an exception or handle it based on your needs
  }


  } catch (error) {
      print(error);
      if (!lessonCompleter.isCompleted) {
        lessonCompleter.completeError(error); // Complete the future with an error
      }
    }

  return lessonCompleter.future;

}

}

