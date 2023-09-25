require "application_system_test_case"

class SpeechesTest < ApplicationSystemTestCase
  setup do
    @speech = speeches(:one)
  end

  test "visiting the index" do
    visit speeches_url
    assert_selector "h1", text: "Speeches"
  end

  test "should create speech" do
    visit speeches_url
    click_on "New speech"

    fill_in "Duration", with: @speech.duration
    fill_in "Name", with: @speech.name
    click_on "Create Speech"

    assert_text "Speech was successfully created"
    click_on "Back"
  end

  test "should update Speech" do
    visit speech_url(@speech)
    click_on "Edit this speech", match: :first

    fill_in "Duration", with: @speech.duration
    fill_in "Name", with: @speech.name
    click_on "Update Speech"

    assert_text "Speech was successfully updated"
    click_on "Back"
  end

  test "should destroy Speech" do
    visit speech_url(@speech)
    click_on "Destroy this speech", match: :first

    assert_text "Speech was successfully destroyed"
  end
end
