defmodule Forms.ResponsesTest do
  use Forms.DataCase

  alias Forms.Responses

  describe "responses" do
    alias Forms.Responses.Response

    import Forms.ResponsesFixtures

    @invalid_attrs %{data: nil, submitted_at: nil}

    test "list_responses/0 returns all responses" do
      response = response_fixture()
      assert Responses.list_responses() == [response]
    end

    test "get_response!/1 returns the response with given id" do
      response = response_fixture()
      assert Responses.get_response!(response.id) == response
    end

    test "create_response/1 with valid data creates a response" do
      valid_attrs = %{data: %{}, submitted_at: ~U[2025-03-19 00:10:00Z]}

      assert {:ok, %Response{} = response} = Responses.create_response(valid_attrs)
      assert response.data == %{}
      assert response.submitted_at == ~U[2025-03-19 00:10:00Z]
    end

    test "create_response/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Responses.create_response(@invalid_attrs)
    end

    test "update_response/2 with valid data updates the response" do
      response = response_fixture()
      update_attrs = %{data: %{}, submitted_at: ~U[2025-03-20 00:10:00Z]}

      assert {:ok, %Response{} = response} = Responses.update_response(response, update_attrs)
      assert response.data == %{}
      assert response.submitted_at == ~U[2025-03-20 00:10:00Z]
    end

    test "update_response/2 with invalid data returns error changeset" do
      response = response_fixture()
      assert {:error, %Ecto.Changeset{}} = Responses.update_response(response, @invalid_attrs)
      assert response == Responses.get_response!(response.id)
    end

    test "delete_response/1 deletes the response" do
      response = response_fixture()
      assert {:ok, %Response{}} = Responses.delete_response(response)
      assert_raise Ecto.NoResultsError, fn -> Responses.get_response!(response.id) end
    end

    test "change_response/1 returns a response changeset" do
      response = response_fixture()
      assert %Ecto.Changeset{} = Responses.change_response(response)
    end
  end
end
