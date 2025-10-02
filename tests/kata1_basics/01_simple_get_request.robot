*** Settings ***
Documentation     Kata 1.1 - Simple GET Request
...               Learn: Basic test structure, GET request, status code validation
Library           RequestsLibrary

*** Variables ***
${BASE_URL}       https://jsonplaceholder.typicode.com

*** Test Cases ***
Get Single User
    [Documentation]    Fetch a single user and verify response
    Create Session    api    ${BASE_URL}
    ${response}=    GET On Session    api    /users/1
    Should Be Equal As Strings    ${response.status_code}    200
    Log    Response: ${response.json()}

Get All Users
    [Documentation]    Fetch all users and verify we get a list
    Create Session    api    ${BASE_URL}
    ${response}=    GET On Session    api    /users
    Should Be Equal As Strings    ${response.status_code}    200
    ${users}=    Set Variable    ${response.json()}
    Length Should Be    ${users}    10
    Log    Total users: ${users.__len__()}
