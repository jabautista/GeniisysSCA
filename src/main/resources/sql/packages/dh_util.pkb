CREATE OR REPLACE PACKAGE BODY CPI.Dh_Util AS
  result   VARCHAR2(2000);
  working_integer        NUMBER;
  working_decimal        VARCHAR2(100);
  working_dec_mag        NUMBER;
  working_integer_spell  VARCHAR2(2000);
  working_decimal_spell  VARCHAR2(2000);
  working_fraction_spell VARCHAR2(2000);
  TYPE number_stencil IS TABLE OF NUMBER
       INDEX BY BINARY_INTEGER;
  TYPE varchar2_stencil IS TABLE OF VARCHAR2(2000)
       INDEX BY BINARY_INTEGER;
  denom varchar2_stencil;
  pad_factor number_stencil;
  hold varchar2_stencil;
--  **************************************************************
--  Packaged Global Function Definition: DH_UTIL.SPELL
--  **************************************************************
FUNCTION spell (x IN NUMBER) RETURN VARCHAR2 IS
--  **************************************************************
--  Local Function Specification: WORDING
--  **************************************************************
  FUNCTION wording (x IN NUMBER) RETURN VARCHAR2 IS
  BEGIN
     IF x = 0 THEN
          RETURN NULL;
--
-- Commented by MMDEGUZMAN to remove the spelled word "ZERO CENTAVOS"
--        return 'Zero';
--
-- Created Dt : 2/4/1999
--
     ELSE
        RETURN TO_CHAR(TO_DATE(x,'J'),'JSP'); -- Numbers-to-words
     END IF;
  END wording;
--  **************************************************************
--  Local Function Specification: INTEGER_TRANSLATION
--  **************************************************************
  FUNCTION integer_translation (working_x IN NUMBER)
           RETURN VARCHAR2 IS
     x_char VARCHAR2(128);
     denoms_to_do NUMBER;
     start_byte   NUMBER;
     pointer      BINARY_INTEGER;
     interim_spelling VARCHAR2(2000);
  BEGIN
     IF working_x IS NULL THEN
        RETURN 'NULL';
     ELSIF working_x = 0 THEN
        RETURN NULL;
     END IF;
     x_char := ABS(working_x);
     pointer := 3-MOD(LENGTH(x_char),3);
     x_char := LPAD(x_char,LENGTH(x_char)+pad_factor(pointer),'0');
     denoms_to_do := LENGTH(x_char)/3;
     result := NULL;
     FOR i IN 1..denoms_to_do LOOP
         start_byte := ((i-1)*3)+1;
         interim_spelling := wording(SUBSTR(x_char,start_byte,3));
         pointer := (denoms_to_do+1)-i;
         IF UPPER(interim_spelling) <> 'ZERO' THEN
            result := RTRIM(LTRIM(result||' '||interim_spelling||
               ' '||denom(pointer)));
         END IF;
         hold(i) := result;
     END LOOP;
     RETURN result;
  END integer_translation;
--  **************************************************************
--  Global Function SPELL Procedural Section
--  **************************************************************
BEGIN
  working_integer_spell := NULL;
  working_decimal_spell := NULL;
  working_fraction_spell := NULL;
  working_integer := TRUNC(x);
  IF ABS(x) > ABS(working_integer) THEN
     working_decimal :=
       SUBSTR(RTRIM(TO_CHAR(ABS(x)-ABS(working_integer),
       '.00000000000000000000000000000000000000000'),
       '0'),3);
  ELSE
     working_decimal := NULL;
     working_dec_mag := NULL;
  END IF;
  working_integer_spell := integer_translation(working_integer);
  IF working_decimal IS NOT NULL THEN
     working_dec_mag := 10 ** LENGTH(working_decimal);
     working_decimal_spell :=
        ' AND '||integer_translation(working_decimal);
     working_fraction_spell :=
        integer_translation(working_dec_mag)||'TH';
     IF working_decimal > 1 THEN
        working_fraction_spell := working_fraction_spell||'S';
     END IF;
     IF UPPER(SUBSTR(working_fraction_spell,1,3))='ONE' THEN
        working_fraction_spell := SUBSTR(working_fraction_spell,5);
     END IF;
     working_fraction_spell := ' / '||working_fraction_spell;
  END IF;
  IF working_integer = 0 AND working_decimal_spell IS NOT NULL THEN
     result := SUBSTR(working_decimal_spell,5)||
        working_fraction_spell;
  ELSE
     result := working_integer_spell||
        working_decimal_spell||working_fraction_spell;
  END IF;
  IF x < 0 THEN
     result := 'NEGATIVE '||result;
  END IF;
  result := REPLACE(result,'  ',' ');
  RETURN result;
END spell;
--  **************************************************************
--  End of Global Function: SPELL
--  **************************************************************
--  **************************************************************
--  Global Function Specification: CHECK_PROTECT
--  **************************************************************
--
-- Modified by: The Saint Michael to fit Lepanto's needs.
-- Modified dt: 02 February 1999
--  Added the parameter print_DV, if TRUE then use DV options.
--
FUNCTION check_protect (x IN NUMBER, currency IN VARCHAR2, print_dv IN BOOLEAN)
RETURN VARCHAR2 IS

   hold_peso NUMBER;
   hold_centavos  NUMBER;
   FUNCTION check_for_single (y IN NUMBER, currency IN VARCHAR2)
      RETURN VARCHAR2 IS
   BEGIN
      IF y = 1 THEN
         RETURN 'ONE '||currency;
      ELSE
         RETURN spell(y) ||' '||currency;
      END IF;
   END;
BEGIN
   IF x IS NULL THEN
      RETURN 'NON NEGOTIABLE';
   END IF;
   hold_peso := TRUNC(x);
   hold_centavos  := (ABS(x) - TRUNC(ABS(x)))*100;
   --
   -- Commented by MMDEGUZMAN to handle "ZERO CENTAVOS" and
   -- to provide the needs of FLT...
   --
   -- Create Dt : 2/4/1999
   --
  IF print_dv THEN
    IF hold_centavos > 0 THEN
      RETURN check_for_single(hold_peso, NULL)||
             ' AND '||TO_CHAR(hold_centavos, '09')||'/100';
    ELSE
      RETURN check_for_single(hold_peso, NULL);
    END IF;
  ELSE
    IF hold_centavos > 0 THEN
      IF hold_peso = 1 THEN
        RETURN check_for_single(hold_peso,currency)||' AND '||hold_centavos||'/100';
               --CHECK_FOR_SINGLE(HOLD_CENTAVOS,'centavo');
      ELSE
        RETURN check_for_single(hold_peso,currency)||' AND '||hold_centavos||'/100';
               --CHECK_FOR_SINGLE(HOLD_CENTAVOS,'centavos');
      END IF;
    ELSE
      IF hold_peso = 1 THEN
        RETURN check_for_single(hold_peso,currency);
      ELSE
        RETURN check_for_single(hold_peso,currency);
      END IF;
    END IF;
  END IF;
END check_protect;
FUNCTION check_protect2 (x IN NUMBER, currency IN VARCHAR2, print_dv IN BOOLEAN)
RETURN VARCHAR2 IS

   hold_peso NUMBER;
   hold_centavos  NUMBER;
   FUNCTION check_for_single (y IN NUMBER, currency IN VARCHAR2)
      RETURN VARCHAR2 IS
   BEGIN
      IF y = 1 THEN
         RETURN 'ONE '||currency;
      ELSE
         RETURN spell(y) ||' '||currency;
      END IF;
   END;
BEGIN
   IF x IS NULL THEN
      RETURN 'NON NEGOTIABLE';
   END IF;
   hold_peso := TRUNC(x);
   hold_centavos  := (ABS(x) - TRUNC(ABS(x)))*100;
   --
   -- Commented by MMDEGUZMAN to handle "ZERO CENTAVOS" and
   -- to provide the needs of FLT...
   --
   -- Create Dt : 2/4/1999
   --
  IF print_dv THEN
    IF hold_centavos > 0 THEN
      RETURN check_for_single(hold_peso, NULL)||
             ' AND '||TO_CHAR(hold_centavos,'09')||'/100';
    ELSE
      RETURN check_for_single(hold_peso, NULL);
    END IF;
  ELSE
    IF hold_centavos > 0 THEN
      IF hold_peso = 1 THEN
        RETURN check_for_single(hold_peso,currency)||' AND '||hold_centavos||'/100';
               --CHECK_FOR_SINGLE(HOLD_CENTAVOS,'centavo');
      ELSE
        RETURN check_for_single(hold_peso,currency)||' AND '||hold_centavos||'/100';
               --CHECK_FOR_SINGLE(HOLD_CENTAVOS,'centavos');
      END IF;
    ELSE
      IF hold_peso = 1 THEN
        RETURN check_for_single(hold_peso,currency);
      ELSE
        RETURN check_for_single(hold_peso,currency);
      END IF;
    END IF;
  END IF;
END check_protect2;
--  **************************************************************
--  "FIRST-TIME-ONLY" PACKAGE INITIALIZATION ACTIVITIES
--  **************************************************************
BEGIN
   pad_factor(1) := 1;
   pad_factor(2) := 2;
   pad_factor(3) := 0;
   denom(1) := NULL;
   denom(2) := 'THOUSAND';
   denom(3) := 'MILLION';
   denom(4) := 'BILLION';
   denom(5) := 'TRILLION';
   denom(6) := 'QUADRILLION';
   denom(7) := 'QUINTILLION';
   denom(8) := 'SEXTILLION';
   denom(9) := 'SEPTILLION';
   denom(10) := 'OCTILLION';
   denom(11) := 'NONILLION';
   denom(12) := 'DECILLION';
   denom(13) := 'UNDECILLION';
   denom(14) := 'DUODECILLION';
   denom(15) := 'TREDECILLION';
   denom(16) := 'QUATTUORDECILLION';
   denom(17) := 'QUINDECILLION';
   denom(18) := 'SEXDECILLION';
   denom(19) := 'SEPTENDECILLION';
   denom(20) := 'OCTODECILLION';
   denom(21) := 'NOVEMDECILLION';
   denom(22) := 'VIGINTILLION';
   denom(23) := 'UNVIGINTILLION';
   denom(24) := 'DUOVIGINTILLION';
   denom(25) := 'TREVIGINTILLION';
   denom(26) := 'QUATTUORVIGINTILLION';
   denom(27) := 'QUINVIGINTILLION';
   denom(28) := 'SEXVIGINTILLION';
   denom(29) := 'SEPTENVIGINTILLION';
   denom(30) := 'OCTOVIGINTILLION';
   denom(31) := 'NOVEMVIGINTILLION';
   denom(32) := 'TREGINTILLION';
   denom(33) := 'UNTREGINTILLION';
   denom(34) := 'DUOTREGINTILLION';
END Dh_Util;
--  **************************************************************
--  END OF GLOBAL FUNCTION: SPELL
--  **************************************************************
/


