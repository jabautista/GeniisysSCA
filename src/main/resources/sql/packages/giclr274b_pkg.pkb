CREATE OR REPLACE PACKAGE BODY CPI.giclr274b_pkg
AS
/*
** Created By: Bonok
** Date Created: 05.20.2013
** Reference By: GICLR274A
** Description: CLAIM LISTING PER PACKAGE POLICY
*/
   FUNCTION get_giclr274b_detail(
      p_line_cd             gipi_pack_polbasic.line_cd%TYPE,
      p_subline_cd          gipi_pack_polbasic.subline_cd%TYPE,
      p_pol_iss_cd          gicl_claims.pol_iss_cd%TYPE,
      p_issue_yy            gipi_pack_polbasic.issue_yy%TYPE,
      p_pol_seq_no          gipi_pack_polbasic.pol_seq_no%TYPE,
      p_renew_no            gipi_pack_polbasic.renew_no%TYPE,      
      p_from_date           VARCHAR2,
      p_to_date             VARCHAR2,
      p_as_of_date          VARCHAR2,
      p_from_ldate          VARCHAR2,
      p_to_ldate            VARCHAR2,
      p_as_of_ldate         VARCHAR2
   ) RETURN giclr274b_detail_tab PIPELINED IS
      res                   giclr274b_detail_type;                
   BEGIN
      FOR i IN (SELECT d.line_cd||'-'||d.subline_cd||'-'||d.iss_cd||'-'||ltrim(to_char(d.issue_yy,'09'))||'-'||ltrim(to_char(d.pol_seq_no,'0999999'))
                       ||'-'||ltrim(to_char(d.renew_no,'09')) package_policy_no,
                       a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||trim(TO_CHAR(a.clm_yy,'09'))||'-'||trim(TO_CHAR(a.clm_seq_no,'0000009')) claim_no,
                       a.line_cd||'-'||a.subline_cd||'-'||a.pol_iss_cd||'-'||trim(TO_CHAR(a.issue_yy,'09')) || '-' ||trim(TO_CHAR(a.pol_seq_no,'0000009')) 
                       || '-'||LTRIM(TO_CHAR(a.renew_no,'09')) policy_no, 
                       a.dsp_loss_date, a.assured_name, 
                       b.line_cd||'-'||b.iss_cd||'-'||SUBSTR(TO_CHAR(b.rec_year,'0009'),4)||'-'||trim(TO_CHAR(b.rec_seq_no,'0000009')) rec_no, 
                       b.cancel_tag, b.rec_type_cd, b.recoverable_amt, b.recovered_amt, b.lawyer_cd, c.payor_cd, c.payor_class_cd, c.recovered_amt payr_rec_amt
                  FROM gicl_claims a, gicl_clm_recovery b, gicl_recovery_payor c, gipi_pack_polbasic d         
                 WHERE a.pack_policy_id = d.pack_policy_id
                   AND d.line_cd = UPPER(p_line_cd)
                   AND d.subline_cd = UPPER(p_subline_cd)
                   AND a.pol_iss_cd = UPPER(p_pol_iss_cd)
                   AND d.issue_yy = p_issue_yy
                   AND d.pol_seq_no = p_pol_seq_no
                   AND d.renew_no = p_renew_no   
                   AND a.claim_id = b.claim_id
                   AND b.claim_id = c.claim_id 
                   AND b.recovery_id = c.recovery_id
                   AND check_user_per_line(d.line_cd,d.iss_cd,'GICLS274') = 1
                   AND ((TRUNC(a.clm_file_date) >= TO_DATE(p_from_date, 'mm-dd-yyyy')
                         AND TRUNC(a.clm_file_date) <= TO_DATE(p_to_date, 'mm-dd-yyyy')
                          OR TRUNC(a.clm_file_date) <= TO_DATE(p_as_of_date, 'mm-dd-yyyy'))
                         OR (TRUNC(a.loss_date) >= TO_DATE(p_from_ldate, 'mm-dd-yyyy')
                             AND TRUNC(a.loss_date) <= TO_DATE(p_to_ldate, 'mm-dd-yyyy')
                              OR TRUNC(a.loss_date) <= TO_DATE(p_as_of_ldate, 'mm-dd-yyyy'))))
      LOOP
         res.package_policy_no := i.package_policy_no; 
         res.claim_no          := i.claim_no;
         res.policy_no         := i.policy_no;
         res.dsp_loss_date     := i.dsp_loss_date;
         res.assured_name      := i.assured_name;
         res.rec_no            := i.rec_no;
         res.cancel_tag        := i.cancel_tag;
         res.rec_type_cd       := i.rec_type_cd;
         res.recoverable_amt   := i.recoverable_amt;
         res.recovered_amt     := i.recovered_amt;
         res.lawyer_cd         := i.lawyer_cd;
         res.payor_cd          := i.payor_cd;
         res.payor_class_cd    := i.payor_class_cd;
         res.payr_rec_amt      := i.payr_rec_amt;
         
         FOR rec IN (SELECT rec_type_desc
                       FROM giis_recovery_type
                      WHERE rec_type_cd = i.rec_type_cd)
         LOOP
            res.rec_type_desc  := rec.rec_type_desc; 
         END LOOP;
         
         IF i.cancel_tag = 'CD' THEN
  	        res.rec_stat := 'Closed';
         ELSIF i.cancel_tag = 'CC' THEN
  	        res.rec_stat := 'Cancelled';
         ELSIF i.cancel_tag = 'WO' THEN
  	        res.rec_stat := 'Written Off';
         ELSE
  	        res.rec_stat := 'In Progress';
         END IF;
         
         FOR pay IN (SELECT payee_last_name||DECODE(payee_first_name,NULL,'',', ')||
                            payee_first_name||DECODE(payee_middle_name,NULL,'',' ')||
                            payee_middle_name pname
                       FROM giis_payees
                      WHERE payee_no = i.payor_cd
                        AND payee_class_cd = i.payor_class_cd)
         LOOP
  	        res.payor := pay.pname;
         END LOOP;
         
         res.company_name      := giisp.v('COMPANY_NAME');
         res.company_address   := giisp.v('COMPANY_ADDRESS');
         
         BEGIN
              IF p_as_of_date IS NOT NULL THEN
               res.date_type := 'Claim File Date As of '||TO_CHAR(TO_DATE(p_as_of_date, 'mm-dd-yyyy'), 'fmMonth DD, RRRR');
            ELSIF p_from_date IS NOT NULL AND p_to_date IS NOT NULL THEN
               res.date_type := 'Claim File Date From '||TO_CHAR(TO_DATE(p_from_date, 'mm-dd-yyyy'), 'fmMonth DD, RRRR')||' To '||TO_CHAR(TO_DATE(p_to_date, 'mm-dd-yyyy'), 'fmMonth DD, RRRR');
            ELSIF p_as_of_ldate IS NOT NULL THEN    
               res.date_type := 'Loss Date As of '||TO_CHAR(TO_DATE(p_as_of_ldate, 'mm-dd-yyyy'), 'fmMonth DD, RRRR');
            ELSIF p_from_ldate IS NOT NULL AND p_to_ldate IS NOT NULL THEN
               res.date_type := 'Loss Date From '||TO_CHAR(TO_DATE(p_from_ldate, 'mm-dd-yyyy'), 'fmMonth DD, RRRR')||' To '||TO_CHAR(TO_DATE(p_to_ldate, 'mm-dd-yyyy'), 'fmMonth DD, RRRR');
            END IF;
         END;
         
         PIPE ROW(res);
      END LOOP;
   END;
END giclr274b_pkg;
/


