defmodule PacketApi.Projects do
  @moduledoc """
  This module collects the operations related to the projects endpoint of the
  Packet API.
  """
  alias PacketApi

  @type includes :: PacketApi.includes()
  @type request :: PacketApi.request()

  @base "/projects"

  @spec batches(request, String.t(), includes) :: {:ok, [map]} | {:error, any}
  def batches(%{client: client}, project_id, includes \\ []) do
    path = path(project_id, "batches")

    case Tesla.get(client, path, query: includes) do
      {:ok, %{status: 200, body: %{"batches" => batches}}} ->
        {:ok, batches}

      {:ok, %{status: status}} ->
        {:error, status}

      error ->
        error
    end
  end

  @spec plans(request, String.t(), includes) :: {:ok, [map]}
  def plans(%{client: client}, project_id, includes \\ []) do
    path = path(project_id, "plans")
    includes = PacketApi.build_include(includes)

    case Tesla.get(client, path, query: includes) do
      {:ok, %{status: 200, body: %{"plans" => plans}}} ->
        {:ok, plans}

      {:ok, %{status: status}} ->
        {:error, status}

      error ->
        error
    end
  end

  defp project_path(project_id), do: "#{@base}/#{project_id}"
  defp path(project_id, path), do: project_path(project_id) <> "/" <> path
end
