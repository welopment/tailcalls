//declare function BigInt(n: number): number
// Aus Typescript, 

// Original 

abstract class Trampoline<A> {
  Trampoline<B> map<B>(B Function(A) ab);

  Trampoline<B> flatMap<B>(Trampoline<B> Function(A) ab);
}

class Done<A> extends Trampoline<A> {
  Done(this.a);
  A a;

  @override
  Trampoline<B> map<B>(B Function(A) ab) {
    return Done(ab(this.a));
  }

  @override
  Trampoline<B> flatMap<B>(Trampoline<B> Function(A) ab) {
    return ab(this.a);
  }
}

class More<A> extends Trampoline<A> {
  More(this.fn);

  Trampoline<A> Function() fn;

  @override
  Trampoline<B> map<B>(B Function(A) ab) {
    return More(() => this.fn().map(ab));
  }

  @override
  Trampoline<B> flatMap<B>(Trampoline<B> Function(A) ab) {
    return More(() => this.fn().flatMap(ab));
  }
}

Done<A> done<A>(A a) {
  return Done(a);
}

More<A> more<A>(Trampoline<A> Function() a) {
  return More(a);
}

Object res( Trampoline r) {
  Trampoline result = r;
  while (true) {
    if (result is More) {
      result = (result as More).fn();
    } else if (result is Done) {
      return result.a;
    }
  }
}

Trampoline<int> fib(int desiredCount) {
  Trampoline<int> itar(int a, int b, int count) {
    if (count == desiredCount) {
      return done(a + b);
    } else {
      return more(() => itar(b, a + b, count + 1));
    }
  }

  return itar(0, 1, 0); // recursive call
}

void main() {
  print("Fibonacci ${fib(10)};");
}

/*
Das Original
declare function BigInt(n: number): number

abstract class Trampoline<A> {
  abstract map<B>(ab: (a: A) => B): Trampoline<B>
  abstract flatMap<B>(ab: (a: A) => Trampoline<B>): Trampoline<B>

  zip<B>(tb: Trampoline<B>): Trampoline<[A, B]> {
    const ta = this
    return ta.flatMap(a => tb.map(b => [a, b] as [A, B]))
  }
}

class Done<A> extends Trampoline<A> {
  constructor(readonly a: A) {
    super()
  }
  map<B>(ab: (a: A) => B): Trampoline<B> {
    return new Done(ab(this.a))
  }
  flatMap<B>(ab: (a: A) => Trampoline<B>): Trampoline<B> {
    return ab(this.a)
  }
}

class More<A> extends Trampoline<A> {
  constructor(readonly fn: () => Trampoline<A>) {
    super()
  }

  map<B>(ab: (a: A) => B): Trampoline<B> {
    return new More(() => this.fn().map(ab))
  }
  flatMap<B>(ab: (a: A) => Trampoline<B>): Trampoline<B> {
    return new More(() => this.fn().flatMap(ab))
  }
}

function done<A>(a: A): Done<A> {
  return new Done(a)
}

function more<A>(a: () => Trampoline<A>): More<A> {
  return new More(a)
}



const fib_TRAMPOLINED = (desiredCount: number): Trampoline<number> => {
    const itar = (a: number, b: number, count: number): Trampoline<number> => {
        if (count === desiredCount) {
            return done(a + b)
        } else {
            return more(() => itar(b, a + b, count + 1))
        }
    }
    return itar(BigInt(0), BigInt(1), 0) // recursive call
}


 */
