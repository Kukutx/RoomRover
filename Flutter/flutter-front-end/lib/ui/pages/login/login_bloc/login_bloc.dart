import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:pw5/data/repositories/auth_repository.dart';
import 'package:pw5/domain/helpers/oauth_config.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepository;
  static var log = Logger();

  LoginBloc({required this.authRepository}) : super(Initial()) {
    on<OnInitial>((event, emit) async {
      log.d("loigin");
      emit(CheckingToken());
      try {
        bool hasCachedInfo =
            await OauthConfig.aadOAuth.hasCachedAccountInformation;
        String token = await OauthConfig.aadOAuth.getAccessToken() ?? "";
        log.d("sto per emittare has token o has not");
        emit(
          hasCachedInfo && token.isNotEmpty
              ? HasToken(token)
              : HasNotToken(),
        );
      } catch (e) {
        emit(ErrorCheck());
      }
    });

    on<OnLogin>((event, emit) async {
      emit(IsLoggingIn());
      try {
        await authRepository.azureLogin();
        String token = await OauthConfig.aadOAuth.getAccessToken() ?? "";
        log.d(token);
        emit(HasToken(token));
      } catch (e) {
        emit(ErrorLogin(e.toString()));
      }
    });

  }
}