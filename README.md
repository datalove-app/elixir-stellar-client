# Stellar

[![Build Status](https://travis-ci.org/revelrylabs/elixir-stellar-client.svg?branch=master)](https://travis-ci.org/revelrylabs/elixir-stellar-client)
[![Hex.pm](https://img.shields.io/hexpm/dt/stellar.svg)](https://hex.pm/packages/stellar)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A [Stellar](https://stellar.org) client for Elixir.

[Documentation](https://hexdocs.pm/stellar)

## Installation

The package can be installed
by adding `stellar` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:stellar, "~> 0.2.0"}
  ]
end
```

Add the following to your configuration:

```elixir
config :stellar, network: :public # Default is `:public`. To use test network, use `:test`
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/stellar](https://hexdocs.pm/stellar).

## Contributing and Development

Bug reports and pull requests are welcomed. See [CONTRIBUTING.md](https://github.com/revelrylabs/elixir-stellar-client/blob/master/CONTRIBUTING.md)
for development guidance.

Everyone is welcome to participate in the project. We expect contributors to
adhere the Contributor Covenant Code of Conduct (see [CODE_OF_CONDUCT.md](https://github.com/revelrylabs/elixir-stellar-client/blob/master/CODE_OF_CONDUCT.md)).
