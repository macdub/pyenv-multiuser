# pyenv-multiuser
A pyenv plugin to enable a more friendly multi-user environment. This plugin will alter the code of pyenv where it looks for the shims directory. By default, the shims directory is setup under `$PYENV_ROOT/shims`, when multiple users are using the same pyenv instance there could be collisions with the changing of shims relative to each environment being used. At times the lock in this directory may fail to be unlocked and prevent others from making changes.

This plugin will solve this by having the base pyenv code look for a custom directory specified by the environment variable `PYENV_LOCAL_SHIM`. This can be setup under an individuals home directory or other personal directory, which will prevent the above mentioned issues.

## Installing as pyenv plugin
Installing pyenv-multiuser as a pyenv plugin will give access to the `pyenv multiuser` command.

    $ git clone https://github.com/macdub/pyenv-multiuser $(pyenv root)/plugins/pyenv-multiuser

After installed, you should run `pyenv multiuser setup` to setup the pyenv to look for the `PYENV_LOCAL_SHIM` environment variable. Any users that may want to use can run `pyenv multiuser init` to setup their local shim directory settings.

## Usage
### Initial Setup
Initial setup is done via `pyenv multiuser setup`

    $ pyenv multiuser setup

### Individual User Setup
An individual user can setup their personalized shims directory environment variable using `pyenv multiuser init`

    $ pyenv multiuser init

This is an optional interactive approach. Otherwise, the user can simple set the environment variable manually and create the directory if not already present.

To ensure that the shims work correctly, your profile should look like this:

```bash
# Example Profile Setup
export PYENV_LOCAL_SHIM="$HOME/.pyenv_local_shim"
export PATH="$PYENV_LOCAL_SHIM:$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
```

### Update
The `pyenv multiuser update` command is a bit of a wrapper around the *pyenv-update* command. Since this plugin makes changes to the base code of pyenv, it is required to restore the original versions of those files before performing updates. This will restore the unaltered files, perform the update, and finally re-setup the multiuser changes.

    $ pyenv multiuser update

## Version History
#### 20210512
- 0.1.0
