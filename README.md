# Installation
Prebuilt binaries available for linux and mac on the [releases page](https://github.com/karshan/svg-tools/releases)

# Installation from source
Install [haskell stack](https://docs.haskellstack.org/en/stable/README/#how-to-install)

```sh
stack setup
stack build --copy-bins
```

# Usage
`./svg-tools input.svg | tr -d '\n' > output.svg`
