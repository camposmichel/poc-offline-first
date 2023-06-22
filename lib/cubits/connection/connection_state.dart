part of 'connection_cubit.dart';

@immutable
abstract class AppConnectionState {}

class AppConnectionInitialState extends AppConnectionState {}

class AppConnectionOnlineState extends AppConnectionState {}

class AppConnectionOfflineState extends AppConnectionState {}
