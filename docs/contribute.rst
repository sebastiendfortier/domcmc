
Requirements
----------------

TODO
    Instructions here on how to initialize a contribution environment



Running the tests
----------------------

- Go in 

  .. code-block:: bash
  
     domcmc/docs

- To run the tests run:

  .. code-block:: bash
  
     make doctest

  The result should look like:

  .. code-block:: bash

     ...
     Doctest summary:
     ===============
       291 tests
         0 failures in tests
         0 failures in setup code
         0 failures in cleanup code

  It is important that there be no failures in the tests.

- To generate a new version of the html documentation page, run:

  .. code-block:: bash
  
     make html

  There will be a few warnings that you can probably ignore. 
  The new page will be in 

  .. code-block:: bash
  
     domcmc/docs/_build/html/


TODO
    link to gitlab contributing guide
