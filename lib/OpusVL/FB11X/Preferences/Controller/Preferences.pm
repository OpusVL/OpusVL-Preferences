package OpusVL::FB11X::Preferences::Controller::Preferences;

use Moose;
use namespace::autoclean;
BEGIN { extends 'Catalyst::Controller::HTML::FormFu'; };
with 'OpusVL::FB11::RolesFor::Controller::UI',
    'OpusVL::FB11::FormFu::RoleFor::Controller',
    'OpusVL::FB11X::TokenProcessor::Admin::Role::ControllerMenuTranslate',
    'OpusVL::FB11X::Preferences::Role::PreferencesController';

has resultset => (is => 'ro', isa => 'Str', default => 'User');

__PACKAGE__->config
(
    fb11_name                 => 'Admin',
    # As far as I can tell this is only needed by deprecated stuff
    # coughformfucough so we don't have to be accurate about it
    fb11_myclass              => 'OpusVL::FB11X::Preferences',
    fb11_method_group         => 'Users',
    fb11_method_group_order   => 2,
    fb11_shared_module        => 'Admin',
);

sub auto
    : Action
{
    my ($self, $c) =@_;
    my $index_url = $c->uri_for($self->action_for('index'));
    $c->stash->{index_url} = $index_url;
    $self->add_breadcrumb($c, { name => 'Parameters', url => $index_url });
}

sub index
    : Path
    : Args(0)
    : NavigationName('User Parameters')
    : FB11Feature('User Parameters')
{
    my ($self, $c) = @_;
    $self->index_preferences($c);
}

sub add
    : Local
    : Args(0)
    : FB11Feature('User Parameters')
    : FB11Form('preferences/preferences/add.yml')
{
    my ($self, $c) = @_;

    $self->add_prefences($c);
}

sub preference_chain
    : Chained('/')
    : CaptureArgs(1)
    : FB11Feature('User Parameters')
    : PathPart('users/preferences')
{
    my ($self, $c, $id) = @_;
    $self->do_preference_chain($c, $id);
}

sub edit
    : Chained('preference_chain')
    : Args(0)
    : FB11Feature('User Parameters')
    : FB11Form('modules/preferences/add.yml')
    : PathPart('edit')
{
    my ($self, $c) = @_;
    $self->edit_prefences($c);
}

sub values
    : Chained('preference_chain')
    : Args(0)
    : FB11Feature('User Parameters')
    : FB11Form('modules/preferences/values.yml')
    : PathPart('values')
{
    my ($self, $c) = @_;
    $self->prefence_values($c);
}

1;


=head1 NAME

OpusVL::FB11X::TokenProcessor::Admin::Controller::Users::Preferences

=head1 DESCRIPTION

=head1 METHODS

=head2 auto

=head2 index

=head2 add

=head2 preference_chain

=head2 edit

=head2 values

=head1 ATTRIBUTES

=head2 resultset


=head1 LICENSE AND COPYRIGHT

Copyright 2012 OpusVL.

This software is licensed according to the "IP Assignment Schedule" provided with the development project.

=cut