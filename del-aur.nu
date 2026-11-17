#!/usr/bin/env -S nu --stdin
# nu-lint-ignore-file: dont_mix_different_effects

git restore  --staged . | complete
let git_status = (git status --short |lines| str trim | str replace "  " ' '| split column ' ' Change File)
let del_files = ($git_status | where Change == D and ($it.File| path basename ) == PKGBUILD  | get File )
let del_pkgs = ($del_files| each {|f| $f | path split |get --optional 1 }| str join ,)
print Del aur pkgs: $del_pkgs
$del_files | each {|f| try { git rm -r ($f | path dirname )  } }
try {
   git commit -m $"📦 package\(del-aur\): del ($del_pkgs)"
}
