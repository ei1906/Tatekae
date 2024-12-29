import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TitleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: SingleChildScrollView(
        child: TitleBody(),
      ),
    );
  }
}

class TitleBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 50),
        getTitleLogo(),
        const SizedBox(height: 30),
        Container(
          height: size.height * 0.7,
          child: getTitleForms(),
        ),
      ],
    );
  }

  Widget getTitleLogo() {
    return Column(
      children: [
        Image.asset(
          'assets/logo.png',
          height: 100,
        ),
        const Text(
          "割り勘レコーダー",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget getTitleForms() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: TitleForms(),
    );
  }
}

class TitleForms extends StatefulWidget {
  @override
  _TitleFormsState createState() => _TitleFormsState();
}

class _TitleFormsState extends State<TitleForms> {
  int headCount = 2;
  int payment = 0;
  final List<int> select = [2, 3, 4, 5, 6, 7, 8, 9, 10];

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
        child: Column(
          children: [
            getMemberSelectButton(),
            const SizedBox(height: 20),
            getHumanIcons(),
          ],
        ),
      ),
    );
  }

  Widget getMemberSelectButton() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            getSelectMenu(),
            const SizedBox(width: 8),
            const Text("人で"),
            const SizedBox(width: 8),
            getTextField(),
            const SizedBox(width: 8),
            const Text("円精算する")
          ],
        ),
        const SizedBox(height: 10),
        getButton(),
      ],
    );
  }

  Widget getSelectMenu() {
    return DropdownButton<int>(
      value: headCount,
      items: select
          .map((value) => DropdownMenuItem(
                value: value,
                child: Text(value.toString()),
              ))
          .toList(),
      onChanged: (value) {
        setState(() {
          headCount = value!;
        });
      },
    );
  }

  Widget getTextField() {
    return SizedBox(
      width: 80,
      child: TextField(
        maxLength: 7,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          counterText: '',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          filled: true,
          fillColor: Colors.grey[200],
        ),
        onChanged: (value) {
          if (value.isNotEmpty) {
            payment = int.parse(value);
          }
        },
      ),
    );
  }

  Widget getButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
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
      child: const Text("次へ"),
    );
  }

  Widget getHumanIcons() {
    return SizedBox(
      width: 200,
      child: GridView.count(
        crossAxisCount: 5,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        children: List.generate(
          headCount,
          (index) => const Icon(
            Icons.person,
            color: Colors.blueAccent,
          ),
        ),
      ),
    );
  }
}
