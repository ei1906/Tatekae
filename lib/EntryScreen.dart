import 'package:flutter/material.dart';
import 'package:tatekae/PaymentManager.dart';
import 'package:provider/provider.dart';

class EntryScreen extends StatefulWidget {
  @override
  _EntryScreenState createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen> {
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Consumer<PaymentManager>(builder: (context, pm, child) {
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
                  children: getFormList(size, pm),
                ),
              ),
            ),
            // 精算開始ボタン
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  pm.initSenderReciever();
                  if (pm.checkPlusPayment()) {
                    // 全てのmustPaymentが正なら精算画面へ
                    Navigator.pushNamed(context, '/settlement');
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("確認"),
                          content:
                              const Text("支払額がマイナスの人がいます\nこのまま精算を行ってもよろしいですか？"),
                          actions: [
                            TextButton(
                              child: const Text("いいえ"),
                              onPressed: () => Navigator.pop(context),
                            ),
                            TextButton(
                                child: const Text("はい"),
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.pushNamed(context, '/settlement');
                                }),
                          ],
                        );
                      },
                    );
                  }
                },
                child: const Text('精算開始'),
              ),
            ),
          ],
        ),
      );
    });
  }

  List<Widget> getFormList(Size size, PaymentManager pm) {
    List<Widget> ret = [];
    // 立替者だけ最終支払額のフォームはなし
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
                  initialValue: pm.getAdvancePayerStatus().getName(),
                  onChanged: (value) {
                    pm.getAdvancePayerStatus().setName(value);
                  },
                ),
              ),
              SizedBox(width: size.width * 0.07),
              // 最終支払額
              SizedBox(
                width: size.width * 0.3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '最終的な支払額',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black, // ラベル風の色
                      ),
                    ),
                    const SizedBox(height: 4), // ラベルとの間隔を確保
                    Text(
                      pm.getAdvancePayerStatus().getMustPayment().toString(),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
    // 立替者以外の入力フォーム
    for (int i = 1; i < pm.getMemberNum(); i++) {
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
                      pm.entryMustPayment(i, int.parse(value));
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
