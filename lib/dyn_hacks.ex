defmodule DynHacks do
  use Operator

  @moduledoc """
  Collection of hacks that utilise dynamic typing and syergise with standard Elixir protocols to improve UX.

  Use `map` from Witchcraft.Functor when possible, instead of fmap. In general, try to never use functions from this module unless you're working with raw data coming from dynamic elixir.
  """

  @doc """
  Exploding version of fmap.
  """
  @spec fmap!(any, any) :: list | map
  def fmap!(f_a, a___b) do
    {:ok, f_b} = fmap(f_a, a___b)
    f_b
  end

  @doc """
  Apply a function deeply traversing f_a for which an Enumerable implementation exists.
  2-tuples are traversed on the right.
  """
  @spec fmap(any, any) :: {:ok, list | map} | {:error, any}
  def fmap(%{} = f_a, a___b) do
    case fmap(f_a |> Enum.into([]), a___b) do
      {:ok, f_b} -> {:ok, f_b |> Enum.into(%{})}
      err -> err
    end
  end

  def fmap(f_a, a___b) do
    if Enumerable.impl_for(f_a) do
      {:ok, Enum.map(f_a, &fmap_do(&1, a___b))}
    else
      {:error, "f_a doesn't have Enumerable implemented for it"}
    end
  end

  defp fmap_do({k, a}, a___b) do
    {k, fmap_do(a, a___b)}
  end

  defp fmap_do(a___or___f_a, a___b) do
    if Enumerable.impl_for(a___or___f_a) do
      fmap!(a___or___f_a, a___b)
    else
      a___b.(a___or___f_a)
    end
  end

  @doc """
  Take a nillable value and if it's not nil, shove it into an addressed structure under given address.
  """
  @spec fval(any(), any(), any(), any()) :: any()
  def fval(f_a_b, a, b, f_a_b___a___b___f_a_b) do
    if b == nil do
      f_a_b
    else
      f_a_b___a___b___f_a_b.(f_a_b, a, b)
    end
  end

  @doc """
  Take a nillable value and if it's not nil, put_new it into the map under key.
  """
  @spec put_value(map(), any(), any()) :: map()
  def put_value(%{} = map, key, value) do
    fval(map, key, value, &Map.put(&1, &2, &3))
  end

  @doc """
  Take a nillable value and if it's not nil, put_new it into the map under key.
  """
  @spec put_new_value(map(), any(), any()) :: map()
  def put_new_value(%{} = map, key, value) do
    fval(map, key, value, &Map.put_new(&1, &2, &3))
  end

  @doc """
  Forgetful continuation over {:error, reason}, {:ok, _value}
  """
  @spec cont({:ok | :error, any()}, (() -> {:ok | :error, any()})) :: {:ok | :error, any()}
  def cont({:error, _} = e, _), do: e
  def cont({:ok, _}, f), do: f.()

  @doc """
  Constant function
  """
  @spec const(any()) :: (any() -> any())
  def const(x), do: fn _ -> x end

  @doc """
  Wraps a value into a nullary function.
  """
  @spec fwrap(any) :: (() -> any)
  def fwrap(x), do: fn -> x end

  @spec fw(any) :: (() -> any)
  defdelegate fw(x), to: __MODULE__, as: :fwrap

  @doc """
  Left sparrow operator.
  """
  @spec left_sparrow((() -> any), (() -> any)) :: any
  def left_sparrow(f, g) do
    res = f.()
    g.()
    res
  end

  @spec lsp((() -> any), (() -> any)) :: any
  defdelegate lsp(f, g), to: __MODULE__, as: :left_sparrow

  @doc """
  Right sparrow operator.
  """
  @spec right_sparrow((() -> any), (() -> any)) :: any
  def right_sparrow(f, g) do
    res = g.()
    f.()
    res
  end

  @spec rsp((() -> any), (() -> any)) :: any
  defdelegate rsp(f, g), to: __MODULE__, as: :right_sparrow

  @doc """
  Run a side-effect (second argument) on the value (first argument), returning the value (first argument).
  """
  @spec impure(any, (any -> any)) :: any
  def impure(x, f) do
    f.(x)
    x
  end

  @spec r_m(any, (any -> any)) :: any
  defdelegate r_m(x, f), to: __MODULE__, as: :impure

  @spec imp(any, (any -> any)) :: any
  defdelegate imp(x, f), to: __MODULE__, as: :impure
end
