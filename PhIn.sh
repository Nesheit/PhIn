#!/bin/sh
xterm -title "PhInMic" -hold -e ./mic_over_mumble &
xterm -title "nmcli -p device show" -hold -e nmcli -p device show & 
xterm -title "PhInCam" -hold -e sh ./PhInCam.sh & 
