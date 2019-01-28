#shellcheck shell=bash
# DO NOT EDIT THIS FILE IT WILL BE OVERWRITTEN ON UPDATE
#
# Add portable user customizations $CMDER_ROOT/config/user_profile.sh,
# these customizations will follow Cmder if $CMDER_ROOT is copied
# to another machine.
#
# Add system specific users customizations to $HOME/.bashrc, these
# customizations will not follow Cmder to another machine.

function runProfiled() {
	unset profile_d_scripts
	pushd "$1" >/dev/null || exit 1
	profile_d_scripts=$(ls ./*.sh 2>/dev/null)

	if [ ! "x$profile_d_scripts" = "x" ]; then
		for x in $profile_d_scripts; do
			# echo Sourcing "$1/$x"...
			#shellcheck source=/dev/null
			source "$1/$x"
		done
	fi
	popd >/dev/null || exit 1
}

# We do this for bash as admin sessions since $CMDER_ROOT is not being set
if [ "$CMDER_ROOT" == "" ]; then
	case "$ConEmuDir" in
	*\\*)
		CMDER_ROOT=$(
			cd "$(cygpath -u "$ConEmuDir")/../.." || exit 1
			pwd
		)
		;;
	esac
else
	case "$CMDER_ROOT" in
	*\\*)
		CMDER_ROOT="$(cygpath -u "$CMDER_ROOT")"
		;;
	esac
fi

# Remove any trailing '/'
#shellcheck disable=SC2001
CMDER_ROOT=$(echo "$CMDER_ROOT" | sed 's:/*$::')

export CMDER_ROOT

if [ -d "/c/Program Files/Git" ]; then
	GIT_INSTALL_ROOT="/c/Program Files/Git"
elif [ -d "/c/Program Files(x86)/Git" ]; then
	GIT_INSTALL_ROOT="/c/Program Files(x86)/Git"
elif [ -d "$CMDER_ROOT/vendor/git" ]; then
	GIT_INSTALL_ROOT="$CMDER_ROOT/vendor/git"
fi

#shellcheck disable=SC2076
if [[ ! "$PATH" =~ "$GIT_INSTALL_ROOT/bin:" ]]; then
	PATH="$GIT_INSTALL_ROOT/bin:$PATH"
fi

PATH="$CMDER_ROOT/bin:$CMDER_ROOT/vendor/bin:$PATH:$CMDER_ROOT"

export PATH

# Drop *.sh or *.zsh files into "$CMDER_ROOT\config\profile.d"
# to source them at startup.
if [ ! -d "$CMDER_ROOT/config/profile.d" ]; then
	mkdir -p "$CMDER_ROOT/config/profile.d"
fi

if [ -d "$CMDER_ROOT/config/profile.d" ]; then
	runProfiled "$CMDER_ROOT/config/profile.d"
fi

if [ -d "$CMDER_USER_CONFIG/profile.d" ]; then
	runProfiled "$CMDER_USER_CONFIG/profile.d"
fi

# Renaming to "config\user_profile.sh" to "user_profile.sh" for consistency.
if [ -f "$CMDER_ROOT/config/user-profile.sh" ]; then
	mv "$CMDER_ROOT/config/user-profile.sh" "$CMDER_ROOT/config/user_profile.sh"
fi

CmderUserProfilePath="$CMDER_ROOT/config/user_profile.sh"
if [ -f "$CMDER_ROOT/config/user_profile.sh" ]; then
	#shellcheck source=/dev/null
	source "$CMDER_ROOT/config/user_profile.sh"
fi

if [ "$CMDER_USER_CONFIG" != "" ]; then
	# Renaming to "config\user_profile.sh" to "user_profile.sh" for consistency.
	if [ -f "$CMDER_USER_CONFIG/user-profile.sh" ]; then
		mv "$CMDER_USER_CONFIG/user-profile.sh" "$CMDER_USER_CONFIG/user_profile.sh"
	fi

	export PATH="$CMDER_USER_CONFIG/bin:$PATH"

	CmderUserProfilePath="$CMDER_USER_CONFIG/user_profile.sh"
	if [ -f "$CMDER_USER_CONFIG/user_profile.sh" ]; then
		#shellcheck source=/dev/null
		source "$CMDER_USER_CONFIG/user_profile.sh"
	fi
fi

if [ ! -f "$CmderUserProfilePath" ]; then
	echo Creating user startup file: "$CmderUserProfilePath"
	cp "$CMDER_ROOT/vendor/user_profile.sh.default" "$CmderUserProfilePath"
fi

# Source the users .bashrc file if it exists
if [ -f "$HOME/.bashrc" ]; then
	#shellcheck source=/dev/null
	source "$HOME/.bashrc"
fi
