/// zip
///
typedef S ZipFun2<T, S>(T a, T b);

///
List<S> zip<T, S>(List<T> l1, List<T> l2, ZipFun2<T, S> f) {
  if (l1 == null || l2 == null) {
    throw new Exception("List is null");
  }

  List<S> res = new List<S>();
  int len1 = l1.length;
  int len2 = l2.length;
  if (len1 != len2) {
    throw new Exception("Different length");
  }
  for (int i = 0; i < len1; i++) {
    res.add(f(l1[i], l2[i]));
  }
  return res;
}

/// range

Iterable<int> range(int low, int high) sync* {
  for (int i = low; i < high; ++i) {
    yield i;
  }
}

List<int> rangeList(int low, int high) => range(low, high).toList();
