defmodule PacketApi.Capacity do
  @moduledoc """
  This module collects the operations related to the capacity endpoint of the
  Packet API.
  """
  alias PacketApi

  @type request :: PacketApi.request()
  @type server_info :: %{
          required(:facility) => String.t(),
          required(:plan) => String.t(),
          optional(:quantity) => pos_integer
        }

  @base "/capacity"

  @doc """
  Validate if a deploy can be fulfilled by checking available capacity.
  """
  @spec check(request, [server_info]) :: any
  def check(%{client: client}, server_infos) do
    case Tesla.post(client, @base, %{"servers" => server_infos}) do
      {:ok, %{status: 200, body: %{"servers" => servers}}} ->
        {:ok, servers}

      {:ok, %{status: status}} ->
        {:error, status}

      error ->
        error
    end
  end

  @doc """
  Returns a list of facilities and plans with their current capacity.
  """
  @spec list(request) :: {:ok, [map]} | {:error, any}
  def list(%{client: client}) do
    case Tesla.get(client, @base) do
      {:ok, %{status: 200, body: %{"capacity" => capacity}}} ->
        {:ok, capacity}

      {:ok, %{status: status}} ->
        {:error, status}

      error ->
        error
    end
  end
end
