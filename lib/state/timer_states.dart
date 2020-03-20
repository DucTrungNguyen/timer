import 'package:equatable/equatable.dart';


abstract class TimerState extends Equatable {
  final int secons;

  const TimerState(this.secons);

  @override
  // TODO: implement props
  List<Object> get props => [secons];

}


class Ready extends TimerState{

  const Ready(int secons) : super(secons);
  @override
  String toString() {
    // TODO: implement toString
    return 'Ready';
  }
}

class Paused  extends TimerState {
  const Paused(int secons) : super(secons);

  @override
  String toString() {
    // TODO: implement toString
    return 'Paused';
  }

}


class Running extends  TimerState{
  const Running(int secons) : super(secons);

  @override
  String toString() {
    // TODO: implement toString
    return 'Running';
  }

}


class Finished  extends TimerState{
  const Finished() : super(0);

  @override
  String toString() {
    // TODO: implement toString
    return 'Finished';
  }
}



