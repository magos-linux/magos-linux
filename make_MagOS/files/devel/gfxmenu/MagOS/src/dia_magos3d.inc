% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Various kernel options dialog.
%
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Some global vars.
%
/magos3d.default 0 def

/magos3d.options [
  ""
  "3ddesktop"
  "no3ddesktop"
] def


% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Build magos3d list.
%
% ( ) ==> ( )
%
/magos3d.init {
  /xmenu.magos3d .xm_size array def

  /xmenu xmenu.magos3d def

  xmenu .xm_current magos3d.default put
  xmenu .xm_list [
    /txt_3d_default
    /txt_3d_on
    /txt_3d_off
  ] put
  xmenu .xm_title /txt_3d put

} def


% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Update magos3d mode.
%
% ( ) ==> ( )
%
/magos3d.update {
  /xmenu xmenu.magos3d def

  /window.action actRedrawPanel def
} def


% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Show magos3d menu.
%
% ( ) => ( )
%
/panel.magos3d {
  "magos3d" help.setcontext

  window.xmenu
  dup .xmenu xmenu.magos3d put
  dup .xmenu.update /magos3d.update put
  dup window.init
      window.show
} def


% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Return width of panel entry.
%
% ( ) => ( width )
%
/panel.magos3d.width {
  /xmenu xmenu.magos3d def

  pmenu.width
} def


% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Redraw panel entry.
%
% ( panel ) => ( )
%
/panel.magos3d.update {
  /xmenu xmenu.magos3d def

  pmenu.panel.update
} def


