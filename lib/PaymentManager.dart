import 'package:tatekae/IndivisualPayment.dart';

class PaymentManager {
  /* メンバ変数 */
  int member_num;
  Map<String, IndividualPayment> payment_status = {};

  /* constructor */
  PaymentManager(this.member_num);

  /* getter */
  int get_member_num() {
    return member_num;
  }

  Map<String, IndividualPayment> get_all_payment_status() {
    return payment_status;
  }

  IndividualPayment get_payment_status(String name) {
    if (!isRegistered(name)) {
      // nameが登録されていない
      return new IndividualPayment('', 0, 0);
    } else {
      return payment_status[name]!;
    }
  }

  /* setter */
  void set_indivisual_payment(String name, int now_pay, int must_pay) {
    payment_status[name] = new IndividualPayment(name, now_pay, must_pay);
    return;
  }

  void set_payment(
      List<String> names, List<int> now_pays, List<int> must_pays) {
    int size = names.length;
    for (int i = 0; i < size; i++) {
      set_indivisual_payment(names[i], now_pays[i], must_pays[i]);
    }
    return;
  }

  /* others */
  bool isRegistered(String name) {
    return payment_status.containsKey(name);
  }
}

void main() {
  PaymentManager test = new PaymentManager(5);
  test.set_indivisual_payment("taki", 0, 90);
  print(test.get_member_num());
}
