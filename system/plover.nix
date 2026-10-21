{ username, ... }:

{
  users.users.${username}.extraGroups = [ 
    "dialout" 
    "input"
    ];

  services.udev.extraRules = ''
      KERNEL=="uinput", GROUP="input", MODE="0660", OPTIONS+="static_node=uinput"
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0660", GROUP="dialout"
  '';
}
