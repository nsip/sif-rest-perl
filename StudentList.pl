#!/usr/bin/perl
use HTTP::Request::Common qw(GET POST);  
use LWP::UserAgent; 
use XML::Simple; # qw(:strict);
my $ua = LWP::UserAgent->new();  

# ------------------------------------------------------------------------------
# AUTHENTICATION
# ------------------------------------------------------------------------------
my $create_xml = q{<environment><solutionId>testSolution</solutionId><authenticationMethod>Basic</authenticationMethod><applicationInfo><applicationKey>PERL</applicationKey><consumerName>PERL</consumerName><supportedInfrastructureVersion>3.0</supportedInfrastructureVersion><supportedDataModel>SIF-US</supportedDataModel><supportedDataModelVersion>3.0</supportedDataModelVersion><transport>REST</transport><applicationProduct><vendorName>X</vendorName><productName>X</productName><productVersion>X</productVersion></applicationProduct></applicationInfo></environment>};

my $req = POST 
	'http://rest3api.sifassociation.org/api/environments/environment', 
	Content_Type => 'application/xml',
	Accept => 'application/xml',
	Content => $create_xml,
;
print STDERR "Logging in\n";
$req->authorization_basic('new', 'guest');
my $response = $ua->request($req);
print STDERR $response->decoded_content;
my $ref = XMLin($response->decoded_content, ForceArray => 0);
use Data::Dumper;
print Dumper($ref);
my $key = $ref->{sessionToken} . "\n";
print STDERR "Done - $key\n";

# ------------------------------------------------------------------------------
# STUDENT LIST
# ------------------------------------------------------------------------------
$req = GET 
	'http://rest3api.sifassociation.org/api/students',
	Content_Type => 'application/xml',
	Accept => 'application/xml',
;
$req->authorization_basic($key, 'guest');
$response = $ua->request($req);
print $response->decoded_content;
my $students = XMLin($response->decoded_content, ForceArray => 0);
print join(", ", map { $_->{name}{nameOfRecord}{fullName} } @{$students->{student}} ) . "\n";
