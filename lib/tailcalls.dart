abstract class TailRec<A> {
  A value;

  A result() {
    TailRec<A> tr = this;
    while (!(tr is _Done<A>)) {
      if (tr is _Bounce<A>) {
        tr = (tr as _Bounce<A>).continuation();
      } else if (tr is Cont) {
        var a = (tr as Cont).a;
        TailRec<A> Function(A) f = (tr as Cont<A, A>).f;
        if (a is _Done) {
          tr = f(a.value);
        } else if (a is _Bounce) {
          tr = ((a as _Bounce<A>)
              .continuation()
              .flatMap<A>(f /*as TailRec<A> Function(A)*/) /* as TailRec<A>*/);
        } else if (a is Cont) {
          TailRec<A> b = a.a;
          TailRec<A> Function(A) g = a.f as TailRec<A> Function(A);
          tr = b.flatMap<A>(
              (x) => g(x).flatMap<A>(f /*as TailRec<A> Function(A)*/));
        }
      }
    }
    return tr.value;
  }

  A compute() {
    TailRec<A> res = this;

    while (!res._isDone /* && res is _Bounce*/) {
      _Bounce<A> r = res /*as _Bounce<A>*/;
      final _Bounce<A> bounce = r;
      res = bounce.continuation();
    }
    _Done<A> done = res;
    return done.value;
  }

  bool get _isDone;

  TailRec<B> map<B>(B Function(A) f) {
    return flatMap((a) => new _Bounce(() => new _Done<B>(f(a))));
  }

  TailRec<B> flatMap<B>(TailRec<B> Function(A) f);
}

class Cont<A, B> extends TailRec<B> {
  Cont(this.a, this.f);

  final TailRec<A> a;
  final TailRec<B> Function(A x) f;

  @override
  TailRec<C> flatMap<C>(TailRec<C> Function(B) f) =>
      Cont<A, C>(this.a, (A x) => this.f(x).flatMap(f));

  @override
  bool get _isDone => false;
}

class _Done<A> extends TailRec<A> {
  _Done(this.value);

  @override
  TailRec<B> flatMap<B>(TailRec<B> Function(A) f) =>
      _Bounce(() => f(this.value));

  @override
  final A value;

  @override
  final bool _isDone = true;
}

class _Bounce<A> extends TailRec<A> {
  _Bounce(this.continuation);

  TailRec<A> Function() continuation;

  @override
  TailRec<B> flatMap<B>(TailRec<B> Function(A) f) => Cont(this, f);

  @override
  final bool _isDone = false;
}

TailRec<A> done<A>(A x) => new _Done<A>(x);

TailRec<A> tailcall<A>(TailRec<A> continuation()) =>
    new _Bounce<A>(continuation);

// -------------------------------------------------

class Defs {
  ///
  static TailRec odd(n) => n == 0 ? done(false) : tailcall(() => even(n - 1));
  static TailRec even(n) => n == 0 ? done(true) : tailcall(() => odd(n - 1));

  ///
  static int badodd(n) => n == 0 ? false : badeven(n - 1);
  static int badeven(n) => n == 0 ? true : badodd(n - 1);

  ///
  static TailRec<int> fib(int n) {
    if (n < 2) {
      return done<int>(n);
    } else {
      return tailcall<int>(() => fib(n - 1)).flatMap<int>((x) {
        return tailcall<int>(() => fib(n - 2)).map<int>((y) {
          return (x + y);
        });
      });
    }
  }
}

void main() {
  bool res1;
  res1 = (Defs.even(101).compute());
  print("Ergebnis von Odd/Even ist $res1");
  num res2;
  res2 = Defs.fib(14).result();
  print("Ergebnis von Fibonacci ist $res2");
}



/*

'Cont<List<Tupl<String, Termtype<String>>>, List<Tupl<String, Termtype<String>>>>' 
'_Done<List<Tupl<String, Termtype<String>>>>'


 */