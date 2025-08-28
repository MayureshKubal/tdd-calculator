class StringCalculator {
  static double add(String numbers) {
    if (numbers.trim().isEmpty) return 0;
    List<String> parts;
    if (numbers.startsWith('//')) {
      var delimiterEnd = numbers.indexOf('\n');
      var delimiterSection = numbers.substring(2, delimiterEnd);
      var rest = numbers.substring(delimiterEnd + 1);
      RegExp multiDelim = RegExp(r'\[(.*?)\]');
      var matches = multiDelim.allMatches(delimiterSection);
      List<String> delimiters = [];
      for (final m in matches) {
        delimiters.add(RegExp.escape(m.group(1)!.trim()));
      }
      String pattern;
      if (delimiters.isNotEmpty) {
        pattern = delimiters.join('|');
      } else {
        // Single character delimiter
        pattern = RegExp.escape(delimiterSection.trim());
      }
      parts = rest.split(RegExp(pattern));
    } else if (!numbers.contains(',') && !numbers.contains('\n')) {
      parts = [numbers];
    } else {
      parts = numbers.split(RegExp('[,\n]'));
    }

    var nums = parts
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .map(double.parse)
        .toList();
    var negatives = nums.where((n) => n < 0).toList();
    if (negatives.isNotEmpty) {
      String negString = negatives
          .map((n) => n % 1 == 0 ? n.toInt().toString() : n.toString())
          .join(',');
      throw Exception('negative numbers not allowed $negString');
    }
    var filtered = nums.where((n) => n <= 1000);
    return filtered.isEmpty ? 0 : filtered.reduce((a, b) => a + b);
  }
}
