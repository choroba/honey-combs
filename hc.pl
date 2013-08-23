#!/usr/bin/perl
use warnings;
use strict;

use Tk;
use List::Util qw(shuffle);

my @letters = (shuffle('A' .. 'Z'))[1 .. 20];

sub altitude {
    sqrt(3/4) * shift;
}

sub poly6 {
    my ($x, $y, $s) = @_;
    my $v = altitude($s);
    return ($x - $s,       $y,
            $x - ($s / 2), $y - $v,
            $x + ($s / 2), $y - $v,
            $x + $s,       $y,
            $x + ($s / 2), $y + $v,
            $x - ($s / 2), $y + $v,
           );
}

sub comb {
    my ($canvas, $fromx, $fromy, $size, $count) = @_;
    for (my $x = $fromx; $x < 3 * $count * $size; $x += 3 * $size) {
        for (my $y = $fromy; $y < 7.5 * $size; $y += 2 * altitude($size)) {
            $canvas->createPolygon(poly6($x, $y, $size),
                                   -outline => 'black',
                                   -fill    => 'yellow',
                                   -width   => 2,
                                  );
            $canvas->createText($x, $y, -fill => 'red',
                                        -text => shift @letters,
                                        -font => "{sans} " . ($size * 0.9),
                               );
        }
    }
}

my $size = 36;

my $mw     = 'MainWindow'->new(-title => "Honeycombs");
my $canvas = $mw->Canvas(-width  => 8 * $size,
                         -height => 8 * $size,
                        )->pack;

comb($canvas, $size,       $size,                   $size, 3);
comb($canvas, $size * 2.5, $size + altitude($size), $size, 2);


$mw->Button(-text    => 'Quit',
            -command => sub { $mw->exit },
           )->pack;
MainLoop();
