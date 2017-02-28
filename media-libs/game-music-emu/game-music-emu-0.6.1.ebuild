# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: 8cd4665d4d2c5ca74ab5e4fb0e627b3cd960045b $

EAPI=5
inherit cmake-multilib

DESCRIPTION="Video game music file emulators"
HOMEPAGE="https://bitbucket.org/mpyne/game-music-emu/wiki/Home"
SRC_URI="https://bitbucket.org/mpyne/game-music-emu/downloads/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha ~amd64 arm ~hppa ~ppc ~ppc64 ~x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

DOCS="changes.txt design.txt gme.txt readme.txt"
