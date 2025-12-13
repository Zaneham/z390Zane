       IDENTIFICATION DIVISION.
       PROGRAM-ID.  TESTOSE2.
      ******************************************************************
      * Test program for SUBTRACT ON SIZE ERROR / NOT ON SIZE ERROR.
      * Tests per FIPS PUB 21-2 Section 6.4.2.
      *
      * Author - Zane Hambly
      * Date   - 2025/12
      ******************************************************************
       ENVIRONMENT DIVISION.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  WS-SMALL       PIC 9(2)    VALUE 0.
       01  WS-RESULT      PIC 9(2)    VALUE 0.
       01  PASS-COUNT     PIC 9(2)    VALUE 0.
       01  FAIL-COUNT     PIC 9(2)    VALUE 0.
       01  WS-FLAG        PIC 9       VALUE 0.

       PROCEDURE DIVISION.
       MAIN-PARA.
           DISPLAY 'TESTOSE2 - SUBTRACT ON SIZE ERROR TEST'.
      *
      *    Test 1: Underflow causing large magnitude
      *            50 - 150 = -100, but PIC 9(2) can't hold -100
      *
           MOVE 50 TO WS-RESULT.
           MOVE 99 TO WS-SMALL.
           SUBTRACT WS-SMALL FROM WS-RESULT ON SIZE ERROR
               MOVE 1 TO WS-FLAG
           NOT ON SIZE ERROR
               MOVE 2 TO WS-FLAG
           END-SUBTRACT.
           DISPLAY 'TEST 1: FLAG = ' WS-FLAG.
           IF WS-FLAG = 1
               DISPLAY 'TEST 1: PASS - ON SIZE ERROR EXECUTED'
               ADD 1 TO PASS-COUNT
           ELSE
               DISPLAY 'TEST 1: FAIL - EXPECTED FLAG=1'
               ADD 1 TO FAIL-COUNT.
      *
      *    Test 2: No underflow - 50 - 10 = 40
      *            40 fits in PIC 9(2), so NOT ON SIZE ERROR
      *
           MOVE 50 TO WS-RESULT.
           MOVE 10 TO WS-SMALL.
           MOVE 0 TO WS-FLAG.
           SUBTRACT WS-SMALL FROM WS-RESULT ON SIZE ERROR
               MOVE 1 TO WS-FLAG
           NOT ON SIZE ERROR
               MOVE 2 TO WS-FLAG
           END-SUBTRACT.
           DISPLAY 'TEST 2: FLAG = ' WS-FLAG ' RESULT = ' WS-RESULT.
           IF WS-FLAG = 2 AND WS-RESULT = 40
               DISPLAY 'TEST 2: PASS - NOT ON SIZE ERROR EXECUTED'
               ADD 1 TO PASS-COUNT
           ELSE
               DISPLAY 'TEST 2: FAIL - EXPECTED FLAG=2 RESULT=40'
               ADD 1 TO FAIL-COUNT.
      *
      *    Summary
      *
           DISPLAY 'TESTOSE2 - COMPLETED'.
           DISPLAY 'PASSED: ' PASS-COUNT ' FAILED: ' FAIL-COUNT.
           IF FAIL-COUNT = 0
               DISPLAY 'TESTOSE2 - ALL TESTS PASSED'
           ELSE
               DISPLAY 'TESTOSE2 - SOME TESTS FAILED'.
           STOP RUN.
