{
  flake.lib.jailHelpers =
    pkgs: lib:
    let
      agentRuntime =
        jail:
        jail.combinators.compose (
          with jail.combinators;
          [
            (fwd-env "PATH")
            (add-pkg-deps [
              pkgs.bash
              pkgs.coreutils
              pkgs.wl-clipboard
            ])
            (try-readonly "/nix")
            (try-readonly "/run/current-system")
            (try-readonly "/etc/profiles/per-user")
            (try-readonly "/etc/static")
            (try-ro-bind "/" "/host_root")

            (add-runtime ''
              if [ -n "''${JAIL_RW:-}" ]; then
                SRC=$(realpath -m "''${JAIL_RW}")
                RUNTIME_ARGS+=(--bind "$SRC" "$HOME/host_share/")
              fi
            '')
          ]
        );
    in
    {
      inherit agentRuntime;

      mkCli =
        jail: name: package: permissions:
        let
          jailed = jail name package permissions;
        in
        pkgs.symlinkJoin {
          name = "${name}-jailed";
          paths = [ jailed ];
          postBuild = ''
            # Keep completion data discoverable without installing unwrapped binaries.
            for completionDir in \
              bash-completion \
              fish/vendor_completions.d \
              fish/vendor_functions.d \
              zsh/site-functions; do
              if [ -d "${package}/share/$completionDir" ]; then
                mkdir -p "$out/share/$completionDir"
                ${pkgs.lndir}/bin/lndir -silent \
                  "${package}/share/$completionDir" "$out/share/$completionDir"
              fi
            done
          '';
          meta = (package.meta or { }) // {
            mainProgram = name;
          };
        };

      cliAgent =
        jail:
        {
          name,
          runtimePackages ? [ ],
          background ? false,
        }:
        jail.combinators.compose (
          with jail.combinators;
          [
            # Forward PATH before permissions that add tools, including BROWSER.
            (agentRuntime jail)
            (persist-home name)
            network
            gui
            (share-ns "pid")
            (share-ns "cgroup")
            (share-ns "user")
            open-urls-in-browser
            (try-readwrite (noescape "~/Projects"))
            (try-readwrite (noescape "~/Downloads"))
          ]
          ++ lib.optionals background [
            no-die-with-parent
            (try-readwrite "/tmp")
          ]
          ++ [ (add-pkg-deps runtimePackages) ]
        );

    };
}
