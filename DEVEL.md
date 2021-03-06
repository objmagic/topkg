Package structure
-----------------

This repo is the base of two OPAM packages:

- `topkg`, with OPAM file [topkg.opam](topkg.opam)
- `topkg-care` with OPAM file [topkg-care.opam](topkg-care.opam)

Both share the same [pkg/pkg.ml](pkg/pkg.ml) file. `topkg` simply
builds the `Topkg` library and `topkg-care` builds the `Topkg_care`
library and the `topkg` command line tool. The distinction is made in
the `pkg.ml` file based on the package name passed to the build
instructions.

The reason for this structure is that while both `Topkg` and `Topkg_care`
could be distributed together and `Topkg_care` be simply build
depending on optional dependencies being present, this would have a
fatal flaw: `topkg` cannot be used for any of `Topkg_care`'s
dependencies. Since we want to use `topkg` for these dependencies
aswell, this structure allows to cut the dependency cycle that would
occur.

So if you want to develop `topkg` you should do a:

```
opam pin add -kgit topkg topkg#master
opam pin add -kgit topkg-care topkg#master
```

