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

function histop
	history | awk '{print $2}' | sort | uniq -c | sort -nr | head -10
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
	sudo rm -rfv ~/.local/share/Trash/*
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

function list-updates
	echo "* Official updates *"
	checkupdates
	echo -e "\n* AUR Updates *"
	yay -Qua
end

# Create a backup of the given file
function backup-file --argument filename
	sudo cp $filename $filename.bak
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

############# Aliases & Abbreviations ############# 
alias grep='grep --color'

# Install date
abbr install-date 'stat -c %w / | cut -b 1-16'

# Fastfetch
abbr ff 'fastfetch'

# Process and journals
abbr psa 'ps auxf'
abbr psmem 'ps auxf | sort -nr -k 4'
abbr pscpu 'ps auxf | sort -nr -k 3'
abbr jctl 'journalctl -p 3 -xb'

# Patching
abbr patch-file 'diff -Naru'
abbr patch-dir 'diff -crB'

# LS
alias ls='eza -la --color=always --group-directories-first --icons'
alias la='eza -a --color=always --group-directories-first --icons'
alias ll='eza -l --color=always --group-directories-first --icons'
alias lt='eza -aT --color=always --group-directories-first --icons'

# PLocate
alias locate='plocate'

# Pacman
# abbr list-updates 'checkupdates; yay -Qua'
abbr clean-arch 'yay -Sc && yay -Yc'
abbr clean-orphans 'pacman -Qtdq | sudo pacman -Rns -'
abbr uninstall 'sudo pacman -Rns'
abbr update-mirrors 'sudo reflector --verbose --score 100 --latest 20 --fastest 5 --sort rate --save /etc/pacman.d/mirrorlist'
abbr fix-key 'sudo rm /var/lib/pacman/sync/* && sudo rm -rf /etc/pacman.d/gnupg/* && sudo pacman-key --init && sudo pacman-key --populate && sudo pacman -Sy --noconfirm archlinux-keyring && sudo pacman --noconfirm -Su'

# Rclone
abbr rcc 'rclone copy'

# Git & dev
abbr gcl 'git clone'
abbr gcm 'git commit -m'
abbr ga 'git add'
abbr gaa 'git add --all'
abbr gs 'git status'
abbr gst 'git stash'
abbr gp 'git push'
abbr gpl 'git pull'
abbr gdi 'git diff'
abbr gmr 'git merge'
abbr gco 'git checkout'
abbr gb 'git branch'
abbr gre 'git rebase'

alias py='python3'


# Zoxide
zoxide init --cmd cd fish | source