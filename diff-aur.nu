#!/usr/bin/env -S nu --stdin

let installed_pkgs = (paru -Qmq |lines | sort)
let repo_pkgs = (paru -Slq wind-mask-arch-repository | lines | sort)

let miss_pkgs = ($installed_pkgs | where $it not-in $repo_pkgs)
let unused_pkgs = ($repo_pkgs | where $it not-in $installed_pkgs)

print miss_pkgs: $miss_pkgs
print unused_pkgs: $unused_pkgs
