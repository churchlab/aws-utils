# Jupyter

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
