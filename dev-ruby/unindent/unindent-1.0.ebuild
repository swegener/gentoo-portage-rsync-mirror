# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: 91e49e6c521e66cf87ea2b8c07ac21e85fe0da64 $

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22 ruby23"

RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_RECIPE_DOC="rdoc"

inherit ruby-fakegem

DESCRIPTION="Ruby method to unindent strings"
HOMEPAGE="https://github.com/mynyml/unindent"
LICENSE="MIT"

KEYWORDS="~amd64 arm ppc ppc64"
SLOT="0"
IUSE=""

ruby_add_bdepend "test? ( dev-ruby/nanotest )"

each_ruby_test() {
	${RUBY} -I.:lib test/test_unindent.rb || die
}
