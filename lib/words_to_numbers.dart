library words_to_numbers;

import 'src/compiler.dart';
import 'src/parser.dart';
import 'src/options.dart';

export 'src/options.dart';

String wordsToNumbers(String text, [Options options]) {
  final regions = parse(text, options ?? Options());
  if (regions.isEmpty) return text;
  final compiled = compile(regions, text);
  return compiled;
}
