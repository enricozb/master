#include "Python.h"

void py_exec() {
	Py_Initialize();
	PyObject* main_module = PyImport_AddModule("__main__");

	// Get the main module's dictionary
	// and make a copy of it.
	PyObject* main_dict = PyModule_GetDict(main_module);

	FILE* file = fopen("pisd.py", "r");
	PyRun_File(file, "pisd.py", Py_file_input, main_dict, main_dict);
	Py_Finalize();
}

int main() {
	py_exec();
	return 0;
}