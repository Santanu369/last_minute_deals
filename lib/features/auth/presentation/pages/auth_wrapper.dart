import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lmd_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:lmd_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:lmd_app/features/auth/presentation/cubit/auth_status.dart';
import 'package:lmd_app/features/home/presentation/cubit/home_cubit.dart';
import 'package:lmd_app/app/shell/widget_tree.dart';
import 'package:lmd_app/features/auth/presentation/pages/splash_screen.dart';

// import '../../providers/auth_provider.dart';

// import '../home/home_page.dart';

import 'package:lmd_app/features/auth/presentation/pages/login_page.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialized) {
      _initialized = true;

      Future.microtask(() async {
        await context.read<AuthCubit>().restoreSession();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    
    //   final authState = context.watch<AuthCubit>().state;

    //   if (authState.status == AuthStatus.loading) {
    //     return const Scaffold(body: Center(child: CircularProgressIndicator()));
    //   }

    //   if (authState.status == AuthStatus.authenticated) {
    //     return BlocProvider(create: (_) => HomeCubit(), child: const HomePage());
    //   }

    //   return LoginPage();
    // }
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        if (authState.status == AuthStatus.loading) {
          return const SplashScreen();

        }

        if (authState.status == AuthStatus.authenticated ||
            authState.status == AuthStatus.offline) {
          return BlocProvider(
            create: (_) => HomeCubit(),
            child: const WidgetTree(),
          );
        }

        return LoginPage();
      },
    );
  }
}
