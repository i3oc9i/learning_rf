*** Settings ***
Documentation     Reusable API Keywords
...               Common keywords for REST API testing
Library           RequestsLibrary
Library           Collections

*** Variables ***
${BASE_URL}       https://jsonplaceholder.typicode.com

*** Keywords ***
# Setup/Teardown Keywords
Initialize API Session
    [Documentation]    Create a session for API testing
    [Arguments]    ${alias}=api    ${base_url}=${BASE_URL}
    Create Session    ${alias}    ${base_url}

# GET Keywords
Get Resource
    [Documentation]    Generic GET request keyword
    [Arguments]    ${endpoint}    ${alias}=api
    ${response}=    GET On Session    ${alias}    ${endpoint}
    RETURN    ${response}

Get Resource And Expect Success
    [Documentation]    GET request with automatic 200 validation
    [Arguments]    ${endpoint}    ${alias}=api
    ${response}=    Get Resource    ${endpoint}    ${alias}
    Should Be Equal As Strings    ${response.status_code}    200
    RETURN    ${response}

# POST Keywords
Create Resource
    [Documentation]    Generic POST request keyword
    [Arguments]    ${endpoint}    ${data}    ${alias}=api
    ${response}=    POST On Session    ${alias}    ${endpoint}    json=${data}
    RETURN    ${response}

Create Resource And Expect Created
    [Documentation]    POST request with automatic 201 validation
    [Arguments]    ${endpoint}    ${data}    ${alias}=api
    ${response}=    Create Resource    ${endpoint}    ${data}    ${alias}
    Should Be Equal As Strings    ${response.status_code}    201
    RETURN    ${response}

# PUT Keywords
Update Resource
    [Documentation]    Generic PUT request keyword
    [Arguments]    ${endpoint}    ${data}    ${alias}=api
    ${response}=    PUT On Session    ${alias}    ${endpoint}    json=${data}
    RETURN    ${response}

# PATCH Keywords
Partially Update Resource
    [Documentation]    Generic PATCH request keyword
    [Arguments]    ${endpoint}    ${data}    ${alias}=api
    ${response}=    PATCH On Session    ${alias}    ${endpoint}    json=${data}
    RETURN    ${response}

# DELETE Keywords
Delete Resource
    [Documentation]    Generic DELETE request keyword
    [Arguments]    ${endpoint}    ${alias}=api
    ${response}=    DELETE On Session    ${alias}    ${endpoint}
    RETURN    ${response}

Delete Resource And Expect Success
    [Documentation]    DELETE request with automatic 200 validation
    [Arguments]    ${endpoint}    ${alias}=api
    ${response}=    Delete Resource    ${endpoint}    ${alias}
    Should Be Equal As Strings    ${response.status_code}    200
    RETURN    ${response}

# Validation Keywords
Response Should Be Successful
    [Documentation]    Validate response has 2xx status code
    [Arguments]    ${response}
    ${status_string}=    Convert To String    ${response.status_code}
    Should Match Regexp    ${status_string}    ^2\\d{2}$

Response Should Have Status
    [Documentation]    Validate specific status code
    [Arguments]    ${response}    ${expected_status}
    Should Be Equal As Strings    ${response.status_code}    ${expected_status}

Response Should Contain Key
    [Documentation]    Validate response JSON contains key
    [Arguments]    ${response}    ${key}
    ${json}=    Set Variable    ${response.json()}
    Dictionary Should Contain Key    ${json}    ${key}

Response Should Contain Keys
    [Documentation]    Validate response JSON contains multiple keys
    [Arguments]    ${response}    @{keys}
    ${json}=    Set Variable    ${response.json()}
    FOR    ${key}    IN    @{keys}
        Dictionary Should Contain Key    ${json}    ${key}
    END

Response Field Should Equal
    [Documentation]    Validate specific field value in response
    [Arguments]    ${response}    ${field}    ${expected_value}
    ${json}=    Set Variable    ${response.json()}
    Should Be Equal As Strings    ${json}[${field}]    ${expected_value}

Response Should Be List
    [Documentation]    Validate response is a list
    [Arguments]    ${response}
    ${json}=    Set Variable    ${response.json()}
    Should Be True    isinstance($json, list)

Response List Should Have Length
    [Documentation]    Validate list response length
    [Arguments]    ${response}    ${expected_length}
    ${json}=    Set Variable    ${response.json()}
    Length Should Be    ${json}    ${expected_length}
