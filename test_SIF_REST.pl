#!/usr/bin/perl
use perl5i::2;
use lib 'lib';
use SIF::REST;
use XML::Simple;
use Data::Dumper;

{
	say "US ENDPOINT; US DATA STRUCTURE - Direct";
	my $sifrest = SIF::REST->new({
		endpoint => 'http://rest3api.sifassociation.org/api',
	});
	$sifrest->setupRest();
	#say Dumper($sifrest->environment_data);

	my $students = XMLin($sifrest->get('students'), ForceArray => 0);
	print join(", ", map { $_->{name}{nameOfRecord}{fullName} } @{$students->{student}}[0..10] ) . "\n";
}

{
	say "US ENDPOINT; AU DATA STRUCUTRE - Brokered";
	my $sifrest = SIF::REST->new({
		endpoint => 'http://rest3api.sifassociation.org/api',
		solutionId => 'auTestSolution',
	});

	$sifrest->setupRest();

	my $students = XMLin($sifrest->get('StudentPersonals'), ForceArray => 0);
	print join(", ", map { $_->{PersonInfo}{Name}{FamilyName} } @{$students->{StudentPersonal}}[0..10] ) . "\n";
}

{
	say "AU ENDPOINT; AU DATA STRUCUTRE - Direct";
	my $sifrest = SIF::REST->new({
		#endpoint => 'http://siftraining.dd.com.au/api',
		endpoint => 'http://localhost:3000',
	});
	$sifrest->setupRest();

	my $students = XMLin($sifrest->get('StudentPersonals'), ForceArray => 0);
	print join(", ", map { $_->{PersonInfo}{Name}{FamilyName} } @{$students->{StudentPersonal}}[0..10] ) . "\n";
}
