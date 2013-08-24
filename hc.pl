#!/usr/bin/perl
use warnings;
use strict;

use Tk;
use List::Util qw(shuffle);


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


{   my %changed;
    sub change {
        my ($canvas, $id, $lid) = @_;
        return sub {
            $canvas->itemconfigure($id,  -fill => 'pink');
            $canvas->itemconfigure($lid, -fill => 'black');
            undef $changed{$id};

            if (20 == keys %changed) {
                print "All letters pressed.\n";
                # Simple exit causes a "Font still in cache" segfault
                # when the last letter is changed with a mouse button.
                $canvas->MainWindow->after(10, sub { exit });
            }
        }
    }
}


{   my @letters = (shuffle('A' .. 'Z'))[1 .. 20];
    sub comb {
        my ($canvas, $fromx, $fromy, $size, $count) = @_;
        for (my $x = $fromx; $x < 3 * $count * $size; $x += 3 * $size) {
            for (my $y = $fromy; $y < 7.5 * $size; $y += 2 * altitude($size)) {
                my $id = $canvas->createPolygon(poly6($x, $y, $size),
                                                -outline => 'black',
                                                -fill    => 'yellow',
                                                -width   => 2,
                                      );
                my $letter = shift @letters;
                my $lid = $canvas->createText($x, $y, -fill => 'red',
                                            -text => $letter,
                                            -font => "{sans} " . ($size * 0.9),
                                   );
                $canvas->MainWindow->bind('all', lc $letter, change($canvas, $id, $lid));
                $canvas->bind($_, '<Button-1>', change($canvas, $id, $lid)) for $id, $lid;
            }
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


my $btn = $mw->Button(-text      => 'Quit',
                      -underline => 0,
                      -command   => sub { exit },
                     )->pack;
$mw->bind('<Alt-q>', sub { $btn->invoke });
MainLoop();
