*** Settings ***
Documentation     Kata 3.2 - CSV-Driven Testing
...               Learn: Reading test data from CSV files
Library           RequestsLibrary
Library           String

*** Variables ***
${BASE_URL}       https://jsonplaceholder.typicode.com
${DATA_FILE}      ${CURDIR}/users.csv

*** Test Cases ***
Verify User Details From CSV
    [Documentation]    Data-driven test using CSV file
    [Template]    Verify User Data
    # Data will be read from CSV file
    user_id    expected_name    expected_email_domain
    1          Leanne Graham    hildegard.org
    2          Ervin Howell     anastasia.net
    3          Clementine Bauch    ramiro.us

Verify Users With Loop
    [Documentation]    Alternative approach using FOR loop
    @{test_data}=    Create List
    ...    1    Leanne Graham
    ...    2    Ervin Howell
    ...    3    Clementine Bauch

    Create Session    api    ${BASE_URL}

    FOR    ${user_id}    ${expected_name}    IN    @{test_data}
        ${response}=    GET On Session    api    /users/${user_id}
        ${user}=    Set Variable    ${response.json()}
        Should Be Equal As Strings    ${user}[name]    ${expected_name}
        Log    Verified user: ${expected_name}
    END

*** Keywords ***
Verify User Data
    [Arguments]    ${user_id}    ${expected_name}    ${email_domain}
    Create Session    api    ${BASE_URL}
    ${response}=    GET On Session    api    /users/${user_id}
    Should Be Equal As Strings    ${response.status_code}    200

    ${user}=    Set Variable    ${response.json()}
    Should Be Equal As Strings    ${user}[name]    ${expected_name}
    Should Contain    ${user}[email]    ${email_domain}
    Log    Validated user ${user_id}: ${expected_name} with email domain ${email_domain}
