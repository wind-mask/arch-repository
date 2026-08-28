# nu-lint-ignore-file: dont_mix_different_effects, catch_builtin_error_try
use ../up.nu *
let o_v = (get_pkgver)
let n_v = (gh_latest_release LI-NA/zed-i18n name | parse "Zed-i18n v{n_v}"|get n_v|get --optional 0)
if ( (vercmp $o_v $n_v|into int) < 0 ) {
  print $"up zed-i18n-cn from ($o_v) to ($n_v)"
  open PKGBUILD | str replace $o_v $n_v | save --force PKGBUILD
  just updpkgsums zed-i18n-cn
} else {
  print "zed-i18n-cn doesn't need up"
}

