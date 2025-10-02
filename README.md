# Robot Framework - REST API Testing with Gherkin

A comprehensive learning project for Robot Framework focused on REST API testing with Gherkin-style test cases.

## <� What is Robot Framework?

**Robot Framework** is a generic open-source automation framework for acceptance testing, acceptance test-driven development (ATDD), and robotic process automation (RPA). It uses a keyword-driven approach and supports Gherkin-style (Given-When-Then) syntax.

### Key Concepts

- **Test Cases**: Organized in `.robot` files using tabular syntax
- **Keywords**: Reusable actions (built-in or custom)
- **Libraries**: Collections of keywords (Python or Java)
- **Resources**: Files containing reusable keywords and variables
- **Variables**: Data that can be reused across tests
- **Test Suites**: Collections of test cases in a file or directory

## =� Project Structure

```text
learning_rf/
  tests/                       # All test cases organized by kata
    kata1_basics/              # Basic REST API operations
    kata2_gherkin/             # Gherkin-style BDD tests
    kata3_data_driven/         # Data-driven testing patterns
    kata4_custom_keywords/     # Reusable keywords & libraries
  resources/                   # Reusable keyword resources
    api_keywords.resource      # Generic API keywords
    gherkin_keywords.resource  # Gherkin-style keywords
  libraries/                   # Custom Python libraries
    CustomValidators.py        # Custom validation keywords
  results/                  # Test execution reports
```

## =� Setup

This project uses [UV](https://docs.astral.sh/uv/) for dependency management.

```bash
# Project is already initialized with UV
# Dependencies are already installed

# Activate virtual environment
source .venv/bin/activate  # Linux/Mac
# or
.venv\Scripts\activate     # Windows
```

### Dependencies

- `robotframework` - Core framework
- `robotframework-requests` - HTTP/REST API testing
- `robotframework-jsonlibrary` - JSON validation

## <� Learning Path

Follow these katas in order to progressively learn Robot Framework:

### Kata 1: Basic REST API Testing

**Location**: [tests/kata1_basics](tests/kata1_basics/)

Learn the fundamentals of Robot Framework and basic HTTP operations.

- **01_simple_get_request.robot** - GET requests, status code validation
- **02_post_request.robot** - POST requests with JSON bodies
- **03_put_delete_requests.robot** - PUT, PATCH, DELETE operations

**Key Learnings**:

- Robot Framework file structure (Settings, Variables, Test Cases, Keywords)
- RequestsLibrary basics
- Session management
- Response validation

**Run it**:

```bash
uv run robot tests/kata1_basics/01_simple_get_request.robot
```

### Kata 2: Gherkin-Style Testing

**Location**: [tests/kata2_gherkin](tests/kata2_gherkin/)

Learn to write BDD-style tests using Given-When-Then syntax.

- **01_gherkin_style.robot** - Basic Gherkin keywords
- **02_gherkin_advanced.robot** - Multi-step scenarios, complex flows

**Key Learnings**:

- Given-When-Then pattern
- Custom keywords for BDD
- Test readability and business language
- Multi-step workflows

**Run it**:

```bash
uv run robot tests/kata2_gherkin/
```

### Kata 3: Data-Driven Testing

**Location**: [tests/kata3_data_driven](tests/kata3_data_driven/)

Learn to run the same test with multiple data sets.

- **01_template_tests.robot** - Test templates
- **02_csv_driven_tests.robot** - CSV data files (demo)
- **03_for_loops.robot** - FOR loops for iteration

**Key Learnings**:

- Test templates
- FOR loops (simple, range, nested)
- Data-driven patterns
- Iterating over API responses

**Run it**:

```bash
uv run robot tests/kata3_data_driven/
```

### Kata 4: Custom Keywords & Libraries

**Location**: [tests/kata4_custom_keywords](tests/kata4_custom_keywords/)

Learn to create reusable components for better test organization.

- **01_using_resource_files.robot** - Import and use resource files
- **02_gherkin_with_resources.robot** - Combine Gherkin with resources
- **03_custom_python_library.robot** - Use custom Python keywords

**Resources**:

- [resources/api_keywords.resource](resources/api_keywords.resource) - Generic API keywords
- [resources/gherkin_keywords.resource](resources/gherkin_keywords.resource) - Gherkin keywords
- [libraries/CustomValidators.py](libraries/CustomValidators.py) - Custom Python library

**Key Learnings**:

- Creating resource files
- Keyword organization
- Creating Python libraries
- Reusability patterns

**Run it**:

```bash
uv run robot tests/kata4_custom_keywords/
```

## <� Running Tests

### Run All Tests

```bash
uv run robot tests/
```

### Run Specific Kata

```bash
uv run robot tests/kata1_basics/
```

### Run Specific Test File

```bash
uv run robot tests/kata2_gherkin/01_gherkin_style.robot
```

### Run Specific Test Case

```bash
uv run robot -t "User Should Be Able To Retrieve A Post" tests/kata2_gherkin/01_gherkin_style.robot
```

### Generate Reports in Custom Directory

```bash
uv run robot -d results tests/
```

### Run with Tags (add tags to tests first)

```bash
uv run robot -i smoke tests/
```

### Run in Parallel (requires robot-framework-parallel)

```bash
# Install additional package
uv add robotframework-parallel

# Run in parallel
uv run pabot tests/
```

## =� Test Reports

After running tests, Robot Framework generates:

- **report.html** - High-level test execution report
- **log.html** - Detailed execution log with keywords
- **output.xml** - Machine-readable results

Open `report.html` in a browser to view results.

## =� Best Practices

### 1. **Naming Conventions**

- Test files: `descriptive_name.robot`
- Test cases: Use natural language ("User Should Be Able To...")
- Keywords: Use natural language with spaces

### 2. **Organization**

- One test suite per file
- Group related tests in directories
- Use resource files for reusable keywords
- Create custom libraries for complex logic

### 3. **Gherkin Style**

- Use Given for setup/preconditions
- Use When for actions
- Use Then for assertions
- Use And/But for additional steps

### 4. **Documentation**

- Document test suites and test cases
- Add [Documentation] to explain purpose
- Use comments sparingly (tests should be self-documenting)

### 5. **Variables**

- Use ${VARIABLE} for scalars
- Use @{LIST} for lists
- Use &{DICT} for dictionaries
- Store base URLs and common data in variables

## =' Common Robot Framework Syntax

### Variables

```robot
${SCALAR}          Single value
@{LIST}            List of values
&{DICT}            Dictionary (key-value pairs)
${VAR}[key]        Dictionary access
${VAR}[0]          List access
```

### Control Structures

```robot
FOR    ${item}    IN    @{list}
    Log    ${item}
END

IF    ${condition}
    Log    True branch
ELSE
    Log    False branch
END
```

### Keywords

```robot
# Built-in keywords
Log                     Log To Console
Should Be Equal         Length Should Be
Set Variable           Create Dictionary

# RequestsLibrary
Create Session         GET On Session
POST On Session        PUT On Session
DELETE On Session      PATCH On Session
```

## < API Endpoint Used

This project uses [JSONPlaceholder](https://jsonplaceholder.typicode.com/) - a free fake REST API for testing.

Available resources:

- `/posts` - 100 posts
- `/comments` - 500 comments
- `/albums` - 100 albums
- `/photos` - 5000 photos
- `/todos` - 200 todos
- `/users` - 10 users

## <� Next Steps

After completing all katas:

1. **Practice**: Create your own test scenarios
2. **Explore**: Try other RF libraries (DatabaseLibrary, SSHLibrary)
3. **Integrate**: Add RF to CI/CD pipelines
4. **Advanced**: Learn about listeners, test libraries, dynamic test generation

## =� Additional Resources

- [Robot Framework User Guide](https://robotframework.org/robotframework/latest/RobotFrameworkUserGuide.html)
- [RequestsLibrary Documentation](https://marketsquare.github.io/robotframework-requests/doc/RequestsLibrary.html)
- [Robot Framework Keywords](https://robotframework.org/robotframework/latest/libraries/BuiltIn.html)
- [JSONPlaceholder API Guide](https://jsonplaceholder.typicode.com/guide/)
