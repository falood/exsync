ExSync
======

Yet another Elixir reloader.

## Usage

1. Create a new application

        mix new my_app

2. Add exsync to your `mix.exs` dependencies:

        def deps do
          [ {:exsync, github: "~> 0.0.1", only: :dev} ]
        end

3. List `:exsync` as your application dependencies:

        def application do
          [ applications: [:exsync] ]
        end
