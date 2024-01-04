import 'package:chatapp/src/core/components/drawer.dart';
import 'package:chatapp/src/core/locator.dart';
import 'package:chatapp/src/features/chats/domain/entities/chat_entity.dart';
import 'package:chatapp/src/features/chats/presentation/contacts/contacts_screen.dart';
import 'package:chatapp/src/features/chats/presentation/home/bloc/home_bloc.dart';
import 'package:chatapp/src/features/chats/presentation/home/bloc/home_event.dart';
import 'package:chatapp/src/features/chats/presentation/home/bloc/home_state.dart';
import 'package:chatapp/src/features/chats/presentation/home/components/chat_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const routeName = '/home';

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
      create: (_) => locator()
        ..addContext(context)
        ..add(const GetChatsHomeEvent()),
      child: const _HomeScreen(),
    );
  }
}

class _HomeScreen extends StatelessWidget {
  const _HomeScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat App'),
      ),
      drawer: const AppDrawer(),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (_, state) {
          if (state is LoadingHomeState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is ErrorHomeState) {
            return Center(
              child: Text('Error: ${state.exception.toString()}'),
            );
          }
          return StreamBuilder<List<ChatEntity>>(
            stream: state.chatsStream,
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
                  child: Text('Start a new chat'),
                );
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  padding: const EdgeInsets.only(top: 16),
                  itemBuilder: (context, index) {
                    ChatEntity chat = snapshot.data![index];
                    return ChatComponent(chat: chat);
                  },
                );
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, ContactsScreen.routeName),
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}
