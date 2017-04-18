DROP PROCEDURE CPI.VALIDATE_BILL_NO;

CREATE OR REPLACE PROCEDURE CPI.validate_bill_no (
   p_prem_seq_no    IN       gipi_invoice.prem_seq_no%TYPE,
   p_iss_cd_param   IN       gipi_polbasic.iss_cd%TYPE,
   p_policy_no      OUT      VARCHAR2,
   p_policy_id      OUT      gipi_polbasic.policy_id%TYPE,
   p_line_cd        OUT      gipi_polbasic.line_cd%TYPE,
   p_subline_cd     OUT      gipi_polbasic.subline_cd%TYPE,
   p_iss_cd         OUT      gipi_polbasic.iss_cd%TYPE,
   p_issue_yy       OUT      gipi_polbasic.issue_yy%TYPE,
   p_pol_seq_no     OUT      gipi_polbasic.pol_seq_no%TYPE,
   p_endt_seq_no    OUT      gipi_polbasic.endt_seq_no%TYPE,
   p_endt_type      OUT      gipi_polbasic.endt_type%TYPE,
   p_pol_flag       OUT      gipi_polbasic.pol_flag%TYPE,
   p_assd_no        OUT      gipi_polbasic.assd_no%TYPE,
   p_ass_name       OUT      giis_assured.assd_name%TYPE,
   p_currency_rt    OUT      gipi_invoice.currency_rt%TYPE,
   p_message        OUT      VARCHAR2,
   p_currency_cd    OUT      gipi_invoice.currency_cd%TYPE
)
IS
   CURSOR invoice_cursor
   IS
      SELECT    RTRIM (b250.line_cd)
             || '-'
             || RTRIM (b250.subline_cd)
             || '-'
             || RTRIM (b250.iss_cd)
             || '-'
             || LTRIM (TO_CHAR (b250.issue_yy, '99'))
             || '-'
             || LTRIM (TO_CHAR (b250.pol_seq_no, '0999999'))
             || DECODE (b250.endt_seq_no,
                        0, NULL,
                           '-'
                        || b250.endt_iss_cd
                        || '-'
                        || LTRIM (TO_CHAR (b250.endt_yy, '09'))
                        || '-'
                        || LTRIM (TO_CHAR (b250.endt_seq_no, '099999'))
                        || ' '
                        || RTRIM (b250.endt_type)
                       )
             || '-'
             || LTRIM (TO_CHAR (b250.renew_no, '09'))
             --Vincent 03242006: added ltrim
             || DECODE (b250.pol_flag,
                        '4', ' (Cancelled Policy)',
                        '5', ' (Spoiled Policy)',
                        NULL
                       ) policy_no,
             b250.policy_id, b250.line_cd, b250.subline_cd, b250.iss_cd,
             b250.issue_yy, b250.pol_seq_no, b250.endt_seq_no,
             b250.endt_type, b250.pol_flag, b250.assd_no, a020.assd_name, b140.currency_rt, b140.currency_cd
        FROM giis_assured a020,
             gipi_parlist b240,
             gipi_polbasic b250,
             gipi_invoice b140
       WHERE NVL (b250.assd_no, b240.assd_no) = a020.assd_no
         AND NVL (b250.endt_type, 'A') = 'A'
         AND b250.par_id = b240.par_id
         AND b140.policy_id = b250.policy_id
         AND b140.iss_cd != 'RI'
         AND b140.prem_seq_no = p_prem_seq_no
         AND b140.iss_cd = p_iss_cd_param;

   v_exists   BOOLEAN := FALSE;
BEGIN
   FOR inv IN invoice_cursor
   LOOP
      IF inv.pol_flag = '5'
      THEN
         p_message := 'This is a spoiled policy.';
      ELSIF inv.pol_flag = '4'
      THEN
         p_message := 'This is a cancelled policy.';
		 
	  ELSE
	  	 p_message := 'Ok';	 
      END IF;
	  
	  p_policy_no := inv.policy_no;
	  p_policy_id := inv.policy_id;
   	  p_line_cd   := inv.line_cd;   
   	  p_subline_cd := inv.subline_cd;   
   	  p_iss_cd    := inv.iss_cd;     
   	  p_issue_yy  := inv.issue_yy;     
   	  p_pol_seq_no := inv.pol_seq_no;     
   	  p_endt_seq_no := inv.endt_seq_no;   
   	  p_endt_type  :=  nvl(inv.endt_type, ' ');   
   	  p_pol_flag   :=  inv.pol_flag;    
   	  p_assd_no    :=  nvl(inv.assd_no, 0);   
	  p_currency_rt := inv.currency_rt; 
   	  p_ass_name   :=  inv.assd_name;    
	  p_currency_cd := inv.currency_cd;   
	    

      v_exists := TRUE;
   END LOOP;

   IF NOT v_exists
   THEN
      p_message := 'This Bill No. is invalid for transaction type ';
   END IF;
END validate_bill_no;
/


