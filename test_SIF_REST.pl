#!/usr/bin/perl
use perl5i::2;
use lib 'lib';
use SIF::REST;
use XML::Simple;
use Data::Dumper;

if (0) {
	say "US ENDPOINT; US DATA STRUCTURE - Direct";
	my $sifrest = SIF::REST->new({
		endpoint => 'http://rest3api.sifassociation.org/api',
	});
	$sifrest->setupRest();
	say "HOST = " . $sifrest->rest->getHost;
	#say Dumper($sifrest->environment_data);

	my $xml = $sifrest->get('students');
	say $xml;
	my $students = XMLin($xml, ForceArray => 0);
	print join(", ", map { $_->{name}{nameOfRecord}{fullName} } @{$students->{student}}[0..10] ) . "\n";
}

if (1) {
	say "US ENDPOINT; AU DATA STRUCUTRE - Brokered";
	my $sifrest = SIF::REST->new({
		endpoint => 'http://rest3api.sifassociation.org/api',
		solutionId => 'auTestSolution',
		type => '',
	});
	$sifrest->setupRest();
	say "DONE";

	my $students = XMLin($sifrest->get('StudentPersonals'), ForceArray => 0);
	print join(", ", map { $_->{PersonInfo}{Name}{FamilyName} } @{$students->{StudentPersonal}}[0..10] ) . "\n";
}

if (0) {
	say "AU ENDPOINT; AU DATA STRUCUTRE - Direct";
	my $sifrest = SIF::REST->new({
		#endpoint => 'http://siftraining.dd.com.au/api',
		endpoint => 'http://localhost:3000',
	});
	$sifrest->setupRest();

	my $students = XMLin($sifrest->get('StudentPersonals'), ForceArray => 0);
	print join(", ", map { $_->{PersonInfo}{Name}{FamilyName} } @{$students->{StudentPersonal}}[0..10] ) . "\n";
}
