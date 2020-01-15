
New feature, bug fix, etc. 
------------------------------------

If you want **domcmc** to be modified in any way, start by contacting me.

Office 538 at CMC in Dorval 

dominik.jacques@canada.ca

514-421-7294

I will then make you a developer on the `gitlab repo <https://gitlab.science.gc.ca/dja001/domcmc>`_.

From the gitlab web interface, you should then:

   #. Create a gitlab issue (In *Issues* use the *New Issue* buttom) describing the proposed changes.

   #. Create a new branch from the issue (click on the issus and then on *New branch*).

      |

      Then, from you computer: 

      |

   #. Clone the source and go in the package directory
      code
        .. code-block:: bash

           git clone git@gitlab.science.gc.ca:dja001/domcmc.git 
           cd domcmc

   #. Create a clean `Anaconda <https://wiki.cmc.ec.gc.ca/wiki/Anaconda>`_ developmemt environment 
      and activate it. 
      You need internet access for this. 
        .. code-block:: bash

           conda env create --name domcmc_dev_env -f docs/environment.yml
           conda activate domcmc_dev_env
   
   #. Switch to the issue 
      branch
        .. code-block:: bash

           git fetch origin
           git checkout --track origin/<Issue branch name>

   #. Make sure Python RPN and pxs2pxt are loaded in your environment. 
      See Home page of docs and load all SSM mentionned.

   #. Modify the code to adress the issue; make a test for the 
      modifications

   #. Run the 
      tests
        .. code-block:: bash

           cd docs
           make doctest
      
      Make sure that there are no failures in the tests.

   #. If you modified the documentation in functions docstrings, you probably want to check the 
      changes by creating your local version of the documentation.

        .. code-block:: bash
      
           cd docs
           make html

      You can see the output by 
      linking 
        .. code-block:: bash
  
           domcmc/docs/_build/html/

      to your *public_html*.

   #. Once you are happy with the modifications, push the new version
      on gitlab 
        .. code-block:: bash

           git push origin <Issue branch name>

   #. From the gitlab web interface, create a new merge request from your branch. We will then 
      discuss the changes until they are accepted and merged into the master branch. 

