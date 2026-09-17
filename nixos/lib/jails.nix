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
