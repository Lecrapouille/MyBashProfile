# My profile

## An owl in your bash

![alt tag](https://github.com/Lecrapouille/MyBashPrompt/blob/master/owl.png)

Here is the bash code for my console prompt. Copy/paste this code into your `~/.bashrc` file to have the same prompt as me.

## Git status

Local status symbols:

- ●n there are n modified files.
- ✚n there are n staged files.
- ✖n there are n files with merge conflicts.
- …n there are n untracked files.

Branch Tracking Symbols:

- ✔ the repository is up to date.
- ▲n ahead of remote by n commits.
- ▼n behind remote by n commits.

## Open terminal in PCManFM (LXDE File Manager)

Create `~/.local/share/file-manager/actions/terminal.desktop` with the following content:

```desktop
[Desktop Entry]
Type=Action
Tooltip=Open Terminal
Name=Open Terminal
Profiles=profile-one;
Icon=utilities-terminal


[X-Action-Profile profile-one]
MimeTypes=inode/directory;
Exec=tilix -w %f
Name=Default profile
```

I'm using [Tilix](https://github.com/gnunn1/tilix) as my terminal.
