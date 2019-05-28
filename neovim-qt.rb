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
    end
end
__END__
