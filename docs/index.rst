.. domcmc documentation master file, created by
   sphinx-quickstart on Fri Jun 28 14:27:39 2019.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.
    Indices and tables
    ==================
    
    * :ref:`genindex`
    * :ref:`modindex`
    * :ref:`search`
    
    .. currentmodule:: legs.legs
    .. autofunction:: __init__
    .. autofunction:: plot_data


The package **domcmc** provides the module **fst_tools** for reading data in the "standard" format.


Installation
===================

Use of `Anaconda <https://wiki.cmc.ec.gc.ca/wiki/Anaconda>`_ environments is strongly encouraged.

Install **domcmc** in an existing anaconda environment:

  .. code-block:: bash

     conda install domcmc -c dja001

Alternatively, you can create a new conda environment for domcmc:

  .. code-block:: bash

     conda create -n new_env_name domcmc -c dja001

Pip installation is also supported. From anywhere with internet connection, run:

  .. code-block:: bash

     pip install domcmc  

Quick start
===================

Make sure `Python RPN <https://wiki.cmc.ec.gc.ca/wiki/Python-RPN>`_ is loaded in your 
environment:
  .. code-block:: bash

	 . ssmuse-sh -x comm/eccc/all/opt/intelcomp/intelpsxe-cluster-19.0.3.199
	 . r.load.dot /fs/ssm/eccc/mrd/rpn/vgrid/6.4.5 
	 . ssmuse-sh -d eccc/mrd/rpn/MIG/ENV/x/rpnpy/2.1-u1.rc9

For vertical interpolation on pressure levels, you will also 
need:
  .. code-block:: bash

     . ssmuse-sh -d eccc/cmd/cmdn/pxs2pxt/3.16.6/default

Then, in your python scripts:

  .. code-block:: python

     import domcmc.fst_tools as fst_tools
     p0 = fst_tools.get_data(fileName='/fst/file/to/read.fst', var_name='P0')

.. toctree::
   :caption: fst_tools
   :maxdepth: 2

   fstDoc

Source code
===================

Can be found 
at: https://gitlab.science.gc.ca/dja001/domcmc


.. toctree::
   :caption: Contribute

   contribute

.. toctree::
   :caption: acknowledgement

   acknowledgement













