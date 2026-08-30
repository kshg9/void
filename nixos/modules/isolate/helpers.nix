{
  flake.lib.jailHelpers = pkgs: lib: {
    mkJailedDesktop =
      jailed: orig:
      let
        origMainProgram = orig.meta.mainProgram or (lib.getName orig);
        jailedExe = lib.getExe jailed;

        desktopItems = pkgs.runCommand "${orig.name}-jailed-desktop-items" { } ''
          if [ -d "${orig}/share" ]; then
            mkdir -p $out/share
            ${pkgs.lndir}/bin/lndir -silent ${orig}/share $out/share
            
            if [ -d "$out/share/applications" ]; then
              if [ -L "$out/share/applications" ]; then
                target=$(readlink -f "$out/share/applications")
                rm "$out/share/applications"
                mkdir -p "$out/share/applications"
                ${pkgs.lndir}/bin/lndir -silent "$target" "$out/share/applications"
              fi
              
              for f in $out/share/applications/*.desktop; do
                [ -e "$f" ] || continue
                real_file=$(readlink -f "$f")
                rm "$f"
                cp "$real_file" "$f"
                chmod +w "$f"
                
                substituteInPlace "$f" \
                  --replace-quiet "Exec=${origMainProgram}" "Exec=${jailedExe}" \
                  --replace-quiet "Exec=${orig}/bin/${origMainProgram}" "Exec=${jailedExe}"
              done
            fi
          fi
        '';
      in
      pkgs.symlinkJoin {
        name = "${orig.name}-jailed-desktop";
        paths = [
          jailed
          desktopItems
          orig
        ];
        meta.mainProgram = origMainProgram;
      };
    wrapAgent =
      pkg: extraPathPkgs:
      pkgs.symlinkJoin {
        name = "${pkg.name}-deps-wrapped";
        paths = [ pkg ];
        meta.mainProgram = pkg.meta.mainProgram or (lib.getName pkg);
        nativeBuildInputs = [ pkgs.makeBinaryWrapper ];
        postBuild = ''
          for bin in $out/bin/*; do
            wrapProgram "$bin" \
              --prefix PATH : ${lib.makeBinPath extraPathPkgs}
          done
        '';
      };

    agentRuntime =
      jail:
      jail.combinators.add-runtime ''
        if [ -n "''${JAIL_RW:-}" ]; then
          SRC=$(realpath -m "''${JAIL_RW}")
          RUNTIME_ARGS+=(--bind "$SRC" "$HOME/JailedProject")
        fi

        if [ -n "''${IN_NIX_SHELL:-}" ]; then
          RUNTIME_ARGS+=(--setenv PATH "$PATH")
          RUNTIME_ARGS+=(--ro-bind-try /nix/store /nix/store)
        fi
      '';
  };
}
