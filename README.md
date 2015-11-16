Garmin-Pacman
=============

![snapshoot](https://github.com/southerncross/Garmin-Pacman/blob/master/snapshoot.png)


## What
Garmin-Pacman is a watch-face app of [Garmin Fenix3](fenix3.garmin.com) which displays a tiny Pac-man game on your watch :blush:


## How to load it into develop environment?

1. Download and deploy the Garmin develop environment along [Developer Guide].
2. Download the source code of Pacman. (git clone or download directly)
3. Create an empty watch-face app project on your Eclipse.`file->new->Connect IQ Project`
4. Replace `source/`, `resources/` and `manifest.xml` in the project with those of Pacman.
5. Start the simulator and run.

That's it. :smile:


## Issues

1. Most of the time, Pacman only update the screen one time every minute :joy:. This constrain comes from Garmin Connect IQ SDK and it is an important way of saving battery life.
Every time when you raise your wrist, Garmin Fenix3 will wake up from sleep mode into active mode, in which the screen can be updated every seconds. The active mode only lasts about 5s, then it will enter sleep mode again.

2. Currently Pacman will cause the watch becomes slower :fearful:. In other words, when you switch to other widgets or apps, it needs about 3s to finish switching. However, once you have switched to other app, it will behave normally.
The reason of this problem is that Pacman costs about 40K memory, I guess. It is inevitable because most of the memory is consumed by the code of drawing pictures :()


## LICENSE
The MIT License (MIT)

Copyright (c) 2015 LiShunyang

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.


----
Thanks for your attention :kissing: