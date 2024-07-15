{
  description = "PJH nix-darwin-home-manager-config";

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
            environment.systemPath = [ "/opt/homebrew/bin" ];    
            
            environment.systemPackages = [
              pkgs.raycast
            ];
            
	          nix.extraOptions = ''
              experimental-features = nix-command flakes
            '';
            
            system.keyboard.enableKeyMapping = true;
            system.keyboard.remapCapsLockToControl = true;

            fonts.packages = [ (pkgs.nerdfonts.override { fonts = [ "UbuntuMono" ]; }) ];

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
              masApps = {
                "Tailscale" = 1475387142;
              };
              casks = [ 
                "google-chrome"
                "mattermost"
                "firefox"
                "sublime-text"
              ];
              taps = [ ];
              brews = [ "node@18" ];
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
                    pkgs.tree
                  ];
                  
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
                  
                  # programs.zsh.enable = true;
                  # programs.zsh.enableCompletion = true;
                  # programs.zsh.enableAutosuggestions = true;
                  # programs.zsh.enableSyntaxHighlighting = true;
                  # programs.zsh.shellAliases = { ls = "ls --color=auto -F"; };

                  programs.zsh = {
                    enable = true;
                    enableCompletion = false; # enabled in oh-my-zsh
                    autosuggestion.enable = true;
                    syntaxHighlighting.enable = true;

                    sessionVariables = {
                      # HISTFILE=~/.histfile;
                      HISTSIZE=25000;
                      SAVEHIST=25000;
                      HISTCONTROL="ignorespace";
                      # PATH="$HOME/bin:/usr/local/bin:$PATH";
                      XDG_CONFIG_HOME="$HOME/.config";
                      REPOS="$HOME/Repos";
                      GITUSER="johanhanses";
                      GHREPOS="$REPOS/github.com/$GITUSER";
                      DOTFILES="$GHREPOS/dotfiles";
                      SCRIPTS="$DOTFILES/scripts";
                      SECOND_BRAIN="$HOME/Documents/obsidian-notes";
                      CLICOLOR=1;
                      # TERM=xterm-256color;
                      # COLORTERM=truecolor;
                      LC_ALL="en_US.UTF-8";
                      LANG="en_US.UTF-8";
                      WORK_DIR="$REPOS/github.com/Digital-Tvilling";
                      LKAB_DIR="$WORK_DIR/.lkab";
                      ONPREM_CONFIG_DIR="$LKAB_DIR/on-prem/config";
                      ONPREM_CERT_DIR="$LKAB_DIR/on-prem/cert";
                      LDFLAGS="-L/opt/homebrew/opt/node@18/lib";
                      CPPFLAGS="-I/opt/homebrew/opt/node@18/include";
                      # PATH="/opt/homebrew/opt/node@18/bin:$PATH";
                      ZSH="$HOME/.oh-my-zsh";
                      # PATH="$XDG_CONFIG_HOME/scripts:$PATH";
                    };

                    shellAliases = {
                      zk="cd $GHREPOS/zettelkasten";
                      repos="cd $REPOS";
                      ghrepos="cd $GHREPOS";
                      dot="cd $GHREPOS/dotfiles";
                      scripts="cd $DOTFILES/scripts";
                      rwdot="cd $REPOS/github.com/rwxrob/dot";
                      rob="cd $REPOS/github.com/rwxrob";
                      dt="cd $REPOS/github.com/Digital-Tvilling";
                      rtm="cd $REPOS/github.com/Digital-Tvilling/dt-frontend-vite";
                      deploy="cd $REPOS/github.com/Digital-Tvilling/deployment-configuration";
                      backend="cd $REPOS/github.com/Digital-Tvilling/deployment-configuration/external/localhost";
                      dti="cd $REPOS/github.com/Digital-Tvilling/dti";
                      icloud="cd ~/Library/Mobile\ Documents/com~apple~CloudDocs";
                      sb="cd $SECOND_BRAIN";
                      "in"="cd $SECOND_BRAIN/0\ Inbox";
                      config="cd $XDG_CONFIG_HOME";
                      sbr="source ~/.bashrc";
                      sz="source ~/.zshrc";
                      cat="bat";
                      fast="fast -u --single-line";
                      # nv=nvim;
                      ".."="cd ..";
                      c="clear";
                      # "?"=duck;
                      # "??"=gpt;
                      # "???"=google;
                      n="npm";
                      nr="npm run";
                      ns="npm start";
                      ls="ls --color=auto";
                      ll="ls -la";
                      l="ls -l";
                      la="ls -lathr";
                      e="exit";
                      gm="git checkout main && git pull";
                      gp="git push";
                      ga="git add .";
                      gs="git status";
                      gc="git checkout";
                      gcb="git checkout -b";
                      gcm="git commit -m";
                      lg="lazygit";
                      k="kubectl";
                      t="tmux";
                      tk="tmux kill-server";
                      tl="tmux ls";
                      ta="tmux a";
                      d="docker";
                      dc="docker compose";
                    };

                    oh-my-zsh = {
                      enable = true;
                      plugins = [ "git" "systemd" "rsync" "kubectl" ];
                      # theme = "terminalparty";
                      theme = "robbyrussell";
                    };
                  };
                  
                  # programs.starship.enable = true;
                  # programs.starship.enableZshIntegration = true;
                  
                  programs.kitty = {
                    enable = true;
                    font.name = "UbuntuMono Nerd Font";
                    font.size = 18;
                  };
                })
	            ];
            };
          } 
        ];
    };
  };
}
