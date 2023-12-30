import 'package:chatapp/src/core/usecases/usecase.dart';
import 'package:chatapp/src/features/auth/domain/repository/auth_repository.dart';

class SignInCodeUseCase implements UseCase<void, Map<String, dynamic>> {
  final AuthRepository _authRepository;

  SignInCodeUseCase(this._authRepository);

  @override
  Future<void> call({Map<String, dynamic>? params}) {
    if (params != null) {
      return _authRepository.signInWithCode(
        params['verificationId'],
        params['smsCode'],
      );
    }
    throw Exception('params is empty');
  }
}
