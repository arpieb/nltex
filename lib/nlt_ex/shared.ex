defmodule NLTEx.Shared do
  @moduledoc ~S"""
  Shaed util functions across package
  """

  import Nx.Defn
    
  # Shamelesly stolen from Axon.Shared
  defn assert_shape!(lhs, rhs) do
    transform(
      {lhs, rhs},
      fn {lhs, rhs} ->
        lhs = Nx.shape(lhs)
        rhs = Nx.shape(rhs)

        unless Elixir.Kernel.==(lhs, rhs) do
          raise ArgumentError,
                "expected input shapes to be equal," <>
                  " got #{inspect(lhs)} != #{inspect(rhs)}"
        end
      end
    )
  end

end
