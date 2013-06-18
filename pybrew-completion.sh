_pybrew_complete()
{
  local CANDIDATES
  local COMMANDS
 

  COMPREPLY=()

  cur=${COMP_WORDS[COMP_CWORD]}
  prev=${COMP_WORDS[COMP_CWORD-1]} 
  commands=`pythonbrew help |grep -e "^ .*: " | cut -d ":" -f 1 | tr -d " " |tr "\n" " "`
  options="-h --help --version"

  case ${COMP_WORDS[1]} in
	-h | --help | --version)
		COMPREPLY=()
		;;
 	help)
            	COMPREPLY=( $( compgen -W "$commands" | grep "^$cur" ) )
		;;

	*)
		COMPREPLY=( $( compgen -C "$options $commands" | grep "^$cur" ) )
		;;
  esac	

  return 0
}

complete -E -F _pybrew_complete pythonbrew
