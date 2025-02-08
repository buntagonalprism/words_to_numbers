import 'constants.dart';
import 'options.dart';

enum TokenFit {
  SKIP,
  ADD,
  START_NEW_REGION,
  NOPE,
}

bool canAddTokenToEndOfSubRegion(SubRegion subRegion, Chunk currentToken, bool impliedHundreds) {
  final tokens = subRegion.tokens;
  final prevToken = tokens[0];
  if (prevToken.type == TOKEN_TYPE.MAGNITUDE && currentToken.type == TOKEN_TYPE.UNIT) return true;
  if (prevToken.type == TOKEN_TYPE.MAGNITUDE && currentToken.type == TOKEN_TYPE.TEN) return true;
  if (impliedHundreds &&
      subRegion.type == TOKEN_TYPE.MAGNITUDE &&
      prevToken.type == TOKEN_TYPE.TEN &&
      currentToken.type == TOKEN_TYPE.UNIT) return true;
  if (impliedHundreds &&
      subRegion.type == TOKEN_TYPE.MAGNITUDE &&
      prevToken.type == TOKEN_TYPE.UNIT &&
      currentToken.type == TOKEN_TYPE.TEN) return true;
  if (prevToken.type == TOKEN_TYPE.TEN && currentToken.type == TOKEN_TYPE.UNIT) return true;
  if (!impliedHundreds && prevToken.type == TOKEN_TYPE.TEN && currentToken.type == TOKEN_TYPE.UNIT)
    return true;
  if (prevToken.type == TOKEN_TYPE.MAGNITUDE && currentToken.type == TOKEN_TYPE.MAGNITUDE)
    return true;
  if (!impliedHundreds && prevToken.type == TOKEN_TYPE.TEN && currentToken.type == TOKEN_TYPE.TEN)
    return false;
  if (impliedHundreds && prevToken.type == TOKEN_TYPE.TEN && currentToken.type == TOKEN_TYPE.TEN)
    return true;
  return false;
}

SubRegionType getSubRegionType(SubRegion? subRegion, Chunk currentToken) {
  if (subRegion == null) {
    return SubRegionType(type: currentToken.type);
  }
  final prevToken = subRegion.tokens[0];
  final isHundred = ((prevToken.type == TOKEN_TYPE.TEN && currentToken.type == TOKEN_TYPE.UNIT) ||
      (prevToken.type == TOKEN_TYPE.TEN && currentToken.type == TOKEN_TYPE.TEN) ||
      (prevToken.type == TOKEN_TYPE.UNIT &&
          currentToken.type == TOKEN_TYPE.TEN &&
          NUMBER[prevToken.lowerCaseValue]! > 9) ||
      (prevToken.type == TOKEN_TYPE.UNIT && currentToken.type == TOKEN_TYPE.UNIT) ||
      (prevToken.type == TOKEN_TYPE.TEN &&
          currentToken.type == TOKEN_TYPE.UNIT &&
          subRegion.type == TOKEN_TYPE.MAGNITUDE));
  if (currentToken.type == TOKEN_TYPE.DECIMAL)
    return SubRegionType(type: TOKEN_TYPE.DECIMAL, isHundred: isHundred);
  if (subRegion.type == TOKEN_TYPE.MAGNITUDE)
    return SubRegionType(type: TOKEN_TYPE.MAGNITUDE, isHundred: isHundred);
  if (isHundred) return SubRegionType(type: TOKEN_TYPE.HUNDRED, isHundred: isHundred);
  return SubRegionType(type: currentToken.type, isHundred: isHundred);
}

class SubRegionType {
  final TOKEN_TYPE? type;
  final bool isHundred;

  SubRegionType({this.type, this.isHundred = false});
}

SubRegionFit checkIfTokenFitsSubRegion(SubRegion? subRegion, Chunk token, Options options) {
  final subType = getSubRegionType(subRegion, token);
  final type = subType.type;
  final isHundred = subType.isHundred;
  if (subRegion == null)
    return SubRegionFit(action: TokenFit.START_NEW_REGION, type: type, isHundred: isHundred);
  if (canAddTokenToEndOfSubRegion(subRegion, token, options.impliedHundreds)) {
    return SubRegionFit(action: TokenFit.ADD, type: type, isHundred: isHundred);
  }
  return SubRegionFit(action: TokenFit.START_NEW_REGION, type: type, isHundred: isHundred);
}

class SubRegionFit {
  final TokenFit action;
  final TOKEN_TYPE? type;
  final bool isHundred;

  SubRegionFit({required this.action, this.type, this.isHundred = false});
}

List<SubRegion> getSubRegions(Region region, Options options) {
  final subRegions = <SubRegion>[];
  SubRegion? currentSubRegion;
  final tokensCount = region.tokens.length;
  int i = tokensCount - 1;
  while (i >= 0) {
    final token = region.tokens[i];
    final subRegionFit = checkIfTokenFitsSubRegion(currentSubRegion, token, options);
    final action = subRegionFit.action,
        type = subRegionFit.type,
        isHundred = subRegionFit.isHundred;
    token.type = isHundred ? TOKEN_TYPE.HUNDRED : token.type;
    switch (action) {
      case TokenFit.ADD:
        {
          currentSubRegion?.type = type;
          currentSubRegion?.tokens.insert(0, token);
          break;
        }
      case TokenFit.START_NEW_REGION:
        {
          currentSubRegion = SubRegion(
            tokens: [token],
            type: type,
          );
          subRegions.insert(0, currentSubRegion);
          break;
        }
      default:
      // no action
    }
    i--;
  }
  return subRegions;
}

bool canAddTokenToEndOfRegion(Region region, Chunk currentToken, bool impliedHundreds) {
  final tokens = region.tokens;
  final prevToken = tokens[tokens.length - 1];
  if (!impliedHundreds &&
      prevToken.type == TOKEN_TYPE.UNIT &&
      currentToken.type == TOKEN_TYPE.UNIT &&
      !region.hasDecimal) return false;
  if (!impliedHundreds && prevToken.type == TOKEN_TYPE.UNIT && currentToken.type == TOKEN_TYPE.TEN)
    return false;
  if (!impliedHundreds && prevToken.type == TOKEN_TYPE.TEN && currentToken.type == TOKEN_TYPE.TEN)
    return false;
  return true;
}

TokenFit checkIfTokenFitsRegion(Region? region, Chunk token, Options options) {
  final isDecimal = DECIMALS.contains(token.lowerCaseValue);
  if ((region == null || region.tokens.isEmpty) && isDecimal) {
    return TokenFit.START_NEW_REGION;
  }
  final isPunctuation = PUNCTUATION.contains(token.lowerCaseValue);
  if (isPunctuation) return TokenFit.SKIP;
  final isJoiner = JOINERS.contains(token.lowerCaseValue);
  if (isJoiner) return TokenFit.SKIP;
  if (isDecimal && !region!.hasDecimal) {
    return TokenFit.ADD;
  }
  final isNumberWord = NUMBER_WORDS.contains(token.lowerCaseValue);
  if (isNumberWord) {
    if (region == null) return TokenFit.START_NEW_REGION;
    if (canAddTokenToEndOfRegion(region, token, options.impliedHundreds)) {
      return TokenFit.ADD;
    }
    return TokenFit.START_NEW_REGION;
  }
  return TokenFit.NOPE;
}

bool checkBlacklist(List<Chunk> tokens) {
  return tokens.length == 1 && BLACKLIST_SINGULAR_WORDS.contains(tokens[0].lowerCaseValue);
}

List<Region> matchRegions(List<Chunk> tokens, options) {
  final regions = <Region>[];

  if (checkBlacklist(tokens)) return regions;

  int i = 0;
  Region? currentRegion;
  final tokensCount = tokens.length;
  while (i < tokensCount) {
    final token = tokens[i];
    final tokenFits = checkIfTokenFitsRegion(currentRegion, token, options);
    switch (tokenFits) {
      case TokenFit.SKIP:
        break;
      case TokenFit.ADD:
        if (currentRegion != null) {
          currentRegion.end = token.end;
          currentRegion.tokens.add(token);
          if (token.type == TOKEN_TYPE.DECIMAL) {
            currentRegion.hasDecimal = true;
          }
        }
        break;
      case TokenFit.START_NEW_REGION:
        currentRegion = Region(
          start: token.start,
          end: token.end,
          tokens: [token],
        );
        regions.add(currentRegion);
        if (token.type == TOKEN_TYPE.DECIMAL) {
          currentRegion.hasDecimal = true;
        }
        break;
      case TokenFit.NOPE:
        currentRegion = null;
        break;
    }
    i++;
  }

  regions.forEach((region) {
    region.subRegions = getSubRegions(region, options);
  });

  return regions;
}

TOKEN_TYPE? getTokenType(String chunk) {
  if (UNIT_KEYS.contains(chunk.toLowerCase())) return TOKEN_TYPE.UNIT;
  if (TEN_KEYS.contains(chunk.toLowerCase())) return TOKEN_TYPE.TEN;
  if (MAGNITUDE_KEYS.contains(chunk.toLowerCase())) return TOKEN_TYPE.MAGNITUDE;
  if (DECIMALS.contains(chunk.toLowerCase())) return TOKEN_TYPE.DECIMAL;
  return null;
}

const puncExcludingDoubleQuote = r"!\#$%&'()*+,\-./:;<=>?@\[\\\]^_‘{|}~";

List<Region> parse(String text, Options options) {
  final chunks = splitKeepDelimeters(
      text, new RegExp('(\\w+|\\s|["$puncExcludingDoubleQuote])', caseSensitive: false));
  final tokens = <Chunk>[];
  for (String chunkText in chunks) {
    final start = tokens.isNotEmpty ? tokens[tokens.length - 1].end + 1 : 0;
    final end = start + chunkText.length;
    if (end != start) {
      tokens.add(Chunk(
        start: start,
        end: end - 1,
        value: chunkText,
        lowerCaseValue: chunkText.toLowerCase(),
        type: getTokenType(chunkText),
      ));
    }
  }
  final regions = matchRegions(tokens, options);
  return regions;
}

List<String> splitKeepDelimeters(String text, RegExp regex) {
  final matches = regex.allMatches(text).toList();
  final result = <String>[];
  if (matches.isEmpty) {
    return [text];
  }
  if (matches[0].start > 0) {
    result.add(text.substring(0, matches[0].start));
  }
  int addedUpToIndex = matches[0].start;
  for (var match in matches) {
    if (addedUpToIndex < match.start) {
      result.add(text.substring(addedUpToIndex, match.start));
    }
    result.add(text.substring(match.start, match.end));
    addedUpToIndex = match.end;
  }
  if (matches.last.end != text.length) {
    result.add(text.substring(matches.last.end));
  }
  return result;
}

class Chunk {
  final int start;
  final int end;
  final String value;
  final String lowerCaseValue;
  TOKEN_TYPE? type;

  Chunk({
    required this.start,
    required this.end,
    required this.value,
    required this.lowerCaseValue,
    this.type,
  });
}

class Region {
  int start;
  int end;
  List<Chunk> tokens;

  Region({
    required this.start,
    required this.end,
    required this.tokens,
  });

  List<SubRegion> subRegions = [];
  bool hasDecimal = false;
}

class SubRegion {
  TOKEN_TYPE? type;
  final List<Chunk> tokens;

  SubRegion({required this.type, required this.tokens});
}
