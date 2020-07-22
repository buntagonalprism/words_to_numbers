import 'package:words_to_numbers/words_to_numbers.dart';
import 'package:test/test.dart';

void main() {

  final wtn = wordsToNumbers;

  test('one hundred', () {
    expect(wtn('one hundred'), '100');
  });

  test('one hundred two', () {
    expect(wtn('one hundred two'), '102');
  });

  test('one hundred and five', () {
    expect(wtn('one hundred and five'), '105');
  });

  test('one hundred and twenty five', () {
    expect(wtn('one hundred and twenty five'), '125');
  });

  test('four thousand and thirty', () {
    expect(wtn('four thousand and thirty'), '4030');
  });

  test('six million five thousand and two', () {
    expect(wtn('six million five thousand and two'), '6005002');
  });

  test('a thousand one hundred and eleven', () {
    expect(wtn('a thousand one hundred and eleven'), '1111');
  });

  test('sixty nine', () {
    expect(wtn('sixty nine'), '69');
  });

  test('twenty thousand five hundred and sixty nine', () {
    expect(wtn('twenty thousand five hundred and sixty nine'), '20569');
  });

  test('five quintillion', () {
    expect(wtn('five quintillion'), '5000000000000000000');
  });

  test('one-hundred', () {
    expect(wtn('one-hundred'), '100');
  });

  test('one-hundred and five', () {
    expect(wtn('one-hundred and five'), '105');
  });

  test('one-hundred and twenty-five', () {
    expect(wtn('one-hundred and twenty-five'), '125');
  });

  test('four-thousand and thirty', () {
    expect(wtn('four-thousand and thirty'), '4030');
  });

  test('six-million five-thousand and two', () {
    expect(wtn('six-million five-thousand and two'), '6005002');
  });

  test('a thousand, one-hundred and eleven', () {
    expect(wtn('a thousand, one-hundred and eleven'), '1111');
  });

  test('twenty-thousand, five-hundred and sixty-nine', () {
    expect(wtn('twenty-thousand, five-hundred and sixty-nine'), '20569');
  });

  test('there were twenty-thousand, five-hundred and sixty-nine X in the five quintillion Y', () {
    expect(wtn('there were twenty-thousand, five-hundred and sixty-nine X in the five quintillion Y'), 'there were 20569 X in the 5000000000000000000 Y');
  });

  test('one two three', () {
    expect(wtn('one two three'), '1 2 3');
  });

  test('test one two three test', () {
    expect(wtn('test one two three test'), 'test 1 2 3 test');
  });

  test('tu thousant and faav', () {
    expect(wtn('too thousant and fiev', Options(fuzzy: true)), '2005');
  });

  // The following tests has been changed slightly for Dart, as the Jaro-Winkler
  // distance implementation used performs differently on strings with 3 or fewer letters
  test('onf huntred', () {
    expect(wtn('onf huntred', Options(fuzzy: true)), '100');
  });

  test('tree millyon sefen hunderd ant twinty sex', () {
    expect(wtn('tree millyon sefen hunderd and twinty sex', Options(fuzzy: true)), '3000726');
  });

  test('forty two point five', () {
    expect(wtn('forty two point five'), '42.5');
  });

  test('ten point five', () {
    expect(wtn('ten point five'), '10.5');
  });

  test('three point one four one five nine two six', () {
    expect(wtn('three point one four one five nine two six'), '3.1415926');
  });

  /* testing for ordinal numbers */

  test('first', () {
    expect(wtn('first'), '1');
  });

  test('second', () {
    expect(wtn('second'), '2');
  });

  test('third', () {
    expect(wtn('third'), '3');
  });

  test('fourteenth', () {
    expect(wtn('fourteenth'), '14');
  });

  test('twenty fifth', () {
    expect(wtn('twenty fifth'), '25');
  });

  test('thirty fourth', () {
    expect(wtn('thirty fourth'), '34');
  });

  test('forty seventh', () {
    expect(wtn('forty seventh'), '47');
  });

  test('fifty third', () {
    expect(wtn('fifty third'), '53');
  });

  test('sixtieth', () {
    expect(wtn('sixtieth'), '60');
  });

  test('seventy second', () {
    expect(wtn('seventy second'), '72');
  });

  test('eighty ninth', () {
    expect(wtn('eighty ninth'), '89');
  });

  test('ninety sixth', () {
    expect(wtn('ninety sixth'), '96');
  });

  test('one hundred and eighth', () {
    expect(wtn('one hundred and eighth'), '108');
  });

  test('one hundred and tenth', () {
    expect(wtn('one hundred and tenth'), '110');
  });

  test('one hundred and ninety ninth', () {
    expect(wtn('one hundred and ninety ninth'), '199');
  });

  test('digtest one', () {
    expect(wtn('digtest one'), 'digtest 1');
  });

  test('digtest one ', () {
    expect(wtn('digtest one '), 'digtest 1 ');
  });

  test('one thirty', () {
    expect(wtn('one thirty'), '1 30');
  });

  test('thousand', () {
    expect(wtn('thousand'), '1000');
  });

  test('million', () {
    expect(wtn('million'), '1000000');
  });

  test('billion', () {
    expect(wtn('billion'), '1000000000');
  });

  test('xxxxxxx one hundred', () {
    expect(wtn('xxxxxxx one hundred'), 'xxxxxxx 100');
  });

  test('and', () {
    expect(wtn('and'), 'and');
  });

  test('a', () {
    expect(wtn('a'), 'a');
  });

  test('junkvalue', () {
    expect(wtn('junkvalue'), 'junkvalue');
  });

  test('eleven dot one', () {
    expect(wtn('eleven dot one'), '11.1');
  });

  test('Fifty People, One Question: Brooklyn', () {
    expect(wtn('Fifty People, One Question: Brooklyn'), '50 People, 1 Question: Brooklyn');
  });

  test('Model Fifty-One Fifty-Six', () {
    expect(wtn('Model Fifty-One Fifty-Six'), 'Model 51 56');
  });

  test('Fifty Million Frenchmen', () {
    expect(wtn('Fifty Million Frenchmen'), '50000000 Frenchmen');
  });

  test('A Thousand and One Wives', () {
    expect(wtn('A Thousand and One Wives'), '1001 Wives');
  });

  test('Ten Thousand Pictures of You', () {
    expect(wtn('Ten Thousand Pictures of You'), '10000 Pictures of You');
  });

  test('nineteen eighty four', () {
    expect(wtn('nineteen eighty four', Options(impliedHundreds: true)), '1984');
  });

  test('one thirty', () {
    expect(wtn('one thirty', Options(impliedHundreds: true)), '130');
  });

  test('six sixty two', () {
    expect(wtn('six sixty two', Options(impliedHundreds: true)), '662');
  });

  test('ten twelve', () {
    expect(wtn('ten twelve', Options(impliedHundreds: true)), '1012');
  });

  test('nineteen ten', () {
    expect(wtn('nineteen ten', Options(impliedHundreds: true)), '1910');
  });

  test('twenty ten', () {
    expect(wtn('twenty ten', Options(impliedHundreds: true)), '2010');
  });

  test('twenty seventeen', () {
    expect(wtn('twenty seventeen', Options(impliedHundreds: true)), '2017');
  });

  test('twenty twenty', () {
    expect(wtn('twenty twenty', Options(impliedHundreds: true)), '2020');
  });

  test('twenty twenty one', () {
    expect(wtn('twenty twenty one', Options(impliedHundreds: true)), '2021');
  });

  test('fifty sixty three', () {
    expect(wtn('fifty sixty three', Options(impliedHundreds: true)), '5063');
  });

  test('fifty sixty', () {
    expect(wtn('fifty sixty', Options(impliedHundreds: true)), '5060');
  });

  test('three thousand', () {
    expect(wtn('three thousand', Options(impliedHundreds: true)), '3000');
  });

  test('fifty sixty three thousand', () {
    expect(wtn('fifty sixty three thousand', Options(impliedHundreds: true)), '5063000');
  });

  test('one hundred thousand', () {
    expect(wtn('one hundred thousand'), '100000');
  });

  test('I have zero apples and four oranges', () {
    expect(wtn('I have zero apples and four oranges'), 'I have 0 apples and 4 oranges');
  });

  test('Dot two Dot', () {
    expect(wtn('Dot two Dot'), '0.2 Dot');
  });

  test('seventeen dot two four dot twelve dot five', () {
    expect(wtn('seventeen dot two four dot twelve dot five'), '17.24 dot 12.5');
  });

  // Added tests for decimals with non-unit expression
  test('point hundred and three', () {
    expect(wtn('point hundred and three'), '0.103');
  });

  test('point seventy-nine', () {
    expect(wtn('point seventy-nine'), '0.79');
  });

// Known failing cases

  // test('one thirty thousand', () {
  //   expect(wtn('one thirty thousand', Options(impliedHundreds: true)), '130000');
  // });

  // test('nineteen eighty thousand', () {
  //   expect(wtn('nineteen eighty thousand', Options(impliedHundreds: true )), '19 80000');
  // });

  // test('one hundred two thousand', () {
  //   expect(wtn('one hundred two thousand'), '102000');
  // });

  // test('one hundred and two thousand', () {
  //   expect(wtn('one hundred and two thousand'), '102000');
  // });

}

