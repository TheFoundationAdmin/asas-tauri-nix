{
  description = "A.S.A.S. / M.A.R.I.A. desktop client -- packages the prebuilt Linux release from asas.archiqueer.com";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux"; # the release only ships an amd64 AppImage
      pkgs = nixpkgs.legacyPackages.${system};

      # version.json = { version, url, hash } -- rewritten by ./update.sh
      rel = builtins.fromJSON (builtins.readFile ./version.json);

      pname = "asas";
      src = pkgs.fetchurl { inherit (rel) url hash; };
      contents = pkgs.appimageTools.extract { inherit pname src; version = rel.version; };

      asas = pkgs.appimageTools.wrapType2 {
        inherit pname src;
        version = rel.version;

        # Tauri uses the system WebKitGTK stack; give the FHS sandbox the usual suspects.
        extraPkgs = p: [ p.webkitgtk_4_1 p.gtk3 p.libsoup_3 p.librsvg p.glib-networking ];

        # Desktop entry + icons, so it shows up in the app launcher.
        extraInstallCommands = ''
          mkdir -p $out/share/applications
          cp ${contents}/*.desktop $out/share/applications/ 2>/dev/null || true
          sed -i 's|^Exec=.*|Exec=${pname}|' $out/share/applications/*.desktop 2>/dev/null || true
          if [ -d ${contents}/usr/share/icons ]; then
            cp -r ${contents}/usr/share/icons $out/share/
          fi
        '';

        meta = {
          description = "A.S.A.S. desktop client";
          homepage = "https://asas.archiqueer.com/install";
          platforms = [ system ];
          mainProgram = pname;
        };
      };
    in {
      packages.${system} = { default = asas; asas = asas; };
      apps.${system}.default = { type = "app"; program = "${asas}/bin/${pname}"; };
    };
}
