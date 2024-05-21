import 'package:flutter/material.dart';
import 'package:tatekae/PaymentManager.dart';

// 共有資源
PaymentManager pm = PaymentManager();

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
  // 人数headcntのテキストフィールドを管理
  final TextEditingController headcntController = TextEditingController();
  // 立替額のテキストフィールド
  final TextEditingController paymentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 200,
              child: getTextField('人数', headcntController),
            ),
            SizedBox(height: 20),
            Container(
                width: 200, child: getTextField('立替金額', paymentController)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // 人数と立替金額が空でなかったときだけonPressedに属性を付与
                if (headcntController.text.isNotEmpty &&
                    paymentController.text.isNotEmpty) {
                  Navigator.pushNamed(
                    context,
                    '/entry',
                    arguments: {
                      'headCount': headcntController.text,
                      'payment': paymentController.text,
                    },
                  );
                }
              },
              child: Text('精算開始'),
            ),
          ],
        ),
      ),
    );
  }

  Widget getTextField(String text, TextEditingController ctr) {
    return TextFormField(
        controller: ctr,
        decoration: InputDecoration(
          labelText: text,
        ));
  }
}

class EntryScreen extends StatelessWidget {
  // 名前一覧のテキストフィールドを管理
  final List<TextEditingController> nameController = [];
  // (現)立替金額のテキストフィールド
  final List<TextEditingController> nowPaymentController = [];
  // (最終)立替金額のテキストフィールド
  final List<TextEditingController> finalPaymentController = [];

  @override
  Widget build(BuildContext context) {
    // 遷移前の画面から渡されたものを args に格納
    final Map args = ModalRoute.of(context)!.settings.arguments as Map;

    // 前画面から渡された headCount を取得
    int headCount = int.parse(args['headCount']);
    // テキストフィールドを人数分用意
    List<Widget> paymentWidgets = getFormList(headCount);
    // 立替総額を取得
    int totalPayment = int.parse(args['payment']);

    paymentWidgets.add(
      ElevatedButton(
        onPressed: () {
          // pmをリセット
          pm.clearPayment();
          // pmに登録していく
          String name;
          int nowP, finalP;
          for (int i = 0; i < headCount; i++) {
            // 名前を取得
            if (nameController[i].text.isEmpty) {
              // 名前が入力されてない場合は連番
              name = "Person ${i + 1}";
            } else {
              name = nameController[i].text;
            }
            // （現）立替金額を取得
            if (nowPaymentController[i].text.isEmpty) {
              if (i == 0)
                nowP = totalPayment;
              else
                nowP = 0;
            } else {
              nowP = int.parse(nowPaymentController[i].text);
            }
            // (最終)立替金額を取得
            if (finalPaymentController[i].text.isEmpty) {
              // 全員均等に支払い(小数点切り上げ)
              finalP = ((totalPayment + headCount - 1) / headCount).ceil();
            } else {
              finalP = int.parse(finalPaymentController[i].text);
            }
            pm.setIndivisualPayment(name, nowP, finalP);
          }

          // 遷移
          Navigator.pushNamed(
            context,
            '/settlement',
            arguments: {},
          );
        },
        child: Text('精算開始'),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Entry'),
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

  List<Widget> getFormList(int num) {
    List<Widget> ret = [];
    for (int i = 0; i < num; i++) {
      nameController.add(TextEditingController());
      nowPaymentController.add(TextEditingController());
      finalPaymentController.add(TextEditingController());
      ret.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly, // 要素間のスペースを均等に
          children: [
            Expanded(
              child: getTextForm('名前 ${i + 1}', nameController[i]),
            ),
            Expanded(
              child: getTextForm('現在の支払額', nowPaymentController[i]),
            ),
            Expanded(
              child: getTextForm('最終的な支払額', finalPaymentController[i]),
            ),
          ],
        ),
      );
      ret.add(SizedBox(height: 20)); // 各Rowの間にスペースを追加
    }
    return ret;
  }

  Widget getTextForm(String labelText, TextEditingController ctr) {
    return TextFormField(
      controller: ctr,
      decoration: InputDecoration(
        labelText: labelText,
      ),
    );
  }
}

class SettlementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // pmから全員分の名前を取得
    List<String> name = pm.getMemberName();
    // プルダウンメニューに初期値をセット
    final ValueNotifier<String?> sender = ValueNotifier<String?>(name[0]);
    final ValueNotifier<String?> reciever = ValueNotifier<String?>(name[0]);
    // 表示するウィジェット
    List<Widget> child = [];
    child.add(getPullDownMenu(sender, name));
    child.add(getPullDownMenu(reciever, name));
    return Scaffold(
      appBar: AppBar(
        title: Text('Settlement'),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: child,
      )),
    );
  }

  Widget getPullDownMenu(
      ValueNotifier<String?> selectedItem, List<String> selectionList) {
    return ValueListenableBuilder<String?>(
      valueListenable: selectedItem,
      builder: (context, value, child) {
        return DropdownButton<String?>(
          hint: Text('Select an item'),
          value: value,
          onChanged: (String? newValue) {
            selectedItem.value = newValue;
          },
          items: selectionList.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        );
      },
    );
  }
}
