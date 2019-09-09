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
TailRec<int> fib(int desiredCount) {
  TailRec<int> itar(int a, int b, int count) {
    if (count == desiredCount) {
      return done(a + b);
    } else {
      return tailcall(() => itar(b, a + b, count + 1));
    }
  }

  return itar(0, 1, 0); // recursive call
}

TailRec<int> fib3(int n) {
  if (n < 2) {
    return done(n);
  } else {
    return tailcall(() => fib3(n - 1)).flatMap((x) {
      return tailcall(() => fib3(n - 2)).map((y) {
        return (x + y);
      });
    });
  }
}

void main() {
  print("Fibonacci ${fib(10).result()};");
  print("Fibonacci ${fib3(10).result()};");
}

/*
Das Original
declare function BigInt(n: number): number

abstract class TailRec<A> {
  abstract map<B>(ab: (a: A) => B): TailRec<B>
  abstract flatMap<B>(ab: (a: A) => TailRec<B>): TailRec<B>

  zip<B>(tb: TailRec<B>): TailRec<[A, B]> {
    const ta = this
    return ta.flatMap(a => tb.map(b => [a, b] as [A, B]))
  }
}

class Done<A> extends TailRec<A> {
  constructor(readonly a: A) {
    super()
  }
  map<B>(ab: (a: A) => B): TailRec<B> {
    return new Done(ab(this.a))
  }
  flatMap<B>(ab: (a: A) => TailRec<B>): TailRec<B> {
    return ab(this.a)
  }
}

class More<A> extends TailRec<A> {
  constructor(readonly fn: () => TailRec<A>) {
    super()
  }

  map<B>(ab: (a: A) => B): TailRec<B> {
    return new More(() => this.fn().map(ab))
  }
  flatMap<B>(ab: (a: A) => TailRec<B>): TailRec<B> {
    return new More(() => this.fn().flatMap(ab))
  }
}

function done<A>(a: A): Done<A> {
  return new Done(a)
}

function more<A>(a: () => TailRec<A>): More<A> {
  return new More(a)
}



const fib_TailRecD = (desiredCount: number): TailRec<number> => {
    const itar = (a: number, b: number, count: number): TailRec<number> => {
        if (count === desiredCount) {
            return done(a + b)
        } else {
            return more(() => itar(b, a + b, count + 1))
        }
    }
    return itar(BigInt(0), BigInt(1), 0) // recursive call
}


 */
