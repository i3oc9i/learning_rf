*** Settings ***
Documentation     Kata 2.1 - Gherkin-Style Test Cases
...               Learn: Using Given-When-Then keywords for BDD-style tests
Library           RequestsLibrary
Library           Collections

*** Variables ***
${BASE_URL}       https://jsonplaceholder.typicode.com
${RESPONSE}       ${None}

*** Test Cases ***
User Should Be Able To Retrieve A Post
    [Documentation]    BDD-style test for retrieving a post
    Given the API is available
    When I request post with id "1"
    Then the response status should be "200"
    And the post should have a title
    And the post should have a body
    And the post should belong to a user

User Should Be Able To Create A New Post
    [Documentation]    BDD-style test for creating a post
    Given the API is available
    When I create a new post with title "Test Post" and body "Test content" for user "1"
    Then the response status should be "201"
    And the response should contain the post title "Test Post"
    And the response should contain the post body "Test content"
    And the post should have an assigned id

*** Keywords ***
# Given Keywords
the API is available
    Create Session    api    ${BASE_URL}

# When Keywords
I request post with id "${post_id}"
    ${response}=    GET On Session    api    /posts/${post_id}
    Set Test Variable    ${RESPONSE}    ${response}

I create a new post with title "${title}" and body "${body}" for user "${user_id}"
    &{post_data}=    Create Dictionary
    ...    title=${title}
    ...    body=${body}
    ...    userId=${user_id}
    ${response}=    POST On Session    api    /posts    json=${post_data}
    Set Test Variable    ${RESPONSE}    ${response}

# Then Keywords
the response status should be "${expected_status}"
    Should Be Equal As Strings    ${RESPONSE.status_code}    ${expected_status}

the post should have a title
    ${json}=    Set Variable    ${RESPONSE.json()}
    Should Not Be Empty    ${json}[title]

the post should have a body
    ${json}=    Set Variable    ${RESPONSE.json()}
    Should Not Be Empty    ${json}[body]

the post should belong to a user
    ${json}=    Set Variable    ${RESPONSE.json()}
    Should Not Be Equal    ${json}[userId]    ${None}
    Should Be True    ${json}[userId] > 0

the response should contain the post title "${expected_title}"
    ${json}=    Set Variable    ${RESPONSE.json()}
    Should Be Equal As Strings    ${json}[title]    ${expected_title}

the response should contain the post body "${expected_body}"
    ${json}=    Set Variable    ${RESPONSE.json()}
    Should Be Equal As Strings    ${json}[body]    ${expected_body}

the post should have an assigned id
    ${json}=    Set Variable    ${RESPONSE.json()}
    Should Not Be Equal    ${json}[id]    ${None}
    Should Be True    ${json}[id] > 0
