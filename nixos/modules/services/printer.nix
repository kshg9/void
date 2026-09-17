{
  flake.nixosModules.printer = { pkgs, ... }: {
    services.printing = {
      enable = true;
      drivers = [ pkgs.canon-capt ];
      listenAddresses = [ "localhost:631" ];
      allowFrom = [ "localhost" ];
      defaultShared = false;
    };

    hardware.printers = {
      ensurePrinters = [
        {
          name = "Canon_LBP2900";
          deviceUri = "usb://Canon/LBP2900?serial=0000D29A1NRj";
          model = "canon/CanonLBP-2900-3000.ppd";
          ppdOptions = {
            PageSize = "iso_a4_210x297mm";
          };
        }
      ];
      ensureDefaultPrinter = "Canon_LBP2900";
    };
  };
}
