import 'package:flutter/material.dart';
import 'package:tatekae/IndividualPayment.dart';

class PaymentManager extends ChangeNotifier {
  final MAX_MEMBER = 10;
  /* メンバ変数 */
  int _headCount = 0;
  List<IndividualPayment> _paymentStatus = [];

  /* constructor */
  void init(int cnt, int payment) {
    clearPayment();

    _headCount = cnt;
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

  void movePay(String from, String to, int payment) {
    if (isRegistered(from) && isRegistered(to)) {
      _paymentStatus[_getIndexFromName(from)].addPayment(payment);
      _paymentStatus[_getIndexFromName(to)].subPayment(payment);
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
}
