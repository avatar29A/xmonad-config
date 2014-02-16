import Data.Monoid
import Data.Tuple
import Data.Ratio ((%))
import qualified Data.Map        as M
import System.Exit
import System.IO
import System.Posix.Unistd

import XMonad
import qualified XMonad.StackSet as W
import XMonad.Actions.SpawnOn
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.SetWMName
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Layout.ResizableTile
import XMonad.Layout.PerWorkspace
import XMonad.Layout.NoBorders
import XMonad.Layout.Tabbed
import XMonad.Layout.Grid
import XMonad.Layout.IM

import XMonad.Actions.TopicSpace
import XMonad.Prompt
import XMonad.Prompt.Workspace

-- Variables
scriptBin  = "~/.xmonad/bin/"
myTerminal = "terminator"

-- myBrowser  = scriptBin ++ "browser.sh"


-- Whether focus follows the mouse pointer.
myFocusFollowsMouse = True

-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask       = mod4Mask

-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor  = "#dddddd"
myFocusedBorderColor = "#ff0000"

-- Keys
zeroModMask         = 0
altMaskLeft       = mod1Mask
altMaskRight      = mod3Mask
audioRaiseVolume :: KeySym
audioRaiseVolume  = 0x1008FF13
audioLowerVolume :: KeySym
audioLowerVolume  = 0x1008FF11
audioMute        :: KeySym
audioMute         = 0x1008FF12
audioPrev        :: KeySym
audioPrev         = 0x1008FF16
audioNext        :: KeySym
audioNext         = 0x1008FF17
audioPlay        :: KeySym
audioPlay         = 0x1008FF14
calculator       :: KeySym
calculator        = 0x1008FF1D

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys = [ ((mod4Mask .|. shiftMask, xK_z), spawn "gnome-screensaver-command --lock") --mod4mask is the windows key
           , ((0, xK_Print), spawn "gnome-screenshot")
           , ((mod1Mask, xK_F4), kill)
	   -- Window launching
    	   , ((mod4Mask, xK_c), spawnHere $ myTerminal ++ " -e python")
	   , ((mod4Mask, xK_i), spawnHere $ myTerminal ++ " -e ipython")
	 ]

------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    [
    -- Left Mouse Button - raise the window to the top of the stack
       ((modm, button1), (\w -> focus w >> windows W.shiftMaster))

    -- Right Mouse Button - set the window to floating mode and move by dragging
    , ((modm, button3), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))

    -- Right Mouse Button + Shift - set the window to floating mode and resize by dragging
    , ((modm .|. shiftMask, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))
    ]


------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.

talkWorkspaces      = ["talk"]

myLayouts = avoidStruts ( tiled ||| Mirror tiled ||| Full ||| Grid )
	where
		tiled = Tall nmaster delta ratio
		nmaster = 1
		ratio = 1/2
		delta = 3/100

--talkLayout      = avoidStruts $ withIM (1%7) (Role "buddy_list") Grid ||| Full

-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
myStartupHook =
  -- Fixes java display issue
  setWMName "LG3D"

myManageHook = composeAll
    [ className =? "MPlayer"        --> doFloat
    , className =? "Gimp"           --> doFloat
    , className =? "Vlc"	    --> doFloat
    , className =? "Pidgin"         --> doShift "talk"
    , className =? "Pithos"         --> doShift "media"
    , className =? "Thunderbird"    --> doShift "email"
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore
    , isFullscreen                  --> doFullFloat
    ]

main = do
	xmproc <- spawnPipe "/usr/bin/xmobar ~/.xmobarrc"
	xmonad $ defaultConfig
		{
		  manageHook = manageDocks <+> myManageHook  <+> manageHook defaultConfig
    		, layoutHook = lessBorders OnlyFloat $ myLayouts
		, focusFollowsMouse = myFocusFollowsMouse
		, startupHook = myStartupHook
		, mouseBindings = myMouseBindings
                , modMask       = myModMask
    		} `additionalKeys` myKeys
