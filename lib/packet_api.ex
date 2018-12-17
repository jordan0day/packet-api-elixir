defmodule PacketApi do
  @moduledoc """
  Documentation for PacketApi. This module contains mostly "helper" functions --
  see the endpoint-specific modules for more information.
  """

  @type includes :: [String.t() | [String.t()]]
  @type page_opts :: [page: non_neg_integer, per_page: 1..1_000]

  @type opts :: [
          auth_token: String.t(),
          base_url: String.t()
        ]

  @type request :: %{
          optional(:client) => Tesla.Client.t()
        }

  @type paged_list(t) :: %{
          current_page: non_neg_integer,
          items: [t],
          last_page: non_neg_integer,
          total_items: non_neg_integer
        }

  @default_uri "https://api.packet.net/"

  @doc """
  Build a request map pre-configured with url and auth token header.
  """
  @spec request(opts) :: request
  def request(opts \\ []) do
    auth_token = Keyword.get(opts, :auth_token)
    base_url = Keyword.get(opts, :base_url, @default_uri)

    middlewares = [
      {Tesla.Middleware.BaseUrl, base_url},
      {Tesla.Middleware.Headers, [{"X-Auth-Token", auth_token}]},
      Tesla.Middleware.JSON,
      Tesla.Middleware.KeepRequest
    ]

    client = Tesla.client(middlewares)

    %{client: client}
  end

  @doc """
  Builds a query string parameter for the `include` feature of the API, where
  associated and nested resources can optionally be retrieved by specifying the
  ?include=... query string parameter.

  According to the API documentation, nested resources may be retrieved up to
  three levels deep.

  Top-level items will be comma-separated in the resulting query string. Items
  contained in embedded lists represent nested resource requests, and will be
  dot-separated.

  # Examples
  iex> PacketApi.build_include([])
  []

  iex> PacketApi.build_include(["emails", "projects", "memberships"])
  [{:include, "emails,projects,memberships"}]

  iex> PacketApi.build_include([["memberships", "projects"]])
  [{:include, "memberships.projects"}]

  """
  @spec build_include(includes) :: [include: String.t()] | []
  def build_include([]), do: []

  def build_include(includes) do
    include_str =
      includes
      |> build_include_recursive([])
      |> Enum.reverse()
      |> Enum.join(",")

    [{:include, include_str}]
  end

  @spec build_include_recursive(includes, [String.t()]) :: [String.t()]
  defp build_include_recursive([], include_list), do: include_list

  defp build_include_recursive([head | rest], include_list) when is_binary(head) do
    build_include_recursive(rest, [head | include_list])
  end

  defp build_include_recursive([head | rest], include_list) when is_list(head) do
    item = Enum.join(head, ".")
    build_include_recursive(rest, [item | include_list])
  end
end
