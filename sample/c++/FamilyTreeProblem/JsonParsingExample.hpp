#ifndef JSON_PARSING_EXAMPLE_H
#define JSON_PARSING_EXAMPLE_H

#include <iostream>
#include "lib/json.hpp"

// for convenience
using json = nlohmann::json;
using namespace std;

/**
 * This class has examples of how to get data out of JSON documents using the "JSON for Modern C++" library
 * 
 * See https://github.com/nlohmann/json for the documentation.
 */
class JsonForModernCppParsingExample {
    public:
        static void jsonParsingExample() {
            string jsonString =
                    "{"
                    " 	\"fieldWithString\": \"value1\","
                    "	\"fieldWithNumber\": 2,"
                    " 	\"fieldWithObject\": {"
                    " 		\"nestedField1\": \"nestedValue1\","
                    " 		\"nestedField2\": \"nestedValue2\""
                    " 	},"
                    " 	\"fieldWithArray\": [ 1, 2, 3 ]"
                    "}";
            
            // Parse a string as a JSON object
            json parsedObject = json::parse(jsonString);
            cout << "parsedObject = " << parsedObject << endl;

            // Get the value of a string-holding field in a JSON object
            string stringField = parsedObject["fieldWithString"]; // "value1"
            cout << "stringField = " << stringField << endl;

            // Get the value of an int-holding field
            int numberField = parsedObject["fieldWithNumber"]; // 2
            cout << "numberField = " << numberField << endl;

            // Get fields in a nested JSON object
            json objectField = parsedObject["fieldWithObject"]; // { "nestedField1": "nestedValue1", "nestedField2": "nestedValue2" }
            string nestedField1 = objectField["nestedField1"];
            string nestedField2 = objectField["nestedField2"];
            cout << "nestedField1 = " << nestedField1 << endl;
            cout << "nestedField2 = " << nestedField2 << endl;

            // Get a nested JSON array
            vector<int> arrayField = parsedObject["fieldWithArray"]; // [ 1, 2, 3 ]
            cout << "arrayField = [";
            for(int i=0; i<arrayField.size(); ++i) {
                cout << arrayField[i];
                if (i != arrayField.size() - 1)
                    cout << ", ";
            }
            cout << "]" << endl;
            // Get the value in a certain index of a JSON array
            int arrayItem0 = arrayField[0];
            cout << "arrayItem0 = " << arrayItem0 << endl;
        }
};
 
#endif