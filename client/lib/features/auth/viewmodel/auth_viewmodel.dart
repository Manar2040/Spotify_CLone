import 'package:client/features/auth/model/user_model.dart';
import 'package:client/features/auth/repositories/auth_local_repository.dart';
import 'package:client/features/auth/repositories/auth_remote_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'auth_viewmodel.g.dart';

@riverpod
class AuthViewModel extends _$AuthViewModel{
  late AuthRemoteRepository _authRemoteRepository;
  late AuthLocalRepository _authLocalRepository;

  @override
  AsyncValue<UserModel>? build() {
    _authRemoteRepository=ref.watch(authRemoteRepositoryProvider);
    _authLocalRepository=ref.watch(authLocalRepositoryProvider);
    return null;
  }

  Future<void> initSharedPreferences() async {
    await _authLocalRepository.init();
  }
  
  Future<void> signUpUser({
    required String name,
    required String email,
    required String password,
  }) async{
    state =const AsyncValue.loading();
    final res=  await _authRemoteRepository.signup(
      name:name,
      email:email,
      password:password,
    );

    final val = res.fold(
      (l) => state=AsyncValue.error(l.message, StackTrace.current,),       // AppFailure
      (r) => state=AsyncValue.data(r),  // UserModel
    );
    print(val);
  }

    Future<void> loginUser({
    required String email,
    required String password,
  }) async{
    state =const AsyncValue.loading();
    final res=  await _authRemoteRepository.login(
      email:email,
      password:password,
    );

    final val = res.fold(
      (l) => state=AsyncValue.error(l.message, StackTrace.current,),       // AppFailure
      (r) => _loginSuccess(r),  // UserModel
    );
    print(val);
  }
 AsyncValue<UserModel>? _loginSuccess(UserModel user) {
    _authLocalRepository.setToken(user.token);
    return state=AsyncValue.data(user);
  }
  
  Future<UserModel?> getData() async {
    state = const AsyncValue.loading();
    final token = _authLocalRepository.getToken();
    if(token!=null){
      //TODO: send a request to server to get the user data by token
    }
  }
}