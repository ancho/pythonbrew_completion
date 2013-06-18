_pybrew_complete()
{
  local commands cur prev
 
  COMPREPLY=()

  commands=`pythonbrew help |grep -e "^ .*: " | cut -d ":" -f 1 | tr -d " " |tr "\n" " "`
  
  if [ $COMP_CWORD -eq 1 ]; then
	
	_pybrew_compreply $commands
  
  elif [ $COMP_CWORD -eq 2 ]; then
	
	case "${COMP_WORDS[COMP_CWORD-1]}" in
		
		help)
			commands=$( echo $commands | sed -e "s/help//g" )
			_pybrew_compreply $commands
		;;
		
		install)
			_pybrew_available_versions
			_pybrew_compreply $available_versions
		;;
		use|switch|uninstall)
			_pybrew_installed_versions
			_pybrew_compreply $installed_versions
		;;
		*)
		;;
	esac 
  fi


  return 0
}

_pybrew_available_versions()
{
	_pybrew_installed_regex
	_pybrew_known_versions
	
	available_versions=$( echo $known_versions | sed -e "s/$installed_regex//g" )

}

_pybrew_installed_versions()
{
	installed_versions=$( pythonbrew list |grep -v ^# | awk '{print $1}' )
}

_pybrew_installed_regex()
{
	_pybrew_installed_versions
	installed_regex=$( echo $installed_versions |tr "\n " "|"| sed -e "s/|$//" -e "s/|/\\\|/g") 
}

_pybrew_known_versions()
{
	known_versions=$( pythonbrew list -k |grep -v ^# )
}

_pybrew_compreply()
{
	COMPREPLY=( $( compgen -W "$*" -- ${COMP_WORDS[COMP_CWORD]}) )
}

complete -F _pybrew_complete pythonbrew
