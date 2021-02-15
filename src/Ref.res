module type Ref = {
  type t
  let create: int => t
  let set: (t, int) => unit
  let get: t => int
}

type t = ref<int>
let create = x => ref(x)
let set = (t, x) => t := x
let get = t => t.contents
