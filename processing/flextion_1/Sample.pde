class Sample {
  int value;
  Date timestamp;

  Sample(int _value) {
    value = _value;
    timestamp = new Date();
  }

  int val() {
    return value;
  }
}

