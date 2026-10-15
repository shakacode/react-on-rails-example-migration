require "test_helper"

class RenderingTest < ActionDispatch::IntegrationTest
  test "posts index renders its navigation and cards on the server" do
    get root_path

    assert_response :success
    assert_select "a", text: "Home"
    assert_select "h2", text: "Tail beef"
    assert_select 'script[data-component-name="Navbar"]'
    assert_select 'script[data-component-name="PostsIndex"]'
    assert_select 'script[src*="generated/Navbar"]'
    assert_select 'script[src*="generated/PostsIndex"]'
  end

  test "post details render on the server" do
    get post_path(0)

    assert_response :success
    assert_select "h1", text: "Tail beef"
    assert_select 'script[data-component-name="PostsShow"]'
    assert_select 'script[src*="generated/Navbar"]'
    assert_select 'script[src*="generated/PostsShow"]'
  end

  test "hello world renders with the MiniRacer runtime" do
    get hello_world_path

    assert_response :success
    assert_select "h3", text: "Hello, Stranger!"
    assert_select 'input#name[value="Stranger"]'
    assert_select 'script[data-component-name="HelloWorld"]'
  end
end
