defmodule GraphqlUserApi.ResolverHits.StoreTest do
  alias GraphqlUserApi.ResolverHits.Store
  use ExUnit.Case, async: true

  setup do
    {:ok, pid} = Store.start_link(name: nil)

    %{pid: pid}
  end

  describe "&increment_hits_for/2" do
    test "should increment the count of hits for a resolver" do
      assert 0 = Store.get_hits("resolver_test")

      assert :ok = Store.increment_hits_for("resolver_test")
      assert :ok = Store.increment_hits_for("resolver_test")

      assert 2 = Store.get_hits("resolver_test")
    end
  end
end
