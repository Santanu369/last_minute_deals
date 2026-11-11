import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lmd_app/core/services/notification_service.dart';
import 'package:lmd_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:lmd_app/features/auth/presentation/cubit/auth_status.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lmd_app/app/shell/navbar_cubit.dart';
import 'package:lmd_app/core/theme/app_text.dart';
import 'package:lmd_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:lmd_app/features/auth/presentation/pages/auth_wrapper.dart';
import 'package:lmd_app/features/home/presentation/cubit/home_cubit.dart';
import 'package:lmd_app/features/home/presentation/pages/stay_home.dart';
import 'package:lmd_app/features/hotel/data/services/hotel_service.dart';
import 'package:lmd_app/features/hotel/presentation/cubit/hotel_cubit.dart';
import 'package:lmd_app/features/hotel/presentation/cubit/hotel_search_cubit.dart';
import 'package:lmd_app/features/payment/data/services/payment_service_impl.dart';
import 'package:lmd_app/features/payment/presentation/cubit/booking_details_cubit.dart';
import 'package:lmd_app/features/payment/presentation/cubit/payment_cubit.dart';
import 'package:lmd_app/features/payment/presentation/cubit/stay_quote_cubit.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit()),
        BlocProvider(create: (_) => HomeCubit()),
        BlocProvider(create: (_) => HotelSearchCubit(HotelService())),
        BlocProvider(create: (_) => HotelCubit(HotelService())),
        BlocProvider(create: (_) => NavbarCubit()),
        BlocProvider(create: (_) => StayQuoteCubit(PaymentServiceImpl())),
        BlocProvider(create: (_) => PaymentCubit(PaymentServiceImpl())),
        BlocProvider(create: (_) => BookingDetailsCubit(PaymentServiceImpl())),
      ],
      child: BlocListener<AuthCubit, AuthState>(
        listenWhen: (a, b) => a.status != b.status,
        listener: (_, state) {
          if (state.status == AuthStatus.authenticated) {
            NotificationService.instance.registerWithBackend();
          }
        },
        child: ScreenUtilInit(
          designSize: const Size(390, 844),
          minTextAdapt: true,
          ensureScreenSize: true,
          fontSizeResolver: (size, util) =>
              FontSizeResolvers.width(size, util) * AppText.fontScale,
          splitScreenMode: true,
          builder: (_, _) => MaterialApp(
            scaffoldMessengerKey: NotificationService.instance.messengerKey,
            title: 'Last Minutes Deal',
            theme: ThemeData(
              primaryColor: Colors.white,
              scaffoldBackgroundColor: Colors.white,
              textTheme: GoogleFonts.interTextTheme(),
            ),
            debugShowCheckedModeBanner: false,
            locale: context.locale,
            supportedLocales: context.supportedLocales,
            localizationsDelegates: context.localizationDelegates,
            home: const AuthWrapper(),
          ),
        ),
      ),
    );
  }
}
