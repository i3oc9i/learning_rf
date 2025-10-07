*** Settings ***
Documentation     Kata 2.2 - Advanced Gherkin with Multiple Scenarios
...               Learn: Complex flows, multiple API calls in one scenario
Library           RequestsLibrary
Library           Collections

*** Variables ***
${BASE_URL}       https://jsonplaceholder.typicode.com
${RESPONSE}       ${None}
${POST_DATA}      ${None}

*** Test Cases ***
Scenario: User Creates A Post And Then Updates It
    [Documentation]    Multi-step workflow: create then update
    Given the API is available
    When I create a post with title "Original Title" and body "Original Body"
    Then the creation should be successful
    And I should receive a post id

    When I update the post with title "Modified Title"
    Then the update should be successful
    And the post title should be "Modified Title"

Scenario: User Retrieves Post Comments
    [Documentation]    Verify post-comment relationship
    Given the API is available
    When I retrieve post "1"
    Then the post should exist

    When I retrieve comments for post "1"
    Then the response should contain comments
    And each comment should have an email
    And each comment should have a body

Scenario: Validate Post Data Structure
    [Documentation]    Verify complete data structure
    Given the API is available
    When I retrieve post "1"
    Then the post should have all required fields
    And the post userId should be a number
    And the post id should be a number

*** Keywords ***
# Given Keywords
the API is available
    Create Session    api    ${BASE_URL}

# When Keywords
I create a post with title "${title}" and body "${body}"
    &{post_data}=    Create Dictionary    title=${title}    body=${body}    userId=1
    ${response}=    POST On Session    api    /posts    json=${post_data}
    ${response_data}=    Set Variable    ${response.json()}
    Set Test Variable    ${RESPONSE}    ${response}
    Set Test Variable    ${POST_DATA}    ${response_data}

I update the post with title "${new_title}"
    &{update_data}=    Create Dictionary    title=${new_title}
    ${post_id}=    Set Variable    ${POST_DATA}[id]
    ${response}=    PATCH On Session    api    /posts/${post_id}    json=${update_data}
    ${response_data}=    Set Variable    ${response.json()}
    Set Test Variable    ${RESPONSE}    ${response}
    Set Test Variable    ${POST_DATA}    ${response_data}

I retrieve post "${post_id}"
    ${response}=    GET On Session    api    /posts/${post_id}
    Set Test Variable    ${RESPONSE}    ${response}

I retrieve comments for post "${post_id}"
    ${response}=    GET On Session    api    /posts/${post_id}/comments
    Set Test Variable    ${RESPONSE}    ${response}

# Then Keywords
the creation should be successful
    Should Be Equal As Strings    ${RESPONSE.status_code}    201

I should receive a post id
    Should Not Be Equal    ${POST_DATA}[id]    ${None}
    Should Be True    ${POST_DATA}[id] > 0

the update should be successful
    Should Be Equal As Strings    ${RESPONSE.status_code}    200

the post title should be "${expected_title}"
    Should Be Equal As Strings    ${POST_DATA}[title]    ${expected_title}

the post should exist
    Should Be Equal As Strings    ${RESPONSE.status_code}    200

the response should contain comments
    ${response_data}=    Set Variable    ${RESPONSE.json()}
    ${comments}=    Set Variable    ${response_data}
    ${length}=    Get Length    ${comments}
    Should Be True    ${length} > 0

each comment should have an email
    ${response_data}=    Set Variable    ${RESPONSE.json()}
    ${comments}=    Set Variable    ${response_data}
    FOR    ${comment}    IN    @{comments}
        Should Not Be Empty    ${comment}[email]
    END

each comment should have a body
    ${response_data}=    Set Variable    ${RESPONSE.json()}
    ${comments}=    Set Variable    ${response_data}
    FOR    ${comment}    IN    @{comments}
        Should Not Be Empty    ${comment}[body]
    END

the post should have all required fields
    ${response_data}=    Set Variable    ${RESPONSE.json()}
    ${post}=    Set Variable    ${response_data}
    Dictionary Should Contain Key    ${post}    userId
    Dictionary Should Contain Key    ${post}    id
    Dictionary Should Contain Key    ${post}    title
    Dictionary Should Contain Key    ${post}    body

the post userId should be a number
    ${response_data}=    Set Variable    ${RESPONSE.json()}
    ${post}=    Set Variable    ${response_data}
    Should Be True    isinstance($post['userId'], int)

the post id should be a number
    ${response_data}=    Set Variable    ${RESPONSE.json()}
    ${post}=    Set Variable    ${response_data}
    Should Be True    isinstance($post['id'], int)
