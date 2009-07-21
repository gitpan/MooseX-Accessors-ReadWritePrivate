package MooseX::Accessors::ReadWritePrivate::Role::Attribute;

use 5.008;
use utf8;

use strict;
use warnings;


use version; our $VERSION = qv('v1.2.0');


use Moose::Role;


my %SIGNIFICANT_IS_VALUES = map { $_ => 1 } qw< ro rw rwp >;


before _process_options => sub {
    my ($class, $name, $options) = @_;

    if (
            exists $options->{is}
        and exists $SIGNIFICANT_IS_VALUES{ $options->{is} }
        and not ( exists $options->{reader} and exists $options->{writer} )
    ) {
        if ($name =~ m< \A ( _* ) ( [^_] .* )? \z >xms) {
            my ($scope, $base) = ($1, $2);

            if ( not exists $options->{reader} ) {
                my $type = $options->{isa};
                my $prefix;
                if ( $type and ($type eq 'Bool' or $type eq 'Maybe[Bool]') ) {
                    $prefix = q<>;
                } else {
                    $prefix = 'get_';
                } # end if

                $options->{reader} = "$scope$prefix$base";
            } # end if

            if ( not exists $options->{writer} ) {
                my $is = $options->{is};
                if ($is eq 'rw') {
                    $options->{writer} = "${scope}set_$base";
                } elsif ($is eq 'rwp') {
                    $options->{writer} = "_set_$base";
                } # end if
            } # end if

            delete $options->{is};
        } # end if
    } # end if

    return;
}; # end before _process_options()


no Moose::Role;

1;

__END__

=pod

=encoding utf8

=for stopwords

=head1 NAME

MooseX::Accessors::ReadWritePrivate::Role::Attribute - Names (non Bool) accessors affordance style.


=head1 SYNOPSIS

    Moose::Util::MetaRole::apply_metaclass_roles
        (
            for_class                 => $p{for_class},
            attribute_metaclass_roles =>
                ['MooseX::Accessors::ReadWritePrivate::Role::Attribute'],
        );


=head1 VERSION

This document describes MooseX::Accessors::ReadWritePrivate::Role::Attribute
version 1.2.0.


=head1 DESCRIPTION

This role applies a method modifier to the C<_process_options()>
method, and tweaks the reader and writer parameters so that they
end up with affordance names, unless they are C<Bool>s, in which case the
names are semi-affordance.


=head1 DIAGNOSTICS

None.


=head1 CONFIGURATION AND ENVIRONMENT

None other than what you specify for your attributes.


=head1 DEPENDENCIES

perl 5.8

L<Moose::Role>

L<version>


=head1 AUTHOR

Elliot Shank C<< <perl@galumph.com> >>


=head1 LICENSE AND COPYRIGHT

Copyright ©2009, Elliot Shank C<< <perl@galumph.com> >>.

Based upon L<MooseX::FollowPBP>, copyright ©2008 Dave Rolsky.

This module is free software; you can redistribute it and/or modify it under
the same terms as Perl itself. See L<perlartistic>.


=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY FOR THE
SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN OTHERWISE
STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES PROVIDE THE
SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED,
INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
FITNESS FOR A PARTICULAR PURPOSE. THE ENTIRE RISK AS TO THE QUALITY AND
PERFORMANCE OF THE SOFTWARE IS WITH YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE,
YOU ASSUME THE COST OF ALL NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING WILL ANY
COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR REDISTRIBUTE THE
SOFTWARE AS PERMITTED BY THE ABOVE LICENSE, BE LIABLE TO YOU FOR DAMAGES,
INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING
OUT OF THE USE OR INABILITY TO USE THE SOFTWARE (INCLUDING BUT NOT LIMITED TO
LOSS OF DATA OR DATA BEING RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR
THIRD PARTIES OR A FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER
SOFTWARE), EVEN IF SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE
POSSIBILITY OF SUCH DAMAGES.

=cut


# setup vim: set filetype=perl tabstop=4 softtabstop=4 expandtab :
# setup vim: set shiftwidth=4 shiftround textwidth=78 autoindent :
# setup vim: set foldmethod=indent foldlevel=0 :
