import 'package:flutter/material.dart';
import 'package:tatekae/IndividualPayment.dart';

class PaymentManager extends ChangeNotifier {
  final MAX_MEMBER = 10;
  /* メンバ変数 */
  int _headCount = 0, _paymentSum = 0;
  List<IndividualPayment> _paymentStatus = [];
  String _sender = '', _reciever = '';

  /* constructor */
  void init(int cnt, int payment) {
    clearPayment();

    _headCount = cnt;
    _paymentSum = payment;
    // リストの先頭は立替者
    _paymentStatus.add(IndividualPayment("立替者", payment, payment));
    // 他のメンバーは 精算者A, B, ...
    int index = 'A'.codeUnitAt(0);
    for (int i = 0; i < _headCount - 1; i++) {
      _paymentStatus
          .add(IndividualPayment("精算者" + String.fromCharCode(index + i), 0, 0));
    }
  }

  /* getter */
  int getMemberNum() {
    return _headCount;
  }

  List<String> getMemberName() {
    List<String> ret = [];
    for (int i = 0; i < _headCount; i++) {
      ret.add(_paymentStatus[i].getName());
    }
    return ret;
  }

  String getFirstMemberName() {
    return getMemberName().first;
  }

  List<IndividualPayment> getAllPaymentStatus() {
    return _paymentStatus;
  }

  IndividualPayment getIndivisualPaymentStatusByName(String name) {
    if (!isRegistered(name)) {
      // nameが登録されていない
      return IndividualPayment('', 0, 0); // null代わり
    } else {
      return _paymentStatus[_getIndexFromName(name)];
    }
  }

  IndividualPayment getIndivisualPaymentStatusByIndex(int index) {
    if (index < _headCount) {
      return _paymentStatus[index];
    } else {
      return IndividualPayment('', 0, 0); // null代わり
    }
  }

  IndividualPayment getAdvancePayerStatus() {
    // リストの先頭が立替者
    return _paymentStatus.first;
  }

  String getSender() {
    return _sender;
  }

  String getReciever() {
    return _reciever;
  }

  /* setter */
  bool addIndivisualPayment(String name, int nowPay, int mustPay) {
    if (_headCount < MAX_MEMBER) {
      _paymentStatus.add(IndividualPayment(name, nowPay, mustPay));
      _headCount++;
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  void setSender(String name) {
    _sender = name;
    notifyListeners();
    return;
  }

  void setReciever(String name) {
    _reciever = name;
    notifyListeners();
    return;
  }

  void initSenderReciever() {
    _sender = getFirstMemberName();
    _reciever = getFirstMemberName();
    notifyListeners();
    return;
  }

  /* others */
  bool isRegistered(String name) {
    if (_getIndexFromName(name) != -1) {
      return true;
    } else {
      return false;
    }
  }

  void printPaymentStatus() {
    for (int i = 0; i < _headCount; i++) {
      _paymentStatus[i].printPayment();
    }
    return;
  }

  void movePay(int payment) {
    if (isRegistered(_sender) && isRegistered(_reciever)) {
      _paymentStatus[_getIndexFromName(_sender)].addPayment(payment);
      _paymentStatus[_getIndexFromName(_reciever)].subPayment(payment);
      notifyListeners();
    }
    return;
  }

  void clearPayment() {
    _headCount = 0;
    _paymentStatus = [];
    notifyListeners();
  }

  int _getIndexFromName(String name) {
    for (int i = 0; i < _headCount; i++) {
      if (_paymentStatus[i].getName() == name) {
        return i;
      }
    }
    return -1;
  }

  /* Entry関連 */
  void entryMustPayment(int index, int mustPay) {
    // 対象のユーザを更新
    getIndivisualPaymentStatusByIndex(index).setMustPayment(mustPay);
    // 立替者の値を更新
    int payerSum = 0;
    for (int i = 1; i < _headCount; i++) {
      // 精算者のmustPayを加算
      payerSum += _paymentStatus[i].getMustPayment();
    }
    getAdvancePayerStatus().setMustPayment(_paymentSum - payerSum);
    // notifyListeners
    notifyListeners();
  }

  bool checkPlusPayment() {
    for (int i = 0; i < _headCount; i++) {
      if (_paymentStatus[i].getMustPayment() < 0) return false;
    }
    return true;
  }

  bool checkNameConflict() {
    Map<String, bool> nt = {};
    for (String x in getMemberName()) {
      if (nt.containsKey(x)) {
        return false;
      }
      nt[x] = true;
    }
    return true;
  }
}
