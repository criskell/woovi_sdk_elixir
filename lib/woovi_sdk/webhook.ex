defmodule WooviSdk.Webhook do
  @moduledoc """
  Validate webhook signatures sent by Woovi.
  """

  @validation_public_key_base64 "LS0tLS1CRUdJTiBQVUJMSUMgS0VZLS0tLS0KTUlHZk1BMEdDU3FHU0liM0RRRUJBUVVBQTRHTkFEQ0JpUUtCZ1FDLytOdElranpldnZxRCtJM01NdjNiTFhEdApwdnhCalk0QnNSclNkY2EzcnRBd01jUllZdnhTbmQ3amFnVkxwY3RNaU94UU84aWVVQ0tMU1dIcHNNQWpPL3paCldNS2Jxb0c4TU5waS91M2ZwNnp6MG1jSENPU3FZc1BVVUcxOWJ1VzhiaXM1WloySVpnQk9iV1NwVHZKMGNuajYKSEtCQUE4MkpsbitsR3dTMU13SURBUUFCCi0tLS0tRU5EIFBVQkxJQyBLRVktLS0tLQo="

  @doc """
  Validate a webhook using payload and its signature sent in the
  `x-webhook-signature` header.
  """
  @spec valid?(binary(), binary()) :: boolean()
  def valid?(payload, signature_base64) do
    with {:ok, public_key} <- decode_public_key(),
         {:ok, signature} <- decode_signature(signature_base64) do
      :public_key.verify(payload, :sha256, signature, public_key)
    else
      _ -> false
    end
  end

  defp decode_public_key do
    key_pem = @validation_public_key_base64 |> Base.decode64!()

    case :public_key.pem_decode(key_pem) do
      [entry] ->
        {:ok, :public_key.pem_entry_decode(entry)}

      _ ->
        {:error, :invalid_public_key}
    end
  end

  defp decode_signature(signature) do
    case Base.decode64(signature) do
      {:ok, binary} -> {:ok, binary}
      :error -> {:error, :invalid_signature}
    end
  end
end
