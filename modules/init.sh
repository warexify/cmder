::----------------------------------------------------------------------------------------------------
:: shark
:: The shell environment of your dreams
::
:: Shark is a package installer that will allow you to create a fully customized shell environment
:: through a single simple installer. It takes the hard work out of downloading and configuring all
:: the components you need. Shark simplifies the installation by asking simple questions and taking
:: care of downloading and installing everything for you from trusted sources (official repositories).
:: It has a modular architecture that allows anyone to add and improve the installer easilly.
::
:: @author       Kenrick JORUS
:: @copyright    2016 Kenrick JORUS
:: @license      MIT License
:: @link         http://kenijo.github.io/shark/
::
:: @package      init.sh
:: @description  Init script for sh
::                !!! THIS FILE IS OVERWRITTEN WHEN CMDER IS UPDATED
::                !!! Use "%SHARK_ROOT%\config\profile.sh" to add your own startup commands
:: ----------------------------------------------------------------------------------------------------

PATH=$PATH:${SHARK_ROOT}/bin
PATH=$PATH:${SHARK_ROOT}/modules/cygwin/bin
PATH=$PATH:${SHARK_ROOT}/modules/git/bin
PATH=$PATH:${SHARK_ROOT}/modules/gow/bin
PATH=$PATH:${SHARK_ROOT}/modules/php
PATH=$PATH:${SHARK_ROOT}/modules/putty
export PATH

# Add portable user customizations ${SHARK_ROOT}/config/profile.sh,
# these customizations will follow Cmder if $SHARK_ROOT is copied
# to another machine.
#
# Add system specific users customizations to $HOME/.bashrc, these
# customizations will not follow Cmder to another machine.

# We do this for bash as admin sessions since $SHARK_ROOT is not being set
if [ "$SHARK_ROOT" == "" ] ; then
    case "$ConEmuDir" in *\\*) SHARK_ROOT=$( cd "$(cygpath -u "$ConEmuDir")/../.." ; pwd );; esac
else
    case "$SHARK_ROOT" in *\\*) SHARK_ROOT="$(cygpath -u "$SHARK_ROOT")";; esac
fi

# Remove any trailing '/'
SHARK_ROOT=$(echo $SHARK_ROOT | sed 's:/*$::')

export SHARK_ROOT

if [ -d "/c/Program Files/Git" ] ; then
    GIT_INSTALL_ROOT="/c/Program Files/Git"
elif [ -d "/c/Program Files(x86)/Git" ] ; then
    GIT_INSTALL_ROOT="/c/Program Files(x86)/Git"
elif [ -d "${SHARK_ROOT}/modules/git" ] ; then
    GIT_INSTALL_ROOT=${SHARK_ROOT}/modules/git
fi

if [[ ! "$PATH" =~ "${GIT_INSTALL_ROOT}/bin:" ]] ; then
  PATH=${GIT_INSTALL_ROOT}/bin:$PATH
fi

PATH=${SHARK_ROOT}/bin:$PATH:${SHARK_ROOT}

export PATH

# Load profile script at startup
. "${SHARK_ROOT}/config/profile.sh"
# use this file to run your own startup commands for msys2 bash'

# To add a new modules to the path, do something like:
# export PATH=/${SHARK_ROOT}/modules/new-module:/${PATH}
eof
fi

# Source the users .bashrc file if it exists
if [ -f "${HOME}/.bashrc" ] ; then
    . "${HOME}/.bashrc"
fi
