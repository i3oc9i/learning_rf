"""
Custom Python Library for Robot Framework
Demonstrates how to create custom keywords in Python
"""

import re
from typing import Any, Dict, List


class CustomValidators:
    """
    Custom validation keywords for API testing.

    This library provides additional validation capabilities
    beyond what's available in standard Robot Framework libraries.
    """

    ROBOT_LIBRARY_SCOPE = 'GLOBAL'
    ROBOT_LIBRARY_VERSION = '1.0'

    def validate_email_format(self, email: str) -> bool:
        """
        Validates that a string is in valid email format.

        Args:
            email: Email string to validate

        Returns:
            True if valid email format

        Raises:
            AssertionError: If email format is invalid

        Example:
            | Validate Email Format | user@example.com |
        """
        email_pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
        if not re.match(email_pattern, email):
            raise AssertionError(f"'{email}' is not a valid email format")
        return True

    def validate_url_format(self, url: str) -> bool:
        """
        Validates that a string is in valid URL format.

        Args:
            url: URL string to validate

        Returns:
            True if valid URL format

        Raises:
            AssertionError: If URL format is invalid

        Example:
            | Validate URL Format | https://example.com |
        """
        url_pattern = r'^https?://[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}'
        if not re.match(url_pattern, url):
            raise AssertionError(f"'{url}' is not a valid URL format")
        return True

    def json_should_contain_nested_key(self, json_data: Dict, key_path: str) -> Any:
        """
        Validates that a nested key exists in JSON data using dot notation.

        Args:
            json_data: Dictionary/JSON object to search
            key_path: Dot-separated path (e.g., 'user.address.city')

        Returns:
            Value at the nested key

        Raises:
            AssertionError: If nested key doesn't exist

        Example:
            | ${response}= | GET Request | /users/1 |
            | ${json}= | Set Variable | ${response.json()} |
            | JSON Should Contain Nested Key | ${json} | address.geo.lat |
        """
        keys = key_path.split('.')
        current = json_data

        for key in keys:
            if not isinstance(current, dict) or key not in current:
                raise AssertionError(
                    f"Nested key '{key_path}' not found in JSON. "
                    f"Failed at '{key}'"
                )
            current = current[key]

        return current

    def validate_response_time(self, response, max_time_ms: int) -> bool:
        """
        Validates that response time is under specified threshold.

        Args:
            response: Response object from RequestsLibrary
            max_time_ms: Maximum allowed time in milliseconds

        Returns:
            True if response time is acceptable

        Raises:
            AssertionError: If response time exceeds threshold

        Example:
            | ${response}= | GET Request | /users |
            | Validate Response Time | ${response} | 1000 |
        """
        # Response.elapsed is a timedelta object
        response_time_ms = response.elapsed.total_seconds() * 1000

        if response_time_ms > max_time_ms:
            raise AssertionError(
                f"Response time {response_time_ms:.2f}ms exceeds "
                f"maximum allowed {max_time_ms}ms"
            )
        return True

    def list_should_contain_item_with_field(
        self,
        items: List[Dict],
        field_name: str,
        field_value: Any
    ) -> Dict:
        """
        Validates that a list contains at least one item with specified field value.

        Args:
            items: List of dictionaries to search
            field_name: Name of the field to check
            field_value: Expected value of the field

        Returns:
            First matching item

        Raises:
            AssertionError: If no matching item found

        Example:
            | ${users}= | GET Request | /users |
            | List Should Contain Item With Field | ${users.json()} | name | John Doe |
        """
        for item in items:
            if isinstance(item, dict) and item.get(field_name) == field_value:
                return item

        raise AssertionError(
            f"No item found with {field_name}='{field_value}' in list of {len(items)} items"
        )

    def extract_ids_from_list(self, items: List[Dict], id_field: str = 'id') -> List:
        """
        Extracts all ID values from a list of objects.

        Args:
            items: List of dictionaries
            id_field: Name of the ID field (default: 'id')

        Returns:
            List of ID values

        Example:
            | ${users}= | GET Request | /users |
            | ${ids}= | Extract IDs From List | ${users.json()} |
            | Log | User IDs: ${ids} |
        """
        return [item.get(id_field) for item in items if isinstance(item, dict)]

    def validate_iso_date_format(self, date_string: str) -> bool:
        """
        Validates that a string is in ISO 8601 date format.

        Args:
            date_string: Date string to validate

        Returns:
            True if valid ISO date format

        Raises:
            AssertionError: If date format is invalid

        Example:
            | Validate ISO Date Format | 2024-01-15T10:30:00Z |
        """
        iso_pattern = r'^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}'
        if not re.match(iso_pattern, date_string):
            raise AssertionError(
                f"'{date_string}' is not in ISO 8601 date format"
            )
        return True
