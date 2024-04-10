moduleName: with builtins; let 
  modulesPath = ../modules/nixos;
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

