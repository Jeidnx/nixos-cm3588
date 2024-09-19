/*
MIT License

Copyright (c) 2023 Ryan Yin

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

# Source: https://github.com/ryan4yin/nixos-rk3588/blob/c4fef04d8c124146e6e99138283e0c57b2ad8e29/pkgs/mali-firmware/default.nix
{
  stdenv,
  fetchurl,
}:
stdenv.mkDerivation {
  pname = "mali-g610-firmware";
  version = "g21p0-01eac0";

  src = fetchurl {
    url = "https://github.com/JeffyCN/mirrors/raw/e08ced3e0235b25a7ba2a3aeefd0e2fcbd434b68/firmware/g610/mali_csffw.bin";
    hash = "sha256-jnyCGlXKHDRcx59hJDYW3SX8NbgfCQlG8wKIbWdxLfU=";
  };

  buildCommand = ''
    install -Dm444 $src $out/lib/firmware/mali_csffw.bin
  '';
}
