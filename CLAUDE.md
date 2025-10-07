# CLAUDE.md

## Project Overview

This is a learning repository for **Robot Framework** focused on REST API testing with Gherkin-style BDD patterns. The project uses [JSONPlaceholder](https://jsonplaceholder.typicode.com/) as the test API and is organized as a progressive kata series.

**Core Technologies:**

- Robot Framework 7.3.2+
- robotframework-requests (HTTP/REST testing)
- robotframework-jsonlibrary (JSON validation)
- UV for dependency management

## Running Tests

### Basic Commands

```bash
# Run all tests
uv run robot tests/

# Run specific kata directory
uv run robot tests/kata1_basics/

# Run single test file
uv run robot tests/kata2_gherkin/01_gherkin_style.robot

# Run specific test case by name
uv run robot -t "User Should Be Able To Retrieve A Post" tests/kata2_gherkin/01_gherkin_style.robot

# Run with custom output directory
uv run robot -d results tests/

# Run with tags (if tests have tags defined)
uv run robot -i smoke tests/
```

### Test Output

Robot Framework generates three files after each run:

- `report.html` - High-level test execution report
- `log.html` - Detailed execution log with all keywords
- `output.xml` - Machine-readable XML results

## Project Architecture

### Directory Structure

```text
tests/                          # Progressive kata-based learning structure
  kata1_basics/                 # Basic HTTP operations (GET, POST, PUT, DELETE)
  kata2_gherkin/                # BDD-style Given-When-Then patterns
  kata3_data_driven/            # Templates, FOR loops, CSV data
  kata4_custom_keywords/        # Resource files and custom Python libraries

resources/                      # Reusable Robot Framework keywords
  api_keywords.resource         # Generic REST API abstractions (CRUD operations)
  gherkin_keywords.resource     # BDD-style Given/When/Then keywords

libraries/                      # Custom Python libraries
  CustomValidators.py           # Python-based validation keywords
```

### Key Design Patterns

**1. Resource Files ([resources/](resources/))**

- Contain reusable keywords to avoid duplication
- `api_keywords.resource` provides generic HTTP operation wrappers (Get Resource, Create Resource, etc.)
- `gherkin_keywords.resource` provides BDD-style keywords for natural language tests
- Import with: `Resource    ../../resources/api_keywords.resource`

**2. Custom Python Libraries ([libraries/CustomValidators.py](libraries/CustomValidators.py))**

- Provides complex validation logic not available in standard libraries
- Examples: email format validation, nested JSON key checks, response time validation
- Import with: `Library    ../../libraries/CustomValidators.py`

**3. Session Management Pattern**

- All tests use `Create Session` to establish a named HTTP session (typically aliased as `api`)
- Session allows multiple requests without re-specifying base URL
- Pattern: `Create Session    api    ${BASE_URL}`

**4. Kata Progression**

- **Kata 1**: Foundation - basic RequestsLibrary usage, direct keyword calls
- **Kata 2**: BDD patterns - Given/When/Then style with custom keywords
- **Kata 3**: Data-driven - test templates, FOR loops, parameterization
- **Kata 4**: Reusability - resource files and Python libraries

## Robot Framework Conventions

### Variable Syntax

- `${SCALAR}` - Single value (string, number, object)
- `@{LIST}` - List of values
- `&{DICT}` - Dictionary with key-value pairs
- `${VAR}[key]` - Dictionary access
- `${VAR}[0]` - List index access

### File Structure

Every `.robot` file follows this structure:

```robot
*** Settings ***
Documentation     Test suite description
Library           RequestsLibrary
Resource          ../../resources/api_keywords.resource

*** Variables ***
${BASE_URL}       https://jsonplaceholder.typicode.com

*** Test Cases ***
Test Case Name
    [Documentation]    Test case description
    Keyword With Argument    value

*** Keywords ***
Custom Keyword Name
    [Documentation]    Keyword description
    [Arguments]    ${arg1}    ${arg2}
    # keyword implementation
```

### Common RequestsLibrary Keywords

- `Create Session    ${alias}    ${base_url}` - Initialize HTTP session
- `GET On Session    ${alias}    ${endpoint}` - GET request
- `POST On Session    ${alias}    ${endpoint}    json=${data}` - POST with JSON body
- `PUT On Session    ${alias}    ${endpoint}    json=${data}` - PUT request
- `PATCH On Session    ${alias}    ${endpoint}    json=${data}` - PATCH request
- `DELETE On Session    ${alias}    ${endpoint}` - DELETE request

### Response Validation Pattern

```robot
${response}=    GET On Session    api    /users/1
Should Be Equal As Strings    ${response.status_code}    200
${json}=    Set Variable    ${response.json()}
Dictionary Should Contain Key    ${json}    email
```

## Writing New Tests

### For Basic Tests

1. Start with `*** Settings ***` section - import RequestsLibrary
2. Define `${BASE_URL}` in `*** Variables ***`
3. Create session in test case setup
4. Use `GET/POST/PUT/DELETE On Session` keywords
5. Validate with `Should Be Equal As Strings` for status codes

### For Gherkin-Style Tests

1. Import `resources/gherkin_keywords.resource`
2. Use Given/When/Then/And keywords for natural language flow
3. Keywords should read like business requirements
4. Example: `Given User Requests A List Of All Posts`

### For Data-Driven Tests

1. Use `[Template]` setting for test case to run with multiple data sets
2. Use FOR loops for iterating over API responses or data
3. Pattern: `FOR    ${item}    IN    @{list} ... END`

### For Custom Validation

1. Import `libraries/CustomValidators.py`
2. Use keywords like: `Validate Email Format`, `JSON Should Contain Nested Key`, `Validate Response Time`
3. For new validators, add methods to CustomValidators class following existing patterns

## JSONPlaceholder API Reference

Base URL: `https://jsonplaceholder.typicode.com`

**Available Resources:**

- `/posts` - 100 blog posts
- `/comments` - 500 comments
- `/albums` - 100 albums
- `/photos` - 5000 photos
- `/todos` - 200 todo items
- `/users` - 10 users

**Behavior:**

- GET requests return real data
- POST/PUT/PATCH/DELETE are faked (return success but don't persist)
- Useful for testing without side effects

## Common Development Tasks

### Adding New Custom Validators

Edit [libraries/CustomValidators.py](libraries/CustomValidators.py):

1. Add method to CustomValidators class
2. Use descriptive name (becomes keyword name with spaces)
3. Include docstring (becomes keyword documentation)
4. Raise AssertionError for validation failures
5. Return value or True on success

### Creating New Resource Files

1. Create `.resource` file in `resources/`
2. Start with `*** Settings ***` and `*** Keywords ***` sections
3. Document each keyword with `[Documentation]` tag
4. Use `[Arguments]` for parameters with defaults when appropriate

### Test Naming

- Test files: `descriptive_name.robot`
- Test cases: Natural language with proper capitalization ("User Should Be Able To...")
- Keywords: Natural language with spaces (converted from Python snake_case)
