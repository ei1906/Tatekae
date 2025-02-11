import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tatekae/main.dart';

class SettlementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

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
  }

  Widget getSettlementForms(Size size) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: size.width * 0.9,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              color: Colors.white,
              child: PaymentForm(),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: size.width * 0.9,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              color: Colors.white,
              child: PaymentTable(),
            ),
          ),
        ],
      ),
    );
  }
}

class PaymentForm extends StatefulWidget {
  @override
  _PaymentFormState createState() => _PaymentFormState();
}

class _PaymentFormState extends State<PaymentForm> {
  int movePayment = 0;

  @override
  Widget build(BuildContext context) {
    // pmから全員分の名前を取得
    List<String> name = pm.getMemberName();
    // プルダウンメニューに初期値をセット
    final ValueNotifier<String?> sender = ValueNotifier<String?>(name[0]);
    final ValueNotifier<String?> reciever = ValueNotifier<String?>(name[0]);

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(children: [
        getPaymentForm(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            getPullDownMenu(sender, name),
            const Text('--->'),
            getPullDownMenu(reciever, name),
          ],
        ),
        getButton(sender, reciever),
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

  Widget getButton(
      ValueNotifier<String?> sender, ValueNotifier<String?> reciever) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF34495E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: () {
        setState(() {
          if (sender.value != null && reciever.value != null) {
            pm.movePay(sender.value!, reciever.value!, movePayment);
          }
        });
        /*showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("タイトル"),
              content: Text("メッセージ内容"),
              actions: [
                TextButton(
                  child: Text("Cancel"),
                  onPressed: () => Navigator.pop(context),
                ),
                TextButton(
                  child: Text("OK"),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            );*/
        //},
        //);

        pm.printPaymentStatus();
        print("from:" +
            sender.value! +
            ", reciever:" +
            reciever.value! +
            ", " +
            movePayment.toString());
      },
      child: const Text(
        "精算",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
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
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Center(
        child: DataTable(
          columns: const <DataColumn>[
            DataColumn(
              label: Expanded(
                child: Text(
                  'Who',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ),
            DataColumn(
              label: Expanded(
                child: Text(
                  'Paid Now',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ),
            DataColumn(
              label: Expanded(
                child: Text(
                  'Paid Finally ',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ),
          ],
          rows: getTable(),
        ),
      ),
      //),
    );
  }

  List<DataRow> getTable() {
    return pm.getAllPaymentStatus().map((row) {
      return DataRow(
        cells: <DataCell>[
          DataCell(tableText(row.getName())),
          DataCell(tableText(row.getNowPayment().toString())),
          DataCell(tableText(row.getMustPayment().toString())),
        ],
      );
    }).toList();
  }

  Widget tableText(String s) {
    return Text(
      s,
      style: TextStyle(fontSize: 13),
    );
  }
}
