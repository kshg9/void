{
  flake.lib.mkJailedDesktop =
    pkgs: lib: jailed: orig:
    let
      mainProgram = orig.meta.mainProgram or (lib.getName orig);
      desktopItems = pkgs.runCommand "${orig.name}-jailed-desktop-items" { } ''
        # Link through original paths so relative asset links still resolve
        # when their targets live outside share (for example, browser icons).
        mkdir -p "$out/share"
        if [ -d "${orig}/share" ]; then
          cp --recursive --symbolic-link --dereference --no-preserve=mode \
            "${orig}/share/." "$out/share/"
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
      ];
      postBuild = ''
        # Preserve the upstream command name as an alias to the jail.
        # Only shared data comes from the original package, not its binaries.
        if [ ! -e "$out/bin/${mainProgram}" ]; then
          mkdir -p "$out/bin"
          ln -s "${lib.getExe jailed}" "$out/bin/${mainProgram}"
        fi
      '';
      meta = orig.meta // {
        inherit mainProgram;
      };
    };
}
