import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Layout.NoBorders
import System.IO

myFocusFollowsMouse = False

myKeys = [ ((mod4Mask .|. shiftMask, xK_z), spawn "gnome-screensaver-command --lock") --mod4mask is the windows key
           , ((0, xK_Print), spawn "gnome-screenshot")
           , ((mod1Mask, xK_F4), kill)
	 ]

myLayouts = avoidStruts ( tiled ||| Mirror tiled ||| Full )
	where
		tiled = Tall nmaster delta ratio
		nmaster = 1
		ratio = 1/2
		delta = 3/100

main = do
	xmproc <- spawnPipe "/usr/bin/xmobar ~/.xmobarrc"
	xmonad $ defaultConfig
		{
		  manageHook = manageDocks <+> (className =? "Vlc" --> doFloat)  <+> manageHook defaultConfig
    		, layoutHook = lessBorders OnlyFloat $ myLayouts
		, focusFollowsMouse = myFocusFollowsMouse
    		} `additionalKeys` myKeys
