"""
This function has an example of how to get data out of JSON documents using Python.

See https://docs.python.org/3/library/json.html for the Python json library documentation.
"""
import json


def json_parsing_example():
    json_string = '''
    {
    "fieldWithString": "value1",
    "fieldWithNumber": 2,
    "fieldWithObject": {
    "nestedField1": "nestedValue1",
    "nestedField2": "nestedValue2"
    },
    "fieldWithArray": [ 1, 2, 3 ]
    }
    '''

    # Parse a string as a JSON object
    parsed_object = json.loads(json_string)
    print("parsed_object = %s" % parsed_object)

    # Get the value of a field in a JSON object
    string_field = parsed_object['fieldWithString']
    print("string_field = %s" % string_field)

    number_field = parsed_object['fieldWithNumber']
    print("number_field = %s" % number_field)

    # Get fields in a nested JSON object
    nested_field_1 = parsed_object['fieldWithObject']['nestedField1']
    nested_field_2 = parsed_object['fieldWithObject']['nestedField2']
    print('nested_field_1 = %s' % nested_field_1)
    print('nested_field_2 = %s' % nested_field_2)

    # Get a nested JSON array
    array_field = parsed_object['fieldWithArray']
    print('array_field = %s' % array_field)
    # Get the value in a certain index of a JSON array
    array_item_0 = array_field[0]
    print('array_item_0 = %s' % array_item_0)


if __name__ == "__main__":
    json_parsing_example()
