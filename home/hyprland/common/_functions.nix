{ lib,  ... }:

let 
  constants = import ./_constants.nix;
in rec {
  lua = lib.generators.mkLuaInline;

  bind = key: action: {
    _args = [
      key
      (lua action)
    ];
  };

  switchWorkspace = modifier: key: target: {
    _args = [
      "${modifier} + ${toString key}"
      (lua "hl.dsp.focus({ workspace = ${toString target} })")
    ];
  };

  bindCommand = key: action: bind "${constants.commandMod}+${key}" action;

  withFlags = flags: b: { _args = b._args ++ [ flags ]; };

  repeatLocked = "{ repeating = true; locked = true; }";

  # same signature as bind / bindCommand, but repeating + locked
  repeatBind = key: action: withFlags repeatLocked (bind key action);
  repeatCommand = key: action: withFlags repeatLocked (bindCommand key action);

  exec = cmd: ''hl.dsp.exec_cmd("${cmd}")'';
  focusdr = dr: ''hl.dsp.focus({ direction = "${dr}" })'';

  ddcBrightnessUp = busNumber: exec "ddcutil --bus ${toString busNumber} setvcp 10 + 1";
  ddcBrightnessDown = busNumber: exec "ddcutil --bus ${toString busNumber} setvcp 10 - 1";
}
