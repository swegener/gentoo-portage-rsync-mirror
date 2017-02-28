# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: 65a1974193cd41ece6d06fff411f211a3fdd24e2 $

EAPI=6

MY_PN="${PN/PEAR-/}"
MY_PV="${PV/_/}"
MY_PV="${MY_PV^^}"
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="Package for reading and writing OLE containers"
HOMEPAGE="http://pear.php.net/package/${MY_PN}"
SRC_URI="http://download.pear.php.net/package/${MY_P}.tgz"
LICENSE="PHP-3.01"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE=""

RDEPEND="dev-lang/php:*
	dev-php/PEAR-PEAR"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	eapply "${FILESDIR}/pear-bug-19284.patch" \
		"${FILESDIR}/${PV}-fix-static-calls.patch"
	eapply_user
}

src_install() {
	insinto /usr/share/php
	doins "${MY_PN}.php"
	doins -r "${MY_PN}"
}
