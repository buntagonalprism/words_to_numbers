
import 'package:edit_distance/edit_distance.dart';
import 'package:meta/meta.dart';

import 'constants.dart';

String fuzzyMatch(String word) {
  final jaro = JaroWinkler();
  return ALL_WORDS
    .map((numberWord) => FuzzyMatchScore(
      word: numberWord,
      score: jaro.normalizedDistance(numberWord, word)
    ))
    .reduce((acc, stat) => (acc?.score ?? 1.01) > stat.score ? stat : acc)
    .word;
}

class FuzzyMatchScore {
  final String word;
  final double score;

  FuzzyMatchScore({@required this.word, @required this.score});
}