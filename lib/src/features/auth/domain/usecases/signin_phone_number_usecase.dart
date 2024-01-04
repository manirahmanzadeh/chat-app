import 'package:chatapp/src/core/usecases/usecase.dart';
import 'package:chatapp/src/features/auth/domain/repository/auth_repository.dart';

class SignInPhoneNumberUseCase implements UseCase<void, Map<String, dynamic>> {
  final AuthRepository _authRepository;

  SignInPhoneNumberUseCase(this._authRepository);

  @override
  Future<void> call({Map<String, dynamic>? params}) {
    if (params != null) {
      return _authRepository.signInWithPhoneNumber(
        params['phoneNumber'],
        params['onCodeSent'],
        params['onVerificationCompleted'],
        params['onVerificationFailed'],
      );
    }
    throw Exception('params is empty');
  }
}
