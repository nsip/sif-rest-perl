#!/usr/bin/perl
use perl5i::2;
use lib 'lib';
use lib '../sif-au-perl/lib';
use SIF::REST;
use XML::Simple;
use Data::Dumper;
use SIF::AU;

# PUPOSE: Create a School using Data Objects

# ----------------------------------------------------------------------
# Get Existing Records
my $school_refid = "DC56C532026B11E3A5325DE06940ABA3";
my $room_refid = "EB571E74026B11E3A5325DE06940ABA3";
my $teaching_group_refid = "fake01";

# ----------------------------------------------------------------------
# A Timetable
my $TT = SIF::AU::TimeTable->new();
$TT->SchoolYear('2009');
$TT->DaysPerCycle(5);
#$TT->PeriodsPerCycle(5);
#$TT->SchoolRefId($school_refid);
$TT = _create($TT);
print "TT = " . $TT->RefId() . "\n";

# ----------------------------------------------------------------------
# TimeTableSubject
my $TTS = SIF::AU::TimeTableSubject->new();
$TTS->Faculty("Maths");
#$TTS->SchoolInfoRefId($school_refid);
$TTS->SubjectLocalId("MAT");
$TTS->SubjectShortName("Mat");
$TTS->SubjectLongName("Mathematics");
$TTS->SubjectType("mat");
$TTS = _create($TTS);
print "TTS = " . $TTS->RefId() . "\n";
print $TTS->to_xml_string();

# ----------------------------------------------------------------------
# TimeTableCell
my $TTC = SIF::AU::TimeTableCell->new();
$TTC->TimeTableRefId($TT->RefId);
$TTC->TimeTableSubjectRefId($TTS->RefId);
$TTC->RoomInfoRefId($room_refid);
$TTC->SchoolInfoRefId($school_refid);
#StaffPersonalRefId
$TTC->TeachingGroupRefId($teaching_group_refid);
$TTC->CellType('CT');
$TTC->PeriodId('PI');
$TTC->DayId('DI');
$TTC = _create($TTC);
print "TTC = " . $TTC->RefId() . "\n";

print "\n\n";
print $TTC->to_xml_string();

exit 0;

# ======================================================================
# CREATE form an Object and return the object
sub _create {
	my ($obj) = @_;
	# TODO support Multiple create
	
	my $class = ref($obj);
	my $name = $class;
	$name =~ s/^SIF::AU:://g;

	# POST / CREATE
	my $xml;
	my $ret = eval {
		$xml = _rest()->post($name . 's', $name, $obj->to_xml_string());
		return $class->from_xml($xml);
	};
	if ($@) {
		die "ERROR $@. Original XML = $xml\n";
	}
	return $ret;
}

sub _rest {
	our $sifrest;
	if (! $sifrest) {
		# SIF REST Client
		$sifrest = SIF::REST->new({
			endpoint => 'http://siftraining.dd.com.au/api',
		});
		$sifrest->setupRest();
	}
	return $sifrest;
}

