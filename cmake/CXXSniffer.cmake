message ("-- Configuring C++11")
message ("-- System: ${CMAKE_SYSTEM_NAME}")

include (CheckCXXCompilerFlag)

# NOTE: Phase out -std=gnu++0x and --std=c++0x as soon as realistically possible.
CHECK_CXX_COMPILER_FLAG("-std=c++11"   _HAS_CXX11)
CHECK_CXX_COMPILER_FLAG("-std=c++0x"   _HAS_CXX0X)
CHECK_CXX_COMPILER_FLAG("-std=gnu++0x" _HAS_GNU0X)

if (_HAS_CXX11)
  set (_CXX11_FLAGS "-std=c++11")
elseif (_HAS_CXX0X)
  message (WARNING "Enabling -std=c++0x draft compile flag. Your compiler does not support the standard '-std=c++11' option.  Consider upgrading.")
  set (_CXX11_FLAGS "-std=c++0x")
elseif (_HAS_GNU0X)
  message (WARNING "Enabling -std=gnu++0x draft compile flag. Your compiler does not support the standard '-std=c++11' option. Consider upgrading.")
  set (_CXX11_FLAGS "-std=gnu++0x")
else (_HAS_CXX11)
 message (FATAL_ERROR "C++11 support missing. Try upgrading your C++ compiler. If you have a good reason for using an outdated compiler, please let us know at support@taskwarrior.org.")
endif (_HAS_CXX11)

if (${CMAKE_SYSTEM_NAME} MATCHES "Linux")
  set (LINUX true)
elseif (${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
  set (DARWIN true)
  set (_CXX11_FLAGS "${_CXX11_FLAGS} -stdlib=libc++")
elseif (${CMAKE_SYSTEM_NAME} MATCHES "kFreeBSD")
  set (KFREEBSD true)
elseif (${CMAKE_SYSTEM_NAME} MATCHES "FreeBSD")
  set (FREEBSD true)
elseif (${CMAKE_SYSTEM_NAME} MATCHES "OpenBSD")
  set (OPENBSD true)
elseif (${CMAKE_SYSTEM_NAME} MATCHES "NetBSD")
  set (NETBSD true)
elseif (${CMAKE_SYSTEM_NAME} MATCHES "SunOS")
  set (SOLARIS true)
elseif (${CMAKE_SYSTEM_NAME} STREQUAL "GNU")
  set (GNUHURD true)
elseif (${CMAKE_SYSTEM_NAME} STREQUAL "CYGWIN")
  set (CYGWIN true)
  # NOTE: Not setting -std=gnu++0x leads to compile errors even with
  #       GCC 4.8.3, and debugging those leads to insanity. Adding this
  #       workaround instead of fixing Cygwin.
  set (_CXX11_FLAGS "-std=gnu++0x")
else (${CMAKE_SYSTEM_NAME} MATCHES "Linux")
  set (UNKNOWN true)
endif (${CMAKE_SYSTEM_NAME} MATCHES "Linux")

set (CMAKE_CXX_FLAGS "${_CXX11_FLAGS} ${CMAKE_CXX_FLAGS}")
set (CMAKE_CXX_FLAGS "-Wall -Wextra -Wsign-compare -Wreturn-type ${CMAKE_CXX_FLAGS}")
