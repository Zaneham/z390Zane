       IDENTIFICATION DIVISION.
       PROGRAM-ID.  TESTOSE1.
      ******************************************************************
      * Test program for COBOL ON SIZE ERROR / NOT ON SIZE ERROR.
      * Tests per FIPS PUB 21-2 Section 6.4.2.
      *
      * Author - Zane Hambly
      * Date   - 2025/12
      ******************************************************************
       ENVIRONMENT DIVISION.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  WS-SMALL      PIC 9(2) VALUE 99.
       01  WS-RESULT     PIC 9(2) VALUE 0.
       01  PASS-COUNT    PIC 9(2) VALUE 0.
       01  FAIL-COUNT    PIC 9(2) VALUE 0.
       01  WS-FLAG       PIC 9    VALUE 0.

       PROCEDURE DIVISION.
       MAIN-PARA.
           DISPLAY 'TESTOSE1 - ON SIZE ERROR TEST'.
      *
      *    Test 1: ADD causes overflow (99+99=198), ON SIZE ERROR
      *
           MOVE 99 TO WS-SMALL.
           MOVE 99 TO WS-RESULT.
           MOVE 0 TO WS-FLAG.
           ADD WS-SMALL TO WS-RESULT
               ON SIZE ERROR
                   MOVE 1 TO WS-FLAG
               NOT ON SIZE ERROR
                   MOVE 2 TO WS-FLAG
           END-ADD.
           DISPLAY 'TEST 1: FLAG = ' WS-FLAG.
           IF WS-FLAG = 1
               DISPLAY 'TEST 1: PASS - ON SIZE ERROR EXECUTED'
               ADD 1 TO PASS-COUNT
           ELSE
               DISPLAY 'TEST 1: FAIL - EXPECTED FLAG=1'
               ADD 1 TO FAIL-COUNT.
      *
      *    Test 2: ADD no overflow (10+0=10), NOT ON SIZE ERROR
      *
           MOVE 10 TO WS-SMALL.
           MOVE 0 TO WS-RESULT.
           MOVE 0 TO WS-FLAG.
           ADD WS-SMALL TO WS-RESULT
               ON SIZE ERROR
                   MOVE 1 TO WS-FLAG
               NOT ON SIZE ERROR
                   MOVE 2 TO WS-FLAG
           END-ADD.
           DISPLAY 'TEST 2: FLAG = ' WS-FLAG ' RESULT = ' WS-RESULT.
           IF WS-FLAG = 2 AND WS-RESULT = 10
               DISPLAY 'TEST 2: PASS - NOT ON SIZE ERROR EXECUTED'
               ADD 1 TO PASS-COUNT
           ELSE
               DISPLAY 'TEST 2: FAIL - EXPECTED FLAG=2 RESULT=10'
               ADD 1 TO FAIL-COUNT.
      *
      *    Summary
      *
           DISPLAY 'TESTOSE1 - COMPLETED'.
           DISPLAY 'PASSED: ' PASS-COUNT ' FAILED: ' FAIL-COUNT.
           IF FAIL-COUNT = 0
               DISPLAY 'TESTOSE1 - ALL TESTS PASSED'
           ELSE
               DISPLAY 'TESTOSE1 - SOME TESTS FAILED'.
           STOP RUN.
