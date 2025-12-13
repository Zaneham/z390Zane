       IDENTIFICATION DIVISION.
       PROGRAM-ID.  TESTRND1.
      ******************************************************************
      * Test program for COBOL ROUNDED phrase.
      * Tests ROUNDED on ADD per FIPS PUB 21-2 Section 6.4.1.
      *
      * Author - Zane Hambly
      * Date   - 2025/12
      ******************************************************************
       ENVIRONMENT DIVISION.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  WS-NUM1       PIC 9(5)V99 VALUE 123.45.
       01  WS-NUM2       PIC 9(5)V99 VALUE 67.89.
       01  WS-RESULT     PIC 9(5)V9  VALUE 0.
       01  PASS-COUNT    PIC 9(2)    VALUE 0.
       01  FAIL-COUNT    PIC 9(2)    VALUE 0.

       PROCEDURE DIVISION.
       MAIN-PARA.
           DISPLAY 'TESTRND1 - ROUNDED CLAUSE TEST'.
      *
      *    Test 1: ADD with ROUNDED - 100.55 rounds up to 100.6
      *            (digit after truncation point is 5, so round up)
      *
           MOVE 100.55 TO WS-NUM1.
           MOVE 0 TO WS-RESULT.
           ADD WS-NUM1 TO WS-RESULT ROUNDED.
           DISPLAY 'TEST 1: ADD ROUNDED = ' WS-RESULT.
           IF WS-RESULT = 100.6
               DISPLAY 'TEST 1: PASS'
               ADD 1 TO PASS-COUNT
           ELSE
               DISPLAY 'TEST 1: FAIL - EXPECTED 100.6'
               ADD 1 TO FAIL-COUNT.
      *
      *    Test 2: ADD without ROUNDED - 100.55 truncates to 100.5
      *
           MOVE 100.55 TO WS-NUM1.
           MOVE 0 TO WS-RESULT.
           ADD WS-NUM1 TO WS-RESULT.
           DISPLAY 'TEST 2: ADD NO ROUND = ' WS-RESULT.
           IF WS-RESULT = 100.5
               DISPLAY 'TEST 2: PASS'
               ADD 1 TO PASS-COUNT
           ELSE
               DISPLAY 'TEST 2: FAIL - EXPECTED 100.5'
               ADD 1 TO FAIL-COUNT.
      *
      *    Test 3: ADD with ROUNDED - 100.34 rounds down to 100.3
      *            (digit after truncation point is 4, so truncate)
      *
           MOVE 100.34 TO WS-NUM1.
           MOVE 0 TO WS-RESULT.
           ADD WS-NUM1 TO WS-RESULT ROUNDED.
           DISPLAY 'TEST 3: ADD ROUNDED = ' WS-RESULT.
           IF WS-RESULT = 100.3
               DISPLAY 'TEST 3: PASS'
               ADD 1 TO PASS-COUNT
           ELSE
               DISPLAY 'TEST 3: FAIL - EXPECTED 100.3'
               ADD 1 TO FAIL-COUNT.
      *
      *    Summary
      *
           DISPLAY 'TESTRND1 - COMPLETED'.
           DISPLAY 'PASSED: ' PASS-COUNT ' FAILED: ' FAIL-COUNT.
           IF FAIL-COUNT = 0
               DISPLAY 'TESTRND1 - ALL TESTS PASSED'
           ELSE
               DISPLAY 'TESTRND1 - SOME TESTS FAILED'.
           STOP RUN.
