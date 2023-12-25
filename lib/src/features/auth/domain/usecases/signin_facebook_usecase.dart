import 'package:chatapp/src/core/usecases/usecase.dart';
import 'package:chatapp/src/features/auth/domain/repository/auth_repository.dart';

class SignInWithFacebookUseCase implements UseCase<void, void> {
  final AuthRepository _authRepository;

  SignInWithFacebookUseCase(this._authRepository);

  @override
  Future<void> call({void params}) {
    return _authRepository.signIngWithFacebook();
  }
}
