{ wezterm, ... }:
wezterm.overrideAttrs (old: {
  patches = (old.patches or [ ])
    ++ [ ./dont-wait-for-configure-event.patch ];
})
