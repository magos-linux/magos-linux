% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Various kernel options dialog.
%
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Some global vars.
%
/magosvideo.default 0 def

/magosvideo.options [
  ""
  "vga=0"
  "vga=788"
  "vga=791"
  "vga=894"
  "vga=ask"
] def


% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Build magosvideo list.
%
% ( ) ==> ( )
%
/magosvideo.init {
  /xmenu.magosvideo .xm_size array def

  /xmenu xmenu.magosvideo def

  xmenu .xm_current magosvideo.default put
  xmenu .xm_list [
    /txt_mvideo_default
    /txt_mvideo_none
    "800x600"
    "1024x768"
    "1366x768"
    /txt_mvideo_ask
  ] put
  xmenu .xm_title /txt_mvideo_mode put

} def


% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Update magosvideo mode.
%
% ( ) ==> ( )
%
/magosvideo.update {
  /xmenu xmenu.magosvideo def

  /window.action actRedrawPanel def
} def


% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Show magosvideo menu.
%
% ( ) => ( )
%
/panel.magosvideo {
  "magosvideo" help.setcontext

  window.xmenu
  dup .xmenu xmenu.magosvideo put
  dup .xmenu.update /magosvideo.update put
  dup window.init
      window.show
} def


% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Return width of panel entry.
%
% ( ) => ( width )
%
/panel.magosvideo.width {
  /xmenu xmenu.magosvideo def

  pmenu.width
} def


% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Redraw panel entry.
%
% ( panel ) => ( )
%
/panel.magosvideo.update {
  /xmenu xmenu.magosvideo def

  pmenu.panel.update
} def


