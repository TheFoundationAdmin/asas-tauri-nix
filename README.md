# asas-tauri-nix

Nix packaging for the A.S.A.S. / M.A.R.I.A. desktop client. It wraps the prebuilt
Linux AppImage served at https://asas.archiqueer.com/install -- no source is built here.

    nix profile add github:TheFoundationAdmin/asas-tauri-nix     # install
    nix run github:TheFoundationAdmin/asas-tauri-nix             # try without installing

Needs flakes enabled (`experimental-features = nix-command flakes`). x86_64-linux only.

## Maintainer: publishing a new release
1. Upload the release to the server as usual.
2. `./update.sh`   (rewrites version.json with the new version + hash)
3. `git commit -am "asas <version>" && git tag v<version> && git push --tags`

Pin a version: `nix profile add github:TheFoundationAdmin/asas-tauri-nix/v0.4.5`.
Keep old release files on the server, or pinned tags stop building.
