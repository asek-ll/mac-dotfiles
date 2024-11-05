# installation
```
 curl -L https://nixos.org/nix/install | sh -s -- --daemon


use zsh or
 #fix
sudo rm /etc/ssl/certs/ca-certificates.crt
sudo ln -s /nix/var/nix/profiles/default/etc/ssl/certs/ca-bundle.crt /etc/ssl/certs/ca-certificates.crt

#nofix
sudo launchctl kickstart -k system/org.nixos.nix-daemon
```


```
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | \
  sh -s -- install --no-confirm --extra-conf "trusted-users = $(whoami)"
```

# nix darwin
```
nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer

./result/bin/darwin-installer

zsh only configured
```


# usage
```
#flakes
nix run nix-darwin -- switch --flake .#macbook

nix run nix-darwin --extra-experimental-features nix-command --extra-experimental-features flakes -- switch --flake .#macbook

#no-flakes
darwin-rebuild switch
```


``` nix + darwin-nix + home-manager
https://gist.github.com/jmatsushita/5c50ef14b4b96cb24ae5268dab613050
```

