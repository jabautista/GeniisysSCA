CREATE OR REPLACE PACKAGE BODY CPI.GIEXR102A_PKG
AS
/**
* Rey Jadlocon
* 03-01-2012
**/
FUNCTION get_details(P_POLICY_ID            NUMBER,
                     P_ASSD_NO              NUMBER,
                     P_INTM_NO              NUMBER,
                     P_ISS_CD               VARCHAR2,
                     P_SUBLINE_CD           VARCHAR2,
                     P_LINE_CD              VARCHAR2,
                     P_ENDING_DATE          VARCHAR2,
                     P_STARTING_DATE        VARCHAR2,
                     P_INCLUDE_PACK         VARCHAR2,
                     P_CLAIMS_FLAG          VARCHAR2,
                     P_BALANCE_FLAG         VARCHAR2)
        RETURN get_details_tab PIPELINED
        IS details get_details_type;
            v_intm_no   VARCHAR2 (2000);
            v_intm_no2   VARCHAR2 (2000);
            item_desc       varchar2(2000);
            makeformula     varchar2(500);
            ending         varchar2(100);
            starting       varchar2(100);
    BEGIN
         FOR i IN(SELECT 
                         B.ISS_CD,
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
                            LTRIM(TO_CHAR(B.RENEW_NO,'09'))                        POLICY_NO,
                         B.TSI_AMT , 
                         B.PREM_AMT,
                         B.TAX_AMT,
                         B.EXPIRY_DATE,
                         D.LINE_NAME,
                         E.SUBLINE_NAME,
                         B.POLICY_ID,
                         F.PERIL_CD,
                         F.PREM_AMT PREM_AMT2,
                         F.TSI_AMT TSI_AMT2,
                         B.PLATE_NO,
                         B.MODEL_YEAR,
                         B.COLOR,
                         B.SERIALNO,
                         B.CAR_COMPANY||' '||B.MAKE MAKE,
                         B.MOTOR_NO,
                         B.ITEM_TITLE,
                         DECODE(B.BALANCE_FLAG,'Y','*',NULL) BALANCE_FLAG,
                         DECODE(B.CLAIM_FLAG,'Y','*',NULL) CLAIM_FLAG,
                         B.PACK_POLICY_ID --sjm 07.20.2012 uw-specs-2012-056
                    FROM GIEX_EXPIRIES_V B,
                         GIIS_LINE D,
                         GIIS_SUBLINE E,
                         GIEX_OLD_GROUP_PERIL F
                   WHERE 1=1 
                     AND NVL(B.POST_FLAG, 'N') = 'N'
                     AND B.LINE_CD = D.LINE_CD
                     AND B.SUBLINE_CD = E.SUBLINE_CD
                     AND D.LINE_CD = E.LINE_CD  
                     AND  B.POLICY_ID = F.POLICY_ID
                     AND B.LINE_CD = 'MC'      
                     AND B.POLICY_ID = NVL(P_POLICY_ID, B.POLICY_ID)     
                     AND B.ASSD_NO = NVL(P_ASSD_NO, B.ASSD_NO)     
                     AND NVL(B.INTM_NO,0) = NVL(P_INTM_NO,NVL(B.INTM_NO,0))     
                     AND UPPER(B.ISS_CD) = NVL(UPPER(P_ISS_CD),UPPER(B.ISS_CD))     
                     AND UPPER(B.SUBLINE_CD) = NVL(UPPER(P_SUBLINE_CD),UPPER(B.SUBLINE_CD)) 
                     AND UPPER(B.LINE_CD) = NVL(UPPER(P_LINE_CD),UPPER(B.LINE_CD))
                     AND TRUNC(B.EXPIRY_DATE) <=TRUNC(NVL(TO_DATE(P_ENDING_DATE, 'DD-MON-YYYY'), NVL(TO_DATE(P_STARTING_DATE, 'DD-MON-YYYY'), B.EXPIRY_DATE)))     
                     AND TRUNC(B.EXPIRY_DATE) >= DECODE(TO_DATE(P_ENDING_DATE, 'DD-MON-YYYY'), NULL, TRUNC(B.EXPIRY_DATE), TRUNC(NVL(TO_DATE(P_STARTING_DATE, 'DD-MON-YYYY'), B.EXPIRY_DATE))) 
                     AND DECODE(P_INCLUDE_PACK, 'N', B.PACK_POLICY_ID, 0)  = 0 
                     AND NVL(B.CLAIM_FLAG,'N') LIKE NVL(P_CLAIMS_FLAG,DECODE(P_CLAIMS_FLAG,'Y','N','%')) 
                     AND NVL(B.BALANCE_FLAG,'N') LIKE NVL(P_BALANCE_FLAG,DECODE(p_claims_flag,'Y','N','%'))
					 AND (check_user_per_iss_cd(NVL(UPPER(p_line_cd),UPPER(b.line_cd)),NVL(UPPER(p_iss_cd),UPPER(b.iss_cd)), 'GIEXS006') = 1 -- bonok :: 01.25.2013 
                          OR check_user_per_line(NVL(UPPER(p_line_cd),UPPER(b.line_cd)),NVL(UPPER(p_iss_cd),UPPER(b.iss_cd)), 'GIEXS006') = 1)) -- bonok :: 01.25.2013
            LOOP
                    details.ISS_CD              := i.ISS_CD;
                    details.LINE_CD             := i.LINE_CD;
                    details.SUBLINE_CD          := i.SUBLINE_CD;
                    details.ISSUE_YY            := i.ISSUE_YY;
                    details.POL_SEQ_NO          := i.POL_SEQ_NO;
                    details.RENEW_NO            := i.RENEW_NO;
                    details.ISS_CD2             := i.ISS_CD2;
                    details.LINE_CD2            := i.LINE_CD2;
                    details.SUBLINE_CD2         := i.SUBLINE_CD2;
                    details.POLICY_NO           := i.POLICY_NO;
                    details.TSI_AMT             := i.TSI_AMT;
                    details.PREM_AMT            := i.PREM_AMT;
                    details.TAX_AMT             := i.TAX_AMT;
                    details.EXPIRY_DATE         := i.EXPIRY_DATE;
                    details.LINE_NAME           := i.LINE_NAME;
                    details.SUBLINE_NAME        := i.SUBLINE_NAME;
                    details.POLICY_ID           := i.POLICY_ID;
                    details.PERIL_CD            := i.PERIL_CD;
                    details.PREM_AMT2           := i.PREM_AMT2;
                    details.TSI_AMT2            := i.TSI_AMT2;
                    details.PLATE_NO            := i.PLATE_NO;
                    details.MODEL_YEAR          := i.MODEL_YEAR;
                    details.COLOR               := i.COLOR;
                    details.SERIALNO            := i.SERIALNO;
                    details.MAKE                := i.MAKE;
                    details.MOTOR_NO            := i.MOTOR_NO;
                    details.ITEM_TITLE          := i.ITEM_TITLE;
                    details.BALANCE_FLAG        := i.BALANCE_FLAG;
                    details.CLAIM_FLAG          := i.CLAIM_FLAG;
                    
                      FOR v IN (SELECT param_value_v
                                  FROM giis_parameters
                                 WHERE param_name = 'COMPANY_NAME')
                      LOOP
                        details.company_name := v.param_value_v;
                      END LOOP;
                      
                      FOR d IN (SELECT param_value_v
                                  FROM giis_parameters
                                 WHERE param_name = 'COMPANY_ADDRESS')
                      LOOP
                        details.company_address := d.param_value_v;
                      END LOOP;
                      
                      FOR l IN (SELECT DISTINCT a.intm_no,
                                        TO_CHAR (a.intm_no)
                                     || '/'
                                     || ref_intm_cd v_intm_no
                                FROM giis_intermediary a,
                                     gipi_polbasic b,
                                     gipi_invoice c,
                                     gipi_comm_invoice d
                               WHERE b.policy_id = c.policy_id
                                 AND c.iss_cd = d.iss_cd
                                 AND c.prem_seq_no = d.prem_seq_no
                                 AND c.policy_id = d.policy_id
                                 AND b.line_cd = i.line_cd
                                 AND b.subline_cd = i.subline_cd
                                 AND b.iss_cd = i.iss_cd
                                 AND b.issue_yy = i.issue_yy
                                 AND b.pol_seq_no = i.pol_seq_no
                                 AND b.renew_no = i.renew_no
                                 AND a.intm_no = d.intrmdry_intm_no
                            ORDER BY a.intm_no)
                       LOOP
                          IF v_intm_no IS NULL
                          THEN
                             v_intm_no := RTRIM (l.v_intm_no, '/');
                          ELSE
                             v_intm_no := v_intm_no2 || ', ' || RTRIM (l.v_intm_no, '/');
                          END IF;
                       END LOOP;
                        details.intm_no         := v_intm_no;
                       details.starting_date        := TO_DATE(P_STARTING_DATE, 'DD-MON-YYYY');
                       details.ending_date          := TO_DATE(P_ENDING_DATE, 'DD-MON-YYYY');
                
                      FOR n IN (SELECT iss_name
                                  FROM giis_issource
                                 WHERE iss_cd = i.iss_cd)
                      LOOP
                            details.iss_name        := n.iss_name;
                      END LOOP;
                      
                      
                   FOR L IN (select a.assd_name
                                   from giis_assured a,
                                        giex_expiry  b
                              where a.assd_no = b.assd_no
                               and  b.policy_id    = i.policy_id)
                    LOOP                
                             details.ASSD_NAME := L.ASSD_NAME;
                       IF L.ASSD_NAME IS NULL THEN

                       FOR C2 IN (select a.assd_name
                                   from giis_assured a,
                                        gipi_polbasic b
                              where a.assd_no = b.assd_no
                               and  b.line_cd    = i.line_cd
                               and  b.subline_cd = i.subline_cd 
                               and  b.iss_cd     = i.iss_cd
                               and  b.issue_yy   = i.issue_yy
                               and  b.pol_seq_no = i.pol_seq_no
                               and  b.renew_no   = i.renew_no)
                       LOOP                
                             details.ASSD_NAME := C2.ASSD_NAME;
                       END LOOP;
                    END IF;
           
                    END LOOP;

                    
                    FOR pol IN(SELECT A.REF_POL_NO REF_POL_NO
                                  FROM GIPI_POLBASIC A
                                  WHERE A.POLICY_ID = i.POLICY_ID )
                    LOOP
                            details.REF_POL_NO := pol.REF_POL_NO;
                    END LOOP;
                  
                    item_desc  := GIEXR102A_PKG.cf_item_descformula(i.line_cd,i.subline_cd,i.iss_cd,i.issue_yy,i.pol_seq_no,i.renew_no,i.plate_no);
                    details.item_desc := item_desc;

                    
                   details.makeformula := GIEXR102A_PKG.cf_makeformula(i.motor_no,GIEXR102A_PKG.cf_item_descformula(i.line_cd,i.subline_cd,i.iss_cd,i.issue_yy,i.pol_seq_no,i.renew_no,i.plate_no),i.make,i.item_title);
                   --details.makeformula := makeformula;
                   
                   FOR y IN (SELECT peril_sname
                               FROM giis_peril
                              WHERE peril_cd = i.peril_cd AND line_cd = i.line_cd)
                   LOOP
                      details.peril_name := y.peril_sname;
                   END LOOP;
                   
                   FOR c IN /*(select tsi_amt
                      from giex_old_group_peril
                      where peril_cd = :peril_cd
                      and policy_id = :policy_id)*/ --commented out by sjm 07.26.2012
                      (SELECT NVL(b.tsi_amt, a.tsi_amt) tsi_amt
                         FROM giex_old_group_peril a, giex_new_group_peril b
                        WHERE a.policy_id = b.policy_id(+)
                          AND a.peril_cd = b.peril_cd(+)
                          AND a.peril_cd = i.peril_cd
                          AND a.policy_id = i.policy_id)
                   LOOP
                      details.tsi_amt := c.tsi_amt;
                   END LOOP;
                   
                   FOR c IN (SELECT NVL (b.prem_amt, a.prem_amt) prem_amt
                               FROM giex_old_group_peril a, giex_new_group_peril b
                              WHERE a.policy_id = b.policy_id(+)
                                AND a.peril_cd = b.peril_cd(+)
                                AND a.peril_cd = i.peril_cd
                                AND a.policy_id = i.policy_id)
                   LOOP
                      details.prem_amt := c.prem_amt;
                   END LOOP;
                    
                 PIPE ROW(details);
            END LOOP;
    END;  
    
    
    
FUNCTION cf_makeformula(p_motor_no      varchar2,
                        p_cf_item_desc  varchar2,
                        p_make          varchar2,
                        p_item_title    varchar2)
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
                  WHERE title = 'PRINT_ITEM_DESC' AND report_id = 'GIEXR102A')
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
    
    
FUNCTION cf_item_descformula(p_line_cd          varchar2,
                             p_subline_cd       varchar2,
                             p_iss_cd           varchar2,
                             p_issue_yy         number,
                             p_pol_seq_no       number,
                             p_renew_no         number,
                             p_plate_no         varchar2)
   RETURN CHAR
IS
   v_item_desc   VARCHAR2 (2000);
BEGIN
   FOR m IN (SELECT a.item_desc
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
         v_item_desc := m.item_desc;
      END IF;
   END LOOP;

   RETURN (v_item_desc);
END;
   
END GIEXR102A_PKG;
/


