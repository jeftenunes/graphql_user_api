defmodule GraphqlUserApi.ResolverHits.StoreTest do
  alias GraphqlUserApi.ResolverHits.Store
  use ExUnit.Case, async: true

  setup do
    {:ok, pid} = Store.start_link(name: nil)

    %{pid: pid}
  end

  describe "&increment_hits_for/2" do
    test "should increment the count of hits for a resolver" do
      assert {:ok, 0} = Store.get_hits(%{key: "resolver_test"})

      assert {:ok, :noreply} = Store.increment_hits_for(%{key: "resolver_test"})
      assert {:ok, :noreply} = Store.increment_hits_for(%{key: "resolver_test"})

      assert {:ok, 2} = Store.get_hits(%{key: "resolver_test"})
    end
  end
end
