#!/usr/bin/env -S nu --stdin
# nu-lint-ignore-file: dont_mix_different_effects

git restore  --staged . | complete
let git_status = (git status --short |lines| str trim | str replace "  " ' '| split column ' ' Change File)
let add_dirs = ($git_status | where { |x| ($x.Change == ??) and ($x.File| path dirname ) == aur }| get File )
let add_pkgs = ($add_dirs| each {|f| $f | path split |get --optional 1 }| str join ,)
print $"Add aur pkgs: ($add_pkgs)"
$add_dirs | each {|f| try { ^rm -rf $"($f)/.git" -- ; git add  $f   } 
try {
   git commit -m $"📦 package\(add-aur\): add ($f | str substring 4.. | str trim --right --char /)"
   }
}
