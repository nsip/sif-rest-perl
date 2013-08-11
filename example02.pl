#!/usr/bin/perl
use perl5i::2;
use lib 'lib';
use SIF::REST::Parse;

my $sifrest = SIF::REST::Parse->new({
	#endpoint => 'http://siftraining.dd.com.au/api',
	endpoint => 'http://rest3api.sifassociation.org/api',
});
$sifrest->setupRest();

my $ret = $sifrest->get('students');

print join ("\n", map { 
	"$_->{RefId} = $_->{GivenName} $_->{FamilyName}" 
} @{$ret->{data}}[0..10]) . "\n";
