defmodule PacketApi.OperatingSystemsTest do
  use ExUnit.Case

  import(PacketApi.OperatingSystems)

  test "happy path responds 200 ok with a list of OSes" do
    Tesla.Mock.mock(fn _env ->
      Tesla.Mock.json(os_json(), status: 200)
    end)

    request = PacketApi.request()

    assert {:ok, os_list} = list(request)

    # Just a small sanity check
    oses = ["FreeBSD 12-testing", "CentOS 6", "Alpine 3"]
    filtered = Enum.filter(os_list, &(&1["name"] in oses))
    assert length(filtered) == 3
  end

  defp os_json() do
    filepath = Path.join(["#{__DIR__}", "json", "operating_systems.json"])

    filepath
    |> File.read!()
    |> Jason.decode!()
  end
end
