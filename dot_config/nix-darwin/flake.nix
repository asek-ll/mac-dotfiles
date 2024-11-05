{
  description = "Example Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    # nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager }:
  let
    configuration = { pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [ 
            pkgs.alacritty

            pkgs.neovim
            pkgs.zoxide
            pkgs.starship
            pkgs.eza
            pkgs.lf
            pkgs.jq
            pkgs.fd
            pkgs.ripgrep
            pkgs.bat
            pkgs.difftastic

            # pkgs.nerd-font-patcher

            pkgs.keepassxc
        ];
      environment.systemPath = [];

      # Auto upgrade nix package and the daemon service.
      services.nix-daemon.enable = true;
      # nix.package = pkgs.nix;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Create /etc/zshrc that loads the nix-darwin environment.
      # programs.zsh.enable = true;  # default shell on catalina
      programs.fish.enable = true;
      environment.shells = [ pkgs.fish ];
      # chsh -s /run/current-system/sw/bin/fish
      users.users."$USER".shell = pkgs.fish;

      environment.variables = {
          EDITOR = "nvim";
      };

      programs.tmux.enable = true;
      programs.tmux.enableMouse = true;
      programs.tmux.extraConfig = ''
set -sg escape-time 0 
set-window-option -g mode-keys vi

set-option -s set-clipboard off
# bind-key -T copy-mode-vi Enter send-keys -X copy-pipe-and-cancel "xclip -selection clipboard -i"
bind-key -T copy-mode-vi Enter send-keys -X copy-pipe "pbcopy"

# set-option -g default-terminal "screen-256color"
set-option -g default-terminal "tmux-256color" #enable italic works
set-option -sa terminal-features ',xterm-kitty:RGB'
set-option -sa terminal-overrides ',xterm*:Tc:sitm=\E[3m:ritm=\E[23m'
set-option -g focus-events on
set-option -g history-limit 4000
# set-option -g default-shell /opt/homebrew/bin/nu
# set-option -g default-shell /opt/homebrew/bin/fish

set -g status-interval 1
set -g status-right "#{?window_bigger,[#{window_offset_x}#,#{window_offset_y}] ,}\"#{=21:pane_title}\" %H:%M %d-%b-%y #(pomo)"
set -g status-style fg=black,bg=brightcyan
      '';

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";

      security.pam.enableSudoTouchIdAuth = true;

      system.keyboard.enableKeyMapping = true;
      system.keyboard.swapLeftCtrlAndFn = true;
      # system.keyboard.nonUS.remapTilde = true;
      system.defaults = {
          dock.autohide = true;
          dock.mru-spaces = false;
          finder.AppleShowAllExtensions = true;
      };

      homebrew.enable = false;
      homebrew.brews = [
          # "fish"
          # "tmux"
          # "neovim"
          # "zoxide"
          # "starship"
          # "direnv"

          # "eza"
          # "lf"
          # "jq"
          # "fd"
          # "bat"
          # "difftastic"

          # "rclone"
          # "syncthing"
          # "tailscale"
          # "zerotier-one"

          # "koekeishiya/formulae/skhd"
          # "koekeishiya/formulae/yabai"

          # "colima"
          # "docker-compose"

          # "pipx"
          # "rustup"
          # "uv"
          # "yarn"

          # "hashicorp/tap/terraform-ls"
          # "lua-language-server"
          # "pyright"
          # "typescript-language-server"

          # "black"
          # "pgformatter"
          # "prettier"
          # "stylua"
          # "taplo"

          # "golangci-lint"
          # "flake8"
          # "yamllint"

      ];
      homebrew.casks = [
          # "alacritty"
          # "kitty"
          # "wezterm

          # "keepassxc"
          # "font-sf-mono-nerd-font"
          # "raycast"
          # "telegram-desktop"
          # "ukelele"
          # "nikitabobko/tap/aerospace"
      ];
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#simple
    darwinConfigurations."macbook" = nix-darwin.lib.darwinSystem {
      modules = [ 
          configuration 
          home-manager.darwinModules.home-manager
          {
              users.users."$USER".home = "/Users/$USER";
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.users."$USER" = import ./home.nix; 

          }
      ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."macbook".pkgs;
  };
}
