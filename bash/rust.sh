alias ccheck="cargo check --color=always 2>&1 | grep -A 10000 error --color=never | less -r"
export RUSTC_WRAPPER=sccache

