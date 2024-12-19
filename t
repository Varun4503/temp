import React, { useState } from "react";
import Papa from "papaparse";

function App() {
  const [CSVdata, setCSVdata] = useState([]);
  const [error, setError] = useState("");
  const [fileName, setFileName] = useState("");

  const handleFileSelect = (event) => {
    const file = event.target.files[0];
    if (!file) {
      setError("No file selected.");
      return;
    }

    setFileName(file.name);

    // Validate file type
    if (!file.name.endsWith(".csv")) {
      setError("Please select a valid CSV file.");
      setCSVdata([]);
      return;
    }

    setError("");

    // Read and parse the file
    const reader = new FileReader();
    reader.onload = (e) => {
      const csvText = e.target.result;

      // Parse the CSV
      const parsedData = Papa.parse(csvText, {
        header: true,
        skipEmptyLines: true,
      });

      if (parsedData.errors.length > 0) {
        setError("Failed to parse CSV data.");
        setCSVdata([]);
        return;
      }

      setCSVdata(parsedData.data);
    };

    reader.onerror = () => {
      setError("Error reading the file.");
      setCSVdata([]);
    };

    reader.readAsText(file);
  };

  return (
    <div>
      <h1>CSV Viewer</h1>
      <div>
        <input type="file" onChange={handleFileSelect} />
      </div>
      {fileName && <p>Selected file: {fileName}</p>}
      {error && <p>{error}</p>}
      <div>
        {CSVdata.length > 0 && (
          <table border="1" style={{borderCollapse:"collapse", width:"50%"}}>
            <thead>
              <tr>
                {Object.keys(CSVdata[0]).map((key, index) => (
                  <th key={index}>{key}</th>
                ))}
              </tr>
            </thead>
            <tbody>
              {CSVdata.map((row, rowIndex) => (
                <tr key={rowIndex}>
                  {Object.values(row).map((value, colIndex) => (
                    <td key={colIndex}>{value}</td>
                  ))}
                </tr>
              ))}
            </tbody>
          </table>
        )}
      </div>
    </div>
  );
}

export default App;
