defmodule GraphqlUserApi.Auth.JwtUtils do
  @header %{
    "alg" => "HS256",
    "typ" => "JWT"
  }

  def generate_token(payload) do
    header = Jason.encode!(@header)
    payload = Jason.encode!(payload)

    header_encoded = base64url_encode(header)
    payload_encoded = base64url_encode(payload)

    signature = sign("#{header_encoded}.#{payload_encoded}", "api_key")
    "#{header_encoded}.#{payload_encoded}.#{signature}"
  end

  def validate_token(token, secret) do
    [header_encoded, payload_encoded, signature] = String.split(token, ".")

    expected_signature = sign("#{header_encoded}.#{payload_encoded}", secret)

    if expected_signature != signature do
      {:error, "Invalid signature"}
    else
      with {:ok, decoded_payload} <- base64url_decode(payload_encoded),
           {:ok, payload} <- Jason.decode(decoded_payload) do
        # verificar se o sub ta presente na ets c os tokens
        {:ok, payload}
      end
    end
  end

  defp base64url_encode(binary) do
    binary
    |> Base.encode64(padding: false)
    |> String.replace("+", "-")
    |> String.replace("/", "_")
  end

  defp base64url_decode(encoded) do
    encoded
    |> String.replace("-", "+")
    |> String.replace("_", "/")
    |> Base.decode64(padding: false)
  end

  defp sign(data, secret) do
    :crypto.mac(:hmac, :sha256, secret, data)
    |> Base.encode64(padding: false)
    |> base64url_encode()
  end
end
