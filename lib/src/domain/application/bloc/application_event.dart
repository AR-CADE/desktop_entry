part of 'application_bloc.dart';

sealed class ApplicationEvent extends Equatable {
  const new();
}

@visibleForTesting
final class ApplicationGetListRequested extends ApplicationEvent {
  const new();

  @override
  List<Object> get props => [];
}
