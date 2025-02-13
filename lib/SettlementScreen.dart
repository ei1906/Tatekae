import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tatekae/PaymentManager.dart';
import 'package:provider/provider.dart';

class SettlementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Consumer<PaymentManager>(builder: (context, pm, child) {
      return Scaffold(
        backgroundColor: const Color(0xE9f5f5f5),
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          title: const Text(
            'Settlement',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(
              size.width * 0.05, 20.0, size.width * 0.05, 20.0),
          child: getSettlementForms(size),
        ),
      );
    });
  }

  Widget getSettlementForms(Size size) {
    return SingleChildScrollView(
      child: SettlementBody(),
    );
  }
}

class SettlementBody extends StatefulWidget {
  @override
  _SettlementBodyState createState() => _SettlementBodyState();
}

class _SettlementBodyState extends State<SettlementBody> {
  int movePayment = 0;
  // プルダウンメニューに初期値をセット
  final ValueNotifier<String?> sender = ValueNotifier<String?>('');
  final ValueNotifier<String?> reciever = ValueNotifier<String?>('');

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Consumer<PaymentManager>(builder: (context, pm, child) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: size.width * 0.9,
            child: getFormsCard(pm),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: size.width * 0.9,
            child: getTableCard(pm),
          ),
        ],
      );
    });
  }

  /* 精算金額などのフォーム関連 */
  Widget getFormsCard(PaymentManager pm) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.white,
      child: getPaymentForms(pm),
    );
  }

  Widget getPaymentForms(PaymentManager pm) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(children: [
        getPaymentForm(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            getPullDownMenu(sender, pm),
            const Text('--->'),
            getPullDownMenu(reciever, pm),
          ],
        ),
        getButton(sender, reciever, pm),
      ]),
    );
  }

  Widget getPaymentForm() {
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
            movePayment = int.parse(value);
          }
        },
      ),
    );
  }

  Widget getPullDownMenu(
      ValueNotifier<String?> selectedItem, PaymentManager pm) {
    List<String> name = pm.getMemberName();

    return ValueListenableBuilder<String?>(
      valueListenable: selectedItem,
      builder: (context, value, child) {
        return DropdownButton<String?>(
          value: value,
          onChanged: (String? newValue) {
            selectedItem.value = newValue;
          },
          items: name.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        );
      },
    );
  }

  Widget getButton(ValueNotifier<String?> sender,
      ValueNotifier<String?> reciever, PaymentManager pm) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF34495E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: () {
        setState(() {
          pm.movePay(sender.value!, reciever.value!, movePayment);
        });

        pm.printPaymentStatus();
      },
      child: const Text(
        "精算",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }

  /* 精算状況のテーブル関連 */
  Widget getTableCard(PaymentManager pm) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.white,
      child: getPaymentTable(pm),
    );
  }

  Widget getPaymentTable(PaymentManager pm) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Center(
        child: DataTable(
          columns: <DataColumn>[
            DataColumn(
              label: Expanded(
                child: tableColumnText('Who'),
              ),
            ),
            DataColumn(
              label: Expanded(
                child: tableColumnText('Paid Now'),
              ),
            ),
            DataColumn(
              label: Expanded(
                child: tableColumnText('Paid Finally'),
              ),
            ),
          ],
          rows: getTable(pm),
        ),
      ),
    );
  }

  List<DataRow> getTable(PaymentManager pm) {
    return pm.getAllPaymentStatus().map((row) {
      return DataRow(
        cells: <DataCell>[
          DataCell(tableRowText(row.getName())),
          DataCell(tableRowText(row.getNowPayment().toString())),
          DataCell(tableRowText(row.getMustPayment().toString())),
        ],
      );
    }).toList();
  }

  Widget tableColumnText(String s) {
    return Text(
      s,
      style: const TextStyle(fontStyle: FontStyle.italic),
    );
  }

  Widget tableRowText(String s) {
    return Text(
      s,
      style: const TextStyle(fontSize: 13),
    );
  }
}
