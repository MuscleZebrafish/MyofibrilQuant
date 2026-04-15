// Starting message
showMessage("Myofibril Grayscale", "Welcome to the Myofibril intensity macro.\n\nPlease start by choosing the folder containing *.tif images to process.\n\n\nVersion 1.1, updated 2023-05-31.");

// Get folder to process from user
processPath = getDir("Choose Experiment Folder...");

// Get custom scale for pixels per micron at the given magnification
// Should be a constant only calculated once per experiment
customScale = getNumber("Pixels per Micron:", 0);

// Setup output folders
processedImages = processPath + File.separator + "processedImages" + File.separator;
if (!File.isDirectory(processedImages)) {
	File.makeDirectory(processedImages);	
}

roiFiles = processPath + File.separator + "roiFiles" + File.separator;
channels = newArray("red", "green", "blue");
if (!File.isDirectory(roiFiles)) {
	File.makeDirectory(roiFiles);	
}

csvData = processPath + File.separator + "csvData" + File.separator;
if (!File.isDirectory(csvData)) {
	File.makeDirectory(csvData);
	for (i = 0; i < channels.length; i++) {
		File.makeDirectory(csvData + File.separator + channels[i]);
	}	
}


// Get list of all *.tif files in Experiment folder
images = getFileList(processPath);


// Loop through all images for processing
for (i=0; i<images.length; i++) {
	// Only process *.tif files
	if (!images[i].contains(".tif")){
		continue; // with next iteration
	}
	
	// Open file
	open(processPath + File.separator + images[i]);
	title = getTitle();
	titleParts = split(title, ".");
	imageName = titleParts[0];
	
	// allow for aborting the analysis (even on Mac)
	analyzeImage = getBoolean("Process image " + imageName + "?", "Analyze", "Stop Analysis"); 
	if (! analyzeImage){
		close();
		showMessage("Stopping analysis for now. Rerun macro to start again.");
		break; // break out of for loop
	} 		
		
	// If "180" image then rotate 180 degrees
	if (imageName.contains("_180_")){
		showMessage("180 Image - rotating 180 degrees for processing");
		run("Rotate 90 Degrees Right");
		run("Rotate 90 Degrees Right");
	}
		
	// Setup the space to draw your ROIs
	run("Set Scale...", "distance=customScale known=1 unit=micron global");
	run("ROI Manager...");
	roiManager("reset"); // remove any previous data
	
	// Prompt user to confirm scale
	waitForUser("Draw line over scale bar and make sure its length matches.");
	roiManager("reset");
	
	// Setup ROI line preferences
	roiManager("show all with labels");
	setTool("polygon");
	
	// Prompt user to draw ROI lines
	waitForUser("Draw your 10 ROI, then press continue");
	
	// Save ROIs drawn
	roiManager("save", roiFiles + imageName + "_roiSet.zip");
	
	// Split RGB Channels
	run("Split Channels");
	
	for (j=0; j<channels.length; j++) {
		selectWindow(title + " (" + channels[j] + ")"); // go to channel window
		roiManager("Show All");
		
		run("Clear Results");
		
		roiManager("Measure");
		saveAs("Results", csvData + File.separator + channels[j] + File.separator + imageName + "_" + channels[j] + ".csv");
		close("Results");
		close("Profiles");
		close();
	}
		
	// Move processed image 
	File.rename(processPath + File.separator + images[i], processedImages + images[i]);
}
close("ROI Manager");
close("Log");
showMessage("Myofibril Graysclae", "Closing the Analysis Macro");
