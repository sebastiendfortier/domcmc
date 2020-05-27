
#this script is sourced when conda environment is activated

#SSMs commands to run
cmds=('. ssmuse-sh -x comm/eccc/all/opt/intelcomp/intelpsxe-cluster-19.0.3.199' 
      '. r.load.dot /fs/ssm/eccc/mrd/rpn/vgrid/6.4.5'
      '. ssmuse-sh -d eccc/mrd/rpn/MIG/ENV/x/rpnpy/2.1-u1.rc9'
      '. ssmuse-sh -d eccc/cmd/cmdn/pxs2pxt/3.16.6/default')
for cmd in "${cmds[@]}"; do
    echo 'Running:  '$cmd
    $cmd
    echo ''
done
