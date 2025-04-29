      *> Simple program to process citizen benefits data
      *> TODO: Add error handling for invalid data formats

       IDENTIFICATION DIVISION.
       PROGRAM-ID. CITIZEN-BATCH. *> Main program name

      *> Define files and data structures
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT INPUT-FILE ASSIGN TO 'citizens.txt' *> Input data file
               ORGANIZATION IS LINE SEQUENTIAL.       *> Read line by line
           SELECT OUTPUT-FILE ASSIGN TO 'report.txt'  *> Output report
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
      *> Format of input records (50 characters per line)
       FD  INPUT-FILE.
       01  INPUT-RECORD              PIC X(50). *> Raw text line

      *> Format of output records (60 characters per line)
       FD  OUTPUT-FILE.
       01  OUTPUT-RECORD             PIC X(60).

       WORKING-STORAGE SECTION.
      *> Split input into these variables
       01  CITIZEN-ID                PIC X(5).  *> First 5 chars: ID
       01  CITIZEN-NAME              PIC X(20). *> Next 20: Name
       01  CITIZEN-DOB               PIC X(10). *> Next 10: Date of Birth
       01  CITIZEN-BENEFIT-AMOUNT    PIC 9(7)V99. *> Numeric value (9999999.99)
       01  WS-BENEFIT-AMOUNT-STR     PIC X(10). *> Temporary string storage

      *> Track total benefits
       01  TOTAL-BENEFITS            PIC 9(9)V99 VALUE 0. *> Start at zero
       01  WS-TOTAL-BENEFITS-STR     PIC Z(7).99. *> For formatted display

      *> Control reading loop
       01  EOF-FLAG                  PIC X VALUE 'N'. *> N=not end, Y=end

       PROCEDURE DIVISION.
       MAIN-LOGIC.
      *> Open files first
           OPEN INPUT INPUT-FILE
           OPEN OUTPUT OUTPUT-FILE

      *> Read until end of file
           PERFORM UNTIL EOF-FLAG = 'Y'
               READ INPUT-FILE
                   AT END
                       MOVE 'Y' TO EOF-FLAG *> Stop after last record
                   NOT AT END
                       PERFORM PROCESS-RECORD
               END-READ
           END-PERFORM

      *> Write total benefits (formatted)
           MOVE SPACES TO OUTPUT-RECORD
           MOVE TOTAL-BENEFITS TO WS-TOTAL-BENEFITS-STR
           STRING
               "TOTAL BENEFITS PAID: £" DELIMITED BY SIZE
               WS-TOTAL-BENEFITS-STR DELIMITED BY SIZE
               INTO OUTPUT-RECORD
           END-STRING
           WRITE OUTPUT-RECORD

      *> Cleanup
           CLOSE INPUT-FILE
           CLOSE OUTPUT-FILE
           STOP RUN.

       PROCESS-RECORD.
      *> Split comma-separated values
           UNSTRING INPUT-RECORD DELIMITED BY ","
               INTO CITIZEN-ID, CITIZEN-NAME, CITIZEN-DOB, WS-BENEFIT-AMOUNT-STR

      *> Convert text to number
           MOVE FUNCTION NUMVAL(WS-BENEFIT-AMOUNT-STR) 
               TO CITIZEN-BENEFIT-AMOUNT

      *> Add to running total
           ADD CITIZEN-BENEFIT-AMOUNT TO TOTAL-BENEFITS

      *> Build output line
           MOVE SPACES TO OUTPUT-RECORD
           STRING
               "Processed: ", CITIZEN-ID, " ",
               CITIZEN-NAME, " £",
               WS-BENEFIT-AMOUNT-STR 
               INTO OUTPUT-RECORD
           END-STRING
           WRITE OUTPUT-RECORD.

