CREATE OR REPLACE PACKAGE BODY CPI.giacr112a_pkg AS       

/*
** Created by: Bonok
** Date Created: 3/6/2015
** Description: GIACR112A : Form 2307 - Certificate of Creditable Tax Withheld at Source (with Form)
*/
--Modified by pjsantos 12/22/2016, GENQA 5898
   FUNCTION populate_giacr112a(
      p_date1             VARCHAR2,
      p_date2             VARCHAR2,
      p_exclude_tag       VARCHAR2,
      p_payee_class_cd    VARCHAR2,
      p_payee_no          VARCHAR2,
      p_post_tran         VARCHAR2,
      p_tran_id           VARCHAR2,
      p_items             VARCHAR2,
      p_tran_tag          VARCHAR2 
   )
   RETURN giacr112a_tab PIPELINED AS
      v_rec       giacr112a_type;
      v_not_exist BOOLEAN := TRUE;
      v_date1     DATE := TO_DATE(p_date1, 'MM/DD/RRRR');
      v_date2     DATE := TO_DATE(p_date2, 'MM/DD/RRRR');
      v_tin       giac_parameters.param_value_v%TYPE;
      v_income_amt_tot    NUMBER(18,2) := 0;
      v_whtax_tot         NUMBER(18,2) := 0;
   BEGIN
      v_rec.date1       := TO_CHAR(v_date1, 'MM        DD        RR');
      v_rec.date2       := TO_CHAR(v_date2, 'MM        DD        RR');
 IF NVL(p_tran_tag, 'N') = 'N'
    THEN      
      FOR i IN(SELECT DISTINCT
                      b.payee_no,
                      b.payee_class_cd,
                      b.payee_last_name||' '||b.payee_first_name||' '||b.payee_middle_name payee, 
                      b.mail_addr1||' '||b.mail_addr2||' '||b.mail_addr3 address
                      --,c.whtax_code,
                      --c.whtax_desc,
                      --c.bir_tax_cd
                 FROM giac_acctrans a, 
                      giis_payees b, 
                      giac_wholding_taxes c,
                      giac_taxes_wheld d
                WHERE c.whtax_id = d.gwtx_whtax_id
                  AND b.payee_class_cd = d.payee_class_cd
                  AND b.payee_no = d.payee_cd
                  AND a.tran_id = d.gacc_tran_id
                  AND a.tran_flag <> 'D'
                  AND d.gacc_tran_id NOT IN (SELECT e.gacc_tran_id
                                               FROM giac_reversals e,
                                                    giac_acctrans f
                                              WHERE e.reversing_tran_id=f.tran_id
                                                AND f.tran_flag<>'D')                   
                  AND ((p_post_tran = 'T' AND TRUNC(a.tran_date) BETWEEN v_date1 AND v_date2) OR (p_post_tran = 'P' AND TRUNC(a.posting_date) BETWEEN v_date1 AND v_date2))
                  AND b.payee_no = NVL(p_payee_no, b.payee_no)
                  AND b.payee_class_cd = NVL(p_payee_class_cd, b.payee_class_cd)
                --ORDER BY c.whtax_code,
                         --c.whtax_desc,
                         --c.bir_tax_cd
                         )
      LOOP
         v_not_exist         := FALSE;
         v_rec.payee         := i.payee;
         v_rec.address       := i.address;
         --v_rec.whtax_code    := i.whtax_code;
         v_tin               := giacp.v('COMPANY_TIN');
         v_rec.com_tin1      := SUBSTR(v_tin,1,3);
         v_rec.com_tin2      := SUBSTR(v_tin,5,3);
         v_rec.com_tin3      := SUBSTR(v_tin,9,3);
         v_rec.com_tin4      := SUBSTR(v_tin,13,3);
         v_rec.comp_name     := giacp.v('COMPANY_NAME');
         v_rec.comp_add      := REPLACE(giacp.v('COMPANY_ADDRESS'),CHR(10),' ');
         v_rec.zip_code      := giacp.v('COMPANY_ZIP_CODE');
         --v_rec.whtax_desc    := i.whtax_desc;
         --v_rec.bir_tax_cd    := i.bir_tax_cd;
         v_rec.payee_no      := i.payee_no;
         v_rec.payee_class_cd := i.payee_class_cd;
           
         <<sub>>
         FOR a IN(SELECT tin, 
                         SUBSTR(tin,1,3) tin1,
                         SUBSTR(tin,5,3) tin2,
                         SUBSTR(tin,9,3) tin3,
                         SUBSTR(tin,13,3) tin4
                    FROM giis_payees
                   WHERE payee_no = i.payee_no
                     AND payee_class_cd = i.payee_class_cd)
         LOOP
            v_rec.payee_tin1 := a.tin1;
            v_rec.payee_tin2 := a.tin2;
            v_rec.payee_tin3 := a.tin3;
            v_rec.payee_tin4 := NVL(a.tin4, '000');
            EXIT sub;
         END LOOP;
         
         v_rec.income_amt1    := 0;
         v_rec.income_amt2    := 0;
         v_rec.income_amt3    := 0;
         v_rec.income_amt_tot := 0;
         v_rec.whtax_tot      := 0;
         v_income_amt_tot     := 0;
         v_whtax_tot          := 0;

         FOR f IN (SELECT a.signatory, a.designation  
                     FROM giis_signatory_names a, 
                          giac_rep_signatory b
                    WHERE a.signatory_id = b.signatory_id
                      AND report_id = 'GIACR112A' 
                      AND rownum = 1)
         LOOP
            v_rec.designation := f.designation;
            v_rec.signatory := f.signatory;            
            EXIT;
         END LOOP;
           
         PIPE ROW(v_rec);
     
      END LOOP;

      IF v_not_exist THEN
         v_rec.flag := 'T';
         PIPE ROW(v_rec);
      END IF;
ELSE
    FOR i IN(SELECT DISTINCT
                      b.payee_no,
                      b.payee_class_cd,
                      b.payee_last_name||' '||b.payee_first_name||' '||b.payee_middle_name payee, 
                      b.mail_addr1||' '||b.mail_addr2||' '||b.mail_addr3 address, a.tran_date
                      --,c.whtax_code,
                      --c.whtax_desc,
                      --c.bir_tax_cd
                 FROM giac_acctrans a, 
                      giis_payees b, 
                      giac_wholding_taxes c,
                      giac_taxes_wheld d
                WHERE c.whtax_id = d.gwtx_whtax_id
                  AND b.payee_class_cd = d.payee_class_cd
                  AND b.payee_no = d.payee_cd
                  AND a.tran_id = d.gacc_tran_id
                  AND a.tran_flag <> 'D'
                  AND d.gacc_tran_id NOT IN (SELECT e.gacc_tran_id
                                               FROM giac_reversals e,
                                                    giac_acctrans f
                                              WHERE e.reversing_tran_id=f.tran_id
                                                AND f.tran_flag<>'D')                   
                  AND d.gacc_tran_id = p_tran_id
                  AND d.item_no IN (SELECT COLUMN_VALUE FROM TABLE (SPLIT_COMMA_SEPARATED (p_items))) 
                --ORDER BY c.whtax_code,
                         --c.whtax_desc,
                         --c.bir_tax_cd
                         )
      LOOP
         v_not_exist         := FALSE;
         v_rec.payee         := i.payee;
         v_rec.address       := i.address;
         --v_rec.whtax_code    := i.whtax_code;
         v_tin               := giacp.v('COMPANY_TIN');
         v_rec.com_tin1      := SUBSTR(v_tin,1,3);
         v_rec.com_tin2      := SUBSTR(v_tin,5,3);
         v_rec.com_tin3      := SUBSTR(v_tin,9,3);
         v_rec.com_tin4      := SUBSTR(v_tin,13,3);
         v_rec.comp_name     := giacp.v('COMPANY_NAME');
         v_rec.comp_add      := REPLACE(giacp.v('COMPANY_ADDRESS'),CHR(10),' ');
         v_rec.zip_code      := giacp.v('COMPANY_ZIP_CODE');
         --v_rec.whtax_desc    := i.whtax_desc;
         --v_rec.bir_tax_cd    := i.bir_tax_cd;
         v_rec.payee_no      := i.payee_no;
         v_rec.payee_class_cd := i.payee_class_cd;
           
         <<sub>>
         FOR a IN(SELECT tin, 
                         SUBSTR(tin,1,3) tin1,
                         SUBSTR(tin,5,3) tin2,
                         SUBSTR(tin,9,3) tin3,
                         SUBSTR(tin,13,3) tin4
                    FROM giis_payees
                   WHERE payee_no = i.payee_no
                     AND payee_class_cd = i.payee_class_cd)
         LOOP
            v_rec.payee_tin1 := a.tin1;
            v_rec.payee_tin2 := a.tin2;
            v_rec.payee_tin3 := a.tin3;
            v_rec.payee_tin4 := NVL(a.tin4, '000');
            EXIT sub;
         END LOOP;
         
         v_rec.income_amt1    := 0;
         v_rec.income_amt2    := 0;
         v_rec.income_amt3    := 0;
         v_rec.income_amt_tot := 0;
         v_rec.whtax_tot      := 0;
         v_income_amt_tot     := 0;
         v_whtax_tot          := 0;

         FOR f IN (SELECT a.signatory, a.designation  
                     FROM giis_signatory_names a, 
                          giac_rep_signatory b
                    WHERE a.signatory_id = b.signatory_id
                      AND report_id = 'GIACR112A' 
                      AND rownum = 1)
         LOOP
            v_rec.designation := f.designation;
            v_rec.signatory := f.signatory;            
            EXIT;
         END LOOP;
         v_rec.date1       := TO_CHAR(i.tran_date, 'MM        DD        RR');
         v_rec.date2       := TO_CHAR(i.tran_date, 'MM        DD        RR');
         PIPE ROW(v_rec);
     
      END LOOP;

      IF v_not_exist THEN
         v_rec.flag := 'T';
         PIPE ROW(v_rec);
      END IF;
END IF;
   END populate_giacr112a;

   FUNCTION get_giacr112a_whtax(
      p_date1             VARCHAR2,
      p_date2             VARCHAR2,
      p_exclude_tag       VARCHAR2,
      p_payee_class_cd    VARCHAR2,
      p_payee_no          giis_payees.payee_no%TYPE,
      p_post_tran         VARCHAR2,
      p_whtax_code        giac_wholding_taxes.whtax_code%TYPE,
      p_bir_tax_cd        VARCHAR2,
      p_tran_id           VARCHAR2,
      p_items             VARCHAR2,
      p_tran_tag          VARCHAR2 
   ) RETURN giacr112a_tab PIPELINED AS
      v_rec       giacr112a_type;
      v_date1     DATE := TO_DATE(p_date1, 'MM/DD/RRRR');
      v_date2     DATE := TO_DATE(p_date2, 'MM/DD/RRRR');
      v_income_amt_tot    NUMBER(18,2) := 0;
      v_whtax_tot         NUMBER(18,2) := 0;  
   BEGIN
 IF NVL(p_tran_tag, 'N') = 'N'
    THEN
       FOR i IN(SELECT DISTINCT
                      b.payee_no,
                      b.payee_class_cd,
                      b.payee_last_name||' '||b.payee_first_name||' '||b.payee_middle_name payee, 
                      b.mail_addr1||' '||b.mail_addr2||' '||b.mail_addr3 address,
                      /*c.whtax_code,
                      c.whtax_desc,*/--Comment out by pjsantos 01/03/2017, GENQA 5898
                      c.bir_tax_cd
                 FROM giac_acctrans a, 
                      giis_payees b, 
                      giac_wholding_taxes c,
                      giac_taxes_wheld d
                WHERE c.whtax_id = d.gwtx_whtax_id
                  AND b.payee_class_cd = d.payee_class_cd
                  AND b.payee_no = d.payee_cd
                  AND a.tran_id = d.gacc_tran_id
                  AND a.tran_flag <> 'D'
                  AND d.gacc_tran_id NOT IN (SELECT e.gacc_tran_id
                                               FROM giac_reversals e,
                                                    giac_acctrans f
                                              WHERE e.reversing_tran_id=f.tran_id
                                                AND f.tran_flag<>'D')                   
                  AND ((p_post_tran = 'T' AND TRUNC(a.tran_date) BETWEEN v_date1 AND v_date2) OR (p_post_tran = 'P' AND TRUNC(a.posting_date) BETWEEN v_date1 AND v_date2))
                  AND b.payee_no = NVL(p_payee_no, b.payee_no)
                  AND b.payee_class_cd = NVL(p_payee_class_cd, b.payee_class_cd)
                ORDER BY /*c.whtax_code,
                         c.whtax_desc,*/ --Comment out by pjsantos 01/03/2017, GENQA 5898
                         c.bir_tax_cd)
      LOOP
         /*v_rec.whtax_code    := i.whtax_code;
         v_rec.whtax_desc    := i.whtax_desc;*/--Comment out by pjsantos 01/03/2017, GENQA 5898
         --Added by pjsantos 01/03/2017, GENQA 5898
         SELECT whtax_desc
           INTO v_rec.whtax_desc
           FROM giac_wholding_taxes
          WHERE bir_tax_cd = i.bir_tax_cd
            AND ROWNUM =1;
         
         v_rec.bir_tax_cd    := i.bir_tax_cd;
         v_rec.payee_no      := i.payee_no;
         v_rec.income_amt1    := 0;
         v_rec.income_amt2    := 0;
         v_rec.income_amt3    := 0;
         v_rec.income_amt_tot := 0;
         v_rec.whtax_tot      := 0;
         v_income_amt_tot     := 0;
         v_whtax_tot          := 0;
         <<sub2>> 
         FOR b IN (SELECT b.payee_no,
                          b.payee_class_cd,
                          --c.whtax_code, Removed by pjsantos 01/03/2017, GENQA 5898
                          c.bir_tax_cd, 
                          TO_NUMBER(TO_CHAR(a.tran_date, 'MM')) months,
                          SUM(d.income_amt) income_amt,
                          SUM(d.wholding_tax_amt) wholding_tax_amt
                     FROM giac_acctrans a, 
                          giis_payees b, 
                          giac_wholding_taxes c,
                          giac_taxes_wheld d
                    WHERE c.whtax_id = d.gwtx_whtax_id
                      AND b.payee_class_cd = d.payee_class_cd
                      AND b.payee_no = d.payee_cd
                      AND a.tran_id = d.gacc_tran_id
                      AND a.tran_flag <> 'D'
                      AND d.gacc_tran_id NOT IN (SELECT e.gacc_tran_id
                                                   FROM giac_reversals e,
                                                        giac_acctrans f
                                                  WHERE e.reversing_tran_id=f.tran_id
                                                    AND f.tran_flag<>'D')               
                                                    AND ((p_post_tran = 'T' AND TRUNC(a.tran_date) BETWEEN v_date1 AND v_date2) 
                                                          OR (p_post_tran = 'P' AND TRUNC(a.posting_date) BETWEEN v_date1 AND v_date2))
                                                    AND ((p_post_tran = 'T' AND a.tran_flag <> NVL(p_exclude_tag,' ')) OR p_post_tran = 'P')   
                                                    AND b.payee_no = p_payee_no
                                                    AND b.payee_class_cd = p_payee_class_cd
                                                    --AND c.whtax_code = p_whtax_code 
                                                    --AND c.bir_tax_cd = p_bir_tax_cd 
                                                    --AND c.whtax_code = i.whtax_code  Removed by pjsantos 01/03/2017, GENQA 5898
                                                    AND c.bir_tax_cd = i.bir_tax_cd
                                                  GROUP BY b.payee_no,
                                                           b.payee_class_cd,
                                                           --c.whtax_code, Removed by pjsantos 01/03/2017, GENQA 5898
                                                           c.bir_tax_cd, 
                                                           TO_NUMBER(TO_CHAR(a.tran_date, 'MM')))
         LOOP
            IF b.months IN (1,4,7,10) THEN
              v_rec.income_amt1   := b.income_amt;
            ELSIF b.months IN (2,5,8,11) THEN
              v_rec.income_amt2   := b.income_amt;
            ELSIF b.months IN (3,6,9,12) THEN
              v_rec.income_amt3   := b.income_amt;
            END IF;
                 
                 
            v_income_amt_tot  := v_income_amt_tot + b.income_amt;
            v_rec.income_amt_tot:= v_income_amt_tot;

                 
            v_whtax_tot  := v_whtax_tot + b.wholding_tax_amt;
            v_rec.whtax_tot:= v_whtax_tot;
         END LOOP;
        
         PIPE ROW(v_rec);
  
      END LOOP;
ELSE      
       FOR i IN(SELECT DISTINCT
                      b.payee_no,
                      b.payee_class_cd,
                      b.payee_last_name||' '||b.payee_first_name||' '||b.payee_middle_name payee, 
                      b.mail_addr1||' '||b.mail_addr2||' '||b.mail_addr3 address,
                      /*c.whtax_code,
                      c.whtax_desc,*/ -- Removed by pjsantos 01/03/2017, GENQA 5898
                      c.bir_tax_cd
                 FROM giac_acctrans a, 
                      giis_payees b, 
                      giac_wholding_taxes c,
                      giac_taxes_wheld d
                WHERE c.whtax_id = d.gwtx_whtax_id
                  AND b.payee_class_cd = d.payee_class_cd
                  AND b.payee_no = d.payee_cd
                  AND a.tran_id = d.gacc_tran_id
                  AND a.tran_flag <> 'D'
                  AND d.gacc_tran_id NOT IN (SELECT e.gacc_tran_id
                                               FROM giac_reversals e,
                                                    giac_acctrans f
                                              WHERE e.reversing_tran_id=f.tran_id
                                                AND f.tran_flag<>'D')                   
                  AND d.gacc_tran_id = p_tran_id
                  AND d.item_no IN (SELECT COLUMN_VALUE FROM TABLE (SPLIT_COMMA_SEPARATED (p_items))) 
                ORDER BY /*c.whtax_code,
                         c.whtax_desc*/  --Removed by pjsantos 01/03/2017, GENQA 5898
                         c.bir_tax_cd)
      LOOP
         /*v_rec.whtax_code    := i.whtax_code;
         v_rec.whtax_desc    := i.whtax_desc;*/ --Removed by pjsantos 01/03/2017, GENQA 5898
         --Added by pjsantos 01/03/2017, GENQA 5898
         SELECT whtax_desc
           INTO v_rec.whtax_desc
           FROM giac_wholding_taxes
          WHERE bir_tax_cd = i.bir_tax_cd
            AND ROWNUM =1;
         v_rec.bir_tax_cd    := i.bir_tax_cd;
         v_rec.payee_no      := i.payee_no;
         v_rec.income_amt1    := 0;
         v_rec.income_amt2    := 0;
         v_rec.income_amt3    := 0;
         v_rec.income_amt_tot := 0;
         v_rec.whtax_tot      := 0;
         v_income_amt_tot     := 0;
         v_whtax_tot          := 0;
         <<sub2>>
         FOR b IN (SELECT b.payee_no,
                          b.payee_class_cd,
                          --c.whtax_code, Removed by pjsantos 01/03/2017, GENQA 5898
                          c.bir_tax_cd, 
                          TO_NUMBER(TO_CHAR(a.tran_date, 'MM')) months,
                          SUM(d.income_amt) income_amt,
                          SUM(d.wholding_tax_amt) wholding_tax_amt
                     FROM giac_acctrans a, 
                          giis_payees b, 
                          giac_wholding_taxes c,
                          giac_taxes_wheld d
                    WHERE c.whtax_id = d.gwtx_whtax_id
                      AND b.payee_class_cd = d.payee_class_cd
                      AND b.payee_no = d.payee_cd
                      AND a.tran_id = d.gacc_tran_id
                      AND a.tran_flag <> 'D'
                      AND d.gacc_tran_id NOT IN (SELECT e.gacc_tran_id
                                                   FROM giac_reversals e,
                                                        giac_acctrans f
                                                  WHERE e.reversing_tran_id=f.tran_id
                                                    AND f.tran_flag<>'D')               
                      AND b.payee_no = i.payee_no
                      AND b.payee_class_cd = i.payee_class_cd
                      AND d.gacc_tran_id = p_tran_id
                      AND d.item_no IN (SELECT COLUMN_VALUE FROM TABLE (SPLIT_COMMA_SEPARATED (p_items))) 
                     --AND c.whtax_code = i.whtax_code  --Removed by pjsantos 01/03/2017, GENQA 5898
                      AND c.bir_tax_cd = i.bir_tax_cd
                                                  GROUP BY b.payee_no,
                                                           b.payee_class_cd,
                                                           --c.whtax_code, --Removed by pjsantos 01/03/2017, GENQA 5898
                                                           c.bir_tax_cd, 
                                                           TO_NUMBER(TO_CHAR(a.tran_date, 'MM')))
         LOOP
            IF b.months IN (1,4,7,10) THEN
              v_rec.income_amt1   := b.income_amt;
            ELSIF b.months IN (2,5,8,11) THEN
              v_rec.income_amt2   := b.income_amt;
            ELSIF b.months IN (3,6,9,12) THEN
              v_rec.income_amt3   := b.income_amt;
            END IF;
                 
                 
            v_income_amt_tot  := v_income_amt_tot + b.income_amt;
            v_rec.income_amt_tot:= v_income_amt_tot;

                 
            v_whtax_tot  := v_whtax_tot + b.wholding_tax_amt;
            v_rec.whtax_tot:= v_whtax_tot;
         END LOOP;
        
         PIPE ROW(v_rec);
  
      END LOOP;
END IF;
   END;
END giacr112a_pkg;
/
