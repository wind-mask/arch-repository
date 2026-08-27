#!/usr/bin/env -S nu --stdin
# nu-lint-ignore-file: catch_builtin_error_try, dont_mix_different_effects
export use ../up.nu *
let n_v =  (gh_latest_release huoshen80/ReinaManager | str trim --char v) 
let o_v = (get_pkgver)
if ((vercmp $o_v $n_v|into int) < 0) {
  print $"up reinamanager from ($o_v) to ($n_v)"
open PKGBUILD | str replace $o_v $n_v | save --force PKGBUILD
just updpkgsums reinamanager
} else {
  print "reinamanager doesn't need up"
} 
