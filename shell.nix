{
  lib ? import <lib> {},
  pkgs ? import (fetchTarball channel:nixos-23.11) {}
}:

let

  # define packages to install with special handling for OSX
  basePackages = [
    pkgs.gnumake
    pkgs.gcc
    pkgs.readline
    pkgs.zlib
    pkgs.libxml2
    pkgs.libiconv
    pkgs.libffi
    pkgs.openssl
    pkgs.curl
    pkgs.git

    pkgs.sqlite

    pkgs.ruby_3_2
    pkgs.bundler
  ];

  inputs = basePackages
    ++ [ pkgs.bashInteractive ]
    ++ pkgs.lib.optionals pkgs.stdenv.isLinux [ pkgs.inotify-tools ]
    ++ pkgs.lib.optionals pkgs.stdenv.isDarwin (with pkgs.darwin.apple_sdk.frameworks; [
        CoreFoundation
        CoreServices
      ]);

in pkgs.mkShell {
  buildInputs = inputs;

  shellHook = ''
    export APP_HOME=$(pwd);
  '';
}
