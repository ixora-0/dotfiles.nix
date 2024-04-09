# explicitly declare unfree packages
# takes lib, packages and returns a predicate
lib: packages: pkg: 
  builtins.elem
    (lib.getName pkg)
    (map lib.getName packages)
