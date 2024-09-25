import 'package:flutter/material.dart';
import 'package:tatekae/Space.dart';
//import 'package:tatekae/main.dart';

class TitleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TitleBody(),
      ),
    );
  }
}

class TitleBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        getTitleLogo(),
        getTitleForms(),
      ],
    );
  }

  Widget getTitleLogo() {
    return Text("ここにロゴ");
  }

  Widget getTitleForms() {
    return TitleForms();
  }
}

class TitleForms extends StatefulWidget {
  @override
  _TitleFormsState createState() => _TitleFormsState();
}

class _TitleFormsState extends State<TitleForms> {
  // 状態を保持するグローバル変数
  int member = 2;
  List<int> select = [2, 3, 4, 5, 6, 7, 8, 9, 10];

  @override
  Widget build(BuildContext context) {
    return getForms();
  }

  Widget getForms() {
    return Column(children: [
      getMemberSelectButton(),
      const ColumnSpace(h: 20),
      getHumanIcons(),
    ]);
  }

  Widget getMemberSelectButton() {
    return DropdownMenu<int>(
      initialSelection: select.first,
      onSelected: (int? value) {
        setState(() {
          member = value!;
        });
      },
      dropdownMenuEntries: select.map<DropdownMenuEntry<int>>((int value) {
        return DropdownMenuEntry(value: value, label: value.toString());
      }).toList(),
    );
  }

  Widget getHumanIcons() {
    return Icon(Icons.person);
  }
}
