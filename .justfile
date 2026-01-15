# 使用nu shell跨平台
set shell := ["nu", "-c"]
# 加载.env文件
set dotenv-load := true
# 默认只是列出所有的recipe
default:
    @just --list --unsorted --justfile {{justfile()}}

build package=".":
    ls | where type == dir | where {|d| $d.name =~ {{package}} } |where { |d| cd $d.name;ls | any { |n| $n.name == PKGBUILD }} | par-each { |p| cd $p.name;makepkg | complete | insert name $p.name}

    
clean:
    rm -rf */src */pkg */*.pkg.tar.zst */*.tar.gz */*.log
