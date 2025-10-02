*** Settings ***
Documentation     Kata 4.2 - Gherkin Tests with Reusable Resource Files
...               Learn: Combine Gherkin style with reusable keywords
Resource          ../../resources/gherkin_keywords.resource

*** Test Cases ***
Scenario: Retrieve A User Successfully
    [Documentation]    Simple Gherkin test using resource keywords
    Given the API is available
    When I send a GET request to "/users/1"
    Then the response status should be "200"
    And the response should contain "name"
    And the response should contain "email"

Scenario: Create A New Post
    [Documentation]    Create resource with Gherkin style
    Given the API is available
    And I set request data    title=My New Post    body=Post content    userId=1
    When I send a POST request to "/posts" with data
    Then the response status should be "201"
    And the response "title" should be "My New Post"
    And the response should contain "id"

Scenario: Retrieve All Users
    [Documentation]    Validate list response
    Given the API is available
    When I send a GET request to "/users"
    Then the response should be successful
    And the response should be a list
    And the response list should have "10" items

Scenario: Update An Existing Post
    [Documentation]    Update resource with PATCH
    Given the API is available
    And I set request data    title=Updated Title
    When I partially update "/posts/1" with data
    Then the response status should be "200"
    And the response "title" should be "Updated Title"

Scenario: Delete A Post
    [Documentation]    Delete resource
    Given the API is available
    When I delete "/posts/1"
    Then the response status should be "200"

Scenario: Create And Verify Post In Multiple Steps
    [Documentation]    Multi-step workflow
    Given the API is available

    # Step 1: Create
    And I set request data    title=Test Post    body=Test Body    userId=1
    When I send a POST request to "/posts" with data
    Then the response status should be "201"
    And the response should contain keys    id    title    body    userId

    # Step 2: Verify it was created (simulated - in real scenario you'd store and retrieve)
    When I send a GET request to "/posts/1"
    Then the response should be successful
    And the response should not be empty
