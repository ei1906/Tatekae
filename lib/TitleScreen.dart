import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tatekae/Space.dart';
//import 'package:tatekae/main.dart';

class TitleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
        const ColumnSpace(h: 100),
        getTitleLogo(),
        getTitleForms(),
      ],
    );
  }

  Widget getTitleLogo() {
    return const Text("ここにロゴ");
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
    return Column(
      children: [
        Row(
          children: [
            getSelectMenu(),
            const Text("人で"),
            getTextField(),
            const Text("円精算する")
          ],
        ),
        getButton()
      ],
    );
  }

  Widget getSelectMenu() {
    return DropdownMenu<int>(
      initialSelection: select.first,
      onSelected: (int? value) {
        setState(() {
          // headCountを選ばれた値へ変更
          headCount = value!;
        });
      },
      dropdownMenuEntries: select.map<DropdownMenuEntry<int>>((int value) {
        return DropdownMenuEntry(value: value, label: value.toString());
      }).toList(),
    );
  }

  Widget getTextField() {
    return SizedBox(
        width: 80,
        child: TextField(
          maxLength: 7,
          keyboardType: TextInputType.number, // 数字用キーボードを表示
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly, // 数字のみを許可
          ],
          onChanged: (value) {
            // 空の場合のエラーハンドリング
            if (value.isNotEmpty) {
              payment = int.parse(value);
            }
          },
        ));
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
