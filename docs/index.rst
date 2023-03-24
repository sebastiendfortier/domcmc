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

Use of `conda <https://wiki.cmc.ec.gc.ca/wiki/conda>`_ environments is strongly encouraged.

Install **domcmc** in an existing conda environment:

  .. code-block:: bash

     conda install domcmc -c dja001

Alternatively, you can create a new conda environment for domcmc:

  .. code-block:: bash

     conda create -n new_env_name domcmc -c dja001

Pip installation is also supported. From anywhere with Internet connection, run:

  .. code-block:: bash

     pip install domcmc  

.. _quick_start:

Quick start
===================

This package requires some in-house software to be loaded in your shell environment.

If you installed domcmc through conda, you don't need to do anything more as the 
necessary SSM packages are automatically loaded when you activate the conda environment
where you installed domcmc.

If you installed domcmc with pip, make sure 
`Python RPN <https://wiki.cmc.ec.gc.ca/wiki/Python-RPN>`_ is loaded in your 
environment:

  .. code-block:: bash

     . r.load.dot eccc/mrd/rpn/MIG/ENV/rpnpy/2.1-u2.5  main/opt/intelcomp/inteloneapi-2022.1.2/intelcomp+mpi+mkl

For vertical interpolation on pressure levels, you will also 
need:

  .. code-block:: bash

     . r.load.dot /fs/ssm/eccc/cmd/cmdn/pxs2pxt/3.17.5/default

Then, in your Python scripts:

  .. code-block:: python

     import domcmc.fst_tools as fst_tools
     p0 = fst_tools.get_data(file_name='/fst/file/to/read.fst', var_name='P0')

.. toctree::
   :caption: fst_tools
   :maxdepth: 2

   fstDoc

Source code
===================

Can be found 
at: https://gitlab.science.gc.ca/dja001/domcmc

.. toctree::
   :caption: Examples

   examples

.. toctree::
   :caption: Gallery

   auto_examples/index


.. toctree::
   :caption: Contribute

   contribute

.. toctree::
   :caption: Acknowledgement

   acknowledgement

