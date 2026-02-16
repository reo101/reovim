{ lib, stdenv, lua, src }:

stdenv.mkDerivation {
  pname = "fennel";
  version = "1.7.0-dev-discard";
  inherit src;

  buildInputs = [ lua ];

  makeFlags = [
    "PREFIX=$(out)"
    "LUA=${lib.getExe lua}"
  ];

  meta = {
    description = "Lua Lisp Language (with #_ discard support)";
    homepage = "https://fennel-lang.org/";
    license = lib.licenses.mit;
    mainProgram = "fennel";
  };
}
