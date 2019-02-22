#include <iostream>
#include <sstream>
#include <fstream>
#include "lib/json.hpp"
#include "JsonParsingExample.hpp"

// for convenience
using json = nlohmann::json;
using namespace std;

string INPUT_FILE = "tree.json";

int main(int argc, char** argv) {
    // Parse file into string
    ifstream t(INPUT_FILE);
    stringstream buffer;
    buffer << t.rdbuf();
    string stringFile = buffer.str();
    cout << stringFile << endl;

    JsonForModernCppParsingExample::jsonParsingExample();
    return 0;
}
