import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zeeppay/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:zeeppay/features/profile/presentation/bloc/profile_event.dart';
import 'package:zeeppay/features/profile/presentation/bloc/profile_state.dart';
import 'package:zeeppay/features/profile/presentation/mixin/profile_page_mixin.dart';
import 'package:zeeppay/features/profile/presentation/widgets/initial_profile_widget.dart';
import 'package:zeeppay/features/profile/presentation/widgets/loaded_profile_widget.dart';
import 'package:zeeppay/features/profile/presentation/widgets/search_cpf_profile_widget.dart';

// ignore: must_be_immutable
class ProfilePage extends StatelessWidget with ProfilePageMixin {
  ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocBuilder<ProfileBloc, ProfileState>(
          bloc: profileBloc,
          builder: (context, state) {
            if (state is ProfileStateInitial) {
              return InitialProfileWidget(
                function: () {
                  profileBloc.add(ProfileCpfEventSet());
                },
                onBack: () {
                  Navigator.of(context).pop();
                },
              );
            }
            if (state is ProfileStateLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ProfileStateSearchCpf) {
              return SearchCpfProfileWidget(
                cpfController: cpfController,
                onConfirm: () {
                  profileBloc.add(
                    ProfileCpfEventLoad(
                      document: formatCpf(cpfController.text),
                    ),
                  );
                },
                onBack: () {
                  profileBloc.add(ProfileSetInitialEvent());
                },
              );
            }
            if (state is ProfileStateSucess) {
              return LoadedProfileWidget(
                client: state.cliente.first,
                profileBloc: profileBloc,
              );
            }
            if (state is ProfileStateError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, color: Colors.red, size: 60),
                    SizedBox(height: 16),
                    Text(
                      'Erro ao consultar perfil',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        state.message,
                        style: TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        profileBloc.add(ProfileSetInitialEvent());
                      },
                      child: Text('Voltar'),
                    ),
                  ],
                ),
              );
            }
            return Center(
              child: Text(
                'State not implemented: ${state.runtimeType}',
                style: TextStyle(color: Colors.red, fontSize: 20),
              ),
            );
          },
        ),
      ),
    );
  }
}
