extension FormattedMessage on Exception {
  // Getter method to extract and format the exception message
  String get getMessage {
    if (toString().startsWith("Exception: ")) {
      return toString().substring(11);
    } else {
      return toString();
    }
  }
}
