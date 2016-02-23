#!/usr/bin/perl
use perl5i::2;
use lib 'lib';
use SIF::REST;
use XML::Simple;
use Data::Dumper;

# Consumer name: nsipdev
# Solution ID: nsipdev
# Application key: nsipdev
# The shared key your application needs to use is: #;JBB!9m

my $sifrest = SIF::REST->new({
	endpoint => 'http://aslenv.acara.edu.au/api',
	consumerKey => '',
	consumerSecret => '',
	# Consumer name: nsipdev
	# Solution ID: nsipdev
	# Application key: nsipdev
});
$sifrest->setupRest();
print $sifrest->get('SchoolInfos');
