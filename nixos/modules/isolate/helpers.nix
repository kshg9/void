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

    agentRuntime =
      jail:
      jail.combinators.compose (
        with jail.combinators;
        [
          (fwd-env "PATH")
          (try-readonly "/nix")
          (try-readonly "/run/current-system")
          (try-readonly "/etc/profiles/per-user")
          (try-readonly "/etc/static")
          (add-runtime ''
            if [ -n "''${JAIL_RW:-}" ]; then
              SRC=$(realpath -m "''${JAIL_RW}")
              RUNTIME_ARGS+=(--bind "$SRC" "$HOME/JailedProject")
            fi
          '')
        ]
      );
  };
}
