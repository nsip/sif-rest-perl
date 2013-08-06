package SIF::REST;
use warnings;
use strict;
use HTTP::Request::Common qw(GET POST);  
use LWP::UserAgent; 
use XML::Simple;
use Mouse;
use Mouse::Util::TypeConstraints;
use Regexp::Common qw /URI/;

use base qw/REST::Client/;

=head1 NAME

SIF::REST - A low level SIF REST Client

=head1 SYNOPSIS

=head1 DESCRIPTION

=cut

# XXX NOTES
# 	- Base class = REST, get, put, post etc
# 	- Next = Environmen Create
# 	- Next = Australian specific

# URL Matching
subtype 'URL'
    => as 'Str'
    => where { /^https?:\/\/.+$/ };	# Simplified
    # => where { $RE{URI}{HTTP} };

# Required - endpoint
has endpoint => (
	is => 'ro',
	required => 1,
	isa => 'URL',
);

# Optional - Uset Agent
has ua => {
	is => 'rw',
	required => 1,
	default => sub {
		LWP::UserAgent->new();
	},
};

has sessionToken => {
	is => 'rw',
	required => 1,
	lazy => 1,
	default => sub {
		my ($self) = @_;
		return $self->environment_create();
	},
};

has sharedSecret => {
	is => 'rw',
	required => 1,
	default => 'guest',	# NOTE: Demo test environment (SIF-RS)
};

has envornmentUser => {
	is => 'rw',
	required => 1,
	default => 'new',	# NOTE: Demo test environment (SIF-RS)
};

# Create an environment
# 	- Keeping return data?
# 	- Storing sessionKey
sub environment_create {
	my ($self) = @_;
	my $create_xml = q{<environment><solutionId>testSolution</solutionId><authenticationMethod>Basic</authenticationMethod><applicationInfo><applicationKey>MIKER_TEST</applicationKey><consumerName>MIKER_CONSUMERNAME</consumerName><supportedInfrastructureVersion>3.0</supportedInfrastructureVersion><supportedDataModel>SIF-US</supportedDataModel><supportedDataModelVersion>3.0</supportedDataModelVersion><transport>REST</transport><applicationProduct><vendorName>X</vendorName><productName>X</productName><productVersion>X</productVersion></applicationProduct></applicationInfo></environment>};

	my $req = POST 
		$self->endpoint . '/environments/environment', 
		Content_Type => 'application/xml',
		Accept => 'application/xml',
		Content => $create_xml,
	;
	$req->authorization_basic($self->environmentUser, $self->sharedSecret);
	my $response = $ua->request($req);
	my $xml = $response->as_string; 

	print STDERR $response->decoded_content;
	my $ref = XMLin($response->decoded_content, ForceArray => 0);
	use Data::Dumper;
	print Dumper($ref);
	my $key = $ref->{sessionToken} . "\n";
	print STDERR "Done - $key\n";
	return $key;
}

# Basic Get - Collection,Id
sub get {
	my ($self, $object, $id) = @_;

	my $req = GET 
		$self->endpoint . '/' . $object . '/' . $id,	# TODO Safe to add '/' ?
		Content_Type => 'application/xml',
		Accept => 'application/xml',
	;
	$req->authorization_basic($self->sessionToken, $self->sharedSecret);
	$response = $ua->request($req);
	print $response->decoded_content;
	my $students = XMLin($response->decoded_content, ForceArray => 0);
	print join(", ", map { $_->{name}{nameOfRecord}{fullName} } @{$students->{student}} ) . "\n";
}

sub delete {
}

sub post {
}

sub put {
}

__PACKAGE__->meta->make_immutable();
