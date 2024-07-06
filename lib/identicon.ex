defmodule Identicon do
  @moduledoc """
  Documentation for `Identicon`.
  """

  def main(input) do
    input
    |> hash_input
    |> pick_color
    |> build_grid
  end

  def build_grid(%Identicon.Image{hex: hex} = _image) do
    hex
    |> Enum.chunk_every(3)
    |> Enum.filter(&length(&1) == 3) # Ensure each chunk has exactly 3 elements
    |> Enum.map(&mirror_row/1)
  end

  def mirror_row(row) do
    # [212, 194, 133] -> [212, 194, 133, 194, 212]
    [first, second | _tail] = row

    row ++ [second, first]
  end

  def pick_color(%Identicon.Image{hex: [r, g, b | _tail]} = image) do
    %Identicon.Image{image | color: {r, g, b}}
  end

  @doc """
  Hashes the input using MD5 and converts it to a list of bytes.

  ## Examples

      iex> Identicon.hash_input("hello")

      [93, 65, 64, 42, 188, 75, 42, 118, 185, 113, 157, 145, 16, 23, 197, 146]
  """
  def hash_input(input) do
    hex = :crypto.hash(:md5, input)
    |> :binary.bin_to_list

    %Identicon.Image{hex: hex}
  end
end
