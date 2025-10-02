*** Settings ***
Documentation     Kata 4.3 - Using Custom Python Libraries
...               Learn: Create and use custom Python keywords
Library           RequestsLibrary
Library           ../../libraries/CustomValidators.py

*** Variables ***
${BASE_URL}       https://jsonplaceholder.typicode.com

*** Test Cases ***
Validate Email Formats In User Data
    [Documentation]    Use custom email validator
    Create Session    api    ${BASE_URL}
    ${response}=    GET On Session    api    /users/1
    ${user}=    Set Variable    ${response.json()}

    # Use custom keyword from Python library
    Validate Email Format    ${user}[email]
    Log    Email ${user}[email] is valid

Validate Nested JSON Keys
    [Documentation]    Use custom nested key validator
    Create Session    api    ${BASE_URL}
    ${response}=    GET On Session    api    /users/1
    ${user}=    Set Variable    ${response.json()}

    # Validate nested keys using custom keyword
    ${city}=    JSON Should Contain Nested Key    ${user}    address.city
    ${lat}=     JSON Should Contain Nested Key    ${user}    address.geo.lat
    ${lng}=     JSON Should Contain Nested Key    ${user}    address.geo.lng

    Log    User lives in ${city} at coordinates (${lat}, ${lng})

Validate Response Time Performance
    [Documentation]    Ensure API responds within acceptable time
    Create Session    api    ${BASE_URL}
    ${response}=    GET On Session    api    /users

    # Custom performance validation (should be under 2 seconds)
    Validate Response Time    ${response}    2000
    Log    Response time is acceptable

Find Specific User In List
    [Documentation]    Search for user with specific name
    Create Session    api    ${BASE_URL}
    ${response}=    GET On Session    api    /users
    ${users}=    Set Variable    ${response.json()}

    # Use custom search keyword
    ${user}=    List Should Contain Item With Field
    ...    ${users}
    ...    name
    ...    Leanne Graham

    Log    Found user: ${user}[username]

Extract And Validate User IDs
    [Documentation]    Extract all IDs from user list
    Create Session    api    ${BASE_URL}
    ${response}=    GET On Session    api    /users
    ${users}=    Set Variable    ${response.json()}

    # Extract all IDs using custom keyword
    ${ids}=    Extract IDs From List    ${users}

    Log    User IDs: ${ids}
    Length Should Be    ${ids}    10

Validate All User Emails
    [Documentation]    Validate email format for all users
    Create Session    api    ${BASE_URL}
    ${response}=    GET On Session    api    /users
    ${users}=    Set Variable    ${response.json()}

    # Loop through all users and validate emails
    FOR    ${user}    IN    @{users}
        Validate Email Format    ${user}[email]
    END

    Log    All user emails are valid

Combined Custom Validations
    [Documentation]    Use multiple custom validators together
    Create Session    api    ${BASE_URL}
    ${response}=    GET On Session    api    /users/1
    ${user}=    Set Variable    ${response.json()}

    # Multiple custom validations
    Validate Email Format    ${user}[email]
    ${website}=    Set Variable    ${user}[website]
    # Add http:// if not present for validation
    ${full_url}=    Set Variable    http://${website}
    Validate URL Format    ${full_url}

    ${company_name}=    JSON Should Contain Nested Key    ${user}    company.name
    ${street}=    JSON Should Contain Nested Key    ${user}    address.street

    Log    ${user}[name] works at ${company_name}, lives on ${street}
