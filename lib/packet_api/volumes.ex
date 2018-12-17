defmodule PacketApi.Volumes do
  @moduledoc """
  This module collects the operations related to the volumes endpoint of the
  Packet API.
  """
  alias PacketApi

  @type volume_create :: %{
          required(:facility) => String.t(),
          required(:plan) => String.t(),
          required(:size) => pos_integer,
          optional(:billing_cycle) => String.t(),
          optional(:customdata) => String.t(),
          optional(:description) => String.t(),
          optional(:locked) => boolean,
          optional(:snapshot_policies) => String.t()
        }

  @type volume_update :: %{
          optional(:billing_cycle) => String.t(),
          optional(:customdata) => String.t(),
          optional(:description) => String.t(),
          optional(:locked) => boolean,
          optional(:size) => pos_integer()
        }

  @type includes :: PacketApi.includes()
  @type paged_list :: PacketApi.paged_list(map)
  @type page :: 1..1_000_000
  @type per_page :: 1..1_000
  @type request :: PacketApi.request()

  @doc """
  Create a new volume. See the `volume_create` type for fields. The "facility",
  "plan", and "size" field are required.
  """
  @spec create(request, String.t(), volume_create) :: {:ok, map} | {:error, any}
  def create(%{client: client}, project_id, create_data) do
    path = project_volumes_path(project_id)

    case Tesla.post(client, path, create_data) do
      {:ok, %{status: 201, body: volume}} ->
        {:ok, volume}

      {:ok, %{status: status}} ->
        {:error, status}

      err ->
        err
    end
  end

  @doc """
  Delete the volume with the specified ID.
  """
  @spec delete(request, String.t()) :: :ok | {:error, any}
  def delete(%{client: client}, id) do
    path = volume_path(id)

    case Tesla.delete(client, path) do
      # Packet API appears to return 204 on successful delete.
      {:ok, %{status: 204}} ->
        :ok

      {:ok, %{status: status}} ->
        {:error, status}

      err ->
        err
    end
  end

  @doc """
  View the list of events associated with the volume with the specified ID.
  Since there may be many events associated to this volume, this endpoint
  exposes a paging API, allowing you to specify a maximum number of events per
  page to list, as well as specify the page number of results to retrieve.
  """
  @spec events(request, String.t(), page, per_page, includes) :: {:ok, paged_list} | {:error, any}
  def events(%{client: client}, id, page \\ 1, per_page \\ 10, includes \\ []) do
    path = volume_path(id) <> "/events"

    case Tesla.get(client, path, query: [{:page, page}, {:per_page, per_page} | includes]) do
      {:ok, %{status: 200, body: %{"meta" => meta, "events" => events}}} ->
        paged_list = %{
          current_page: meta["current_page"],
          items: events,
          last_page: meta["last_page"],
          total: meta["total"]
        }

        {:ok, paged_list}

      {:ok, %{status: status}} ->
        {:error, status}

      error ->
        error
    end
  end

  @doc """
  Get the details of the volume with the specified ID.
  """
  @spec get(request, String.t(), includes) :: {:ok, map} | {:error, any}
  def get(%{client: client}, id, includes \\ []) do
    path = volume_path(id)

    case Tesla.get(client, path, query: includes) do
      {:ok, %{status: 200, body: volume}} ->
        {:ok, volume}

      {:ok, %{status: status}} ->
        {:error, status}

      error ->
        error
    end
  end

  @doc """
  List all volumes under the project with the specified ID. Since there may be
  many volumes, this endpoint exposes a paging API, allowing you to specify a
  maximum number of volumes per page to list, as well as specify the page
  number of results to retrieve.
  """
  @spec list(request, String.t(), page, per_page, includes) :: {:ok, paged_list} | {:error, any}
  def list(%{client: client}, project_id, page \\ 1, per_page \\ 10, includes \\ []) do
    path = project_volumes_path(project_id)

    case Tesla.get(client, path, query: [{:page, page}, {:per_page, per_page} | includes]) do
      {:ok, %{status: 200, body: %{"meta" => meta, "volumes" => volumes}}} ->
        paged_list = %{
          current_page: meta["current_page"],
          items: volumes,
          last_page: meta["last_page"],
          total: meta["total"]
        }

        {:ok, paged_list}

      {:ok, %{status: status}} ->
        {:error, status}

      error ->
        error
    end
  end

  @doc """
  Update the volume with the specified ID. See the `volume_update` type for
  field details.
  """
  @spec update(request, String.t(), volume_update()) :: {:ok, map} | {:error, any}
  def update(%{client: client}, id, update_data) do
    path = volume_path(id)

    case Tesla.put(client, path, update_data) do
      # Packet API appears to return 200 on successful update,
      {:ok, %{status: 200, body: volume}} ->
        {:ok, volume}

      {:ok, %{status: status}} ->
        {:error, status}

      error ->
        error
    end
  end

  defp project_volumes_path(project_id), do: "projects/#{project_id}/storage"
  defp volume_path(id), do: "storage/#{id}"
end
