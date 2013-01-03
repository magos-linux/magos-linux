% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%
% Various kernel options dialog.
%
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Some global vars.
%
/magosother.default 0 def

/magosother.options [
  ""
  "copy2ram"
  "apm=off acpi=off mce=off barrier=off ide=nodma idewait=50 i8042.nomux psmouse.proto=bare irqpoll pci=nommconf nopat no3ddesktop xdriver=free noload=/modules/"
] def


% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Build magosother list.
%
% ( ) ==> ( )
%
/magosother.init {
  /xmenu.magosother .xm_size array def

  /xmenu xmenu.magosother def

  xmenu .xm_current magosother.default put
  xmenu .xm_list [
    /txt_kernel_default
    /txt_copy2ram
    /txt_kernel_safe
  ] put
  xmenu .xm_title /txt_magos_sp put

} def


% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Update magosother mode.
%
% ( ) ==> ( )
%
/magosother.update {
  /xmenu xmenu.magosother def

  /window.action actRedrawPanel def
} def


% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Show magosother menu.
%
% ( ) => ( )
%
/panel.magosother {
  "magosother" help.setcontext

  window.xmenu
  dup .xmenu xmenu.magosother put
  dup .xmenu.update /magosother.update put
  dup window.init
      window.show
} def


% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Return width of panel entry.
%
% ( ) => ( width )
%
/panel.magosother.width {
  /xmenu xmenu.magosother def

  pmenu.width
} def


% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Redraw panel entry.
%
% ( panel ) => ( )
%
/panel.magosother.update {
  /xmenu xmenu.magosother def

  pmenu.panel.update
} def


