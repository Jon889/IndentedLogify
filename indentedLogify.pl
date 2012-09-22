#!/usr/bin/env perl
# indentedLogify.pl
############
##THIS IS A COPY OF logify.pl (https://github.com/DHowett/theos/blob/master/bin/logify.pl). The only difference is the modification of logLineForDeclaration to produce indented logs and must be used with IndentedLogify.h/m. So this script is all DHowett's work
####
# Converts an Objective-C header file (or anything containing a @interface and method definitions)
#+into a Logos input file which causes all function calls to be logged.
#
# Accepts input on stdin or via filename specified on the commandline.

# Lines are only processed if we were in an @interface, so you can run this on a file containing
# an @implementation, as well.
use strict;

use FindBin;
use lib "$FindBin::Bin/lib";

use Logos::Method;
use Logos::Util;
$Logos::Util::errorhandler = sub {
	die "$ARGV:$.: error: missing closing parenthesis$/"
};

my $interface = 0;
while(my $line = <>) {
	if($line =~ m/^[+-]\s*\((.*?)\).*?(?=;)/ && $interface == 1) {
		print logLineForDeclaration($&);
	} elsif($line =~ m/^\s*\@property\s*\((.*?)\)\s*(.*?)\b([\$a-zA-Z_][\$_a-zA-Z0-9]*)(?=;)/ && $interface == 1) {
		my @attributes = smartSplit(qr/\s*,\s*/, $1);
		my $propertyName = $3;
		my $type = $2;
		my $readonly = scalar(grep(/readonly/, @attributes));
		my %methods = ("setter" => "set".ucfirst($propertyName).":", "getter" => $propertyName);
		foreach my $attribute (@attributes) {
			next if($attribute !~ /=/);
			my @x = smartSplit(qr/\s*=\s*/, $attribute);
			$methods{$x[0]} = $x[1];
		}
		if($readonly == 0) {
			print logLineForDeclaration("- (void)".$methods{"setter"}."($type)$propertyName");
		}
		print logLineForDeclaration("- ($type)".$methods{"getter"});
	} elsif($line =~ m/^\@interface\s+(.*?)\s*[:(]/ && $interface == 0) {
		print "%hook $1\n";
		$interface = 1;
	} elsif($line =~ m/^\@end/ && $interface == 1) {
		print "%end\n";
		$interface = 0;
	}
}

sub logLineForDeclaration {
	my $declaration = shift;
	$declaration =~ m/^[+-]\s*\((.*?)\).*?/;
	my $rtype = $1;
	my $innards = "INCR_INDENTLEVEL; IndentedLog; ";
	if($rtype ne "void") {
		$innards .= "$rtype r = %orig; ";
        $innards .= "DECR_INDENTLEVEL; ";
		$innards .= "return r; ";
	} else {
		$innards .= "%orig; DECR_INDENTLEVEL; ";
	}
	return "$declaration { $innards}\n";
}
