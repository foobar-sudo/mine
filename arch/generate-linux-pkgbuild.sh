#!/bin/bash
pkgver=$(curl -s https://www.kernel.org/ | grep -A1 'stable:' | grep -oP '(?<=strong>).*(?=</strong.*)' | head -n1)
vermajor=$(echo $pkgver | grep -o1 "[0-9*].[0-9]*" | head -n1)
gitdir="."
patchdir="kernel-patches/$vermajor"
cd $gitdir
git clone https://gitlab.com/sirlucjan/kernel-patches.git
patchdirs=$(ls $patchdir | grep -vwE *sep | grep -vwE *-dev* | grep -vwE *-trunk* | grep -vwE *ll* | while read line; do if [[ $line = *-v* ]]; then (printf "%s\n" $patchdir/${line%-v*}* | grep -vwE *sep | grep -vwE *ll* | grep -vwE *-trunk* | grep -vwE *-dev* | tail -n1 | sed -rne "s|$patchdir/(.*)|\1|gp"); else ls $patchdir/$line*-v* 1>/dev/null 2>&1 || echo $line; fi; done | uniq)
patchfiles=$(printf "%s\n" $patchdirs | while read line; do echo $(ls $patchdir/$line/*); done | sed -rne "s|$patchdir/(.*)|\1|gp")
treeurl="https://gitlab.com/sirlucjan/kernel-patches/-/tree/master/$vermajor"
cat << EOF > PKGBUILD.tmp
#THIS FILE WAS AUTOMATICALLY GENERATED ON $(date -Ru${SOURCE_DATE_EPOCH:+d @$SOURCE_DATE_EPOCH})
_major=$vermajor
pkgbase=linux-custom-git
pkgver="${pkgver}.custom1"
pkgrel=1
pkgdesc='Linux'
url=""
arch=(x86_64)
license=(GPL2)
makedepends=(
  bc kmod libelf pahole cpio perl tar xz
  xmlto python-sphinx python-sphinx_rtd_theme graphviz imagemagick
  git
)
options=('!strip')
_srcname=linux
source=(git://git.kernel.org/pub/scm/linux/kernel/git/stable/${_srcname}.git#branch=linux-${_major}.y
$(printf "$treeurl/%s\n" $patchfiles)
.config::https://git.archlinux.org/svntogit/packages.git/plain/trunk/config?h=packages/linux
)
EOF

cat << "EOF" >> PKGBUILD.tmp
validpgpkeys=(
  'ABAF11C65A2970B130ABE3C479BE3E4300411886'  # Linus Torvalds
  '647F28654894E3BD457199BE38DBBDC86092693E'  # Greg Kroah-Hartman
  'A2FF3A36AAA56654109064AB19802F8B0D70FC30'  # Jan Alexander Steffens (heftig)
)
sha256sums=('SKIP'
            '6dde032690644a576fd36c4a7d3546d9cec0117dd3fb17cea6dc95e907ef9bef')

export KBUILD_BUILD_HOST=archlinux
export KBUILD_BUILD_USER=$pkgbase
export KBUILD_BUILD_TIMESTAMP="$(date -Ru${SOURCE_DATE_EPOCH:+d @$SOURCE_DATE_EPOCH})"

prepare() {
  cd $_srcname

  echo "Setting version..."
  scripts/setlocalversion --save-scmversion
  echo "-$pkgrel" > localversion.10-pkgrel
  echo "${pkgbase#linux}" > localversion.20-pkgname

  local src
  for src in "${source[@]}"; do
    src="${src%%::*}"
    src="${src##*/}"
    [[ $src = .config ]] && echo "Setting config..."; cp "../$src" .config
    [[ $src = *.patch ]] || continue
    echo "Applying patch $src..."
    patch -Np1 < "../$src"
  done

  #echo "Setting config..."
  #cp ../config .config
  #make olddefconfig
  echo "Making some changes to config..."
  scripts/config --enable CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE_O3
  scripts/config --enable CONFIG_HZ_1000
  scripts/config --set-val CONFIG_HZ 1000
  scripts/config --enable CONFIG_MNATIVE_INTEL
  scripts/config --enable CONFIG_SCHED_PDS
  scripts/config --enable CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE
  scripts/config --enable CONFIG_UNEVICTABLE_FILE
  scripts/config --set-val CONFIG_UNEVICTABLE_FILE_KBYTES_LOW 262144
  scripts/config --set-val CONFIG_UNEVICTABLE_FILE_KBYTES_MIN 131072
  scripts/config --enable CONFIG_BTRFS_FS_POSIX_ACL
  scripts/config --disable CONFIG_HZ_300
  scripts/config --disable CONFIG_CPU_FREQ_DEFAULT_GOV_SCHEDUTIL
  scripts/config --disable CONFIG_CPU_FREQ_GOV_ONDEMAND
  scripts/config --disable CONFIG_CPU_FREQ_GOV_CONSERVATIVE
  scripts/config --disable CONFIG_CPU_FREQ_GOV_USERSPACE
  scripts/config --disable CONFIG_CPU_FREQ_GOV_SCHEDUTIL
  scripts/config --disable CONFIG_LL_BRANDING
  scripts/config --disable CONFIG_SCHED_BMQ
  scripts/config --disable CONFIG_NUMA
  scripts/config --disable CONFIG_MODULE_COMPRESS_XZ
  echo "Make menuconfig..."

  make -s kernelrelease > version
  echo "Prepared $pkgbase version $(<version)"
  make menuconfig
}

build() {
  cd $_srcname
  make all
}

_package() {
  pkgdesc="The $pkgdesc kernel and modules"
  depends=(coreutils kmod initramfs)
  optdepends=('crda: to set the correct wireless channels of your country'
              'linux-firmware: firmware images needed for some devices')
  provides=(VIRTUALBOX-GUEST-MODULES WIREGUARD-MODULE)
  replaces=(virtualbox-guest-modules-arch wireguard-arch)

  cd $_srcname
  local kernver="$(<version)"
  local modulesdir="$pkgdir/usr/lib/modules/$kernver"

  echo "Installing boot image..."
  # systemd expects to find the kernel here to allow hibernation
  # https://github.com/systemd/systemd/commit/edda44605f06a41fb86b7ab8128dcf99161d2344
  install -Dm644 "$(make -s image_name)" "$modulesdir/vmlinuz"

  # Used by mkinitcpio to name the kernel
  echo "$pkgbase" | install -Dm644 /dev/stdin "$modulesdir/pkgbase"

  echo "Installing modules..."
  make INSTALL_MOD_PATH="$pkgdir/usr" INSTALL_MOD_STRIP=1 modules_install

  # remove build and source links
  rm "$modulesdir"/{source,build}
}

_package-headers() {
  pkgdesc="Headers and scripts for building modules for the $pkgdesc kernel"
  depends=(pahole)

  cd $_srcname
  local builddir="$pkgdir/usr/lib/modules/$(<version)/build"

  echo "Installing build files..."
  install -Dt "$builddir" -m644 .config Makefile Module.symvers System.map \
    localversion.* version vmlinux
  install -Dt "$builddir/kernel" -m644 kernel/Makefile
  install -Dt "$builddir/arch/x86" -m644 arch/x86/Makefile
  cp -t "$builddir" -a scripts

  # add objtool for external module building and enabled VALIDATION_STACK option
  install -Dt "$builddir/tools/objtool" tools/objtool/objtool

  # add xfs and shmem for aufs building
  mkdir -p "$builddir"/{fs/xfs,mm}

  echo "Installing headers..."
  cp -t "$builddir" -a include
  cp -t "$builddir/arch/x86" -a arch/x86/include
  install -Dt "$builddir/arch/x86/kernel" -m644 arch/x86/kernel/asm-offsets.s

  install -Dt "$builddir/drivers/md" -m644 drivers/md/*.h
  install -Dt "$builddir/net/mac80211" -m644 net/mac80211/*.h

  # http://bugs.archlinux.org/task/13146
  install -Dt "$builddir/drivers/media/i2c" -m644 drivers/media/i2c/msp3400-driver.h

  # http://bugs.archlinux.org/task/20402
  install -Dt "$builddir/drivers/media/usb/dvb-usb" -m644 drivers/media/usb/dvb-usb/*.h
  install -Dt "$builddir/drivers/media/dvb-frontends" -m644 drivers/media/dvb-frontends/*.h
  install -Dt "$builddir/drivers/media/tuners" -m644 drivers/media/tuners/*.h

  echo "Installing KConfig files..."
  find . -name 'Kconfig*' -exec install -Dm644 {} "$builddir/{}" \;

  echo "Removing unneeded architectures..."
  local arch
  for arch in "$builddir"/arch/*/; do
    [[ $arch = */x86/ ]] && continue
    echo "Removing $(basename "$arch")"
    rm -r "$arch"
  done

  echo "Removing documentation..."
  rm -r "$builddir/Documentation"

  echo "Removing broken symlinks..."
  find -L "$builddir" -type l -printf 'Removing %P\n' -delete

  echo "Removing loose objects..."
  find "$builddir" -type f -name '*.o' -printf 'Removing %P\n' -delete

  echo "Stripping build tools..."
  local file
  while read -rd '' file; do
    case "$(file -bi "$file")" in
      application/x-sharedlib\;*)      # Libraries (.so)
        strip -v $STRIP_SHARED "$file" ;;
      application/x-archive\;*)        # Libraries (.a)
        strip -v $STRIP_STATIC "$file" ;;
      application/x-executable\;*)     # Binaries
        strip -v $STRIP_BINARIES "$file" ;;
      application/x-pie-executable\;*) # Relocatable binaries
        strip -v $STRIP_SHARED "$file" ;;
    esac
  done < <(find "$builddir" -type f -perm -u+x ! -name vmlinux -print0)

  echo "Stripping vmlinux..."
  strip -v $STRIP_STATIC "$builddir/vmlinux"

  echo "Adding symlink..."
  mkdir -p "$pkgdir/usr/src"
  ln -sr "$builddir" "$pkgdir/usr/src/$pkgbase"
}

pkgname=("$pkgbase" "$pkgbase-headers")
for _p in "${pkgname[@]}"; do
  eval "package_$_p() {
    $(declare -f "_package${_p#$pkgbase}")
    _package${_p#$pkgbase}
  }"
done
EOF
