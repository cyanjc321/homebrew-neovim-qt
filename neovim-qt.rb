class NeovimQt < Formula
    desc "Neovim client library and GUI, in Qt5"
    homepage "https://github.com/equalsraf/neovim-qt"
    url "https://github.com/equalsraf/neovim-qt/archive/v0.2.12.tar.gz"
    sha256 "f88a35683f2897d766bfd617c2bb9277e5e267a4b9c509807cbafa5cfe354cf6"

    head "https://github.com/equalsraf/neovim-qt"

    option "without-release", "Build neovim-qt without -DCMAKE_BUILD_TYPE=Release"

    depends_on "cmake" => :build
    depends_on "qt"
    depends_on "neovim"

    def install
        mkdir "build" do
            if build.without? "release"
                system "cmake", ".."
            else
                system "cmake", "-DCMAKE_BUILD_TYPE=Release", ".."
            end
            system "make"
            prefix.install "bin/nvim-qt.app"
            bin.install_symlink prefix/"nvim-qt.app/Contents/MacOS/nvim-qt"
        end
        # Create a runner script to extend 'PATH'
        # 'nvim-qt' could not find 'nvim' in '/usr/local/bin' in macOS High Sierra
        # even '/usr/local/bin' is listed in '/etc/paths'
        script = File.new(prefix/"nvim-qt.app/Contents/MacOS/nvim-qt-runner.sh", "w")
        script.puts("#!/bin/bash")
        script.puts('BASE="$(cd $(dirname $0); pwd)"')
        script.puts('(cd $HOME; PATH="/usr/local/bin:/usr/bin:/bin" "${BASE}/nvim-qt")')
        script.close()
        chmod('+x', prefix/"nvim-qt.app/Contents/MacOS/nvim-qt-runner.sh")
    end

    # Patch Info.plist to use runner script instead
    patch :DATA
end
__END__
index f4f4754..dd4d38a 100644
--- a/cmake/MacOSXBundleInfo.plist.in
+++ b/cmake/MacOSXBundleInfo.plist.in
@@ -5,7 +5,7 @@
<key>CFBundleDevelopmentRegion</key>
<string>English</string>
<key>CFBundleExecutable</key>
-	<string>nvim-qt</string>
+	<string>nvim-qt-runner.sh</string>
<key>CFBundleDisplayName</key>
<string>Neovim</string>
<key>CFBundleGetInfoString</key>
