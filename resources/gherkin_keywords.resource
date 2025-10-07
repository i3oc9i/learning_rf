*** Settings ***
Documentation     Gherkin-Style Keywords for BDD Testing
...               Given-When-Then keywords following BDD patterns
Library           RequestsLibrary
Library           Collections
Resource          api_keywords.resource

*** Variables ***
# These variables are used to share state between Gherkin-style keywords
# within a test case. They are set dynamically during test execution.
${LAST_RESPONSE}      ${None}    # Stores the most recent API response
${REQUEST_DATA}       ${None}    # Stores request data for POST/PUT/PATCH operations

*** Keywords ***
# ============================================================================
# GIVEN Keywords - Setup and preconditions
# ============================================================================

Given the API is available
    [Documentation]    Initialize API session
    Initialize API Session

Given the "${alias}" API is available at "${base_url}"
    [Documentation]    Initialize API session with custom parameters
    Initialize API Session    ${alias}    ${base_url}

# ============================================================================
# WHEN Keywords - Actions
# ============================================================================

When I send a GET request to "${endpoint}"
    [Documentation]    Send GET request and store response
    ${response}=    Get Resource    ${endpoint}
    Set Test Variable    ${LAST_RESPONSE}    ${response}

When I send a POST request to "${endpoint}" with data
    [Documentation]    Send POST request with JSON body (data should be set as ${REQUEST_DATA})
    [Arguments]    ${data}=${REQUEST_DATA}
    ${response}=    Create Resource    ${endpoint}    ${data}
    Set Test Variable    ${LAST_RESPONSE}    ${response}

When I create a ${resource_type} with
    [Documentation]    Create a resource with provided dictionary data
    [Arguments]    ${endpoint}    &{data}
    Set Test Variable    ${REQUEST_DATA}    ${data}
    ${response}=    Create Resource    ${endpoint}    ${data}
    Set Test Variable    ${LAST_RESPONSE}    ${response}

When I update "${endpoint}" with data
    [Documentation]    Send PUT request
    [Arguments]    ${data}=${REQUEST_DATA}
    ${response}=    Update Resource    ${endpoint}    ${data}
    Set Test Variable    ${LAST_RESPONSE}    ${response}

When I partially update "${endpoint}" with data
    [Documentation]    Send PATCH request
    [Arguments]    ${data}=${REQUEST_DATA}
    ${response}=    Partially Update Resource    ${endpoint}    ${data}
    Set Test Variable    ${LAST_RESPONSE}    ${response}

When I delete "${endpoint}"
    [Documentation]    Send DELETE request
    ${response}=    Delete Resource    ${endpoint}
    Set Test Variable    ${LAST_RESPONSE}    ${response}

When I set request data
    [Documentation]    Set request data dictionary for next request
    [Arguments]    &{data}
    Set Test Variable    ${REQUEST_DATA}    ${data}

# ============================================================================
# THEN Keywords - Assertions
# ============================================================================

Then the response status should be "${expected_status}"
    [Documentation]    Validate response status code
    Response Should Have Status    ${LAST_RESPONSE}    ${expected_status}

Then the response should be successful
    [Documentation]    Validate 2xx status code
    Response Should Be Successful    ${LAST_RESPONSE}

Then the response should contain "${key}"
    [Documentation]    Validate response has specific key
    Response Should Contain Key    ${LAST_RESPONSE}    ${key}

Then the response should contain keys
    [Documentation]    Validate response has multiple keys
    [Arguments]    @{keys}
    Response Should Contain Keys    ${LAST_RESPONSE}    @{keys}

Then the response "${field}" should be "${expected_value}"
    [Documentation]    Validate specific field value
    Response Field Should Equal    ${LAST_RESPONSE}    ${field}    ${expected_value}

Then the response should be a list
    [Documentation]    Validate response is a list
    Response Should Be List    ${LAST_RESPONSE}

Then the response list should have "${length}" items
    [Documentation]    Validate list length
    Response List Should Have Length    ${LAST_RESPONSE}    ${length}

Then the response should not be empty
    [Documentation]    Validate response has content
    ${json}=    Set Variable    ${LAST_RESPONSE.json()}
    Should Not Be Empty    ${json}

# ============================================================================
# AND Keywords - Additional validations (alias for Then)
# ============================================================================

And the response status should be "${expected_status}"
    Then the response status should be "${expected_status}"

And the response should be successful
    Then the response should be successful

And the response should contain "${key}"
    Then the response should contain "${key}"

And the response should contain keys
    [Arguments]    @{keys}
    Then the response should contain keys    @{keys}

And the response "${field}" should be "${expected_value}"
    Then the response "${field}" should be "${expected_value}"

And the response should be a list
    Then the response should be a list

And the response list should have "${length}" items
    Then the response list should have "${length}" items

And the response should not be empty
    Then the response should not be empty

And I set request data
    [Documentation]    Alias for setting request data (Given/When variant)
    [Arguments]    &{data}
    When I set request data    &{data}

And I send a GET request to "${endpoint}"
    [Documentation]    Alias for GET request
    When I send a GET request to "${endpoint}"

And I send a POST request to "${endpoint}" with data
    [Documentation]    Alias for POST request
    When I send a POST request to "${endpoint}" with data
