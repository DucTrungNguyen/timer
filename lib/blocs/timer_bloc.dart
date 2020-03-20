import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timer/events/timer_events.dart' ;
import 'package:timer/state/timer_states.dart';
import 'package:timer/ticker.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

class TimerBloc extends Bloc<TimerEvents, TimerState>{
  final Ticker _ticker;
  final int _secons = 10;


  StreamSubscription<int> _tickerSubscription;

  TimerBloc({@required Ticker ticker}) : assert (ticker != null), _ticker = ticker;

  @override
  // TODO: implement initialState
  TimerState get initialState => Ready(_secons);

  @override
  void onTransition(Transition<TimerEvents, TimerState> transition) {
    // TODO: implement onTransition
    super.onTransition(transition);
    print(transition);
  }

  @override
  Stream<TimerState> mapEventToState(TimerEvents event) async* {
    if ( event is Start){
      print('start');
      yield* _mapStartToState(event);

    }else if ( event is Pause){
      print('pausee ne');
      yield* _mapPauseToState(event);

    } else if (event is Remuse){
      
      yield* _mapRemuseToState(event);
      
    } else if ( event is Reset){

      yield* _mapResetToState(event);
    } else if ( event is Tick){

      yield* _mapTickToState(event);
    }
  }

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }

  Stream<TimerState> _mapStartToState(Start start ) async* {
    yield Running(start.secons);
    _tickerSubscription?.cancel();

    _tickerSubscription = _ticker
        .tick(ticks: start.secons)
        .listen((secons) => add( Tick(secons:  secons)));

  }

  Stream<TimerState> _mapPauseToState(Pause pause) async* {
    if ( state is Running){
      _tickerSubscription?.pause();
      yield Paused(state.secons);
    }
  }

  Stream<TimerState> _mapRemuseToState(Remuse remuse) async*{
    if (state is Paused){
      _tickerSubscription?.resume();
      yield Running(state.secons);
    }
  }

  Stream<TimerState> _mapResetToState(Reset reset) async*{
    _tickerSubscription?.cancel();
    yield Ready(_secons);
  }

  Stream<TimerState> _mapTickToState(Tick tick) async*{
    if  (tick.secons > 0)
      yield Running(tick.secons);
    else {
      FlutterRingtonePlayer.play(
        android: AndroidSounds.notification,
        ios: IosSounds.glass,
        looping: false,
        volume: 1.0,
      );

      yield Finished();
    }


    //yield tick.secons > 0 ? Running(tick.secons) :
  }

}