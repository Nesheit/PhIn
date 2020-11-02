# PhIn

PhIn, the Ph(one)In(put) setup to use your phone as a webcam and/or microphone for your Linux PC

## Dependencies

To get this setup to work properly on your Linux desktop, you'll need to install:
* ffmpeg
* pavucontrol
* mumble
* murmurd
* v4l2loopback from this github: <a href="https://github.com/umlaeute/v4l2loopback" target="_blank">umlaeute/v4l2loopback</a>   

And you'll have to then configure the murmurd server, for our purpose there's an useful github page:
* mic_over_mumble: <a href="https://github.com/pzmarzly/mic_over_mumble" target="_blank">pzmarzly/mic_over_mumble</a>  

## 1st Step: Creating Virtual Interfaces

The aim of this setup is to create (one and for all) a virtual webcam and a virtual microphone to which redirect the data sent over LAN by your phone.     
1. To create the **virtual webcam**, start by following all the <a href="https://github.com/umlaeute/v4l2loopback" target="_blank">v4l2loopback</a> guide about getting it installed.  
2. Once done, you can install on your phone an **IP Camera App**.   
I suggest you <a href="https://play.google.com/store/apps/details?id=com.pas.webcam" target="_blank">IP Webcam for Android</a> or <a href="https://play.google.com/store/apps/details?id=com.pas.webcam" target="_blank">YouIPCams for iPhone</a>.   

After that you can create a virtual microphone as described in [NapoleonWils0n's github guide](https://github.com/NapoleonWils0n/cerberus/blob/master/pulseaudio/virtual-mic.org).   
Here's an ultra-newbie version of that same guide:
1. open terminal
2. run    
    
       pactl load-module module-null-sink sink_name=Source
3. then run    
    
       pactl load-module module-virtual-source source_name=VirtualMic master=Source.monitor
4. then run    
    
       touch ~/.config/pulse/default.pa
5. then run    
    
       nano ~/.config/pulse/default.pa
6. then copy the following code:\# include the default.pa pulseaudio config file   
   > .include /etc/pulse/default.pa   
   >    
   > \# null sink   
   > .ifexists module-null-sink.so   
   > load-module module-null-sink sink_name=Source   
   > .endif   
   >    
   > \# virtual source   
   > .ifexists module-virtual-source.so   
   > load-module module-virtual-source source_name=VirtualMic master=Source.monitor   
   > .endif   
7. then <kbd>ctrl</kbd> + <kbd>shift</kbd> + <kbd>V</kbd> in the terminal window
8. then <kbd>ctrl</kbd> + <kbd>O</kbd> in the terminal window
9. then <kbd>Enter</kbd> 
10. then <kbd>ctrl</kbd> + <kbd>X</kbd> 
11. then <kbd>Enter</kbd>   
   
You can now install [Plumble on your Android Phone](https://play.google.com/store/apps/details?id=com.morlunk.mumbleclient.free) or [Mumble on your iPhone](https://apps.apple.com/it/app/mumble/id443472808) to create an audio chat between your PC and your Phone on the murmurd(Mumble) server hosted by your computer over the same LAN connection of your phone.
   
## 2nd Step: Connecting video and audio from Phone to Virtual Interfaces

### Video to Virtual Webcam

Once you have all prepared, you can now connect your Phone's IP Camera video stream to your virtual webcam using ffmpeg:
1. Open the terminal
2. run    
    
        sudo modprobe v4l2loopback
3. then run    
    
       v4l2-ctl --list-devices
4. keep in mind the /dev/videoXXXX line of your _**Dummy Video Device**_ 
5. finally run    
    
       ffmpeg -f mjpeg -r 15 -i YOUR_APP_VIDEOFEED_ADDRESS -vcodec rawvideo -pix_fmt yuv420p -threads 0 -f v4l2 /dev/videoXXXX
   
If you have an Android Phone and you're using <a href="https://play.google.com/store/apps/details?id=com.pas.webcam" target="_blank">IP Webcam</a>, YOUR_APP_VIDEOFEED_ADDRESS will be    
    
       http://IP_IN_THE_BOTTOM_OF_THE_APP_SCREEN:8080/videofeed
   
And, on the phone, you'll have to set the video in the 640x480 format   
   
Otherwise, on <a href="https://play.google.com/store/apps/details?id=com.pas.webcam" target="_blank">YouIPCams for iPhone</a>, YOUR_APP_VIDEOFEED_ADDRESS will be    
    
       rtsp://ACCOUNT_NAME:ACCOUNT_PASSWORD@IP_IN_THE_APP_MENU:22345/live
   
And, on the phone, you'll have to enable the rtsp mode and set a name and a password for accessing the stream.

### Audio to Virtual Microphone
   
Now you can also redirect the audio from the Mumble chat to your Virtual Microphone:
1. open terminal and navigate too the mic_over_mumble folder you previously downloaded from github
2. launch    
    
       ./mic_over_mumble
   
   it will setup the server and make your PC enter the Mumble room
           
3. then run    
    
       nmcli -p device show
4. Keep in mind your IP4.ADDRESS[1]
5. from your phone enter the "call room" by entering the IP4.ADDRESS[1] when asked Server's IP
6. from Mumble Settings on PC set the Audio Exit so that you have "pulseaudio" as system and "Null Exit" as interface and **Apply**
7. if you face any problem, launch    
    
       pavucontrol
   and set the Mumble output to "Null Exit" and adjust the volume as you prefer    
   
**Enjoy**
