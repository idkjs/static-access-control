

let fst: 'a 'b. (('a, 'b)) => 'a =
  /* "For all ['a] and ['b], ..." */
  ((x, _)) => x;

exception Crisis
let panic: 'a .unit => 'a = () => raise(Crisis);


Js.log(panic())
// This expression's type contains type variables that can't be generalized:
// ref(list('_weak1))
// let state = ref([]);

//  This expression's type contains type variables that can't be generalized:
  // ref(list('_weak1))
// let sneaky_id = (x) => {
//   state := [x, ...state^];
//   x;
// };
