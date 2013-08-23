#!/usr/bin/perl
use warnings;
use strict;

use Tk;

sub altitude {
    sqrt(3) * shift() / 2;
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
    my ($canvas, $fromx, $fromy, $color, $size) = @_;
    for (my $x = $fromx; $x < 10 * $size; $x += 3 * $size) {
        for (my $y = $fromy; $y < 10 * $size; $y += 2 * altitude($size)) {
            $canvas->createPolygon(poly6($x, $y, $size),
                                   -outline => 'blue',
                                   -fill => $color);
        }
    }
}

my $size = 36;

my $mw     = 'MainWindow'->new(-title => "Honeycombs");
my $canvas = $mw->Canvas(-width  => 10 * $size,
                         -height => 12 * $size,
                        )->pack;

comb($canvas, $size,       $size,               'yellow', $size);
comb($canvas, $size * 2.5, sqrt($size)+altitude($size) * 2, 'pink',   $size);


$mw->Button(-text    => 'Quit',
            -command => sub { $mw->exit },
           )->pack;
MainLoop();
