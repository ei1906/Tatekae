import 'package:flutter/material.dart';
import 'package:tatekae/main.dart';

class EntryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 遷移前の画面から渡されたものを args に格納
    final Map args = ModalRoute.of(context)!.settings.arguments as Map;
    // 前画面から渡された headCount を取得
    int headCount = args['headCount'];
    // 立替総額を取得
    int totalPayment = args['payment'];

    // pmを初期化
    pm.init(headCount, totalPayment);

    // テキストフィールドを人数分用意
    List<Widget> paymentWidgets = getFormList();
    paymentWidgets.add(
      ElevatedButton(
        onPressed: () {
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
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            children: paymentWidgets,
          ),
        ),
      ),
    );
  }

  List<Widget> getFormList() {
    List<Widget> ret = [];
    for (int i = 0; i < pm.getMemberNum(); i++) {
      ret.add(
        Row(
          children: [
            // 名前入力フォーム
            SizedBox(
              width: 200,
              child: TextFormField(
                initialValue: pm.getIndivisualPaymentStatusByIndex(i).getName(),
                onChanged: (value) {
                  pm.getIndivisualPaymentStatusByIndex(i).setName(value);
                },
              ),
            ),
            // 現在の支払額入力フォーム
            SizedBox(
              width: 200,
              child: TextFormField(
                initialValue: pm
                    .getIndivisualPaymentStatusByIndex(i)
                    .getNowPayment()
                    .toString(),
                onChanged: (value) {
                  pm
                      .getIndivisualPaymentStatusByIndex(i)
                      .setNowPayment(int.parse(value));
                },
              ),
            ),
            // 最終支払額入力フォーム
            SizedBox(
              width: 200,
              child: TextFormField(
                initialValue: pm
                    .getIndivisualPaymentStatusByIndex(i)
                    .getMustPayment()
                    .toString(),
                onChanged: (value) {
                  pm
                      .getIndivisualPaymentStatusByIndex(i)
                      .setMustPayment(int.parse(value));
                },
              ),
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
