import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zeeppay/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:zeeppay/features/profile/presentation/bloc/profile_event.dart';
import 'package:zeeppay/features/profile/presentation/bloc/profile_state.dart';
import 'package:zeeppay/features/profile/presentation/mixin/profile_page_mixin.dart';
import 'package:zeeppay/features/profile/presentation/widgets/initial_profile_widget.dart';
import 'package:zeeppay/features/profile/presentation/widgets/search_cpf_profile_widget.dart';

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
