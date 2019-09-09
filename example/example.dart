import 'package:tailcalls/utils.dart';
import 'package:tailcalls/tailcalls.dart';

// Example 1

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

// Example 2

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

int startRecursion(int n) {
  TailRec<int> recursiveFunction(int z) {
    if (z < n) {
      return tailcall(() => recursiveFunction(z + 1));
    } else {
      return done(z);
    }
  }

  return recursiveFunction(0) .result();
}

int startRecursion2(int n) {
  int recursiveFunction(int z) {
    if (z < n) {
      return recursiveFunction(z + 1);
    } else {
      return z;
    }
  }

  return recursiveFunction(0);
}

class Defs {
  static TailRec<bool> odd(int n) =>
      n == 0 ? done(false) : tailcall(() => even(n - 1));
  static TailRec<bool> even(int n) =>
      n == 0 ? done(true) : tailcall(() => odd(n - 1));

  static bool badodd(int n) => n == 0 ? false : badeven(n - 1);
  static bool badeven(int n) => n == 0 ? true : badodd(n - 1);
}



void main() {
  //Example 1
  var res = fib(2).result();
  print("Result: $res");

  // Example 2
  List<int> r = rangeList(1, 400);
  print(r.last);
  bool res2 = isEven(r).result();
  print(res2);

  // Example 3
  List<int> r4 = rangeList(1, 400);
  print(r4.last);
  bool res23 = isEven(r).result();
  print(res23);
  print("begin 1");
  var res3 = startRecursion(1000);
  print("end: " + res3.toString());
  print("begin 2");
  var res4 = startRecursion2(1000);
  print("end: " + res4.toString());

  // Example 4
  print((Defs.even(1000).result()));
}
