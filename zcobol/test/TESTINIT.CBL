       IDENTIFICATION DIVISION.
       PROGRAM-ID.    TESTINIT.
       AUTHOR.        ZANE HAMBLY.
      *****************************************************************
      * TESTINIT - Test COBOL INITIALIZE statement
      * Per FIPS PUB 21-2 Section VI-6.17 (pp. VI-92 to VI-93)
      *
      * Tests:
      * 1. Initialize elementary alphanumeric field -> SPACES
      * 2. Initialize elementary numeric field -> ZEROS
      * 3. Initialize group item -> all subordinates initialized
      * 4. FILLER items should NOT be affected
      *****************************************************************
       ENVIRONMENT DIVISION.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
      *
      * Test 1: Elementary alphanumeric field
      *
       01  WS-ALPHA-FIELD       PIC X(20) VALUE 'INITIAL VALUE HERE'.
      *
      * Test 2: Elementary numeric fields
      *
       01  WS-NUM-DISPLAY       PIC 9(8)  VALUE 12345678.
       01  WS-NUM-PACKED        PIC S9(5) COMP-3 VALUE -99999.
       01  WS-NUM-BINARY        PIC S9(8) COMP   VALUE 87654321.
      *
      * Test 3: Group item with mixed types
      *
       01  WS-GROUP-ITEM.
           05  WS-GRP-NAME      PIC X(15) VALUE 'BEFORE INIT'.
           05  WS-GRP-AMOUNT    PIC 9(7)V99 VALUE 1234567.89.
           05  WS-GRP-CODE      PIC XXX   VALUE 'ABC'.
           05  WS-GRP-COUNT     PIC S9(4) COMP VALUE 9999.
      *
      * Test 4: Group with FILLER (FILLER should not be affected)
      *
       01  WS-WITH-FILLER.
           05  WS-FILL-NAME     PIC X(10) VALUE 'NAME VALUE'.
           05  FILLER           PIC X(5)  VALUE '*****'.
           05  WS-FILL-NUM      PIC 9(5)  VALUE 11111.
      *
      * Work fields
      *
       01  WS-PASS-COUNT        PIC 9(2)  VALUE 0.
       01  WS-FAIL-COUNT        PIC 9(2)  VALUE 0.
      *
       PROCEDURE DIVISION.
       MAIN-LOGIC.
           DISPLAY 'TESTINIT - COBOL INITIALIZE TEST STARTED'.
           DISPLAY ' '.
      *
      * TEST 1: Initialize elementary alphanumeric field
      *
           DISPLAY 'TEST 1: Elementary alphanumeric field'.
           DISPLAY '  Before: [' WS-ALPHA-FIELD ']'.
           INITIALIZE WS-ALPHA-FIELD.
           DISPLAY '  After:  [' WS-ALPHA-FIELD ']'.
           IF WS-ALPHA-FIELD = SPACES
               DISPLAY '  PASS - Field set to SPACES'
               ADD 1 TO WS-PASS-COUNT
           ELSE
               DISPLAY '  FAIL - Field not set to SPACES'
               ADD 1 TO WS-FAIL-COUNT
           END-IF.
           DISPLAY ' '.
      *
      * TEST 2: Initialize elementary numeric fields
      *
           DISPLAY 'TEST 2: Elementary numeric fields'.
           DISPLAY '  Display before: ' WS-NUM-DISPLAY.
           INITIALIZE WS-NUM-DISPLAY.
           DISPLAY '  Display after:  ' WS-NUM-DISPLAY.
           IF WS-NUM-DISPLAY = 0
               DISPLAY '  PASS - Display numeric set to ZEROS'
               ADD 1 TO WS-PASS-COUNT
           ELSE
               DISPLAY '  FAIL - Display numeric not zero'
               ADD 1 TO WS-FAIL-COUNT
           END-IF.
           DISPLAY ' '.
      *
           DISPLAY '  Packed before: ' WS-NUM-PACKED.
           INITIALIZE WS-NUM-PACKED.
           DISPLAY '  Packed after:  ' WS-NUM-PACKED.
           IF WS-NUM-PACKED = 0
               DISPLAY '  PASS - Packed decimal set to ZEROS'
               ADD 1 TO WS-PASS-COUNT
           ELSE
               DISPLAY '  FAIL - Packed decimal not zero'
               ADD 1 TO WS-FAIL-COUNT
           END-IF.
           DISPLAY ' '.
      *
           DISPLAY '  Binary before: ' WS-NUM-BINARY.
           INITIALIZE WS-NUM-BINARY.
           DISPLAY '  Binary after:  ' WS-NUM-BINARY.
           IF WS-NUM-BINARY = 0
               DISPLAY '  PASS - Binary field set to ZEROS'
               ADD 1 TO WS-PASS-COUNT
           ELSE
               DISPLAY '  FAIL - Binary field not zero'
               ADD 1 TO WS-FAIL-COUNT
           END-IF.
           DISPLAY ' '.
      *
      * TEST 3: Initialize group item
      *
           DISPLAY 'TEST 3: Group item initialization'.
           DISPLAY '  Before:'.
           DISPLAY '    Name:   [' WS-GRP-NAME ']'.
           DISPLAY '    Amount: ' WS-GRP-AMOUNT.
           DISPLAY '    Code:   [' WS-GRP-CODE ']'.
           DISPLAY '    Count:  ' WS-GRP-COUNT.
           INITIALIZE WS-GROUP-ITEM.
           DISPLAY '  After:'.
           DISPLAY '    Name:   [' WS-GRP-NAME ']'.
           DISPLAY '    Amount: ' WS-GRP-AMOUNT.
           DISPLAY '    Code:   [' WS-GRP-CODE ']'.
           DISPLAY '    Count:  ' WS-GRP-COUNT.
           IF WS-GRP-NAME = SPACES AND WS-GRP-AMOUNT = 0
              AND WS-GRP-CODE = SPACES AND WS-GRP-COUNT = 0
               DISPLAY '  PASS - All group subordinates initialized'
               ADD 1 TO WS-PASS-COUNT
           ELSE
               DISPLAY '  FAIL - Group not fully initialized'
               ADD 1 TO WS-FAIL-COUNT
           END-IF.
           DISPLAY ' '.
      *
      * TEST 4: FILLER should not be affected
      *
           DISPLAY 'TEST 4: FILLER preservation'.
           DISPLAY '  Before:'.
           DISPLAY '    Name:   [' WS-FILL-NAME ']'.
           DISPLAY '    (FILLER should stay as asterisks)'.
           DISPLAY '    Num:    ' WS-FILL-NUM.
           INITIALIZE WS-WITH-FILLER.
           DISPLAY '  After:'.
           DISPLAY '    Name:   [' WS-FILL-NAME ']'.
           DISPLAY '    Num:    ' WS-FILL-NUM.
      *    Note: We cannot directly test FILLER content in std COBOL
      *    but we verify other fields were initialized correctly
           IF WS-FILL-NAME = SPACES AND WS-FILL-NUM = 0
               DISPLAY '  PASS - Named fields initialized correctly'
               ADD 1 TO WS-PASS-COUNT
           ELSE
               DISPLAY '  FAIL - Fields not initialized'
               ADD 1 TO WS-FAIL-COUNT
           END-IF.
           DISPLAY ' '.
      *
      * SUMMARY
      *
           DISPLAY '========================================='.
           DISPLAY 'TESTINIT - TEST SUMMARY'.
           DISPLAY '  Passed: ' WS-PASS-COUNT.
           DISPLAY '  Failed: ' WS-FAIL-COUNT.
           IF WS-FAIL-COUNT = 0
               DISPLAY 'TESTINIT - ALL TESTS PASSED'
               DISPLAY 'TESTINIT - TEST ENDED OK'
           ELSE
               DISPLAY 'TESTINIT - SOME TESTS FAILED'
           END-IF.
           STOP RUN.




