source /usr/share/fish/config.fish
oh-my-posh init fish --config ~/.config/oh-my-posh/arch.omp.json | source

# Functions
function fish_greeting
	neofetch
end

if status is-interactive
    # Commands to run in interactive sessions can go here
end

#Functions
function history
	builtin history --show-time='%F %T'
end

function backup --argument filename
	cp $filename $filename.bak
end

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


# Aliases
alias ls='eza -la --color=always --group-directories-first --icons'
alias la='eza -a --color=always --group-directories-first --icons'
alias ll='eza -l --color=always --group-directories-first --icons'
alias lt='eza -aT --color=always --group-directories-first --icons'

alias update-arch='yay'
alias clean-arch='yay -sC && yay -Yc'
alias update-mirrors='sudo reflector --verbose --score 100 --latest 20 --fastest 5 --sort rate --save /etc/pacman.d/mirrorlist'
alias fix-key='sudo rm /var/lib/pacman/sync/* && sudo rm -rf /etc/pacman.d/gnupg/* && sudo pacman-key --init && sudo pacman-key --populate && sudo pacman -Sy --noconfirm archlinux-keyring && sudo pacman --noconfirm -Su'
alias grep='grep --color'
