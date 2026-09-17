{
  flake.lib.mkJailedDesktop =
    pkgs: lib: jailed: orig:
    let
      mainProgram = orig.meta.mainProgram or (lib.getName orig);
      desktopItems = pkgs.runCommand "${orig.name}-jailed-desktop-items" { } ''
        # Some packages make share a symlink. Merge its contents explicitly
        mkdir -p "$out/share"
        if [ -d "${orig}/share" ]; then
          ${pkgs.lndir}/bin/lndir -silent "${orig}/share" "$out/share"
        fi

        # Recreate applications so rewritten files cannot modify the originals.
        rm -rf "$out/share/applications"
        mkdir -p "$out/share/applications"
        for source in "${orig}"/share/applications/*.desktop; do
          [ -e "$source" ] || continue
          target="$out/share/applications/$(basename "$source")"
          cp "$source" "$target"
          chmod +w "$target"

          # Launch the wrapper instead of the original executable.
          substituteInPlace "$target" \
            --replace-quiet "Exec=${mainProgram}" "Exec=${lib.getExe jailed}" \
            --replace-quiet "Exec=${orig}/bin/${mainProgram}" "Exec=${lib.getExe jailed}"
        done
      '';
    in
    pkgs.symlinkJoin {
      name = "${orig.name}-jailed-desktop";
      paths = [
        jailed
        desktopItems
        orig
      ];
      meta = orig.meta // {
        inherit mainProgram;
      };
    };
}
