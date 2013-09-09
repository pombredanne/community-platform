package DDGC::Web::Controller::Duckduckhack;

use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

sub base :Chained('/base') :PathPart('duckduckhack') :CaptureArgs(0) {
	my ( $self, $c ) = @_;
	
}

sub index :Chained('base') :PathPart('') :Args(0) {
	my ( $self, $c ) = @_;
	$c->add_bc('DuckDuckHack', '');
	my $content = $c->model('Duckduckhack')->get_docs();
}

1;

no Moose;
__PACKAGE__->meta->make_immutable;