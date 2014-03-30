#file xmonad-start.sh, made executable.
sleep 1
#xsetroot -grey #just to set background color

setxkbmap -layout "us,ru(winkeys)" -model "microsoft4000" -option "grp:caps_toggle,terminate:ctrl_alt_bksp,grp_led:scroll"

trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 10 --height 12 --transparent true --tint 0x000000 &

xmonad
