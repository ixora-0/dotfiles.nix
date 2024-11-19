let
  importX = xPath: xName: with builtins; let
    prependXPath = x: xPath + x;
    potentials = map prependXPath [
      "/${xName}.nix"
      "/${xName}/${xName}.nix"
      "/${xName}/$default.nix"
    ];
    existingPaths = filter pathExists potentials;
  in
    if length existingPaths == 1 then
      head existingPaths
    else if builtins.length existingPaths > 1 then
      throw "More than one potential path to ${xName}: ${builtins.toString existingPaths}"
    else
      abort "Cannot resolve path to ${xName}, none of these exists: ${builtins.toString potentials}"
  ;
in {
  importHomeModule = importX ../modules/home;
  importNixosModule = importX ../modules/nixos;
  importBundle = importX ../bundles;
}
