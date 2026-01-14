import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:prj_final_prm/features/auth/domain/usecases/login_usecase.dart';
import 'package:prj_final_prm/features/auth/domain/usecases/logout_usecase.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/presentation/widgets/widgets.dart';
import '../../../../i18n/strings.g.dart';
import '../mobx/auth_store.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late final _authStore = AuthStore(
    loginUseCase: getIt<LoginUseCase>(),
    logoutUseCase: getIt<LogoutUseCase>(),
  );

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      _authStore.login(
        _emailController.text,
        _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    
    return Scaffold(
      appBar: AppBarSimple(
        title: t.login,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.go(AppRoutes.settings),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: t.email,
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return t.pleaseEnterEmail;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: t.password,
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return t.pleaseEnterPassword;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Observer(
                builder: (_) {
                  if (_authStore.errorMessage != null) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(_authStore.errorMessage!),
                          backgroundColor: Theme.of(context).colorScheme.error,
                        ),
                      );
                      _authStore.clearError();
                    });
                  }

                  return AppPrimaryButton(
                    text: t.login,
                    onPressed: _handleLogin,
                    isLoading: _authStore.isLoading,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
