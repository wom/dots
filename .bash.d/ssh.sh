
# allow single agent to work across all sessions
#export SSH_AUTH_SOCK='~/.ssh/ssh-agent.sock'
#auth ()
#{
    ## startup ssh-agent if not already running; and auth key.
    #RESULT=`pgrep ssh-agent`
    #if [ "${RESULT:-null}" == "null" ]; then
        #echo "${PROCESS} not running, starting "$PROCANDARGS
        #echo 'Starting Agent'
        #eval $(ssh-agent -s -a "${SSH_AUTH_SOCK}")
    #fi
    #ssh-add
#}
auth ()
{
    eval $(ssh-agent -s)
    ssh-add
}
