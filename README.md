# homebrew-synaxi

This is the [Homebrew](https://brew.sh) tap for the Synaxi CLI runtime.

Synaxi is a local runtime that optimises and routes Claude Code traffic on
your machine — see [synaxi.ai](https://synaxi.ai) for what it does. The
source for Synaxi itself lives in a private repository; this tap holds only
the Homebrew formula (`Formula/synaxi.rb`), which points at signed release
archives published to Synaxi's own CDN.

## Install

```sh
brew tap BeadW/synaxi
brew install synaxi
```

or, without a separate tap step:

```sh
brew install BeadW/synaxi/synaxi
```

## Updating

This formula is updated by hand for each new tagged Synaxi release. It is
not built or tested by any CI in this repository.
