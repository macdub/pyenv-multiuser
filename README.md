[![testing](https://github.com/macdub/pyenv-multiuser/actions/workflows/test-pyenv-multiuser.yml/badge.svg)](https://github.com/macdub/pyenv-multiuser/actions/workflows/test-pyenv-multiuser.yml)
# pyenv-multiuser
A pyenv plugin to enable a more friendly multi-user environment. This plugin will alter the code of pyenv where it looks for the shims directory. By default, the shims directory is setup under `$PYENV_ROOT/shims`, when multiple users are using the same pyenv instance there could be collisions with the changing of shims relative to each environment being used. At times the lock in this directory may fail to be unlocked and prevent others from making changes.

This plugin will solve this by having the base pyenv code look for a custom directory specified by the environment variable `PYENV_LOCAL_SHIM`. This can be setup under an individuals home directory or other personal directory, which will prevent the above mentioned issues.

## Installing as pyenv plugin
Installing pyenv-multiuser as a pyenv plugin will give access to the `pyenv multiuser` command.

    git clone https://github.com/macdub/pyenv-multiuser $(pyenv root)/plugins/pyenv-multiuser

After installed, you should run `pyenv multiuser setup` to setup the pyenv to look for the `PYENV_LOCAL_SHIM` environment variable. Any users that may want to use can run `pyenv multiuser init` to setup their local shim directory settings.

## Uninstalling
A command is provided within the *pyenv-multiuser* plugin to uninstall the plugin. This will restore the original files that were change in the pyenv install and then remove the plugin from the pyenv install.

    pyenv multiuser uninstall

This will ask for confirmation that uninstallation is desired before proceeding.

## Usage
### Initial Setup
Initial setup is done via `pyenv multiuser setup`

    pyenv multiuser setup

### Individual User Setup
An individual user can setup their personalized shims directory environment variable using `pyenv multiuser init`

    pyenv multiuser init [PATH]

This is command allows the user to setup the local shim directory. This will automatically add the appropriate export command to their shell rc file.

- A **bash** shell will add the export to `$HOME/.bashrc`.
- A **zsh** shell will add the export to `$HOME/.zshrc`.
- All other shells will add the export to `$HOME/.profile`. It should be noted that there are shells that will ignore `.profile`, such as **csh** and **ksh** by default.

To ensure that the shims work correctly, your profile should look similar to this:

```bash
# Example Profile Setup
export PYENV_LOCAL_SHIM="$HOME/.pyenv_local_shim"
export PATH="$PYENV_LOCAL_SHIM:$PYENV_ROOT/bin:$PATH"
eval "$(pyenv virtualenv-init -)"
```

You should refer to the [PyEnv Installation](https://github.com/pyenv/pyenv#installation) and adjust to include the above.

### Update
The `pyenv multiuser update` command is a bit of a wrapper around the *pyenv-update* command. Since this plugin makes changes to the base code of pyenv, it is required to restore the original versions of those files before performing updates. This will restore the unaltered files, perform the update, and finally re-setup the multiuser changes.

    $ pyenv multiuser update

### Uninstall
The `pyenv multiuser uninstall` command will uninstall the plugin from your pyenv install. It restores the normal pyenv files that it modified prior to uninstalling to ensure that your pyenv install will still function.

    $ pyenv multiuser uninstall

## Version History
#### v1.0.1
- hotfixes
  * logic to replace the 'setup.true' marker file after an update is run
  * add check for PYENV\_BASE environment variable being set and set to PYENV\_ROOT if it is not set
  * remove backup directory from repository
  * add logic to create backup directory during the `pyenv multiuser setup` command execution
- general code clean up
  * if-statement conventions
- github
  * create new workflow to run for all branches

#### v1.0.0
- update setup information

#### v0.3.0
- bug fixes related to backup creation and restoration
- CI pipeline setup
- user init function creates shims directory
- user init can take in custom directory as parameter `pyenv multiuser init <CUSTOM_PATH>`

#### v0.2.0
- add uninstall command

#### v0.1.1
- add check to update function to look for the *pyenv-update* plugin

#### v0.1.0
- Initial version
