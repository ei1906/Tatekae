import 'package:flutter/material.dart';
import 'main.dart';
import 'package:flutter/services.dart';

class EntryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    final Map args = ModalRoute.of(context)!.settings.arguments as Map;
    int headCount = args['headCount'];
    int totalPayment = args['payment'];

    pm.init(headCount, totalPayment);

    List<Widget> paymentWidgets = getFormList(size);

    return Scaffold(
      backgroundColor: const Color(0xE9f5f5f5),
      appBar: AppBar(
        title: const Text(
          'メンバーと支払額の設定',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          // ヘッダー部分
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'メンバー情報を入力してください',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          // 入力フォームリスト
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: paymentWidgets,
              ),
            ),
          ),
          // 精算開始ボタン
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/settlement', arguments: {});
              },
              child: const Text('精算開始'),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> getFormList(Size size) {
    List<Widget> ret = [];
    for (int i = 0; i < pm.getMemberNum(); i++) {
      ret.add(
        Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 名前入力フォーム */
                SizedBox(
                  width: size.width * 0.4,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: '名前',
                    ),
                    initialValue:
                        pm.getIndivisualPaymentStatusByIndex(i).getName(),
                    onChanged: (value) {
                      pm.getIndivisualPaymentStatusByIndex(i).setName(value);
                    },
                  ),
                ),
                SizedBox(width: size.width * 0.07),
                // 現在の支払額入力フォーム
                /*    TextFormField(
                  decoration: const InputDecoration(
                    labelText: '現在の支払額',
                  ),
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
                const SizedBox(width: 3),*/
                // 最終支払額入力フォーム
                SizedBox(
                  width: size.width * 0.3,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: '最終的な支払額',
                    ),
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
          ),
        ),
      );
    }
    return ret;
  }
}
