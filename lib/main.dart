import 'package:flutter/material.dart';
import 'package:tatekae/PaymentManager.dart';
import 'package:tatekae/TitleScreen.dart';
import 'package:tatekae/EntryScreen.dart';
import 'package:tatekae/SettlementScreen.dart';

// 共有資源
PaymentManager pm = PaymentManager();
const MAX_MEMBER = 10;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // 画面遷移で使う設定
      initialRoute: '/title',
      routes: {
        // ルート画面をHomeScreen()に設定
        '/title': (context) => TitleScreen(),
        // 情報の入力画面をEntryScreen()に設定
        '/entry': (context) => EntryScreen(),
        // 立替精算画面をSettlementScreen()に設定
        '/settlement': (context) => SettlementScreen(),
      },
    );
  }
}
