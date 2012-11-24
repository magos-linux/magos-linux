#!/bin/bash
PFP=usr/lib/libDrakX/ugtk2.pm
sed -i s/'->new_with_status_icon($info->{title}, $info->{message}, undef, $self->{statusicon})'/'->new($info->{title}, $info->{message}, $self->{statusicon})'/ $PFP
PFP=usr/lib/libDrakX/network/tools.pm
sed -i 's|foreach (cat_("/proc/net/route"))|my @routes = cat_("/proc/net/route");\n    require bootloader;\n    @routes = reverse(@routes) if bootloader::cmp_kernel_versions(c::kernel_version(), "2.6.39") >= 0;\n    foreach (@routes)|' $PFP

exit 0
