// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pw5/data/repositories/auth_repository.dart';
import 'package:pw5/ui/pages/layout/layout_screen.dart';
import 'package:pw5/ui/pages/login/login_bloc/login_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => AuthRepository(),
      child: BlocProvider(
        create: (context) => LoginBloc(
          authRepository: RepositoryProvider.of<AuthRepository>(context),
        ),
        child: Scaffold(
          body: BlocConsumer<LoginBloc, LoginState>(
            listener: (context, state) async {
              if (state is HasToken) {
                AuthRepository a = AuthRepository();
                a.postUserToDb();
                await Future.delayed(const Duration(milliseconds: 500));
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LayoutScreen()),
                    (route) => false);
              }
            },
            builder: (context, state) {
              if (state is Initial) {
                BlocProvider.of<LoginBloc>(context).add(OnInitial());
                return const SizedBox();
              } else if (state is CheckingToken || state is IsLoggingIn) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is HasNotToken) {
                String error = state is ErrorLogin ? state.error : "";
                return LoginLayout(state: state, error: error);
              } else {
                return const SizedBox();
              }
            },
          ),
        ),
      ),
    );
  }
}

class LoginLayout extends StatefulWidget {
  const LoginLayout({
    super.key,
    required this.state,
    required this.error,
  });

  final LoginState state;
  final String error;

  @override
  State<LoginLayout> createState() => _LoginLayoutState();
}

class _LoginLayoutState extends State<LoginLayout> {
  @override
  Widget build(BuildContext context) {
    LoginBloc bloc = BlocProvider.of<LoginBloc>(context);

    return Column(
      children: [
        Expanded(
          child: Container(
            color: Colors.white,
            child: Center(
              child: SvgPicture.asset(
                'assets/icons/icona_persona.svg',
                width: 200,
                height: 100,
              ),
            ),
          ),
        ),
        Container(
          height: 50,
          decoration: const BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
          ),
        ),
        Expanded(
          child: Container(
            color: Colors.blue,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Login",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          fontSize: 36)),
                  const SizedBox(height: 10),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Text(
                      "use your microsoft account to access the application.",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 200, // Larghezza ridotta del bottone
                    child: ElevatedButton(
                      onPressed: () async {
                        await Future.delayed(const Duration(milliseconds: 500));
                        bloc.add(OnLogin());
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.blue,
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: Colors.blue),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: InkResponse(
                        splashColor: Colors.lightBlueAccent.withOpacity(0.5),
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          await Future.delayed(
                              const Duration(milliseconds: 500));
                          bloc.add(OnLogin());
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          child: const Text("Login Azure AD"),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Visibility(
                    visible: widget.state is ErrorLogin,
                    child: Text(
                      widget.error,
                      style: Theme.of(context)
                          .textTheme
                          .labelMedium
                          ?.copyWith(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
