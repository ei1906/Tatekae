class IndividualPayment {
  int now_payment;
  int must_payment;
  String name;

  /* constructor */
  IndividualPayment(this.name, this.now_payment, this.must_payment);

  /* getter */
  int getNowPayment() {
    return now_payment;
  }

  int getMustPayment() {
    return must_payment;
  }

  String getName() {
    return name;
  }

  /* setter */
  void setNowPayment(int payment) {
    now_payment = payment;
    return;
  }

  void setMustPayment(int payment) {
    must_payment = payment;
    return;
  }

  void setName(String name) {
    name = name;
    return;
  }

  /* others */
  bool isNullData() {
    if (name == '') {
      return true;
    }
    return false;
  }

  int addPayment(int add) {
    int now = getNowPayment();
    setNowPayment(now + add);
    return getNowPayment();
  }

  int subPayment(int sub) {
    int now = getNowPayment();
    setNowPayment(now - sub);
    return getNowPayment();
  }

  void printPayment() {
    print("name: ${name}, now: ￥${now_payment}, must: ￥${must_payment}");
    return;
  }
}
