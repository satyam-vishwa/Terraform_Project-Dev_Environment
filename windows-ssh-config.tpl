add-content -path c:/users/satyam/.ssh/config -value @'
Host ${hostname}
    HostName ${hostname}
    User ${user}
    IdentityFile ${identityfile}
'@
