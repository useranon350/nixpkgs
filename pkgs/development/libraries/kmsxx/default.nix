{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, cmake
, pkg-config
, libdrm
, fmt
, libevdev
, libGL
, libX11
, wayland
, mesa
, withPython ? false
, python3Packages
}:

stdenv.mkDerivation {
  pname = "kmsxx";
  version = "2024-05-02";

  src = fetchFromGitHub {
    owner = "tomba";
    repo = "kmsxx";
    fetchSubmodules = true;
    rev = "9ae90ce75478e49844cf984562db0dc1a074462f";
    sha256 = "sha256-XZth4VtXMjZpjEqynwooU0PDrdlVQmQnJXfaosH+2Ok=";
  };

  # Didn't detect pybind11 without cmake
  nativeBuildInputs = [ meson ninja pkg-config ] ++ lib.optionals withPython [ cmake ];
  buildInputs = [ libGL wayland mesa libX11 libdrm fmt libevdev ]
    ++ lib.optionals withPython (with python3Packages; [ python pybind11 ]);

  dontUseCmakeConfigure = true;

  mesonFlags = [
    "-Dkmscube=true"
  ] ++ lib.optional (!withPython) "-Dpykms=disabled";

  postPatch = ''
    substituteInPlace ./utils/meson.build \
      --replace-fail "install : false" "install : true"
    substituteInPlace ./kmscube/meson.build \
      --replace-fail ": kmscube_deps)" ": kmscube_deps, install : true)"
    substituteInPlace ./kmscube/cube-gbm.cpp \
      --replace-fail "GBM_BO_USE_SCANOUT | GBM_BO_USE_RENDERING" "0"
  '';

  meta = with lib; {
    description = "C++11 library, utilities and python bindings for Linux kernel mode setting";
    homepage = "https://github.com/tomba/kmsxx";
    license = licenses.mpl20;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
