defmodule PacketApi.OperatingSystems do
  @moduledoc """
  This module collects all operations related to the operating-systems endpoint
  of the Packet API.
  """
  alias PacketApi

  @type request :: PacketApi.request()

  @doc """
  "Provides a listing of available operating systems to provision your new device with."
  [API Docs](https://www.packet.com/developers/api/#operatingsystems)

  Returns {:ok, [map]} on success.
  """
  @spec list(request) :: {:ok, [map]} | {:error, any}
  def list(%{client: client}) do
    case Tesla.get(client, "/operating-systems") do
      {:ok, %{status: 200, body: %{"operating_systems" => oses}}} ->
        {:ok, oses}

      {:ok, %{status: status} = resp} ->
        IO.puts("Resp: #{inspect(resp, pretty: true)}")
        {:error, status}

      error ->
        error
    end
  end
end
