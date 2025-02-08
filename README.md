# Words To Numbers

Dart implementation of the [words_to_numbers](https://github.com/finnfiddle/words-to-numbers) package by [@finnfiddle](https://github.com/finnfiddle)

Converts words to numbers. Optionally fuzzy match the words to numbers.

The returned value is always return a string. If you are expecting the entire string to be a number, then you can use the `tryParse` methods to get the numeric value:

```dart
import 'package:words_to_numbers/words_to_numbers.dart';

void main() {
    final String numberAsText = wordsToNumbers('three point five two');
    final int intValue = int.tryParse(numberAsText); // Returns null
    final double doubleValue = double.tryParse(numberAsText); // Returns 3.52
    final num numValue = num.tryParse(numberAsText); // Returns 3.45
}
```

## Basic Examples

```dart
import 'package:words_to_numbers/words_to_numbers.dart';
void main() {
    wordsToNumbers('one hundred'); //100
    wordsToNumbers('one hundred and five'); //105
    wordsToNumbers('one hundred and twenty five'); //125
    wordsToNumbers('four thousand and thirty'); //4030
    wordsToNumbers('six million five thousand and two'); //6005002
    wordsToNumbers('a thousand one hundred and eleven'); //1111
    wordsToNumbers('twenty thousand five hundred and sixty nine'); //20569
    wordsToNumbers('five quintillion'); //5000000000000000000
    wordsToNumbers('one-hundred'); //100
    wordsToNumbers('one-hundred and five'); //105
    wordsToNumbers('one-hundred and twenty-five'); //125
    wordsToNumbers('four-thousand and thirty'); //4030
    wordsToNumbers('six-million five-thousand and two'); //6005002
    wordsToNumbers('a thousand, one-hundred and eleven'); //1111
    wordsToNumbers('twenty-thousand, five-hundred and sixty-nine'); //20569
}
```

## Multiple numbers in a string

Returns a string with all instances replaced.

```dart
wordsToNumbers('there were twenty-thousand, five-hundred and sixty-nine X in the five quintillion Y')) // 'there were 20569 X in the 5000000000000000000 Y'
```


## Decimal Points

```dart
import 'package:words_to_numbers/words_to_numbers.dart';
void main() {
    wordsToNumbers('ten point five'); //10.5
    wordsToNumbers('three point one four one five nine two six'); //3.1415926
}
```

## Ordinal Numbers

```dart
import 'package:words_to_numbers/words_to_numbers.dart';
void main() {
    wordsToNumbers('first'); //1
    wordsToNumbers('second'); //2
    wordsToNumbers('third'); //3
    wordsToNumbers('fourteenth'); //14
    wordsToNumbers('twenty fifth'); //25
    wordsToNumbers('thirty fourth'); //34
    wordsToNumbers('forty seventh'); //47
    wordsToNumbers('fifty third'); //53
    wordsToNumbers('sixtieth'); //60
    wordsToNumbers('seventy second'); //72
    wordsToNumbers('eighty ninth'); //89
    wordsToNumbers('ninety sixth'); //96
    wordsToNumbers('one hundred and eighth'); //108
    wordsToNumbers('one hundred and tenth'); //110
    wordsToNumbers('one hundred and ninety ninth'); //199
}
```

## Commonjs

```dart
import 'package:words_to_numbers/words_to_numbers.dart';
wordsToNumbers('one hundred'); //100;
```

## Implied Hundreds

```dart
import 'package:words_to_numbers/words_to_numbers.dart';
void main() {
    wordsToNumbers('nineteen eighty four', {Options(impliedHundreds: true)); //1984
    wordsToNumbers('one thirty', {Options(impliedHundreds: true)); //130
    wordsToNumbers('six sixty two', {Options(impliedHundreds: true)); //662
    wordsToNumbers('ten twelve', {Options(impliedHundreds: true)); //1012
    wordsToNumbers('nineteen ten', {Options(impliedHundreds: true)); //1910
    wordsToNumbers('twenty ten', {Options(impliedHundreds: true)); //2010
    wordsToNumbers('twenty seventeen', {Options(impliedHundreds: true)); //2017
    wordsToNumbers('twenty twenty', {Options(impliedHundreds: true)); //2020
    wordsToNumbers('twenty twenty one', {Options(impliedHundreds: true)); //2021
    wordsToNumbers('fifty sixty three', {Options(impliedHundreds: true)); //5063
    wordsToNumbers('fifty sixty', {Options(impliedHundreds: true)); //5060
    wordsToNumbers('fifty sixty three thousand', {Options(impliedHundreds: true)); //5063000
    wordsToNumbers('one hundred thousand', {Options(impliedHundreds: true)); //100000
}
```