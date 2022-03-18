defmodule Client.List do
  use Tesla

  plug Tesla.Middleware.BaseUrl, "http://localhost:4000/api"
  plug Tesla.Middleware.JSON

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
      _ -> %{error: "Cannot get all lists"}
    end
  end

  def get_list(token, list_id) do
    with response <- get_all_lists(token) do
      case is_map(response) do
        true -> %{error: response}
        false -> Enum.find(response, &(&1["id"] == list_id))
      end
    else
      _ -> %{error: "Cannot get list"}
    end
  end

  def new_list(token, list_body) do
    client = Tesla.client([{Tesla.Middleware.Headers, [{"authorization", token}]}])

    with {_, response} <- post(client, "/lists", list_body) do
      case Map.has_key?(response.body, "data") do
        true ->
          response.body["data"]

        false ->
          response.body["error"]
      end
    else
      _ -> %{error: "Cannot create list"}
    end
  end

  def edit_list(token, list_id, list_body) do
    client = Tesla.client([{Tesla.Middleware.Headers, [{"authorization", token}]}])

    with {_, response} <- patch(client, "/lists/#{list_id |> Integer.to_string()}", list_body) do
      case Map.has_key?(response.body, "data") do
        true ->
          response.body["data"]

        false ->
          response.body["error"]
      end
    else
      _ -> %{error: "Cannot edit list"}
    end
  end

  def delete_list(token, list_id) do
    client = Tesla.client([{Tesla.Middleware.Headers, [{"authorization", token}]}])

    with {_, response} <- delete(client, "/lists/#{list_id |> Integer.to_string()}") do
      case Map.has_key?(response.body, "data") do
        true ->
          response.body["data"]

        false ->
          response.body["error"]
      end
    else
      false -> %{error: "Not allowed to delete list"}
      _ -> %{error: "Cannot delete list"}
    end
  end
end
