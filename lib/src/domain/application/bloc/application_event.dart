part of 'application_bloc.dart';

sealed class ApplicationEvent extends Equatable {
  const new();
}

final class ApplicationGetListRequested extends ApplicationEvent {
  const new();

  @override
  List<Object> get props => [];
}
