{
  inputs,
  ...
}:
{
  flake.nixosModules.neovim =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      imports = [
        (inputs.wrappers.lib.getInstallModule {
          name = "neovim";
          value = inputs.wrappers.lib.wrapperModules.neovim;
        })
      ];

      wrappers.neovim = {
        enable = true;

        specs.main = {
          data = null;
          config = ''
            vim.opt.tabstop = 2
            vim.opt.shiftwidth = 2
            vim.opt.expandtab = true
            vim.opt.autoindent = true
            vim.opt.number = true
            vim.opt.hlsearch = true
            vim.opt.ruler = true
            vim.api.nvim_set_hl(0, 'Comment', { ctermfg = 2, fg = 'green' })

            -- Enable transparent background
            local transparent_groups = {
              "Normal", "NormalNC", "LineNr", "FoldColumn", "NonText", 
              "SpecialKey", "SignColumn", "EndOfBuffer", "NormalFloat", "FloatBorder"
            }

            for _, group in ipairs(transparent_groups) do
              vim.cmd("highlight " .. group .. " guibg=NONE ctermbg=NONE")
            end
          '';
        };
      };

      environment.systemPackages = [
        config.wrappers.neovim.wrapper
      ];
    };
}
