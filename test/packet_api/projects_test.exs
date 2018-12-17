defmodule PacketApi.ProjectsTest do
  use ExUnit.Case

  doctest PacketApi.Projects
  import PacketApi.Projects

  describe "plans/3" do
    test "list plans, no nested associations" do
      Tesla.Mock.mock(fn _env ->
        "plans1.json"
        |> get_json()
        |> Tesla.Mock.json(status: 200)
      end)

      request = PacketApi.request()
      assert {:ok, plans} = plans(request, "abc123")

      # Quick sanity check
      names = ["g2.large.x86", "c2.medium.x86"]
      filtered = Enum.filter(plans, &(&1["name"] in names))
      assert length(filtered) == 2
    end

    test "list plans, with nested 'available_in' association" do
      Tesla.Mock.mock(fn _env ->
        "plans2.json"
        |> get_json()
        |> Tesla.Mock.json(status: 200)
      end)

      request = PacketApi.request()
      assert {:ok, plans} = plans(request, "abc123")

      # Quick sanity check
      names = ["g2.large.x86", "c2.medium.x86"]
      filtered = Enum.filter(plans, &(&1["name"] in names))
      assert length(filtered) == 2

      locations = ["Dallas, TX", "Sunnyvale, CA", "Tokyo, JP", "Parsippany, NJ", "Amsterdam, NL"]

      location_names =
        plans
        |> Enum.map(fn plan -> plan["available_in"] end)
        |> Enum.map(fn locations ->
          Enum.map(locations, fn location -> location["name"] end)
        end)
        |> List.flatten()

      assert Enum.all?(locations, &(&1 in location_names))
    end
  end

  defp get_json(file) do
    filepath = Path.join(["#{__DIR__}", "json", "projects", file])

    filepath
    |> File.read!()
    |> Jason.decode!()
  end
end
