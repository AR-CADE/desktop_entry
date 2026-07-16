part of 'application_bloc.dart';

enum ApplicationStatus {
  initial,
  ready,
  loading,
  error,
}

class ApplicationState extends Equatable {
  const ApplicationState({
    required this.status,
    this.applications,
    this.message,
  });

  factory ApplicationState.initial() => const ApplicationState(
    status: ApplicationStatus.initial,
  );

  final ApplicationStatus status;
  final List<ApplicationDesktopEntry>? applications;
  final String? message;

  ApplicationState copyWith({
    ApplicationStatus? status,
    List<ApplicationDesktopEntry>? applications,
    String? message,
  }) {
    return ApplicationState(
      status: status ?? this.status,
      applications: applications ?? this.applications,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, applications, message];
}
