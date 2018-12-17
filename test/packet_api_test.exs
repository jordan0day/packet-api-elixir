defmodule PacketApiTest do
  use ExUnit.Case
  doctest PacketApi

  import PacketApi

  describe "build_include/1" do
    test "Empty list results in empty list" do
      assert [] == build_include([])
    end

    test "single element" do
      assert [{:include, "hello"}] == build_include(["hello"])
    end

    test "single nested element" do
      assert [{:include, "hello.world"}] == build_include([["hello", "world"]])
    end

    test "two elements" do
      assert [{:include, "hello,world"}] == build_include(["hello", "world"])
    end

    test "two nested elements" do
      assert [{:include, "hello.world,foo.bar"}] ==
               build_include([["hello", "world"], ["foo", "bar"]])
    end

    test "one nested, one un-nested element" do
      assert [{:include, "hello,foo.bar"}] == build_include(["hello", ["foo", "bar"]])
    end

    test "three levels of nesting" do
      assert [{:include, "foo.bar.baz"}] == build_include([["foo", "bar", "baz"]])
    end
  end
end
