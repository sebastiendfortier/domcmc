

Quick Start
----------------------

- Get the source code with

  .. code-block:: bash
  
     git clone git@gitlab.science.gc.ca:dja001/domUtils.git

  and copy or link the `domUtils` directory wherever you will be running your python scripts.

  |

- To use the domUtils modules in your python code, load the different modules separately:

  >>> import domcmc.fst_tools as fst_tools  #doctest:+SKIP 



Requirements
------------------

This package was developed with:

- python 3.7.3
- numpy 1.16.2

Additionally, 

The **legs** module requires:

- matplotlib 3.0.3

The **geo_tools** module requires:

- cartopy 0.17.0

The **fst_tools** module requires **rpnpy** (https://wiki.cmc.ec.gc.ca/wiki/Python-RPN) loaded as:

  .. code-block:: bash

     . r.load.dot eccc/mrd/rpn/MIG/ENV/py/2.7/rpnpy/2.1.b3

Problems have been reported with ordenv profiles versions < 1.6. In your home `.profile` should be a symlink as:

  .. code-block:: bash

     .profile -> /fs/ssm/eccc/mrd/ordenv/profile/1.6

Earlier versions of all dependencies may well work. Let me know how it goes for you. 

- At ECCC, you can get recent versions of python3, numpy, matplotlib and cartopy through
  the use of custom Anaconda environments. 

  Activate Anaconda with:

  .. code-block:: bash
      
     . ssmuse-sh -x hpco/exp/mib002/anaconda2/anaconda2-5.0.1-hpcobeta2

  as per :
  https://portal.science.gc.ca/confluence/pages/viewpage.action?pageId=30278663

  Instructions for creating an environment and installing the required packages can be found at
  https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html

  Conda environments are quite large and, by default, will be stored in the `.conda/` directory in your home. 
  Since home space is tight at EC, it is advised to make `.conda` a symlink to somewhere with mode space such 
  as `ords`

  .. code-block:: bash

     ln -s /your/path/to/ords/anaconda_environments/ ~/.conda

  To make an environment, the command:

  .. code-block:: bash
     
     conda create -n myenv python=3.7 scipy cartopy matplotlib

  will create an environment that will allow all modules of the `domUtils` package to run. 

  After its creation, you must activate your new environment with: 

  .. code-block:: bash
     
     source activate myenv



