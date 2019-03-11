defmodule PacketApi.User do
  @moduledoc """
  This module collects the operations related to the user endpoint of the
  Packet API.
  """
  alias PacketApi

  @type includes :: PacketApi.includes()
  @type request :: PacketApi.request()

  @base "/user"

  def get_current_user(%{client: client}, includes \\ []) do
    case Tesla.get(client, @base, query: includes) do
      {:ok, %{status: 200, body: user}} ->
        {:ok, user}
      {:ok, %{status: status}} ->
        {:error, status}

      error ->
        error
    end
  end
end
