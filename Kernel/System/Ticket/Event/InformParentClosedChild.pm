# --
# Copyright (C) 2016 BeOnUP, https://beonup.com.br/
# Copyright (C) 2016 Jose Junior, <contato@beonup.com.br>
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Ticket::Event::InformParentClosedChild;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::System::Log',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::Ticket',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Argument (qw(Event Config)) {
        if ( !$Param{$Argument} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Argument!",
            );

            return;
        }
    }

    if ( !$Param{Data}->{TicketID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need TicketID!",
        );

        return;
    }

    return 1 if $Param{Event} eq 'HistoryAdd';

    # get needed objects
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
    my $LinkObject   = $Kernel::OM->Get('Kernel::System::LinkObject');
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # get config options
    my $TicketHook        = $ConfigObject->Get('Ticket::Hook');
    my $TicketHookDivider = $ConfigObject->Get('Ticket::HookDivider');

    # get ticket data
    my %Ticket = $TicketObject->TicketGet(
        TicketID => $Param{Data}{TicketID},
    );

    return 1 if $Ticket{StateType} ne 'closed';

    if ( $Param{Event} eq 'ArticleCreate' ) {

        my @ArticleIndex = $TicketObject->ArticleIndex(
            TicketID => $Param{Data}{TicketID},
        );

        return 1 if scalar @ArticleIndex != 1;
    }

    # send request
    my %LinkList = $LinkObject->LinkKeyListWithData(
        Object1   => 'Ticket',
        Key1      => $Param{Data}{TicketID},
        Object2   => 'Ticket',
        Type      => 'ParentChild',
        Direction => 'Source',
        State     => 'Valid',
        UserID    => 1,
    );

    # push article of child to parents
    if (%LinkList) {
        my $ParentArticleID = '';
        for my $TicketID ( keys %LinkList ) {
            my $ParentTicketNumber = $TicketObject->TicketNumberLookup(
                TicketID => $TicketID,
                UserID   => 1,
            );

            # create article for the parent
            $ParentArticleID = $TicketObject->ArticleCreate(
                TicketID       => $TicketID,
                SenderType     => 'system',
                ArticleTypeID  => 11,   # note-report
                Subject        => "Child ticket closed: $TicketHook$TicketHookDivider$Ticket{TicketNumber}",
                Body           => 'A child ticket has been closed, please check it.',
                From           => 'root@localhost',
                ContentType    => 'text/plain; charset=UTF-8',
                UserID         => 1,
                HistoryType    => 'ChildClose',
                HistoryComment => 'Child ticket closed.',
             );
             
             if ( !$ParentArticleID ) {
                 return $LayoutObject->ErrorScreen();
             }
         }
    }
    return 1;
}
1;
