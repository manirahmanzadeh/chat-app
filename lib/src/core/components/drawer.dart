import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chatapp/src/features/auth/presentation/account/bloc/profile_bloc.dart';
import 'package:chatapp/src/features/auth/presentation/account/screens/profile_screen.dart';

import '../../features/auth/presentation/bloc/auth/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth/auth_event.dart';
import '../../features/auth/presentation/bloc/auth/auth_state.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    final profileBloc = BlocProvider.of<ProfileBloc>(context, listen: true);
    final user = authBloc.getCurrentUser();
    final displayName = user!.displayName == null || user.displayName!.isEmpty ? null : user.displayName;
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (_, state) => Drawer(
        child: state is LoadingAuthState
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  DrawerHeader(
                    child: InkWell(
                      onTap: () => Navigator.pushNamed(context, ProfileScreen.routeName),
                      child: CircleAvatar(
                        radius: 50.0,
                        backgroundColor: Colors.grey[300],
                        child: profileBloc.getUserPhotoUrl(context) != null
                            ? ClipOval(
                                child: Image.network(
                                  profileBloc.getUserPhotoUrl(context)!,
                                  width: 100.0,
                                  height: 100.0,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : const Icon(
                                Icons.person,
                                size: 50.0,
                                color: Colors.grey,
                              ),
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text(displayName ?? 'You haven\'t set your name'),
                    onTap: () => Navigator.pushNamed(context, ProfileScreen.routeName),
                  ),
                  ListTile(
                    title: const Text('Log Out'),
                    onTap: () => authBloc.add(SignOutAuthEvent(context: context)),
                  ),
                ],
              ),
      ),
    );
  }
}
