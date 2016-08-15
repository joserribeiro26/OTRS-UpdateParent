# --
# Kernel/Language/hu_UpdateParent.pm - provides Hungarian language translation for UpdateParent package
# Copyright (C) 2016 BeOnUP, https://beonup.com.br/
# Copyright (C) 2016 Balázs Úr, http://www.otrs-megoldasok.hu
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::hu_UpdateParent;
use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;
    my $Lang = $Self->{Translation};
    return 0 if ref $Lang ne 'HASH';

    # $$START$$

    # Kernel/Config/Files/UpdateParent.xml
    $Lang->{'Ticket event module to send automatically notification to parent.'} = 'Jegyesemény modul automatikus értesítés küldéséhez a szülő részére.';

    # Kernel/System/Ticket/Event/InformParentClosedChild.pm
    $Lang->{'Child ticket closed.'} = 'Gyermekjegy lezárva.';

    return 0;

    # $$STOP$$
}

1;
