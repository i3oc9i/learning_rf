*** Settings ***
Documentation     Kata 1.3 - PUT and DELETE Requests
...               Learn: Updating and deleting resources, PATCH vs PUT
Library           RequestsLibrary
Library           Collections

*** Variables ***
${BASE_URL}       https://jsonplaceholder.typicode.com

*** Test Cases ***
Update Post With PUT
    [Documentation]    Replace an entire post using PUT
    Create Session    api    ${BASE_URL}

    &{body}=    Create Dictionary
    ...    id=1
    ...    title=Updated Title
    ...    body=Updated content
    ...    userId=1

    ${response}=    PUT On Session    api    /posts/1    json=${body}
    Should Be Equal As Strings    ${response.status_code}    200
    Should Be Equal As Strings    ${response.json()}[title]    Updated Title

Partially Update Post With PATCH
    [Documentation]    Partially update a post using PATCH
    Create Session    api    ${BASE_URL}

    &{body}=    Create Dictionary    title=Patched Title Only

    ${response}=    PATCH On Session    api    /posts/1    json=${body}
    Should Be Equal As Strings    ${response.status_code}    200
    Should Be Equal As Strings    ${response.json()}[title]    Patched Title Only
    # Other fields remain unchanged

Delete Post
    [Documentation]    Delete a post and verify response
    Create Session    api    ${BASE_URL}

    ${response}=    DELETE On Session    api    /posts/1
    Should Be Equal As Strings    ${response.status_code}    200
    Log    Post deleted successfully
