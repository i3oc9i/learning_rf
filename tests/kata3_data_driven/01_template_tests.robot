*** Settings ***
Documentation     Kata 3.1 - Data-Driven Testing with Templates
...               Learn: Test templates for running same test with different data
Library           RequestsLibrary

*** Variables ***
${BASE_URL}       https://jsonplaceholder.typicode.com

*** Test Cases ***
Verify Multiple Users Exist
    [Documentation]    Test template to verify multiple users
    [Template]    User Should Exist
    1
    2
    3
    5
    10

Verify Posts For Different Users
    [Documentation]    Check posts exist for various user IDs
    [Template]    User Should Have Posts
    1    10
    2    10
    3    10

*** Keywords ***
User Should Exist
    [Arguments]    ${user_id}
    Create Session    api    ${BASE_URL}
    ${response}=    GET On Session    api    /users/${user_id}
    Should Be Equal As Strings    ${response.status_code}    200
    ${user}=    Set Variable    ${response.json()}
    Should Not Be Empty    ${user}[name]
    Should Not Be Empty    ${user}[email]
    Log    User ${user_id}: ${user}[name]

User Should Have Posts
    [Arguments]    ${user_id}    ${expected_count}
    Create Session    api    ${BASE_URL}
    ${response}=    GET On Session    api    /users/${user_id}/posts
    Should Be Equal As Strings    ${response.status_code}    200
    ${posts}=    Set Variable    ${response.json()}
    Length Should Be    ${posts}    ${expected_count}
    Log    User ${user_id} has ${expected_count} posts
