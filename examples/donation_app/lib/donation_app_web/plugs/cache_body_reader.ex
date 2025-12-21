defmodule DonationAppWeb.Plugs.CacheBodyReader do
  def read_body(%Plug.Conn{} = conn, opts) do
    case Plug.Conn.read_body(conn, opts) do
      {:ok, binary, conn} ->
        {:ok, binary, maybe_store_body_chunk(conn, binary)}

      {:more, binary, conn} ->
        {:ok, binary, maybe_store_body_chunk(conn, binary)}

      {:error, reason} ->
        {:error, reason}
    end
  end

  defp enabled_for?(conn) do
    case conn.path_info do
      ["api", "woovi", "callback" | _rest] -> true
      _ -> false
    end
  end

  def maybe_store_body_chunk(conn, chunk) do
    if enabled_for?(conn) do
      store_body_chunk(conn, chunk)
    else
      conn
    end
  end

  def store_body_chunk(%Plug.Conn{} = conn, chunk) when is_binary(chunk) do
    chunks = conn.private[:raw_body] || []
    Plug.Conn.put_private(conn, :raw_body, [chunk | chunks])
  end

  def get_raw_body(%Plug.Conn{} = conn) do
    case conn.private[:raw_body] do
      nil -> nil
      chunks -> chunks |> Enum.reverse() |> Enum.join("")
    end
  end
end
