# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: da00453398841a049523e624b1d45093b3bdbd74 $

EAPI=5

PYTHON_COMPAT=( python{2_7,3_4,3_5} pypy)
inherit distutils-r1

DESCRIPTION="Pattern matching and various utilities for file systems paths"
HOMEPAGE="https://pypi.python.org/pypi/pathtools/"
SRC_URI="mirror://pypi/p/pathtools/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc x86"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
