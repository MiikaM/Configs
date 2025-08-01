# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{ config, lib, pkgs, ... }:

{
  imports = [
    # include NixOS-WSL modules
    <nixos-wsl/modules>
  ];

  wsl.enable = true;
  wsl.defaultUser = "nixos";

  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
  # User definitions

  users.defaultUserShell = pkgs.zsh;

  # Package configurations
  environment.systemPackages = with pkgs; [
    git
    jujutsu
    neovim
    oh-my-posh
    wget
    zsh
    gemini-cli
    tree
    git-credential-manager
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "jujutsu-0.23.0"
  ];

  # Program definitions
  programs.nix-ld = {
    enable = true;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;

    shellAliases = {
      ll = "ls -l";
      update = "sudo nixos-rebuild switch";
    };
  };
}
