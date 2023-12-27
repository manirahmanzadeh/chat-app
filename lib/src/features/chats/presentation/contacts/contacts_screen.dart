import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/src/core/locator.dart';
import 'package:chatapp/src/features/auth/domain/entities/user_profile_entity.dart';
import 'package:chatapp/src/features/chats/presentation/contacts/bloc/contacts_bloc.dart';
import 'package:chatapp/src/features/chats/presentation/contacts/bloc/contacts_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  static const routeName = '/contacts';

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ContactsBloc>(
      create: (_) => locator(),
      child: const _ContactsScreen(),
    );
  }
}

class _ContactsScreen extends StatelessWidget {
  const _ContactsScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
      ),
      body: BlocBuilder<ContactsBloc, ContactsState>(
        builder: (_, state) {
          if (state is LoadedContactsState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is ErrorContactsState) {
            return Center(
              child: Text('Error: ${state.exception.toString()}'),
            );
          }
          return StreamBuilder<List<UserProfileEntity>>(
            stream: state.contactsStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text('No contacts available'),
                );
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    UserProfileEntity contact = snapshot.data![index];
                    return ListTile(
                      leading: CircleAvatar(
                        child: CachedNetworkImage(imageUrl: contact.photoURL ?? ''),
                      ),
                      title: Text(contact.displayName ?? contact.uid),
                      // Add more widgets to display other chat information
                    );
                  },
                );
              }
            },
          );
        },
      ),
    );
  }
}
