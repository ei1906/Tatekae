class IndividualPayment {
  int now_payment;
  int must_payment;
  String name;

  /* constructor */
  IndividualPayment() {
    this.now_payment = 0;
    this.must_payment = 0;
    this.name = "";
  }

  IndividualPayment(String name, int now_pay, int must_pay) {
    this.name = name;
    this.now_payment = now_pay;
    this.must_payment = must_pay;
  }

  /* getter */
  int get_now_payment() {
    return this.now_payment;
  }

  int get_must_payment() {
    return this.must_payment;
  }

  String get_name() {
    return this.name;
  }

  /* setter */
  void set_now_payment(int payment) {
    this.now_payment = payment;
    return;
  }

  void set_must_payment(int payment) {
    this.must_payment = payment;
    return;
  }

  void set_name(String name) {
    this.name = name;
    return;
  }

  /* others */
  int add_payment(int add) {
    int now = get_now_payment();
    set_now_payment(now + add);
    return get_now_payment();
  }

  int sub_payment(int sub) {
    int now = get_now_payment();
    set_now_payment(now - sub);
    return get_now_payment();
  }
}
