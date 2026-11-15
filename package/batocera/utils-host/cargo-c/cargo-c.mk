################################################################################
#
# cargo-c
#
################################################################################

CARGO_C_VERSION = v0.10.19
CARGO_C_SITE = $(call github,lu-zero,cargo-c,$(CARGO_C_VERSION))
CARGO_C_LICENSE = MIT License
CARGO_C_LICENSE_FILES = LICENSE

# cargo-c ships no Cargo.lock, so cargo vendor resolves the newest crates, some of
# which need a newer rustc than host-rustc provides. Prefer compatible versions.
HOST_CARGO_C_DL_ENV += CARGO_RESOLVER_INCOMPATIBLE_RUST_VERSIONS=fallback

HOST_CARGO_C_DEPENDENCIES = host-pkgconf host-rustc host-openssl

$(eval $(host-cargo-package))
