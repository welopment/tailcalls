import '../lib/tailcalls.dart';
import '../lib/utils.dart';

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

  return recursiveFunction(0).compute();
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
  static TailRec odd(n) => n == 0 ? done(false) : tailcall(() => even(n - 1));
  static TailRec even(n) => n == 0 ? done(true) : tailcall(() => odd(n - 1));

  static int badodd(n) => n == 0 ? false : badeven(n - 1);
  static int badeven(n) => n == 0 ? true : badodd(n - 1);
}

void main1() {}

void main() {
  // Example 1
  //var res = fib(20).result();
  //print("Result: $res");

  // Example 2
  //List<int> r = rangeList(1, 40002);
  //print(r.last);
  //bool res2 = isEven(r).result();
  //print(res2);

  // Example 3
  //List<int> r = rangeList(1, 40002);
  //print(r.last);
  //bool res2 = isEven(r).result();
  //print(res2);
  print("begin 1");
  var res = startRecursion(100000000);
  print("end: " + res.toString());
  print("begin 2");
  var res2 = startRecursion2(10000);
  print("end: " + res2.toString());

  // Example 4
  print(Defs.even(1000000).compute());
}
