class Gdmap < Formula
  desc "Tool to inspect the used space of folders"
  homepage "https://sourceforge.net/projects/gdmap/"
  url "https://downloads.sourceforge.net/project/gdmap/gdmap/0.8.1/gdmap-0.8.1.tar.gz"
  sha256 "a200c98004b349443f853bf611e49941403fce46f2335850913f85c710a2285b"
  revision 2

  bottle do
    sha256 "d465a02727acca541229325a9d3ffa79e1ef9693512da5b1d3a3b37437fbe00d" => :catalina
    sha256 "9c178f409b81ce7808efe356bf09d82804265de11d4527dcc1dea20948a76b16" => :mojave
    sha256 "1f82d4cf21c4166fd579e132e3ecf7302179cba2d6b19bf33ef18618f5354416" => :high_sierra
    sha256 "2a5da8dc2b00407271001ef511d61cad03f043cc98b45442ab1aff7d9263ae19" => :sierra
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "gtk+"

  # The code depends on some GTK macros that are flagged as deprecated in the brew version of GTK.
  # I assume they're not deprecated in normal GTK, because the config file disables deprecated GDK calls.
  # The first patch turns off this disablement, making the code work fine as intended
  # The second patch is to remove an unused system header import on one of the files.
  # This header file doesn't exist in OSX and the program compiles and runs fine without it.
  # Filed bug upstream as https://sourceforge.net/p/gdmap/bugs/19/
  patch :DATA

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    system "make", "install"
  end

  test do
    system "#{bin}/gdmap", "--help"
  end
end

__END__
diff --git a/configure b/configure
index fc7ed80..bb408d3 100755
--- a/configure
+++ b/configure
@@ -8225,7 +8225,7 @@ else
 echo "${ECHO_T}yes" >&6; }
         :
 fi
-UI_CFLAGS="$UI_CFLAGS -DGTK_DISABLE_DEPRECATED"
+#UI_CFLAGS="$UI_CFLAGS -DGTK_DISABLE_DEPRECATED"



diff --git a/src/gui_main.c b/src/gui_main.c
index efe2239..91c2a14 100644
--- a/src/gui_main.c
+++ b/src/gui_main.c
@@ -11,7 +11,6 @@
 #  include <config.h>
 #endif

-#include <sys/vfs.h>
 #include <stdlib.h>
 #include <math.h>
 #include <string.h>
