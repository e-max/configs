
is_private()
{
	if [[ "$HISTFILE" = "" ]]
	then
		echo "{private}"
	fi
}

private_color()
{
	if [[ "$HISTFILE" = "" ]]
	then
		echo -e "${c_magenta}"
	fi
}

# я не могу просто использовать эту функцию в конце PS1 потому что 
# в процессе формирования PS1 строки я вызываю git и т.е. и $? перезатирается
# поэтому я сначала формирую символ, а потом печатаю

PROMPT_COMMAND='exit_code=$?'

exit_color() {
  if [ "$exit_code" == "0" ]; then
	echo ""
  else
	echo -e "${c_red}"
  fi
}
exit_symbol() {
  if [ "$exit_code" == "0" ]; then
	echo "$"
  else
	echo "!"
  fi
}


# цвета работают коряво. Каждый эскейп символ должен быть экранирован \[ в начале и \] в конце
# причем это должно быть сделано в самой строке PS1.
# поэтому нельзя просто написать функцию которая откроет цвет, напишет символ и закроет цвет
# поэтому везде применен паттерн - \[$(функция цвета)\]цветной текст\[резет цвета\]
# без этого цвет будет работать, но при нажатии вверх и поиске по истории с длинными строчками будет происходить чушь

#PS1='\[$(branch_color)\]$(parse_git_branch)\[${c_sgr0}\]\[$(private_color)\]$(is_private)\[${c_sgr0}\][\u@\h \W]$ ';
#PS1='\[$(branch_color)\]$(parse_git_branch)\[${c_sgr0}\]\[$(private_color)\]$(is_private)\[${c_sgr0}\][\W]$ ';
#PS1='\[$(branch_color)\]$(parse_git_branch)\[${c_sgr0}\]\[$(private_color)\]$(is_private)\[${c_sgr0}\][\W]\[$(exit_symbol)\] ';
PS1='\[$(branch_color)\]$(parse_git_branch)\[${c_sgr0}\]\[$(private_color)\]$(is_private)\[${c_sgr0}\][\W]\[$(exit_color)\]$(exit_symbol)\[${c_sgr0}\] ';
