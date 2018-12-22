defmodule PacketApi.Devices do
  @moduledoc """
  This module collects the operations related to the devices endpoint of the
  Packet API.
  """
  alias PacketApi

  @type includes :: PacketApi.includes()
  @type request :: PacketApi.request()
  @type paged_list :: PacketApi.paged_list(map)

  @base "/devices"

  @type device_create :: %{
          required(:facility) => String.t(),
          required(:plan) => String.t(),
          required(:operating_system) => String.t(),
          optional(:always_pxe) => boolean,
          optional(:billing_cycle) => String.t(),
          optional(:customdata) => String.t(),
          optional(:description) => String.t(),
          optional(:features) => [String.t()],
          optional(:hardware_reservation_id) => String.t(),
          optional(:hostname) => String.t(),
          optional(:ipxe_script_url) => String.t(),
          optional(:locked) => boolean,
          optional(:project_ssh_keys) => [String.t()],
          optional(:public_ipv4_subnet_size) => pos_integer,
          optional(:spot_instance) => boolean,
          optional(:spot_price_max) => number,
          optional(:tags) => [String.t()],
          optional(:termination_time) => String.t(),
          optional(:userdata) => String.t(),
          optional(:user_ssh_keys) => [String.t()]
        }

  # TODO: Validate optional/required
  @type device_update :: %{
          optional(:always_pxe) => boolean,
          optional(:billing_cycle) => String.t(),
          optional(:customdata) => String.t(),
          optional(:description) => String.t(),
          optional(:hostname) => String.t(),
          optional(:ipxe_script_url) => String.t(),
          optional(:locked) => boolean,
          optional(:spot_instance) => boolean,
          optional(:tags) => [String.t()],
          optional(:userdata) => String.t()
        }

  @doc """
  Creates a new device and provisions it in a datacenter.
  """
  @spec create(request, String.t(), device_create) :: {:ok, map} | {:error, any}
  def create(%{client: client}, project_id, device) do
    path = projects_devices_path(project_id)

    case Tesla.post(client, path, device) do
      {:ok, %{status: 201, body: device_info}} ->
        {:ok, device_info}

      {:ok, %{status: status}} ->
        {:error, status}

      {:error, _} = err ->
        err
    end
  end

  @doc """
  Deletes a device and deprovisions it in the datacenter.
  """
  @spec delete(request, String.t(), boolean) :: :ok | {:error, any}
  def delete(%{client: client}, device_id, force? \\ false) do
    path = device_path(device_id)

    case Tesla.delete(client, path, query: [{:force_delete, force?}]) do
      {:ok, %{status: 204}} ->
        :ok

      {:ok, %{status: status}} ->
        {:error, status}

      {:error, _} = err ->
        err
    end
  end

  @spec list(request, String.t(), 1..1_000_000, 1..1_000, includes) ::
          {:ok, paged_list} | {:error, any}
  def list(%{client: client}, project_id, page \\ 1, per_page \\ 10, includes \\ []) do
    path = projects_devices_path(project_id)

    case Tesla.get(client, path, query: [{:page, page}, {:per_page, per_page} | includes]) do
      {:ok, %{status: 200, body: %{"devices" => devices, "meta" => meta}}} ->
        paged_list = %{
          current_page: meta["current_page"],
          items: devices,
          last_page: meta["last_page"],
          total: meta["total"]
        }

        {:ok, paged_list}

      {:ok, %{status: status}} ->
        {:error, status}

      {:error, _} = err ->
        err
    end
  end

  defp device_path(device_id), do: "#{@base}/#{device_id}"
  defp projects_devices_path(project_id), do: "projects/#{project_id}/devices"
end
