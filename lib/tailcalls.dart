///
/// Typedefs
///
///

typedef TailRec<B> UbergFu<A, B>(A x);

typedef B UnterFu<A, B>(A x);

///
/// Utility function
///
/// range
///

abstract class TailRec<A> {
  A value;

  //
  // In Scala:
  //
  // result
  //
  //
  // Returns the result of the tailcalling computation
  //
  //@annotation.tailrec final def result: A = this match {
  //  case Done(a) => a
  //  case Call(t) => t().result
  //  case Cont(a, f) => a match {
  //    case Done(v) => f(v).result
  //    case Call(t) => t().flatMap(f).result
  //    case Cont(b, g) => b.flatMap(x => g(x) flatMap f).result
  //  }
  //}

  ///
  /// TailRec.result
  ///
  /// (adapted from Scala)
  ///
  A result() {
    TailRec<A> tr = this;
    while (!(tr is _Done<A>)) {
      if (tr is _Bounce<A>) {
        tr = (tr as _Bounce<A>).continuation();
      } else if (tr is Cont) {
        var a = (tr as Cont).a;
        var f = (tr as Cont).f;
        if (a is _Done) {
          tr = f(a.value);
        } else if (a is _Bounce) {
          // this is Cont und hat a, a is _Bounce, tr is Cont und hat a, ...
          tr = a.continuation().flatMap(f); // hier Problem
        } else if (a is Cont) {
          var b = a.a;
          var g = a.f;
          tr = b.flatMap((x) => g(x).flatMap(f));
        } else {
          throw new Exception("#1");
        }
      } else {
        throw new Exception("#2");
      }
    }
    return tr.value;
  }

  ///
  /// TailRec.compute
  ///
  /// from Dart
  ///
  A compute() {
    TailRec<A> res = this;

    while (!res._isDone) {
      final _Bounce<A> bounce = res;
      res = bounce.continuation();
    }
    _Done<A> done = res;
    return done.value;
  }

  bool get _isDone;

  //
  // In Scala:
  //
  // map
  //
  // Continue the computation with `f`.
  //
  // final def map[B](f: A => B): TailRec[B] =     flatMap(a => Call(() => Done(f(a))))

  // typedef B UnterFu<A, B>(A);

  ///
  /// TailRec.map
  ///

  ///
  TailRec<B> map<B>(UnterFu<A, B> f) {
    /* B f(A x) */
    return flatMap<B>((a) => new _Bounce<B>(() => new _Done<B>(f(a))));
  }

  //
  // In Scala:
  //
  // flatMap
  //
  //final def flatMap[B](f: A => TailRec[B]): TailRec[B] =
  //  this match {
  //    case Done(a) => Call(() => f(a))
  //    case c@Call(_) => Cont(c, f)
  //    case c: Cont[a1, b1] => Cont(c.a, (x: a1) => c.f(x) flatMap f)
  //  }

  // typedef TailRec<B> UbergFu<A, B>(A);
  /// TailRec.flatMap
  TailRec<B> flatMap<B>(dynamic /*UbergFu<A, B>*/ f) {
    if (this is _Done) {
      A a = this.value;
      return new _Bounce<B>(() => f(a));
    } else if (this is _Bounce) {
      TailRec<A> c = this;
      return new Cont<A, B>(c, f);
    } else if (this is Cont) {
      Cont<A, B> c = (this as Cont<A, B>);
      return new Cont<A, B>(c.a,
          (A x) => c.f(x).flatMap((f as UbergFu<A, B>))); // geht: (x)=>done(x))
      //(this as Cont<A,B>).a, (A x) => (this as Cont<A,B>).f( x).flatMap(f));
    } else {
      throw new Exception("");
    }
  }
}

//
// In Scala:
//
// Cont
//
// protected case class Cont[A, B](a: TailRec[A], f: A => TailRec[B]) extends TailRec[B]

/// Cont

typedef TailRec<B> ContFu<A, B>(A x);

class Cont<A, B> extends TailRec<B> {
  Cont(this.a, this.f);

  TailRec<A> a;
  ContFu<A, B> f;
  @override
  bool get _isDone => false;
}

// in scala Done
//   case class Done[A](value: A) extends TailRec[A]

/// _Done
///
class _Done<A> extends TailRec<A> {
  _Done(this.value);
  @override
  final A value;
  @override
  final bool _isDone = true;
  
}

//
// In Scala: Call
//
// _Bounce
//
// protected case class Call[A](rest: () => TailRec[A]) extends TailRec[A]

/// _Bounce
///
///
typedef TailRec<A> BounceFun<A>();

class _Bounce<A> extends TailRec<A> {
  _Bounce(BounceFun<A> f) {
    this.continuation = f;
  }
  BounceFun<A> continuation; // oder einfach ... Function ... statt BounceFun
  @override
  final bool _isDone = false;
  //_Bounce(TailRec<A> continuation()) : this.continuation = continuation;

}

//
// In Scala:
//
// done
//
// def done[A](result: A): TailRec[A] = Done(result)

/// done
///
TailRec<A> done<A>(A x) => new _Done<A>(x);

//
// In Scala:
//
// tailcall
//
// def tailcall[A](rest: => TailRec[A]): TailRec[A] = Call(() => rest)

/// tailcall
///
/// "TailRec continuation()" bedeutet: "()=> new TailRec()""
///
TailRec<A> tailcall<A>(TailRec<A> continuation()) => new _Bounce(continuation);
