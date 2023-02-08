#include <iostream>
#include <fstream>
#include <string>
#include <zlib.h>

using namespace std;

int main() {
    const char *fileName = "420.gz";
    gzFile file = gzopen(fileName, "rb");
    if (file == NULL) {
        cerr << "Error: Unable to open file " << fileName << endl;
        return 1;
    }

    string line;
    while (gzgets(file, &line[0], (int) line.capacity()) != NULL) {
        // Process line
    }

    cout << "Surface Mesh Plot" << endl;
    cout << "By: H. Williamson" << endl;
    cout << "Ref: Comm. ACM 15 100" << endl;

    gzclose(file);
    return 0;
}
