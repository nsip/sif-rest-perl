#!/usr/bin/perl
use perl5i::2; no warnings;
use lib 'lib'; use lib '../sif-au-perl/lib';
use SIF::REST;
use XML::Simple;
use Data::Dumper;
use SIF::AU;

# ----------------------------------------------------------------------
# Create the school object
my $school = SIF::AU::SchoolInfo->new();
$school->SchoolName("SIF IDEA 3");
$school->LocalId('IDEA3');
print $school->RefId . ": " . $school->SchoolName . "\n";


# ----------------------------------------------------------------------
# SIF REST Client
my $sifrest = SIF::REST->new({
	endpoint => 'http://siftraining.dd.com.au/api',
});
$sifrest->setupRest();


# ----------------------------------------------------------------------
# POST / CREATE
my $newschool = SIF::AU::SchoolInfo->from_xml($sifrest->post('SchoolInfos', 'SchoolInfo', $school->to_xml_string()));
print $newschool->RefId . ": " . $newschool->SchoolName . "\n";


