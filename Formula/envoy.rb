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
  depends_on "llvm@10" => :build

  # Fix source/common/common/utility.cc:309:21: error: loop variable 'token' of type
  # 'const absl::string_view' creates a copy from type 'const absl::string_view'
  # [-Werror,-Wrange-loop-analysis]
  # patch do
  #   url "https://gist.githubusercontent.com/dio/f3f3f15a18f14ace24e26446a205299a/raw/58552ba7794b91a217c31ded0e650e52bd5cb0bc/string_view_ref.patch"
  #   sha256 "a413e5c34c937e78d5cb8548e3831bb90fa3a0a6c7c6538eb61114b1acbcaa81"
  # end

  def install
    ENV["PATH"] = "/usr/local/bin:/opt/local/bin:/usr/bin:/bin:#{ENV["PATH"]}"
    system "bazelisk", "--bazelrc=/dev/null",
                       "build",
                       "-c",
                       "opt",
                       "//source/exe:envoy-static.stripped"

    bin.install "bazel-bin/source/exe/envoy-static.stripped" => "envoy"
  end

  test do
    system bin/"envoy", "--version"
  end
end