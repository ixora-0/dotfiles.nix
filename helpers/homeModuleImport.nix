moduleName: with builtins; let 
  # module should be a string which is the name of the module
  # or a list [name arg1 arg2 ...]

  modulesPath = ../homeModules;
  prependModulesPath = m: modulesPath + m;
  potentials = map prependModulesPath [
    "/${moduleName}.nix"
    "/${moduleName}/${moduleName}.nix"
    "/${moduleName}/$default.nix"
  ];
  existingPaths = filter pathExists potentials;
in

  if length existingPaths == 1 then
    head existingPaths
  else if builtins.length existingPaths > 1 then
    throw "More than one potential path to module ${moduleName}: ${builtins.toString existingPaths}"
  else
    abort "Cannot resolve path to module ${moduleName}, none of these exists: ${builtins.toString potentials}"

