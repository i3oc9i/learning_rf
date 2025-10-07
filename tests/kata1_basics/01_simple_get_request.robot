*** Settings ***
Documentation     Kata 1.1 - Simple GET Request
...               Learn: Basic test structure, GET request, status code validation
Library           RequestsLibrary
Library           Collections

Suite Setup       Create Session    api    ${BASE_URL}
Suite Teardown    Delete All Sessions

*** Variables ***
${BASE_URL}       https://jsonplaceholder.typicode.com
${EXPECTED_USERS}    3

*** Test Cases ***
Get Single User
    [Documentation]    Fetch a single user and verify response
    [Tags]    smoke    get
    ${response}=    GET On Session    api    /users/1
    Should Be Equal As Strings    ${response.status_code}    200
    ${user}=    Set Variable    ${response.json()}
    Dictionary Should Contain Key    ${user}    id
    Dictionary Should Contain Key    ${user}    name
    Dictionary Should Contain Key    ${user}    email
    Log    User ID ${user}[id]: ${user}[name]: ${user}[email]

Get All Users
    [Documentation]    Fetch all users and verify we get at least the expected number
    [Tags]    smoke    get
    ${response}=    GET On Session    api    /users
    Should Be Equal As Strings    ${response.status_code}    200
    ${users}=    Set Variable    ${response.json()}
    ${count}=    Get Length    ${users}
    Should Be True    ${count} >= ${EXPECTED_USERS}
    Log    Successfully retrieved ${count} users (expected at least ${EXPECTED_USERS})
