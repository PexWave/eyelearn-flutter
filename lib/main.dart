import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:namer_app/pupil/lesson/GRAMMAR/grammarLandingPage.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:namer_app/pupil/lesson/INTONATION/intonationLandingPage.dart';
import 'package:namer_app/pupil/lesson/ORAL/oralLandingPage.dart';
import 'package:namer_app/pupil/lesson/VOCABULARY/vocabularyLandingPage.dart';
import 'package:namer_app/pupil/practice/grammarPractice.dart';
import 'package:namer_app/pupil/practice/intonationPractice.dart';
import 'package:namer_app/pupil/practice/listeningComprehensionPractice.dart';
import 'package:namer_app/pupil/practice/spellingPractice.dart';
import 'package:namer_app/pupil/lesson/GRAMMAR/grammar_lessons/pronoun.dart';
import 'package:namer_app/pupil/lesson/GRAMMAR/grammar_lessons/verb.dart';
import 'package:namer_app/pupil/lesson/GRAMMAR/grammar_lessons/adjectives.dart';
import 'package:namer_app/pupil/practicePage.dart';
import 'pupil/pupilHompage.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:async';
import 'dart:convert';
import 'common.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:permission_handler/permission_handler.dart';
import 'dart:math' as math;
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:namer_app/custom_color.dart';
import 'voiceNavigation.dart';
import 'pupil/lessonPage.dart';
import 'pupil/lesson/GRAMMAR/grammar_lessons/nouns.dart';
import 'voiceNavigation.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:permission_handler/permission_handler.dart';
import 'package:porcupine_flutter/porcupine.dart';
import 'package:porcupine_flutter/porcupine_error.dart';
import 'package:porcupine_flutter/porcupine_manager.dart';
import 'dart:collection'; 
import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:isolate';
import 'package:flutter_easyloading/flutter_easyloading.dart';

// import 'package:auto_route/auto_route.dart';


const int tSampleRate = 44100;
typedef _Fn = void Function();


final apiUrl = dotenv.env['API_URL']!;
// player.AudioPlayer audioPlayer = player.AudioPlayer();

final player = AudioPlayer();

const platform = MethodChannel("com.learnhear/speechrecognition");

final RouteObserver<ModalRoute> routeObserver =
      RouteObserver<ModalRoute>();

class FontSize {
  final String name;
  final double fontSize;
  const FontSize(this.name, this.fontSize);

  @override
  String toString() {
    return name;
  }
}



onTimeout() => print("Time Out occurs");


const List<FontSize> list = [
    FontSize('32', 32.0),
    FontSize('48', 48.0),
  ];


GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  Isolate.current.setErrorsFatal(false);
  await dotenv.load(fileName: 'devconfig.env');

  runApp(MyApp());
  configLoading();
}


final _router = GoRouter(
  initialLocation: '/',
  navigatorKey: navigatorKey,
    observers: [
    GoRouterObserver(), 
  ],
  routes: [


    GoRoute(
      name: 'landingpage',
      path: '/',
      builder: (context, state) => const LandingPage(),
    ),

    GoRoute(
      name: 'pupilHompage',
      path: '/pupilHompage',
      builder: (context, state) => const PupilHompage(),
    ),
      GoRoute(
      name: 'home-gram',
      path: '/pupilHompage/grammar',
      builder: (context, state) => const GrammarLandingPage(),
    ),

    GoRoute(
      name: 'grammar-noun',
      path: '/pupilHompage/grammar/noun',
      builder: (context, state) => const Noun(),
    ),

    GoRoute(
      name: 'grammar-pronoun',
      path: '/pupilHompage/grammar/pronoun',
      builder: (context, state) => const Pronoun(),
    ),

    GoRoute(
      name: 'grammar-verb',
      path: '/pupilHompage/grammar/verb',
      builder: (context, state) => const Verb(),
    ),

    GoRoute(
      name: 'grammar-adjective',
      path: '/pupilHompage/grammar/adjectives',
      builder: (context, state) => const Adjectives(),
    ),

    GoRoute(
      name: 'home-vocabulary',
      path: '/pupilHompage/vocabulary',
      builder: (context, state) => const VocabularyLandingPage(),
    ),
        GoRoute(
      name: 'home-oral',
      path: '/pupilHompage/oral',
      builder: (context, state) => const OralLandingPage(),
    ),
    GoRoute(
      name: 'home-intonation',
      path: '/pupilHompage/intonation',
      builder: (context, state) => const IntonationLandingPage(),
    ),
    GoRoute(
      name: 'practice',
      path: '/pupilHompage/practice',
      builder: (context, state) => const PracticePage(),
    ),
    GoRoute(
      name: 'exercise-intonation',
      path: '/pupilHompage/practice/intonation',
      builder: (context, state) => const IntonationPractice(),
    ),
    GoRoute(
      name: 'exercise-listeningcomprehension',
      path: '/pupilHompage/practice/listeningcomprehension',
      builder: (context, state) => const ListeningComprehensionPractice(),
    ),
    GoRoute(
      name: 'exercise-grammar',
      path: '/pupilHompage/practice/grammar',
      builder: (context, state) => const GrammarPractice(),
    ),
    GoRoute(
      name: 'exercise-spelling',
      path: '/pupilHompage/practice/spelling',
      builder: (context, state) => const SpellingPractice(),
    ),
  ],
);

class GoRouterObserver extends NavigatorObserver {

  Completer<void>? completer;
  Completer<void>? completer2;
  Completer<void>? helperCompleter;


  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    
    String routeName = route.settings.name ?? '';

    print('MyTest didpush: $routeName');
    if (routeName.contains('pupilHompage')) {
        
      Future.delayed(Duration(milliseconds: 500), () async {
      welcomeMessage('assets/guide_speaker/home_choices.mp3','assets/guide_speaker/rpt_mne_menu_ins.mp3');
      });
    }

      if (routeName.contains('home-gram')) {
     Future.delayed(Duration(milliseconds: 500), () async {
      welcomeMessage('assets/guide_speaker/grammar_lessons_choices.mp3','assets/guide_speaker/rpt_grammar.mp3');
      
    });
  }
      if (routeName.contains('practice')) {
     Future.delayed(Duration(milliseconds: 100), () async {
      welcomeMessage('assets/guide_speaker/practices.mp3','assets/guide_speaker/practices.mp3');
      
    });
  }

  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {

  String routeName = route.settings.name ?? '';

  print('MyTest didPop: $routeName');

  if (routeName.contains('home') || routeName.contains('practice')) {
     Future.delayed(Duration(milliseconds: 500), () async {
      welcomeMessage('assets/guide_speaker/home_choices.mp3','assets/guide_speaker/rpt_mne_menu_ins.mp3');
      });
  }
  
  if (routeName.contains('grammar')) {
     Future.delayed(Duration(milliseconds: 500), () async {
      welcomeMessage('assets/guide_speaker/grammar_lessons_choices.mp3','assets/guide_speaker/rpt_grammar.mp3');
      });
  }
  if (routeName.contains('exercise')) {
     Future.delayed(Duration(milliseconds: 500), () async {
      welcomeMessage('assets/guide_speaker/practices.mp3','assets/guide_speaker/practices.mp3');
      });
  }

  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    print('MyTest didRemove: $route');
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    print('MyTest didReplace: $newRoute');
  }

  Future<void> welcomeMessageHelper(Completer<void>? helperCompleter, String path, String rptpath) async {
  completer = Completer<void>();
  completer2 = Completer<void>();

  try{
  
   await playaudio(path,completer);
   await completer!.future;
  
  
  //  await playaudio(rptpath,completer2);
  //  await completer2!.future;

   await platform.invokeMethod('resetPocketPhinx');

    
  } 
  
  catch(e) 
    {
    print(e); 

    if(!completer!.isCompleted) {
      completer!.completeError(e); // Complete the future with an error
    
    }
    if(!completer2!.isCompleted) {
      completer2!.completeError(e);
    }
                      
    }
  
  finally {

      if(!completer!.isCompleted) {
      completer!.complete();
      
      }
      if(!completer2!.isCompleted) {
        completer2!.complete();      
      }

  }

    return helperCompleter!.future;
  }

  Future<void> welcomeMessage(String path, String rptpath) async {
  
  helperCompleter = Completer<void>();

  try{
 
   welcomeMessageHelper(helperCompleter, path, rptpath);
   
   await platform.invokeMethod('resetPocketPhinx');

    
  } 
  
  catch(e) 
    {
    print(e); 

    if(!helperCompleter!.isCompleted) {
      helperCompleter!.completeError(e); // Complete the future with an error
    
    }

                      
    }
  
  finally {

      if(!helperCompleter!.isCompleted) {
      helperCompleter!.complete();
      
      }

  }

  }


}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override 
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [

        ChangeNotifierProvider(
          create: (context) => EyeLhearnAppState(),
        ),
 
        ChangeNotifierProvider(
          create: (context) => VoiceActivationState(),
        ),
        ChangeNotifierProvider(
          create: (context) => PracticeAndLessonState(),  // Note: You have two providers for `LessonState`. You may want to check this.
        
        ),
        ChangeNotifierProvider(
          create: (context) => PupilState(),  // Note: You have two providers for `LessonState`. You may want to check this.
        
        ),
          ChangeNotifierProvider(
              create: (context) {
                  final state = VoiceNavigationState();
                  state.init();
                  state.initConfigRecorder();
                          
                  return state;
              }
          ),
          ChangeNotifierProvider(
              create: (context) {
                  final state = AnswerState();        
                  return state;
              }
          ),
          ChangeNotifierProvider(
              create: (context) {
                  final state = ConfirmationState();        
                  return state;
              }
          ),
          ChangeNotifierProvider(
              create: (context) {
                  final state = AudioPlayerState();
                  return state;
              }
          ),
      ],
      child: MaterialApp(
        navigatorObservers: [ routeObserver ],
        title: 'LearnHear',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
        ),
        home: StartApp(),
        builder: EasyLoading.init(),
      ),
    );
  }
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = false
    ..dismissOnTap = false
    ..customAnimation = CustomAnimation();
}


class StartApp extends StatefulWidget {
const StartApp({ Key? key }) : super(key: key);

  @override
  State<StartApp> createState() => _StartAppState();
}

class _StartAppState extends State<StartApp> with WidgetsBindingObserver {

   @override
  void initState() {
    super.initState();
    ambiguate(WidgetsBinding.instance)!.addObserver(this);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));
    _init();
  }

  Future<void> _init() async {
    // Inform the operating system of our app's audio attributes etc.
    // We pick a reasonable default for an app that plays speech.
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
    // Listen to errors during playback.
    player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      print('A stream error occurred: $e');
    });
    // Try to load audio from a source and catch any errors.
    // try {
    //   // AAC example: https://dl.espressif.com/dl/audio/ff-16b-2c-44100hz.aac
    //   await player.setAudioSource(AudioSource.uri(Uri.parse(
    //       "https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3")));
    // } catch (e) {
    //   print("Error loading audio source: $e");
    // }
  }

  @override
  void dispose() {
    ambiguate(WidgetsBinding.instance)!.removeObserver(this);
    // Release decoders and buffers back to the operating system making them
    // available for other apps to use.
    player.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // Release the player's resources when not in use. We use "stop" so that
      // if the app resumes later, it will still remember what position to
      // resume from.
      player.stop();
    }
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
    );
  }
}


class AudioPlayerState extends ChangeNotifier {
  EyeLhearnAppState eyeLhearnAppState = EyeLhearnAppState();


  // player.AudioPlayer audioPlayer = player.AudioPlayer();
  Duration currentPosition = Duration();

  List<String> words = [];
  final List<String> images = [];

  String lesson = "";
  int currentWordIndex = 0;


  late final logger;


  Future<void> playLesson(String url, Completer<void> completer) async {
      player.stop();

      await Future.delayed(Duration(seconds: 3)).timeout(Duration(seconds: 5),onTimeout: () async {
      });
      
    if (!completer.isCompleted) {



          try {
            await player.setUrl(url);                 
            player.play();

            player.positionStream.listen((Duration p) {
              currentPosition = p;
              print(currentPosition);
              notifyListeners();
              });

            player.playerStateStream.listen((state) {
            if (state.playing)  {
            switch (state.processingState) {
              case ProcessingState.idle:
                break;
              case ProcessingState.loading:
                break;
              case ProcessingState.buffering:
                break;
              case ProcessingState.ready: 
                break;
              case ProcessingState.completed: 
                  if (!completer.isCompleted) {
                      completer.complete();  // Complete the future when the player finishes
                      }
                break;
            }
            } else {

            }

          });


            } catch (error) {
                print(error);
                if (!completer.isCompleted) {
                  completer.completeError(error); // Complete the future with an error
                }
              }


          }

  }

 

  int getCurrentLyricIndex(Duration position, List<Lyric> lyrics) {
    for (int i = 0; i < lyrics.length; i++) {
      if (position < lyrics[i].timestamp) {
        return i > 0 ? i - 1 : 0;
      }
    }
    return lyrics.length - 1;
  }


  void onPositionChanged(Duration position,  List<Lyric> lyrics, fontSize, int duration, ScrollController scrollController) {

  int currentIndex = getCurrentLyricIndex(position, lyrics);
  double size = fontSize == 32.0 ? 2.2 : 1.7;
  double itemHeight = fontSize / size;
  print(size);
  
  double offset = (currentIndex * itemHeight) - (0.5 * scrollController.position.viewportDimension);

  offset = math.max(offset, scrollController.position.minScrollExtent);
  offset = math.min(offset, scrollController.position.maxScrollExtent);

  scrollController.animateTo(
    offset,
    duration: Duration(milliseconds: duration),
    curve: Curves.easeOut,
  );

}


Future<void> stop() async {
  try {
    // await audioPlayer.stop();
    
  } catch (error) {
    print('Error stopping audio: $error');
    // You can choose to rethrow the error or handle it in another way
    // throw error;
  }
}



  void incrementIndex(){
    currentWordIndex++;
    notifyListeners();
  }

  void setWords(List<String> newWords){
    words = newWords;
   
    notifyListeners();
  }

  void setLesson(String lesson) {
    this.lesson = lesson;
    notifyListeners();
  }



  @override
  void dispose() {

      // audioPlayer.dispose();

      super.dispose();
  }


  }


class AnswerState extends ChangeNotifier {
// player.AudioPlayer audioPlayer = player.AudioPlayer();
FlutterTts flutterTts = FlutterTts();

final mRecorder = FlutterSoundRecorder();
bool isRecording = false;
bool isChoiceAvailable = false;

int   userscore = 0;



Future speak(String text) async{
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.4);
    await flutterTts.speak(text);
}
Future stop() async{
      await flutterTts.stop();
}



void setIsrecording(bool isRecording) {
    this.isRecording = isRecording;
    notifyListeners();
  }

//RECORDER
Future<void> startRecording(String token, int id, Completer<void> recordingCompleter) async {
  
        await Future.delayed(Duration(seconds: 3)).timeout(Duration(seconds: 5),onTimeout: () async {
      });

    if (!recordingCompleter.isCompleted)  {
          try
          {
          
          isRecording = true;
          notifyListeners();
          Directory tempDir = await getTemporaryDirectory();
          String mPath = '${tempDir.path}/command.aac';

          //await audioPlayer.play(player.AssetSource('assets/recorder/recorder-start.wav'));
          await player.setAsset('assets/recorder/recorder-start.wav');
          await player.play();

          await mRecorder.openRecorder();
          // await platform.invokeMethod('stopPocketPhinx');
          await mRecorder.startRecorder(
            toFile: mPath,
          );

          // Stop recording after 10 seconds
          await Future.delayed(Duration(seconds: 8), () async {

              if (!recordingCompleter.isCompleted) {
              await stopRecording(mPath, token, id, recordingCompleter);
              }
            
          });
          

          } catch (e) { 
            print(e);
            if (!recordingCompleter.isCompleted) {
                recordingCompleter.completeError(e); // Complete the future with an error
              }
          }
    } 
}


Future<void> stopRecording(String path, String token, int id, Completer<void> recordingCompleter) async {


  try {

  print("stop recording called!!!!");

   await mRecorder.stopRecorder().then((result) async => {
      // await audioPlayer.play(player.AssetSource('assets/recorder/recorder-remove.wav')),
      await player.setAsset('assets/recorder/recorder-remove.wav'),
      await player.play(),
      await sendAudioToAPI(result!, token, id, recordingCompleter),


    
   });

  } catch (error) {
      print(error);
      if (!recordingCompleter.isCompleted) {
        recordingCompleter.completeError(error); // Complete the future with an error
      }
    }


}

Future<void> deleteRecording(String path) async {
  try {
    File file = File(path);
    if (file.existsSync()) {
      file.deleteSync();
      print("File deleted successfully");
    }
  } catch (e) {
    print("Failed to delete the file: $e");
  }
}

//SEND RECORDED ANSWER TO THE API

Future<dynamic> sendAudioToAPI(String path, String token, int id, Completer<void> recordingCompleter) async {
  print('caaled!!!!!!!');
try{

  EasyLoading.show(status: 'loading...',maskType: EasyLoadingMaskType.black);

  var request = http.MultipartRequest('POST', Uri.parse("${apiUrl}/api/practices/check/pupil/answer"));
  request.files.add(
    await http.MultipartFile.fromPath(
      'recorded_audio', 
      path, 
      contentType: MediaType('audio', 'm4a')
    )
  );
  request.fields['token'] = token;
  request.fields['practice_id'] = id.toString();

  var streamedResponse = await request.send();
  var response = await http.Response.fromStream(streamedResponse);  
 
  
  if (response.statusCode == 422) {
      print(response.body);
  }
  print("Request status code: ${response.statusCode}");

  if (response.statusCode == 200) {
     Map<String, dynamic> data = json.decode(response.body);
    print("Uploaded successfully");

    print("Response body: ${data}");

    var score = data['score'];
    var practice_type = data['practice_type'];
    
    var answers = data['answer'];
    var requiredElements = ["a", "b", "c", "d"];
    bool anyElementPresent = requiredElements.any((element) => answers.contains(element));

    if(!anyElementPresent && practice_type != "spelling"){
        speak('Sorry, that is not part of the choices please try again');
        showToast('Sorry, that is not part of the choices. please try again', Colors.red);
        await Future.delayed(Duration(seconds: 4), () {
        });
    }else{
      isChoiceAvailable = true;
    }

    if(score != null) {
      userscore = score;
      print(userscore);
    }
    notifyListeners();
    // Delete the recording after a successful upload
    deleteRecording(path);

    
    EasyLoading.dismiss();

    recordingCompleter.complete(data);

      isRecording = false;

      notifyListeners();

  } else {
    print("Failed to upload");
    deleteRecording(path);
    EasyLoading.dismiss();

    return false;
  }


  } catch (error) {
      print(error);
      if (!recordingCompleter.isCompleted) {
        recordingCompleter.completeError(error); // Complete the future with an error
      }
    }  finally {
    EasyLoading.dismiss();
  }

}




}



class ConfirmationState extends ChangeNotifier {
  // player.AudioPlayer audioPlayer = player.AudioPlayer();
FlutterTts flutterTts = FlutterTts();

final mRecorder = FlutterSoundRecorder();
bool isRecording = false;
bool isCancelled = false;

int   userscore = 0;



Future speak(String text) async{
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.0);
    await flutterTts.speak(text);
}
Future stop() async{
      await flutterTts.stop();
}



void setIsrecording(bool isRecording) {
    this.isRecording = isRecording;
  }

//RECORDER
Future<void> startRecording(String token, int id, Completer<void> recordingCompleter) async {
  
        await Future.delayed(Duration(seconds: 3)).timeout(Duration(seconds: 5),onTimeout: () async {
      });

    if (!recordingCompleter.isCompleted)  {
          try
          {
          
          isRecording = true;
          Directory tempDir = await getTemporaryDirectory();
          String mPath = '${tempDir.path}/command.aac';

          // await audioPlayer.play(player.AssetSource('assets/recorder/recorder-start.wav'));
          await player.setAsset('assets/recorder/recorder-start.wav');
          await player.play();
          await mRecorder.openRecorder();
          // await platform.invokeMethod('stopPocketPhinx');
          await mRecorder.startRecorder(
            toFile: mPath,
          );

          // Stop recording after 8 seconds
          await Future.delayed(Duration(seconds: 5), () async {

              if (!recordingCompleter.isCompleted) {
              await stopRecording(mPath, token, id, recordingCompleter);
              }
            
          });
          

          } catch (e) { 
            print(e);
            if (!recordingCompleter.isCompleted) {
                recordingCompleter.completeError(e); // Complete the future with an error
              }
          }
    } 
}


Future<void> stopRecording(String path, String token, int id, Completer<void> recordingCompleter) async {


  try {

  print("stop recording called!!!!");

   await mRecorder.stopRecorder().then((result) async => {
      // await audioPlayer.play(player.AssetSource('assets/recorder/recorder-remove.wav')),
      await player.setAsset('assets/recorder/recorder-remove.wav'),
      await player.play(),
      
      await sendAudioToAPI(result!, token, id, recordingCompleter),


    
   });

  } catch (error) {
      print(error);
      if (!recordingCompleter.isCompleted) {
        recordingCompleter.completeError(error); // Complete the future with an error
      }
    }


}

Future<void> deleteRecording(String path) async {
  try {
    File file = File(path);
    if (file.existsSync()) {
      file.deleteSync();
      print("File deleted successfully");
    }
  } catch (e) {
    print("Failed to delete the file: $e");
  }
}

//SEND RECORDED ANSWER TO THE API

Future<dynamic> sendAudioToAPI(String path, String token, int id, Completer<void> recordingCompleter) async {
  print('caaled!!!!!!!');
try{

  EasyLoading.show(status: 'loading...',maskType: EasyLoadingMaskType.black);

  var request = http.MultipartRequest('POST', Uri.parse("${apiUrl}/api/lessons/confirm/"));
  request.files.add(
    await http.MultipartFile.fromPath(
      'recorded_audio', 
      path, 
      contentType: MediaType('audio', 'm4a')
    )
  );
  request.fields['token'] = token;
  request.fields['practice_id'] = id.toString();

  var streamedResponse = await request.send();
  var response = await http.Response.fromStream(streamedResponse);  
 
  
  if (response.statusCode == 422) {
      print(response.body);
  }
  print("Request status code: ${response.statusCode}");

  if (response.statusCode == 200) {
     Map<String, dynamic> data = json.decode(response.body);
    print("Uploaded successfully");

    print("Response body: ${data}");

    var command = data['command'];

    print(command);

      if(command == "no"){
        isCancelled = true;
      }
    // Delete the recording after a successful upload
    deleteRecording(path);

    
    EasyLoading.dismiss();

    recordingCompleter.complete(data);

    isRecording = false;


  } else {
    print("Failed to upload");
    deleteRecording(path);
    EasyLoading.dismiss();

    return false;
  }


  } catch (error) {
      print(error);
      if (!recordingCompleter.isCompleted) {
        recordingCompleter.completeError(error); // Complete the future with an error
      }
    }  finally {
    EasyLoading.dismiss();
  }

}


void setIscancelled(bool isCancelled) {
    this.isCancelled = isCancelled;
  }

}




class VoiceNavigationState extends ChangeNotifier {
  // player.AudioPlayer audioPlayer = player.AudioPlayer();

  bool _isActive = true;

  String? previousPage = '';
  String? currentPage = '';
  
  String? navigationCommand  = "";
  String? lastProcessedCommand  = "";

  String? option = "";
  String? level = "";
  String? category = "";
  String? subcategory = "";
  String? practiceCategory = "";

  bool isNavigatedLesson = false;
  bool isNavigatedPractice = false;
  bool isNavigatedGrammar = false;
  bool isNavigatedLevel = false;
  bool isNavigatedCategory = false;
  bool isNavigatedSubCategory = false;

  late final FlutterSoundRecorder mRecorder;
  late final MethodChannel nativechannel;
  late final FlutterSoundRecorder recorder;


void setPreviousPage(String? previousPage) {
    this.previousPage = previousPage;
  }

void setCurrentPage(String? currentPage) {
    this.currentPage = currentPage;
  }

void init() async {
  
   nativechannel = MethodChannel('com.learnhear/speechrecognition');
  
  setMethodCallHandler();

  mRecorder = FlutterSoundRecorder();
 
    if (!kIsWeb) {
      var status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        throw RecordingPermissionException('Microphone permission not granted');
      }
       
    }
    await mRecorder.openRecorder();
    
}

initConfigRecorder() async {


    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration(
      avAudioSessionCategoryOptions:
      AVAudioSessionCategoryOptions.allowBluetooth |
      AVAudioSessionCategoryOptions.defaultToSpeaker,
      avAudioSessionMode: AVAudioSessionMode.spokenAudio,
      avAudioSessionRouteSharingPolicy:
      AVAudioSessionRouteSharingPolicy.defaultPolicy,
      avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
      androidAudioAttributes: const AndroidAudioAttributes(
        contentType: AndroidAudioContentType.speech,
        flags: AndroidAudioFlags.none,
        usage: AndroidAudioUsage.voiceCommunication,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
      androidWillPauseWhenDucked: true,
    ));
  }

void setMethodCallHandler() {
    nativechannel.setMethodCallHandler((MethodCall call) async {
      switch (call.method) {
        case 'methodNameInFlutter':
          final data = call.arguments;
          print("calling pocketPhinx");

          await platform.invokeMethod('stopPocketPhinx');
          await startRecording();
          // Handle the data and perform your function.
          break;
        default:
          throw MissingPluginException();
      }
    });
  }

//RECORDER
Future<void> startRecording() async {
  Completer<void> recordingCompleter = Completer<void>();

  
try{
  // Ensure recorder is initialized
  Directory tempDir = await getTemporaryDirectory();
  String mPath = '${tempDir.path}/command.aac';

  await playRecordStartedSound();

  await platform.invokeMethod('stopPocketPhinx');

  await mRecorder.startRecorder(
    toFile: mPath,
  );

  // Stop recording after 10 seconds
  Future.delayed(Duration(seconds: 5), () async {
    if (_isActive) {
      print("stop recording");
      await stopRecording(mPath);
      recordingCompleter.complete(); // Signal that recording is complete
    }
  });

  } catch (error) {
      print(error);
      if (!recordingCompleter.isCompleted) {
        recordingCompleter.completeError(error); // Complete the future with an error
      }
    }

  return recordingCompleter.future; // Return the Future to wait for recording completion
}


Future<void> stopRecording(String path) async {

  Completer<void> recordingCompleter = Completer<void>();

try{

   await mRecorder.stopRecorder().then((result) async => {
      playRecordStopSound(),
      await sendAudioToAPI(result!),
      recordingCompleter.complete() // Signal that recording is complete

    
   });

  } catch (error) {
      print(error);
      if (!recordingCompleter.isCompleted) {
        recordingCompleter.completeError(error); // Complete the future with an error
      }
    }

  return recordingCompleter.future;

}

Future<void> deleteRecording(String path) async {
  try {
    File file = File(path);
    if (file.existsSync()) {
      file.deleteSync();
      print("File deleted successfully");
    }
  } catch (e) {
    print("Failed to delete the file: $e");
  }
}

//SEND RECORDED ANSWER TO THE API

Future<dynamic> sendAudioToAPI(String path) async {

    Completer<void> apiCallCompleter = Completer<void>();
    EasyLoading.show(status: 'loading...',maskType: EasyLoadingMaskType.black,);
try{

  var request = http.MultipartRequest('POST', Uri.parse("${apiUrl}/api/practices/check/"));
  request.files.add(
    await http.MultipartFile.fromPath(
      'recorded_audio', 
      path, 
      contentType: MediaType('audio', 'm4a')
    )
  );

  
  var streamedResponse = await request.send();
  var response = await http.Response.fromStream(streamedResponse);  
 
  
if (response.statusCode == 422) {
    print(response.body);
}
  if (response.statusCode == 200) {
     Map<String, dynamic> data = json.decode(response.body);
    print("Uploaded successfully");

    print("Response body: ${data}");

    String command = data['command'];

    print(command);

    navigationCommand = command;
    
    notifyListeners();
    // Delete the recording after a successful upload
    deleteRecording(path);

  
    apiCallCompleter.complete();
    
    await platform.invokeMethod('resetPocketPhinx');

  } else {
    print("Failed to upload");
    deleteRecording(path);
    EasyLoading.dismiss();
    return false;
  }
  } catch (error) {
      print(error);
      if (!apiCallCompleter.isCompleted) {
        apiCallCompleter.completeError(error); // Complete the future with an error
      }
    }

      EasyLoading.dismiss();

      // await platform.invokeMethod('resetPocketPhinx');

      return apiCallCompleter.future;


}


void setOption(String? option) {
    this.option = option;
  }

void setlastProcessedCommand(String? lastProcessedCommand) {
    this.lastProcessedCommand = lastProcessedCommand;
  }

void setLevel(String? level) {
    this.level = level;
  }

void setCategory(String? category) {
    this.category = category;
  }

void setSubCategory(String? subcategory) {
    this.subcategory = subcategory;
  }

void setPracticeCategory(String? practiceCategory) {
    this.practiceCategory = practiceCategory;
  }

void setIsNavigatedLesson(bool isNavigatedLesson) {
    this.isNavigatedLesson = isNavigatedLesson;
  }

void setIsNavigatedGrammar(bool isNavigatedGrammar) {
    this.isNavigatedGrammar = isNavigatedGrammar;
  }

void setIsNavigatedLevel(bool isNavigatedLevel) {
    this.isNavigatedLevel = isNavigatedLevel;
  }

void setIsNavigatedCategory(bool isNavigatedCategory) {
    this.isNavigatedCategory = isNavigatedCategory;
  }

void setIsNavigatedSubCategory(bool isNavigatedSubCategory) {
    this.isNavigatedSubCategory = isNavigatedSubCategory;
  }

void setIsNavigatedPractice(bool isNavigatedPractice) {
  this.isNavigatedPractice = isNavigatedPractice;
}

void reset() {
    option = null;
    level = null;
    category = null;
    subcategory = null;
    practiceCategory = null;
  } 

@override
void dispose() {
    mRecorder.closeRecorder();
    nativechannel.setMethodCallHandler(null);
    _isActive = false;
    super.dispose();
}

//RECORDER SOUND
 playRecordStopSound() async {

    // await audioPlayer.play(player.AssetSource('assets/recorder/recorder-remove.wav'));
    await player.setAsset('assets/recorder/recorder-remove.wav');
    await player.play();

  }

 playRecordStartedSound() async {
 
    // await audioPlayer.play(player.AssetSource('assets/recorder/recorder-start.wav'));
    await player.setAsset('assets/recorder/recorder-start.wav');
    await player.play();

  }


}

class PracticeAndLessonState extends ChangeNotifier {
  List<Map<String, dynamic>> practice_and_lesson_list = [];

  Duration currentPosition = Duration();


  void setPracticeOrLessonList(List<Map<String, dynamic>> practiceList) {
      practice_and_lesson_list = practiceList;
     }


  Future<void> playPractice(String url) async {
  Completer<void> completer = Completer();
// try {
//   await audioPlayer.play(player.UrlSource(url)); // will immediately start playing
//   audioPlayer.onPositionChanged.listen((Duration p) {
//       currentPosition = p;

//       print(currentPosition);

//       notifyListeners();
//     });
//      audioPlayer.onPlayerComplete.listen((_) {

//         if (!completer.isCompleted) {
//             completer.complete();  // Complete the future when the player finishes
//         }
//   });
//   } catch (error) {
//       print(error);
//       if (!completer.isCompleted) {
//         completer.completeError(error); // Complete the future with an error
//       }
//     }




try {
  await player.setUrl(url);                 
  player.play();

  player.positionStream.listen((Duration p) {
    currentPosition = p;
    print(currentPosition);
    notifyListeners();
    });

  player.playerStateStream.listen((state) {
  if (state.playing)  {
  switch (state.processingState) {
    case ProcessingState.idle:
      break;
    case ProcessingState.loading:
      break;
    case ProcessingState.buffering:
      break;
    case ProcessingState.ready: 
      break;
    case ProcessingState.completed: 
        if (!completer.isCompleted) {
             completer.complete();  // Complete the future when the player finishes
            }
      break;
  }
  } else {

  }

});


  } catch (error) {
      print(error);
      if (!completer.isCompleted) {
        completer.completeError(error); // Complete the future with an error
      }
    }
  return completer.future; 
  
 }

}

class VoiceActivationState extends ChangeNotifier {
  IconData iconData = Icons.voice_over_off;

  setVoiceCommandOn() async {
    print(iconData);
        if (iconData == Icons.voice_over_off) {
          iconData = Icons.record_voice_over;
          await platform.invokeMethod('resetPocketPhinx');

        } else {
          iconData = Icons.voice_over_off;
          await platform.invokeMethod('stopPocketPhinx');

        }
        notifyListeners();
  }

}

//User states
class EyeLhearnAppState extends ChangeNotifier {
  var user_Token = '';
  double fontSize = 32.0;

  void setFontSize(double fontsize){
    fontSize = fontsize;
    notifyListeners();
    print(fontSize);
  }


  void setToken(String token){
    user_Token = token;
    print(user_Token);
    notifyListeners();
  }

  

}

//Pupil State

class PupilState extends ChangeNotifier {
  
    List<Map<String, dynamic>> pupils = [];
  
    void setPupils(List<Map<String, dynamic>> newPupils){
      pupils = newPupils;
      notifyListeners();
    }
}

//APBAR AND CUSTOM DRAWER
AppBar buildAppBar(BuildContext context, {loggedInUserState}) {
  return AppBar(
    elevation: 0,
    backgroundColor: Colors.transparent,

  );
}

Widget activateVoiceCommand(BuildContext context, loggedInUserState) {

  return Padding(
    padding: const EdgeInsets.only(left: 270),
    child: GestureDetector(
      onTap: () {
        loggedInUserState.setVoiceCommandOn();
        
      },
      child: Icon(
        loggedInUserState.iconData,
        size: 40.0,
        color: Colors.white,
      ),
    ),
    
  );
}

class CustomDrawer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: primaryColor,
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[

         GestureDetector(
      onTapDown: (details) {
      playaudio('navigationguide/fontsize.mp3');
      },
           child: Text('Font Size',
                                style: GoogleFonts.purplePurse(
                                  textStyle: Theme.of(context).textTheme.displayLarge,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w700,
                                  fontStyle: FontStyle.italic,
                                  color: categoryColor,
                                ),
           ),
         ),
        const SizedBox(height: 8),
        GestureDetector(
                onTapDown: (details) {
      playaudio('navigationguide/fontsize.mp3');
      },
          child: SearchDropDown()
          ),

        ],
      ),
    );
  }
}

class SearchDropDown extends StatelessWidget {
  final EyeLhearnAppState eyeLhearnAppState = EyeLhearnAppState();

  SearchDropDown({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<FontSize>(
      hintText: 'Select font size',
      items: list,
      excludeSelected: true,
      onChanged: (value) {
        Provider.of<EyeLhearnAppState>(context, listen: false).setFontSize(value.fontSize);
      },
    );
  }
  
}

//practice constructor 
class AudioPracticeItem {
  final int id;
  final String item;
  final String lessonAudioUrl;
  final String choices;
  final List<Lyric> lessonLyrics;
  final List<LessonImage> lessonImages;
  final String category;

  // Constructor
  AudioPracticeItem({
    required this.id,
    required this.choices,
    required this.item,
    required this.lessonAudioUrl,
    required this.lessonLyrics,
    required this.lessonImages,
    required this.category,
  });

  // Factory constructor to create an instance from a map
  factory AudioPracticeItem.fromJson(Map<String, dynamic> json) {
    var lyrics_list = json['lesson_lyrics'] as List;
    var lyrics_image = json['lesson_image'] as List;
    List<Lyric> lyricsList = lyrics_list.map((i) => Lyric.fromJson(i)).toList();
    List<LessonImage> lessonImage = lyrics_image.map((i) => LessonImage.fromJson(i)).toList();

    return AudioPracticeItem(
      id: json['id'],
      item: json['title'],
      choices: json['choices'],
      lessonAudioUrl: json['lesson_audio'],
      lessonLyrics: lyricsList,
      lessonImages: lessonImage,
      category: json['category'],
    );
  }
}

//LESSON CLASSES


//Intonation Lesson constructor
class AudioLessonItem {
  final int id;
  final String item;
  final String lessonAudioUrl;
  final String bridgeAudioUrl;
  final List<Lyric> lessonLyrics;
  final List<LessonImage> lessonImages;
  final String category;

  // Constructor
  AudioLessonItem({
    required this.id,
    required this.item,
    required this.lessonAudioUrl,
    required this.bridgeAudioUrl,
    required this.lessonLyrics,
    required this.lessonImages,
    required this.category,
  });

  // Factory constructor to create an instance from a map
  factory AudioLessonItem.fromJson(Map<String, dynamic> json) {
    var lyrics_list = json['lesson_lyrics'] as List;
    var lyrics_image = json['lesson_image'] as List;
    List<Lyric> lyricsList = lyrics_list.map((i) => Lyric.fromJson(i)).toList();
    List<LessonImage> lessonImage = lyrics_image.map((i) => LessonImage.fromJson(i)).toList();

    return AudioLessonItem(
      id: json['id'],
      item: json['title'],
      lessonAudioUrl: json['lesson_audio'],
      bridgeAudioUrl: json['bridge_audio'],
      lessonLyrics: lyricsList,
      lessonImages: lessonImage,
      category: json['category'],
    );
  }
}

class LessonImage{
  final String imageUrl;

  LessonImage({required this.imageUrl});

  factory LessonImage.fromJson(Map<String, dynamic> json) {
    return LessonImage(
      imageUrl: json['lesson_image'] ?? '', // Provide default value if null
      
    );
  }
}

class Lyric {
  final String text;
  final Duration timestamp;

  Lyric({required this.text, required this.timestamp});

  factory Lyric.fromJson(Map<String, dynamic> json) {
    return Lyric(
      text: json['text'] ?? '', // Provide default value if null
      timestamp: _parseTimestamp(json['timestamp']),
    );
  }


static Duration _parseTimestamp(String? timestamp) {
    // Guard clause to return a default value if the timestamp is null or not in the expected format
    if (timestamp == null || !timestamp.contains(":")) {
        return Duration.zero;
    }

    // Assuming format is "hh:mm:ss"
    List<String> parts = timestamp.split(':');
    int hours = (parts.length > 2) ? int.tryParse(parts[0]) ?? 0 : 0;
    int minutes = (parts.length > 1) ? int.tryParse(parts[parts.length - 2]) ?? 0 : 0;
    int seconds = int.tryParse(parts.last) ?? 0;

    return Duration(hours: hours, minutes: minutes, seconds: seconds);
}

}


Future<void> playaudio(String path, [Completer<void>? playbackCompleter]) async {

try{

// await audioPlayer.play(player.AssetSource(path));      
//                  // will immediately start playing
//      audioPlayer.onPlayerComplete.listen((_) async {

//         if (!playbackCompleter!.isCompleted) {

//             playbackCompleter.complete();  // Complete the future when the player finishes
//             await Future.delayed(Duration(seconds: 2), () async => {
//               // voiceActivationState.iconData == Icons.record_voice_over ? await platform.invokeMethod('resetPocketPhinx') : null,
//             }).timeout(Duration(seconds: 30), onTimeout: onTimeout());
 
//         }
        
//   });

await player.setAsset(path);  
await player.play();    
player.playerStateStream.listen((state) {
  // if (state.playing)
  switch (state.processingState) {
    case ProcessingState.completed:

        if(!playbackCompleter!.isCompleted) {
          playbackCompleter.complete();  // Complete the future when the player finishes
          Future.delayed(Duration(seconds: 2), () async => {
          }).timeout(Duration(seconds: 30), onTimeout: onTimeout());
        }

      break;
    default:
      break;
  }

});
  
} catch (error) {
      print(error);
      if (!playbackCompleter!.isCompleted) {
        playbackCompleter.completeError(error); // Complete the future with an error
      }
    }
  return playbackCompleter!.future; 
}

 Future<void> stopaudio() async {
//   player.playerStateStream.listen((state) {
//     if (state.playing)  {
//       player.stop();
//     } 
// });                        // Stop and free resources
      player.stop();

}


  
class Utils {
  BuildContext? context;

  Utils([this.context]);

  Future<void> startLoading() async {
    if (context != null) {
      return await showDialog<void>(
        context: context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const SimpleDialog(
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            children: <Widget>[
              Center(
                child: CircularProgressIndicator(),
              )
            ],
          );
        },
      );
    }
  }

  Future<void> stopLoading() async {
    if (context != null) {
      Navigator.of(context!).pop();
    }
  }

  Future<void> showError(Object? error) async {
    if (context != null) {
      ScaffoldMessenger.of(context!).showSnackBar(
        SnackBar(
          action: SnackBarAction(
            label: 'Dismiss',
            onPressed: () {
              ScaffoldMessenger.of(context!).hideCurrentSnackBar();
            },
          ),
          backgroundColor: Colors.red,
          content: Text(""),
        ),
      );
    }
  }
}


  
Widget buildBackgroundImage(String imagePath) {
  return Container(
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage(imagePath), // Replace with your image path
        fit: BoxFit.cover,
      ),
    ),
  );
}



void showToast(message, Color color) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,  // Use LONG for consistency across platforms
    gravity: ToastGravity.CENTER,
    timeInSecForIosWeb: 3,  // Set duration for iOS and web
    backgroundColor: color,
    textColor: Colors.white,
    fontSize: 38.0,
  );

  // Countdown timer for Android
  Timer(Duration(seconds: 3), () {
    Fluttertoast.cancel();  // Cancel the toast after 2 seconds on Android
  });
}



Future<bool> checkInternetConnection() async {
  FlutterTts flutterTts = FlutterTts();

  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.none) {
    showToast("Please connect to the Internet",Colors.red);

    player.playerStateStream.listen((state) {
      if (state.playing){
        player.stop();
      }
    });

    await flutterTts.speak("Please connect to the Internet");
    return false;
  } else {
    return true;
  }
}



Future<dynamic> resetScore(String practiceTitle, String userToken) async {
      Completer<void> apiCallCompleter = Completer<void>();
    EasyLoading.show(status: 'loading...',maskType: EasyLoadingMaskType.black,);
try{

  var request = http.MultipartRequest('POST', Uri.parse("${apiUrl}/api/practices/resetscore/"));
  request.fields['practice_title'] = practiceTitle.toString();
  request.fields['token'] = userToken.toString();

  
  var streamedResponse = await request.send();
  var response = await http.Response.fromStream(streamedResponse);  
 
  
if (response.statusCode == 422) {
    print(response.body);
}
  if (response.statusCode == 200) {
     Map<String, dynamic> data = json.decode(response.body);
    print("Uploaded successfully");

    print("Response body: ${data}");
  
    apiCallCompleter.complete();
    


  } else {
    print("Failed to upload");
    EasyLoading.dismiss();
    return false;
  }
  } catch (error) {
      print(error);
      if (!apiCallCompleter.isCompleted) {
        apiCallCompleter.completeError(error); // Complete the future with an error
      }
    }

      EasyLoading.dismiss();

      // await platform.invokeMethod('resetPocketPhinx');

      return apiCallCompleter.future;

}


class CustomAnimation extends EasyLoadingAnimation {
  CustomAnimation();

  @override
  Widget buildWidget(
    Widget child,
    AnimationController controller,
    AlignmentGeometry alignment,
  ) {
    return Opacity(
      opacity: controller.value,
      child: RotationTransition(
        turns: controller,
        child: child,
      ),
    );
  }
}

