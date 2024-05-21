import 'package:tatekae/IndivisualPayment.dart';

class PaymentManager {
  /* メンバ変数 */
  int member_num = 0;
  Map<String, IndividualPayment> payment_status = {};

  /* constructor */

  /* getter */
  int getMemberNum() {
    return member_num;
  }

  List<String> getMemberName() {
    List<String> ret = [];
    payment_status.forEach((key, value) {
      ret.add(key);
    });
    return ret;
  }

  Map<String, IndividualPayment> getAllPaymentStatus() {
    return payment_status;
  }

  IndividualPayment getIndivisualPaymentStatus(String name) {
    if (!isRegistered(name)) {
      // nameが登録されていない
      return IndividualPayment('', 0, 0);
    } else {
      return payment_status[name]!;
    }
  }

  /* setter */
  void setIndivisualPayment(String name, int now_pay, int must_pay) {
    payment_status[name] = IndividualPayment(name, now_pay, must_pay);
    member_num++;
    return;
  }

  void setAllPayment(
      List<String> names, List<int> now_pays, List<int> must_pays) {
    int size = names.length;
    for (int i = 0; i < size; i++) {
      setIndivisualPayment(names[i], now_pays[i], must_pays[i]);
    }
    return;
  }

  /* others */
  bool isRegistered(String name) {
    return payment_status.containsKey(name);
  }

  void printPaymentStatus() {
    payment_status.forEach((key, value) {
      value.printPayment();
    });
  }

  void movePay(String from, String to, int payment) {
    if (isRegistered(from) && isRegistered(to)) {
      payment_status[from]!.addPayment(payment);
      payment_status[to]!.subPayment(payment);
    }
    return;
  }

  void clearPayment() {
    member_num = 0;
    payment_status.clear();
  }
}
