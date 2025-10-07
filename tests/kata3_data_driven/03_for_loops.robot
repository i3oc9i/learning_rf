*** Settings ***
Documentation     Kata 3.3 - Using FOR Loops for Data Iteration
...               Learn: Different types of loops in Robot Framework
Library           RequestsLibrary
Library           Collections

*** Variables ***
${BASE_URL}       https://jsonplaceholder.typicode.com

*** Test Cases ***
Iterate Over Multiple Posts
    [Documentation]    Loop through posts and validate structure
    Create Session    api    ${BASE_URL}

    FOR    ${post_id}    IN RANGE    1    6
        ${response}=    GET On Session    api    /posts/${post_id}
        ${post}=    Set Variable    ${response.json()}
        Should Not Be Empty    ${post}[title]
        Should Not Be Empty    ${post}[body]
        Log    Post ${post_id}: ${post}[title]
    END

Validate All Users Have Required Fields
    [Documentation]    Get all users and validate each one
    Create Session    api    ${BASE_URL}
    ${response}=    GET On Session    api    /users
    ${users}=    Set Variable    ${response.json()}

    FOR    ${user}    IN    @{users}
        Validate User Structure    ${user}
    END

Create Multiple Posts In Loop
    [Documentation]    Create several posts dynamically
    Create Session    api    ${BASE_URL}

    @{post_ids}=    Create List

    FOR    ${index}    IN RANGE    1    4
        ${title}=    Set Variable    Test Post Number ${index}
        ${body}=    Set Variable    This is test post body number ${index}

        &{post_data}=    Create Dictionary
        ...    title=${title}
        ...    body=${body}
        ...    userId=1

        ${response}=    POST On Session    api    /posts    json=${post_data}
        ${created_post}=    Set Variable    ${response.json()}
        Append To List    ${post_ids}    ${created_post}[id]
        Log    Created post with ID: ${created_post}[id]
    END

    ${count}=    Get Length    ${post_ids}
    Log    Created ${count} posts with IDs: ${post_ids}

Nested Loop Example - Posts And Comments
    [Documentation]    Nested loops to check posts and their comments
    Create Session    api    ${BASE_URL}

    FOR    ${post_id}    IN RANGE    1    4
        ${post_response}=    GET On Session    api    /posts/${post_id}
        ${post}=    Set Variable    ${post_response.json()}
        Log    Checking post: ${post}[title]

        ${comments_response}=    GET On Session    api    /posts/${post_id}/comments
        ${comments}=    Set Variable    ${comments_response.json()}

        FOR    ${comment}    IN    @{comments}
            Should Not Be Empty    ${comment}[email]
            Should Not Be Empty    ${comment}[body]
        END

        ${comment_count}=    Get Length    ${comments}
        Log    Post ${post_id} has ${comment_count} valid comments
    END

*** Keywords ***
Validate User Structure
    [Arguments]    ${user}
    Should Be True    ${user}[id] > 0
    Should Not Be Empty    ${user}[name]
    Should Not Be Empty    ${user}[username]
    Should Not Be Empty    ${user}[email]

    # Validate nested address object
    Dictionary Should Contain Key    ${user}    address
    Should Not Be Empty    ${user}[address][street]
    Should Not Be Empty    ${user}[address][city]

    # Validate nested company object
    Dictionary Should Contain Key    ${user}    company
    Should Not Be Empty    ${user}[company][name]

    Log    User ${user}[name] has valid structure
