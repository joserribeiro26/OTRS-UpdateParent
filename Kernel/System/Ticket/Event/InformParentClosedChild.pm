# Custom code contato@beonup.com.br ( Jose Junior )
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
    my %GetParam;

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

    # get ticket object
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

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

     my $LinkObject = $Kernel::OM->Get('Kernel::System::LinkObject');
     my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
	 
	 
	  
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
             # change the subject of note send to parent
             my $ParentTicketNumber = $TicketObject->TicketNumberLookup(
                TicketID => $TicketID,
                UserID   =>  1,
             );
             $GetParam{Subject} = "Tarefa filho encerrada ID $Param{Data}{TicketID}";
       
             # create articke for a parent
             $ParentArticleID = $TicketObject->ArticleCreate(
                TicketID                        => $TicketID,
                SenderType                      => 'agent',
	        ArticleTypeID 			=> 1,
		Body				=> "Uma atividade desse chamado foi encerrada, por favor verifique",
                From                            => 'root@localhost',
		ContentType     		=> 'text/plain; charset=ISO-8859-15',      # or optional Charset & MimeType
                UserID                          => 1,
                HistoryType                     => "StateUpdate",
                HistoryComment                  => "chamado filho encerrado", 
                %GetParam,
             );
             
             if ( !$ParentArticleID ) {
                return $LayoutObject->ErrorScreen();
             }
          }      
	}
    return 1;
}
1;
