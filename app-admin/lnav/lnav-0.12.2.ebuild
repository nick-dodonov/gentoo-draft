# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# crates list is built manually using `cargo ebuild` in "src/third-party/prqlc-c/"
#	required to download dependencies before `cargo build --release` inside `make`
#	(it fixes network-sandbox build issues)
CRATES="
	addr2line-0.21.0
	adler-1.0.2
	ahash-0.8.11
	aho-corasick-1.1.3
	allocator-api2-0.2.16
	android-tzdata-0.1.1
	android_system_properties-0.1.5
	anstream-0.6.15
	anstyle-1.0.6
	anstyle-parse-0.2.3
	anstyle-query-1.0.2
	anstyle-wincon-3.0.2
	anyhow-1.0.89
	ariadne-0.4.1
	autocfg-1.2.0
	backtrace-0.3.71
	bitflags-1.3.2
	bitflags-2.5.0
	bumpalo-3.15.4
	cc-1.0.90
	cfg-if-1.0.0
	chrono-0.4.38
	chumsky-0.9.3
	clap-4.5.4
	clap-verbosity-flag-2.1.2
	clap_builder-4.5.2
	clap_complete-4.4.10
	clap_complete_command-0.5.1
	clap_complete_fig-4.5.0
	clap_complete_nushell-0.1.11
	clap_derive-4.5.4
	clap_lex-0.7.0
	clio-0.3.5
	codespan-reporting-0.11.1
	color-eyre-0.6.3
	color-spantrace-0.2.1
	colorchoice-1.0.0
	colorchoice-clap-1.0.3
	core-foundation-sys-0.8.6
	crossbeam-channel-0.5.12
	crossbeam-utils-0.8.19
	csv-1.3.0
	csv-core-0.1.11
	cxx-1.0.120
	cxx-build-1.0.120
	cxxbridge-flags-1.0.120
	cxxbridge-macro-1.0.120
	dyn-clone-1.0.17
	either-1.10.0
	enum-as-inner-0.6.0
	equivalent-1.0.1
	errno-0.3.8
	eyre-0.6.12
	fastrand-2.0.2
	filetime-0.2.23
	fsevent-sys-4.1.0
	gimli-0.28.1
	hashbrown-0.14.3
	heck-0.4.1
	heck-0.5.0
	hermit-abi-0.3.9
	iana-time-zone-0.1.60
	iana-time-zone-haiku-0.1.2
	indenter-0.3.3
	indexmap-2.2.6
	inotify-0.9.6
	inotify-sys-0.1.5
	is-terminal-0.4.12
	is_terminal_polyfill-1.70.1
	itertools-0.13.0
	itoa-1.0.11
	js-sys-0.3.69
	kqueue-1.0.8
	kqueue-sys-1.0.4
	lazy_static-1.4.0
	libc-0.2.153
	link-cplusplus-1.0.9
	linux-raw-sys-0.4.13
	log-0.4.22
	memchr-2.7.2
	minijinja-2.3.1
	minimal-lexical-0.2.1
	miniz_oxide-0.7.2
	mio-0.8.11
	nom-7.1.3
	notify-6.1.1
	num-traits-0.2.18
	object-0.32.2
	once_cell-1.19.0
	owo-colors-3.5.0
	pin-project-lite-0.2.13
	proc-macro2-1.0.79
	prqlc-0.13.0
	prqlc-parser-0.13.0
	psm-0.1.21
	quote-1.0.35
	redox_syscall-0.4.1
	ref-cast-1.0.23
	ref-cast-impl-1.0.23
	regex-1.11.0
	regex-automata-0.4.8
	regex-syntax-0.8.5
	rustc-demangle-0.1.23
	rustix-0.38.32
	rustversion-1.0.14
	ryu-1.0.17
	same-file-1.0.6
	schemars-1.0.0-alpha.15
	schemars_derive-1.0.0-alpha.15
	scratch-1.0.7
	semver-1.0.23
	serde-1.0.210
	serde_derive-1.0.210
	serde_derive_internals-0.29.1
	serde_json-1.0.128
	serde_yaml-0.9.34+deprecated
	sharded-slab-0.1.7
	sqlformat-0.2.6
	sqlparser-0.48.0
	stacker-0.1.15
	strsim-0.11.0
	strum-0.26.3
	strum_macros-0.26.4
	syn-2.0.55
	tempfile-3.10.1
	termcolor-1.4.1
	terminal_size-0.3.0
	thread_local-1.1.8
	tracing-0.1.40
	tracing-core-0.1.32
	tracing-error-0.2.0
	tracing-subscriber-0.3.18
	unicode-ident-1.0.12
	unicode-width-0.1.11
	unicode_categories-0.1.1
	unsafe-libyaml-0.2.11
	utf8parse-0.2.1
	valuable-0.1.0
	version_check-0.9.4
	walkdir-2.5.0
	wasi-0.11.0+wasi-snapshot-preview1
	wasm-bindgen-0.2.92
	wasm-bindgen-backend-0.2.92
	wasm-bindgen-macro-0.2.92
	wasm-bindgen-macro-support-0.2.92
	wasm-bindgen-shared-0.2.92
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-util-0.1.6
	winapi-x86_64-pc-windows-gnu-0.4.0
	windows-core-0.52.0
	windows-sys-0.42.0
	windows-sys-0.48.0
	windows-sys-0.52.0
	windows-targets-0.48.5
	windows-targets-0.52.4
	windows_aarch64_gnullvm-0.42.2
	windows_aarch64_gnullvm-0.48.5
	windows_aarch64_gnullvm-0.52.4
	windows_aarch64_msvc-0.42.2
	windows_aarch64_msvc-0.48.5
	windows_aarch64_msvc-0.52.4
	windows_i686_gnu-0.42.2
	windows_i686_gnu-0.48.5
	windows_i686_gnu-0.52.4
	windows_i686_msvc-0.42.2
	windows_i686_msvc-0.48.5
	windows_i686_msvc-0.52.4
	windows_x86_64_gnu-0.42.2
	windows_x86_64_gnu-0.48.5
	windows_x86_64_gnu-0.52.4
	windows_x86_64_gnullvm-0.42.2
	windows_x86_64_gnullvm-0.48.5
	windows_x86_64_gnullvm-0.52.4
	windows_x86_64_msvc-0.42.2
	windows_x86_64_msvc-0.48.5
	windows_x86_64_msvc-0.52.4
	yansi-1.0.1
	zerocopy-0.7.32
	zerocopy-derive-0.7.32
"

inherit autotools flag-o-matic cargo

DESCRIPTION="A curses-based tool for viewing and analyzing log files"
HOMEPAGE="https://lnav.org"
SRC_URI="
	https://github.com/tstack/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	${CARGO_CRATE_URIS}
"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="pcap test"
RESTRICT="!test? ( test )"

RDEPEND="
	app-arch/bzip2:0=
	app-arch/libarchive:=
	>=dev-db/sqlite-3.9.0
	dev-libs/libpcre2
	>=net-misc/curl-7.23.0
	sys-libs/ncurses:=
	sys-libs/readline:=
	sys-libs/zlib:=
	pcap? ( net-analyzer/wireshark[tshark] )"
# The tests use ssh-keygen and use dsa and rsa keys (which is why ssl is required)
DEPEND="${RDEPEND}
	test? (
		virtual/openssh[ssl]
		dev-cpp/doctest
	)"

# build dependency https://github.com/PRQL/prql.git
BDEPEND="${DEPEND}
    >=virtual/rust-1.70
	"

DOCS=( AUTHORS NEWS.md README )

PATCHES=(
	"${FILESDIR}"/${PN}-0.12.2-lock-prqlc.patch
)

src_prepare() {
	default

	eautoreconf
}

src_compile() {
    # cargo build custom package - result will be used in default make
	cargo_src_compile --manifest-path src/third-party/prqlc-c/Cargo.toml

	default
}

src_install() {
    # skip default cargo_src_install because it's result is already used in build

	default
}

src_configure() {
	filter-lto

	econf \
		--disable-static \
		--with-ncurses \
		$(use_with test system-doctest)
}
