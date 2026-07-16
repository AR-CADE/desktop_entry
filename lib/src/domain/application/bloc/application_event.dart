part of 'application_bloc.dart';

sealed class ApplicationEvent extends Equatable {
  const ApplicationEvent();
}

@visibleForTesting
final class ApplicationGetListRequested extends ApplicationEvent {
  const ApplicationGetListRequested();

  @override
  List<Object> get props => [];
}
