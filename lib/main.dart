import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // 画面遷移で使う設定
      initialRoute: '/',
      routes: {
        // ルート画面をHomeScreen()に設定
        '/': (context) => TitleScreen(),
        // 情報の入力画面をEntryScreen()に設定
        '/entry': (context) => EntryScreen(),
        // 立替精算画面をSettlementScreen()に設定
        '/settlement': (context) => SettlementScreen(),
      },
    );
  }
}

class TitleScreen extends StatelessWidget {
  final TextEditingController numController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 200,
              child: TextFormField(
                controller: numController,
                decoration: InputDecoration(
                  labelText: '人数',
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: 200,
              child: TextFormField(
                controller: amountController,
                decoration: InputDecoration(
                  labelText: '立替金額',
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/entry',
                  arguments: {
                    'num': numController.text,
                    'amount': amountController.text,
                  },
                );
              },
              child: Text('精算開始'),
            ),
          ],
        ),
      ),
    );
  }
}

class EntryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map args = ModalRoute.of(context)!.settings.arguments as Map;

    int num = int.parse(args['num']);
    List<Widget> paymentWidgets = [];

    for (int i = 0; i < num; i++) {
      paymentWidgets.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly, // 要素間のスペースを均等に
          children: [
            Expanded(
              child: getTextForm('名前 ${i + 1}'),
            ),
            Expanded(
              child: getTextForm('現在の支払額'),
            ),
            Expanded(
              child: getTextForm('最終的な支払額'),
            ),
          ],
        ),
      );
      paymentWidgets.add(SizedBox(height: 20)); // 各Rowの間にスペースを追加
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('結果'),
      ),
      body: SingleChildScrollView(
        // スクロール可能にする
        padding: EdgeInsets.all(20),
        child: Column(
          children: paymentWidgets,
        ),
      ),
    );
  }

  Widget getTextForm(String labelText) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: labelText,
      ),
    );
  }
}

class SettlementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {}
}
