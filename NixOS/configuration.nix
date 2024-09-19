{ config, inputs, pkgs, ... }:

{
	nixpkgs.overlays = [(self: super: {
		changeBrightness = pkgs.writeScriptBin "changeBrightness" ''
#!/usr/bin/env bash
# changeBrightness

# Arbitrary but unique message tag
msgTag="mybrightness"

# Change the volume using alsa(might differ if you use pulseaudio)
# amixer -c 0 set Master "$@" > /dev/null

# Query amixer for the current volume and whether or not the speaker is muted
brightness=$(( $( brightnessctl get ) * 100 / 255 ))

# Show the volume notification
dunstify -a "changeBrightness" -u low -h string:x-dunst-stack-tag:$msgTag -h int:value:$brightness "Brightness: ''${brightness}%"
		'';
		changeVolume = pkgs.writeScriptBin "changeVolume" ''
#!/usr/bin/env bash
# changeVolume

# Arbitrary but unique message tag
msgTag="myvolume"

# Change the volume using alsa(might differ if you use pulseaudio)
# amixer -c 0 set Master "$@" > /dev/null

# Query amixer for the current volume and whether or not the speaker is muted
volume="$(wpctl get-volume @DEFAULT_AUDIO_SINK@)"

# Show the volume notification
dunstify -a "changeVolume" -u low -h string:x-dunst-stack-tag:$msgTag "''${volume}"
		'';
  	})];
	imports =
	[ # Include the results of the hardware scan.
	<nixos-hardware/asus/zephyrus/ga401>
	./hardware-configuration.nix
        ./unstable.nix
	<home-manager/nixos>
	];

	hardware = {
		graphics = {
			enable = true;
		};
		#bumblebee = {
		#	enable = true;
		#};
		#nvidiaOptimus.disable = true;
		nvidia = {
			package = config.boot.kernelPackages.nvidiaPackages.production;
			open = true;
			dynamicBoost.enable = false;
			powerManagement = {
				enable = true;
				finegrained = true;
			};
		};
	};

	fonts.packages = with pkgs; [
		noto-fonts
		noto-fonts-lgc-plus
		noto-fonts-cjk-sans
		noto-fonts-cjk-serif
		meslo-lgs-nf
		meslo-lg
		font-awesome
		ibm-plex
		dejavu_fonts
		noto-fonts-cjk
		noto-fonts-emoji
		liberation_ttf
		fira-code
		fira-code-symbols
		jetbrains-mono
	];

	home-manager.users.liz = { pkgs, ...}: {
		home.packages = with pkgs; [
			dunst
			libsForQt5.fcitx5-with-addons
                        wbg
			git-annex
			wl-clipboard-rs
                        mullvad-browser
                        way-displays
			vesktop
			foot
			brave
			firefox
			spotdl
			wmenu
			keepassxc
			hyfetch
			zathura
		];

		services = {
                        mpdris2 = {
                            enable = true;
                            notifications = true;
                        };
                        mpd = {
                            enable = true;
                            musicDirectory = "/home/liz/Music";
                            dbFile = "/home/liz/.config/mpd/database";
                            extraConfig = ''
                                audio_output {
                                    type    "pipewire"
                                    name    "Pipewire Sound Server"
                                }
                                
                            '';
                        };
			easyeffects = {
				enable = true;
			};
			dunst = {
				configFile = "/home/liz/.config/dunst/dunstrc";
			};
		};
		programs = {
                        foot = {
                            enable = true;
                            settings = {
                                main = {
                                    font="JetBrainsMono:size=10";
                                    font-bold="JetBrainsMono:size=10";
                                    font-italic="JetBrainsMono=12:slant=italic";
                                    font-bold-italic="JetBrainsMono=12:slant=italic";
                                    line-height="19px";
                                    letter-spacing=-1;
                                    underline-thickness="1px";
                                    pad="3x2";
                                };

                                colors = {
                                    foreground="cdd6f4"; # Text
                                    background="1e1e2e"; # Base
                                    regular0="45475a";   # Surface 1
                                    regular1="f38ba8";   # red
                                    regular2="a6e3a1";   # green
                                    regular3="f9e2af";   # yellow
                                    regular4="89b4fa";  # blue
                                    regular5="f5c2e7";   # pink
                                    regular6="94e2d5";   # teal
                                    regular7="bac2de";   # Subtext 1
                                    bright0="585b70";    # Surface 2
                                    bright1="f38ba8";    # red
                                    bright2="a6e3a1";    # green
                                    bright3="f9e2af";    # yellow
                                    bright4="89b4fa";    # blue
                                    bright5="f5c2e7";    # pink
                                    bright6="94e2d5";    # teal
                                    bright7="a6adc8";    # Subtext 0



                                    flash="7f7f00";
                                    flash-alpha=0.5;
                                    selection-foreground="c8c093";
                                    selection-background="2d4f67";
                                    scrollback-indicator="181616 0d0c0c";
                                    search-box-no-match="c5c9c5 c4746e";
                                    search-box-match="c5c9c5 181616";

                                    alpha=0.9;
                                };
                                cursor = {
                                    style="underline";
                                    color="181616 c5c9c5";
                                };

                            };
                        };

                        git = {
                            enable = true;
                            userName = "Elizabeth Sun";
                            userEmail = "andysun0402@gmail.com";
                        };
			neovim = {
				vimAlias = true;
				enable = true;
				coc.enable = true;
				plugins = with pkgs.vimPlugins; [
					vim-fugitive
					vimtex
					coc-vimtex
					ultisnips
					coc-ultisnips
					vim-snippets
					plenary-nvim
					telescope-nvim
					nvim-treesitter
					lightspeed-nvim
					goyo-vim
					limelight-vim
					tabular
					vim-json
					vim-pandoc-syntax
					vim-pandoc
					catppuccin-nvim
				];
				defaultEditor = true;
				extraConfig = ''
set nocompatible

set hidden

set wildmenu

set showcmd

set hlsearch

"set autoindent

set nostartofline

set ruler

set laststatus=2

set visualbell

set number

set cmdheight=2

set clipboard+=unnamedplus

set notimeout ttimeout ttimeoutlen=200

set pastetoggle=<F11>

set shiftwidth=4
set softtabstop=4
set expandtab

if exists("g:neovide")
    let g:neovide_cursor_trail_size = 0.5
    let g:neovide_refresh_rate_idle = 5
    let g:neovide_confirm_quit = v:true
    let g:neovide_cursor_vfx_mode = ""
    let g:neovide_cursor_animation_length=0.10
    let g:neovide_cursor_vfx_opacity = 200
    let g:neovide_cursor_vfx_particle_density = 200
    let g:neovide_cursor_vfx_particle_speed = 10.0
    let g:neovide_cursor_vfx_particle_phase = 1.5
    let g:neovide_cursor_vfx_particle_curl = 1.0
endif

setlocal spell
set spelllang=nl,en_gb
inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u

if has('filetype')
  filetype indent plugin on
endif

" Enable syntax highlighting
if has('syntax')
  syntax on
endif

if has('mouse')
  set mouse=a
endif

inoremap <C-BS> <C-w>
inoremap <M-Del> <cmd>norm! dw<CR>

set number

let g:tex_flavor='latex'
let g:vimtex_view_method = 'zathura'
let g:vimtex_quickfix_mode=0
"set conceallevel=1
let g:vimtex_view_general_options
    \ = '-reuse-instance -forward-search @tex @line @pdf'
let g:vimtex_quickfix_mode=0
"let g:vimtex_compiler_method = 'latexrun'
let g:vimtex_view_forward_search_on_start=1

let g:UltiSnipsExpandTrigger = '<tab>'
let g:UltiSnipsJumpForwardTrigger = '<tab>'
let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'

" disable math tex conceal feature
let g:tex_conceal = ""

if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu   | endif
  autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu                  | set nornu | endif
augroup END

colorscheme catppuccin-mocha


map Y y$
				'';
			};
			ncmpcpp = {
				enable = true;
				settings = {
mpd_host = "127.0.0.1";
mpd_port = 6600;
mpd_connection_timeout = "5";
mpd_crossfade_time = "5";
#execute_on_song_change  = "MediaControl nccover ; dunstify --replace=27072 -i /tmp/cover.png "Playing.." "$(mpc --format '%title% \n%artist%' current)""

#visualizer_data_source = /tmp/mpd.fifo;
#visualizer_output_name = my_fifo;

#visualizer_in_stereo = "yes";
#visualizer_fps = "60";
#visualizer_type = "ellipse";
#visualizer_look = ●●;
#visualizer_color = "33,39,63,75,81,99,117,153,189";
#visualizer_spectrum_smooth_look = "yes";

# GENERAL;
# ---;
connected_message_on_startup = "yes";
cyclic_scrolling = "yes";
mouse_support = "no";
mouse_list_scroll_whole_page = "yes";
lines_scrolled = "1";
message_delay_time = "1";
playlist_shorten_total_times = "yes";
playlist_display_mode = "columns";
browser_display_mode = "columns";
search_engine_display_mode = "columns";
playlist_editor_display_mode = "columns";
autocenter_mode = "yes";
centered_cursor = "yes";
user_interface = "classic";
follow_now_playing_lyrics = "yes";
locked_screen_width_part = "50";
ask_for_locked_screen_width_part = "yes";
display_bitrate = "no";
external_editor = "nano";
main_window_color = "default";
startup_screen = "playlist";

# PROGRESS BAR;
# ---;
#progressbar_look = "▪▪▪";
#progressbar_look =  "=>-";
progressbar_look = "▃▃▃";
progressbar_elapsed_color = "magenta";
progressbar_color = "black";

# UI VISIBILITY;
# ---;
header_visibility = "no";
statusbar_visibility = "yes";
titles_visibility = "yes";
enable_window_title = "yes";

# COLORS;
# ---;
statusbar_color = "white";
color1 = "white";
color2 = "blue";

# UI APPEARANCE;
# ---;
now_playing_prefix = "$b$2$7 ";
now_playing_suffix = "  $/b$8";
current_item_prefix = "$b$7$/b$3 ";
current_item_suffix = "  $8";

song_columns_list_format = "(50)[]{t|fr:Title} (0)[magenta]{a}";
song_list_format = " {%t $R   $8%a$8}|{%f $R   $8%l$8} $8";
song_status_format = "$b$2󰣐 $7 {$b$6$8 %t $6} $7 $8";
song_window_title_format = "Now Playing ..";
				};
			};
		};

		xdg.userDirs = {
			enable = true;
		};
		
		programs.waybar = {
			enable = true;
			settings = {
    mainBar = {	
			
	layer = "top";
        
	modules-left = ["river/tags" "river/mode" "river/layout" "mpd"];
	modules-right = ["network" "wireplumber" "temperature" "cpu" "memory" "battery" "tray" "clock"];

        "river/tags" = {
            "num-tags" = 9;
        };

	mpd = {
            tooltip = false;
            format = "{stateIcon} {title} - {artist} ({elapsedTime:%M:%S}/{totalTime:%M:%S})";
            format-disconnected = "";
            format-stopped = "";
            state-icons = {
                playing = "▶";
                paused = "";
            };
            on-click = "foot -m ncmpcpp";
	};

        tray = {
            tooltip = false;
            spacing = 10;
        };

        "river/mode" = {
            format = "{}";
            tooltip = false;
        };

        "river/layout" = {
            "format" = "{}";
            "tooltip" = false;
        };

        wireplumber = {
            tooltip = false;
            scroll-step = 5;
            format = "Volume: {volume}%";
        };

	network = {
            format-wifi = "{essid} ({signalStrength}%)";
            tooltip = false;
            format-ethernet = "{ifname}: {ipaddr}/{cidr}";
            format-disconnected = "Disconnected ⚠";
	};

	cpu = {
            tooltip = false;
            format = "CPU: {usage}%";
	};

	memory = {
            tooltip = false;
            format = " {}%";
	};

        battery = {
            bat = "BAT0";
            states = {
                warning = 30;
                critical = 15;
            };
            format = "{capacity}% {icon}";
            format-icons = ["" "" "" "" ""];
        };

        clock = {
            interval = 60;
            format = "{:%Y-%m-%d %H:%M}";
        };

        		};
};
			style = ''
/*
*
* Catppuccin Mocha palette
* Maintainer: rubyowo
*
*/

@define-color base   #1e1e2e;
@define-color mantle #181825;
@define-color crust  #11111b;

@define-color text     #cdd6f4;
@define-color subtext0 #a6adc8;
@define-color subtext1 #bac2de;

@define-color surface0 #313244;
@define-color surface1 #45475a;
@define-color surface2 #585b70;

@define-color overlay0 #6c7086;
@define-color overlay1 #7f849c;
@define-color overlay2 #9399b2;

@define-color blue      #89b4fa;
@define-color lavender  #b4befe;
@define-color sapphire  #74c7ec;
@define-color sky       #89dceb;
@define-color teal      #94e2d5;
@define-color green     #a6e3a1;
@define-color yellow    #f9e2af;
@define-color peach     #fab387;
@define-color maroon    #eba0ac;
@define-color red       #f38ba8;
@define-color mauve     #cba6f7;
@define-color pink      #f5c2e7;
@define-color flamingo  #f2cdcd;
@define-color rosewater #f5e0dc;

/* Global */
* {
  font-family: "JetBrainsMono";
  font-size: .9rem;
  border-radius: 1rem;
  transition-property: background-color;
  transition-duration: 0.5s;
  background-color: shade(@base, 0.9);
  color: @text;
}

@keyframes blink_red {
  to {
    background-color: @red;
    color: @base;
  }
}

/*
.warning, .critical, .urgent {
  animation-name: blink_red;
  animation-duration: 1s;
  animation-timing-function: linear;
  animation-iteration-count: infinite;
  animation-direction: alternate;
}
*/

/*
.warning, .critical, .urgent {
    background-color: @red;
    color: @base;
}
*/

#mode, #clock, #memory, #temperature, #cpu, #custom-weather,
#mpd, #idle_inhibitor, #backlight, #network, 
#battery, #custom-powermenu, #custom-cava-internal,
#custom-launcher, #tray, #disk, #custom-pacman, #custom-scratchpad-indicator, #wireplumber{
  padding-left: .6rem;
  padding-right: .6rem;
}

/* Bar */
window#waybar {
  background-color: transparent;
}

window > box {
  background-color: transparent;
  margin: .3rem;
  margin-bottom: 0;
}


/* Workspaces */
#tags:hover {
  color: @rosewater;
  border: none;
}

#mode {
    color: @sapphire;
    border: none;
}

#layout{
    color: @pink;
    border: none;
}

#tags button {
  padding-right: .4rem;
  padding-left: .4rem;
  padding-top: .1rem;
  padding-bottom: .1rem;
  color: @text;
  border: .2px solid transparent;
  background: @base;
}
#tags button:hover {
  border: .1rem solid @maroon;
}

#tags button.visible {

}

#tags button.focused {
    background-color: @base;
    color: @rosewater;
    border: .1rem solid @maroon;
}

#tags button.urgent {
    background-color: @sapphire;
}


/* Tooltip */
tooltip {
  background-color: @base;
}

tooltip label {
  color: @rosewater;
}

/* battery */
#battery {
  color: @mauve;
}
#battery.full {
  color: @green;
}
#battery.charging{
  color: @teal;
}
#battery.discharging {
  color: @peach;
}
#battery.critical:not(.charging) {
  color: @pink;
}
#custom-powermenu {
  color: @red;
}

/* mpd */
#mpd.paused {
    color: @pink;
    font-style: italic;
}
#mpd.stopped {
    color: @rosewater;
  /* background: transparent; */
}
#mpd {
    color: @rosewater;
}

/* Extra */
#custom-cava-internal{
    color: @peach;
    padding-right: 1rem;
}
#custom-launcher {
    color: @yellow;
}
#memory {
    color: @peach;
}
#cpu {
    color: @blue;
}
#clock {
    color: @rosewater;
}
#idle_inhibitor {
    color: @green;
}
#temperature {
    color: @sapphire;
}
#backlight {
    color: @green;
}

#wireplumber {
    color: @mauve;  /* not active */
}
#wireplumber.muted {
    color: @base;  /* not active */
    background-color: @red;
}


/*
#network {
    color: @pink; 
    padding-left .1rem;
}
*/
#network.ethernet, #network, #network.wifi {
    color: @pink;
}
#network.disconnected {
    color: @foreground;  /* not active */
}
#disk {
    color: @maroon;
}
#custom-pacman{
    color: @sky;
}
#custom-scratchpad-indicator {
    color: @yellow
}
#custom-weather {
    color: @red;
}
			'';
	};
		
		wayland.windowManager = {
                    
                    river = {
                        extraSessionVariables = {
                            MOZ_ENABLE_WAYLAND = "1";
                        };
                        enable = true;
                        extraConfig = ''
#!/bin/sh

riverctl spawn "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=river"
riverctl spawn "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=river"
riverctl spawn "pkill waybar"
riverctl spawn "pkill way-displays"
riverctl spawn "pkill hypridle"


riverctl spawn hyprpaper
riverctl spawn fcitx5
riverctl spawn 'easyeffects --gapplication-service'
riverctl spawn hypridle
riverctl spawn dunst
riverctl spawn waybar

riverctl spawn 'wideriver --inner-gaps 6 --outer-gaps 6 --layout left --stack even --smart-gaps --border-width 3 --border-color-focused 0xcba6f7 --border-color-unfocused 0x1e1e2e --ratio-master 0.55 --count-master 1'
riverctl rule-add -app-id firefox ssd
riverctl rule-add -app-id librewolf ssd
riverctl rule-add -app-id "Mullvad Browser" ssd
riverctl rule-add -app-id com.github.wwmm.easyeffects ssd



# Super+Shift+Return to start an instance of foot (https://codeberg.org/dnkl/foot)
riverctl map normal Alt+Shift Return spawn foot
riverctl map normal Alt P spawn 'wmenu-run -n cdd6f4 -N 1e1e2e -m f38ba8 -M 1e1e2e -s f9e2af -S 1e1e2e'
riverctl map normal Alt+Shift R spawn '/home/liz/.config/river/init'
# Super+Q to close the focused view
riverctl map normal Alt+Shift C close

# Super+Shift+E to exit river
riverctl map normal Alt+Shift Q exit

# Super+J and Super+K to focus the next/previous view in the layout stack
riverctl map normal Alt J focus-view next
riverctl map normal Alt K focus-view previous

# Super+Shift+J and Super+Shift+K to swap the focused view with the next/previous
# view in the layout stack
riverctl map normal Super+Shift J swap next
riverctl map normal Super+Shift K swap previous

# Super+Period and Super+Comma to focus the next/previous output
riverctl map normal Alt Period focus-output next
riverctl map normal Alt Comma focus-output previous

# Super+Shift+{Period,Comma} to send the focused view to the next/previous output
riverctl map normal Alt+Shift Period send-to-output next
riverctl map normal Alt+Shift Comma send-to-output previous

# Super+Return to bump the focused view to the top of the layout stack
riverctl map normal Alt Return zoom

riverctl map normal Alt H send-layout-cmd wideriver '--ratio -0.05'
riverctl map normal Alt L send-layout-cmd wideriver '--ratio +0.05'

riverctl map normal Alt I send-layout-cmd wideriver '--count +1'
riverctl map normal Alt D send-layout-cmd wideriver '--count -1'

# Super+Alt+{H,J,K,L} to move views
#riverctl map normal Super+Alt H move left 100
#riverctl map normal Super+Alt J move down 100
#riverctl map normal Super+Alt K move up 100
#riverctl map normal Super+Alt L move right 100

# Super+Alt+Control+{H,J,K,L} to snap views to screen edges
#riverctl map normal Super+Alt+Control H snap left
#riverctl map normal Super+Alt+Control J snap down
#riverctl map normal Super+Alt+Control K snap up
#riverctl map normal Super+Alt+Control L snap right

# Super+Alt+Shift+{H,J,K,L} to resize views
#riverctl map normal Super+Alt+Shift H resize horizontal -100
#riverctl map normal Super+Alt+Shift J resize vertical 100
#riverctl map normal Super+Alt+Shift K resize vertical -100
#riverctl map normal Super+Alt+Shift L resize horizontal 100

# Super + Left Mouse Button to move views
riverctl map-pointer normal Super BTN_LEFT move-view

# Super + Right Mouse Button to resize views
riverctl map-pointer normal Super BTN_RIGHT resize-view

# Super + Middle Mouse Button to toggle float
#riverctl map-pointer normal Super BTN_MIDDLE toggle-float

for i in ''$(seq 1 9)
do
    tags=''$((1 << ($i - 1)))

    # Super+[1-9] to focus tag [0-8]
    riverctl map normal Alt ''$i set-focused-tags ''$tags

    # Super+Shift+[1-9] to tag focused view with tag [0-8]
    riverctl map normal Alt+Shift ''$i set-view-tags ''$tags

    # Super+Control+[1-9] to toggle focus of tag [0-8]
    riverctl map normal Alt+Control ''$i toggle-focused-tags ''$tags

    # Super+Shift+Control+[1-9] to toggle tag [0-8] of focused view
    riverctl map normal Alt+Shift+Control ''$i toggle-view-tags ''$tags
done

# Super+0 to focus all tags
# Super+Shift+0 to tag focused view with all tags
all_tags=''$(((1 << 32) - 1))
riverctl map normal Alt 0 set-focused-tags ''$all_tags
riverctl map normal Alt+Shift 0 set-view-tags ''$all_tags

# Super+Space to toggle float
riverctl map normal Alt Space toggle-float
riverctl map float Alt Space toggle-float

riverctl map normal Alt M send-layout-cmd wideriver '--layout monocle'
riverctl map normal Super Up    send-layout-cmd wideriver '--layout top'
riverctl map normal Super Right send-layout-cmd wideriver '--layout right'
riverctl map normal Super Down  send-layout-cmd wideriver '--layout bottom'
riverctl map normal Alt T  send-layout-cmd wideriver '--layout left'

# Declare a passthrough mode. This mode has only a single mapping to return to
# normal mode. This makes it useful for testing a nested wayland compositor
riverctl declare-mode passthrough

# Super+F11 to enter passthrough mode
riverctl map normal Super F11 enter-mode passthrough

# Super+F11 to return to normal mode
riverctl map passthrough Super F11 enter-mode normal

# Various media key mapping examples for both normal and locked mode which do
# not have a modifier
for mode in normal locked
do
    # Control pulse audio volume with pamixer (https://github.com/cdemoulins/pamixer)
    riverctl map $mode None XF86AudioRaiseVolume  spawn 'wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ && changeVolume'
    riverctl map $mode None XF86AudioLowerVolume  spawn 'wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- && changeVolume'
    riverctl map $mode None XF86AudioMute         spawn 'wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle && changeVolume'

    # Control MPRIS aware media players with playerctl (https://github.com/altdesktop/playerctl)
    riverctl map $mode None XF86AudioPlay  spawn 'playerctl play-pause'
    riverctl map $mode None XF86AudioPrev  spawn 'playerctl previous'
    riverctl map $mode None XF86AudioNext  spawn 'playerctl next'

    # Control screen backlight brightness with brightnessctl (https://github.com/Hummer12007/brightnessctl)
    riverctl map $mode None XF86MonBrightnessUp   spawn 'brightnessctl set +5% && changeBrightness'
    riverctl map $mode None XF86MonBrightnessDown spawn 'brightnessctl set 5%- && changeBrightness'
    riverctl map $mode Super L spawn 'systemctl hibernate'
done

riverctl declare-mode float
riverctl map normal Alt F enter-mode float		# Super+R to enter float mode
 
### Floating window mappings but note that these also apply to tiled windows.
#
# Super {Arrows} to move views
  riverctl map float Super Left move left 100
  riverctl map float Super Down move down 100
  riverctl map float Super Up move up 100
  riverctl map float Super Right move right 100
 
# Alt+{arrows} to snap views to screen edges
  riverctl map float Alt Left snap left
  riverctl map float Alt Down snap down
  riverctl map float Alt Up snap up
  riverctl map float Alt Right snap right
 
# Shift+{arrows} to resize views
riverctl map float Shift Left resize horizontal -100
riverctl map float Shift Down resize vertical 100
riverctl map float Shift Up resize vertical -100
riverctl map float Shift Right resize horizontal 100
 
riverctl map float Alt F enter-mode normal	# Escape to exit float mode and return to normal mode

#riverctl background-color 0x002b36
#riverctl border-color-focused 0x93a1a1
#riverctl border-color-unfocused 0x586e75

riverctl set-repeat 50 300

#riverctl rule-add -app-id 'float*' -title 'foo' float

riverctl rule-add -app-id 'bar' csd

# Set the default layout generator to be rivertile and start it.
# River will send the process group of the init executable SIGTERM on exit.
riverctl default-layout wideriver 
riverctl spawn 'way-displays > /tmp/way-displays.''${XDG_VTNR}.''${USER}.log 2>&1'
way-displays > /tmp/way-displays.''${XDG_VTNR}.''${USER}.log 2>&1 &
                        '';
                    };
                };
                
		home.stateVersion = "24.05";
		};

	systemd = {
		services = {
			supergfxd.path = [ pkgs.pciutils ];
		};
	};

	services = {
		xserver.videoDrivers = ["nvidia"];
		supergfxd = {
			enable = true;
			settings = {
				
				mode = "Integrated";
				vfio_enable = true;
				vfio_save = true;
				always_reboot = false;
				no_logind = true;
				logout_timeout_s = 180;
				hotplug_type = "Asus";
				
			};
		};
		asusd = {
			enable = true;
			enableUserService = true;
		};
		auto-cpufreq.enable = true;
		auto-cpufreq.settings = {
			battery = {
				governor = "powersave";
				turbo = "never";
			};
			charger = {
				governor = "performance";
				turbo = "auto";
			};
		};
		udisks2.enable = true;
		dbus.enable = true;
		pipewire = {
			enable = true;
			audio.enable = true;
			wireplumber.enable = true;
			alsa = {
				enable = true;
				support32Bit = true;
			};
			pulse.enable = true;
			jack.enable = true;
		};
	};

	sound = {
		mediaKeys = {
			enable = true;
			volumeStep = "2%";
		};
	};

	security = {
		polkit.enable = true;
		rtkit.enable = true;
	};

	programs.zsh.enable = true;

	powerManagement = {
		powertop = {
			enable = true;
		};
		enable = true;
	};
	environment = {
		systemPackages = with pkgs; [
			brightnessctl
                        psmisc
                        sbctl
                        gnome.adwaita-icon-theme
			powertop
			changeBrightness
			changeVolume
			wget		
			htop
			libnotify
			libmpdclient
			wireplumber
			btop
			neovim
			catppuccin-qt5ct
			pwvucontrol
			catppuccin-gtk
			libsForQt5.sddm
			ripgrep
			fd
			pstree
			lf
			htop
			acpi
			zsh-completions
			git
		];
		sessionVariables = {
			NIXOS_OZONE_WL = "1";
                        XKB_DEFAULT_OPTIONS=caps:escape;
		};
		pathsToLink = ["/share/zsh"];
		variables = {
			TERMINAL = "foot";
			EDITOR = "nvim";
			VISUAL = "nvim";
		};
	};

	xdg.portal = {
                enable = true;
                wlr.enable = true;
		config = {
			common = {
                            default = [
                                "gtk"
                            ];
			};
		};
	};

	#nix.settings.experimental-features = [ "nix-command" "flakes" ];
	#nix = {
	#	package = pkgs.nixFlakes;
	#};

	# Bootloader.
	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;

	boot.initrd.luks.devices."luks-c74d8b1c-5902-4257-982d-c93be6f4d3ec".device = "/dev/disk/by-uuid/c74d8b1c-5902-4257-982d-c93be6f4d3ec";
	networking.hostName = "koneko"; # Define your hostname.
	# networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

	# Configure network proxy if necessary
	# networking.proxy.default = "http://user:password@proxy:port/";
	# networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

	# Enable networking
	networking.networkmanager.enable = true;

	# Set your time zone.
	time.timeZone = "America/Los_Angeles";

	# Select internationalisation properties.
	i18n.defaultLocale = "en_US.UTF-8";

	i18n.extraLocaleSettings = {
		LC_ADDRESS = "en_US.UTF-8";
		LC_IDENTIFICATION = "en_US.UTF-8";
		LC_MEASUREMENT = "en_US.UTF-8";
		LC_MONETARY = "en_US.UTF-8";
		LC_NAME = "en_US.UTF-8";
		LC_NUMERIC = "en_US.UTF-8";
		LC_PAPER = "en_US.UTF-8";
		LC_TELEPHONE = "en_US.UTF-8";
		LC_TIME = "en_US.UTF-8";
	};
	i18n.inputMethod = {
		enabled = "fcitx5";
		fcitx5 = {
			addons = with pkgs; [
				fcitx5-mozc
				fcitx5-gtk
				fcitx5-rime
			];
			waylandFrontend = true;
		};
	};

	# Configure keymap in X11
	#services.xserver.xkb = {
	#	layout = "us";
	#    xkbVariant = "";
	#};

	# Define a user account. Don't forget to set a password with ‘passwd’.
	users.users.liz = {
		isNormalUser = true;
		description = "Elizabeth";
		extraGroups = [ "networkmanager" "wheel" "audio" "input" "storage" "video" "users" "mpd" ];
		packages = with pkgs; [];
	};

	# Allow unfree packages
	nixpkgs.config.allowUnfree = true;
	programs = {
		dconf.enable = true;
	};

	# List packages installed in system profile. To search, run:
	# $ nix search wget

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
	system.stateVersion = "24.05"; # Did you read the comment?
}
