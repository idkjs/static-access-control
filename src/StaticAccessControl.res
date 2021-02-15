// https://blog.janestreet.com/howto-static-access-control-using-phantom-types/
// We’ll start by implementing an int ref module on top of OCaml’s built-in ref.
module Ref: {
  type t
  let create: int => t
  let set: (t, int) => unit
  let get: t => int
} = {
  type t = ref<int>
  let create = x => ref(x)
  let set = (t, x) => t := x
  let get = t => t.contents
}

// The simplest way of getting a read-only handle is to create another module with a different, more constrained signature.

module RORef: {
  type t
  let \"import": Ref.t => t
  let get: t => int
} = {
  type t = Ref.t
  let \"import" = x => x
  let get = Ref.get
}
// An RORef.t is just a Ref.t underneath, but the signature hides that fact by making the RORef.t abstract.
//  Note that there is a function for converting Ref.t’s to RORef.t’s (import), but not the other way around.
//   This gives you a way to create the read-only handle, but prevents someone with such a handle from recovering
//   the underlying read-write handle. The downside to this approach is that it is impossible to write code that
//   is polymorphic over Ref.t’s and RORef.t’s, even if that code only uses the functionality common to both, i.e.,
//   if it only reads.

// A better solution is to use a phantom type to encode the access control rights associated
// with a particular value. But what is a phantom type? The definition unfortunately
//  makes it sound more complicated than it is. A phantom type is a type that is
//  used as a parameter to another type (like the int in int list), but which is
//  unused in the actual definition (as in type 'a t = int). The fact that the
//  phantom parameter is unused gives you the freedom to use it to encode additional
//  information about your types, which you can then convince the type checker to keep
//  track of for you. Since the phantom type isn’t really part of the definition of the type,
//  it has no effect on code-generation and so is completely free at runtime.
//  The way in which you convince the type-checker to track the information you’re interested
//  in is by constraining the appearance of the phantom types using a signature.

// It’s easier to understand once you look at an example.
type readonly

type readwrite

module PRef: {
  type t<'a>
  let create: int => t<readwrite>
  let set: (t<readwrite>, int) => unit
  let get: t<'a> => int
  let readonly: t<'a> => t<readonly>
} = {
  type t<'a> = Ref.t
  let create = Ref.create
  let set = Ref.set
  let get = Ref.get
  let readonly = x => x
}

let sumrefs = reflist => List.fold_left(\"+", 0, List.map(PRef.get, reflist))

let increfs = reflist => List.iter(r => PRef.set(r, PRef.get(r) + 1), reflist)
