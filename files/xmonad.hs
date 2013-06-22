


import XMonad

import XMonad hiding (Tall)
import XMonad.Actions.CycleWS
import XMonad.Actions.FloatKeys
import XMonad.Actions.GridSelect

import XMonad.Hooks.DynamicHooks
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.EwmhDesktops

import qualified XMonad.StackSet as SS
import XMonad.Layout.MultiToggle as MT
import XMonad.Layout.SimpleFloat
import XMonad.Layout.WindowArranger
import XMonad.Layout.Named
import XMonad.Layout.Magnifier
import XMonad.Layout.Grid
import XMonad.Layout.BoringWindows hiding (Merge)
import XMonad.Layout.Spacing
import XMonad.Layout.Column
import XMonad.Layout.ComboP
import XMonad.Layout.LayoutModifier
import XMonad.Layout.MouseResizableTile
import XMonad.Layout.PerWorkspace
import XMonad.Layout.Simplest
import XMonad.Layout.SubLayouts
import XMonad.Layout.ToggleLayouts
import XMonad.Layout.Tabbed
import XMonad.Layout.Circle
import XMonad.Layout.IM
import XMonad.Layout.Reflect
import XMonad.Layout.ComboP
import XMonad.Layout.TwoPane
import XMonad.Layout.ThreeColumns
import XMonad.Layout.LayoutCombinators hiding ( (|||) )
import XMonad.Layout.WindowNavigation

import XMonad.ManageHook
import XMonad.Prompt
import XMonad.Prompt.Shell
import XMonad.Util.Run
import XMonad.Util.Loggers

import Control.Monad (liftM2)
import Data.Monoid
import Graphics.X11
import Graphics.X11.Xinerama
import System.Exit
import System.IO

import qualified System.IO.UTF8
import qualified Data.Map as M
import qualified XMonad.StackSet as W
import qualified XMonad.Actions.FlexibleResize as Flex

xmonadDir  = "/home/jianingy/.xmonad"

-- myXmonadBar = "dzen2 -x '0' -y '0' -h '18' -w '1920' -ta 'l' -fg '#cccccc' -bg '#151515' -fn 'PF Tempesta Seven:size=6' -e ''"
-- myTrayIcon = "trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --widthtype request --transparent true --alpha 0 --tint 0x151515 --height 18  --margin 2"
myBitmapsDir = "/home/jianingy/.xmonad/dzen2"
main = do
--         dzenLeftBar <- spawnPipe myXmonadBar
--         dzenRightBar <- spawnPipe myTrayIcon
         xmonad $ ewmh defaultConfig
            { modMask = mod4Mask
            , terminal = "urxvt"
            , borderWidth = 1
            , focusFollowsMouse = False
            , keys = myKeys
            , workspaces = myWorkspaces
            , normalBorderColor = "#4B5054"
            , focusedBorderColor = "#777777"
            , layoutHook = myLayout
            , manageHook = myManageHook <+> manageHook defaultConfig
--            , logHook    = myLogHook dzenLeftBar -- >> fadeInactiveLogHook 0xdddddddd
            }

-- Statusbar options:

myLogHook :: Handle -> X ()
myLogHook h = dynamicLogWithPP $ defaultPP
    {
        ppCurrent           =   dzenColor "#ebac54" "#222222" . pad
      , ppVisible           =   dzenColor "#cccccc" "#151515" . pad
      , ppHidden            =   dzenColor "#cccc80" "#151515" . pad
      , ppHiddenNoWindows   =   dzenColor "#7b7b7b" "#151515" . pad
      , ppUrgent            =   dzenColor "#ff0000" "#151515" . pad
      , ppWsSep             =   " "
      , ppSep               =   "  |  "
      , ppLayout            =   dzenColor "#ebac54" "#151515" .
                                (\x -> case x of
                                    "ResizableTall"             ->      "^i(" ++ myBitmapsDir ++ "/tall.xbm)"
                                    "Mirror ResizableTall"      ->      "^i(" ++ myBitmapsDir ++ "/mtall.xbm)"
                                    "Full"                      ->      "^i(" ++ myBitmapsDir ++ "/full.xbm)"
                                    "Simple Float"              ->      "~"
                                    _                           ->      x
                                )
      , ppTitle             =   (" " ++) . dzenColor "#cccccc" "#151515" . dzenEscape
      , ppExtras            =   [wrapL " " " " $ date "%H:%M"]
      , ppOutput            =   hPutStrLn h
    }

-- Urgency hint options:
-- Layouts:
myTabTheme = defaultTheme { decoHeight = 28
                   , activeColor = "#333333"
                   , inactiveColor = "#151515"
                   , activeBorderColor = "#4B5054"
                   , inactiveBorderColor = "#4B5054"
                   , activeTextColor = "#ebac54"
                   , inactiveTextColor = "#666666"
                   }

-- myWorkspaces :: [WorkspaceId]
-- myWorkspaces = ["MAIN"] ++ map show [2 .. 24]
myWorkspaces = ["Programming", "Browsering", "Temporary", "Operation"] ++ map show [5 .. 9]

--

myLayout = avoidStruts
    $ onWorkspace "Programming" layout_toggle_emacs
    $ onWorkspace "Browsering" layout_toggle_browse
    $ onWorkspace "Temporary" layout_magnify_circle
    $ onWorkspace "Operation" layout_grid
    $ layout_toggle
  where

  -- layout specific variables

    -- basic information
    goldenRatio = 233 / 377
    magStep = toRational (1+goldenRatio)
    ratio12 = 1 / 2
    ratio45 = 4 / 5
    delta = 3 / 100
    nmaster = 1

    -- basic layouts
    layout_grid = spacing 3 $ Grid
    layout_tall = spacing 3 $ Tall nmaster delta ratio12
    layout_mirror_tall = spacing 3 $ Mirror $ Tall nmaster delta ratio12
    layout_circle = Circle
    layout_tabup = tabbed shrinkText myTabTheme
    layout_tabs = (layout_tabup *//* layout_tabup)
    layout_magnify_grid = spacing 3 $ windowArrange $ magnifiercz' magStep $ MT.mkToggle (REFLECTX ?? EOT) $ MT.mkToggle (REFLECTY ?? EOT) $ Grid
    layout_magnify_circle = spacing 3 $ windowArrange $ magnifiercz' magStep $ MT.mkToggle (REFLECTX ?? EOT) $ MT.mkToggle (REFLECTY ?? EOT) $ Circle


    -- cominbation layouts
    -- layout_trinity_www = spacing 3 $combineTwoP (TwoPane delta goldenRatio) (Full) (layout_tabs) (ClassName "Google-chrome")
    -- layout_trinity_emacs = spacing 3 $ combineTwoP (TwoPane delta goldenRatio) (Full) (layout_tabs) (ClassName "Emacs")
    -- layout_trinity_term = spacing 3 $ combineTwoP (TwoPane delta goldenRatio) (Full) (layout_tabs) (ClassName "URxvt")
    layout_trinity_col = spacing 3 $ ThreeColMid nmaster delta ratio12
    -- layout_toggle_trinity = toggleLayouts Full (layout_trinity_col ||| layout_trinity_www ||| layout_trinity_term ||| layout_trinity_emacs ||| Full)

    -- workspace layouts
    layout_emacs = spacing 3 $ Mirror $ Tall nmaster delta ratio45
    layout_browse = spacing 3 $ Tall nmaster delta ratio45
    layout_toggle_emacs = toggleLayouts Full (layout_emacs ||| layout_magnify_grid ||| layout_tall)
    layout_toggle_browse = toggleLayouts Full (layout_browse ||| layout_magnify_grid ||| layout_tall)

    -- toggle layouts
    layout_toggle1 = toggleLayouts Full (layout_grid ||| layout_magnify_grid ||| layout_mirror_tall)
    layout_toggle2 = toggleLayouts Full (layout_mirror_tall||| layout_grid ||| layout_magnify_grid)

    layout_toggle = toggleLayouts Full (layout_tall ||| layout_tabup ||| layout_circle ||| layout_grid ||| layout_mirror_tall ||| layout_magnify_circle ||| layout_magnify_grid ||| layout_trinity_col ||| simpleFloat)

-- use xprop to get WM_CLASSNAME
myManageHook = composeAll
      [ className =? "Gimp" --> doFloat
      , className =? "Mplayer" --> doFloat
      , className =? "Conky" --> doIgnore
      , className =? "Gnome-player" --> doFloat
      , className =? "rdesktop" --> (ask >>= doF . W.sink)
      , className =? "Gcr-prompter" --> doCenterFloat
      , className =? "URxvt" -->  doF W.swapDown
      , (role =? "gimp-toolbox" <||> role =? "gimp-image-window") --> (ask >>= doF . W.sink)
      , isFullscreen --> doFullFloat -- for fullscreen apps
      , resource =? "stalonetray" --> doIgnore
      , manageDocks
      ]
      where role = stringProperty "WM_WINDOW_ROLE"

myKeys conf@(XConfig {XMonad.modMask = modMask}) =
  M.fromList $
    -- launching and killing programs
    [ ((modMask,               xK_Return), spawn $ XMonad.terminal conf) -- %! Launch terminal
    , ((modMask,               xK_v     ), spawn "/home/jianingy/local/t/mymenu.sh") -- %! Launch dmenu
    , ((modMask .|. shiftMask, xK_p     ), spawn "gmrun") -- %! Launch gmrun
    , ((modMask              , xK_s     ), spawn "screenshot") -- %! screenshot
    , ((modMask .|. shiftMask, xK_c     ), kill) -- %! Close the focused window

    , ((modMask,               xK_space ), sendMessage NextLayout) -- %! Rotate through the available layout algorithms
    , ((modMask .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf) -- %!  Reset the layouts on the current workspace to default

    , ((modMask,               xK_n     ), refresh) -- %! Resize viewed windows to the correct size

    -- move focus up or down the window stack
    , ((modMask,               xK_Tab   ), windows W.focusDown) -- %! Move focus to the next window
    , ((modMask .|. shiftMask, xK_Tab   ), windows W.focusUp  ) -- %! Move focus to the previous window
    , ((modMask,               xK_j     ), windows W.focusDown) -- %! Move focus to the next window
    , ((modMask,               xK_k     ), windows W.focusUp  ) -- %! Move focus to the previous window
    , ((modMask,               xK_m     ), windows W.focusMaster  ) -- %! Move focus to the master window

    -- modifying the window order
    , ((modMask .|. shiftMask, xK_Return), windows W.swapMaster) -- %! Swap the focused window and the master window
    , ((modMask .|. shiftMask, xK_j     ), windows W.swapDown  ) -- %! Swap the focused window with the next window
    , ((modMask .|. shiftMask, xK_k     ), windows W.swapUp    ) -- %! Swap the focused window with the previous window

    -- resizing the master/slave ratio
    , ((modMask,               xK_l     ), sendMessage Shrink) -- %! Shrink the master area
    , ((modMask,               xK_h     ), sendMessage Expand) -- %! Expand the master area

    -- floating layer support
    , ((modMask,               xK_t     ), withFocused $ windows . W.sink) -- %! Push window back into tiling

    -- increase or decrease number of windows in the master area
    , ((modMask              , xK_comma ), sendMessage (IncMasterN 1)) -- %! Increment the number of windows in the master area
    , ((modMask              , xK_period), sendMessage (IncMasterN (-1))) -- %! Deincrement the number of windows in the master area

    -- toggle the status bar gap
    --, ((modMask              , xK_b     ), modifyGap (\i n -> let x = (XMonad.defaultGaps conf ++ repeat (0,0,0,0)) !! i in if n == x then (0,0,0,0) else x)) -- %! Toggle the status bar gap
    -- quit, or restart
    , ((modMask .|. shiftMask, xK_q     ), io (exitWith ExitSuccess)) -- %! Quit xmonad
    , ((modMask              , xK_q     ), spawn "if type xmonad; then xmonad --recompile && xmonad --restart; else xmessage xmonad not in \\$PATH: \"$PATH\"; fi") -- %! Restart xmonad
    , ((modMask              , xK_f), sendMessage $ JumpToLayout "Full")  -- jump directly to the Full layout
    ]

  ++
    -- mod-[1..9] %! Switch to workspace N
    -- mod-shift-[1..9] %! Move client to workspace N
  [((m .|. modMask, k), windows $ f i)
  | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
  , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
  ++
    -- mod-{w,e,r} %! Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r} %! Move client to screen 1, 2, or 3
  [((m .|. modMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

-- vim: ts=2 sw=2 ai et
