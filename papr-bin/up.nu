# nu-lint-ignore-file: dont_mix_different_effects, catch_builtin_error_try
use ../up.nu *
let o_v = (get_pkgver)
let n_v = (gh_latest_release l0ng-ai/papr name | parse "Papr v{n_v}"|get n_v|get --optional 0)
if ( (vercmp $o_v $n_v|into int) < 0 ) {
  print $"up papr-bin from ($o_v) to ($n_v)"
  open PKGBUILD | str replace $o_v $n_v | save --force PKGBUILD
  just updpkgsums papr-bin
} else {
  print "papr-bin doesn't need up"
}

