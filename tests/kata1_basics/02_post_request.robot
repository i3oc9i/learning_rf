*** Settings ***
Documentation     Kata 1.2 - POST Request with JSON Body
...               Learn: Creating resources, JSON body, validating response data
Library           RequestsLibrary
Library           Collections

*** Variables ***
${BASE_URL}       https://jsonplaceholder.typicode.com

*** Test Cases ***
Create New Post
    [Documentation]    Create a new post and verify the response
    Create Session    api    ${BASE_URL}

    # Create JSON body
    &{body}=    Create Dictionary
    ...    title=My Test Post
    ...    body=This is the content of my test post
    ...    userId=1

    ${response}=    POST On Session    api    /posts    json=${body}
    Should Be Equal As Strings    ${response.status_code}    201

    # Validate response contains our data
    ${json}=    Set Variable    ${response.json()}
    Should Be Equal As Strings    ${json}[title]    My Test Post
    Should Be Equal As Strings    ${json}[body]    This is the content of my test post
    Should Be Equal As Numbers    ${json}[userId]    1

    # Verify an ID was assigned
    Should Not Be Empty    ${json}[id]
    Log    Created post with ID: ${json}[id]
