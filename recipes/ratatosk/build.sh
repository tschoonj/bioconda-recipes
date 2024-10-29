#!/bin/bash -ex

mkdir -p "${PREFIX}/bin"

export INCLUDES="-I${PREFIX}/include"
export LIBPATH="-L${PREFIX}/lib"
export LDFLAGS="${LDFLAGS} -L${PREFIX}/lib"

export CXXFLAGS="${CXXFLAGS} -O3 -D_FILE_OFFSET_BITS=64 -I${PREFIX}/include"

if [[ `uname` == Darwin ]]; then
	export CONFIG_ARGS="-DCMAKE_FIND_FRAMEWORK=NEVER -DCMAKE_FIND_APPBUNDLE=NEVER"
	export LDFLAGS="${LDFLAGS} -Wl,-rpath,${PREFIX}/lib"
else
	export CONFIG_ARGS=""
fi

cmake -S . -B build \
	-DCMAKE_INSTALL_PREFIX="${PREFIX}" \
	-DCMAKE_BUILD_TYPE=Release \
	-DCMAKE_CXX_COMPILER="${CXX}" \
	-DCMAKE_CXX_FLAGS="${CXXFLAGS}" \
	"${CONFIG_ARGS}"

cmake --build build/ --target install -j "${CPU_COUNT}" -v
