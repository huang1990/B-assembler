#!/usr/bin/perl -w
#Author: Ruan Jue

use strict;

my $name = '';
my $len  = 0;

while(<>){
	if(/^>(\S+)/){
		$name = $1;
		print "\@$name\n";
	} else {
		print;
		chomp;
		print "+$name\n";
		print 'h' x length($_);
		print "\n";
	}
}
