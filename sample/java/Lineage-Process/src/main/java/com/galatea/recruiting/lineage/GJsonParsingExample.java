package com.galatea.recruiting.lineage;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

/**
 * This class has examples of how to get data out of JSON documents using Google's Gson library.
 * 
 * See http://www.javadoc.io/doc/com.google.code.gson/gson/2.8.2 for the Gson Javadoc.
 */
public class GJsonParsingExample {

	public static void jsonParsingExample() {
		String jsonString = ""
				+ "{"
				+ " 	'fieldWithString': 'value1',"
				+ "		'fieldWithNumber': 2,"
				+ " 	'fieldWithObject': {"
				+ " 		'nestedField1': 'nestedValue1',"
				+ " 		'nestedField2': 'nestedValue2'"
				+ " 	},"
				+ " 	'fieldWithArray': [ 1, 2, 3 ]"
				+ "}";
		
		// Parse a string as a JSON object
		JsonObject parsedObject = new JsonParser().parse(jsonString).getAsJsonObject();
		System.out.println("parsedObject = " + parsedObject);
		
		// Get the value of a string-holding field in a JSON object
		String stringField = parsedObject.get("fieldWithString").getAsString(); // "value1"
		System.out.println("stringField = " + stringField);
		
		// Get the value of an int-holding field
		int numberField = parsedObject.get("fieldWithNumber").getAsInt(); // 2
		System.out.println("numberField = " + numberField);
		
		// Get fields in a nested JSON object
		JsonObject objectField = parsedObject.get("fieldWithObject").getAsJsonObject(); // { "nestedField1": "nestedValue1", "nestedField2": "nestedValue2" }
		String nestedField1 = objectField.get("nestedField1").getAsString(); // "nestedValue1"
		String nestedField2 = objectField.get("nestedField2").getAsString(); // "nestedValue2"
		System.out.println("nestedField1 = " + nestedField1);
		System.out.println("nestedField2 = " + nestedField2);
		
		// Get a nested JSON array
		JsonArray arrayField = parsedObject.get("fieldWithArray").getAsJsonArray(); // [ 1, 2, 3 ]
		System.out.println("arrayField = " + arrayField);
		// Get the value in a certain index of a JSON array
		int arrayItem0 = arrayField.get(0).getAsInt(); // 1
		System.out.println("arrayItem0 = " + arrayItem0);
	}
}
