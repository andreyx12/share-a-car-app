part of 'emergency_report_bloc.dart';

@immutable
abstract class EmergencyReportEvent {}

class OnInitialState extends EmergencyReportEvent{}

class OnPostEmergencyReport extends EmergencyReportEvent{
}
