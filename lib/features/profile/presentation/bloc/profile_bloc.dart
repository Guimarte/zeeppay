import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zeeppay/features/profile/domain/usecase/profile_usecase.dart';
import 'package:zeeppay/features/profile/presentation/bloc/profile_event.dart';
import 'package:zeeppay/features/profile/presentation/bloc/profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({required this.profileUsecase}) : super(ProfileStateInitial()) {
    on<ProfileCpfEventLoad>(_geClientCpf);
    on<ProfileCardEventLoad>(_loadProfileCard);
    on<ProfileCpfEventSet>(_setProfileCpf);
    on<ProfileSetInitialEvent>(_setInitialState);
  }

  ProfileUsecase profileUsecase;

  Future<void> _geClientCpf(
    ProfileCpfEventLoad event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileStateLoading());
    try {
      final cliente = await profileUsecase.call(event.document);
      emit(ProfileStateSucess(cliente: cliente));
    } catch (e) {
      emit(ProfileStateError(message: e.toString()));
    }
  }

  Future<void> _loadProfileCard(
    ProfileCardEventLoad event,
    Emitter<ProfileState> emitter,
  ) async {
    //   emit(ProfileStateLoading());
    //   try {
    //     final cliente = await profileUsecase(cardNumber: event.cardNumber);
    //     emit(ProfileStateSucess(cliente: cliente));
    //   } catch (e) {
    //     emit(ProfileStateError(message: e.toString()));
    //   }
    // }
  }

  void _setInitialState(
    ProfileSetInitialEvent event,
    Emitter<ProfileState> emitter,
  ) {
    emitter(ProfileStateInitial());
  }

  Future<void> _setProfileCpf(
    ProfileCpfEventSet event,
    Emitter<ProfileState> emitter,
  ) async {
    emitter(ProfileStateSearchCpf());
    // emit(ProfileStateLoading());
    // try {
    //   final cliente = await profileUsecase(cpf: cpf);
    //   emit(ProfileStateSucess(cliente: cliente));
    // } catch (e) {
    //   emit(ProfileStateError(message: e.toString()));
    // }
  }
}
