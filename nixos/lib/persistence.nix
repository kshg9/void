{
  flake.lib.persistenceHelpers =
    lib:
    let
      pathOf = entry: if builtins.isString entry then entry else entry.directory;
      beneath = parent: child: parent == child || lib.hasPrefix "${parent}/" child;
      tokens =
        value:
        lib.concatMap (
          line: lib.filter (part: builtins.isString part && part != "") (builtins.split "[ \t\n]+" line)
        ) (if value == null then [ ] else lib.toList value);
      enabled =
        value:
        value == true
        || lib.elem (lib.toLower (toString value)) [
          "1"
          "yes"
          "true"
          "on"
        ];
      stateName =
        token:
        let
          source = builtins.head (lib.splitString ":" token);
          parts = lib.filter (part: part != "" && part != ".") (lib.splitString "/" source);
        in
        if
          source == ""
          || lib.hasPrefix "/" source
          || lib.elem ".." parts
          || builtins.match "[A-Za-z0-9_./-]+" source == null
          || parts == [ ]
        then
          null
        else
          lib.concatStringsSep "/" parts;
    in
    {
      # First declaration wins, preserving explicit ownership and mode overrides.
      collapseDirectories =
        entries:
        let
          unique = lib.foldl' (
            acc: entry: if lib.any (other: pathOf other == pathOf entry) acc then acc else acc ++ [ entry ]
          ) [ ] entries;
        in
        lib.filter (
          entry:
          !lib.any (other: pathOf other != pathOf entry && beneath (pathOf other) (pathOf entry)) unique
        ) unique;

      discoverState =
        {
          services,
          registry ? { },
          excludeServices ? [ ],
          excludePaths ? [ ],
        }:
        let
          optedOut =
            excludeServices
            ++ lib.mapAttrsToList (_: service: service.unit) (
              lib.filterAttrs (_: service: service.enable && !service.state.persist) registry
            );
          declarations = lib.mapAttrsToList (unit: service: {
            inherit unit;
            dynamic = enabled (service.serviceConfig.DynamicUser or false);
            names = tokens (service.serviceConfig.StateDirectory or [ ]);
          }) (lib.filterAttrs (unit: service: (service.enable or true) && !lib.elem unit optedOut) services);
          registered = lib.concatLists (
            lib.mapAttrsToList (
              _: service:
              lib.optional (service.enable && service.state.persist && !lib.elem service.unit optedOut) {
                inherit (service) unit;
                dynamic = enabled (services.${service.unit}.serviceConfig.DynamicUser or false);
                names = service.state.directories;
              }
            ) registry
          );
          parsed = lib.concatMap (
            declaration:
            map (
              token:
              let
                name = stateName token;
              in
              {
                inherit (declaration) unit dynamic;
                inherit token;
                path =
                  if name == null then
                    null
                  else
                    "/var/lib/${lib.optionalString declaration.dynamic "private/"}${name}";
              }
            ) declaration.names
          ) (declarations ++ registered);
          extras = lib.concatLists (
            lib.mapAttrsToList (
              _: service:
              if service.enable && service.state.persist && !lib.elem service.unit optedOut then
                map (path: {
                  inherit path;
                  inherit (service) unit;
                  dynamic = false;
                  token = path;
                }) service.state.paths
              else
                [ ]
            ) registry
          );
          included = lib.filter (
            entry: entry.path != null && !lib.any (path: beneath path entry.path) excludePaths
          ) (parsed ++ extras);
        in
        {
          directories = lib.unique (map (entry: entry.path) included);
          privateDirectories = lib.unique (
            map (entry: entry.path) (lib.filter (entry: entry.dynamic) included)
          );
          skipped = map (entry: "${entry.unit}: ${entry.token}") (
            lib.filter (entry: entry.path == null) parsed
          );
        };
    };
}
