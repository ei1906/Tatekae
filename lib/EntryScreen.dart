import 'package:flutter/material.dart';
import 'package:tatekae/main.dart';

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
    int headCount = args['headCount'];
    // テキストフィールドを人数分用意
    List<Widget> paymentWidgets = getFormList(headCount);
    // 立替総額を取得
    int totalPayment = args['payment'];

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
