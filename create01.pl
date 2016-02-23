#!/usr/bin/perl
use perl5i::2;
use lib 'lib';
use SIF::REST;
use XML::Simple;
use Data::Dumper;

my $sifrest = SIF::REST->new({
	endpoint => 'http://localhost:3000',
	#endpoint => 'http://siftraining.dd.com.au/api',
});
$sifrest->setupRest();

my $ret = $sifrest->post('StudentPersonals', 'StudentPersonal', 
	q{<StudentPersonal>
		<LocalId>EXAMPLE01</LocalId>  
		<PersonInfo>     
		<Name Type="LGL">       
			<FamilyName>VITTA 2 Monday Family Name Demo 1</FamilyName>      
			<GivenName>First Name Demo 1</GivenName>       
		</Name> 
		</PersonInfo>
		<MostRecent>
			<SchoolLocalId>SchoolID</SchoolLocalId>    
			<YearLevel>YearLevel</YearLevel>  
		</MostRecent>
	</StudentPersonal>}
);

my $created = XMLin($ret, ForceArray => 0);
print "REFID = " . $created->{RefId} . "\n\n";

print "GET = " . $sifrest->get('StudentPersonals', $created->{RefId}) . "\n";

print "DELETE = " . $sifrest->delete('StudentPersonals', $created->{RefId}) .  "\n";

print "GET = " . $sifrest->get('StudentPersonals', $created->{RefId}) . "\n";
print "CODE = " . $sifrest->rest->responseCode . "\n";
