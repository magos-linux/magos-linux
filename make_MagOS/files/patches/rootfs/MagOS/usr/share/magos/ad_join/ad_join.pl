#!/usr/bin/perl -w
# MagOS-linux.ru
# Author M.Zaripov

use strict;
use Glib qw/TRUE FALSE/;
use Gtk2 '-init'; 

#standard window creation, placement, and signal connecting
my $window = Gtk2::Window->new('toplevel');
$window->signal_connect('delete_event' => sub { Gtk2->main_quit; });
$window->set_border_width(5);
$window->set_position('center_always');

#this vbox will geturn the bulk of the gui
my $vbox = &ret_vbox();

#add and show the vbox
$window->add($vbox);
$window->show();

#our main event-loop
Gtk2->main();

sub ret_vbox {
  my $vbox = Gtk2::VBox->new(FALSE,5);
  $vbox->pack_start ("Gtk2::Label"->new (" Please input password to join into domain "), 0, 0, 0);
  
  # create table with 2 entries
  my $table1 = Gtk2::Table->new (2, 2, FALSE);
  
  my $t1l1 = Gtk2::Label->new_with_mnemonic("Domain Admin User Name: ");
  $t1l1->set_alignment (0, 0);
  $table1->attach_defaults ($t1l1, 0, 1, 0, 1);
  my $t1e1 = Gtk2::Entry->new();
  $table1->attach_defaults ($t1e1, 1, 2, 0, 1);
  my $t1l2 = Gtk2::Label->new_with_mnemonic("Domain Admin Password: ");
  $t1l2->set_alignment (0, 0);
  $table1->attach_defaults ($t1l2, 0, 1, 1, 2);
  my $t1e2 = Gtk2::Entry->new();
  $t1e2->set_visibility (FALSE);
  $table1->attach_defaults ($t1e2, 1, 2, 1, 2);
  $vbox->pack_start($table1, 0, 0 ,0);

  #$vbox->pack_end(Gtk2::HSeparator->new(),0, 0 ,0);
  # create table with 2 buttons
  my $table2 = Gtk2::Table->new (1, 2, FALSE);
  my $t2b1 = Gtk2::Button->new ('Join');
  $table2->attach_defaults ($t2b1, 0, 1, 0, 1);
  my $t2b2 = Gtk2::Button->new ('Cancel');
  $table2->attach_defaults ($t2b2, 1, 2, 0, 1);
  $t2b2->signal_connect (clicked => sub { Gtk2->main_quit; });
  $t2b1->signal_connect (clicked => sub { system("net join -U \"".$t1e1->get_text().'%'.$t1e2->get_text()."\"") || exit (1); });
  $vbox->pack_start($table2, 0, 0 ,0);
  
  $vbox->show_all();

  return $vbox;
}

