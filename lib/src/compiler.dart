import 'dart:math' as math;

import 'constants.dart';
import 'parser.dart';
import 'util.dart';

String getNumber(Region region) {
  int sum = 0;
  bool decimalReached = false;
  List<SubRegion> decimalUnits = [];
  region.subRegions.forEach((subRegion) {
    final type = subRegion.type;
    if (type == TOKEN_TYPE.DECIMAL) {
      decimalReached = true;
      return;
    }
    if (decimalReached) {
      decimalUnits.add(subRegion);
      return;
    }
    sum += subRegionSum(subRegion);
  });
  if (decimalUnits.isEmpty) {
    return sum.toString();
  } else {
    final allDecimalTokensAreUnits = decimalUnits.every((decimalSubRegion) {
      return decimalSubRegion.tokens.every((token) {
        return UNIT_KEYS.contains(token.lowerCaseValue);
      });
    });
    if (allDecimalTokensAreUnits) {
      double decimalSum = sum.toDouble();
      int currentDecimalPlace = 1;
      decimalUnits.forEach((decimalSubRegion) {
        decimalSubRegion.tokens.forEach((token) {
          decimalSum += NUMBER[token.lowerCaseValue]! / math.pow(10, currentDecimalPlace);
          currentDecimalPlace += 1;
        });
      });
      return decimalSum.toString();
    } else {
      int decimalIntSum = 0;
      decimalUnits.forEach((decimalSubRegion) {
        decimalIntSum += subRegionSum(decimalSubRegion);
      });
      double decimalSum = (decimalIntSum / math.pow(10, decimalIntSum.toString().length));
      return (sum.toDouble() + decimalSum).toString();
    }
  }
}

int subRegionSum(SubRegion subRegion) {
  int subRegionSum = 0;
  final tokens = subRegion.tokens, type = subRegion.type;
  switch (type) {
    case TOKEN_TYPE.MAGNITUDE:
    case TOKEN_TYPE.HUNDRED:
      {
        subRegionSum = 1;
        final tokensCount = tokens.length;
        final acc = <int>[];
        tokens.asMap().forEach((i, token) {
          if (token.type == TOKEN_TYPE.HUNDRED) {
            final List<Chunk> tokensToAdd = (tokensCount - 1) > 0 ? tokens.sublist(i + 1) : [];
            final List<Chunk> filtered = [];
            for (int j = 0; j < tokensToAdd.length; j++) {
              if (j == 0 || tokensToAdd[j - 1].type!.value > tokensToAdd[j].type!.value) {
                filtered.add(tokensToAdd[j]);
              }
            }
            int tokensToAddSum = 0;
            filtered.forEach((tokenToAdd) => tokensToAddSum += NUMBER[tokenToAdd.lowerCaseValue]!);
            return acc.add(tokensToAddSum + (NUMBER[token.lowerCaseValue]! * 100));
          }
          if (i > 0 && tokens[i - 1].type == TOKEN_TYPE.HUNDRED) return;
          if (i > 1 &&
              tokens[i - 1].type == TOKEN_TYPE.TEN &&
              tokens[i - 2].type == TOKEN_TYPE.HUNDRED) return;
          acc.add(NUMBER[token.lowerCaseValue]!);
        });
        acc.forEach((tokenValue) {
          subRegionSum *= tokenValue;
        });
        break;
      }
    case TOKEN_TYPE.UNIT:
    case TOKEN_TYPE.TEN:
      {
        tokens.forEach((token) {
          subRegionSum += NUMBER[token.lowerCaseValue]!;
        });
        break;
      }
    default:
    // no operation
  }
  return subRegionSum;
}

String replaceRegionsInText(List<Region> regions, String text) {
  String replaced = text;
  int offset = 0;
  regions.forEach((region) {
    final length = region.end - region.start + 1;
    final replaceWith = '${getNumber(region)}';
    replaced = splice(replaced, region.start + offset, length, replaceWith);
    offset -= length - replaceWith.length;
  });
  return replaced;
}

String compile(List<Region> regions, String text) {
  if (regions.isEmpty) return text;
  if (regions[0].end - regions[0].start == text.length - 1) return getNumber(regions[0]).toString();
  return replaceRegionsInText(regions, text);
}
