# --
# Kernel/Language/pt_BR_UpdateParent.pm - provides Brazilian portuguese language translation for UpdateParent package
# Copyright (C) 2016 BeOnUP, https://beonup.com.br/
# Copyright (C) 2016 Jose Junior, <contato@beonup.com.br>
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::pt_BR_UpdateParent;
use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;
    my $Lang = $Self->{Translation};
    return 0 if ref $Lang ne 'HASH';

    # $$START$$

    # Kernel/Config/Files/UpdateParent.xml
    $Lang->{'Ticket event module to send automatically notification to parent.'} = '';

    # Kernel/System/Ticket/Event/InformParentClosedChild.pm
    $Lang->{'Child ticket closed.'} = '';

    return 0;

    # $$STOP$$
}

1;
