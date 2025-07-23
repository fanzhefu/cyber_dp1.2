/*
https://sid4hack.medium.com/malware-development-part-3-669bebef79c4

Threads Demo:

*/

#include <iostream>
#include <vector>
#include <windows.h>

// Function to simulate file download
DWORD WINAPI downloadFile(LPVOID lpParam) {
	std::string url = *(static_cast<std::string*>(lpParam)); 
	std::cout << "Downloading file from: " << url << std::endl; 
	// Simulate file download time (5 seconds for demonstration) 
	Sleep (5000);
	std::cout << "File downloaded successfully!" << std::endl; 
	return 0;
}
 
 
int main() {

	// List of file URLS to download

	std::vector<std::string> fileUrls = {"https://examplefiles.org/files/documents/csv-example-file-download.csv",
										 "https://examplefiles.org/files/documents/csv-example-file-download-100rows.csv",
										 "https://examplefiles.org/files/documents/csv-example-file-download-1000rows.csv"};
 
	// Create threads to download each file concurrently
	std::vector<HANDLE> threads;
	for (size_t i = 0; i < fileUrls.size(); ++i) {
		HANDLE hThread = CreateThread (NULL, 0, downloadFile, &fileUrls[i], 0, NULL); 
		if (hThread != NULL) {
		threads.push_back(hThread);
		}
	}
	// Wait for all threads to finish
	WaitForMultipleObjects(threads.size(), threads.data(), TRUE, INFINITE);
	std::cout << "All files downloaded successfully!" << std::endl;

	return 0;

}