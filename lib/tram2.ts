/*abstract class Trampoline<A> {
    abstract map<B>(ab: (a: A) => B): Trampoline<B>
    abstract flatMap<B>(ab: (a: A) => Trampoline<B>): Trampoline<B>


    // The new ZIP operator can help us with combining two Trampolines.
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
*/