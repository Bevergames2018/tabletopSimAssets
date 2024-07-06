const fs = require('fs');
const csv = require('csvtojson');

const csvFilePath = 'RYAAY.csv';
const jsonFilePath = 'RYAAY.json';

// Initialize an empty array to store JSON objects
let jsonData = [];

csv()
  .fromFile(csvFilePath)
  .then((csvData) => {
    csvData.forEach((row, index) => {
      // Remove the Date field from the row
      const date = row['Date'];
      delete row['Date'];
      delete row['High'];
      delete row['Low'];
      delete row['Close'];
      delete row['Adj Close'];
      delete row['Volume'];

      // Create a new object with index as key and remaining row data
      const indexedRow = {
        index: index + 1, // Adding 1 to start index from 1
        ...row,
      };

      // Add the indexed row object to jsonData array
      jsonData.push(indexedRow);
    });

    const jsonString = JSON.stringify(jsonData, null, 2);
    fs.writeFileSync(jsonFilePath, jsonString);
    console.log(`Conversion complete. JSON saved to ${jsonFilePath}`);
  })
  .catch((err) => {
    console.error('Error converting CSV to JSON:', err);
  });
