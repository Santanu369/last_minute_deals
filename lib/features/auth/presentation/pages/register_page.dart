import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lmd_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:lmd_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:lmd_app/features/auth/presentation/cubit/auth_status.dart';
import 'package:lmd_app/features/auth/presentation/widgets/auth_widgets.dart';
import 'package:lmd_app/features/auth/presentation/widgets/register_card.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }

        if (state.status == AuthStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message ?? 'Authentication failed')),
          );
        }
      },
      child: const AuthPageLayout(
        title: 'Create Account',
        subtitle: 'Sign up for a new Last Minutes Deal Account',
        card: RegisterCard(),
      ),
    );
  }
}