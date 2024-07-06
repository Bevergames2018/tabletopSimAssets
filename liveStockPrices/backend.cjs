const express = require('express');
const fs = require('fs').promises; // Use fs.promises for async file operations
const app = express();
const port = 80;

// Set interval to update currentIndex every x seconds (e.g., every 10 seconds)
const updateIntervalSeconds = 10; // Change this value as needed

// Array of stock files
const stockFiles = [
  "./stocks/AAPL.json",
  "./stocks/AMD.json",
  "./stocks/IBM.json",
  "./stocks/NVDA.json",
  "./stocks/RYAAY.json"
];

let currentIndex = 1; // Initialize currentIndex
let concatenatedValues = ''; // Initialize concatenatedValues globally

// Function to read JSON files and concatenate values
const readJsonFilesAndConcatenate = async () => {
  concatenatedValues = ''; // Reset concatenatedValues

  try {
    for (let i = 0; i < stockFiles.length; i++) {
      const file = stockFiles[i];
      const data = await fs.readFile(file, 'utf8');
      const jsonData = JSON.parse(data);
      
      const result = jsonData.find(item => item.index === currentIndex);
      
      if (result) {
        const openValue = result.Open;
        const roundedValue = parseFloat(openValue).toFixed(2); // Round to 2 decimal places
        concatenatedValues += roundedValue + ' ';
      } else {
        console.log(`Object with index ${currentIndex} not found in ${file}`);
      }
    }
    
    // Increment currentIndex and reset if it exceeds 1258
    currentIndex = (currentIndex % 1258) + 1;
    console.log(`Current index: ${currentIndex}`);
    console.log(`Current concatenated values: ${concatenatedValues}`);
    
  } catch (err) {
    console.error('Error reading files:', err);
  }
};

// Initial read to get currentIndex set
readJsonFilesAndConcatenate();

// Route handler to fetch concatenated values
app.get('/values', (req, res) => {
  res.set('Content-Type', 'text/plain');
  res.send(concatenatedValues.trim()); // Trim to remove trailing space
});

// Set interval to update data every x seconds
setInterval(readJsonFilesAndConcatenate, updateIntervalSeconds * 1000); // Convert seconds to milliseconds

// Start the server
app.listen(port, () => {
  console.log(`Server is running at http://localhost:${port}`);
});
