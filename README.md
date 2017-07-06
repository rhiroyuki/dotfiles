# dotfiles
Most of my files are from [campuscode dotfiles](https://github.com/campuscode/cc_dotfiles)

- Antigen for zsh theme and plugins
- Vundle for vim

Make sure to install gvim instead of vim to enable clipboard function

# Vim navigation tips
## Jumping lines
Moving up and down one line: j, k  
First line g  
Last line G  
Line number 8gg  
Top of the screen: H  
Middle of the screen: M  
Bottom of the screen: L  

## Screen shifting
Line to top: zz  
To middle: zt  
To bottom: zb  
Scroll one line: <C y> and <C e>  
Scroll half page: <C u> and <C d>  
Scroll full page: <C b> and <C f>  

## Within a Line
Beginning of line: 0  
First char of line: ^  
End of line: $  
Last char on line: g_  

word: ends at non-word character, such as '.', '-', ')'  
WORD: ends at white-space stricly  

## Paragraphs
Start the current paragraph {
End of the current paragrah }

# to do
- keymap for vim and tmux
- install.sh
- uninstall.sh
