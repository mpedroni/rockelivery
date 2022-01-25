defmodule RockeliveryWeb.UsersControllerTest do
  use RockeliveryWeb.ConnCase, async: true

  import Mox
  import Rockelivery.Factory

  alias Rockelivery.ViaCep.ClientMock
  alias RockeliveryWeb.Auth.Guardian

  describe "create/2" do
    test "when all params are valid, creates the user", %{conn: conn} do
      params = %{
        "age" => 20,
        "address" => "Rua das Bananeiras, 15",
        "cep" => "12345678",
        "cpf" => "12345678900",
        "email" => "matheus@pedroni.com",
        "password" => "123456",
        "name" => "Matheus Pedroni"
      }

      expect(ClientMock, :get_cep_info, fn _cep ->
        {:ok, build(:cep_info)}
      end)

      response =
        conn
        |> post(Routes.users_path(conn, :create, params))
        |> json_response(:created)

      assert %{
               "message" => "User created",
               "user" => %{
                 "address" => "Rua das Bananeiras, 15",
                 "age" => 20,
                 "cpf" => "12345678900",
                 "email" => "matheus@pedroni.com",
                 "id" => _id
               }
             } = response
    end

    test "when there are some error, returns the error", %{conn: conn} do
      params = %{
        "password" => "123456",
        "name" => "Matheus Pedroni"
      }

      response =
        conn
        |> post(Routes.users_path(conn, :create, params))
        |> json_response(:bad_request)

      expected_response = %{
        "message" => %{
          "address" => ["can't be blank"],
          "age" => ["can't be blank"],
          "cep" => ["can't be blank"],
          "cpf" => ["can't be blank"],
          "email" => ["can't be blank"]
        }
      }

      assert response == expected_response
    end
  end

  describe "delete/2" do
    setup %{conn: conn} do
      user = insert(:user)
      {:ok, token, _claims} = Guardian.encode_and_sign(user)

      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      {:ok, conn: conn, user: user}
    end

    test "when there is a user with the given id, deletes the user", %{conn: conn} do
      id = "70171f01-df8e-43e7-af6d-28362eaf94b4"

      response =
        conn
        |> delete(Routes.users_path(conn, :delete, id))
        |> response(:no_content)

      expected_response = ""

      assert response == expected_response
    end
  end
end
