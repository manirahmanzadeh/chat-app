import 'package:chatapp/src/core/usecases/usecase.dart';
import 'package:chatapp/src/features/auth/domain/repository/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInCredentialUseCase implements UseCase<void, AuthCredential> {
  final AuthRepository _authRepository;

  SignInCredentialUseCase(this._authRepository);

  @override
  Future<void> call({AuthCredential? params}) {
    if (params != null) {
      return _authRepository.signInWithCredentials(params);
    }
    throw Exception('params is empty');
  }
}
