#!/usr/bin/perl
use perl5i::2;
use lib 'lib';
use SIF::REST;
use XML::Simple;
use Data::Dumper;

my $sifrest = SIF::REST->new({
	#endpoint => 'http://rest3api.sifassociation.org/api',
	endpoint => 'http://siftraining.dd.com.au/api',
});
$sifrest->setupRest();
print $sifrest->get('SchoolInfos', 'DC56C532026B11E3A5325DE06940ABA3');
__END__
my $students = XMLin($sifrest->get('students'), ForceArray => 0);
print join(", ", map { $_->{name}{nameOfRecord}{fullName} } @{$students->{student}}[0..10] ) . "\n";
