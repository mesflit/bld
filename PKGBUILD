pkgname=bld
pkgver=19.12.24
pkgrel=1
pkgdesc="Bld is a great program for managing PKGBUILDs"
arch=('any')
url="https://github.com/mesflit/bld"
license=('GPL')
depends=('bash')
source=("git+https://github.com/mesflit/bld.git")
sha256sums=('SKIP') 

prepare() {
    cd "$srcdir/$pkgname"
}


build() {
    cd "$srcdir/$pkgname"
}

package() {
    cd "$srcdir/$pkgname"
    install -Dm755 "$srcdir/$pkgname/bld.sh" "$pkgdir/usr/local/bin/bld"
}

clean() {
    rm -rf "$srcdir" "$pkgdir"
}

