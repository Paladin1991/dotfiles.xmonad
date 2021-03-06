import System.IO
import System.Exit

import XMonad
import XMonad.Hooks.SetWMName
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageHelpers(doFullFloat, doCenterFloat, isFullscreen, isDialog)
import XMonad.Config.Desktop
import XMonad.Config.Azerty
import XMonad.Util.Run(spawnPipe)
import XMonad.Actions.SpawnOn
import XMonad.Util.EZConfig (additionalKeys, additionalMouseBindings)
import XMonad.Actions.CycleWS
import XMonad.Hooks.UrgencyHook
import qualified Codec.Binary.UTF8.String as UTF8

import XMonad.Layout.Spacing
import XMonad.Layout.Gaps
import XMonad.Layout.ResizableTile
---import XMonad.Layout.NoBorders
import XMonad.Layout.Fullscreen (fullscreenFull)
import XMonad.Layout.Cross(simpleCross)
import XMonad.Layout.Spiral(spiral)
import XMonad.Layout.ThreeColumns
import XMonad.Layout.MultiToggle
import XMonad.Layout.MultiToggle.Instances
import XMonad.Layout.IndependentScreens


import XMonad.Layout.CenteredMaster(centerMaster)

import Graphics.X11.ExtraTypes.XF86
import qualified XMonad.StackSet as W
import qualified Data.Map as M
import qualified Data.ByteString as B
import Control.Monad (liftM2)
import qualified DBus as D
import qualified DBus.Client as D

import XMonad.Actions.MouseGestures
import qualified XMonad.StackSet as W

myStartupHook = do
    spawn "$HOME/.xmonad/scripts/autostart.sh"
    --setWMName "LG3D"

-- colours
normBord = "#192325"
focdBord = "#D5BA82"
fore     = "#DEE3E0"
back     = "#282c34"
winType  = "#c678dd"

myModMask = mod4Mask
encodeCChar = map fromIntegral . B.unpack
myFocusFollowsMouse = True
myBorderWidth = 0

myWorkspaces    = ["1","2","3","4","5","6","7","8","9","10"]


myBaseConfig = desktopConfig

-- window manipulations
myManageHook = composeAll . concat $
    [ [isDialog --> doCenterFloat]
    , [className =? c --> doCenterFloat | c <- myCFloats]
    , [title =? t --> doFloat | t <- myTFloats]
    , [resource =? r --> doFloat | r <- myRFloats]
    , [resource =? i --> doIgnore | i <- myIgnores]
    ]
    where
    -- doShiftAndGo = doF . liftM2 (.) W.greedyView W.shift
    myCFloats = ["pavucontrol","lxappearance", "termite"]
    myTFloats = ["Downloads", "Save As..."]
    myRFloats = ["feh"]
    myIgnores = ["desktop_window"]
    -- my1Shifts = []
    -- my2Shifts = []
    -- my3Shifts = []
    -- my4Shifts = []
    -- my5Shifts = []
    -- my6Shifts = []
    -- my7Shifts = []
    -- my8Shifts = []
    -- my9Shifts = []
    -- my10Shifts = []




myLayout = spacingRaw True (Border 20 20 20 20) True (Border 20 20 20 20) True $ avoidStruts $ mkToggle (NBFULL ?? NOBORDERS ?? EOT) $ tiled ||| Mirror tiled ||| spiral (6/7)  ||| ThreeColMid 1 (3/100) (1/2) ||| Full
--myLayout = avoidStruts (smartBorders (tabbed shrinkText tabbedTheme) ||| defaultFancyBorders tiled ||| defaultFancyBorders (Mirror tiled))

    where
        tiled = Tall nmaster delta tiled_ratio
        nmaster = 1
        delta = 4/100
        tiled_ratio = 1/2


myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modMask, 1), (\w -> focus w >> mouseMoveWindow w >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modMask, 2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modMask, 3), (\w -> focus w >> mouseResizeWindow w >> windows W.shiftMaster))

    ]


-- keys config

myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $

  [ ((modMask, xK_t), spawn $ "telegram-desktop" )
  , ((modMask, xK_c), spawn $ "google-chrome-stable" )
  , ((modMask, xK_s), spawn $ "subl3" )
  , ((modMask, xK_n), spawn $ "nemo" )
  , ((modMask, xK_Return), spawn $ "termite" )
  , ((modMask, xK_e), spawn $ "eww open-many sidebar webapps webapps2 mpd calendar weather sys & feh -g 245x170+1095+250 --zoom 20 ~/Imagens/*")
  , ((modMask .|. shiftMask , xK_d ), spawn $ "dmenu_run -i -nb '#191919' -nf '#5e81ac' -sb '#5e81e0' -sf '#191919' -fn 'NotoMonoRegular:bold:pixelsize=14'")
  , ((modMask .|. shiftMask , xK_r ), spawn $ "xmonad --recompile && xmonad --restart")
  , ((modMask .|. shiftMask , xK_e ), io (exitWith ExitSuccess))
  , ((modMask, xK_q), kill )
  , ((modMask, xK_f), sendMessage $ Toggle NBFULL)

  , ((0, xK_Print), spawn $ "scrot 'Xmonad-%Y-%m-%d-%s_screenshot_$wx$h.png' -e 'mv $f $$(xdg-user-dir PICTURES)'")

  -- Mute volume
  , ((0, xF86XK_AudioMute), spawn $ "amixer -q set Master toggle")

  -- Decrease volume
  , ((0, xF86XK_AudioLowerVolume), spawn $ "eww open vol && amixer -q set Master 5%- && sleep 5 && eww close vol")

  -- Increase volume
  , ((0, xF86XK_AudioRaiseVolume), spawn $ "eww open vol && amixer -q set Master 5%+ && sleep 5 && eww close vol")

  --  XMONAD LAYOUT KEYS

  -- Cycle through the available layout algorithms.
  , ((modMask, xK_space), sendMessage NextLayout)
  , ((modMask .|. shiftMask, xK_space     ), withFocused $ windows . W.sink)

  --  Reset the layouts on the current workspace to default.
  --, ((modMask .|. shiftMask, xK_space), setLayout $ XMonad.layoutHook conf)

  -- Move focus to the next window.
  , ((modMask, xK_Tab), windows W.focusDown)

  -- Shrink the master area.
  , ((controlMask .|. shiftMask , xK_Left), sendMessage Shrink)

  -- Expand the master area.
  , ((controlMask .|. shiftMask , xK_Right), sendMessage Expand)

  ]
  ++

  -- mod-[1..9], Switch to workspace N
  -- mod-shift-[1..9], Move client to workspace N
  [((m .|. modMask, k), windows $ f i)

  --Keyboard layouts
  --qwerty users use this line
   | (i, k) <- zip (XMonad.workspaces conf) [xK_1,xK_2,xK_3,xK_4,xK_5,xK_6,xK_7,xK_8,xK_9,xK_0]

  --French Azerty users use this line
  -- | (i, k) <- zip (XMonad.workspaces conf) [xK_ampersand, xK_eacute, xK_quotedbl, xK_apostrophe, xK_parenleft, xK_minus, xK_egrave, xK_underscore, xK_ccedilla , xK_agrave]

  --Belgian Azerty users use this line
  -- | (i, k) <- zip (XMonad.workspaces conf) [xK_ampersand, xK_eacute, xK_quotedbl, xK_apostrophe, xK_parenleft, xK_section, xK_egrave, xK_exclam, xK_ccedilla, xK_agrave]

      , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)
      , (\i -> W.greedyView i . W.shift i, shiftMask)]]

  ++
  -- ctrl-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
  -- ctrl-shift-{w,e,r}, Move client to screen 1, 2, or 3
  [((m .|. controlMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
      | (key, sc) <- zip [xK_w, xK_e] [0..]
      , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]


main :: IO ()
main = do

    dbus <- D.connectSession
    -- Request access to the DBus name
    D.requestName dbus (D.busName_ "org.xmonad.Log")
        [D.nameAllowReplacement, D.nameReplaceExisting, D.nameDoNotQueue]

    xmonad . ewmh $

            myBaseConfig

                {startupHook = myStartupHook
, layoutHook = gaps [(U,60), (D,45), (R,40), (L,40)] $ myLayout ||| layoutHook myBaseConfig
, manageHook = manageSpawn <+> myManageHook <+> manageHook myBaseConfig
, modMask = myModMask
, borderWidth = myBorderWidth
, handleEventHook    = handleEventHook myBaseConfig <+> fullscreenEventHook
, focusFollowsMouse = myFocusFollowsMouse
, workspaces = myWorkspaces
, focusedBorderColor = focdBord
, normalBorderColor = normBord
, keys = myKeys
, mouseBindings = myMouseBindings
}
