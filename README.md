# Citizen Benefits Batch Processor

## What This Program Does

This COBOL program reads a text file of citizen records (`citizens.txt`), each containing an ID, name, date of birth, and benefit amount. It processes each record, outputs a summary line for each citizen to `report.txt`, and calculates the total benefits paid across all records.

**Example input line:**
```
ID001,John Smith,1982-07-15,1234.56
```

**Example output line:**
```
Processed: ID001 John Smith           £1234.56
```

At the end of the report, the program prints the total benefits paid.

---

## Issues Faced

- **File Output Error (Status 71):**  
  When first running the program, I encountered a `libcob: error: invalid data in LINE SEQUENTIAL file (status = 71)` for the output file. This was due to writing uninitialized or partially filled records to the output file, which COBOL does not allow in LINE SEQUENTIAL mode.

- **Duplicate/Malformed Records:**  
  At one point, a citizen record was duplicated in the output. This happened because the input file had an extra, malformed line (with missing fields), which the program processed as a valid record.

---

## How I Overcame These Issues

- **Ensured Proper Output Initialization:**  
  I fixed the file output error by always initializing the output record with spaces (`MOVE SPACES TO OUTPUT-RECORD`) before writing to the file. I also reduced the output record length to better fit the actual data, which helped prevent writing unintended characters.

- **Input Data Validation:**  
  I checked and cleaned up the input data file to remove any malformed or empty lines, which resolved the duplicate entry problem. I also learned the importance of validating input data and plan to add more robust checks in future versions.

---

## How to Run

1. **Prepare your input file:**  
   Create a `citizens.txt` file in the same directory as the program, with each line formatted as:  
   `ID,Name,DateOfBirth,BenefitAmount`

2. **Compile the program:**  
   ```
   cobc -free -x -o citizen-batch citizen-batch.cob
   ```

3. **Run the program:**  
   ```
   ./citizen-batch
   ```

4. **Check the output:**  
   The results will be in `report.txt` in the same directory.

---

## Notes

- This project was created as a learning exercise in COBOL and batch data processing.
- Future improvements could include better input validation, error handling, and more detailed reporting.

---

Feel free to adjust or add any personal notes!

---
Answer from Perplexity: pplx.ai/share
