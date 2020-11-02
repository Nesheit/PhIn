#!/bin/sh
echo "Enter user's password:"

read password

echo "\nEnter user's password:"

echo $password | sudo -S modprobe v4l2loopback

echo "\n\n"

v4l2-ctl --list-devices

echo "\n\n"

echo "Enter the XXXX number of the /dev/videoXXXX refered to Dummy video device:\n"

read n

echo "On your phone, which last IP digits are displayed on IP Webcam before ":8080"?\n"

read ip

echo "FFmpebCam Loading...\n\n\n"

ffmpeg -f mjpeg -r 15 -i http://192.168.1.$ip:8080/videofeed -vcodec rawvideo -pix_fmt yuv420p -threads 0 -f v4l2 /dev/video$n
