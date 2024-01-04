import 'package:chatapp/src/core/components/app_button.dart';
import 'package:chatapp/src/core/components/app_text_form_field.dart';
import 'package:chatapp/src/core/utils/validators.dart';
import 'package:chatapp/src/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:chatapp/src/features/auth/presentation/bloc/auth/auth_state.dart';
import 'package:chatapp/src/features/auth/presentation/register/bloc/register_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SetNameAndPhotoScreen extends StatelessWidget {
  const SetNameAndPhotoScreen({Key? key}) : super(key: key);

  static const routeName = '/set-name-and-photo';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterBloc(context),
      child: const _SetNameAndPhotoScreen(),
    );
  }
}

class _SetNameAndPhotoScreen extends StatelessWidget {
  const _SetNameAndPhotoScreen();

  @override
  Widget build(BuildContext context) {
    final registerBloc = BlocProvider.of<RegisterBloc>(context, listen: true);
    final staticRegisterBloc = BlocProvider.of<RegisterBloc>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        elevation: 0,
        title: const Text(
          'Name',
        ),
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (_, state) {
          if (state is LoadingAuthState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Form(
                key: staticRegisterBloc.registerFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          const SizedBox(
                            height: 16,
                          ),
                          InkWell(
                            onTap: () => staticRegisterBloc.showImagePicker(context),
                            child: CircleAvatar(
                              radius: 50.0,
                              backgroundColor: Colors.grey[300],
                              child: registerBloc.getUserPhotoUrl(context) != null
                                  ? ClipOval(
                                      child: Image.network(
                                        registerBloc.getUserPhotoUrl(context)!,
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
                          const SizedBox(
                            height: 16,
                          ),
                          Text(
                            'Display Name',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          AppTextFormField(
                            title: staticRegisterBloc.getUserDisplayName(context),
                            validator: AppValidator.emptyValidator,
                            onSaved: staticRegisterBloc.onNameSaved,
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                        ],
                      ),
                    ),
                    AppButton(
                      onTap: () => staticRegisterBloc.submitChangeDisplayNameForm(context),
                      labelText: 'Save',
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
