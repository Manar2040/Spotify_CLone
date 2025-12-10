import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/features/auth/model/user_model.dart';
import 'package:client/features/auth/repositories/auth_local_repository.dart';
import 'package:client/features/auth/repositories/auth_remote_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'auth_viewmodel.g.dart';

@riverpod
class AuthViewModel extends _$AuthViewModel{
  late AuthRemoteRepository _authRemoteRepository;
  late AuthLocalRepository _authLocalRepository;
  late CurrentUserNotifier _currentUserNotifier;

  @override
  AsyncValue<UserModel>? build() {
    _authRemoteRepository=ref.watch(authRemoteRepositoryProvider);
    _authLocalRepository=ref.watch(authLocalRepositoryProvider);
    _currentUserNotifier=ref.watch(currentUserProvider.notifier);
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
    _currentUserNotifier.addUser(user);
    return state=AsyncValue.data(user);
  }
  
 Future<UserModel?> getData() async {
  if (!ref.mounted) return null;  // حماية من البداية
  state = const AsyncValue.loading();

  final token = _authLocalRepository.getToken();
  if (token == null) return null;

  final res = await _authRemoteRepository.getCurrentUserData(token);

  if (!ref.mounted) return null; // حماية بعد async

  return res.fold(
    (l) {
      if (!ref.mounted) return null;
      state = AsyncValue.error(l.message, StackTrace.current);
      return null;
    },
    (r) {
      if (!ref.mounted) return null;
      state =_getDataSuccess(r);
      return r;
    },
  );
}

  AsyncValue<UserModel>? _getDataSuccess(UserModel user) {
    _currentUserNotifier.addUser(user);
    return state=AsyncValue.data(user);
  }
}