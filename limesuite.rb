class Limesuite < Formula
  desc "Lime suite device drivers, GUI, and SDR support"
  homepage "https://github.com/myriadrf/LimeSuite/blob/master/README.md"
  head "https://github.com/myriadrf/LimeSuite.git"
  url "https://github.com/myriadrf/LimeSuite/archive/v19.01.0.tar.gz"
  sha256 "06bc5cb40ae5ebcf7104a02d73864bb1526fd3f86d58f38f3d419b38ed52761e"

  depends_on "cmake" => :build
  depends_on "sqlite" #core library dependency
  depends_on "libusb" => :recommended
  depends_on "wxwidgets" => :recommended
  depends_on "soapysdr" => :recommended
  option "with-images", "Download and install firmware/gatware images"

  def install
    args = ["-DENABLE_QUICKTEST=OFF"]
    args += ["-DENABLE_OCTAVE=OFF"]

    if build.with?("images")
      args += ["-DDOWNLOAD_IMAGES=TRUE"]
    else
      args += ["-DDOWNLOAD_IMAGES=FALSE"]
    end

    if build.with?("libusb")
      args += ["-DENABLE_STREAM=ON"]
    else
      args += ["-DENABLE_STREAM=OFF"]
    end

    if build.with?("wxwidgets")
      args += ["-DENABLE_GUI=ON"]
    else
      args += ["-DENABLE_GUI=OFF"]
    end

    #novena is arm linux only
    args += ["-DENABLE_NOVENARF7=OFF"]

    if build.with?("soapysdr")
      args += ["-DENABLE_SOAPY_LMS7=ON"]
    else
      args += ["-DENABLE_SOAPY_LMS7=OFF"]
    end

    if !(build.head?)
      args += ["-DLIME_SUITE_EXTVER=release"]
    end

    args += %W[-DLIME_SUITE_ROOT='#{HOMEBREW_PREFIX}']

    mkdir "builddir" do
      args += std_cmake_args
      system "cmake", "..", *args
      system "make", "install"
    end
  end
end
