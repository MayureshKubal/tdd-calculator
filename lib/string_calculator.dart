class StringCalculator {
  static double add(String numbers) {
    if (numbers.trim().isEmpty) return 0;
    List<String> parts = [];

    // Handles custom delimiters
    if (numbers.startsWith('//')) {
      var delimiterEnd = numbers.indexOf('\n');
      var delimiterSection = numbers.substring(2, delimiterEnd);
      var rest = numbers.substring(delimiterEnd + 1);
      RegExp multiDelim = RegExp(r'\[(.*?)\]');
      var matches = multiDelim.allMatches(delimiterSection);
      List<String> delimiters = matches.map((e) => RegExp.escape(e.group(1)!.trim())).toList();
      String pattern = "";
      if (delimiters.isNotEmpty) {
        // Multiple character delimiters
        pattern = delimiters.join('|');
      } else {
        // Single character delimiter
        pattern = RegExp.escape(delimiterSection.trim());
      }
      parts = rest.split(RegExp(pattern));
    } else if (!numbers.contains(',') && !numbers.contains('\n')) {
      // Single number
      parts = [numbers];
    } else {
      // Multiple numbers
      parts = numbers.split(RegExp('[,\n]'));
    }

    // Convert parts to numbers
    var nums = parts
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .map(double.parse)
        .toList();
        
    var filtered = nums.where((n) => n <= 1000);
    if (filtered.isEmpty) return 0;

    var negatives = filtered.where((n) => n < 0).toList();
    if (negatives.isNotEmpty) {
      String negString = negatives
          .map((n) => n % 1 == 0 ? n.toInt().toString() : n.toString())
          .join(',');
      throw Exception('negative numbers not allowed $negString');
    }
    return filtered.reduce((a, b) => a + b);
  }
}