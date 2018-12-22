defmodule PacketApi.Facilities do
  @moduledoc """
  This module collects the operations related to the facilities endpoint of the
  Packet API.
  """
  alias PacketApi

  @type includes :: PacketApi.includes()
  @type request :: PacketApi.request()

  @base "/facilities"

  @doc """
  Provides a listing of available datacenters where you can provision Packet devices.
  """
  @spec list(request, includes) :: {:ok, [map]} | {:error, any}
  def list(%{client: client}, includes \\ []) do
    case Tesla.get(client, @base, query: includes) do
      {:ok, %{status: 200, body: %{"facilities" => facilities}}} ->
        {:ok, facilities}

      {:ok, %{status: status}} ->
        {:error, status}

      error ->
        error
    end
  end

  @doc """
  Returns a listing of available datacenters for the given project.
  """
  @spec list_for_project(request, String.t(), includes) :: {:ok, [map]} | {:error, any}
  def list_for_project(%{client: client}, project_id, includes \\ []) do
    path = "projects/#{project_id}/facilities"

    case Tesla.get(client, path, query: includes) do
      {:ok, %{status: 200, body: %{"facilities" => facilities}}} ->
        {:ok, facilities}

      {:ok, %{status: status}} ->
        {:error, status}

      error ->
        error
    end
  end
end
