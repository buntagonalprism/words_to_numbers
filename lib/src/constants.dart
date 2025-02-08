const Map<String, int> UNIT = {
  'zero': 0,
  'first': 1,
  'one': 1,
  'second': 2,
  'two': 2,
  'third': 3,
  'thirteenth': 13,
  'thirteen': 13,
  'three': 3,
  'fourth': 4,
  'fourteenth': 14,
  'fourteen': 14,
  'four': 4,
  'fifteenth': 15,
  'fifteen': 15,
  'fifth': 5,
  'five': 5,
  'sixth': 6,
  'sixteenth': 16,
  'sixteen': 16,
  'six': 6,
  'seventeenth': 17,
  'seventeen': 17,
  'seventh': 7,
  'seven': 7,
  'eighteenth': 18,
  'eighteen': 18,
  'eighth': 8,
  'eight': 8,
  'nineteenth': 19,
  'nineteen': 19,
  'ninth': 9,
  'nine': 9,
  'tenth': 10,
  'ten': 10,
  'eleventh': 11,
  'eleven': 11,
  'twelfth': 12,
  'twelve': 12,
  'a': 1,
};

const Map<String, int> TEN = {
  'twenty': 20,
  'twentieth': 20,
  'thirty': 30,
  'thirtieth': 30,
  'forty': 40,
  'fortieth': 40,
  'fifty': 50,
  'fiftieth': 50,
  'sixty': 60,
  'sixtieth': 60,
  'seventy': 70,
  'seventieth': 70,
  'eighty': 80,
  'eightieth': 80,
  'ninety': 90,
  'ninetieth': 90,
};

const Map<String, int> MAGNITUDE = {
  'hundred': 100,
  'hundredth': 100,
  'thousand': 1000,
  'million': 1000000,
  'billion': 1000000000,
  'trillion': 1000000000000,
  'quadrillion': 1000000000000000,
  'quintillion': 1000000000000000000,
};

const Map<String, int> NUMBER = {...UNIT, ...TEN, ...MAGNITUDE};

final List<String> UNIT_KEYS = UNIT.keys.toList();
final List<String> TEN_KEYS = TEN.keys.toList();
final List<String> MAGNITUDE_KEYS = MAGNITUDE.keys.toList();

final List<String> NUMBER_WORDS = [...UNIT_KEYS, ...TEN_KEYS, ...MAGNITUDE_KEYS];

const List<String> JOINERS = ['and'];
const List<String> DECIMALS = ['point', 'dot'];

const List<String> PUNCTUATION = [
  '.',
  ',',
  '\\',
  '#',
  '!',
  '\$',
  '%',
  '^',
  '&',
  '/',
  '*',
  ';',
  ':',
  '{',
  '}',
  '=',
  '-',
  '_',
  '`',
  '~',
  '(',
  ')',
  ' ',
];

enum TOKEN_TYPE {
  UNIT,
  TEN,
  MAGNITUDE,
  DECIMAL,
  HUNDRED,
}

extension TypeExtension on TOKEN_TYPE {
  int get value {
    return switch (this) {
      TOKEN_TYPE.UNIT => 0,
      TOKEN_TYPE.TEN => 1,
      TOKEN_TYPE.MAGNITUDE => 2,
      TOKEN_TYPE.DECIMAL => 3,
      TOKEN_TYPE.HUNDRED => 4
    };
  }

  void talk() {
    print('meow');
  }
}

final List<String> ALL_WORDS = [...NUMBER_WORDS, ...JOINERS, ...DECIMALS];

const List<String> BLACKLIST_SINGULAR_WORDS = ['a'];
