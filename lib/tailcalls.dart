// declare function BigInt(n: number): number
// Aus Typescript,
// Abgewandelt, der API angepasst.

abstract class TailRec<A> {
  TailRec<B> map<B>(B Function(A) ab);

  TailRec<B> flatMap<B>(TailRec<B> Function(A) ab);

  A result() {
    TailRec<A> res = this;
    while (true) {
      if (res is More<A>) {
        res = (res as More<A>).fn();
      } else if (res is Done<A>) {
        return (res).a;
      }
    }
  }
}

class Done<A> extends TailRec<A> {
  Done(this.a);
  A a;

  @override
  TailRec<B> map<B>(B Function(A) ab) {
    return Done(ab(this.a));
  }

  @override
  TailRec<B> flatMap<B>(TailRec<B> Function(A) ab) {
    return ab(this.a);
  }
}

class More<A> extends TailRec<A> {
  More(this.fn);

  TailRec<A> Function() fn;

  @override
  TailRec<B> map<B>(B Function(A) ab) {
    return More(() => this.fn().map(ab));
  }

  @override
  TailRec<B> flatMap<B>(TailRec<B> Function(A) ab) {
    return More(() => this.fn().flatMap(ab));
  }
}

Done<A> done<A>(A a) {
  return Done(a);
}

More<A> tailcall<A>(TailRec<A> Function() a) {
  return More(a);
}

// kein Fibonacci
TailRec<int> rec(int desiredCount) {
  TailRec<int> itar(int a, int b, int count) {
    if (count == desiredCount) {
      return done(a + b);
    } else {
      return tailcall(() => itar(b, a + b, count + 1));
    }
  }

  return itar(0, 1, 0); // recursive call
}

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

void main() {
  print("Fibonacci ${rec(10).result()};");
  print("Fibonacci ${fib(10).result()};");
}
