compass-webapp Cookbook
===============
This chef cookbook sets up the environment for the compass webapp.

To install this cookbook run the following commands

`berks install`  
`berks vendor cookbooks`  
`add #{current_dir}/cookbooks/compass-webapp/cookbooks/ to cookbook_path`  
`sudo chef-client -z -o compass-webapp`  

Requirements
------------
The following cookbooks are dependencies

nginx-2.7.4
postgresql-3.4.14
database-3.1.0
rbenv-1.7.0

Attributes
----------
None so far.

Usage
-----
#### webapp::default

Just include `compass-webapp` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[compass-webapp]"
  ]
}
```

Contributing
------------
TODO: (optional) If this is a public cookbook, detail the process for contributing. If this is a private cookbook, remove this section.

e.g.
1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
Authors: Patrick Spencer
License: MIT
