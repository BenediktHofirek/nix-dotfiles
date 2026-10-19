{ lib, ... }@inputs:
let
  common = import ./common/_default.nix inputs;
in 
{
  wayland.windowManager.hyprland = {

    settings = with common; {

      monitor = [
        {
          # Asus portable (left)
          output = "DP-1";
          mode = "2560x1600@60";
          position = "0x600";
          scale = 1.6;
        }
        {
          # Huawei (center)
          output = "HDMI-A-1";
          mode = "3840x2560@49.98";
          position = "1600x0";
          scale = 1.6;
        }
        {
          # Built in screen (right)
          output = "eDP-2";
          mode = "2560x1600@60";
          position = "4000x400";
          scale = 1.333333;
        }
      ];

      bind = []
        # Switch workspace
        ## Display 1
        ++ map (i: (switchWorkspace "${display1Mod}" i (i+10))) (lib.range 1 9)        
        ## Display 2
        ++ map (i: (switchWorkspace "${display2Mod}" i (i+20))) (lib.range 1 9)        
        ## Display 3
        ++ map (i: (switchWorkspace "${display3Mod}" i (i+30))) (lib.range 1 9)        
      ;

      workspace_rule = []
        ## Display 1
        ++ map (i: { workspace = i+10; monitor = "${display1Id}"; }) (lib.range 1 9)
        ## Display 2
        ++ map (i: { workspace = i+20; monitor = "${display2Id}"; }) (lib.range 1 9)
        ## Display 3
        ++ map (i: { workspace = i+30; monitor = "${display3Id}"; }) (lib.range 1 9)
        ## Display 4
        ++ map (i: { workspace = i+40; monitor = "${display4Id}"; }) (lib.range 1 9)
      ;

    };
  };
}
