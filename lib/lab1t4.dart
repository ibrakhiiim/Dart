import 'package:flutter/services.dart';

void main() {
  List<int> numbers = [14, 88, 3, 42, 99, 12, 67];
  int min = numbers[0];
  int max = numbers[0];
  for (int i = 0; i < numbers.length; i++) {
    if (numbers[i] < min) {
      min = numbers[i];
    }
    if (numbers[i] > max) {
      max = numbers[i];
    }
  }
  print ('min; $min');
  print ('max: $max');
}
