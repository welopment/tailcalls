import 'tailcalls.dart';
import 'utils.dart';

///
/// Test from Dart
///
class Defs {
  static TailRec odd(n) => n == 0 ? done(false) : tailcall(() => even(n - 1));
  static TailRec even(n) => n == 0 ? done(true) : tailcall(() => odd(n - 1));

  static int badodd(n) => n == 0 ? false : badeven(n - 1);
  static int badeven(n) => n == 0 ? true : badodd(n - 1);
}

void main1() {
  print(Defs.even(1000000).compute());
}

///
/// Test from Scala # 1
///
TailRec<bool> isEven(List<int> xs) {
  if (xs.isEmpty) {
    return done(true);
  } else {
    return tailcall(() => isOdd(xs.sublist(1)));
  }
}

TailRec<bool> isOdd(List<int> xs) {
  if (xs.isEmpty) {
    return done(false);
  } else {
    return tailcall(() => isEven(xs.sublist(1)));
  }
}

void main2() {
  List<int> r = rangeList(1, 40002);
  print(r.last);
  bool res = isEven(r).result();
  print(res);
}

///
/// Test aus Scala # 2
///
TailRec<int> fib(int n) {
  if (n < 2) {
    return done(n);
  } else {
    return tailcall(() => fib(n - 1)).flatMap((x) {
      return tailcall(() => fib(n - 2)).map((y) {
        return (x + y);
      });
    });
  }
}

void main3() {
  var res = fib(20).result();
  print("Ergebnis von Fibonacci $res");
}
