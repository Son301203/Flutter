import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_localizations/firebase_ui_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class LabelOverrides extends DefaultLocalizations {
  const LabelOverrides();

  @override
  String get emailInputLabel => 'Nhập địa chỉ email';

  @override
  String get passwordInputLabel => "Nhập mật khẩu";

  String get signInLabel => "Đăng nhập";

  String get registerLabel => "Đăng ký";

  String get forgottenPasswordLabel => "Quên mật khẩu";

  String get signInButtonLabel => "Đăng nhập";

  String get dontHaveAccountLabel => 'Chưa có tài khoản';
}

class FirebaseUIScreen extends StatefulWidget {
  const FirebaseUIScreen({super.key});

  @override
  State<FirebaseUIScreen> createState() => _FirebaseUIScreenState();
}

class _FirebaseUIScreenState extends State<FirebaseUIScreen> {
  final auth = FirebaseAuth.instance;
  final providers = [
    EmailAuthProvider(),
  ];
  @override
  Widget build(BuildContext context) {
    final currentUser = auth.currentUser;
    return MaterialApp(
      initialRoute: auth.currentUser == null ? '/sign-in' : '/providers',
      routes: {
        '/': (context) {
          return Scaffold(
            appBar: AppBar(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(currentUser?.photoURL ??
                    'https://mcdn.coolmate.me/image/March2023/avatar-meme-1457_724.jpg'),
              ),
              title: const Text('Home Screem'),
            ),
            body: const Placeholder(),
          );
        },
        '/sign-in': (context) {
          return SignInScreen(providers: providers, actions: [
            AuthStateChangeAction((context, state) {
              Navigator.pushReplacementNamed(context, '/providers');
            })
          ]);
        },
        '/providers': (context) {
          return ProfileScreen(
            actions: [
              SignedOutAction((context) {
                Navigator.pushReplacementNamed(context, '/sign-in');
              }),
            ],
          );
        },
      },
      title: 'Firebase UI demo',
      debugShowCheckedModeBanner: false,
      locale: const Locale('vi', 'VN'),
      supportedLocales: const [
        Locale('vi'),
        Locale('en'),
      ],
      localizationsDelegates: [
        FirebaseUILocalizations.withDefaultOverrides(const LabelOverrides()),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        FirebaseUILocalizations.delegate,
      ],
    );
  }
}