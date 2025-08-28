import 'package:test/test.dart';
import '../lib/string_calculator.dart';

void main() {
  test('returns 0 for empty string', () {
    expect(StringCalculator.add(''), equals(0));
  });

  test('returns the number itself for a single number', () {
    expect(StringCalculator.add('1'), equals(1));
    expect(StringCalculator.add('42'), equals(42));
  });

  test('returns the sum for two numbers separated by a comma', () {
    expect(StringCalculator.add('1,5'), equals(6));
    expect(StringCalculator.add('10,20'), equals(30));
  });

  test('returns the sum for any amount of numbers', () {
    expect(StringCalculator.add('1,2,3,4'), equals(10));
    expect(StringCalculator.add('10,20,30'), equals(60));
    expect(StringCalculator.add('1,2,3,4,5,6,7,8,9,10'), equals(55));
  });

  test('handles new lines as delimiters', () {
    expect(StringCalculator.add('1\n2,3'), equals(6));
    expect(StringCalculator.add('4\n5\n6'), equals(15));
    expect(StringCalculator.add('7,8\n9'), equals(24));
  });

  test('supports custom delimiters', () {
    expect(StringCalculator.add('//;\n1;2'), equals(3));
    expect(StringCalculator.add('//|\n4|5|6'), equals(15));
    expect(StringCalculator.add('//#\n7#8#9'), equals(24));
  });

  test('supports delimiters of any length', () {
    expect(StringCalculator.add('//[***]\n1***2***3'), equals(6));
    expect(StringCalculator.add('//[abc]\n4abc5abc6'), equals(15));
    expect(StringCalculator.add('//[delim]\n7delim8delim9'), equals(24));
  });

  test('supports multiple single-character delimiters', () {
    expect(StringCalculator.add('//[*][%]\n1*2%3'), equals(6));
    expect(StringCalculator.add('//[;][,]\n4;5,6'), equals(15));
    expect(StringCalculator.add('//[a][b][c]\n1a2b3c4'), equals(10));
  });

  test('supports multiple delimiters of any length', () {
    expect(StringCalculator.add('//[***][%%]\n1***2%%3'), equals(6));
    expect(StringCalculator.add('//[a][bb][ccc]\n1a2bb3ccc4'), equals(10));
    expect(StringCalculator.add('//[!][@@][#]\n5!6@@7#8'), equals(26));
  });

  test('trims whitespace around numbers and delimiters', () {
    expect(StringCalculator.add(' 1 , 2 , 3 '), equals(6));
    expect(StringCalculator.add('  4\n 5 , 6  '), equals(15));
    expect(StringCalculator.add('//[***]\n 1 *** 2 *** 3 '), equals(6));
    expect(StringCalculator.add('//[;][,]\n 4 ; 5 , 6 '), equals(15));
  });

  test('supports floating-point numbers', () {
    expect(StringCalculator.add('1.5,2.5'), closeTo(4.0, 0.0001));
    expect(StringCalculator.add('0.1,0.2,0.3'), closeTo(0.6, 0.0001));
    expect(
        StringCalculator.add('//[***]\n1.1***2.2***3.3'), closeTo(6.6, 0.0001));
  });

  test('ignores numbers greater than 1000', () {
    expect(StringCalculator.add('2,1001'), equals(2));
    expect(StringCalculator.add('1000,1001,1002,3'), equals(1003));
    expect(StringCalculator.add('//[***]\n1***1001***2***1002***3'), equals(6));
    expect(StringCalculator.add('//[;][,]\n1001;1002,5'), equals(5));
  });
  
  test('returns 0 if all numbers are ignored (all > 1000)', () {
    expect(StringCalculator.add('1001,1002'), equals(0));
    expect(StringCalculator.add('//[***]\n1001***1002***1003'), equals(0));
  });

  test('throws on negative numbers with a single negative', () {
    expect(
        () => StringCalculator.add('1,-2,3'),
        throwsA(predicate((e) =>
            e is Exception &&
            e.toString().contains('negative numbers not allowed -2'))));
    expect(
        () => StringCalculator.add('-1,2,3'),
        throwsA(predicate((e) =>
            e is Exception &&
            e.toString().contains('negative numbers not allowed -1'))));
  });

  test('throws on negative numbers with multiple negatives', () {
    expect(
        () => StringCalculator.add('1,-2,-3,4'),
        throwsA(predicate((e) =>
            e is Exception &&
            e.toString().contains('negative numbers not allowed -2,-3'))));
    expect(
        () => StringCalculator.add('-1,-2,-3'),
        throwsA(predicate((e) =>
            e is Exception &&
            e.toString().contains('negative numbers not allowed -1,-2,-3'))));
  });
  
  test('throws on negative decimal and whole integer numbers', () {
    expect(
        () => StringCalculator.add('1,-2.5,3'),
        throwsA(predicate((e) =>
            e is Exception &&
            e.toString().contains('negative numbers not allowed -2.5'))));
    expect(
        () => StringCalculator.add('-1.1,2,-3'),
        throwsA(predicate((e) =>
            e is Exception &&
            e.toString().contains('negative numbers not allowed -1.1,-3'))));
    expect(
        () => StringCalculator.add('-1.0,-2.0,-3.5'),
        throwsA(predicate((e) =>
            e is Exception &&
            e.toString().contains('negative numbers not allowed -1,-2,-3.5'))));
  });
}
