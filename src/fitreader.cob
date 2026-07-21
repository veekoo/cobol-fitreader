       IDENTIFICATION DIVISION.
       PROGRAM-ID. FITREADER.
       AUTHOR. ville.karaila@gmail.com.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
      *>    Maps the programs logical file to an external JCL DD
      *>   name or file path
           SELECT FIT-FILE ASSIGN TO "INPUT.FIT"
               ORGANIZATION IS SEQUENTIAL
               ACCESS MODE IS SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
      *>   File Description (FD) defines the record structure
       FD  FIT-FILE.
       01  FIT-RECORD.
           05  FIT-ID        PIC 9(05).
           05  FIT-NAME      PIC X(20).
           05  FIT-DEPT      PIC X(10).
      *>   Line feed at end of record for display purposes
           05  LINEFEED      PIC X(2).

       WORKING-STORAGE SECTION.
      *>   Variables for end-of-file tracking and display staging
       01  WS-FLAGS.
           05  WS-EOF        PIC X(01) VALUE "N".
               88  END-OF-FILE         VALUE "Y".
               88  NOT-END-OF-FILE     VALUE "N".

       PROCEDURE DIVISION.
       0000-MAIN.
      *>   1. Open file for reading
           OPEN INPUT FIT-FILE.

      *>   2. Fetch the initial record to prime the loop
           PERFORM 1000-READ-RECORD.

      *>   3. Loop until the end-of-file flag is flipped to 'Y'
           PERFORM 2000-PROCESS-RECORD UNTIL END-OF-FILE.

      *>   4. Housekeeping and cleanup
           CLOSE FIT-FILE.
           STOP RUN.

       1000-READ-RECORD.
      *>   Reads the single next record sequentially
           READ FIT-FILE
               AT END
                   SET END-OF-FILE TO TRUE
               NOT AT END
                   SET NOT-END-OF-FILE TO TRUE
           END-READ.

       2000-PROCESS-RECORD.
      *>   Process the record fields currently loaded in the FILE SECTION
           DISPLAY "ID: " FIT-ID " | Name: " FIT-NAME " | Dept: "
               FIT-DEPT.
           
      *>   Read next record to continue or terminate the loop
           PERFORM 1000-READ-RECORD.
