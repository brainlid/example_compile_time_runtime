# CompileTimeRuntime

This is a demonstration project to help illustrate when code in an Elixir
project is evaluated and executed.

## Setup

This project was created using `mix new compile_time_runtime`.

## Demonstration

The code being demonstrated is in [`lib/compile_time_runtime.ex`](./lib/compile_time_runtime.ex).

Compile the project: `mix compile`

```shell
$ mix compile
Compiling 1 file (.ex)
I'M EVALUATED AND EXECUTED AT COMPILE TIME
Generated compile_time_runtime app
```

Execute the project interactively (IEx shell into the project).

```shell
$ iex -S mix
Erlang/OTP 22 [erts-10.5.5] [source] [64-bit] [smp:4:4] [ds:4:4:10] [async-threads:1] [hipe]

Interactive Elixir (1.9.4) - press Ctrl+C to exit (type h() ENTER for help)
```

```iex
iex(1)> CompileTimeRuntime.hello()
I'M EXECUTED AT RUN TIME
** (FunctionClauseError) no function clause matching in anonymous fn/2 in CompileTimeRuntime.hello/0

    The following arguments were given to anonymous fn/2 in CompileTimeRuntime.hello/0:

        # 1
        3

        # 2
        100

    (compile_time_runtime) lib/compile_time_runtime.ex:16: anonymous fn/2 in CompileTimeRuntime.hello/0
iex(1)>
```

Code *inside* a function that is valid syntax (checked at compile time) but
performs invalid pattern matches is not evaluated until runtime. Elixir
dynamically (at runtime) checks the types.

Code *outside* of a function is executed at compile time. This is when macros
are also executed as they operate on the compiled AST. This is not where
"normal" code is located in a project as the code is only performed once (when
compiled).

Note that dialyzer will check and identify the code problem. However, that is an
optional extra static check

## Dialyzer

Dialyzer is an optional, external static type checking resource in the Erlang
community. To test with this, uncomment the `dialyxir` dependency (to activate
it) in the `mix.exs` file under `deps()`.

Dialyxir is an Elixir library that brings in Elixir friendly support for
dialyzer.

Install dialyzer:

```
$ mix deps.get
Resolving Hex dependencies...
Dependency resolution completed:
New:
  dialyxir 1.0.0-rc.7
  erlex 0.2.5
* Getting dialyxir (Hex package)
* Getting erlex (Hex package)
```

Execute dialyzer's static check of the project. Note, on first run it will be
very slow (like 15 minutes) as it builds the PLT (Persistent Lookup Table) for
the project, Elixir and Erlang code.

Running it a second time is fast as the PLT is cached and reused.

```
$ mix dialyzer
==> erlex
Compiling 2 files (.erl)
Compiling 1 file (.ex)
Generated erlex app
==> dialyxir
Compiling 59 files (.ex)
Generated dialyxir app
==> compile_time_runtime
Compiling 1 file (.ex)
I'M EVALUATED AND EXECUTED AT COMPILE TIME
Generated compile_time_runtime app
Finding suitable PLTs
Checking PLT...
[:compiler, :crypto, :dialyxir, :dialyzer, :elixir, :erlex, :hipe, :kernel, :logger, :mix, :stdlib, :wx]
Looking up modules in dialyxir_erlang-22.1.7_elixir-1.9.4_deps-dev.plt
Looking up modules in dialyxir_erlang-22.1.7_elixir-1.9.4.plt
Looking up modules in dialyxir_erlang-22.1.7.plt
Finding applications for dialyxir_erlang-22.1.7.plt
Finding modules for dialyxir_erlang-22.1.7.plt
Creating dialyxir_erlang-22.1.7.plt
Looking up modules in dialyxir_erlang-22.1.7.plt
Removing 4 modules from dialyxir_erlang-22.1.7.plt
Checking 16 modules in dialyxir_erlang-22.1.7.plt
Adding 176 modules to dialyxir_erlang-22.1.7.plt
done in 1m0.23s
Finding applications for dialyxir_erlang-22.1.7_elixir-1.9.4.plt
Finding modules for dialyxir_erlang-22.1.7_elixir-1.9.4.plt
Copying dialyxir_erlang-22.1.7.plt to dialyxir_erlang-22.1.7_elixir-1.9.4.plt
Looking up modules in dialyxir_erlang-22.1.7_elixir-1.9.4.plt
Checking 192 modules in dialyxir_erlang-22.1.7_elixir-1.9.4.plt
Adding 235 modules to dialyxir_erlang-22.1.7_elixir-1.9.4.plt
done in 2m2.48s
Finding applications for dialyxir_erlang-22.1.7_elixir-1.9.4_deps-dev.plt
Finding modules for dialyxir_erlang-22.1.7_elixir-1.9.4_deps-dev.plt
Copying dialyxir_erlang-22.1.7_elixir-1.9.4.plt to dialyxir_erlang-22.1.7_elixir-1.9.4_deps-dev.plt
Looking up modules in dialyxir_erlang-22.1.7_elixir-1.9.4_deps-dev.plt
Checking 427 modules in dialyxir_erlang-22.1.7_elixir-1.9.4_deps-dev.plt
Adding 688 modules to dialyxir_erlang-22.1.7_elixir-1.9.4_deps-dev.plt
done in 4m28.3s
No :ignore_warnings opt specified in mix.exs and default does not exist.

Starting Dialyzer
[
  check_plt: false,
  init_plt: '/home/mark/thinking_code/compile_time_runtime/_build/dev/dialyxir_erlang-22.1.7_elixir-1.9.4_deps-dev.plt',
  files: ['/home/mark/thinking_code/compile_time_runtime/_build/dev/lib/compile_time_runtime/ebin/Elixir.CompileTimeRuntime.beam'],
  warnings: [:unknown]
]
Total errors: 5, Skipped: 0, Unnecessary Skips: 0
done in 0m2.88s
lib/compile_time_runtime.ex:13:no_return
Function hello/0 has no local return.
________________________________________________________________________________
lib/compile_time_runtime.ex:16:no_return
The created anonymous function has no local return.
________________________________________________________________________________
lib/compile_time_runtime.ex:17:pattern_match
The pattern can never match the type.

Pattern:
1, _x

Type:
3, 100

________________________________________________________________________________
lib/compile_time_runtime.ex:18:pattern_match
The pattern can never match the type.

Pattern:
2, _x

Type:
3, 100

________________________________________________________________________________
lib/compile_time_runtime.ex:20:apply
Function application with arguments (3, 100) will never return since it differs in arguments with
positions 1st from the success typing arguments:

(1 | 2, any())

________________________________________________________________________________
done (warnings were emitted)
Halting VM with exit status 2
```

The first dialyzer error says this:

```
lib/compile_time_runtime.ex:13:no_return
Function hello/0 has no local return.
```

The term `no_return` is a fairly cryptic way of saying "There are conditions in
this function which will **never match** resulting in a runtime error." A
runtime error means the function doesn't give a return value, hence the function
"has no local return".
