# PacketApi

An Elixir wrapper library for the [Packet](https://www.packet.com) HTTP API. It uses the [Tesla](https://hex.pm/packages/tesla) library under-the-covers for performing HTTP requests.

*This library is a work in progress!* See the [changelog](changelog.md) to see the current state of the API.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `packet_api` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:packet_api, "~> 0.1.0"}
  ]
end
```

## Basic Usage

To access the Packet API, you'll need an [auth token](https://www.packet.com/developers/api/#authentication). With that, you can create a `PacketApi.Request` map, which is then passed into subsequent API calls.

Example:
```elixir
request = PacketApi.request(auth_token: "YOUR AUTH TOKEN HERE")

PacketApi.OperatingSystems.list(request)
```

which returns
```elixir
{:ok, [
   %{
     "distro" => "freebsd",
     "id" => "7014aac5-b97c-4770-8a59-001b5638a4c0",
     "licensed" => false,
     "name" => "FreeBSD 12-testing",
     "preinstallable" => false,
     "pricing" => %{},
     "provisionable_on" => ["c1.large.arm", "baremetal_2a", "c1.small.x86",
      "baremetal_1", "m2.xlarge.x86", "s1.large.x86", "baremetal_s",
      "t1.small.x86", "baremetal_0"],
     "slug" => "freebsd_12_testing",
     "version" => "12-testing"
   },
   %{
     "distro" => "alpine",
     "id" => "06e21644-a769-11e6-80f5-76304dec7eb7",
     "licensed" => false,
     "name" => "Alpine 3",
     "preinstallable" => false,
     "pricing" => %{},
     "provisionable_on" => [],
     "slug" => "alpine_3",
     "version" => "3"
   }
   ...
]}
```
