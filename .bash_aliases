# Mes alias
echo "chargement des alias"

# The 'ls' family (this assumes you use the GNU ls)
alias ll='ls -lh'
alias l='ls -CF'
alias lA='ls -Al'               # show hidden files
alias la="ls -a -I '[!.]*'"		  # show ONLY hidden files
alias lla="ls -Al"				      # show hidden files among others the long way
alias ls='ls -hF --color'	      # add colors for filetype recognition
alias lx='ls -lXB'              # sort by extension
alias lk='ls -lSh'              # sort by size
alias lc='ls -lcr'		          # sort by change time
alias lu='ls -lur'		          # sort by access time
alias lr='ls -lR'               # recursive ls
alias lt='ls -ltr'              # sort by date
alias lm='ls -al |more'         # pipe through 'more'
alias tree='tree -Csu'	      	# nice alternative to 'ls'
alias grep='grep --color'

alias dirs='find .??* * -prune -type d -print 2>/dev/null'
alias files='find .??* * -prune -type f -print 2>/dev/null'

# Ubuntu and Debian specifics
if [[ -f /etc/debian_version ]];then
	alias acs='aptitude search'
	alias agu='sudo aptitude update'
	alias agg='sudo aptitude safe-upgrade'
	alias agd='sudo aptitude full-upgrade'
	alias agi='sudo aptitude install'
	alias agr='sudo aptitude remove'
	alias agc='sudo aptitude clean'
	alias agac='sudo aptitude autoclean'
	alias agp='sudo aptitude purge'

	alias rem='sudo apt-get autoremove'           # Uninstall packages and deps
	alias purge='sudo apt-get autoremove --purge' # Get  ride of packages, deps and conf files
	# alias cleanall='sudo apt-get autoclean'
	# Show the installed version of a package
  alias dpkg-version="dpkg-query -W --showformat='\${Version}\n'"

  supaclean(){
    list=$(dpkg -l |grep ^rc |awk '{print $2} ')
    [[ -z "$list"  || "$list" == "" ]] && { echo -e "supaclean not doin' nothing !"; return 0 ; }
    echo "[$list]"
    if ask "On purge vraiment ? "
      then COLUMNS=200 dpkg -l |grep ^rc |awk '{print $2} ' | xargs sudo dpkg -P
    fi
  }

elif [[ -f /etc/arch_version ]];then
  #
  #
  alias acs='pacman -Ss'
  alias agu='pacman -U'
  alias agg='pacman -Syu'   # Met à jour tous les paquets si une version plus récente est présente dans les dépôts.
  alias agd='this is Arch, don\t know what to do...'
  alias agi='pacman -S'
  alias agr='pacman -R'
  alias agrr'pacman -Rs'    # Supprime le(s) paquet(s) spécifié(s) en argument ainsi que toutes ses dépendances qui ne sont pas nécessaires à d'autres paquets.
  alias agc='pacman -Sc'    # Supprime tous les paquets non installés du cache.
  alias agac='pacman -Scc'  # Clean the entire package cache

elif [[ -f /etc/redhat-release ]];then
  alias acs='yum search'
  alias agu='yum check-update'
  alias agg='yum update'
  alias agd='yum upgrade'
  alias agi='yum install'
  alias agr='yum erase'
  alias agc='yum clean'
  alias agac='yum clean all'
fi

# Misc
alias sa="cd /etc/apache2/sites-available"
alias wlog="cd /var/log/apache2"
alias cls="clear"
alias psx="ps -aux"
alias cd..='cd ..'
alias rezo='sudo watch netstat -alpe --ip'
# public
alias monip="curl ip.appspot.com"
# private
alias ips="ifconfig -a | perl -nle'/(\d+\.\d+\.\d+\.\d+)/ && print $1'"
alias :wq='echo Je ne suis PAS vim'
# -> Prevents accidentally clobbering files.
alias mkdir='mkdir -p'
alias which='type -all'
alias path='echo -e ${PATH//:/\\n}'
alias findstring='find . -type f -print0 | xargs -0 grep -H'
c(){ printf "\33[2J" ;}

alias lso="sudo lsof -i -T -n"
alias tailf="tail -f --retry"
alias shot="convert X: ~/Bureau/shot.png"
alias ducks="du -h * |sort -hr |head -11"
alias duse="du -hs * | sort -hr"

alias head='head -n $((${LINES:-12}-2))'      # As many as possible without scrolling
alias tail='tail -n $((${LINES:-12}-2)) -s.1' # Likewise, also more responsive -f

# functions
cx(){ chmod u+x $* ;}

ask() {
    echo -n "$@" '[o/n] '
    read ans
    case "$ans" in
        o*|O*) return 0 ;;
        *) return 1 ;;
    esac
}

mydumpdb ()
{
  local usage opts opt o_verbose o_zip o_preserve
  local -i OPTIND=1
  true=1
  usage="usage: mydumpdb [-v(erbose)] [-z(ip)] [-p(reserve)] <database_name>\nYou will be prompted to provide db root pass"
    minArgs=2
    opts="vzp"
    while getopts "$opts" opt ; do
        case "$opt" in
            v)  o_verbose=$true                 ;;
            z)  o_zip=$true                   ;;
            p)  o_preserve=$true                ;;
            *)  echo -e "$usage" ; return $65   ;;
         esac
        [[ -n "$OPTARG" ]] && options="${options/ -$opt $OPTARG/} -$opt $OPTARG" || options="${options/ -$opt/} -$opt"
    done
    shift $((OPTIND-1))

    [[ -n "$1" ]] || { echo -e $usage; return 1; }
    fullOptions="--quote-names --quick --add-drop-table --add-locks --extended-insert --lock-tables"
    DUMPFILE="${1}.sql"
    # Add informations
    (( o_verbose )) && fullOptions=$fullOptions" --debug-info"
    # if preserve is set add timestamp to prevent overwrite.
    (( o_preserve )) && DUMPFILE=${DUMPFILE%.*}-$(date +"%Y%m%d.%H%M%S").sql
    mysqldump -uroot -p $fullOptions $1 > $DUMPFILE
    # May gain space if bzip2 is installed
    (( o_zip )) && bzip2 $DUMPFILE
}

# $GROUP=$(id -gn)
if [[ $UID == 0 ]];then
  export PS1="\[\e[34m\][\$(date +%Y-%m-%d.)\t]\[\e[31m\]\u\[\e[34m\]@\[\e[35m\]\h\[\e[34m\] \[\e[33m\]\w\[\e[0m\]\n# "
else
  # Nota : le \ devant le $ de date permet à la commande d'être exécuté à chaque fois et pas seulement au démarrage du shell
  # ce qui aurait pour effet de bloquer l'heure sur la création du shell
  export PS1="\[\e[34m\]\$(date +[%Y-%m-%d.%H:%M:%S])\[\e[32m\]\u\[\e[34m\]@\[\e[35m\]\h\[\e[34m\] \[\e[33m\]\w\[\e[0m\]\n\$ "
fi

export PATH=${HOME}/bin:$PATH
export PATH=/sbin:$PATH
set -o vi

if [ "$TERM" == "xterm" ]
then
  # window-title stuff here.
  setWindowTitle() {
    echo -ne "\e]2;$*\a"
  }

   updateWindowTitle() {
       setWindowTitle "${HOSTNAME%%.*}:${PWD/$HOME/~}"
   }

  PROMPT_COMMAND=updateWindowTitle
fi


# Remove duplicates from the history
export HISTCONTROL=erasedups
#increase history size
export HISTSIZE=10000
# Ensures that when you exit a shell, the history from that session is appended to ~/.bash_history
shopt -s histappend
# Automatic correction of directory typo
shopt -s cdspell
# Leave it on last line
HOSTNAME=$(hostname -s)
[[ -f ~/.bash_aliases.${HOSTNAME} ]] && source ~/.bash_aliases.${HOSTNAME}
