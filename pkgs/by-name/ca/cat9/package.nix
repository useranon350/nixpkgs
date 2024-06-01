{ lib
, stdenvNoCC
, fetchFromGitHub
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "cat9";
  version = "unstable-2023-06-02";

  src = fetchFromGitHub {
    owner = "letoram";
    repo = "cat9";
    rev = "6d90fc3a5a774fb44f303e1df8ea1458333be1cf";
    hash = "sha256-3nGEsSgWFnSzY7YwE0ApNWZzQNuPfaA+aQLoltd3x8Y=";
  };

  dontConfigure = true;

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p ${placeholder "out"}/share/arcan/appl/cat9
    cp -a ./* ${placeholder "out"}/share/arcan/appl/cat9

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/letoram/cat9";
    description = "A User shell for LASH";
    license = with lib.licenses; [ unlicense ];
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.all;
  };
})
