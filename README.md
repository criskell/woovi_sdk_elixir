# woovi-sdk

An SDK for communicating with the Woovi API.

## Examples

There is an application called `donation_app` in the `examples` folder that tests the Woovi SDK, made using Phoenix Live View.
This application tests the creation of charges and the receipt of webhooks from Woovi in ​​a Phoenix application; you can use it to understand the integration flow between the Woovi SDK and your Phoenix application.
See a demonstration of this application in this video:
https://www.youtube.com/watch?v=RYoFOGhtLVU

## Installation

The package can be installed by adding `woovi_sdk` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:woovi_sdk, "~> 0.1.0"}
  ]
end
```
