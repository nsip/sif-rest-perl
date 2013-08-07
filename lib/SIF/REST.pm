package SIF::REST;
use warnings;
use strict;
use XML::Simple;
use Mouse;
use Mouse::Util::TypeConstraints;
use REST::Client;
use MIME::Base64;

=head1 NAME

SIF::REST - A low level SIF REST Client

=head1 SYNOPSIS

=head1 DESCRIPTION

=cut

# URL Matching
subtype 'URL'
    => as 'Str'
    => where { /^https?:\/\/.+$/ };	# Simplified
    # => where { $RE{URI}{HTTP} };

# Required - endpoint
has endpoint => (
	is => 'rw',
	required => 1,
	isa => 'URL',
);

# Optional - Uset Agent
has rest => (
	is => 'rw',
	required => 1,
	lazy => 1,
	default => sub {
		my ($self) = @_;
		my $client = REST::Client->new();
		$client->setHost($self->endpoint);
		$client->addHeader(Content_Type => 'application/xml');
		$client->addHeader(Accept => 'application/xml');
		return $client;
	},
);

# sessionToken - created as required, or can also be provided
has sessionToken => (
	is => 'rw',
	required => 1,
	lazy => 1,
	default => sub {
		my ($self) = @_;
		my $key = $self->environment_create();
		die "Invalid session key created $key" unless ($key =~ /.+/);
		return $key;
	},
);

# consumerSecret - used to generate envionment and on created session
has consumerSecret => (
	is => 'rw',
	required => 1,
	default => 'guest',	# NOTE: Demo test environment (SIF-RS)
);

# consumerKey - Used only during creation of environment
has consumerKey => (
	is => 'rw',
	required => 1,
	default => 'new',	# NOTE: Demo test environment (SIF-RS)
);

has solutionId => (
	is => 'rw',
	required => 1,
	default => 'testSolution',
);

# environment_xml_send - generated or provided XML to generate a new environment
has environment_xml_send => (
	is => 'rw',
	required => 1,
	lazy => 1,
	default => sub {
		my ($self) = @_;
		# TODO - what about setting better actual data?
		return qq{<environment><solutionId>} . $self->solutionId . qq{</solutionId><authenticationMethod>Basic</authenticationMethod><consumerName>Perl</consumerName><applicationInfo><applicationKey>PERL</applicationKey><supportedInfrastructureVersion>3.0</supportedInfrastructureVersion><supportedDataModel>SIF-US</supportedDataModel><supportedDataModelVersion>3.0</supportedDataModelVersion><transport>REST</transport><applicationProduct><vendorName>X</vendorName><productName>X</productName><productVersion>X</productVersion></applicationProduct></applicationInfo></environment>};
	},
);

# Kept in case we need to review results later
has environment_xml_receive => (
	is => 'rw',
);
has environment_data => (
	is => 'rw',
);

# Create an environment
# 	- Keeping return data?
# 	- Storing sessionKey
sub environment_create {
	my ($self) = @_;

	$self->rest->POST(
		'environments/environment', 
		$self->environment_xml_send,
		{
			'Authorization' => 'Basic '. encode_base64($self->consumerKey . ':' . $self->consumerSecret),
		}
	);

	#say $client->responseContent();
	$self->environment_xml_receive($self->rest->responseContent());
	$self->environment_data($self->xml2data($self->environment_xml_receive));
	return $self->environment_data->{sessionToken};
}

# NOTE: Simplified XML convert - see SIF::AU::XML instead !
sub xml2data {
	my ($self, $in) = @_;
	return XMLin($in, ForceArray => 0);
}

sub setupRest {
	my ($self) = @_;
	$self->rest->addHeader('Authorization', 'Basic '.  encode_base64($self->sessionToken . ':' . $self->consumerSecret));

	# XXX proper way here is to re-request environment data if not already known
	# XXX e.g. if a user includes a sessionToken, then how do I get requestsConnector ? from Environments
	# XXX But then I need an environment ID saved as well...
	my $host = $self->environment_data->{infrastructureServices}{infrastructureService}{requestsConnector}{content};
	die "Invalid hostname / endpoint = $host" unless ($host =~ /^https?:\/\/.+$/);
	$self->rest->setHost($host);
}

# Basic Get - Collection,Id
sub get {
	my ($self, $object, $id) = @_;

	$self->rest->GET($object . ($id ? '/' . $id : ''));
	return $self->rest->responseContent();
}

sub delete {
	my ($self, $object, $id) = @_;
	$self->rest->DELETE($object . '/' . $id);
	return $self->rest->responseContent();
}

sub post {
	my ($self, $object, $id, $data) = @_;
	$self->rest->POST($object . ($id ? '/' . $id : ''), $data);
	return $self->rest->responseContent();
}

sub put {
	my ($self, $object, $id, $data) = @_;
	$self->rest->POST($object . ($id ? '/' . $id : ''), $data);
	return $self->rest->responseContent();
}

__PACKAGE__->meta->make_immutable();
