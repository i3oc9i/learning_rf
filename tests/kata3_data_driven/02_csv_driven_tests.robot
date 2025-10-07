*** Settings ***
Documentation     Kata 3.2 - CSV-Driven Testing
...               Learn: Reading test data from CSV files
Library           RequestsLibrary
Library           String
Library           OperatingSystem
Library           Collections

*** Variables ***
${BASE_URL}       https://jsonplaceholder.typicode.com
${DATA_FILE}      ${CURDIR}/users.csv

*** Test Cases ***
Verify User Details From CSV
    [Documentation]    Data-driven test reading from CSV file
    @{test_data}=    Load CSV Data    ${DATA_FILE}
    
    FOR    ${row}    IN    @{test_data}
        ${user_id}=    Get From List    ${row}    0
        ${expected_name}=    Get From List    ${row}    1
        ${expected_email_domain}=    Get From List    ${row}    2
        Verify User Data    ${user_id}    ${expected_name}    ${expected_email_domain}
    END

*** Keywords ***
Load CSV Data
    [Arguments]    ${csv_file}
    [Documentation]    Reads CSV file and returns data rows (excluding header)
    ${content}=    Get File    ${csv_file}
    @{lines}=    Split To Lines    ${content}
    Remove From List    ${lines}    0    # Remove header row
    @{test_data}=    Create List
    
    FOR    ${line}    IN    @{lines}
        Continue For Loop If    '${line}' == ''
        @{row}=    Split String    ${line}    ,
        Append To List    ${test_data}    ${row}
    END
    
    RETURN    ${test_data}

Verify User Data
    [Arguments]    ${user_id}    ${expected_name}    ${expected_email_domain}
    Create Session    api    ${BASE_URL}
    ${response}=    GET On Session    api    /users/${user_id}
    Should Be Equal As Strings    ${response.status_code}    200

    ${user}=    Set Variable    ${response.json()}
    Should Be Equal As Strings    ${user}[name]    ${expected_name}
    Should Contain    ${user}[email]    ${expected_email_domain}
    Log    Validated user ${user_id}: ${expected_name} with email domain ${expected_email_domain}
