use strict;
use 5.10.0;

$/ = "";

while(<>){
	if (/section.*Abstract/ .. /pagebreak/){
		next if/^\\/;
		s/\n/ /g;
		s/\$//g;
		s/\s*\\\w+\{[^}]*}//;
		s/\\//g;
		s/RR/R/g;
		s/``/“/g;
		s/''/”/g;
		s/---?/–/g;
		say;
	}
}
