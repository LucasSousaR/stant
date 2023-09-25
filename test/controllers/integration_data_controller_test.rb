require "test_helper"

class IntegrationDataControllerTest < ActionDispatch::IntegrationTest
  setup do
    @integration_datum = integration_data(:one)
  end

  test "should get index" do
    get integration_data_url
    assert_response :success
  end

  test "should get new" do
    get new_integration_datum_url
    assert_response :success
  end

  test "should create integration_datum" do
    assert_difference("IntegrationDatum.count") do
      post integration_data_url, params: { integration_datum: {  } }
    end

    assert_redirected_to integration_datum_url(IntegrationDatum.last)
  end

  test "should show integration_datum" do
    get integration_datum_url(@integration_datum)
    assert_response :success
  end

  test "should get edit" do
    get edit_integration_datum_url(@integration_datum)
    assert_response :success
  end

  test "should update integration_datum" do
    patch integration_datum_url(@integration_datum), params: { integration_datum: {  } }
    assert_redirected_to integration_datum_url(@integration_datum)
  end

  test "should destroy integration_datum" do
    assert_difference("IntegrationDatum.count", -1) do
      delete integration_datum_url(@integration_datum)
    end

    assert_redirected_to integration_data_url
  end
end
