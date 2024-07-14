{
  description = "PJH nix-config";

  inputs = {
    # Where we get most of our software. Giant mono repo with recipes
    # called derivations that say how to build software.
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # Manages configs links things into your home directory
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Controls system level software and settings including fonts
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs: {
    darwinConfigurations.DtMackan =
      inputs.darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        pkgs = import inputs.nixpkgs { 
          system = "aarch64-darwin"; 
          config = {
            allowUnfree = true;
            allowUnfreePredicate = _: true;
          };
        };
	modules = [
          ({ pkgs, ... }: {
            # here go the darwin preferences and config items
	    programs.zsh.enable = true;
            environment.shells = [ pkgs.bash pkgs.zsh ];
            environment.loginShell = pkgs.zsh;
            
            environment.systemPackages = [
              pkgs.raycast
            ];
            
	    nix.extraOptions = ''
              experimental-features = nix-command flakes
            '';
            
            system.keyboard.enableKeyMapping = true;
            system.keyboard.remapCapsLockToControl = true;

#            fonts.fontDir.enable = false; 
#            fonts.fonts = [ (pkgs.nerdfonts.override { fonts = [ "Meslo" ]; }) ];

            services.nix-daemon.enable = true;

            system.defaults.finder.AppleShowAllExtensions = true;
            system.defaults.finder._FXShowPosixPathInTitle = true;
            system.defaults.finder.FXPreferredViewStyle = "Nlsv";
            system.defaults.finder.ShowPathbar = true;
            system.defaults.finder.ShowStatusBar = true;

            system.defaults.dock.autohide = true;
            system.defaults.NSGlobalDomain.AppleShowAllExtensions = true;

            # backwards compat; don't change
            system.stateVersion = 4;
            
            homebrew = {
              enable = true;
              caskArgs.no_quarantine = true;
              global.brewfile = true;
              masApps = { };
              casks = [ "google-chrome" "mattermost" "firefox" "sublime-text" ];
              taps = [ ];
              # brews = [ ];
            };
          })
          inputs.home-manager.darwinModules.home-manager
          {

	    users.users.johanhanses = {
	      name = "johanhanses";
	      home = "/Users/johanhanses";
	    };
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.johanhanses.imports = [
	        ({ pkgs, ... }: {
                  # Don't change this when you change package input. Leave it alone.
                  home.stateVersion = "24.05";
                  # specify my home-manager configs
                  home.packages = [
                    pkgs.ripgrep
                    pkgs.fd
                    pkgs.curl
                    pkgs.less
                  ];
                  home.sessionVariables = {
                    PAGER = "less";
                    CLICLOLOR = 1;
                    EDITOR = "vim";
                  };
                  home.file.".inputrc".text = ''
                    set show-all-if-ambiguous on
                    set completion-ignore-case on
                    set mark-directories on
                    set mark-symlinked-directories on
                    set match-hidden-files off
                    set visible-stats on
                    set keymap vi
                    set editing-mode vi-insert
                  '';
                  programs.bat.enable = true;
                  programs.bat.config.theme = "TwoDark";
                  programs.fzf.enable = true;
                  programs.fzf.enableZshIntegration = true;
                  programs.git.enable = true;
                  programs.git.userName = "johanhanses";
                  programs.git.userEmail = "johanhanses@gmail.com";
                  programs.zsh.enable = true;
                  programs.zsh.enableCompletion = true;
                  programs.zsh.enableAutosuggestions = true;
                  programs.zsh.enableSyntaxHighlighting = true;
                  programs.zsh.shellAliases = { ls = "ls --color=auto -F"; };
                  programs.starship.enable = true;
                  programs.starship.enableZshIntegration = true;
                  programs.alacritty = {
                    enable = true;
                    # settings.font.normal.family = "MesloLGS Nerd Font Mono";
                    settings.font.size = 16;
                  };
		  
                })
	      ];
            };
          } 
        ];
    };
  };
}
