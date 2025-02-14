import 'package:flutter/material.dart';
import 'package:tatekae/PaymentManager.dart';
import 'package:provider/provider.dart';
import 'package:tatekae/TitleScreen.dart';
import 'package:tatekae/EntryScreen.dart';
import 'package:tatekae/SettlementScreen.dart';

void main() {
  runApp(
    ChangeNotifierProvider<PaymentManager>(
      create: (context) => PaymentManager(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // 画面遷移で使う設定
      initialRoute: '/title',
      routes: {
        // ルート画面をTitleScreen()に設定
        '/title': (context) => TitleScreen(),
        // 情報の入力画面をEntryScreen()に設定
        '/entry': (context) => EntryScreen(),
        // 立替精算画面をSettlementScreen()に設定
        '/settlement': (context) => SettlementScreen(),
      },
    );
  }
}
