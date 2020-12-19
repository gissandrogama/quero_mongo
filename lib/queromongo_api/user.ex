defmodule QueromongoApi.User do
  def run(params) do
    params = validate_params(params)

    case params do
      %{email: _, password: _} ->
        user = Mongo.insert_one!(:mongo, "users", params)
        map_user_create(user)

      message ->
        {:error, message}
    end
  end

  def validate_params(params) do
    params = validate_email(params)

    case params do
      {:error, message} -> message
      _ -> params
    end
  end

  def validate_email(params) do
    %{email: email, password: _} = params

    email_compare =
      Mongo.find(:mongo, "users", %{"email" => email})
      |> Enum.to_list()
      |> Enum.map(&Map.delete(&1, "_id"))
      |> Enum.map(& &1["email"])
      |> List.first()

    if email_compare === email do
      {:error, "email já existe!"}
    else
      case(String.match?(email, ~r/^[A-Za-z0-9._%+-+']+@[A-Za-z0-9.-]+\.[A-Za-z]+$/)) do
        false -> {:error, "email inválido Ex: test@test.com"}
        true -> validate_password(params)
      end
    end
  end

  def validate_password(params) do
    %{email: _email, password: password} = params

    case String.match?(password, ~r/^[[:alnum:]]+$/) do
      false -> {:error, "digite uma senha"}
      true -> Map.put(params, :password, hashing(password).password_hash)
    end
  end

  def hashing(password) do
    Argon2.add_hash(password)
  end

  defp map_user_create(user) do

    id = user.inserted_id

    user_db = Mongo.find_one(:mongo, "users", %{"_id" => id})

    user_db
    |> Enum.to_list()
    |> List.first()

    user_map = %{"id" => BSON.ObjectId.encode!(user_db["_id"]), "email" => user_db["email"], "password" => user_db["password"]}

    {:ok, user_map}
  end

  # def authenticate_user(email, password) do
  #   Mongo.find(:mongo, "users", %{email: email})

  #   case  do
  #     nil ->
  #       Argon2.no_user_verify()
  #       {:error, :invalid_credentials}

  #     user ->
  #       if Argon2.verify_pass(password, user.password_hash) do
  #         {:ok, user}
  #       else
  #         {:error, :invalid_credentials}
  #       end
  #   end
  # end
end
