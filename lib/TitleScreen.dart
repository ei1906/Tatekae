import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  int headCount = 2;
  int payment = 0;
  final List<int> select = [2, 3, 4, 5, 6, 7, 8, 9, 10];

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
    return Row(
      children: [getSelectMenu(), getButton()],
    );
  }

  Widget getSelectMenu() {
    return DropdownMenu<int>(
      initialSelection: select.first,
      onSelected: (int? value) {
        setState(() {
          // memberを選ばれた値へ変更
          headCount = value!;
        });
      },
      dropdownMenuEntries: select.map<DropdownMenuEntry<int>>((int value) {
        return DropdownMenuEntry(value: value, label: value.toString());
      }).toList(),
    );
  }

  Widget getButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(
          context,
          '/entry',
          arguments: {
            "headCount": headCount,
            "payment": payment,
          },
        );
      },
      child: const Text("ここをクリック"),
    );
  }

  Widget getHumanIcons() {
    return SizedBox(
        width: 200,
        child: GridView.count(
          crossAxisCount: 5, // 1行あたり5個表示
          shrinkWrap: true, // GridViewが無限に広がらないように
          physics: const NeverScrollableScrollPhysics(), // 親のスクロールに任せる
          crossAxisSpacing: 8.0, // アイコン同士の横方向のスペース
          mainAxisSpacing: 8.0, // アイコン同士の縦方向のスペース
          children: List.generate(
            headCount, // memberの数だけアイコンを生成
            (index) => const Icon(Icons.person),
          ),
        ));
  }
}
