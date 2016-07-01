## snippets
* en: this repo contains some useful scripts and code-snippets and is yet work in progress
* de: Dieses Repo enthält einige Skripte und Code-Schnipsel und wird noch erweitert

- [x] This repo is still WIP!
- [x] MIT licensed
- [x] feel free to use and/or mod this snippets
- [x] have fun!

## manUpdate.sh
Ubuntu 14.04 update-script (will be multilingual in future)

## runKSP.sh
small startup script for KSP under Linux :D

## RAMcleaner.sh
will clean your RAM (basicly unloads system components off the RAM)

>CAUTION! this script is intended to be used in conky!

* set the max lowest RAM usage in the script (i assume 25% is just fair enough, otherwise mod that)
* set ask to false if you wish not to get bothered by clicking yes/no

example usage in any conky script:
```
${execi 60 ~/.conky/RAMcleaner.sh}
```
