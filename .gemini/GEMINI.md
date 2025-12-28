## Gemini Added Memories
- The project uses Protocol Buffers (via `prost`) for serialization and gRPC, specifically in `clairvo-calls-gateway`, `clairvo-power-dialer`, `clairvo-api`, and `clairvo-calls-processor`.
- Added `libs/clairvo-fury` library for Apache Fury support in Rust using `fory` crate. Modified `freeswitch/dockerfile` to build Apache Fury C++ from source.
- mod_clairvo now uses CMake for building and depends on Apache Fury C++.
