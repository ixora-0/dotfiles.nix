{ lib }: rec {
  importX = import ./importX.nix;
  mkIfElse = import ./mkIfElse.nix { inherit lib; };
  makeUnfreePredicate = import ./makeUnfreePredicate.nix { inherit lib; };
  importHomeModule = importX.importHomeModule;
  importNixosModule = importX.importNixosModule;
}
