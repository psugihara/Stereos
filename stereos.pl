#!/usr/bin/env perl -w

# stereos.pl
# This program takes two images or videos and interleaves them to produce
# "wiggle" stereoscopic effects.

use strict;
use warnings;

use Getopt::Long;

use Weaver;

my $TMP_DIR = "./.stereos_tmp";
mkdir $TMP_DIR;

# Get filepaths and verify.
if ($#ARGV < 1) {
    die "usage: stereos video_1 video_2\n";
}

my ($video_1, $video_2) = @ARGV;

unless (-e $video_1) {
    die "couldn't find \"$video_1\"\n";
}
unless (-e $video_2) {
    die "couldn't find \"$video_2\"\n";
}

# Retrieve options.
my $stutter;
my $rate = 4;
my $output_file = "wiggle.mp4";
GetOptions("rate=i" => \$rate,
           "stutter"  => \$stutter,
           "out=s" => \$output_file);

# Get frames.
my @frames_1;
my @frames_2;
my $data_dir = "./frames_$video_1\_$video_2";
my $frame_dir_1 = "$data_dir/$video_1";
my $frame_dir_2 = "$data_dir/$video_2";
unless (-e $data_dir) {
    mkdir $data_dir;
    print "Splitting videos into frames...\n";
    @frames_1 = make_frames($video_1, $frame_dir_1);
    @frames_2 = make_frames($video_2, $frame_dir_2);
} else {
    print "Found cached frames...\n";
    @frames_1 = frames_in_file($frame_dir_1);
    @frames_2 = frames_in_file($frame_dir_2);
}

# Interleave frames.
print "Weaving frames...\n";
my @woven;
if ($stutter) {
    @woven = stutter([\@frames_1, \@frames_2], $rate);
} else {
    @woven = alternate([\@frames_1, \@frames_2], $rate);
}

# Merge frames.
print "Merging frames...\n";
unlink $output_file;
merge_frames(\@woven, $output_file, $data_dir);

`rm -r $TMP_DIR`;



# SPLIT
# Rip frames into $frame_dir from video at $path.
# Return a list of frame names in order.
# (path) -> (frame paths)
sub make_frames {
    my $path;
    my $frame_dir;
    ($path, $frame_dir) = @_;

    # Check if the decoder is available
    my $ffmpeg = `which ffmpeg`;
    chomp($ffmpeg);
    if($ffmpeg eq "") {
      die "Sorry, ffmpeg could not be found.\n";
    }

    # Generate frames in $framedir.
    mkdir $frame_dir;
    `$ffmpeg -qscale 1 -i \"$path\" -qscale 1 $frame_dir/f%10d.jpg >> log.txt 2>&1`;

    return frames_in_file($frame_dir);
}

# Get names of frames in $frame_dir. Return list of paths.
sub frames_in_file {
    my $frame_dir = $_[0];

    # Get names of generated frame files in order.
    opendir DIR, $frame_dir;
    my @frame_names = grep /^f\d*\.jpg$/, readdir(DIR);
    close DIR;

    # Append relative path.
    return map { "$frame_dir/$_" } @frame_names;
}


# MERGE
# Take a reference to an ordered list of @paths to images and merge them into
# as frames of an $output file.
# (path, fps, file_name) -> ()
sub merge_frames {
    my @paths = @{$_[0]}; # directory containing frames
    # my $fps; # frames per second
    my $output = $_[1]; # output file

    # Check if the encoder is available
    my $ffmpeg = `which ffmpeg`;
    chomp($ffmpeg);
    if($ffmpeg eq "") {
      die "Sorry, ffmpeg could not be found.\n";
    }

    # Write the list of frames to a file to prevent "argument list too long".
    my $to_cat = "$TMP_DIR/frame_list.txt";
    open OUT, ">$to_cat";
    print OUT join "\n", @paths;
    close OUT;
    `cat $to_cat | xargs cat | ffmpeg -f image2pipe -c:v mjpeg -i - $output`;
}