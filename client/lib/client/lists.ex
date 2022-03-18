defmodule Client.Lists do
  use Tesla

  plug Tesla.Middleware.BaseUrl, "http://localhost:4000/api"
  plug Tesla.Middleware.JSON

  alias Client.Lists.List

  def get_all_lists(token) do
    client = Tesla.client([{Tesla.Middleware.Headers, [{"authorization", token}]}])

    with {:ok, response} <- get(client, "/lists/") do
      case Map.has_key?(response.body, "data") do
        true ->
          response.body["data"]

        false ->
          response.body["error"]
      end
    else
      {:error, reason} -> %{"error" => reason}
    end
  end

  def get_list(token, list_id) do
    with response <- get_all_lists(token) do
      case is_map(response) do
        true -> response
        false -> Enum.find(response, &(&1["id"] == list_id))
      end
    else
      {:error, reason} -> %{"error" => reason}
    end
  end

  def new_list(token, %List{} = list_body) do
    client = Tesla.client([{Tesla.Middleware.Headers, [{"authorization", token}]}])

    with {:ok, response} <- post(client, "/lists", list_body) do
      case Map.has_key?(response.body, "data") do
        true ->
          response.body["data"]

        false ->
          response.body["error"]
      end
    else
      {:error, reason} -> %{"error" => reason}
    end
  end

  def edit_list(token, list_id, %List{} = list_body) do
    client = Tesla.client([{Tesla.Middleware.Headers, [{"authorization", token}]}])

    with {:ok, response} <- patch(client, "/lists/#{list_id |> Integer.to_string()}", list_body) do
      case Map.has_key?(response.body, "data") do
        true ->
          response.body["data"]

        false ->
          response.body["error"]
      end
    else
      {:error, reason} -> %{"error" => reason}
    end
  end

  def delete_list(token, list_id) do
    client = Tesla.client([{Tesla.Middleware.Headers, [{"authorization", token}]}])

    with {:ok, response} <- delete(client, "/lists/#{list_id |> Integer.to_string()}") do
      case Map.has_key?(response.body, "data") do
        true ->
          response.body["data"]

        false ->
          response.body["error"]
      end
    else
      {:error, reason} -> %{"error" => reason}
    end
  end
end
