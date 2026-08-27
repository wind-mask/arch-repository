#!/usr/bin/env -S nu --stdin
# nu-lint-ignore-file: kebab_case_commands

  

def main [] {
  
  git restore  --staged . | complete
  let git_status = (git status --short |lines| str trim | str replace "  " ' '| split column ' ' Change File)
  print -e $git_status
  for $c in $git_status {
    if ($c.Change == M and ($c.File | path basename) == PKGBUILD ) {
      
  print changed: $c
  let ver = ( git diff main $c.File|  parse --regex '.+pkgver="?(?<ver0>[\.\d]+)"?.+pkgver="?(?<ver1>[\.\d]+)"?')
  if ($ver | is-empty) {
    continue
  }
  let ver0 = ($ver | get ver0 | get --optional 0)
  let ver1 = ($ver | get ver1 | get --optional 0)
  if (($ver0 | is-empty ) or ($ver1 | is-empty)) {
    continue
     }
  print oldver:($ver0) newver:($ver1 )
  let vmp = (vercmp $ver0 $ver1 | into int)
  if ($vmp < 0) {
    let pac = ($c.File | parse "{field0}/{field1}" | get field0 | get --optional  0)
    print $"up ($pac) from ($ver0) to($ver1)"
    git add $c.File | complete
    git commit -m $"📦 package\(up-($pac)\): pkgver=($ver1)" | complete
  } else if ($vmp > 0) {
    print down
  } else {
    print 0
  }
}
  }
}

# 获取 github 参考的latest release的name（非tag name）
export def gh_latest_release [user_repo: string]: any -> string { # nu-lint-ignore: kebab_case_commands
  try {
  let v_name = (gh api repos/($user_repo)/releases/latest | from json| get name)
  return $v_name
      } catch {|err|
      error make {msg: $err.msg} # nu-lint-ignore: add_label_to_error
    }
   }
# 获取当前目录PKGBUILD的pkgver
export def get_pkgver []: any -> string {
  let ver = (open --raw PKGBUILD | lines | where $it =~ pkgver= | parse --regex 'pkgver=(.+)' | get capture0 | get --optional 0) # nu-lint-ignore: catch_builtin_error_try
  return $ver
}
