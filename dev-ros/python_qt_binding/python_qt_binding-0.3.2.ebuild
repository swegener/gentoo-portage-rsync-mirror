# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: b1d48bf1707299aba48f58e68ec12b037f50916a $

EAPI=5

ROS_REPO_URI="https://github.com/ros-visualization/python_qt_binding"
KEYWORDS="~amd64"
PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit ros-catkin

DESCRIPTION="Infrastructure for an integrated graphical user interface based on Qt"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="
	dev-python/PyQt5[gui,widgets,${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
