// RUN: %swift -parse -verify -enable-pointer-conversions %s

class C {}
class D {}

func takesMutablePointer(x: UnsafePointer<Int>) {} // expected-note{{}}expected-note{{}}expected-note{{}}expected-note{{}}
func takesMutableVoidPointer(x: UnsafePointer<Void>) {}  // expected-note{{}}expected-note{{}}expected-note{{}}
func takesMutableArrayPointer(x: UnsafePointer<[Int]>) {} // expected-note{{}}
func takesConstPointer(x: ConstUnsafePointer<Int>) -> Character { return "x" } // expected-note{{}}
func takesConstVoidPointer(x: ConstUnsafePointer<Void>) {}
func takesAutoreleasingPointer(x: AutoreleasingUnsafePointer<C>) {} // expected-note{{}}expected-note{{}}

func mutablePointerArguments(p: UnsafePointer<Int>,
                             cp: ConstUnsafePointer<Int>,
                             ap: AutoreleasingUnsafePointer<Int>) {
  takesMutablePointer(nil)
  takesMutablePointer(p)
  takesMutablePointer(cp) // expected-error{{}}
  takesMutablePointer(ap) // expected-error{{}}
  var i: Int = 0
  var f: Float = 0
  takesMutablePointer(&i)
  takesMutablePointer(&f) // expected-error{{}}
  takesMutablePointer(i) // expected-error{{}}
  takesMutablePointer(f) // expected-error{{}}
  var ii: [Int] = [0, 1, 2]
  var ff: [Float] = [0, 1, 2]
  takesMutablePointer(&ii)
  takesMutablePointer(&ff) // expected-error{{}}
  takesMutablePointer(ii) // expected-error{{}}
  takesMutablePointer(ff) // expected-error{{}}

  takesMutableArrayPointer(&i) // expected-error{{}}
  takesMutableArrayPointer(&ii)

  // We don't allow these conversions outside of function arguments.
  var x: UnsafePointer<Int> = &i // expected-error{{}}
  x = &ii // expected-error{{}}
}

func mutableVoidPointerArguments(p: UnsafePointer<Int>,
                                 cp: ConstUnsafePointer<Int>,
                                 ap: AutoreleasingUnsafePointer<Int>,
                                 fp: UnsafePointer<Float>) {
  takesMutableVoidPointer(nil)
  takesMutableVoidPointer(p)
  takesMutableVoidPointer(fp)
  takesMutableVoidPointer(cp) // expected-error{{}}
  takesMutableVoidPointer(ap) // expected-error{{}}
  var i: Int = 0
  var f: Float = 0
  takesMutableVoidPointer(&i)
  takesMutableVoidPointer(&f)
  takesMutableVoidPointer(i) // expected-error{{}}
  takesMutableVoidPointer(f) // expected-error{{}}
  var ii: [Int] = [0, 1, 2]
  var dd: [CInt] = [1, 2, 3]
  var ff: [Int] = [0, 1, 2]
  takesMutableVoidPointer(&ii)
  takesMutableVoidPointer(&dd)
  takesMutableVoidPointer(&ff)
  takesMutableVoidPointer(ii) // expected-error{{}}
  takesMutableVoidPointer(ff) // expected-error{{}}

  // We don't allow these conversions outside of function arguments.
  var x: UnsafePointer<Void> = &i // expected-error{{}}
  x = p // expected-error{{}}
  x = &ii // expected-error{{}}
}

func constPointerArguments(p: UnsafePointer<Int>,
                           cp: ConstUnsafePointer<Int>,
                           ap: AutoreleasingUnsafePointer<Int>) {
  takesConstPointer(nil)
  takesConstPointer(p)
  takesConstPointer(cp)
  takesConstPointer(ap)

  var i: Int = 0
  var f: Float = 0
  takesConstPointer(&i)
  takesConstPointer(&f) // expected-error{{}}
  var ii: [Int] = [0, 1, 2]
  var ff: [Float] = [0, 1, 2]
  takesConstPointer(&ii)
  takesConstPointer(&ff) // expected-error{{}}
  takesConstPointer(ii)
  takesConstPointer(ff) // expected-error{{}}
  takesConstPointer([0, 1, 2])
  takesConstPointer([0.0, 1.0, 2.0]) // expected-error{{}}

  // We don't allow these conversions outside of function arguments.
  var x: ConstUnsafePointer<Int> = &i // expected-error{{}}
  x = ii // expected-error{{}}
  x = p // expected-error{{}}
  x = ap // expected-error{{}}
}

func constVoidPointerArguments(p: UnsafePointer<Int>,
                               fp: UnsafePointer<Float>,
                               cp: ConstUnsafePointer<Int>,
                               cfp: ConstUnsafePointer<Float>,
                               ap: AutoreleasingUnsafePointer<Int>,
                               afp: AutoreleasingUnsafePointer<Float>) {
  takesConstVoidPointer(nil)
  takesConstVoidPointer(p)
  takesConstVoidPointer(fp)
  takesConstVoidPointer(cp)
  takesConstVoidPointer(cfp)
  takesConstVoidPointer(ap)
  takesConstVoidPointer(afp)

  var i: Int = 0
  var f: Float = 0
  takesConstVoidPointer(&i)
  takesConstVoidPointer(&f)
  var ii: [Int] = [0, 1, 2]
  var ff: [Float] = [0, 1, 2]
  takesConstVoidPointer(&ii)
  takesConstVoidPointer(&ff)
  takesConstVoidPointer(ii)
  takesConstVoidPointer(ff)
  // TODO: takesConstVoidPointer([0, 1, 2])
  // TODO: takesConstVoidPointer([0.0, 1.0, 2.0])

  // We don't allow these conversions outside of function arguments.
  var x: ConstUnsafePointer<Void> = &i // expected-error{{}}
  x = ii // expected-error{{}}
  x = p // expected-error{{}}
  x = fp // expected-error{{}}
  x = cp // expected-error{{}}
  x = cfp // expected-error{{}}
  x = ap // expected-error{{}}
  x = afp // expected-error{{}}
}

func autoreleasingPointerArguments(p: UnsafePointer<Int>,
                                   cp: ConstUnsafePointer<Int>,
                                   ap: AutoreleasingUnsafePointer<C>) {
  takesAutoreleasingPointer(nil)
  takesAutoreleasingPointer(p) // expected-error{{}}
  takesAutoreleasingPointer(cp) // expected-error{{}}
  takesAutoreleasingPointer(ap)

  var c: C = C()
  takesAutoreleasingPointer(&c)
  takesAutoreleasingPointer(c) // expected-error{{}}
  var d: D = D()
  takesAutoreleasingPointer(&d) // expected-error{{}}
  takesAutoreleasingPointer(d) // expected-error{{}}
  var cc: [C] = [C(), C()]
  var dd: [D] = [D(), D()]
  takesAutoreleasingPointer(&cc) // expected-error{{}}
  takesAutoreleasingPointer(&dd) // expected-error{{}}

  // Should fail once the existing __conversions are removed
  //var x: AutoreleasingUnsafePointer<C> = &c // e/xpected-error{{}}
}

func pointerConstructor(x: UnsafePointer<Int>) -> UnsafePointer<Float> {
  return UnsafePointer(x)
}

func pointerArithmetic(x: UnsafePointer<Int>, y: UnsafePointer<Int>,
                       i: Int) {
  let p = x + i
  let d = x - y
}

func genericPointerArithmetic<T>(x: UnsafePointer<T>, i: Int, t: T) -> UnsafePointer<T> {
  let p = x + i
  p.initialize(t)
}

func passPointerToClosure(f: UnsafePointer<Float> -> Int) -> Int { }

func pointerInClosure(f: UnsafePointer<Int> -> Int) -> Int {
  return passPointerToClosure { f(UnsafePointer($0)) }
}

struct NotEquatable {}

func arrayComparison(x: [NotEquatable], y: [NotEquatable], p: UnsafePointer<NotEquatable>) {
  // Don't allow implicit array-to-pointer conversions in operators.
  let a: Bool = x == y // expected-error{{}}
  // FIXME: Should be allowed.
  // let b: Bool = p == &x
}

func addressConversion(p: UnsafePointer<Int>, var x: Int) {
  let a: Bool = p == &x
}
