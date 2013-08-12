#!/usr/bin/perl
use perl5i::2;
use lib 'lib';
use lib '../sif-au-perl/lib';
use SIF::REST;
use XML::Simple;
use Data::Dumper;
use SIF::AU;

# PUPOSE: Create a School using Data Objects

# Create the school object
my $school = SIF::AU::SchoolInfo->new();
$school->SchoolName("Now has a new name");
print $school->LocalId . ": " . $school->SchoolName . "\n";

# SIF REST Client
my $sifrest = SIF::REST->new({
	endpoint => 'http://siftraining.dd.com.au/api',
});
$sifrest->setupRest();

# POST / CREATE
my $xml = $sifrest->post('SchoolInfos', 'SchoolInfo', $school->to_xml_string());
my $newschool = SIF::AU::SchoolInfo->from_xml($xml);
print $newschool->RefId . "\n";
