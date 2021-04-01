#!/bin/sh

title=$(cmus-remote -Q | rg "title" | sed 's/tag title //')
album=$(cmus-remote -Q | rg "album " | sed 's/tag album //')
artist=$(cmus-remote -Q | rg "albumartist " | sed 's/tag albumartist //')
number=$(cmus-remote -Q | rg "tracknumber" | sed 's/tag tracknumber //')
volume="VOL:$(cmus-remote -Q | rg "vol_right" | sed 's/set vol_right //')"
[ $(cmus-remote -C "set shuffle?" | sed "s/.*=// ; s/'//") = "true" ] && shuffle="Shuffle" || shuffle="No shuffle"
[ $(cmus-remote -C "set repeat_current?" | sed "s/.*=// ; s/'//") = "true" ] && repeat="Repeat" || repeat="No repeat"
[ $(cmus-remote -Q | rg "status" | sed "s/status //") = "playing" ] && status="Playing" || status="Paused"
info=$(echo "$artist - $title/$album:$number 🔈$volume% $shuffle$status$repeat")

cat <<EOF | xmenu | sh &
Applications
	Terminals
		st	st
		xterm	xterm
		alacritty	alacritty
	Emacs
		dired	emacsclient -c -e '(dired nil)'
		elfeed	emacsclient -c -e '(elfeed)'
		ibuffer	emacsclient -c -e '(ibuffer)'
	Web browsers
		Firefox	firefox
		Chromium	chromium
	Discord	discord
	Calculator	qalculate-gtk

Dwm
	Layouts	layoutmenu.sh
Dmenu scripts
	Dmenu	dmenu_run -l 5 -g 10 -p 'Run:'
	Volume	volume-script
	Edit configs	Booky 'emacsclient -c -a emacs' '><' 'Cconfig'
	Bookmarks	Booky 'firefox' ':' 'Bconfig'
	Music	music-changer cmus
	Switch	switch
	Emojis	emoji-script
	Calculator	calc
	Passmenu	passmenu2 -F -p 'Passwords:'
	Man pages	manview
	Allmenu	allemnu
	Shut	shut

Cmus
	$artist	music-changer queue
	$title/$album:$number	music-changer play
	$volume	dmenu < /dev/null -p "$info" -fn "mononoki nerd font:pixelsize=19:antialias=true:autohint=true" | xargs -I {} cmus-remote -v '{}'%
	$status	[ "$status" = "Playing" ] && cmus-remote -u || cmus-remote -p
	$repeat	cmus-remote -C "toggle repeat_current"
	$shuffle	cmus-remote	-S

Shutdown		loginctl poweroff
Reboot			loginctl reboot
EOF

# Applications
# 	IMG:./icons/web.png	Web Browser	firefox
# 	IMG:./icons/gimp.png	Image editor	gimp
# Terminal (xterm)	xterm
# Terminal (urxvt)	urxvt
# Terminal (st)		st
