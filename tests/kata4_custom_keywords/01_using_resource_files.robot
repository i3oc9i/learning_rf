*** Settings ***
Documentation     Kata 4.1 - Using Resource Files for Code Reuse
...               Learn: How to organize and reuse keywords via resource files
Resource          ../../resources/api_keywords.resource

*** Test Cases ***
Test Using Reusable Keywords - Get User
    [Documentation]    Use generic keywords from resource file
    Initialize API Session
    ${response}=    Get Resource And Expect Success    /users/1
    Response Should Contain Keys    ${response}    id    name    email    username

Test Using Reusable Keywords - Create Post
    [Documentation]    Create a post using reusable keywords
    Initialize API Session

    &{post_data}=    Create Dictionary
    ...    title=Reusable Keyword Test
    ...    body=Testing with resource files
    ...    userId=1

    ${response}=    Create Resource And Expect Created    /posts    ${post_data}
    Response Field Should Equal    ${response}    title    Reusable Keyword Test

Test Using Reusable Keywords - Update And Delete
    [Documentation]    Update and delete using reusable keywords
    Initialize API Session

    # Update
    &{update_data}=    Create Dictionary    title=Updated via Resource
    ${update_response}=    Partially Update Resource    /posts/1    ${update_data}
    Response Should Have Status    ${update_response}    200

    # Delete
    ${delete_response}=    Delete Resource And Expect Success    /posts/1

Test Validation Keywords
    [Documentation]    Test various validation keywords
    Initialize API Session

    ${response}=    Get Resource    /users
    Response Should Be Successful    ${response}
    Response Should Be List    ${response}
    Response List Should Have Length    ${response}    10
