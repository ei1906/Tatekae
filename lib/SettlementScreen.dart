import 'package:flutter/material.dart';
import 'package:tatekae/main.dart';

class SettlementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settlement'),
      ),
      body: SingleChildScrollView(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            children: [
              PaymentForm(),
              PaymentTable(),
            ],
          ),
        ),
      ),
    );
  }
}

class PaymentForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // pmから全員分の名前を取得
    List<String> name = pm.getMemberName();
    // プルダウンメニューに初期値をセット
    final ValueNotifier<String?> sender = ValueNotifier<String?>(name[0]);
    final ValueNotifier<String?> reciever = ValueNotifier<String?>(name[0]);

    List<Widget> ret = [];
    ret.add(getPullDownMenu(sender, name));
    ret.add(const Text('--->'));
    ret.add(getPullDownMenu(reciever, name));

    return Row(children: ret);
  }

  Widget getPullDownMenu(
      ValueNotifier<String?> selectedItem, List<String> selectionList) {
    return ValueListenableBuilder<String?>(
      valueListenable: selectedItem,
      builder: (context, value, child) {
        return DropdownButton<String?>(
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

class PaymentTable extends StatefulWidget {
  @override
  _PaymentTableState createState() => _PaymentTableState();
}

class _PaymentTableState extends State<PaymentTable> {
  @override
  Widget build(BuildContext context) {
    return getTable();
  }

  Widget getTable() {
    return const Text('ここにテーブル');
  }
}
