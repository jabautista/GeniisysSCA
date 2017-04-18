CREATE OR REPLACE PACKAGE BODY CPI.GIEXR101A_PKG
AS
/**
* Rey Jadlocon
* 02.08.2012
**/
FUNCTION get_details(P_POLICY_ID                GIEX_EXPIRIES_V.policy_id%TYPE,
                     P_ASSD_NO                  GIEX_EXPIRIES_V.assd_no%TYPE,
                     P_INTM_NO                  GIEX_EXPIRIES_V.intm_no%TYPE,
                     P_ISS_CD                   GIEX_EXPIRIES_V.iss_cd%TYPE,
                     P_SUBLINE_CD               GIEX_EXPIRIES_V.subline_cd%TYPE,
                     P_LINE_CD                  GIEX_EXPIRIES_V.line_cd%TYPE,
                     P_ENDING_DATE              VARCHAR2,
                     P_STARTING_DATE            VARCHAR2,
                     p_include_pack             VARCHAR2,
                     p_claims_flag              VARCHAR2,
                     p_balance_flag             VARCHAR2)
      RETURN get_details_tab PIPELINED
      IS
            details get_details_type;
            p_cf_item_desc      VARCHAR2(32767); -- bonok :: 8.3.2015 :: UCPB SR 20009
  BEGIN
         FOR i IN(SELECT B.ISS_CD,
                         B.LINE_CD,
                         B.SUBLINE_CD,
                         B.ISSUE_YY,
                         B.POL_SEQ_NO,       
                         B.RENEW_NO,
                         B.ISS_CD ISS_CD2,
                         B.LINE_CD LINE_CD2,
                         B.SUBLINE_CD SUBLINE_CD2,       
                         B.LINE_CD||'-'||
                            RTRIM(B.SUBLINE_CD)||'-'||
                            RTRIM(B.ISS_CD)||'-'||
                            LTRIM(TO_CHAR(B.ISSUE_YY,'09'))||'-'||
                            LTRIM(TO_CHAR(B.POL_SEQ_NO,'0999999'))||'-'||
                            LTRIM(TO_CHAR(B.RENEW_NO,'09'))    POLICY_NO,
                         B.TSI_AMT , 
                         B.PREM_AMT,
                         B.TAX_AMT,
                         B.EXPIRY_DATE,
                         D.LINE_NAME,
                         E.SUBLINE_NAME,
                         B.POLICY_ID,
                         B.PLATE_NO,
                         B.MODEL_YEAR,
                         B.COLOR,
                         B.SERIALNO,
                         B.CAR_COMPANY || ' ' || B.MAKE MAKE,
                         B.MOTOR_NO,
                         B.ITEM_TITLE,
                         DECODE(B.BALANCE_FLAG,'Y','*',NULL) BALANCE_FLAG,
                         DECODE(B.CLAIM_FLAG,'Y','*',NULL) CLAIM_FLAG,
                         NVL(B.REN_PREM_AMT,0) REN_PREM_AMT,--added by april as of 09/24/2007
                         NVL(B.REN_TSI_AMT,0) REN_TSI_AMT --added by april as of 09/24/2007
                    FROM --GIPI_POLBASIC A, commented by gmi.. walang gamit ata ang polbasic d2 since, sa extraction, kuha na lahat ng giex_expiry tables ang values needed here
                         GIEX_EXPIRIES_V B,
                         GIIS_LINE D,
                         GIIS_SUBLINE E            
                   WHERE 1=1 -- B.POLICY_ID           = A.POLICY_ID
                     AND B.LINE_CD = D.LINE_CD
                     AND B. SUBLINE_CD = E.SUBLINE_CD
                     AND D.LINE_CD = E.LINE_CD    
                     AND B.LINE_CD = 'MC'
                     AND NVL(B.POST_FLAG, 'N') = 'N'
                     AND B.POLICY_ID = NVL(P_POLICY_ID, B.POLICY_ID)
                     AND B.ASSD_NO = NVL(P_ASSD_NO, B.ASSD_NO)
                     AND NVL(B.INTM_NO,0) = NVL(P_INTM_NO,NVL(B.INTM_NO,0))
                     AND UPPER(B.ISS_CD) = NVL(UPPER(P_ISS_CD),UPPER(B.ISS_CD))
                     AND UPPER(B.SUBLINE_CD) = NVL(UPPER(P_SUBLINE_CD),UPPER(B.SUBLINE_CD))
                     AND UPPER(B.LINE_CD) = NVL(UPPER(P_LINE_CD),UPPER(B.LINE_CD))
                     AND trunc(B.EXPIRY_DATE) <=TRUNC(NVL(TO_DATE(P_ENDING_DATE, 'DD-MON-YYYY'), NVL(TO_DATE(P_STARTING_DATE, 'DD-MON-YYYY'), B.EXPIRY_DATE))) -- bonok :: 8.3.2015 :: UCPB SR 20009
                     AND TRUNC(B.EXPIRY_DATE) >= DECODE(TO_DATE(P_ENDING_DATE, 'DD-MON-YYYY'), NULL, TRUNC(B.EXPIRY_DATE), TRUNC(NVL(TO_DATE(P_STARTING_DATE, 'DD-MON-YYYY'), B.EXPIRY_DATE))) -- bonok :: 8.3.2015 :: UCPB SR 20009
                    --codes below added by gmi... either include package main policies or not.. ung view sa from clause, nahahandle na niang nde ksama ang sub-policies ng package
                     AND DECODE(p_include_pack, 'N', B.PACK_POLICY_ID, 0)  = 0 
                     -- end gmi
                     AND NVL(B.CLAIM_FLAG,'N') LIKE NVL(p_claims_flag,DECODE(p_balance_flag,'Y','N','%')) /* mark jm 08.10.09 balance_flag handling (UW-SPECS-2009-00053) */
                     AND NVL(B.BALANCE_FLAG,'N') LIKE NVL(p_balance_flag,DECODE(p_claims_flag,'Y','N','%')) /* mark jm 08.10.09 balance_flag handling (UW-SPECS-2009-00053) */
					 AND (check_user_per_iss_cd(NVL(UPPER(p_line_cd),UPPER(b.line_cd)),NVL(UPPER(p_iss_cd),UPPER(b.iss_cd)), 'GIEXS006') = 1 -- bonok :: 01.25.2013 
                          OR check_user_per_line(NVL(UPPER(p_line_cd),UPPER(b.line_cd)),NVL(UPPER(p_iss_cd),UPPER(b.iss_cd)), 'GIEXS006') = 1) -- bonok :: 01.25.2013
                ORDER BY POLICY_NO)
        LOOP
                details.iss_cd          := i.iss_cd;
                details.line_cd         := i.line_cd;
                details.subline_cd      := i.subline_cd;
                details.issue_yy        := i.issue_yy;
                details.pol_seq_no      := i.pol_seq_no;
                details.renew_no        := i.renew_no;
                details.iss_cd2         := i.iss_cd2;
                details.line_cd2        := i.line_cd2;
                details.policy_no       := i.policy_no;
                details.tsi_amt         := i.tsi_amt;
                details.prem_amt        := i.prem_amt;
                details.tax_amt         := i.tax_amt;
                details.expiry_date     := i.expiry_date;
                details.line_name       := i.line_name;
                details.subline_name    := i.subline_name;
                details.policy_id       := i.policy_id;
                details.plate_no        := i.plate_no;
                details.model_year      := i.model_year;
                details.color           := i.color;
                details.serialno        := i.serialno;
                details.make            := i.make;
                details.motor_no        := i.motor_no;
                details.item_title      := i.item_title;
                details.balance_flag    := i.balance_flag;
                details.claim_flag      := i.claim_flag;
                details.ren_prem_amt    := i.ren_prem_amt;
                details.ren_tsi_amt     := i.ren_tsi_amt;
                details.ending_date     := TO_CHAR(TO_DATE(P_ENDING_DATE,'dd-MM-RRRR'),'Month dd, RRRR');
                details.starting_date   := TO_CHAR(TO_DATE(P_STARTING_DATE,'dd-MM-RRRR'),'Month dd, RRRR');
                
                FOR c IN(SELECT param_value_v
                   FROM giis_parameters
                  WHERE param_name = 'COMPANY_NAME')
                LOOP
                         details.v_company_name := c.param_value_v;
                END LOOP;
                
                details.v_company_address   := giisp.v('COMPANY_ADDRESS');                
                       
                FOR n IN(SELECT iss_name
                           FROM giis_issource
                          WHERE iss_cd = i.iss_cd)
                LOOP
                        details.iss_name    := n.iss_name;
                END LOOP;
                 
                FOR ASSD IN (select a.assd_name
                               from giis_assured a,
                                    giex_expiry  b
                              where a.assd_no = b.assd_no
                                and b.policy_id    = i.policy_id)
                LOOP                
                        details.assured      := assd.assd_name;
                END LOOP;          
                
                FOR pol IN(SELECT A.REF_POL_NO REF_POL_NO
                             FROM GIPI_POLBASIC A
                            WHERE A.POLICY_ID = i.POLICY_ID)
                LOOP
                        details.ref_pol_no      := pol.REF_POL_NO;
                END LOOP;
                
                FOR y IN(select distinct A.INTM_NO, to_char(A.INTM_NO)||'/'||ref_intm_cd v_intm_no
                           from giis_intermediary a,
                                gipi_polbasic b,
                                gipi_invoice c,
                                gipi_comm_invoice d
                          where b.policy_id = c.policy_id and
                                c.iss_cd = d.iss_cd and
                                c.prem_seq_no = d.prem_seq_no and
                                c.policy_id = d.policy_id and
                                B.LINE_CD = i.line_cd    AND
                                B.SUBLINE_CD = i.subline_cd AND
                                B.ISS_CD = i.iss_cd AND
                                B.ISSUE_YY = i.issue_yy AND
                                B.POL_SEQ_NO = i.pol_seq_no AND
                                B.RENEW_NO  = i.RENEW_NO AND  
                                --B.POL_FLAG IN ('1','2','3') 
                               a.intm_no = d.INTRMDRY_INTM_NO 
                               order by a.intm_no)
                  LOOP
                    IF p_intm_no IS NULL THEN
                       details.agent := rtrim(y.v_intm_no,'/');
                    ELSE
                       details.agent := p_intm_no||', '||rtrim(y.v_intm_no,'/');
                    END IF;
                  END LOOP;
                  
                  p_cf_item_desc := cf_item_descformula(i.plate_no,i.line_cd,i.subline_cd,i.iss_cd,i.issue_yy,i.pol_seq_no,i.renew_no);

                  details.make_motor        := cf_makeformula(i.motor_no,p_cf_item_desc,i.make,i.item_title);
    
                  
                  
                
                PIPE ROW(details);                 
        END LOOP;
    --RETURN;
 END;


/* Formatted on 2012/02/09 18:08 (Formatter Plus v4.8.8) */
FUNCTION cf_item_descformula(p_plate_no     gipi_vehicle.plate_no%TYPE,
                             p_line_cd      gipi_polbasic.line_cd%TYPE,
                             p_subline_cd   gipi_polbasic.subline_cd%TYPE,
                             p_iss_cd       gipi_polbasic.iss_cd%TYPE,
                             p_issue_yy     gipi_polbasic.issue_yy%TYPE,
                             p_pol_seq_no   gipi_polbasic.pol_seq_no%TYPE,
                             p_renew_no     gipi_polbasic.renew_no%TYPE)
   RETURN CHAR
IS
   v_item_desc   VARCHAR2 (32767); -- bonok :: 8.3.2015 :: UCPB SR 20009
BEGIN
   FOR m IN (SELECT a.item_desc itm_desc
               FROM gipi_item a, gipi_polbasic b
              WHERE b.line_cd = p_line_cd
                AND b.subline_cd = p_subline_cd
                AND b.iss_cd = p_iss_cd
                AND b.issue_yy = p_issue_yy
                AND b.pol_seq_no = p_pol_seq_no
                AND b.renew_no = p_renew_no
                AND a.policy_id = b.policy_id)
   LOOP
      IF p_plate_no = 'VARIOUS'
      THEN
         v_item_desc := 'VARIOUS';
      ELSE
         v_item_desc := m.itm_desc;
      END IF;
   END LOOP;

   RETURN (v_item_desc);
END;

/* Formatted on 2012/02/09 18:18 (Formatter Plus v4.8.8) */
FUNCTION cf_makeformula(p_motor_no          gipi_vehicle.motor_no%TYPE,
                        p_cf_item_desc      VARCHAR2,
                        p_make              gipi_vehicle.make%TYPE,
                        p_item_title        varchar2)
   RETURN CHAR
IS
   v_text   VARCHAR2 (1000);

   PROCEDURE inc
   IS
   BEGIN
      IF p_motor_no IS NOT NULL
      THEN
         v_text := v_text || ' / ' || p_motor_no;
      END IF;
   END;
BEGIN
   FOR m IN (SELECT text
               FROM giis_document
              WHERE title = 'PRINT_ITEM_DESC' AND report_id = 'GIEXR101A')
   LOOP
      v_text := m.text;
   END LOOP;

   IF v_text = 'Y'
   THEN
      IF p_cf_item_desc IS NOT NULL
      THEN
         v_text := p_cf_item_desc;
         inc;
      ELSE
         v_text := p_make;
         inc;
      END IF;
   ELSIF v_text = 'T'
   THEN
      IF p_item_title IS NOT NULL
      THEN
         v_text := p_item_title;
         inc;
      ELSE
         v_text := p_make;
         inc;
      END IF;
   ELSE
      v_text := p_make;
      inc;
   END IF;

   WHILE SUBSTR (v_text, 1, 1) = ' '
   LOOP
      v_text := SUBSTR (v_text, 2, LENGTH (v_text) - 1);
   END LOOP;

   RETURN (v_text);
END;



END GIEXR101A_PKG;
/


