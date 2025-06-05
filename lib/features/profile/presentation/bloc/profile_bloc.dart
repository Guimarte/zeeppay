import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zeeppay/features/profile/domain/usecase/profile_usecase.dart';
import 'package:zeeppay/features/profile/presentation/bloc/profile_event.dart';
import 'package:zeeppay/features/profile/presentation/bloc/profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({required this.profileUsecase}) : super(ProfileStateInitial()) {
    on<ProfileEventLoad>(_loadProfile);
  }

  ProfileUsecase profileUsecase;

  Future<void> _loadProfile(
    ProfileEventLoad event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileStateLoading());
    try {
      final cliente = await profileUsecase();
      emit(ProfileStateSucess(cliente: cliente));
    } catch (e) {
      emit(ProfileStateError(message: e.toString()));
    }
  }
}
