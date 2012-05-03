stereos
=======

Stereos is a command line utility for interleaving stereoscopic videos.

###Sample output

[This](http://youtu.be/q0Vo1ujwRlg) is the result of running stereos with two video channels from a 3D video camera.

###Dependencies
Stereos depends on Perl 5 and ffmpeg to process image and video files. You probably already have Perl. The easiest way to install ffmpeg on Mac OS X is with [homebrew](http://mxcl.github.com/homebrew/):

     brew install ffmpeg --use-clang
	
This may take a few minutes, but it's worth the wait.

We'll push out a simple way to install stereos with `brew` soon. For now, just download stereos and use the executable perl script:

     cd stereos
     ./stereos

###Using stereos

Suppose we have two images we want to wiggle between. The following line would write a third animated GIF file in our current directory named wiggle.gif:
      stereos left.jpg right.jpgSuppose we have two video files we want to wiggle between. The 
following line would write a third video file in our current directory named wiggle.mp4:     stereos left.mp4 right.mp4The output wiggle.mp4 file will oscillate between the two mp4ies, playing the first 4 frames of left.mp4 then the second 4 frames of right.mp4 then the third 4 frames of left.mp4 and so on. If we want it to wiggle every 8 frames instead, we can add the rate option:     stereos left.mp4 right.mp4 -r 8Perhaps we would like to include all frames from both files. That is, we'd like the first 4 frames of left.mp4 to play followed by the first 4 frames of right.mp4 and so on. To do this, we would turn on the "stutter" option:     stereos left.mp4 right.mp4 -sThe resulting video in this case will seem to stutter every time it wiggles.
###Options
* `--rate` -- Specify the number of frames to take from one video before switching to the other.* `--stutter` -- Rather than alternating frames in time, each time the video changes, time will jump back.* `--out` -- Specify the output file.


###Cached frames
In order to interleave 2 videos, stereos first breaks the videos into frames. These frames are kept in a directory which is placed in the one where stereos was called. Because interleaving videos often requires a bit of trial and error and splitting up frames can be a lengthu process, stereos will keep the frames around and use them on the next run if it sees that they are there. Go ahead and toss them away after you're done.
###GoodbyeI hope you enjoy your new stereos!
Much love,
Peter Sugihara