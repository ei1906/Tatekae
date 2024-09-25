import 'package:flutter/material.dart';
import 'package:tatekae/main.dart';

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
