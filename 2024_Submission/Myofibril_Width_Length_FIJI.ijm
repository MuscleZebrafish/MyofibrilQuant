// SarcomereManualMeasurement.ijm
// by Emily Tomak Via Joy-el Talbot SarcQuant 1.1
// Version 1.1
// Updated 2023-04-28

/* Purpose: allows for efficient measurement of various components of myofibrils.
*/

// Starting message
showMessage("Sarcomere Manual Measure", "Welcome to the Sarcomere Manual Measure macro.\n\nPlease start by choosing the folder containing *.tif images to process.\n\n\nVersion 1.1, updated 2023-04-28.");

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
if (!File.isDirectory(roiFiles)) {
	File.makeDirectory(roiFiles);	
}

csvData = processPath + File.separator + "csvData" + File.separator;
if (!File.isDirectory(csvData)) {
	File.makeDirectory(csvData);
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
	run("Line Width...", "line=5"); // line thickness for this analysis
	setTool("line");
	
	// Prompt user to draw ROI lines
	waitForUser("Draw at least 30 ROI lines along the myofibril component (Sarcomere Length, 	Myofibril Width) you would like to measure, then press continue.\n\nMeasure consistently from 1-2 somites.");
	
	// Save ROIs drawn
	roiManager("save", roiFiles + imageName + "_roiSet.zip");
	
	
	// go to channel window
		roiManager("Show All");
		
		run("Clear Results");
		
		roiManager("measure");
		run("Set Measurements...", "decimal=4"); // set number of decimal places to show
		
	//waitForUser("Review plot and results");
		saveAs("WidthResults", csvData + File.separator + File.separator + imageName + 			".csv");
		close("Results");
		close("Profiles");
		close();
		
	// Move processed image 
	File.rename(processPath + File.separator + images[i], processedImages + images[i]);
}
close("ROI Manager");
close("Log");
showMessage("SarcomereManualMeasure", "Closing the Analysis Macro");
