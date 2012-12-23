% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Various kernel options dialog.
%
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Some global vars.
%
/magoscopy2ram.default 0 def

/magoscopy2ram.options [
  ""
  "copy2ram"
] def


% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Build magoscopy2ram list.
%
% ( ) ==> ( )
%
/magoscopy2ram.init {
  /xmenu.magoscopy2ram .xm_size array def

  /xmenu xmenu.magoscopy2ram def

  xmenu .xm_current magoscopy2ram.default put
  xmenu .xm_list [
    /txt_copy2ram_default
    /txt_copy2ram_on
  ] put
  xmenu .xm_title /txt_copy2ram put

} def


% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Update magoscopy2ram mode.
%
% ( ) ==> ( )
%
/magoscopy2ram.update {
  /xmenu xmenu.magoscopy2ram def

  /window.action actRedrawPanel def
} def


% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Show magoscopy2ram menu.
%
% ( ) => ( )
%
/panel.magoscopy2ram {
  "magoscopy2ram" help.setcontext

  window.xmenu
  dup .xmenu xmenu.magoscopy2ram put
  dup .xmenu.update /magoscopy2ram.update put
  dup window.init
      window.show
} def


% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Return width of panel entry.
%
% ( ) => ( width )
%
/panel.magoscopy2ram.width {
  /xmenu xmenu.magoscopy2ram def

  pmenu.width
} def


% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Redraw panel entry.
%
% ( panel ) => ( )
%
/panel.magoscopy2ram.update {
  /xmenu xmenu.magoscopy2ram def

  pmenu.panel.update
} def


