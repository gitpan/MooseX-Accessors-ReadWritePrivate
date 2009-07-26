#!/usr/bin/env perl

use utf8;
use 5.008004;

use strict;
use warnings;

use version; our $VERSION = qv('v1.2.1');


use Test::More tests => 120;


## no critic (Modules::ProhibitMultiplePackages)
{
    package Before::Moose;

    use MooseX::Accessors::ReadWritePrivate;
    use Moose;

    has 'public_rw'                   => (is => 'rw' );
    has '_private_rw'                 => (is => 'rw' );
    has '__distribution_private_rw'   => (is => 'rw' );

    has 'public_ro'                   => (is => 'ro' );
    has '_private_ro'                 => (is => 'ro' );
    has '__distribution_private_ro'   => (is => 'ro' );

    has 'public_rwp'                  => (is => 'rwp');
    has '_private_rwp'                => (is => 'rwp');
    has '__distribution_private_rwp'  => (is => 'rwp');

    has 'public_bare'                 => (is => 'bare');
    has '_private_bare'               => (is => 'bare');
    has '__distribution_private_bare' => (is => 'bare');
} # end Before::Moose

{
    package After::Moose;

    # Make sure load order doesn't matter.
    use Moose;
    use MooseX::Accessors::ReadWritePrivate;

    has 'public_rw'                   => (is => 'rw' );
    has '_private_rw'                 => (is => 'rw' );
    has '__distribution_private_rw'   => (is => 'rw' );

    has 'public_ro'                   => (is => 'ro' );
    has '_private_ro'                 => (is => 'ro' );
    has '__distribution_private_ro'   => (is => 'ro' );

    has 'public_rwp'                  => (is => 'rwp');
    has '_private_rwp'                => (is => 'rwp');
    has '__distribution_private_rwp'  => (is => 'rwp');

    has 'public_bare'                 => (is => 'bare');
    has '_private_bare'               => (is => 'bare');
    has '__distribution_private_bare' => (is => 'bare');
} # end After::Moose

{
    package Selector::Overrides;

    use Moose;
    use MooseX::Accessors::ReadWritePrivate;

    has 'public_rw'                  => (is => 'rw',    reader => 'public_rw'                  );
    has '_private_rw'                => (is => 'rw',    reader => '_private_rw'                );
    has '__distribution_private_rw'  => (is => 'rw',    reader => '__distribution_private_rw'  );

    has 'public_ro'                  => (is => 'ro',    reader => 'public_ro'                  );
    has '_private_ro'                => (is => 'ro',    reader => '_private_ro'                );
    has '__distribution_private_ro'  => (is => 'ro',    reader => '__distribution_private_ro'  );

    has 'public_rwp'                 => (is => 'rwp',   reader => 'public_rwp'                 );
    has '_private_rwp'               => (is => 'rwp',   reader => '_private_rwp'               );
    has '__distribution_private_rwp' => (is => 'rwp',   reader => '__distribution_private_rwp' );

    has 'public_bare'                 => (is => 'bare', reader => 'public_bare'                );
    has '_private_bare'               => (is => 'bare', reader => '_private_bare'              );
    has '__distribution_private_bare' => (is => 'bare', reader => '__distribution_private_bare');
} # end Selector::Overrides

{
    package Mutator::Overrides;

    use Moose;
    use MooseX::Accessors::ReadWritePrivate;

    has 'public_rw'                   => (is => 'rw',   writer => 'public_rw'                  );
    has '_private_rw'                 => (is => 'rw',   writer => '_private_rw'                );
    has '__distribution_private_rw'   => (is => 'rw',   writer => '__distribution_private_rw'  );

    # Of course this is stupid, but you should still be able to do it.
    has 'public_ro'                   => (is => 'ro',   writer => 'public_ro'                  );
    has '_private_ro'                 => (is => 'ro',   writer => '_private_ro'                );
    has '__distribution_private_ro'   => (is => 'ro',   writer => '__distribution_private_ro'  );

    has 'public_rwp'                  => (is => 'rwp',  writer => 'public_rwp'                 );
    has '_private_rwp'                => (is => 'rwp',  writer => '_private_rwp'               );
    has '__distribution_private_rwp'  => (is => 'rwp',  writer => '__distribution_private_rwp' );

    has 'public_bare'                 => (is => 'bare', writer => 'public_bare'                );
    has '_private_bare'               => (is => 'bare', writer => '_private_bare'              );
    has '__distribution_private_bare' => (is => 'bare', writer => '__distribution_private_bare');
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

    ok(! $package->can('get_public_bare'),                 "$package->get_public_bare() doesn't exist.");
    ok(! $package->can('_set_public_bare'),                "$package->_set_public_bare() doesn't exist.");
    ok(! $package->can('_get_private_bare'),               "$package->_get_private_bare() doesn't exist.");
    ok(! $package->can('_set_private_bare'),               "$package->_set_private_bare() doesn't exist.");
    ok(! $package->can('__get_distribution_private_bare'), "$package->__get_distribution_private_bare() doesn't exist.");
    ok(! $package->can('_set_distribution_private_bare'),  "$package->_set_distribution_private_bare() doesn't exist.");
} # end foreach


ok(  Selector::Overrides->can('public_rw'),                     q[Selector::Overrides->public_rw() exists.]                           );
ok(! Selector::Overrides->can('get_public_rw'),                 q[Selector::Overrides->get_public_rw() doesn't exist.]                );
ok(  Selector::Overrides->can('set_public_rw'),                 q[Selector::Overrides->set_public_rw() exists.]                       );
ok(  Selector::Overrides->can('_private_rw'),                   q[Selector::Overrides->_private_rw() exists.]                         );
ok(! Selector::Overrides->can('_get_private_rw'),               q[Selector::Overrides->_get_private_rw() doesn't exist.]              );
ok(  Selector::Overrides->can('_set_private_rw'),               q[Selector::Overrides->_set_private_rw() exists.]                     );
ok(  Selector::Overrides->can('__distribution_private_rw'),     q[Selector::Overrides->__distribution_private_rw() exists.]           );
ok(! Selector::Overrides->can('__get_distribution_private_rw'), q[Selector::Overrides->__get_distribution_private_rw() doesn't exist.]);
ok(  Selector::Overrides->can('__set_distribution_private_rw'), q[Selector::Overrides->__set_distribution_private_rw() exists.]       );

ok(  Selector::Overrides->can('public_ro'),                     q[Selector::Overrides->public_ro() exists.]                           );
ok(! Selector::Overrides->can('get_public_ro'),                 q[Selector::Overrides->get_public_ro() doesn't exist.]                );
ok(! Selector::Overrides->can('set_public_ro'),                 q[Selector::Overrides->set_public_ro() doesn't exist.]                );
ok(  Selector::Overrides->can('_private_ro'),                   q[Selector::Overrides->_private_ro() exists.]                         );
ok(! Selector::Overrides->can('_get_private_ro'),               q[Selector::Overrides->_get_private_ro() doesn't exist.]              );
ok(! Selector::Overrides->can('_set_private_ro'),               q[Selector::Overrides->_set_private_ro() doesn't exist.]              );
ok(  Selector::Overrides->can('__distribution_private_ro'),     q[Selector::Overrides->__distribution_private_ro() exists.]           );
ok(! Selector::Overrides->can('__get_distribution_private_ro'), q[Selector::Overrides->__get_distribution_private_ro() doesn't exist.]);
ok(! Selector::Overrides->can('__set_distribution_private_ro'), q[Selector::Overrides->__set_distribution_private_ro() doesn't exist.]);

ok(  Selector::Overrides->can('public_rwp'),                     q[Selector::Overrides->public_rwp() exists.]                           );
ok(! Selector::Overrides->can('get_public_rwp'),                 q[Selector::Overrides->get_public_rwp() doesn't exist.]                );
ok(  Selector::Overrides->can('_set_public_rwp'),                q[Selector::Overrides->_set_public_rwp() exists.]                      );
ok(  Selector::Overrides->can('_private_rwp'),                   q[Selector::Overrides->_private_rwp() exists.]                         );
ok(! Selector::Overrides->can('_get_private_rwp'),               q[Selector::Overrides->_get_private_rwp() doesn't exist.]              );
ok(  Selector::Overrides->can('_set_private_rwp'),               q[Selector::Overrides->_set_private_rwp() exists.]                     );
ok(  Selector::Overrides->can('__distribution_private_rwp'),     q[Selector::Overrides->__distribution_private_rwp() exists.]           );
ok(! Selector::Overrides->can('__get_distribution_private_rwp'), q[Selector::Overrides->__get_distribution_private_rwp() doesn't exist.]);
ok(  Selector::Overrides->can('_set_distribution_private_rwp'),  q[Selector::Overrides->_set_distribution_private_rwp() exists.]        );

ok(  Selector::Overrides->can('public_bare'),                     q[Selector::Overrides->public_bare() exists.]                           );
ok(! Selector::Overrides->can('get_public_bare'),                 q[Selector::Overrides->get_public_bare() doesn't exist.]                );
ok(! Selector::Overrides->can('set_public_bare'),                 q[Selector::Overrides->set_public_bare() doesn't exist.]                );
ok(  Selector::Overrides->can('_private_bare'),                   q[Selector::Overrides->_private_bare() exists.]                         );
ok(! Selector::Overrides->can('_get_private_bare'),               q[Selector::Overrides->_get_private_bare() doesn't exist.]              );
ok(! Selector::Overrides->can('_set_private_bare'),               q[Selector::Overrides->_set_private_bare() doesn't exist.]              );
ok(  Selector::Overrides->can('__distribution_private_bare'),     q[Selector::Overrides->__distribution_private_bare() exists.]           );
ok(! Selector::Overrides->can('__get_distribution_private_bare'), q[Selector::Overrides->__get_distribution_private_bare() doesn't exist.]);
ok(! Selector::Overrides->can('__set_distribution_private_bare'), q[Selector::Overrides->__set_distribution_private_bare() doesn't exist.]);


ok(  Mutator::Overrides->can('get_public_rw'),                 q[Mutator::Overrides->get_public_rw() exists.]                       );
ok(  Mutator::Overrides->can('public_rw'),                     q[Mutator::Overrides->public_rw() exists.]                           );
ok(! Mutator::Overrides->can('set_public_rw'),                 q[Mutator::Overrides->set_public_rw() doesn't exist.]                );
ok(  Mutator::Overrides->can('_get_private_rw'),               q[Mutator::Overrides->_get_private_rw() exists.]                     );
ok(  Mutator::Overrides->can('_private_rw'),                   q[Mutator::Overrides->_private_rw() exists.]                         );
ok(! Mutator::Overrides->can('_set_private_rw'),               q[Mutator::Overrides->_set_private_rw() doesn't exist.]              );
ok(  Mutator::Overrides->can('__get_distribution_private_rw'), q[Mutator::Overrides->__get_distribution_private_rw() exists.]       );
ok(  Mutator::Overrides->can('__distribution_private_rw'),     q[Mutator::Overrides->__distribution_private_rw() exists.]           );
ok(! Mutator::Overrides->can('__set_distribution_private_rw'), q[Mutator::Overrides->__set_distribution_private_rw() doesn't exist.]);

ok(  Mutator::Overrides->can('get_public_ro'),                 q[Mutator::Overrides->get_public_ro() exists.]                       );
ok(  Mutator::Overrides->can('public_ro'),                     q[Mutator::Overrides->public_ro() exists.]                           );
ok(! Mutator::Overrides->can('set_public_ro'),                 q[Mutator::Overrides->set_public_ro() doesn't exist.]                );
ok(  Mutator::Overrides->can('_get_private_ro'),               q[Mutator::Overrides->_get_private_ro() exists.]                     );
ok(  Mutator::Overrides->can('_private_ro'),                   q[Mutator::Overrides->_private_ro() exists.]                         );
ok(! Mutator::Overrides->can('_set_private_ro'),               q[Mutator::Overrides->_set_private_ro() doesn't exist.]              );
ok(  Mutator::Overrides->can('__get_distribution_private_ro'), q[Mutator::Overrides->__get_distribution_private_ro() exists.]       );
ok(  Mutator::Overrides->can('__distribution_private_ro'),     q[Mutator::Overrides->__distribution_private_ro() exists.]           );
ok(! Mutator::Overrides->can('__set_distribution_private_ro'), q[Mutator::Overrides->__set_distribution_private_ro() doesn't exist.]);

ok(  Mutator::Overrides->can('get_public_rwp'),                 q[Mutator::Overrides->get_public_rwp() exists.]                       );
ok(  Mutator::Overrides->can('public_rwp'),                     q[Mutator::Overrides->public_rwp() exists.]                           );
ok(! Mutator::Overrides->can('_set_public_rwp'),                q[Mutator::Overrides->_set_public_rwp() doesn't exist.]                );
ok(  Mutator::Overrides->can('_get_private_rwp'),               q[Mutator::Overrides->_get_private_rwp() exists.]                     );
ok(  Mutator::Overrides->can('_private_rwp'),                   q[Mutator::Overrides->_private_rwp() exists.]                         );
ok(! Mutator::Overrides->can('_set_private_rwp'),               q[Mutator::Overrides->_set_private_rwp() doesn't exist.]              );
ok(  Mutator::Overrides->can('__get_distribution_private_rwp'), q[Mutator::Overrides->__get_distribution_private_rwp() exists.]       );
ok(  Mutator::Overrides->can('__distribution_private_rwp'),     q[Mutator::Overrides->__distribution_private_rwp() exists.]           );
ok(! Mutator::Overrides->can('_set_distribution_private_rwp'),  q[Mutator::Overrides->_set_distribution_private_rwp() doesn't exist.]);

ok(! Mutator::Overrides->can('get_public_bare'),                 q[Mutator::Overrides->get_public_bare() doesn't exist.]                );
ok(  Mutator::Overrides->can('public_bare'),                     q[Mutator::Overrides->public_bare() exists.]                           );
ok(! Mutator::Overrides->can('_set_public_bare'),                q[Mutator::Overrides->_set_public_bare() doesn't exist.]               );
ok(! Mutator::Overrides->can('_get_private_bare'),               q[Mutator::Overrides->_get_private_bare() doesn't exist.]              );
ok(  Mutator::Overrides->can('_private_bare'),                   q[Mutator::Overrides->_private_bare() exists.]                         );
ok(! Mutator::Overrides->can('_set_private_bare'),               q[Mutator::Overrides->_set_private_bare() doesn't exist.]              );
ok(! Mutator::Overrides->can('__get_distribution_private_bare'), q[Mutator::Overrides->__get_distribution_private_bare() doesn't exist.]);
ok(  Mutator::Overrides->can('__distribution_private_bare'),     q[Mutator::Overrides->__distribution_private_bare() exists.]           );
ok(! Mutator::Overrides->can('_set_distribution_private_bare'),  q[Mutator::Overrides->_set_distribution_private_bare() doesn't exist.] );


# setup vim: set filetype=perl tabstop=4 softtabstop=4 expandtab :
# setup vim: set shiftwidth=4 shiftround textwidth=78 nowrap autoindent :
# setup vim: set foldmethod=indent foldlevel=0 :
