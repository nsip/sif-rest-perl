package SIF::REST::Parse;

=head1 NAME

SIF::REST::Parse - Make use of SIF::XML::Parse to automatically parse REST requests

=head1 SYNOPSIS

	use SIF::REST::Parse;

	# Setup end point, including automatic environment create
	my $sifrest = SIF::REST::Parse->new({
		endpoint => 'http://rest3api.sifassociation.org/api',
	});
	$sifrest->setupRest();

	# Get students
	my $ret = $sifrest->get('students');

	# Print first 10 students
	print join ("\n", map { "$_->{RefId} = $_->{GivenName} $_->{FamilyName}" } @{$ret->{data}}[0..10]) . "\n";

=head1 DESCRIPTION

TODO

=cut

use warnings;
use strict;
use Mouse;
use SIF::XML::Parse;

extends 'SIF::REST';

sub get {
	my ($self, $object, $id) = @_;
	my $xml = $self->SUPER::get($object, $id);
	return SIF::XML::Parse->parse($xml);
}

sub delete {
	my ($self, $object, $id) = @_;
	my $xml = $self->SUPER::delete($object, $id);
	return SIF::XML::Parse->parse($xml);
}

sub post {
	my ($self, $object, $id, $data) = @_;
	my $xml = $self->SUPER::get($object, $id, $data);
	return SIF::XML::Parse->parse($xml);
}

sub put {
	my ($self, $object, $id, $data) = @_;
	my $xml = $self->SUPER::get($object, $id, $data);
	return SIF::XML::Parse->parse($xml);
}

__PACKAGE__->meta->make_immutable();
