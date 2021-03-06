(*---------------------------------------------------------------------------
   Copyright (c) 2016 Daniel C. Bünzli. All rights reserved.
   Distributed under the ISC license, see terms at the end of the file.
   %%NAME%% %%VERSION%%
  ---------------------------------------------------------------------------*)

open Topkg_result

type context = [ `Pin | `Dev | `Distrib ]

type t =
  { prepare_on_pin : bool;
    dir : Topkg_fpath.t;
    pre : Topkg_conf.t -> unit result;
    cmd : Topkg_conf.t -> Topkg_conf.os -> Topkg_cmd.t;
    post : Topkg_conf.t -> unit result; }

let with_dir b dir = { b with dir }

let nop = fun _ -> Ok ()
let cmd c os =
  let ocamlbuild = Topkg_conf.tool "ocamlbuild" os in
  let build_dir = Topkg_conf.build_dir c in
  Topkg_cmd.(ocamlbuild % "-use-ocamlfind" % "-classic-display" %
             "-build-dir" % build_dir)

let v
    ?(prepare_on_pin = true) ?(dir = "_build") ?(pre = nop) ?(cmd = cmd)
    ?(post = nop) () =
  { prepare_on_pin; dir; pre; cmd; post }

let prepare_on_pin b = b.prepare_on_pin
let dir b = b.dir
let pre b = b.pre
let cmd b = b.cmd
let post b = b.post
let codec =
  let prepare_on_pin = Topkg_codec.(with_kind "prepare_on_pin" @@ bool) in
  let dir = Topkg_codec.(with_kind "dir" @@ string) in
  let fields =
    let stub _ = invalid_arg "not executable outside package definition" in
    (fun b -> b.prepare_on_pin, b.dir),
    (fun (prepare_on_pin, dir)  ->
       { prepare_on_pin; dir; pre = stub; cmd = stub; post = stub })
  in
  Topkg_codec.version 0 @@
  Topkg_codec.(view ~kind:"build" fields (pair prepare_on_pin dir))

(*---------------------------------------------------------------------------
   Copyright (c) 2016 Daniel C. Bünzli

   Permission to use, copy, modify, and/or distribute this software for any
   purpose with or without fee is hereby granted, provided that the above
   copyright notice and this permission notice appear in all copies.

   THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
   WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
   MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
   ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
   WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
   ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
   OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  ---------------------------------------------------------------------------*)
