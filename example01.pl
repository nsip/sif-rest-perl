#!/usr/bin/perl
use perl5i::2;
use lib 'lib';
use SIF::REST;
use XML::Simple;
use Data::Dumper;

my $sifrest = SIF::REST->new({
	endpoint => 'http://rest3api.sifassociation.org/api',
});
$sifrest->setupRest();
my $students = XMLin($sifrest->get('students'), ForceArray => 0);
print join(", ", map { $_->{name}{nameOfRecord}{fullName} } @{$students->{student}}[0..10] ) . "\n";
