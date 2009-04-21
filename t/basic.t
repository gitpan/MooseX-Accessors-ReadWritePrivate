#!/usr/bin/env perl

use utf8;
use 5.008004;

use strict;
use warnings;

use version; our $VERSION = qv('v1.1.0');


use Test::More tests => 36;


## no critic (Modules::ProhibitMultiplePackages)
{
    package Before::Moose;

    use MooseX::Accessors::ReadWritePrivate;
    use Moose;

    has 'public_rw'                  => (is => 'rw' );
    has '_private_rw'                => (is => 'rw' );
    has '__distribution_private_rw'  => (is => 'rw' );

    has 'public_ro'                  => (is => 'ro' );
    has '_private_ro'                => (is => 'ro' );
    has '__distribution_private_ro'  => (is => 'ro' );

    has 'public_rwp'                 => (is => 'rwp');
    has '_private_rwp'               => (is => 'rwp');
    has '__distribution_private_rwp' => (is => 'rwp');
} # end Before::Moose

{
    package After::Moose;

    # Make sure load order doesn't matter.
    use Moose;
    use MooseX::Accessors::ReadWritePrivate;

    has 'public_rw'                  => (is => 'rw' );
    has '_private_rw'                => (is => 'rw' );
    has '__distribution_private_rw'  => (is => 'rw' );

    has 'public_ro'                  => (is => 'ro' );
    has '_private_ro'                => (is => 'ro' );
    has '__distribution_private_ro'  => (is => 'ro' );

    has 'public_rwp'                 => (is => 'rwp');
    has '_private_rwp'               => (is => 'rwp');
    has '__distribution_private_rwp' => (is => 'rwp');
} # end After::Moose

{
    package Selector::Overrides;

    use Moose;
    use MooseX::Accessors::ReadWritePrivate;

    has 'public_rw'                  => (is => 'rw',  reader => 'public_rw'                 );
    has '_private_rw'                => (is => 'rw',  reader => '_private_rw'               );
    has '__distribution_private_rw'  => (is => 'rw',  reader => '__distribution_private_rw' );

    has 'public_ro'                  => (is => 'ro',  reader => 'public_ro'                 );
    has '_private_ro'                => (is => 'ro',  reader => '_private_ro'               );
    has '__distribution_private_ro'  => (is => 'ro',  reader => '__distribution_private_ro' );

    has 'public_rwp'                 => (is => 'rwp', reader => 'public_rwp'                );
    has '_private_rwp'               => (is => 'rwp', reader => '_private_rwp'              );
    has '__distribution_private_rwp' => (is => 'rwp', reader => '__distribution_private_rwp');
} # end Selector::Overrides

{
    package Mutator::Overrides;

    use Moose;
    use MooseX::Accessors::ReadWritePrivate;

    has 'public_rw'                  => (is => 'rw',  reader => 'public_rw'                 );
    has '_private_rw'                => (is => 'rw',  reader => '_private_rw'               );
    has '__distribution_private_rw'  => (is => 'rw',  reader => '__distribution_private_rw' );

    has 'public_ro'                  => (is => 'ro',  reader => 'public_ro'                 );
    has '_private_ro'                => (is => 'ro',  reader => '_private_ro'               );
    has '__distribution_private_ro'  => (is => 'ro',  reader => '__distribution_private_ro' );

    has 'public_rwp'                 => (is => 'rwp', reader => 'public_rwp'                );
    has '_private_rwp'               => (is => 'rwp', reader => '_private_rwp'              );
    has '__distribution_private_rwp' => (is => 'rwp', reader => '__distribution_private_rwp');
} # end Mutator::Overrides


foreach my $package ( qw< Before::Moose After::Moose > ) {
    ok($package->can('get_public_rw'),                 "$package->get_public_rw() exists."                );
    ok($package->can('set_public_rw'),                 "$package->set_public_rw() exists."                );
    ok($package->can('_get_private_rw'),               "$package->_get_private_rw() exists."              );
    ok($package->can('_set_private_rw'),               "$package->_set_private_rw() exists."              );
    ok($package->can('__get_distribution_private_rw'), "$package->__get_distribution_private_rw() exists.");
    ok($package->can('__set_distribution_private_rw'), "$package->__set_distribution_private_rw() exists.");

    ok(  $package->can('get_public_ro'),                 "$package->get_public_ro() exists."                       );
    ok(! $package->can('set_public_ro'),                 "$package->set_public_ro() doesn't exist."                );
    ok(  $package->can('_get_private_ro'),               "$package->_get_private_ro() exists."                     );
    ok(! $package->can('_set_private_ro'),               "$package->_set_private_ro() doesn't exist."              );
    ok(  $package->can('__get_distribution_private_ro'), "$package->__get_distribution_private_ro() exists."       );
    ok(! $package->can('__set_distribution_private_ro'), "$package->__set_distribution_private_ro() doesn't exist.");

    ok($package->can('get_public_rwp'),                 "$package->get_public_rwp() exists."                );
    ok($package->can('_set_public_rwp'),                "$package->_set_public_rwp() exists."               );
    ok($package->can('_get_private_rwp'),               "$package->_get_private_rwp() exists."              );
    ok($package->can('_set_private_rwp'),               "$package->_set_private_rwp() exists."              );
    ok($package->can('__get_distribution_private_rwp'), "$package->__get_distribution_private_rwp() exists.");
    ok($package->can('_set_distribution_private_rwp'),  "$package->_set_distribution_private_rwp() exists." );
} # end foreach


# setup vim: set filetype=perl tabstop=4 softtabstop=4 expandtab :
# setup vim: set shiftwidth=4 shiftround textwidth=78 nowrap autoindent :
# setup vim: set foldmethod=indent foldlevel=0 :
