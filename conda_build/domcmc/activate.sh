
#this script is sourced when conda environment is activated



# https://stackoverflow.com/a/4025065
# if $1 = $2, returns '='
# if $1 < $2, returns '<'
# if $1 > $2, returns '>'
vercomp () {
    if [[ $1 == $2 ]]
    then
        echo '='
    fi
    local IFS=.
    local i ver1=($1) ver2=($2)
    # fill empty fields in ver1 with zeros
    for ((i=${#ver1[@]}; i<${#ver2[@]}; i++))
    do
        ver1[i]=0
    done
    for ((i=0; i<${#ver1[@]}; i++))
    do
        if [[ -z ${ver2[i]} ]]
        then
            # fill empty fields in ver2 with zeros
            ver2[i]=0
        fi
        if ((10#${ver1[i]} > 10#${ver2[i]}))
        then
            echo '>'
            return
        fi
        if ((10#${ver1[i]} < 10#${ver2[i]}))
        then
            echo '<'
            return
        fi
    done
}


#
#
#MAIN code begins here

#insure minimum version of atomic profile
minimum_atomic_version=1.17.0
if [ "$(vercomp ${minimum_atomic_version} ${EC_ATOMIC_PROFILE_VERSION})" = '>' ]; then
	echo "EC_ATOMIC_PROFILE_VERSION=${EC_ATOMIC_PROFILE_VERSION} but should be greater or equal to ${minimum_atomic_version}"
	echo "Please use login profile greater of equal to /fs/ssm/eccc/mrd/ordenv/profile/${minimum_atomic_version}"
	return 1
fi

#SSMs commands to run
cmds=( '. r.load.dot eccc/mrd/rpn/MIG/ENV/rpnpy/2.1-u2.4'
       '. r.load.dot eccc/mrd/rpn/MIG/ENV/migdep/5.1-u2.2' 
       '. r.load.dot eccc/cmd/cmda/libs/20220216/inteloneapi-2022.1.2'
       '. r.load.dot /fs/ssm/eccc/cmd/cmdn/pxs2pxt/3.17.5/default')
for cmd in "${cmds[@]}"; do
    echo 'Running:  '$cmd
    $cmd
    echo ''
done
