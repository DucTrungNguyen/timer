import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timer/blocs/bloc.dart';
import 'package:timer/blocs/timer_bloc.dart';
import 'package:timer/ticker.dart';
import 'package:timer/state/timer_states.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor:  Color.fromRGBO(109, 234, 255, 1),
        accentColor: Color.fromRGBO(72, 74, 126, 1),
        brightness: Brightness.dark,


        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create:  (context) => TimerBloc(ticker: Ticker()),
        child: Timer(),
      ),
    );
  }
}



class Timer extends StatelessWidget {

  static const TextStyle timerTextStyle = TextStyle(
    fontSize:  60,
    fontWeight: FontWeight.bold
  );


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Timer App'
        ),
      ),
      body: Stack(
        children: <Widget>[
          Background(),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 100.0),
                child: Center(
                  child: BlocBuilder<TimerBloc, TimerState>(
                      builder: (context,state){
                        final String minutesStr = ((state.secons /60) % 60)
                            .floor()
                            .toString()
                            .padLeft(2, ' ');
                        final String secondsStr =
                        (state.secons % 60 ).floor().toString().padLeft(2, '0');

                        return Text(
                          '$minutesStr:$secondsStr',
                          style:  Timer.timerTextStyle,

                        );

                      }


                  ),
                ),
              ),
              BlocBuilder<TimerBloc, TimerState>(
                condition: (previousState, state)=> state.runtimeType != previousState.runtimeType,
                builder: (context, state) => Actions()  ,
              )
            ],
          ),
        ],
      ),
    );
  }
}


class Actions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: _mapStateToActionButtons(
        timerBloc: BlocProvider.of<TimerBloc>(context),
      ),
    );
  }

  List<Widget> _mapStateToActionButtons({TimerBloc timerBloc,}) {
    final TimerState currentState = timerBloc.state;
    if (currentState is Ready) {
      return [
        FloatingActionButton(
          child: Icon(Icons.play_arrow),
          onPressed: () =>
              timerBloc.add(Start(secons: currentState.secons)),
        ),
      ];
    }
    if (currentState is Running) {
      print('running');
      return [
        FloatingActionButton(
          child: Icon(Icons.pause),
          onPressed: () => timerBloc.add(Pause()),
        ),
        FloatingActionButton(
          child: Icon(Icons.replay),
          onPressed: () => timerBloc.add(Reset()),
        ),
      ];
    }
    if (currentState is Paused) {
      return [
        FloatingActionButton(
          child: Icon(Icons.play_arrow),
          onPressed: () => timerBloc.add(Remuse()),
        ),
        FloatingActionButton(
          child: Icon(Icons.replay),
          onPressed: () => timerBloc.add(Reset()),
        ),
      ];
    }
    if (currentState is Finished) {
      return [
        FloatingActionButton(
          child: Icon(Icons.replay),
          onPressed: () => timerBloc.add(Reset()),
        ),
      ];
    }
    return [];
  }
}


class Background extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WaveWidget(
      config: CustomConfig(
        gradients: [
          [
            Color.fromRGBO(100, 74, 126, 1),
            Color.fromRGBO(125, 170, 206, 1),
            Color.fromRGBO(184, 189, 245, 0.7)
          ],
          [
            Color.fromRGBO(72, 74, 126, 1),
            Color.fromRGBO(125, 170, 206, 1),
            Color.fromRGBO(172, 182, 219, 0.7)
          ],
          [
            Color.fromRGBO(72, 73, 126, 1),
            Color.fromRGBO(125, 170, 206, 1),
            Color.fromRGBO(190, 238, 246, 0.7)
          ],

        ],
        durations: [19440,90000,6000],
        heightPercentages: [0.4,0.01,0.02],
        gradientBegin: Alignment.bottomCenter,
        gradientEnd: Alignment.topCenter
      ),
      size: Size(double.infinity, double.infinity),
      waveAmplitude: 50,
      backgroundColor: Colors.blue[50],
    );
  }
}

