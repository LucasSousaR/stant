require "application_system_test_case"

class IntegrationDataTest < ApplicationSystemTestCase
  setup do
    @integration_datum = integration_data(:one)
  end

  test "visiting the index" do
    visit integration_data_url
    assert_selector "h1", text: "Integration data"
  end

  test "should create integration datum" do
    visit integration_data_url
    click_on "New integration datum"

    click_on "Create Integration datum"

    assert_text "Integration datum was successfully created"
    click_on "Back"
  end

  test "should update Integration datum" do
    visit integration_datum_url(@integration_datum)
    click_on "Edit this integration datum", match: :first

    click_on "Update Integration datum"

    assert_text "Integration datum was successfully updated"
    click_on "Back"
  end

  test "should destroy Integration datum" do
    visit integration_datum_url(@integration_datum)
    click_on "Destroy this integration datum", match: :first

    assert_text "Integration datum was successfully destroyed"
  end
end
