package OpusVL::Preferences::Hat::preferences;

use v5.24;
use Moose;
with "OpusVL::FB11::Role::Hat";

# ABSTRACT: Allows any FB11 component to do legacy Preferences stuff

has classes_with_preferences => (
    is => 'rw',
    traits => ['Array'],
    isa => 'ArrayRef',
    handles => {
        add_pref_class => 'push',
        find_pref_class => 'first',
    }
);

sub schema { shift->__brain }

sub register_extension {
    my $self = shift;
    my %namespaces = @_;

    my $classes = delete $namespaces{preferences_sources};

    $self->add_pref_class(@$classes);
    $self->schema->load_namespaces(%namespaces);
}

sub class_has_preferences {
    my $self = shift;
    my $class = shift;

    return $self->find_pref_class( sub { $_ eq $class } );
}

1;

=head1 DESCRIPTION

This Hat doesn't have an interface because it is entirely specific to this
module.

Anything using this hat is already tightly coupled to the Preferences module
and deserves everything it gets.

It exists so that those components can still actualy get at this component via
the component manager - the only level of decoupling we expect to achieve.

=head2 DEPRECATED

This module was written deprecated. New code should not be using it. New code
should make the JSON-based L<OpusVL::FB11::Parameters> module work instead, and
then use that.

=head1 METHODS

=head2 schema

The Preferences schema is the brain. The dbic_schema::is_brain hat is also worn.

=head2 register_extension

Pass a hashref a la L<DBIx::Class::Schema/load_namespaces> and it will be loaded
in.

This should only be done at Catalyst time so that we don't produce migrations
for other schemata.
