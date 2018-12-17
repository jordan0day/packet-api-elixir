defmodule PacketApi.Notifications do
  @moduledoc """
  This module collects the operations related to the notifications endpoint of
  the Packet API.
  """

  alias PacketApi

  @type includes :: PacketApi.includes()
  @type request :: PacketApi.request()

  @base "/notifications"

  @doc """
  Returns a list of the current user’s notifications.
  """
  @spec list(request, includes) :: {:ok, [map]} | {:error, any}
  def list(%{client: client}, includes \\ []) do
    path = @base

    case Tesla.get(client, path, query: includes) do
      {:ok, %{status: 200, body: %{"notifications" => notifications}}} ->
        {:ok, notifications}

      {:ok, %{status: status}} ->
        {:error, status}

      err ->
        err
    end
  end
end
