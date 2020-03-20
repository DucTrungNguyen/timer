import 'package:equatable/equatable.dart';

import 'package:meta/meta.dart';

abstract class TimerEvents  extends Equatable{
  const TimerEvents();
  @override
  // TODO: implement props
  List<Object> get props => [];
}


class Start extends TimerEvents {
  final int secons;
  const Start({@required this.secons});
  @override
  String toString() {
    // TODO: implement toString
    return 'Start';
  }
}


class Pause  extends TimerEvents {}

class Remuse extends TimerEvents {}

class Reset extends TimerEvents {}



class Tick extends TimerEvents {
  final int secons;

  const Tick({@required this.secons});

  @override
  // TODO: implement props
  List<Object> get props => [secons];

  @override
  String toString() {
    // TODO: implement toString
    return 'Tick';
  }

}
