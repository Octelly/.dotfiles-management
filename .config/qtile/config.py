# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

from typing import List  # noqa: F401

from libqtile import bar, layout, widget, qtile, hook
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal
#from libqtile.

from screeninfo import get_monitors  # how many monitors?
import os          # autostart path
import subprocess  #       and exec

mod = "mod4"
terminal = guess_terminal()

keys = [

    # Keybinds cheatsheet
    # (not implemented)

    # Switch between groups
    Key([mod], "Left", lazy.screen.prev_group()),
    Key([mod], "Right", lazy.screen.next_group()),

    # Switch between windows
    Key(["mod1"], "Tab", lazy.group.next_window()),
    Key(["mod1", "shift"], "Tab", lazy.group.prev_window()),

    # Focus urgent client
    # (never used)

    # Switch between screens
    # (not implemented)

    # Program shortcuts
    # FIXME: add the rest
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    Key([mod], "f", lazy.spawn('nautilus -w'), desc="Launch file manager"),
    Key([mod], "r", lazy.spawn("rofi -no-default-config -config ~/.config/awesome/rofi/config.rasi -switchers combi,drun,calc -show combi"),
        desc="Spawn Rofi"),
    Key(["control", "shift"], "Print", lazy.spawn("i3-maim-clpimg -s"), desc="Selection screenshot"),
    Key(["control"], "Print", lazy.spawn("i3-maim-clpimg -f"), desc="Fullscreen screenshot"),
    Key([mod], "l", lazy.spawn(os.path.expanduser('~') + '/.config/qtile/lock.zsh'), desc="Lock session"),

    # HW control
    Key([], "XF86MonBrightnessUp", lazy.spawn("busctl call org.clightd.clightd /org/clightd/clightd/Backlight org.clightd.clightd.Backlight RaiseAll \"d(bdu)s\" 0.025 0 0 0 \"\""), desc="Brightness up"),
    Key([], "XF86MonBrightnessDown", lazy.spawn("busctl call org.clightd.clightd /org/clightd/clightd/Backlight org.clightd.clightd.Backlight LowerAll \"d(bdu)s\" 0.025 0 0 0 \"\""), desc="Brightness down"),

    # QTile control
    Key([mod, "control"], "r", lazy.restart(), desc="Restart Qtile"),
    Key(["mod1", "control"], "r", lazy.spawn(os.path.expanduser('~') + '/.config/qtile/restart_picom.zsh'), desc="Restart Picom"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),

    # Window width change
    # (not implemented)

    # Keyboard layouts
    Key([mod], "space", lazy.widget["keyboardlayout"].next_keyboard(), desc="Next keyboard layout."),

    # Unminimise client
    # (might not be needed)

    # Media keys
    # (might not be needed)

    # Toggle between different layouts as defined below
    # FIXME: will need to be changed eventually
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),

    # "clientkeys"
    Key([mod], "q", lazy.window.kill(), desc="Kill focused window"),
    Key([mod, "shift"], "t", lazy.window.toggle_floating(), desc="Pain"),
    # FIXME: "clientkeys" from AwesomeWM
]

# Drag floating layouts.
mouse = [
    # Switch between groups
    Click([mod], "Button4", lazy.screen.prev_group()),
    Click([mod], "Button5", lazy.screen.next_group()),

    # FIXME: below are some default binds, customise them
    Drag([mod], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front())
]

layouts = [
    layout.Columns(
        border_focus_stack='#d75f5f',
        margin=5,
        
        border_normal="#2d2a2e",
        border_focus="#f85e84",

        border_width=2,
    ),
    layout.Max(),
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Matrix(),
    # layout.MonadTall(),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

widget_defaults = dict(
    font='FiraCode Nerd Font Mono',
    fontsize=13,
    padding=2,
)
extension_defaults = widget_defaults.copy()

class MousePosition(widget.base.InLoopPollText):
    def poll(self):
        return str(qtile.mouse_position)

screens = [
    Screen(
        top=bar.Bar(
            [
                widget.GroupBox(
                    active="#e3e1e4",
                    inactive="#49464e",

                    this_current_screen_border="#f85e84",
                    this_screen_border="#f85e84",

                    highlight_method="line",
                    highlight_color="1a181a",
                    rounded=False
                ),
                widget.TaskList(
                    border="#49464e",

                    padding=1,

                    highlight_method="block",
                    rounded=False
                ),
                widget.Chord(
                    chords_colors={
                        'launch': ("#ff0000", "#ffffff"),
                    },
                    name_transform=lambda name: name.upper(),
                ),
                widget.TextBox("ahoj Kati :)", name="default"),
                widget.KeyboardLayout(
                    configured_keyboards=['us','cz(qwerty)']
                ),
                widget.Systray(background="#2d2a2e"),
                widget.Battery(format='{percent:2.0%}batt', battery=1),
                widget.Battery(format='{percent:2.0%}batt', battery=0),
                widget.Clock(
                    format='%H:%M:%S|%A %d.%m.|%b %Y'#,
                    #foreground="#49464e"
                ),
                #MousePosition(),  # test thing
                widget.CurrentLayoutIcon(
                    #padding=0,
                    #scale=False,
                ),
            ],
            size=24,
            opacity=0.9,
            background="#2d2a2e",
            margin=5
        ),
    ) for _ in range(len(get_monitors()))
]

groups = [ Group(i) for i in "123456789" ]

# for screen in range(len(screens)):
#     for group in '123456789':
#         groups.append(
#             Group(
#                 name="{screen}-{group}".format(
#                     screen=screen,
#                     group=group
#                 ),
#                 screen_affinity=screen,
#                 label=group
#             )
#         )

for i in groups:
    keys.extend([
        # mod1 + letter of group = switch to group
        Key([mod], i.name, lazy.group[i.name].toscreen(),
            desc="Switch to group {}".format(i.name)),

        # mod1 + shift + letter of group = switch to & move focused window to group
        Key([mod, "shift"], i.name, lazy.window.togroup(i.name, switch_group=True),
            desc="Switch to & move focused window to group {}".format(i.name)),
        # Or, use below if you prefer not to switch to that group.
        # # mod1 + shift + letter of group = move focused window to group
        # Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
        #     desc="move focused window to group {}".format(i.name)),
    ])

# @subscribe.client_mouse_enter
# def change_screen_focus(c):
#     qtile.focus_screen(c.group.screen.index)


dgroups_key_binder = None
dgroups_app_rules = []  # type: List
follow_mouse_focus = False
bring_front_click = True
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class='confirmreset'),  # gitk
        Match(wm_class='makebranch'),  # gitk
        Match(wm_class='maketag'),  # gitk
        Match(wm_class='ssh-askpass'),  # ssh-askpass
        Match(title='branchdialog'),  # gitk
        Match(title='pinentry'),  # GPG key password entry
    ],
    border_normal="#2d2a2e",
    border_focus="#f85e84",

    border_width=2,
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"

@hook.subscribe.startup_once
def autostart():
    home = os.path.expanduser('~')
    subprocess.call([home + '/.config/qtile/autostart.zsh'])
