class NeovimQt < Formula
    desc "Neovim client library and GUI, in Qt5"
    homepage "https://github.com/equalsraf/neovim-qt"
    url "https://github.com/equalsraf/neovim-qt/releases/download/v0.2.16.1/neovim-qt.zip"
    sha256 "ddb4492db03da407703fb0ab271c4eb060250d1a7d71200e2b3b981cb0de59de"

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
