# Resin

*A very viscous liquid, will make your Plug-based application sluggish.*

Resin is a plug that will add a configurable delay to every request
that's passing through it, unless run in production.

This is basically a completely useless plug, unless your PM/boss/whoever
insists that your project is too snappy and wants a more "realistic"
demo...

## Usage

Given the example in [SimpleApp](examples/simple_app/lib/simple_app.ex):

```elixir
defmodule SimpleApp do
  use Plug.Router

  use Resin, enterpriseyness: 1_000

  plug :match
  plug :dispatch

  get "/hello" do
    conn
    |> send_resp(200,  "That sure was slo^H^H^Henterprisey, right?\n")
  end

  match _ do
    conn
    |> send_resp(404, "nope")
  end

  def start do
    Plug.Adapters.Cowboy.http SimpleApp, [], port: 4000
  end

  def stop do
    Plug.Adapters.Cowboy.shutdown SimpleApp.HTTP
  end
end
```

Then just run `SimpleApp.start` in your `iex` and start cURLing
localhost:4000/hello and feel the enterpriseyness:

    $ time curl localhost:4000
    nope
    curl localhost:4000  0.01s user 0.01s system 1% cpu 1.057 total


**Are your project managers complaining that your Elixir web application
is unrealistically fast, and that your demos does not reflect actual
production performance?**

Just pour some `resin` into its `Plug.Router` and it will be noticably
~~slower~~ more enterprisey!

    use Resin

**Did your management start believing you are faking this delay because
all requests take exactly the same amount of time to complete?**

Use a range for the `enterpriseyness` option, to make the
enterpriseyness level differ between requests, making the "performance
forecast" (thanks for that term, @DevL).

    use Resin, enterpriseyness: 1_000 .. 3_000

This will make add a random number between 1000 and 3000 milliseconds of
enterpriseyness.

**Worried that you will forget to clear out the resin before you ship to
production?**

No worries! Resin will detect that it's running in a production
environment, and just edit itself right out of your AST.

**Are you serious?**

Not really.

**But why?**

I was bored and I wanted to build a plug.

**Why the name?**

Resin is a very viscous liquid.

Also, `tar` would just be confusing, and `acts_as_enterprisey` is
already an existing thing for Rails, but it would also be too obvious.

**Isn't this just [acts_as_enterprisey](https://github.com/airblade/acts_as_enterprisey)
as a plug?**

Yes. Cred goes out to [@airblade](https://github.com/airblade) for inspiration.

