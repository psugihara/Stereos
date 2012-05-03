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
 
following line would write a third video file in our current directory named wiggle.mp4:




###Cached frames
In order to interleave 2 videos, stereos first breaks the videos into frames. These frames are kept in a directory which is placed in the one where stereos was called. Because interleaving videos often requires a bit of trial and error and splitting up frames can be a lengthu process, stereos will keep the frames around and use them on the next run if it sees that they are there. Go ahead and toss them away after you're done.


