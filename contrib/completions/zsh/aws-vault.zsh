#compdef aws-vault

_aws-vault() {
	_arguments -C \
		'1: :->command' \
		'2: :->profiles'

	case $state in
		command)
			local -a commands=( $(${words[1]} --completion-bash) )
			_describe -t commands 'Commands' commands

			;;
		profiles)
			case "${words[2]}" in
				exec|login|remove|rm|rotate)
					local -a profiles=(  $(cat ~/.aws/config | awk '/^\[profile/ {print $2;}' | tr -d \])  )
					_describe -t profiles 'AWS Profiles' profiles
					;;
			esac
			;;
		args)
			_describe -t args 'Args' args
	esac
}


if [[ "$(basename -- ${(%):-%x})" != "_aws-vault" ]]; then
    compdef _aws-vault aws-vault
fi
