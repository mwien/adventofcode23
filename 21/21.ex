defmodule AOCDay21 do
  def to_index_map(s) do
    String.trim(s)
    |> String.split("\n")
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {ln, i}, mp ->
      Map.merge(
        mp,
        String.to_charlist(ln)
        |> Enum.with_index()
        |> Map.new(fn {c, j} -> {{j, i}, c} end)
      )
    end)
  end

  def neighbors(grid, {x, y}) do
    for(i <- [-1, 0, 1], j <- [-1, 0, 1], rem(i + j, 2) != 0, do: {x + i, y + j})
    |> Enum.filter(&Map.has_key?(grid, &1))
    |> Enum.filter(&(grid[&1] != ?#))
  end

  def dfs(_, _, maxd, d, vis) when d > maxd do
    vis
  end

  def dfs(grid, v, maxd, d, vis) do
    Enum.reduce(neighbors(grid, v), MapSet.put(vis, {v, d}), fn p, vis ->
      if MapSet.member?(vis, {p, d + 1}), do: vis, else: dfs(grid, p, maxd, d + 1, vis)
    end)
  end

  def part1(file, steps) do
    grid =
      File.read!(file)
      |> to_index_map()

    {start, _} =
      Map.to_list(grid)
      |> Enum.find(fn {_, c} -> c == ?S end)
      |> IO.inspect()

    dfs(grid, start, steps, 0, MapSet.new())
    |> MapSet.filter(fn {_, d} -> d == steps end)
    |> MapSet.size()
  end

  # for part 2 I (with a bit of online help)
  # - duplicated the grid (file 'rep_main.in')
  # - computed part1("rep_main.in", 65), part1("rep_main.in", 65 + 131), part1("rep_main.in", 65 + 2*131), which for me are 3859, 34324, 95135
  # - in julia do interpolation: 
  # using SimplePolynomials
  # p = interpolate([3859, 34324, 95135])
  # res = p(div(26501365, 131))
end
