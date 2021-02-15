// // https://blog.janestreet.com/howto-static-access-control-using-phantom-types/
// // We’ll start by implementing an int ref module on top of OCaml’s built-in ref.
// module Ref: {type t; let create: int => t; let set: (t, int) => unit; let get: t => int;} = {
//   type t = ref(int);
//   let create = (x) => ref(x);
//   let set = (t, x) => t := x;
//   let get = (t) => t^;
// };

type readonly;

type readwrite;

type immutable;
module IRef: {
  type t('a);
  let create: int => t('a);
  let set: (t(readwrite), int) => unit;
  let get: t('a) => int;
  let readonly: t('a) => t(readonly);
} = {
  type t('a) = Ref.t;
  let create = Ref.create;
  // let create_readwrite = Ref.create;
  let readonly = (x) => x;
  let set = Ref.set;
  let get = Ref.get;
};


let r = IRef.create(3);
Js.log(r)
let r: IRef.t(immutable) = IRef.create(3);
Js.log(r)
Js.log(IRef.get(r))
