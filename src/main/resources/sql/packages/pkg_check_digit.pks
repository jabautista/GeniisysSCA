CREATE OR REPLACE PACKAGE CPI.pkg_check_digit
AS
   /***************************************************
   Description: Check digit generator 
        ACCT_ISS_CD - 2 digits
        PREM_SEQ_NO - 8 digits  
        DUE_DATE (MMDD) - 4 digits
        Check Digit - 2 digits 
        Input: Bill Number (ISS_CD-PREM_SEQ_NO)
        
    for 1st digit     
        1. Starting right, double numbers that are positioned in even numbers (e.g 2nd , 4th, 6th...)          
    for 2nd digit 
        1. Starting right, double numbers that are positioned in odd numbers (e.g 1st, 3rd, 5th...)    
    basic flow    
        2. Add the digits together if the doubling gives you a two digit number.
        3. Now add the doubled digits with the digits that were not doubled.
        4. Divide the sum by 10 and check if the remainder is zero. If the remainder is zero then that is the check digit. If the number is not zero, then subtract the remainder from 10. The resulting number will be the check digit.
    
   Programmer    -     Edward Barroso
   Date Started  -    Jul 22 2014
   Date Finished -      
   *****************************************************/
   v_bill_num        VARCHAR2(20);
   v_check_digit     NUMBER;
   --digit parts
   v_acct_iss_cd   GIIS_ISSOURCE.iss_cd%TYPE;
   v_prem_seq_no   VARCHAR2(8);
   v_due_date      VARCHAR2(4);   
   v_build         VARCHAR2(16);
   --digit definitions
   v_substr_acct   VARCHAR2(20):= '^[[:alnum:]]{2}';   
   v_substr_prem   VARCHAR2(20):=  '[0-9]{8}$';
   v_tochar_due    VARCHAR2(20):=  'MMDD';    
   v_acct_iss_pad  NUMBER      :=   2;
   v_acct_char_pad VARCHAR2(1) :=  '0';
   -- giis paramters
   v_param_name  GIIS_PARAMETERS.param_name%TYPE :='GENERATE_REF_INV_NO';           
   /**********************************************************/
   FUNCTION get_acct_iss_cd( p_iss_cd  GIIS_ISSOURCE.iss_cd%TYPE )  
   RETURN   GIIS_ISSOURCE.acct_iss_cd%TYPE;
   FUNCTION generate_indv(p_bill_num VARCHAR2, p_type NUMBER )
   RETURN   VARCHAR2;
   FUNCTION  generate(p_iss_cd GIPI_INVOICE.iss_cd%TYPE, p_prem_seqno GIPI_INVOICE.prem_seq_no%TYPE , p_due_date GIPI_INVOICE.due_date%TYPE DEFAULT NULL  )
   RETURN   VARCHAR2;
   FUNCTION build(p_bill_num VARCHAR2 DEFAULT NULL) 
   RETURN   VARCHAR2;
   --check_digit_algorithm
   v_multiplier         NUMBER  DEFAULT 2;
   v_divisor            NUMBER  DEFAULT 10;
   v_digit_process      BOOLEAN DEFAULT TRUE;
   PROCEDURE cd_algorithm(p_build VARCHAR2 DEFAULT NULL, p_type NUMBER DEFAULT 1);   
   FUNCTION  get_giis_parameter RETURN VARCHAR2;
END;
/


