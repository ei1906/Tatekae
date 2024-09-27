class IndividualPayment {
  int _now_payment;
  int _must_payment;
  String _name;

  /* constructor */
  IndividualPayment(this._name, this._now_payment, this._must_payment);

  /* getter */
  int getNowPayment() {
    return _now_payment;
  }

  int getMustPayment() {
    return _must_payment;
  }

  String getName() {
    return _name;
  }

  /* setter */
  void setNowPayment(int payment) {
    _now_payment = payment;
    return;
  }

  void setMustPayment(int payment) {
    _must_payment = payment;
    return;
  }

  void setName(String name) {
    _name = name;
    return;
  }

  /* others */
  bool isNullData() {
    if (_name == '') {
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
    print("name: ${_name}, now: ￥${_now_payment}, must: ￥${_must_payment}");
    return;
  }
}
