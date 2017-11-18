% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Various kernel options dialog.
%
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Some global vars.
%
/magosdesktop.default 0 def

/magosdesktop.options [
  ""
  "desktop=kde"
  "desktop=lxde"
  "desktop=steam"
  "desktop=none"
] def


% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Build magosdesktop list.
%
% ( ) ==> ( )
%
/magosdesktop.init {
  /xmenu.magosdesktop .xm_size array def

  /xmenu xmenu.magosdesktop def

  xmenu .xm_current magosdesktop.default put
  xmenu .xm_list [
    /txt_desktop_default
    "KDE"
    "LXDE"
    "Steam"
    /txt_desktop_console
  ] put
  xmenu .xm_title /txt_desktop put

} def


% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Update magosdesktop mode.
%
% ( ) ==> ( )
%
/magosdesktop.update {
  /xmenu xmenu.magosdesktop def

  /window.action actRedrawPanel def
} def


% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Show magosdesktop menu.
%
% ( ) => ( )
%
/panel.magosdesktop {
  "magosdesktop" help.setcontext

  window.xmenu
  dup .xmenu xmenu.magosdesktop put
  dup .xmenu.update /magosdesktop.update put
  dup window.init
      window.show
} def


% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Return width of panel entry.
%
% ( ) => ( width )
%
/panel.magosdesktop.width {
  /xmenu xmenu.magosdesktop def

  pmenu.width
} def


% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Redraw panel entry.
%
% ( panel ) => ( )
%
/panel.magosdesktop.update {
  /xmenu xmenu.magosdesktop def

  pmenu.panel.update
} def


