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

  # Fix source/common/common/utility.cc:309:21: error: loop variable 'token' of type
  # 'const absl::string_view' creates a copy from type 'const absl::string_view'
  # [-Werror,-Wrange-loop-analysis]
  patch do
    url "https://gist.githubusercontent.com/dio/c2bc5b654accd3f700a6deffd8927cff/raw/aaf8d4512dea868d20e7aadf1e7bca32430635b1/common_common_utility.patch"
    sha256 "3c42a1b5dcc4bbb509386c67b10a86cc9e8e0425e41290d61837a306c5687e26"
  end

  def install
    system "bazelisk", "--bazelrc=/dev/null",
                       "build",
                       "-s",
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