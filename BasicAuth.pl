#!/usr/bin/perl
use HTTP::Request::Common qw(GET POST);  
use LWP::UserAgent; 
my $ua = LWP::UserAgent->new();  

my $create_xml = q{<environment><solutionId>testSolution</solutionId><authenticationMethod>Basic</authenticationMethod><applicationInfo><applicationKey>MIKER_TEST</applicationKey><consumerName>MIKER_CONSUMERNAME</consumerName><supportedInfrastructureVersion>3.0</supportedInfrastructureVersion><supportedDataModel>SIF-US</supportedDataModel><supportedDataModelVersion>3.0</supportedDataModelVersion><transport>REST</transport><applicationProduct><vendorName>X</vendorName><productName>X</productName><productVersion>X</productVersion></applicationProduct></applicationInfo></environment>};

my $req = POST 
	'http://rest3api.sifassociation.org/api/environments/environment', 
	Content_Type => 'application/xml',
	Accept => 'application/xml',
	Content => $create_xml,
;
$req->authorization_basic('new', 'guest');
my $response = $ua->request($req);
print $response->as_string; 
