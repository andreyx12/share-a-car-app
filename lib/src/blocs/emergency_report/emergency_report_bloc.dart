import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'emergency_report_event.dart';
part 'emergency_report_state.dart';

class EmergencyReportBloc extends Bloc<EmergencyReportEvent, EmergencyReportState> {
  
  EmergencyReportBloc() : super(EmergencyReportState());

  @override
  Stream<EmergencyReportState> mapEventToState(EmergencyReportEvent event) async* {
    // TODO: implement mapEventToState
  }
}
