#!/usr/bin/perl
use perl5i::2;
use lib 'lib';
use lib '../sif-au-perl/lib';
use SIF::REST;
use XML::Simple;
use Data::Dumper;
use SIF::AU;

# PUPOSE: Create a School using Data Objects

# SIF REST Client
my $sifrest = SIF::REST->new({
	endpoint => 'http://siftraining.dd.com.au/api',
});
$sifrest->setupRest();

# A Timetable
my $TT = SIF::AU::TimeTable->new();
$TT->SchoolYear('2009');
$TT->DaysPerCycle(5);
#$TT->PeriodsPerCycle(5);
$TT = _create($TT);
print $TT->RefId() . "\n";

# Create the school object
my $TTC = SIF::AU::TimeTableCell->new();
$TTC->TimeTableRefId($TT->RefId);
#$TT->TimeTableSubjectRefId($XXX);
#$TT->TeachingGroupRefId($XXX);
$TTC->RoomInfoRefId('EB571E74026B11E3A5325DE06940ABA3');
#RoomInfoRefId
#SchoolInfoRefId
#StaffPersonalRefId
#TeachingGroupRefId
#TimeTableRefId
#TimeTableSubjectRefId
$TTC->CellType('CT');
$TTC->PeriodId('PI');
$TTC->DayId('DI');
print $TTC->to_xml_string();

exit 0;

# CREATE form an Object and return the object
sub _create {
	my ($obj) = @_;

	# TODO support Multiple create
	
	my $class = ref($obj);
	my $name = $class;
	$name =~ s/^SIF::AU:://g;

	# POST / CREATE
	my $xml = $sifrest->post($name . 's', $name, $obj->to_xml_string());
	return $class->from_xml($xml);
}
