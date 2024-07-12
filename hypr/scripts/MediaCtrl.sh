#!/bin/bash
## /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# Playerctl

music_icon="$HOME/.config/swaync/icons/music.png"

# Play the next track
play_next() {
    playerctl next --player=spotify
    # show_music_notification
}

# Play the previous track
play_previous() {
    playerctl previous --player=spotify
    # show_music_notification
}

# Toggle play/pause
toggle_play_pause() {
    playerctl play-pause --player=spotify
    show_music_notification
}

# Stop playback
stop_playback() {
    playerctl stop --player=spotify
    notify-send -e -u low -i "$music_icon" "Playback Stopped"
}

# Display notification with song information
show_music_notification() {
	sleep 0.02
    status=$(playerctl status --player=spotify)
    if [[ "$status" == "Playing" ]]; then		# This was supposed the playing but doesn't work with playerctl/spotify
        song_title=$(playerctl metadata title --player=spotify)
        song_artist=$(playerctl metadata artist --player=spotify)
        notify-send -e -u low -i "$music_icon" "Now Playing:" "$song_title\nby $song_artist"
    elif [[ "$status" == "Paused" ]]; then		# This was supposed the paused but doesn't work with playerctl/spotify
        notify-send -e -u low -i "$music_icon" "Playback Paused"
    fi
}

# Get media control action from command line argument
case "$1" in
    "--nxt")
        play_next
        ;;
    "--prv")
        play_previous
        ;;
    "--pause")
        toggle_play_pause
        ;;
    "--stop")
        stop_playback
        ;;
    *)
        echo "Usage: $0 [--nxt|--prv|--pause|--stop]"
        exit 1
        ;;
esac
