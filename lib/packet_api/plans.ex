defmodule PacketApi.Plans do
  @moduledoc """
  This module collects the operations related to the plans endpoint of the
  Packet API.
  """
  alias PacketApi

  @type request :: PacketApi.request()
  @type includes :: PacketApi.includes()

  @base "/plans"

  @doc """
  Provides a listing of available services plans available on which you can
  provision your device.
  """
  @spec list(request, includes) :: {:ok, [map]} | {:error, any}
  def list(%{client: client}, includes \\ []) do
    case Tesla.get(client, @base, query: includes) do
      {:ok, %{status: 200, body: %{"plans" => plans}} = resp} ->
        {:ok, plans}

      {:ok, %{status: status}} ->
        {:error, status}

      error ->
        error
    end
  end

  @doc """
  Returns a listing of available services plans available for the given project.
  """
  @spec list_for_project(request, String.t(), includes) :: {:ok, [map]} | {:error, any}
  def list_for_project(%{client: client}, project_id, includes \\ []) do
    path = "projects/#{project_id}/plans"

    case Tesla.get(client, path, query: includes) do
      {:ok, %{status: 200, body: %{"plans" => plans}} = resp} ->
        {:ok, plans}

      {:ok, %{status: status}} ->
        {:error, status}

      error ->
        error
    end
  end
end
