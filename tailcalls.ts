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


