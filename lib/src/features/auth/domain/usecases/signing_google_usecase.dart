import 'package:chatapp/src/core/usecases/usecase.dart';
import 'package:chatapp/src/features/auth/domain/repository/auth_repository.dart';

class SignInWithGoogleUseCase implements UseCase<void, void> {
  final AuthRepository _authRepository;

  SignInWithGoogleUseCase(this._authRepository);

  @override
  Future<void> call({void params}) {
    return _authRepository.signIngWithGoogle();
  }
}
