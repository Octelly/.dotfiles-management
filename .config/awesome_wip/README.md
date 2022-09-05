# AwesomeWM config rewrite

- better readibility
- better code organisation
- new rice

Structure based on [JavaCafe's dotfiles](https://github.com/JavaCafe01/dotfiles/tree/master/config/awesome), primarily because the inner working of Awesome are still a lowkey mystery to me.

I plan to implement [this awesome-widgets module](https://github.com/andOrlando/awesome-widgets), particularly its recycler, which is nicely animated and should make my client lists work well.

The general goal is to fix many functional issues of my current setup while also finally changing up the style a bit after years of mostly rocking the same general colour scheme.

## Dev

```sh
Xephyr -br -ac -noreset -screen 1600x900 :2
DISPLAY=:2 awesome -c rc.lua  # in awesome_wip directory
```
