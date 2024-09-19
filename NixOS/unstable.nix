{ pkgs, config, ... }:

let

  pkgsUnstable = import <nixpkgs-unstable> {};

in

{
    environment.systemPackages = with pkgsUnstable; [
        wideriver
    ];
}
