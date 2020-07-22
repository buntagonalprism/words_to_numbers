String splice(String str, int index, int count, String add) {
  int i = index;
  if (i < 0) {
    i = str.length + i;
    if (i < 0) {
      i = 0;
    }
  }
  return str.substring(0, i) + (add ?? '') + str.substring(i + count);
}