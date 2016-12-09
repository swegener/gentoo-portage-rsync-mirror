# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils gnome2-utils readme.gentoo-r1 systemd user xdg-utils

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/transmission/transmission"
else
	SRC_URI="https://github.com/transmission/transmission/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~mips ~ppc ~ppc64 ~x86 ~x86-fbsd ~amd64-linux"
fi

# See CMakeLists
DHT_ID="cc379e406d"
UTP_ID="7c4f19abdf"
B64_ID="c1e3323498"

SRC_URI+="
	https://github.com/transmission/dht/archive/${DHT_ID}.tar.gz -> dht-${DHT_ID}.tar.gz
	https://github.com/transmission/libutp/archive/${UTP_ID}.tar.gz -> libutp-${UTP_ID}.tar.gz
	https://github.com/transmission/libb64/archive/${B64_ID}.tar.gz -> libb64-${B64_ID}.tar.gz
"

DESCRIPTION="A fast, easy, and free BitTorrent client"
HOMEPAGE="https://transmissionbt.com/"

# web/LICENSE is always GPL-2 whereas COPYING allows either GPL-2 or GPL-3 for the rest
# transmission in licenses/ is for mentioning OpenSSL linking exception
# MIT is in several libtransmission/ headers
LICENSE="|| ( GPL-2 GPL-3 Transmission-OpenSSL-exception ) GPL-2 MIT"
SLOT="0"
IUSE="ayatana gtk libressl lightweight nls qt5 systemd test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/libevent-2.0.10:=
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	net-libs/libnatpmp
	>=net-libs/miniupnpc-1.7:=
	>=net-misc/curl-7.16.3[ssl]
	sys-libs/zlib:=
	gtk? (
		>=dev-libs/dbus-glib-0.100
		>=dev-libs/glib-2.32:2
		>=x11-libs/gtk+-3.4:3
		ayatana? ( >=dev-libs/libappindicator-0.4.30:3 )
	)
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
		dev-qt/qtnetwork:5
		dev-qt/qtdbus:5
	)
	systemd? ( >=sys-apps/systemd-209:= )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? (
		virtual/libintl
		gtk? (
			dev-util/intltool
			sys-devel/gettext
		)
		qt5? (
			dev-qt/linguist-tools:5
		)
	)
"

src_unpack() {
	if [[ ${PV} == 9999 ]]; then
		git-r3_src_unpack
	else
		unpack ${P}.tar.gz
	fi
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_DOCDIR=share/doc/${PF}

		-DENABLE_GTK=$(usex gtk ON OFF)
		-DENABLE_LIGHTWEIGHT=$(usex lightweight ON OFF)
		-DENABLE_NLS=$(usex nls ON OFF)
		-DENABLE_QT=$(usex qt5 ON OFF)
		-DENABLE_TESTS=$(usex test ON OFF)
		-DUSE_QT5=ON

		-DUSE_SYSTEM_EVENT2=ON
		-DUSE_SYSTEM_DHT=OFF
		-DUSE_SYSTEM_MINIUPNPC=ON
		-DUSE_SYSTEM_NATPMP=ON
		-DUSE_SYSTEM_UTP=OFF
		-DUSE_SYSTEM_B64=OFF

		-DWITH_CRYPTO=openssl
		-DWITH_INOTIFY=ON
		-DWITH_LIBAPPINDICATOR=$(usex ayatana ON OFF)
		-DWITH_SYSTEMD=$(usex systemd ON OFF)
	)

	cmake-utils_src_configure

	symlink_tarball() {
		local srcdir="${BUILD_DIR}/third-party/${1}-${3}/src"
		mkdir -p "${srcdir}" || die
		ln -s "${DISTDIR}/${2}-${3}.tar.gz" "${srcdir}/${3}.tar.gz" || die
	}

	symlink_tarball dht dht "${DHT_ID}"
	symlink_tarball utp libutp "${UTP_ID}"
	symlink_tarball b64 libb64 "${B64_ID}"
}

DISABLE_AUTOFORMATTING=1
DOC_CONTENTS="\
If you use transmission-daemon, please, set 'rpc-username' and
'rpc-password' (in plain text, transmission-daemon will hash it on
start) in settings.json file located at /var/lib/transmission/config or
any other appropriate config directory.

Since µTP is enabled by default, transmission needs large kernel buffers for
the UDP socket. You can append following lines into /etc/sysctl.conf:

net.core.rmem_max = 4194304
net.core.wmem_max = 1048576

and run sysctl -p"

src_install() {
	cmake-utils_src_install

	newinitd "${FILESDIR}"/transmission-daemon.initd.10 transmission-daemon
	newconfd "${FILESDIR}"/transmission-daemon.confd.4 transmission-daemon
	systemd_dounit daemon/transmission-daemon.service
	systemd_install_serviced "${FILESDIR}"/transmission-daemon.service.conf

	readme.gentoo_create_doc
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postrm() {
	xdg_desktop_database_update
	gnome2_icon_cache_update
}

pkg_postinst() {
	xdg_desktop_database_update
	gnome2_icon_cache_update

	enewgroup transmission
	enewuser transmission -1 -1 /var/lib/transmission transmission

	if [[ ! -e "${EROOT%/}"/var/lib/transmission ]]; then
		mkdir -p "${EROOT%/}"/var/lib/transmission || die
		chown transmission:transmission "${EROOT%/}"/var/lib/transmission || die
	fi

	readme.gentoo_print_elog
}
