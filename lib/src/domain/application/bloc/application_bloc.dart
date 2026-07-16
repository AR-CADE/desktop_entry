import 'package:bloc/bloc.dart' show Bloc, Emitter;
import 'package:desktop_entry/src/data/models/application_desktop_entry.dart';
import 'package:desktop_entry/src/data/repositories/application/application_repository.dart'
    show ApplicationRepository;
import 'package:equatable/equatable.dart' show Equatable;
import 'package:meta/meta.dart';

part 'application_event.dart';
part 'application_state.dart';

class ApplicationBloc extends Bloc<ApplicationEvent, ApplicationState> {
  ApplicationBloc({
    required this.repository,
    required this.directories,
  }) : super(ApplicationState.initial()) {
    on<ApplicationGetListRequested>(_onGetList);

    add(const ApplicationGetListRequested());
  }

  final ApplicationRepository repository;
  final List<String> directories;

  Future<void> _onGetList(
    ApplicationGetListRequested event,
    Emitter<ApplicationState> emit,
  ) async {
    emit(state.copyWith(status: .loading));
    try {
      final applications = await repository.getApplications(
        directories,
      );

      return emit(
        state.copyWith(
          status: .ready,
          applications: applications,
        ),
      );
    } on Exception catch (e) {
      emit(state.copyWith(status: .error, message: e.toString()));
    }
  }
}
