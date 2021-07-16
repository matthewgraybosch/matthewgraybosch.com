---
layout: post
title: "XTerm: Because Worse is Better"
description: "There's no shortage of terminal emulators available for GNU/Linux and BSD, but I don't bother with them because XTerm is good enough."
---

Ever since I started using OpenBSD back in 2017, I've used XTerm whenever I needed a shell prompt. It's not that I can't use other terminal emulators; there are plenty packaged for OpenBSD. There's also Kitty. I could even build my own version of the simple terminal. I just can't be bothered.

Yes, they might all be better than XTerm. For example, Kitty renders with OpenGL, so if you've got a fancy graphics card actions like scrolling should be buttery-smooth. Unlike these other terminal emulators, XTerm comes with OpenBSD as part of its X Window System package, Xenocara.

It's not just OpenBSD, incidentally. If your GNU/Linux distribution still installs X by default instead of Wayland, you probably have XTerm. Bruno Garcia [recently discovered this for himself][1]:

> It was surprising to learn that xterm is still very much actively developed. Even more surprisingly, it turns out xterm has incredibly low input latency compared to modern terminals. This is easy to test at home, try typing in xterm compared to any other terminal and feel how much snappier it is.

> The lower latency alone is worth the price of admission in my opinion, so I went about configuring xterm as my default terminal. The configuration goes in ~/.Xresources and you need to run xrdb ~/.Xresources after every change, or make vim do it.

After sharing his config, Garcia notes that XTerm does have a few "missing features".

> * Text reflow when the terminal is resized.
> * Fallback fonts don't seem to always work. Maybe I'm missing a config option?
> * Transparency not natively supported. I don't care about transparency but maybe it's important to some people.
> * Occasionally strange flickering with picom, possibly a bug with picom?

I'm not sure what to do about the text reflow issue myself, so I just live with it. I haven't tried setting up fallback fonts, either. I just use Noto Sans Mono and hope for the best.

For readers not familiar with picom, it's a lightweight compositor for X11 forked from compton (which is in turn a descendent of xcompmgr). While I find translucent windows distracting, it's possible to set up rules in your config file for picom for all windows or specific windows (like XTerm). Also, I've also noticed occasional weird flickers while using picom, but in my case they went away after I started using vertical sync.

If anybody's interested, here's how I start up picom in my ~/.xsession file.

```shell
picom --fading --vsync --use-ewmh-active-win --daemon
```

Likewise, here is my ~/.Xresources file. It's where I configure XTerm, xclock, xidle, xlock, and my font and geometry for Emacs.

```Xresources
! ===== Colors
! Base16 OceanicNext
! Scheme: https://github.com/voronianski/oceanic-next-color-scheme

#define base00 #1b2b34
#define base01 #343d46
#define base02 #4f5b66
#define base03 #65737e
#define base04 #a7adba
#define base05 #c0c5ce
#define base06 #cdd3de
#define base07 #d8dee9
#define base08 #ec5f67
#define base09 #f99157
#define base0A #fac863
#define base0B #99c794
#define base0C #5fb3b3
#define base0D #6699cc
#define base0E #c594c5
#define base0F #ab7967

*foreground: base05
#ifdef background_opacity
        *background: background_opacitybase00
#else
        *background: base00
#endif
*cursorColor: base05

*color0: base00
*color1: base08
*color2: base0B
*color3: base0A
*color4: base0D
*color5: base0E
*color6: base0C
*color7: base05
*color8: base03
*color9: base08
*color10: base0B
*color11: base0A
*color12: base0D
*color13: base0E
*color14: base0C
*color15: base07
*color16: base09
*color17: base0F
*color18: base01
*color19: base02
*color20: base04
*color21: base06

! ===== cursors
Xcursor.size: 32

! ===== fonts
Xft.dpi: 200
Xft.autohint: 0
Xft.lcdfilter: lcddefault
Xft.hintstyle: hintslight
Xft.hinting: 1
Xft.antialias: 1
Xft.rgba: rgb
*faceName: Noto Mono
*faceSize: 12
*renderFont: true

! ===== xidle
XIdle*position: sw
XIdle*delay: 1
XIdle*timeout: 300

! ===== xlock
XLock.dpmsoff: 1
XLock.description: off
XLock.echokeys: off
XLock.info: Judicial warrant or GTFO.
XLock.background: base00
XLock.foreground: base05
XLock.mode: blank
XLock.username: username: 
XLock.password: password: 
XLock.font: -*-spleen-*-*-*-*-32-*-*-*-*-*-*-*
XLock.planfont: -*-spleen-*-*-*-*-24-*-*-*-*-*-*-*

! ===== xclock
XClock*analog: false
XClock*twentyfour: true
XClock*padding: 1
XClock*font: -*-spleen-*-*-*-*-24-*-*-*-*-*-*-*
XClock*background: base00
XClock*foreground: base05
XClock*borderWidth: 1

! ===== XTerm settings
xterm*geometry: 80x24
xterm*borderWidth: 0
xterm*internalBorder: 10
xterm*termName: xterm-256color
xterm*vt100.metaSendsEscape: true
xterm*v100.saveLines: 32768
xterm*vt100.scrollBar: false
xterm*vt100.bellIsUrgent: true
xterm*allowBoldFonts: false
xterm*scrollKey: true
xterm*fullscreen: never
xterm*cutToBeginningOfLine: false
xterm*cutNewline: false
xterm*charClass: 33:48,36-47:48,58-59:48,61:48,63-64:48,95:48,126:48
xterm*on2Clicks: word
xterm*on3Clicks: line
xterm*utf8: 1

! ===== GNU Emacs settings
Emacs*geometry: 80x24
Emacs*font: Noto Mono-12:dpi=200:antialias=true:autohint=true
Emacs*toolBar: off
```

I got the color stuff from terminal.sexy, a web app that allows you to preview color schemes for terminals and export them in various formats.

One thing about the way I configured my font for Emacs: the "dpi=200" part of my font string works for me since I use the chill window manager that comes with OpenBSD instead of bothering with i3, XFCE, MATE, GNOME, etc. GNOME in particular has its own way of implementing HiDPI support that doesn't necessarily play nicely with ~/.Xresources or ~/.config/fontconfig/fonts.conf, but the GNOME people are targeting GNU/systemd so I'm not really in their target demographic to begin with.

Feel free to get in touch if you have any questions or suggestions.


## PS

If you're wondering why I bothered to install GNU Emacs when OpenBSD comes with ed, vi, and a tiny Emacs-like editor called mg:

* I regularly use ed, vi, and mg for sysadmin work.
* I also use vi when importing text from my AlphaSmart 3000.
* I've been using GNU Emacs for decades, and find it preferable for writing fiction and for doing any sort of web development.


[1]: https://aduros.com/blog/xterm-its-better-than-you-thought/
