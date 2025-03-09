import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:tatekae/PaymentManager.dart';
import 'package:provider/provider.dart';

class SendRecvManager {
  String user = '';

  SendRecvManager(String s) {
    user = s;
  }
}

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
  final IS_SENDER = 0, IS_RECIEVER = 1;

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
            getPullDownMenu(IS_SENDER, pm),
            const Text('--->'),
            getPullDownMenu(IS_RECIEVER, pm),
          ],
        ),
        getButton(pm),
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

  Widget getPullDownMenu(int senderORreciever, PaymentManager pm) {
    List<String> name = pm.getMemberName();

    if (senderORreciever % 2 == IS_SENDER) {
      return DropdownButton(
        value: pm.getSender(),
        onChanged: (String? newValue) {
          setState(() {
            pm.setSender(newValue!);
          });
        },
        items: name.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      );
    } else {
      return DropdownButton(
        value: pm.getReciever(),
        onChanged: (String? newValue) {
          setState(() {
            pm.setReciever(newValue!);
          });
        },
        items: name.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      );
    }
  }

  Widget getButton(PaymentManager pm) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF34495E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: () {
        setState(() {
          pm.movePay(movePayment);
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
          // 現在の支払額 < 最終支払額ならフォントカラーが赤になる
          DataCell(tableRowText(row.getName(),
              setTextColor(row.getNowPayment(), row.getMustPayment()))),
          DataCell(tableRowText(row.getNowPayment().toString(),
              setTextColor(row.getNowPayment(), row.getMustPayment()))),
          DataCell(tableRowText(row.getMustPayment().toString(), Colors.black)),
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

  Widget tableRowText(String s, Color c) {
    return Text(
      s,
      style: TextStyle(fontSize: 13, color: c),
    );
  }

  Color setTextColor(int nowPay, int mustPay) {
    if (nowPay < mustPay) {
      return Colors.red;
    } else {
      return Colors.black;
    }
  }
}
