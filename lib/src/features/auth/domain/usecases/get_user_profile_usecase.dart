import 'package:chatapp/src/core/usecases/usecase.dart';
import 'package:chatapp/src/features/auth/domain/entities/user_profile_entity.dart';
import 'package:chatapp/src/features/auth/domain/repository/auth_repository.dart';

class GetUserProfileUseCase implements UseCase<UserProfileEntity, String> {
  final AuthRepository _authRepository;

  const GetUserProfileUseCase(this._authRepository);

  @override
  Future<UserProfileEntity> call({String? params}) {
    if (params != null) {
      return _authRepository.getUserProfile(params);
    }
    throw (Exception('params is empty'));
  }
}
