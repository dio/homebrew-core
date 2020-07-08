class Envoy < Formula
  desc "Envoy"
  homepage "https://www.envoyproxy.io"
  url "https://github.com/envoyproxy/envoy.git",
      :tag      => "v1.15.0",
      :revision => "50ef0945fa2c5da4bff7627c3abf41fdd3b7cffd"

  depends_on "automake" => :build
  depends_on "bazelisk" => :build
  depends_on "coreutils" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "ninja" => :build
  depends_on "wget" => :build

  def install
    system "bazelisk", "--bazelrc=/dev/null",
                       "build",
                       "--action_env=PATH=/usr/local/bin:/opt/local/bin:/usr/bin:/bin",
                       "-c",
                       "opt",
                       "//source/exe:envoy-static.stripped"

    bin.install "bazel-bin/source/exe/envoy-static.stripped" => "envoy"
  end

  test do
    system bin/"envoy", "--version"
  end
end