add IterativeSolvers
   Resolving package versions...
    Updating `~/.julia/environments/v1.7/Project.toml`
  [42fd0dbc] + IterativeSolvers v0.9.2
  No Changes to `~/.julia/environments/v1.7/Manifest.toml`

(@v1.7) pkg> test IterativeSolvers
     Testing IterativeSolvers
      Status `/tmp/jl_Q2BEC9/Project.toml`
  [e30172f5] Documenter v0.26.3
  [42fd0dbc] IterativeSolvers v0.9.2
  [7a12625a] LinearMaps v3.8.0
  [3cdcf5f2] RecipesBase v1.2.1
  [37e2e46d] LinearAlgebra `@stdlib/LinearAlgebra`
  [9a3f8284] Random `@stdlib/Random`
  [2f01184e] SparseArrays `@stdlib/SparseArrays`
  [8dfed614] Test `@stdlib/Test`
      Status `/tmp/jl_Q2BEC9/Manifest.toml`
  [ffbed154] DocStringExtensions v0.8.6
  [e30172f5] Documenter v0.26.3
  [b5f81e59] IOCapture v0.1.1
  [42fd0dbc] IterativeSolvers v0.9.2
  [682c06a0] JSON v0.21.3
  [7a12625a] LinearMaps v3.8.0
  [69de0a69] Parsers v2.3.2
  [3cdcf5f2] RecipesBase v1.2.1
  [56f22d72] Artifacts `@stdlib/Artifacts`
  [2a0f44e3] Base64 `@stdlib/Base64`
  [ade2ca70] Dates `@stdlib/Dates`
  [b77e0a4c] InteractiveUtils `@stdlib/InteractiveUtils`
  [76f85450] LibGit2 `@stdlib/LibGit2`
  [8f399da3] Libdl `@stdlib/Libdl`
  [37e2e46d] LinearAlgebra `@stdlib/LinearAlgebra`
  [56ddb016] Logging `@stdlib/Logging`
  [d6f4376e] Markdown `@stdlib/Markdown`
  [a63ad114] Mmap `@stdlib/Mmap`
  [ca575930] NetworkOptions `@stdlib/NetworkOptions`
  [de0858da] Printf `@stdlib/Printf`
  [3fa0cd96] REPL `@stdlib/REPL`
  [9a3f8284] Random `@stdlib/Random`
  [ea8e919c] SHA `@stdlib/SHA`
  [9e88b42a] Serialization `@stdlib/Serialization`
  [6462fe0b] Sockets `@stdlib/Sockets`
  [2f01184e] SparseArrays `@stdlib/SparseArrays`
  [10745b16] Statistics `@stdlib/Statistics`
  [8dfed614] Test `@stdlib/Test`
  [4ec0a83e] Unicode `@stdlib/Unicode`
  [e66e0078] CompilerSupportLibraries_jll `@stdlib/CompilerSupportLibraries_jll`
  [4536629a] OpenBLAS_jll `@stdlib/OpenBLAS_jll`
  [8e850b90] libblastrampoline_jll `@stdlib/libblastrampoline_jll`
Precompiling project...
  2 dependencies successfully precompiled in 10 seconds (9 already precompiled)
     Testing Running tests...
Test Summary:    | Pass  Total
Basic operations |    4      4
[ Info: SetupBuildDirectory: setting up build directory.
[ Info: Doctest: running doctests.
[ Info: Skipped ExpandTemplates step (doctest only).
[ Info: Skipped CrossReferences step (doctest only).
[ Info: Skipped CheckDocument step (doctest only).
[ Info: Skipped Populate step (doctest only).
[ Info: Skipped RenderDocument step (doctest only).
Test Summary:              | Pass  Total
Doctests: IterativeSolvers |    1      1
Test Summary:     | Pass  Total
Orthogonalization |   24     24
Test Summary: | Pass  Total
Hessenberg    |    4      4
Test Summary:      | Pass  Total
Stationary solvers |  153    153
Test Summary:       | Pass  Total
Conjugate Gradients |   54     54
Test Summary: | Pass  Total
BiCGStab(l)   |   54     54
Test Summary: | Pass  Total
MINRES        |   52     52
Matrix{Float32}: Test Failed at /home/ian/.julia/packages/IterativeSolvers/rhYBz/test/gmres.jl:30
  Expression: norm(F \ (A * x - b)) / norm(b) ≤ reltol
   Evaluated: 0.0019488388f0 ≤ 0.00034526698f0
Stacktrace:
 [1] macro expansion
   @ ~/julia-1.7.3/share/julia/stdlib/v1.7/Test/src/Test.jl:445 [inlined]
 [2] macro expansion
   @ ~/.julia/packages/IterativeSolvers/rhYBz/test/gmres.jl:30 [inlined]
 [3] macro expansion
   @ ~/julia-1.7.3/share/julia/stdlib/v1.7/Test/src/Test.jl:1359 [inlined]
 [4] macro expansion
   @ ~/.julia/packages/IterativeSolvers/rhYBz/test/gmres.jl:16 [inlined]
 [5] macro expansion
   @ ~/julia-1.7.3/share/julia/stdlib/v1.7/Test/src/Test.jl:1283 [inlined]
 [6] top-level scope
   @ ~/.julia/packages/IterativeSolvers/rhYBz/test/gmres.jl:13
Test Summary:                                    | Pass  Fail  Total
GMRES                                            |   53     1     54
  Matrix{Float32}                                |    5     1      6
  Matrix{Float64}                                |    6            6
  Matrix{ComplexF32}                             |    6            6
  Matrix{ComplexF64}                             |    6            6
  SparseMatrixCSC{Float64, Int64}                |    5            5
  SparseMatrixCSC{Float64, Int32}                |    5            5
  SparseMatrixCSC{ComplexF64, Int64}             |    5            5
  SparseMatrixCSC{ComplexF64, Int32}             |    5            5
  Linear operator defined as a function          |    1            1
  Off-diagonal in hessenberg matrix exactly zero |    1            1
  Termination criterion                          |    8            8
ERROR: LoadError: Some tests did not pass: 53 passed, 1 failed, 0 errored, 0 broken.
in expression starting at /home/ian/.julia/packages/IterativeSolvers/rhYBz/test/gmres.jl:1
in expression starting at /home/ian/.julia/packages/IterativeSolvers/rhYBz/test/runtests.jl:22
ERROR: Package IterativeSolvers errored during testing

(@v1.7) pkg> 

