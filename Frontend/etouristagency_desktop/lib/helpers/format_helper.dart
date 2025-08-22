class FormatHelper {
  static String formatNumber(double val) {
    if (val % 1 == 0) {
      return val.toInt().toString();
    } else {
      return val.toStringAsFixed(2);
    }
  }
}
