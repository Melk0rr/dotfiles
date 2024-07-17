oh-my-posh init fish --config ~/.config/oh-my-posh/omp.json | source


############# Functions ############# 
# Fish greeting message
function fish_greeting
	fastfetch
end

# Print fish history
function history
	builtin history --show-time='%F %T'
end

# Clear fish history
function clear-fish-history
	echo 'Clearing fish history...'
	rm -fv ~/.local/share/fish/fish_history
	sudo rm -fv /root/.local/share/fish/fish_history
	rm -fv ~/.config/fish/fish_history
	sudo rm -fv /root/.config/fish/fish_history
end

# Empty trash directories
function empty-trash
	echo 'Emptying trash...'
	
	# Global trash
	rm -rfv ~/.local/share/Trash/*
	sudo rm -rfv /root/.local/share/Trash/*
end

# Clear temporary files
function clear-temp
	echo 'Clearing temporary files...'
	sudo rm -rfv /tmp/*
	sudo rm -rfv /var/tmp/*
end

# Clear crash reports
function clear-crash-reports
	echo 'Clearing crash reports...'
	sudo rm -rfv /var/crash/*
	sudo rm -rfv /var/lib/systemd/coredump/
end

# Clear system logs
function clear-syslogs
	echo 'Clearing system logs...'
	if ! command -v 'journalctl' &> /dev/null
		echo 'Skipping because journalctl was not found'
	else
		sudo journalctl --vacuum-time=1s
	end

	sudo rm -rfv /run/log/journal/*
	sudo rm -rfv /var/log/journal/*
end

# Combined cleanup
function cleanup
	empty-trash
	clear-temp
	clear-crash-reports
	clear-syslogs
end

# Create a backup of the given file
function backup-file --argument filename
	sudo cp $filename $filename.bak
end

# Update sddm theme based on current theme
function sddm-theme
	source "$HOME/.config/hyde/hyde.conf"
	echo $sddmTheme
	# set --local count (count $argv | tr -d \n)
	# if test "$count" = 1
	# 	set theme (echo $argv[1])
	# else
	# 	set theme "corners"
	# end

	# sudo cp "$HOME/.config/sddm/faces/$theme.face.icon" /usr/share/sddm/faces/me1k0r.face.icon
	# sudo cp "$HOME/.config/sddm/themes/corners/$theme/theme.conf" /usr/share/sddm/themes/corners/theme.conf
end

# Copy file
function copy
	set count (count $argv | tr -d \n)
	if test "$count" = 2; and test -d "$argv[1]"
		set from (echo $argv[1] | trim-right /)
		set to (echo $argv[2])
		command cp -r $from $to
	else
		command cp $argv
	end
end

if status is-interactive
    # Commands to run in interactive sessions can go here
end

############# Aliases ############# 
alias grep='grep --color'
alias install-date='stat -c %w / | cut -b 1-16'

# Process and journals
alias psa='ps auxf'
alias psmem='ps auxf | sort -nr -k 4'
alias pscpu='ps auxf | sort -nr -k 3'
alias jctl='journalctl -p 3 -xb'

# LS
alias ls='eza -la --color=always --group-directories-first --icons'
alias la='eza -a --color=always --group-directories-first --icons'
alias ll='eza -l --color=always --group-directories-first --icons'
alias lt='eza -aT --color=always --group-directories-first --icons'

# Pacman
alias update-arch='yay'
alias list-updates='checkupdates; yay -Qua'
alias clean-arch='yay -Sc && yay -Yc'
alias clean-orphans='pacman -Qtdq | sudo pacman -Rns -'
alias uninstall='sudo pacman -Rns'
alias update-mirrors='sudo reflector --verbose --score 100 --latest 20 --fastest 5 --sort rate --save /etc/pacman.d/mirrorlist'
alias fix-key='sudo rm /var/lib/pacman/sync/* && sudo rm -rf /etc/pacman.d/gnupg/* && sudo pacman-key --init && sudo pacman-key --populate && sudo pacman -Sy --noconfirm archlinux-keyring && sudo pacman --noconfirm -Su'

# Git & dev
alias gcl='git clone'
alias gcm='git commit -m'
alias ga='git add'
alias gaa='git add --all'
alias gst='git status'
alias gpsh='git push'
alias gpll='git pull'
alias gdi='git diff'
alias gmr='git merge'
alias gck='git checkout'
alias gbr='git branch'

alias py='python3'