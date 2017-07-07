# Jupyter

## Basics

Ssh with port-forwarding

    (local) $ ssh -i <ssh-key> -L 8888:localhost:8888 ubuntu@ec2-xxxxxxxxx.compute-1.amazonaws.com
    
Start notebook on AWS machine

    (ec2) $ jupyter notebook --script
    
Console output will show URL with required token:

    ...
    [I 17:05:26.694 NotebookApp] The Jupyter Notebook is running at: http://localhost:8888/?token=b25c8dee718270a0385fd0014d52d179d9b35f5db444d0fc
    ...
    
Access Jupyter notebook through your local browser at localhost:8888. Use the full URL to include the token.

(Optional): See docs for how to setup a password rather than using the URL token: <http://jupyter-notebook.readthedocs.io/en/latest/public_server.html>

## Virtual environments

TODO: Python 2 virtualenv

### Python 3

Python3 already comes with a way to create virtual environments. Make sure you've first installed Python3. For Mac OSX, you can follow these instructions for [installing Python3](http://python-guide-pt-br.readthedocs.io/en/latest/starting/install3/osx/).

To create the virtual environment, 

    python3 -m venv /path/to/new/virtual/environment

To activate the environment,

    source /path/to/new/virtual/environment/bin/activate .

This will set up configure your environment to be self-contained within the virtual environment. You can deactivate it by simply typing `deactivate`.

#### Setting up an interactive environment

##### Do with the creation of each new virtualenv

Install jupyter within the activated environment.

    pip install --upgrade pip
    pip install jupyter

Install the python kernel of our new environment among those recognized by jupyter.

    python -m ipykernel install --user --name <name_of_venv> --display-name "<display_name>"
  
Here, `<name_of_venv>` corresponds to the name of the virtual environment. For example if you created the environment at `/path/to/my_venv`, then use `my_venv` for `<name_of_venv>`. The `<display_name>` argument is simply the kernel name that will be displayed in the jupyter notebook interface when you try to create a new notebook, or want to switch between kernels. 

Now to launch jupyter notebook enter `jupyter notebook`. When creating a new notebook, you should see your newly registered kernel among the options there. At this point it should be fresh (no packages installed). To install new packages inside this new environment, use the pip bundled with the virtualenv (the default if you activate your virtualenv) to install the packages you need. 

NOTE: Jupyter stores information in a centralized location on your computer. Thus while you might install a new jupyter for every new virtualenv you create, kernel specifications will all get dumped to the same place on your computer. Therefore, when trying to create a notebook using the kernel you are interested, you will see among your options other kernels from other virtualenvs. Just ignore these.

    

## Multiple kernels

Jupyter has a non-obvious aspect where, regardless of which environment (read: virtualenv) you start the notebook from, the kernels that are available have to be registered with unique names.

Thus if you have a virtualenv and also kernels with the same name previously registered (e.g. this is the case with the Bitfusion AMIs having python 2 kernels raedy), you have to register a new local virtual kernel manually. For example:

    source activate myenv
    python -m ipykernel install --user --name myenv --display-name "Python (myenv)"
    source activate other-env
    python -m ipykernel install --user --name other-env --display-name "Python (other-env)"

See: https://ipython.readthedocs.io/en/stable/install/kernel_install.html#kernels-for-different-environments
