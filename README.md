# magic-prompt
My personal bash prompt

## How to use
Clone this repo or download it or copy-paste it... you just need the `magic-prompt.sh` file in your system. Then you just need to source it in your `.bash_profile`

```
source ~/magic-prompt.sh
```

## Features

* Shows git branch
* Emojis per branch type
  * 👑 Master
  * ☕️ Develop
  * 🛠 Feature
  * 🐛 Bugfix
  * 🚀 Release
* Shows git status
  * `*` for uncommitted
  * `+` for unstaged
  * `?` for untracked
  * `$` for stashed
  * `⬇` when local is behind remote
  * `⬆` when local is ahead of remote
  * `⬇⬆` when local has diverged
* Alerts when last command failed with ⚠️
* Nice colors :)

## Notes
This is still in development, kinda. I'm not really supporting it or anything like that, I just wanted to share this thing :)
