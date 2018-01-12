# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit multilib-build

DESCRIPTION="Virtual for libelf.so.0 provider dev-libs/libelf"
SLOT="0/0"
KEYWORDS="alpha amd64 arm hppa m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-linux ~arm-linux ~x86-linux"

RDEPEND=">=dev-libs/libelf-0.8.13-r2:0/0[${MULTILIB_USEDEP}]"
