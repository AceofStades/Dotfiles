# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

export ZSH="$HOME/.oh-my-zsh"
export EDITOR='nvim'
export VISUAL='nvim'
export XCURSOR_SIZE=22
export XCURSOR_THEME=macOS
export GPG_TTY=$(tty)

# ZSH_THEME="random"
ZSH_THEME="eastwood"
# source $ZSH/themes/random.zsh-theme &>/dev/null   #Does the same work as above without printing random theme generated text

plugins=( 
    git
    archlinux
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# Check archlinux plugin commands here
# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/archlinux


# Display Pokemon-colorscripts
# Project page: https://gitlab.com/phoneybadger/pokemon-colorscripts#on-other-distros-and-macos
pokemon-colorscripts --no-title -s -r


### From this line is for pywal-colors
# Import colorscheme from 'wal' asynchronously
# &   # Run the process in the background.
# ( ) # Hide shell job control messages.
# Not supported in the "fish" shell.
#(cat ~/.cache/wal/sequences &)

# Alternative (blocks terminal for 0-3ms)
#cat ~/.cache/wal/sequences

# To add support for TTYs this line can be optionally added.
#source ~/.cache/wal/colors-tty.sh

# alias manga='manga-cli -p'
# alias anime='ani-cli'
alias update='yay -Syu'
alias n='nvim'
alias :q='exit'
alias obsidian="obsidian --enable-features=UseOzonePlatform --ozone-platform=wayland"
alias c='code-insiders --ozone-platform=wayland'
alias sn='sudo nvim'
alias timeshift='sudo timeshift'
alias z="zeditor"
alias icat='kitten icat'
alias syscoms="ssh -i ~/.ssh/iitm 23f2005427@se2001.ds.study.iitm.ac.in"
alias open='xdg-open'

function run() {
  # Get the filename and extension
  filename="$1"
  extension="${filename##*.}"

  # Check if file exists
  if [ ! -f "$filename" ]; then
    echo "Error: File '$filename' does not exist."
    return 1
  fi

  # Compile based on extension
  case "$extension" in
    cpp)
      g++ -o "${filename%.*}" "$filename" && ./"${filename%.*}"
      ;;
    c)
      gcc -o "${filename%.*}" "$filename" && ./"${filename%.*}"
      ;;
    *)
      echo "Error: Unsupported file extension '$extension'."
      ;;
  esac
}

export PATH=$PATH:/home/aceofstades/.spicetify:/home/aceofstades/.cargo/bin:/home/aceofstades/.local/bin


# # --- Start SSH Agent and Add Keys ---
# # This block will automatically start the SSH agent and load keys.
#
# # Only run if a new SSH agent is not already active.
# if ! pgrep -u "$USER" ssh-agent > /dev/null; then
#   # Start the agent
#   eval "$(ssh-agent -s)"
#
#   # Loop through all private keys in ~/.ssh and add them if not already loaded.
#   # The find command looks for files that are not directories and do not end with .pub
#   for key in $(find ~/.ssh -maxdepth 1 -type f ! -name "*.pub"); do
#     # Check if the key is already loaded to avoid adding it multiple times
#     if ! ssh-add -l | grep -q "$(ssh-keygen -lf "$key" | awk '{print $2}')"; then
#       # Add the key to the agent
#       ssh-add "$key"
#     fi
#   done
# fi
# # --- End SSH Agent and Add Keys ---
