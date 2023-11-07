let pkgs = import <nixpkgs> {};
in {
  alwaysNewDerivation = pkgs.writeText "build-example" (builtins.toString builtins.currentTime);
  constantDerivation = pkgs.runCommand "fetch-example" {} "echo Example > $out";
  recursiveNixDerivation = pkgs.runCommand "recursive-nix-example"
    {
      buildInputs = [ pkgs.nix ];
      requiredSystemFeatures = [ "recursive-nix" ];
      NIX_PATH = "nixpkgs=${pkgs.path}";
    }
    ''
      mkdir $out
      echo ${builtins.toString builtins.currentTime} > $out/time.txt
      ln -s $(nix-build ${./test.nix} -A constantDerivation) $out/recursive-output
    '';
}
