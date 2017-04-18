CREATE OR REPLACE PACKAGE BODY CPI.POPULATE_TEXT_FOR_BOND_DOC AS
/******************************************************************************
   NAME:       POPULATE_TEXT_FOR_BOND_DOC
   PURPOSE:    For populating bond documents

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        2/9/2011            Grace    Created this package.
   1.1        5/5/2011            Bhev     modified Populate_text_for_G13bond
******************************************************************************/

  FUNCTION Populate_text_for_G16bond (p_EXTRACT_id    GIXX_POLBASIC.EXTRACT_id%TYPE) 
    RETURN g16bond_tab PIPELINED
  
  IS
  
      v_g16bond         g16bond_type;
  
  BEGIN
  
    FOR i IN (
        SELECT P.prem_amt, A.assd_name,
               LTRIM(RTRIM(A.bill_addr1||' '||A.bill_addr2||' '||A.bill_addr3)) address,
               get_policy_no(P.policy_id) policy_no, P.subline_cd,
               to_char(P.expiry_date,'fmMonth DD, yyyy') expiry_date, P.tsi_amt, s.prin_signor, s.designation,
               to_char(P.incept_date,'fmMonth DD, yyyy') incept_date, --* Added by Windell ON May 12, 2011
               populate_text_for_bond_doc.get_spelled_number(P.tsi_amt) tsi_word,
               NVL(TO_CHAR(b.contract_date,'ddth'),'______') contract_day,
               NVL(TO_CHAR(b.contract_date,'fmMonth, yyyy'),'_____________,______') contract_month_year, 
               b.contract_dtl,
               b.bond_dtl, P.issue_date,
               NVL(TO_CHAR(P.issue_date,'ddth'),'______') issue_day,
               NVL(TO_CHAR(P.issue_date,'fmMonth, yyyy '),'_____________,_______') issue_month_year,
               h.obligee_name,
               LTRIM(RTRIM(h.address1||''||h.address2||''||h.address3)) o_address,
               s.issue_place, P.policy_id, P.ref_pol_no,         
               s.res_cert, P.iss_cd,
               sl.subline_name
               ,b.clause_type
          FROM gixx_polbasic p,
               gixx_bond_basic b,
               giis_assured a,
               giis_subline sl,
               giis_obligee h,
               giis_prin_signtry s
        WHERE 1 = 1
          AND p.extract_id = b.extract_id(+)
          AND p.assd_no = a.assd_no(+)
          AND p.subline_cd = sl.subline_cd(+)
          AND b.obligee_no = h.obligee_no(+)
          AND b.prin_id = S.PRIN_ID(+)
          AND p.extract_id = p_extract_id) 
    LOOP
       
       v_g16bond.prem_amt             := i.prem_amt;
       v_g16bond.assd_name            := i.assd_name;
       v_g16bond.address              := i.address;
       v_g16bond.policy_no            := i.policy_no;   
       v_g16bond.incept_date          := i.incept_date;  --* Added by Windell ON May 12, 2011
       v_g16bond.expiry_date          := i.expiry_date;
       v_g16bond.subline_cd           := i.subline_cd;
       v_g16bond.subline_name         := i.subline_name; --* Added by Windell ON May 12, 2011
       v_g16bond.tsi_amt              := i.tsi_amt;
       v_g16bond.tsi_word             := i.tsi_word;    
       v_g16bond.prin_signor          := i.prin_signor;
       v_g16bond.designation          := i.designation;
       v_g16bond.contract_day         := i.contract_day;
       v_g16bond.contract_month_year  := i.contract_month_year;
       v_g16bond.contract_dtl         := i.contract_dtl;
       v_g16bond.bond_dtl             := i.bond_dtl;
       v_g16bond.issue_date           := i.issue_date;
       v_g16bond.issue_day            := i.issue_day;   
       v_g16bond.issue_month_year     := i.issue_month_year;                         
       v_g16bond.obligee_name         := i.obligee_name;
       v_g16bond.o_address            := i.o_address;
       v_g16bond.issue_place          := i.issue_place;
       v_g16bond.policy_id            := i.policy_id;
       v_g16bond.ref_pol_no           := i.ref_pol_no;
       v_g16bond.res_cert             := i.res_cert;
       v_g16bond.iss_cd               := i.iss_cd;
       v_g16bond.clause_type          := i.clause_type;
       
       PIPE ROW (v_g16bond);
    END LOOP;
  
  END Populate_text_for_G16bond; 
    
  
  FUNCTION Populate_text_for_Taxes (p_policy_id    GIPI_INVOICE.policy_id%TYPE) 
    RETURN taxes_tab PIPELINED
  
  IS
  
      v_taxes         taxes_type;
  
  BEGIN
  
    FOR i IN (SELECT v.policy_id, v.prem_amt, sum(tax_amt) OVER(PARTITION BY v.policy_id) total_tax, 
              (SELECT i.tax_amt
                 FROM gipi_inv_tax i
                WHERE i.tax_cd = giisp.n('DOCUMENTARY_TAX')
                  AND i.iss_cd = v.iss_cd
                  AND i.prem_seq_no = v.prem_seq_no) ds_tax, 
              (SELECT i.tax_amt
                 FROM gipi_inv_tax i
                WHERE i.tax_cd = giisp.n('LOCAL GOVT TAX')
                  AND i.iss_cd = v.iss_cd
                  AND i.prem_seq_no = v.prem_seq_no) lgt_tax, 
              (SELECT i.tax_amt
                 FROM gipi_inv_tax i
                WHERE i.tax_cd = giisp.n('NOTARIAL FEE')
                  AND i.iss_cd = v.iss_cd
                  AND i.prem_seq_no = v.prem_seq_no) not_fee,
              (SELECT i.tax_amt
                 FROM gipi_inv_tax i,
                      giis_parameters b
                WHERE i.tax_cd = b.param_value_n
                  AND b.param_name = 'EVAT'
                  AND b.param_type = 'N'
                  AND i.iss_cd = v.iss_cd
                  AND i.prem_seq_no = v.prem_seq_no) evat_tax,
              (SELECT sum(i.tax_amt)
                 FROM gipi_inv_tax i
                WHERE i.tax_cd NOT IN (giisp.n('DOCUMENTARY_TAX'), giisp.n('LOCAL GOVT TAX'), giisp.n('NOTARIAL FEE'),
                                       (SELECT param_value_n
                                          FROM giis_parameters
                                         WHERE param_name = 'EVAT'
                                           AND param_type = 'N'))    
                  AND i.iss_cd = v.iss_cd
                  AND i.prem_seq_no = v.prem_seq_no) oth_tax              
          FROM gipi_invoice v                    
         WHERE v.policy_id = nvl(p_policy_id, v.policy_id)                
         ORDER BY policy_id        
        )
    LOOP
       
       v_taxes.policy_id        := i.policy_id;
       v_taxes.prem_amt         := i.prem_amt;
       v_taxes.ds_tax           := i.ds_tax;
       v_taxes.lgt_tax          := i.lgt_tax;
       v_taxes.not_fee          := i.not_fee; 
       v_taxes.evat_tax         := i.evat_tax;
       v_taxes.oth_tax          := i.oth_tax;   
       v_taxes.total_tax        := i.total_tax;          
       PIPE ROW (v_taxes);
    END LOOP;
  
  END Populate_text_for_Taxes; 
  
  --start Populate_text_for_taxes2
  FUNCTION Populate_text_for_Taxes2 (p_policy_id    GIPI_INVOICE.policy_id%TYPE) 
    RETURN taxes_tab2 PIPELINED
  
  IS
  
      v_taxes2         taxes_type2;
  
  BEGIN
  
    FOR i IN (SELECT A.POLICY_ID, decode(b.tax_cd, 3, 'Doc Stamps',5,'L.G.T', c.tax_desc) TAX_DESC, B.TAX_AMT 
         FROM GIPI_INVOICE A, GIPI_INV_TAX B, GIIS_TAX_CHARGES C
         WHERE A.ISS_CD =  B.ISS_CD
         AND A.PREM_SEQ_NO = B.PREM_SEQ_NO
         AND B.TAX_AMT != 0
         AND B.ISS_CD = C.ISS_CD
         AND B.LINE_CD = C.LINE_CD
         AND B.TAX_CD   = C.TAX_CD
         AND b.tax_id = c.tax_id -- bonok :: SR 19563 :: UCPB Fullweb
         AND POLICY_ID = p_policy_id)
    LOOP
       
       v_taxes2.policy_id        := i.policy_id;
       v_taxes2.tax_desc         := i.tax_desc;
       v_taxes2.tax_amt          := i.tax_amt;        
       PIPE ROW (v_taxes2);
    END LOOP;
  
  END Populate_text_for_Taxes2; 
  --abie 06092011
  --end
  
   FUNCTION Populate_text_for_G13bond (p_extract_id    GIXX_POLBASIC.extract_id%TYPE)   
        RETURN g13bond_tab PIPELINED
    
      IS
        v_g13bond       g13bond_type;
  
  BEGIN
  
    FOR i IN (SELECT A.assd_name,
                     LTRIM(RTRIM(P.address1||''||P.address2||''||
                     P.address3)) address,
                     get_policy_no(P.policy_id) policy_no,
                     P.tsi_amt,
                     to_char(P.incept_date,'fmMonth DD, yyyy') incept_date, --* Added by Windell ON May 12, 2011   
                     to_char(P.expiry_date,'fmMonth DD, yyyy') expiry_date, --* Revised by Windell ON May 12, 2011  
                     TO_CHAR(NVL(P.tsi_amt,0), '999,999,999,990.99') tsi_chr, --* Added by Windell ON April 06, 2011; Converts currency to a formatted character/string
                     DH_UTIL.SPELL(NVL(P.tsi_amt,0)) tsi_word_dh, --* Added by Windell ON April 06, 2011; Uses DH_UTIL.SPELL Function to spell out numbers
                     s.prin_signor, s.designation,
                     b.contract_date, 
                     TO_CHAR(b.contract_date, 'Fmddth') contract_day, --* Revised by Windell ON April 06, 2011; Added 'Fm' in format string to remove [unnecessary] trailing zeroes
                     NVL(TO_CHAR(b.contract_date,'fmMonth, yyyy '),'_____________,_______') contract_mon_year,
                     b.contract_dtl,
                     b.bond_dtl, P.issue_date, 
                     TO_CHAR(P.issue_date, 'Fmddth') issue_day, --* Revised by Windell ON April 06, 2011; Added 'Fm' in format string to remove [unnecessary] trailing zeroes
                     NVL(TO_CHAR(P.issue_date,'fmMonth, yyyy '),'_____________,_______') issue_mon_year,    
                     h.obligee_name,
                     LTRIM(RTRIM(h.address1||''||h.address2||''||
                     h.address3)) o_address, s.issue_place, P.prem_amt, 
                     P.policy_id, P.ref_pol_no, n.np_no, n.np_name, n.ptr_no, 
                     n.expiry_date np_expiry_date, n.place_issue, s.res_cert, 
                     s.issue_date s_issue_date,
                     ltrim(rtrim(to_char(P.endt_seq_no,'09'))) endt_seq_no, 
                     y.clause_desc, P.iss_cd, s.address s_address,
                     SUBSTR(TO_CHAR(P.tsi_amt,'999,999,999,990.99'),-2,3)||'/100' cents,
                     SUBSTR(TO_CHAR(P.tsi_amt,'999,999,999,990.99'),-6,3) hundreds,
                     SUBSTR(TO_CHAR(P.tsi_amt,'999,999,999,990.99'),-10,3) thousands,
                     SUBSTR(TO_CHAR(P.tsi_amt,'999,999,999,990.99'),-14,3) millions,
                     P.issue_date  pol_iss_dt,
                     P.subline_cd, sl.subline_name --* Added by Windell ON May 12, 2011
                FROM giis_assured A,
                     giis_prin_signtry s,
                     gixx_bond_basic b,
                     giis_obligee h,
                     gixx_polbasic P,
                     giis_notary_public n,
                     giis_bond_class_clause y,
                     giis_subline sl  --* Added by Windell ON May 12, 2011
               WHERE 1 = 1
                     --AND a.assd_no          = s.assd_no(+)            bmq                    
                     AND A.assd_no      = P.assd_no       
                     AND P.extract_id   = b.extract_id(+) --  added (+) by robert 06.14.2013 SR 13376
                     AND b.obligee_no   = h.obligee_no(+) --  added (+) by robert 06.14.2013 SR 13376
                     AND b.np_no        = n.np_no(+)
                     AND P.extract_id   = p_extract_id --* Revised by Windel ON May 19, 2011; Removed NVL
                     AND b.clause_type  = y.clause_type(+) --  added (+) by robert 06.14.2013 SR 13376
                     AND b.prin_id      = s.prin_id(+)   --* Added by Windell ON April 07, 2011 
                     AND P.subline_cd   = sl.subline_cd --* Added by Windell ON May 12, 2011
           )          
     LOOP   
        v_g13bond.assd_name         := i.assd_name;
        v_g13bond.address           := i.address;
        v_g13bond.policy_no         := i.policy_no;
        v_g13bond.incept_date       := i.incept_date;  --* Added by Windell ON May 12, 2011  
        v_g13bond.expiry_date       := i.expiry_date;
        v_g13bond.tsi_amt           := i.tsi_amt;
        v_g13bond.tsi_word_dh       := i.tsi_word_dh;  --* Added by Windell ON April 06, 2011; Uses DH_UTIL.SPELL Function to spell out numbers
        v_g13bond.tsi_chr           := i.tsi_chr; --* Added by Windell ON April 06, 2011; Converts currency to a formatted character/string
        v_g13bond.prin_signor       := i.prin_signor;
        v_g13bond.prin_designation  := i.designation; --* WSV; 05/12/11; Renamed to prin_designation
        v_g13bond.contract_date     := i.contract_date;
        v_g13bond.contract_day       := i.contract_day;
        v_g13bond.contract_mon_year := i.contract_mon_year;
        v_g13bond.contract_dtl      := i.contract_dtl;
        v_g13bond.bond_dtl          := i.bond_dtl;
        v_g13bond.issue_date        := i.issue_date;
        v_g13bond.issue_day         := i.issue_day;
        v_g13bond.issue_mon_year    := i.issue_mon_year;
        v_g13bond.obligee_name      := i.obligee_name;
        v_g13bond.o_address         := i.o_address;
        v_g13bond.issue_place       := i.issue_place;
        v_g13bond.prem_amt          := i.prem_amt;
        v_g13bond.policy_id         := i.policy_id;
        v_g13bond.ref_pol_no        := NVL(i.ref_pol_no,'_______________');--* WSV; 05/12/11
        v_g13bond.np_no             := i.np_no;
        v_g13bond.np_name           := i.np_name;
        v_g13bond.np_expiry_date    := i.np_expiry_date;
        v_g13bond.ptr_no            := i.ptr_no; 
        v_g13bond.place_issue       := i.place_issue;
        v_g13bond.res_cert          := i.res_cert;
        v_g13bond.s_issue_date      := i.s_issue_date;
        v_g13bond.endt_seq_no       := i.endt_seq_no;
        v_g13bond.clause_desc       := i.clause_desc;
        v_g13bond.iss_cd            := i.iss_cd;
        v_g13bond.s_address         := i.s_address;
        v_g13bond.cents             := i.cents;
        v_g13bond.hundreds          := i.hundreds;
        v_g13bond.thousands         := i.thousands;
        v_g13bond.millions          := i.millions;
        v_g13bond.pol_iss_dt        := i.pol_iss_dt;
        v_g13bond.tsiamt_word       := populate_text_for_bond_doc.get_spelled_number(i.tsi_amt);
        v_g13bond.subline_cd        := i.subline_cd;   --* Added by Windell ON May 12, 2011
        v_g13bond.subline_name      := i.subline_name; --* Added by Windell ON May 12, 2011
        
        PIPE ROW (v_g13bond);
        
      END LOOP;
  
  END Populate_text_for_G13bond;


    
FUNCTION Populate_text_for_Signatory (p_iss_cd    GIIS_SIGNATORY.iss_cd%TYPE)  
        RETURN signatory_tab PIPELINED
    
      IS
        v_signatory    signatory_type;
        v_count        number:=0;-----------------(gino) added so that rowcount<>0 when joined with other table
  
  BEGIN

    FOR i IN (SELECT b.signatory, b.designation
                    ,b.res_cert_no, b.res_cert_place, b.res_cert_date, b.remarks
                    -- abie 06102011 added columns for company details
                    ,GIISP.V('COMPANY_NAME') COMP_NAME, 
                    GIISP.V('COMPANY_SHORT_NAME') COMP_SNAME, 
                    GIISP.V('COMPANY_ADDRESS') COMP_ADDRESS, 
                    GIISP.V('COMPANY_TIN') COMP_TIN
                    -- end
                  FROM giis_signatory A,
                        giis_signatory_names b
                 WHERE A.line_cd = 'SU'
                     AND A.iss_cd = nvl(p_iss_cd, A.iss_cd)
                     AND A.report_id = 'BONDS'
                     AND NVL(A.current_signatory_sw,'N') = 'Y'
                     AND A.signatory_id = b.signatory_id
                     --AND ROWNUM = 1
                 )
    LOOP
        v_count := v_count+1;
          v_signatory.signatory       := i.signatory;
          v_signatory.designation   := i.designation;
          v_signatory.res_cert_no   := i.res_cert_no;
        v_signatory.res_cert_place:= i.res_cert_place;
        v_signatory.res_cert_date := NVL(TO_CHAR(i.res_cert_date,'dd fmMONTH, yyyy'),'________________,________'); --* Revised by Windell; May 6, 2011; Added NVL
        v_signatory.comp_name      := i.comp_name;
        v_signatory.comp_sname      := i.comp_sname;
        v_signatory.comp_address       := i.comp_address;
        v_signatory.comp_tin      := i.comp_tin;
        v_signatory.sign_remarks    := i.remarks;
       PIPE ROW (v_signatory);
    END LOOP;
    IF  v_count=0 THEN----------------------------------------------------------added by gino
          v_signatory.signatory       := '___________';
          v_signatory.designation   := '___________';
          v_signatory.res_cert_no   := '___________';
        v_signatory.res_cert_place:= '___________';
        v_signatory.res_cert_date := NULL;
    PIPE ROW (v_signatory);
    END IF;
  
  END Populate_text_for_Signatory;
  
  
  FUNCTION get_spelled_number(p_number IN varchar2) RETURN varchar2 AS
  --
  TYPE string_array IS TABLE OF varchar2(255);
  --
  /*
  Modified:    07/05/2011  BMQ
  Description:    avoid displaying 00/100
                added the word ONLY
  */
  v_string  string_array := string_array('',
                                         ' THOUSAND ',      ' MILLION ',
                                         ' BILLION ',       ' TRILLION ',
                                         ' QUADRILLION ',   ' QUINTILLION ',
                                         ' SEXTILLION ',    ' SEPTILLION ',
                                         ' OCTILLION ',     ' NONILLION ',
                                         ' DECILLION ',     ' UNDECILLION ',
                                         ' DUODECILLION ',  ' TRIDECILLION ',
                                         ' QUADDECILLION ', ' QUINDECILLION ',
                                         ' SEXDECILLION ',  ' SEPTDECILLION ',
                                         ' OCTDECILLION ',  ' NONDECILLION ',
                                         ' DEDECILLION ');
  v_number  varchar2(255);
  v_return  varchar2(4000);
  -- 07/05/2011    added variable to handle decimal places
  v_dec        varchar2(255);
  v_dec2    varchar2(255);
  v_dec_f   varchar2(255);
BEGIN
  IF instr(p_number, '.') = 0 THEN
    v_number := p_number;
  ELSE
    v_number := substr(p_number, 1, instr(p_number, '.')-1);
    v_dec     := ltrim(rpad(substr(p_number, instr(p_number, '.')+1, 2), 2, '0'), 0);
    v_dec2     := substr(p_number, instr(p_number, '.')+3);
  END IF;
  --
  IF v_number = '0'
        OR v_number IS NULL THEN
    --v_return := 'zero';    comment out 07/05/2011
    v_return := NULL;
  ELSE
    FOR i IN 1 .. v_string.count
    LOOP
      exit WHEN v_number IS NULL;
      --
      IF (substr(v_number, length(v_number)-2, 3) <> 0) THEN
        v_return := upper(to_char(to_date(substr(v_number, length(v_number)-2, 3), 'j'), 'jsp')) ||
                    v_string(i) ||
                    v_return;
      END IF;
      v_number := substr(v_number, 1, length(v_number)-3);
    END LOOP;
  END IF;

  -- to include decimal places.
  IF v_dec2 = '0' OR v_dec2 is null then
    v_dec2     := NULL;
  ELSE
    v_dec2     := '.' || v_dec2;
  END IF;

  IF v_dec = '0' OR v_dec is null then
    IF v_dec2 IS NOT NULL THEN
        v_dec_f := ' AND 0' || v_dec2 || '/100';
    ELSE 
        v_dec_f    := NULL;--' AND ' || v_dec2 || '/100';
    END IF;
  ELSE
    v_dec_f    := ' AND ' || v_dec || v_dec2 || '/100';
  END IF;
  /*    07/05/2011
  IF p_number LIKE '%.%' THEN
    v_number := substr(p_number, instr(p_number, '.')+1);
    v_return := v_return ||' AND';
    FOR i IN 1 .. length(v_number)
    LOOP
      exit WHEN v_number IS NULL;
      IF substr(v_number, 1, 1) = '0' THEN
        v_return := v_return ||' zero';
      ELSE
        v_return := v_return ||' '||v_number||'/100';
      END IF;
      RETURN v_return;
    END LOOP;
  ELSE
    IF v_number IS NULL THEN
        v_return := v_return||' AND 00/100';
    ELSE
      v_return := v_return||' '||v_number||'/100';
    END IF;
  */  
  RETURN v_return || v_dec_f;
  
END get_spelled_number;


  FUNCTION Populate_text_for_G02bond (p_extract_id    GIXX_POLBASIC.extract_id%TYPE) 
    RETURN g02bond_tab PIPELINED
  
  IS
  
      v_g02bond       g02bond_type;
  
  BEGIN
  
    FOR i IN (SELECT A.assd_name,
                     LTRIM(RTRIM(A.bill_addr1||''||
                     A.bill_addr2||''||
                     A.bill_addr3)) address,
                     get_policy_no(P.policy_id) policy_no,
                     P.tsi_amt,
                     TO_CHAR(NVL(P.tsi_amt,0), '999,999,999,990.99') tsi_chr, -- Added by Windell ON April 06, 2011; Converts currency to a formatted character/string
                     DH_UTIL.SPELL(NVL(P.tsi_amt,0)) tsi_word_dh, -- Added by Windell ON April 06, 2011; Uses DH_UTIL.SPELL Function to spell out numbers
                     s.prin_signor,
                     s.designation p_designation,
                     NVL(TO_CHAR(b.contract_date,'fmMonth dd, yyyy '),'____________________,________') contract_date,
                     NVL(TO_CHAR(b.contract_date,'HH:MI:SS a.m.'),'___________________') contract_time, 
                     --NVL(b.bond_dtl,'_____________________________________________________________________') bond_dtl,
                     b.bond_dtl,
                     NVL(TO_CHAR(P.issue_date,'Fmddth'),'______') issue_day,--Revised by Windell ON April 06, 2011; Added 'Fm' in format string to remove [unnecessary] trailing zeroes
                     NVL(TO_CHAR(P.issue_date,'yyyy'),'______') issue_year, --Added by Windell ON April 04, 2011 FOR UCPB G2 Bond
                     NVL(TO_CHAR(P.issue_date,'fmMonth yyyy '),'_____________,_______') issue_month_year, --Revised by Windell ON April 04, 2011 FOR UCPB G2 Bond; Removed comma
                     NVL(TO_CHAR(P.issue_date,'fmMonth DD, RRRR'),'___________________') issue_date,    
                     NVL(s.issue_place,'_______________') issue_place,    
                     h.obligee_name,
                     P.prem_amt, 
                     P.policy_id, 
                     P.ref_pol_no,  
                     n.np_name,    
                     n.ptr_no,     
                     n.expiry_date np_expiry_date,
                     n.place_issue,
                     n.remarks,    
                     s.res_cert, 
                     to_char(n.issue_date, 'fmMonth DD, RRRR') np_issue_date,
                     to_char(s.issue_date, 'fmMonth DD, RRRR') s_issue_date, P.iss_cd,
                     c.clause_desc, --Added by Windell ON April 01, 2011 FOR UCPB G2 Bond
                     to_char(P.incept_date,'fmMonth DD, yyyy') incept_date,
                     to_char(P.expiry_date,'fmMonth DD, yyyy') expiry_date,                           
                     P.subline_cd,   --* Added by Windell ON May 12, 2011
                     sl.subline_name, --* Added by Windell ON May 12, 2011
                     get_period_year_day(P.incept_date, P.expiry_date) period
                FROM giis_assured A,
                     giis_prin_signtry s,
                     gixx_bond_basic b,
                     giis_obligee h,
                     gixx_polbasic P,
                     giis_notary_public n,
                     giis_bond_class_clause c, --Added by Windell ON April 01, 2011 FOR UCPB G2 Bond
                     giis_subline sl
               WHERE 1 = 1
                 --AND A.assd_no      = s.assd_no (+)    -- removed by robert 06.14.2013 SR 13376                
                 AND A.assd_no      = P.assd_no                  
                 AND P.extract_id   = b.extract_id (+) -- added (+) by robert 06.14.2013 SR 13376 
                 AND b.obligee_no   = h.obligee_no (+) -- added (+) by robert 06.14.2013 SR 13376 
                 AND b.np_no        = n.np_no(+) 
                 AND P.extract_id   = p_extract_id --* Revised by Windel ON May 19, 2011; Removed NVL
                 AND b.clause_type  = c.clause_type(+) -- added (+) by robert 06.14.2013 SR 13376 --Added by Windell ON April 01, 2011 FOR UCPB G2 Bond 
                 AND b.prin_id      = s.prin_id(+) -- added (+) by robert 06.14.2013 SR 13376 -- Added by Windell ON April 07, 2011               
                 AND P.subline_cd   = sl.subline_cd
                     )
     LOOP

       v_g02bond.assd_name            := i.assd_name;
       v_g02bond.address              := i.address;
       v_g02bond.policy_no            := i.policy_no;    
       v_g02bond.tsi_amt              := i.tsi_amt;
       v_g02bond.tsi_word_dh          := i.tsi_word_dh; -- Added by Windell ON April 06, 2011; Uses DH_UTIL.SPELL Function to spell out numbers    
       v_g02bond.tsi_chr              := i.tsi_chr; -- Added by Windell ON April 06, 2011; Converts currency to a formatted character/string     
       v_g02bond.prin_signor          := i.prin_signor;
       v_g02bond.p_designation        := initcap(i.p_designation);
       v_g02bond.contract_date        := i.contract_date;
       v_g02bond.contract_time        := i.contract_time;
       v_g02bond.bond_dtl             := i.bond_dtl;
       v_g02bond.issue_day            := i.issue_day;
       v_g02bond.issue_year           := i.issue_year; --Added by Windell ON April 04, 2011 FOR UCPB G2 Bond
       v_g02bond.issue_month_year     := i.issue_month_year;
       v_g02bond.issue_date           := i.issue_date;
       v_g02bond.issue_place          := i.issue_place;                      
       v_g02bond.obligee_name         := i.obligee_name;
       v_g02bond.prem_amt             := i.prem_amt;
       v_g02bond.policy_id            := i.policy_id;
       v_g02bond.ref_pol_no           := NVL(i.ref_pol_no,'_______________');--* WSV; 05/12/11
       v_g02bond.np_name              := i.np_name;
       v_g02bond.ptr_no               := i.ptr_no;
       v_g02bond.np_expiry_date       := i.np_expiry_date;
       v_g02bond.place_issue          := i.place_issue;
       v_g02bond.res_cert             := i.res_cert;
       v_g02bond.s_issue_date         := i.s_issue_date;
       v_g02bond.np_issue_date        := i.np_issue_date;
       v_g02bond.iss_cd               := i.iss_cd;
       v_g02bond.tsiamt_word          := populate_text_for_bond_doc.get_spelled_number(i.tsi_amt);
       v_g02bond.clause_desc          := i.clause_desc;  --Added by Windell ON April 01, 2011 FOR UCPB G2 Bond
       v_g02bond.remarks              := i.remarks;      --Added by Windell ON April 04, 2011 FOR UCPB G2 Bond       
       v_g02bond.expiry_date          := i.expiry_date;  --* Added by Windell ON May 12, 2011
       v_g02bond.incept_date          := i.incept_date;  --* Added by Windell ON May 12, 2011
       v_g02bond.subline_cd           := i.subline_cd;   --* Added by Windell ON May 12, 2011
       v_g02bond.subline_name         := i.subline_name; --* Added by Windell ON May 12, 2011
       v_g02bond.period                  := i.period;
       
       PIPE ROW (v_g02bond);
    END LOOP;
  
  END Populate_text_for_G02bond; 
  
  
    FUNCTION Populate_text_for_G07bond (p_policy_id    GIPI_POLBASIC.policy_id%TYPE) 
    RETURN g07bond_tab PIPELINED
  
  IS
  
      v_g07bond       g07bond_type;
  
  BEGIN
  
    FOR i IN (SELECT A.assd_name,
           P.line_cd||'-'||
           P.subline_cd||'-'||
           P.iss_cd||'-'||
           LTRIM(RTRIM(TO_CHAR(P.issue_yy,'00')))||'-'||
           LTRIM(RTRIM(TO_CHAR(P.pol_seq_no,'000000'))) policy_no,
           P.policy_id,
           LTRIM(RTRIM(A.bill_addr1||''||
           A.bill_addr2||''||
           A.bill_addr3)) address,
           NVL(TO_CHAR(P.eff_date,'DDTH'),'________') eff_day,
           NVL(TO_CHAR(P.eff_date,'FMMONTH, YYYY'),'___________________,_______') eff_month_year,        
           NVL(TO_CHAR(P.expiry_date,'DDTH'),'________') expiry_day,
           NVL(TO_CHAR(P.expiry_date,'FMMONTH, YYYY'),'__________________,________') expiry_month_year,
           P.tsi_amt,
           NVL(s.prin_signor, ' ') p_signor,
           NVL(s.designation, ' ') p_designation,
           NVL(TO_CHAR(P.issue_date,'DD FMMONTH, YYYY'),'____________________,________') issue_date,
           NVL(TO_CHAR(P.issue_date,'DDTH'),'________') issue_day,
           NVL(TO_CHAR(P.issue_date,'FMMONTH, YYYY '),'___________________,_______') issue_month_year,    
           P.ref_pol_no,
           P.iss_cd
      FROM giis_assured A,
           giis_prin_signtry s,
           gipi_bond_basic b,
           gipi_polbasic P      
     WHERE 1 = 1
       AND A.assd_no      = s.assd_no (+)                    
       AND A.assd_no      = P.assd_no              
       AND b.policy_id    = P.policy_id
       AND b.prin_id      = s.prin_id(+)
       AND P.policy_id    = p_policy_id --* Revised by Windel ON May 19, 2011; Removed NVL
       )  

     LOOP

        v_g07bond.assd_name           := i.assd_name;
        v_g07bond.policy_no           := i.policy_no;
        v_g07bond.policy_id           := i.policy_id;
        v_g07bond.address             := i.address;
        v_g07bond.eff_day             := i.eff_day;
        v_g07bond.eff_month_year      := i.eff_month_year;
        v_g07bond.expiry_day          := i.expiry_day;
        v_g07bond.expiry_month_year   := i.expiry_month_year;
        v_g07bond.tsi_amt             := i.tsi_amt; 
        v_g07bond.prin_signor         := i.p_signor;
        v_g07bond.p_designation       := i.p_designation;              
        v_g07bond.issue_date          := i.issue_date;
        v_g07bond.issue_day           := i.issue_day;
        v_g07bond.issue_month_year    := i.issue_month_year;
        v_g07bond.v_ref_pol_no        := i.ref_pol_no;
        v_g07bond.iss_cd              := i.iss_cd;
        v_g07bond.tsiamt_word         := populate_text_for_bond_doc.get_spelled_number(i.tsi_amt);
       
       PIPE ROW (v_g07bond);
    END LOOP;
  
  END Populate_text_for_G07bond; 

  FUNCTION Populate_text_for_C07bond (p_policy_id    GIPI_POLBASIC.policy_id%TYPE) 
    RETURN c07bond_tab PIPELINED
  
  IS
  
      v_c07bond       c07bond_type;
  
  BEGIN
  
    FOR i IN (SELECT A.assd_name,
           P.line_cd||'-'||
           P.subline_cd||'-'||
           P.iss_cd||'-'||
           LTRIM(RTRIM(TO_CHAR(P.issue_yy,'00')))||'-'||
           LTRIM(RTRIM(TO_CHAR(P.pol_seq_no,'000000'))) policy_no,
           NVL(TO_CHAR(P.expiry_date,'FMMONTH DD, YYYY'),'____________________,________') expiry_date,
           tsi_amt,
           s.prin_signor,
           s.designation prin_desig,
           NVL(TO_CHAR(P.issue_date,'DDTH'),'_______') issue_day,
           NVL(TO_CHAR(P.issue_date,'FMMONTH, YYYY '),'_____________________,_______') issue_month_year,
           A.assd_name||' of '||A.mail_addr1||' '||A.mail_addr2||' '||A.mail_addr3 assd_name_add,
           z.obligee_name,
           populate_text_for_bond_doc.get_spelled_number(tsi_amt) tsiamt_word,
           TO_CHAR(P.eff_date,'YYYY') eff_year,
           TO_CHAR(P.issue_date,'FMMONTH DD, YYYY') issue_date,
           P.iss_cd
      FROM giis_assured A,
           giis_prin_signtry s,
           gipi_bond_basic b,
           gipi_polbasic P,
           giis_obligee z 
     WHERE 1 = 1
       AND A.assd_no    = s.assd_no (+)                    
       AND A.assd_no     = P.assd_no
       AND b.policy_id  = P.policy_id 
       AND b.obligee_no = z.obligee_no
       AND b.policy_id  = p_policy_id --* Revised by Windel ON May 19, 2011; Removed NVL
       )  

     LOOP

        v_c07bond.assd_name           :=i.assd_name;
        v_c07bond.policy_no           :=i.policy_no;
        v_c07bond.expiry_date         :=i.expiry_date;
        v_c07bond.tsi_amt             :=i.tsi_amt;
        v_c07bond.prin_signor         :=i.prin_signor;
        v_c07bond.prin_desig          :=i.prin_desig;
        v_c07bond.issue_day           :=i.issue_day;
        v_c07bond.issue_month_year    :=i.issue_month_year;
        v_c07bond.assd_name_add       :=i.assd_name_add;
        v_c07bond.obligee_name        :=i.obligee_name;
        v_c07bond.tsiamt_word         :=i.tsiamt_word;
        v_c07bond.eff_year            :=i.eff_year;
        v_c07bond.issue_date          :=i.issue_date;
        v_c07bond.iss_cd              :=i.iss_cd;
       
       PIPE ROW (v_c07bond);
    END LOOP;
  
  END Populate_text_for_C07bond; 
  
  FUNCTION get_comm_computed_prem (p_iss_cd    GIIS_SIGNATORY.iss_cd%TYPE,
                                   p_prem_seq_no  GIPI_COMM_INV_PERIL.prem_seq_no%TYPE
                                  )   
        RETURN comm_computed_prem_tab PIPELINED
    
      IS
        v_comm_computed_prem    comm_computed_prem_type;
  
  BEGIN
                --partial premium
        FOR A IN (SELECT nvl(sum(premium_amt),0) partial_prem
                      FROM giac_direct_prem_collns x
                   WHERE b140_prem_seq_no = p_prem_seq_no
                     AND b140_iss_cd = p_iss_cd
                 AND EXISTS (SELECT 1
                               FROM giac_acctrans y
                              WHERE tran_flag NOT IN ('D')
                                AND tran_id = x.GACC_TRAN_ID) )
        LOOP
          v_comm_computed_prem.partial_prem := A.partial_prem;
        END LOOP;

                --premium
        FOR b IN (SELECT prem_amt
                         FROM GIPI_INVOICE
                        WHERE iss_cd = p_iss_cd
                             AND prem_seq_no = p_prem_seq_no)
        LOOP
          v_comm_computed_prem.prem_amt := b.prem_amt;
        END LOOP;


                --partial commission
        FOR c IN (SELECT NVL(comm_amt,0) partial_comm
                      FROM giac_comm_slip_ext
                       WHERE iss_cd = p_iss_cd
                         AND prem_seq_no = p_prem_seq_no
                         AND comm_slip_tag = 'Y')
        LOOP
         v_comm_computed_prem.partial_comm := c.partial_comm;
        END LOOP;                

                
                --total commission
        FOR d IN ( SELECT (SUM (NVL(gcip.COMMISSION_AMT,0)) - SUM(NVL(gpci.COMMISSION_AMT,0))) total_comm
                 FROM GIPI_COMM_INV_PERIL GCIP, GIAC_PARENT_COMM_INVPRL GPCI
                    WHERE GCIP.INTRMDRY_INTM_NO = GPCI.CHLD_INTM_NO (+)
                      AND GCIP.ISS_CD = GPCI.ISS_CD (+)
                  AND GCIP.PREM_SEQ_NO = GPCI.PREM_SEQ_NO (+)
                  AND GCIP.PERIL_CD = GPCI.PERIL_CD (+)
                  AND GCIP.ISS_CD = p_iss_cd
                  AND GCIP.PREM_SEQ_NO = p_prem_seq_no)
        LOOP
          v_comm_computed_prem.total_comm := d.total_comm;
        END LOOP;
      
        PIPE ROW (v_comm_computed_prem);
 
  END get_comm_computed_prem;
  
  
  FUNCTION Populate_text_for_G18bond (p_extract_id    GIXX_POLBASIC.extract_id%TYPE) 
    RETURN g18bond_tab PIPELINED
  
  IS
  
      v_g18bond       g18bond_type;
  
  BEGIN
  
    FOR i IN (SELECT A.assd_name,
           P.line_cd||'-'||
           P.subline_cd||'-'||
           P.iss_cd||'-'||
           LTRIM(RTRIM(TO_CHAR(P.issue_yy,'00')))||'-'||
           LTRIM(RTRIM(TO_CHAR(P.pol_seq_no,'000000'))) policy_no,
           P.policy_id,
           LTRIM(RTRIM(A.bill_addr1||''||
           A.bill_addr2||''||
           A.bill_addr3)) address,
           NVL(TO_CHAR(P.eff_date,'DDTH'),'________') eff_day,
           NVL(TO_CHAR(P.eff_date,'FMMONTH, YYYY'),'___________________,_______') eff_month_year,        
           NVL(TO_CHAR(P.expiry_date,'DDTH'),'________') expiry_day,
           NVL(TO_CHAR(P.expiry_date,'FMMONTH, YYYY'),'__________________,________') expiry_month_year,
           NVL(TO_CHAR(P.expiry_date,'FMMonth DD, YYYY'),'__________________,________') expiry_date,
           NVL(TO_CHAR(P.incept_date,'FMMonth DD, YYYY'),'__________________,________') incept_date,
           LTRIM(NVL(TO_CHAR(P.tsi_amt,'999,999,999,990.99'), '0.00'),' ') tsi_amt_char,
           P.tsi_amt,
           NVL(s.prin_signor, ' ') p_signor,
           NVL(s.designation, ' ') p_designation,
           NVL(TO_CHAR(P.issue_date,'DD FMMonth, YYYY'),'____________________,________') issue_date,
           NVL(TO_CHAR(P.issue_date,'ddth'),'________') issue_day,
           NVL(TO_CHAR(P.issue_date,'FMMonth YYYY '),'___________________,_______') issue_month_year,    
           RTRIM(NVL(b.bond_dtl,'_____________________________________________________________________'), ' ') bond_dtl,
           NVL(P.ref_pol_no, ' ') ref_pol_no,
           P.iss_cd,
           h.obligee_name,
           P.subline_cd,
           sl.subline_name
           , cc.clause_desc
      FROM giis_assured A,
           giis_prin_signtry s,
           gixx_bond_basic b,
           gixx_polbasic P,
           giis_obligee h,
           giis_subline sl,
           giis_bond_class_clause cc   
     WHERE 1 = 1
       --AND A.assd_no      = s.assd_no (+)                    
       AND b.prin_id      = s.prin_id(+)
       AND A.assd_no      = P.assd_no              
       AND p.extract_id    = b.extract_id(+) -- modified by robert sr 13376 06.14.2013
       AND b.obligee_no   = h.obligee_no(+) -- modified by robert sr 13376 06.14.2013
       AND b.clause_type = cc.clause_type(+) -- modified by robert sr 13376 06.14.2013
       AND P.extract_id    = p_extract_id
       AND P.subline_cd   = sl.subline_cd
       )  

     LOOP

        v_g18bond.assd_name           := i.assd_name;
        v_g18bond.policy_no           := i.policy_no;
        v_g18bond.policy_id           := i.policy_id;
        v_g18bond.address             := i.address;
        v_g18bond.eff_day             := i.eff_day;
        v_g18bond.eff_month_year      := i.eff_month_year;
        v_g18bond.expiry_day          := i.expiry_day;
        v_g18bond.expiry_month_year   := i.expiry_month_year;
        v_g18bond.tsi_amt             := i.tsi_amt; 
        v_g18bond.tsi_amt_char        := i.tsi_amt_char; 
        v_g18bond.prin_signor         := i.p_signor;
        v_g18bond.p_designation       := i.p_designation;              
        v_g18bond.issue_date          := i.issue_date;
        v_g18bond.issue_day           := i.issue_day;
        v_g18bond.issue_month_year    := i.issue_month_year;
        v_g18bond.v_ref_pol_no        := i.ref_pol_no;
        v_g18bond.iss_cd              := i.iss_cd;
        v_g18bond.obligee_name        := i.obligee_name;
        v_g18bond.bond_dtl            := i.bond_dtl;
        v_g18bond.expiry_date         := i.expiry_date;
        v_g18bond.tsiamt_word         := populate_text_for_bond_doc.get_spelled_number(i.tsi_amt);  --07/05/2011
        --v_g18bond.tsiamt_word         :=DH_UTIL.SPELL(i.tsi_amt);       
        v_g18bond.incept_date         := i.incept_date; --* Added by Windell ON May 12, 2011
        v_g18bond.subline_cd          := i.subline_cd; --* Added by Windell ON May 12, 2011
        v_g18bond.subline_name        := i.subline_name; --* Added by Windell ON May 12, 2011
        v_g18bond.clause_desc         := i.clause_desc;
       
       PIPE ROW (v_g18bond);
    END LOOP;
  
  END Populate_text_for_G18bond;
  
/*****************ADDED*BY*WINDELL***********04*05*2011**************C12***********/    
/*   Added by    : Windell Valle
**   Date Created: April 05, 2011
**   last Revised: April 06, 2011
**   Description : Populate C12 Bond Documents
**   Client(s)   : UCPB,...
*/
FUNCTION Populate_text_for_C12bond (p_extract_id    GIXX_POLBASIC.extract_id%TYPE) 
    RETURN C12bond_tab PIPELINED
  
  IS
  
      v_C12bond         C12bond_type;
  
  BEGIN
  
    FOR i IN (SELECT A.assd_name,
                     LTRIM(RTRIM(A.bill_addr1||''||A.bill_addr2||''||A.bill_addr3)) address,
                     get_policy_no(P.policy_id) policy_no,
                     P.subline_cd,
                     sl.subline_name,
                     to_char(P.incept_date,'fmMonth DD, yyyy') incept_date,
                     to_char(P.expiry_date,'fmMonth DD, yyyy') expiry_date,
                     P.tsi_amt,
                     --TO_CHAR(NVL(P.tsi_amt,0), '999,999,999,990.99') tsi_chr, -- Added by Windell ON April 06, 2011; Converts currency to a formatted character/string
                     TO_CHAR(NVL(P.tsi_amt,0), 'fm999,999,999,990.99') tsi_chr,       -- bmq 07282011
                     DH_UTIL.SPELL(NVL(P.tsi_amt,0)) tsi_word_dh, -- Added by Windell ON April 06, 2011; Uses DH_UTIL.SPELL Function to spell out numbers
                     s.prin_signor,
                     s.designation,
                     populate_text_for_bond_doc.get_spelled_number(P.tsi_amt) tsi_word,
                     NVL(TO_CHAR(b.contract_date,'Fmddth'),'______') contract_day,
                     NVL(TO_CHAR(b.contract_date,'fmMonth yyyy'),'_____________,______') contract_month_year, 
                     b.contract_dtl,
                     b.bond_dtl,
                     P.issue_date,
                     NVL(TO_CHAR(P.issue_date,'Fmddth'),'______') issue_day,
                     NVL(TO_CHAR(P.issue_date,'fmMonth yyyy'),'_____________,_______') issue_month_year,
                     h.obligee_name,
                     LTRIM(RTRIM(h.address1||''||h.address2||''||h.address3)) o_address,
                     s.issue_place,
                     P.policy_id,
                     P.ref_pol_no,         
                     s.res_cert,
                     P.iss_cd
                     , b.clause_type
                FROM giis_assured A,
                     giis_prin_signtry s,
                     gixx_bond_basic b,
                     giis_obligee h,
                     gixx_polbasic P,
                     giis_subline sl
               WHERE 1 = 1
                 --AND A.assd_no      = s.assd_no (+)                   
                 AND A.assd_no      = P.assd_no        
                 AND P.extract_id   = b.extract_id(+)  -- modified by robert sr 13376 06.14.2013
                 AND b.obligee_no   = h.obligee_no(+) -- modified by robert sr 13376 06.14.2013
                 AND P.extract_id   = p_extract_id --* Revised by Windel ON May 19, 2011; Removed NVL
                 --AND p.subline_cd = 'C12'
                 AND b.prin_id      = s.prin_id(+)  -- Added by Windell ON April 07, 2011)
                 AND sl.subline_cd  = P.subline_cd (+) --* WSV; 05/11/11
                 ) 
    LOOP
       
       v_C12bond.assd_name            := i.assd_name;
       v_C12bond.address              := i.address;
       v_C12bond.policy_no            := i.policy_no;    
       v_C12bond.incept_date          := i.incept_date;
       v_C12bond.expiry_date          := i.expiry_date;
       v_C12bond.subline_cd           := i.subline_cd;
       v_C12bond.subline_name         := i.subline_name;
       v_C12bond.tsi_amt              := i.tsi_amt;
       v_C12bond.tsi_word_dh          := i.tsi_word_dh;
       v_C12bond.tsi_word             := i.tsi_word;    
       v_C12bond.tsi_chr              := i.tsi_chr;
       v_C12bond.prin_signor          := i.prin_signor;  
       v_C12bond.prin_designation     := i.designation;  --* WSV; 05/11/11
       v_C12bond.contract_day         := i.contract_day;
       v_C12bond.contract_month_year  := i.contract_month_year;
       v_C12bond.contract_dtl         := i.contract_dtl;
       v_C12bond.bond_dtl             := i.bond_dtl;
       v_C12bond.issue_date           := i.issue_date;
       v_C12bond.issue_day            := i.issue_day;   
       v_C12bond.issue_month_year     := i.issue_month_year;                         
       v_C12bond.obligee_name         := i.obligee_name;
       v_C12bond.o_address            := i.o_address;
       v_C12bond.issue_place          := i.issue_place;
       v_C12bond.policy_id            := i.policy_id;
       v_C12bond.ref_pol_no           := NVL(i.ref_pol_no,'_______________');--* WSV; 05/11/11
       v_C12bond.res_cert             := i.res_cert;
       v_C12bond.iss_cd               := i.iss_cd;
       v_C12bond.clause_type          := i.clause_type;
       
       PIPE ROW (v_C12bond);
    END LOOP;
  
  END Populate_text_for_C12bond;  
  /*****************ADDED*BY*WINDELL***********04*05*2011**************C12***********/

  
  
  
FUNCTION Populate_text_for_jcl5bond (p_extract_id    GIXX_POLBASIC.extract_id%TYPE) 
    RETURN jcl5bond_tab PIPELINED
  
  IS
  
      v_jcl5bond         jcl5bond_type;
  
  BEGIN        
  
    FOR i IN (SELECT P.prem_amt, A.assd_name,
                     LTRIM(RTRIM(A.bill_addr1||''||A.bill_addr2||''||A.bill_addr3)) address,
                     get_policy_no(P.policy_id) policy_no, P.subline_cd,
                     to_char(P.expiry_date,'fmMonth DD, yyyy') expiry_date, P.tsi_amt, s.prin_signor, s.designation,
                     to_char(P.incept_date,'fmMonth DD, yyyy') incept_date,  --* Added by Windell ON May 12, 2011
                     populate_text_for_bond_doc.get_spelled_number(P.tsi_amt) tsi_word,
                     NVL(TO_CHAR(b.contract_date,'fmddth'),'______') contract_day,
                     NVL(TO_CHAR(b.contract_date,'fmMonth, yyyy'),'_____________,______') contract_month_year, 
                     b.contract_dtl,
                     b.bond_dtl, P.issue_date,
                     NVL(TO_CHAR(P.issue_date,'fmddth'),'______') issue_day,
                     NVL(TO_CHAR(P.issue_date,'fmMonth, yyyy '),'_____________,_______') issue_month_year,
                     h.obligee_name,
                     LTRIM(RTRIM(h.address1||''||h.address2||''||h.address3)) o_address,
                     s.issue_place, P.policy_id, P.ref_pol_no,         
                     s.res_cert, P.iss_cd,
                     sl.subline_name  --* Added by Windell ON May 12, 2011
                     , b.clause_type 
                FROM giis_assured A,
                     giis_prin_signtry s,
                     gixx_bond_basic b,
                     giis_obligee h,
                     gixx_polbasic P,
                     giis_subline sl
               WHERE 1 = 1
                 --AND A.assd_no      = s.assd_no (+)                   
                 AND A.assd_no      = P.assd_no        
                 AND P.extract_id   = b.extract_id(+) -- modified by robert sr 13376 06.14.2013
                 AND b.obligee_no   = h.obligee_no(+) -- modified by robert sr 13376 06.14.2013
                  AND b.prin_id     = s.prin_id(+)
                 AND P.extract_id   = p_extract_id    --* Revised by Windell ON May 12, 2011; Removed NVL 
                 AND P.subline_cd   = sl.subline_cd  --* Added by Windell ON May 12, 2011
                 )
    LOOP
       
       v_jcl5bond.prem_amt             := i.prem_amt;
       v_jcl5bond.assd_name            := i.assd_name;
       v_jcl5bond.address              := i.address;
       v_jcl5bond.policy_no            := i.policy_no;    
       v_jcl5bond.incept_date          := i.incept_date; --* Added by Windell ON May 12, 2011
       v_jcl5bond.expiry_date          := i.expiry_date;
       v_jcl5bond.subline_cd           := i.subline_cd;
       v_jcl5bond.subline_name         := i.subline_name;   -- bmq 07282011 modified   i.subline_cd; --* Added by Windell ON May 12, 2011
       v_jcl5bond.tsi_amt              := i.tsi_amt;
       v_jcl5bond.tsi_word             := i.tsi_word;    
       v_jcl5bond.prin_signor          := i.prin_signor;
       v_jcl5bond.designation          := i.designation;
       v_jcl5bond.contract_day         := i.contract_day;
       v_jcl5bond.contract_month_year  := i.contract_month_year;
       v_jcl5bond.contract_dtl         := i.contract_dtl;
       v_jcl5bond.bond_dtl             := i.bond_dtl;
       v_jcl5bond.issue_date           := i.issue_date;
       v_jcl5bond.issue_day            := i.issue_day;   
       v_jcl5bond.issue_month_year     := i.issue_month_year;                         
       v_jcl5bond.obligee_name         := i.obligee_name;
       v_jcl5bond.o_address            := i.o_address;
       v_jcl5bond.issue_place          := get_pol_issue_place(i.iss_cd);   -- bmq 07282011    i.issue_place;
       v_jcl5bond.policy_id            := i.policy_id;
       v_jcl5bond.ref_pol_no           := i.ref_pol_no;
       v_jcl5bond.res_cert             := i.res_cert;
       v_jcl5bond.iss_cd               := i.iss_cd;
       v_jcl5bond.clause_type          := i.clause_type;
       
       PIPE ROW (v_jcl5bond);
    END LOOP;
  
  END Populate_text_for_jcl5bond; 

  FUNCTION Populate_text_for_G05bond (p_extract_id    GIXX_POLBASIC.extract_id%TYPE) 
    RETURN g05bond_tab PIPELINED
  
  IS
  
      v_g05bond         g05bond_type;
  
  BEGIN
  
    FOR i IN (SELECT P.prem_amt, A.assd_name,
                     LTRIM(RTRIM(A.bill_addr1||''||A.bill_addr2||''||A.bill_addr3)) address,
                     get_policy_no(P.policy_id) policy_no, P.subline_cd,
                     to_char(P.eff_date,'fmMonth DD, yyyy') eff_date,
                     to_char(P.expiry_date,'fmMonth DD, yyyy') expiry_date, P.tsi_amt, s.prin_signor, s.designation,
                     populate_text_for_bond_doc.get_spelled_number(P.tsi_amt) tsi_word,
                     NVL(TO_CHAR(b.contract_date,'ddth'),'______') contract_day,
                     NVL(TO_CHAR(b.contract_date,'fmMonth, yyyy'),'_____________,______') contract_month_year, 
                     b.contract_dtl,
                     b.bond_dtl, P.issue_date,
                     NVL(TO_CHAR(P.issue_date,'ddth'),'______') issue_day,
                     NVL(TO_CHAR(P.issue_date,'fmMonth, yyyy '),'_____________,_______') issue_month_year,
                     h.obligee_name,
                     LTRIM(RTRIM(h.address1||''||h.address2||''||h.address3)) o_address,
                     s.issue_place, P.policy_id, P.ref_pol_no,         
                     s.res_cert, P.iss_cd,sl.subline_name,to_char(P.incept_date,'FmMonth Dd, YYYY')incept_date
                FROM giis_assured A,
                     giis_prin_signtry s,
                     gixx_bond_basic b,
                     giis_obligee h,
                     gixx_polbasic P,
                     giis_subline sl
               WHERE 1 = 1
                 --AND A.assd_no      = s.assd_no (+)   -- removed by robert sr 13376 06.14.2013               
                 AND A.assd_no      = P.assd_no        
                 AND P.extract_id   = b.extract_id(+)   -- modified by robert sr 13376 06.14.2013   
                 AND b.obligee_no   = h.obligee_no(+)   -- modified by robert sr 13376 06.14.2013   
                 AND P.extract_id   = p_extract_id  --* Revised by Windell ON May 12, 2011; Removed NVL 
                 AND P.subline_cd   = sl.subline_cd
                 AND b.prin_id      = s.prin_id(+)      -- modified by robert sr 13376 06.14.2013  
                 )
    LOOP
       
       v_g05bond.prem_amt             := i.prem_amt;
       v_g05bond.assd_name            := i.assd_name;
       v_g05bond.address              := i.address;
       v_g05bond.policy_no            := i.policy_no;    
       v_g05bond.expiry_date          := i.expiry_date;
       v_g05bond.subline_cd           := i.subline_cd;
       v_g05bond.tsi_amt              := i.tsi_amt;
       v_g05bond.tsi_word             := i.tsi_word;    
       v_g05bond.prin_signor          := i.prin_signor;
       v_g05bond.designation          := i.designation;
       v_g05bond.contract_day         := i.contract_day;
       v_g05bond.contract_month_year  := i.contract_month_year;
       v_g05bond.contract_dtl         := i.contract_dtl;
       v_g05bond.bond_dtl             := i.bond_dtl;
       v_g05bond.issue_date           := i.issue_date;
       v_g05bond.issue_day            := i.issue_day;   
       v_g05bond.issue_month_year     := i.issue_month_year;                         
       v_g05bond.obligee_name         := i.obligee_name;
       v_g05bond.o_address            := i.o_address;
       v_g05bond.issue_place          := i.issue_place;
       v_g05bond.policy_id            := i.policy_id;
       v_g05bond.ref_pol_no           := i.ref_pol_no;
       v_g05bond.res_cert             := i.res_cert;
       v_g05bond.iss_cd               := i.iss_cd;
       v_g05bond.eff_date             := i.eff_date;
       v_g05bond.subline_name         := i.subline_name;
       v_g05bond.incept_date          := i.incept_date;
       
       PIPE ROW (v_g05bond);
    END LOOP;
  
  END Populate_text_for_G05bond; 
        -----added_by_GINO----- 
FUNCTION populate_text_for_ucpb_g17bond (p_extract_id   gixx_polbasic.extract_id%TYPE
)                                              
   RETURN ucpb_g17bond_tab PIPELINED
IS
   v_ucpb_g17bond   ucpb_g17bond_type;
BEGIN
   FOR i IN
      (SELECT A.assd_name,
              LTRIM (RTRIM (   A.bill_addr1
                            || ''
                            || A.bill_addr2
                            || ''
                            || A.bill_addr3
                           )
                    ) address,
              get_policy_no (P.policy_id) policy_no, P.subline_cd,
              sl.subline_name,
              TO_CHAR (P.incept_date, 'fmMonth DD, yyyy') incept_date,
              TO_CHAR (P.expiry_date, 'fmMonth DD, yyyy') expiry_date,
              P.tsi_amt,
              TO_CHAR (NVL (P.tsi_amt, 0), '999,999,999,990.99') tsi_chr,
              dh_util.spell (NVL (P.tsi_amt, 0)) tsi_word_dh, s.prin_signor,
              s.designation,
              populate_text_for_bond_doc.get_spelled_number
                                                          (P.tsi_amt)
                                                                    tsi_word,
              NVL (TO_CHAR (b.contract_date, 'Fmddth'),
                   '______') contract_day,
              NVL (TO_CHAR (b.contract_date, 'fmMonth yyyy'),
                   '_____________,______'
                  ) contract_month_year,
              b.contract_dtl, b.bond_dtl, P.issue_date,
              NVL (TO_CHAR (P.issue_date, 'Fmddth'), '______') issue_day,
              NVL (TO_CHAR (P.issue_date, 'FmMonth'), '______') issue_month,
              NVL (TO_CHAR (P.issue_date, 'fmMonth, yyyy '),
                   '_____________,_______'
                  ) issue_month_year,
              h.obligee_name,
              LTRIM (RTRIM (h.address1 || '' || h.address2 || '' || h.address3)
                    ) o_address,
              s.issue_place, P.policy_id, P.ref_pol_no, s.res_cert, P.iss_cd,
              b.indemnity_text,
              NVL (TO_CHAR (b.val_period), '_______________') val_period
         FROM giis_assured A,
              giis_prin_signtry s,
              gixx_bond_basic b,
              giis_obligee h,
              gixx_polbasic P,
              giis_subline sl
        WHERE 1 = 1
          --AND P.assd_no = s.assd_no -- removed by robert sr 13376 06.14.2013
          AND A.assd_no = P.assd_no
          AND P.extract_id = b.extract_id(+) -- modified by robert sr 13376 06.14.2013
          AND b.obligee_no = h.obligee_no(+) -- modified by robert sr 13376 06.14.2013
          AND P.extract_id = p_extract_id
          AND sl.subline_cd = P.subline_cd
          AND b.prin_id = s.prin_id (+) -- modified by robert sr 13376 06.14.2013
          )
   LOOP
      v_ucpb_g17bond.assd_name := i.assd_name;
      v_ucpb_g17bond.address := i.address;
      v_ucpb_g17bond.policy_no := i.policy_no;
      v_ucpb_g17bond.expiry_date := i.expiry_date;
      v_ucpb_g17bond.incept_date := i.incept_date;
      v_ucpb_g17bond.subline_cd := i.subline_cd;
      v_ucpb_g17bond.subline_name := i.subline_name;
      v_ucpb_g17bond.tsi_amt := i.tsi_amt;
      v_ucpb_g17bond.tsi_word_dh := i.tsi_word_dh;
      v_ucpb_g17bond.tsi_word := i.tsi_word;
      v_ucpb_g17bond.tsi_chr := i.tsi_chr;
      v_ucpb_g17bond.prin_signor := i.prin_signor;
      v_ucpb_g17bond.designation := i.designation;
      v_ucpb_g17bond.contract_day := i.contract_day;
      v_ucpb_g17bond.contract_month_year := i.contract_month_year;
      v_ucpb_g17bond.contract_dtl := i.contract_dtl;
      v_ucpb_g17bond.bond_dtl := NVL (i.bond_dtl, ' ');
      v_ucpb_g17bond.issue_date := i.issue_date;
      v_ucpb_g17bond.issue_day := i.issue_day;
      v_ucpb_g17bond.issue_month := i.issue_month;
      v_ucpb_g17bond.issue_month_year := i.issue_month_year;
      v_ucpb_g17bond.obligee_name := i.obligee_name;
      v_ucpb_g17bond.o_address := i.o_address;
      v_ucpb_g17bond.issue_place := i.issue_place;
      v_ucpb_g17bond.policy_id := i.policy_id;
      v_ucpb_g17bond.ref_pol_no := NVL (i.ref_pol_no, '_______________');
      v_ucpb_g17bond.res_cert := i.res_cert;
      v_ucpb_g17bond.iss_cd := i.iss_cd;
      v_ucpb_g17bond.indemnity_text :=
                      NVL (i.indemnity_text, '_____________________________');
      v_ucpb_g17bond.val_period := i.val_period;
      PIPE ROW (v_ucpb_g17bond);
   END LOOP;
END populate_text_for_ucpb_g17bond;
                                   ----------------------------end gino 5.6.11

/*****************ADDED*BY*WINDELL***********05*05*2011**************JCL15***********/    
/*   Added by    : Windell Valle
**   Date Created: May 05, 2011
**   Last Revised: May 05, 2011
**   Description : Populate JCL15 Bond Documents
**   Client(s)   : UCPB,...
*/
FUNCTION Populate_text_for_JCL15bond (p_extract_id    GIXX_POLBASIC.extract_id%TYPE) 
    RETURN JCL15bond_tab PIPELINED
  
  IS
  
      v_JCL15bond         JCL15bond_type;
  
  BEGIN
  
    FOR i IN (SELECT A.assd_name,
                     LTRIM(RTRIM(A.bill_addr1||''||A.bill_addr2||''||A.bill_addr3)) address,
                     get_policy_no(P.policy_id) policy_no,
                     P.subline_cd,
                     sl.subline_name,
                     to_char(P.incept_date,'fmMonth DD, yyyy') incept_date,
                     to_char(P.expiry_date,'fmMonth DD, yyyy') expiry_date,
                     P.tsi_amt,
                     TO_CHAR(NVL(P.tsi_amt,0), '999,999,999,990.99') tsi_chr, 
                     DH_UTIL.SPELL(NVL(P.tsi_amt,0)) tsi_word_dh, 
                     s.prin_signor,
                     s.designation,
                     populate_text_for_bond_doc.get_spelled_number(P.tsi_amt) tsi_word,
                     NVL(TO_CHAR(b.contract_date,'Fmddth'),'______') contract_day,
                     NVL(TO_CHAR(b.contract_date,'fmMonth yyyy'),'_____________,______') contract_month_year, 
                     b.contract_dtl,
                     b.bond_dtl,
                     P.issue_date,
                     NVL(TO_CHAR(P.issue_date,'Fmddth'),'______') issue_day,
                     NVL(TO_CHAR(P.issue_date,'fmMonth yyyy'),'_____________,_______') issue_month_year,
                     h.obligee_name,
                     LTRIM(RTRIM(h.address1||''||h.address2||''||h.address3)) o_address,
                     s.issue_place,
                     P.policy_id,
                     P.ref_pol_no,         
                     s.res_cert,
                     P.iss_cd,
                     b.indemnity_text
                FROM giis_assured A,
                     giis_prin_signtry s,
                     gixx_bond_basic b,
                     giis_obligee h,
                     gixx_polbasic P,
                     giis_subline sl
               WHERE 1 = 1
                 --AND A.assd_no      = s.assd_no (+)   -- removed by robert sr 13376 06.14.2013               
                 AND A.assd_no      = P.assd_no    (+)   -- modified by robert sr 13376 06.14.2013       
                 AND P.extract_id    = b.extract_id  (+)   -- modified by robert sr 13376 06.14.2013 
                 AND b.obligee_no   = h.obligee_no (+)   -- modified by robert sr 13376 06.14.2013  
                 AND P.extract_id    = p_extract_id
                 AND sl.subline_cd  = P.subline_cd -- modified by robert sr 13376 06.14.2013          
                 --AND p.subline_cd   = 'JCL15'
                 AND b.prin_id      = s.prin_id(+) -- modified by robert sr 13376 06.14.2013 
                 ) 
    LOOP
       
       v_JCL15bond.assd_name            := i.assd_name;
       v_JCL15bond.address              := i.address;
       v_JCL15bond.policy_no            := i.policy_no;    
       v_JCL15bond.expiry_date          := i.expiry_date;
       v_JCL15bond.incept_date          := i.incept_date;
       v_JCL15bond.subline_cd           := i.subline_cd;
       v_JCL15bond.subline_name         := i.subline_name;
       v_JCL15bond.tsi_amt              := i.tsi_amt;
       v_JCL15bond.tsi_word_dh          := i.tsi_word_dh;
       v_JCL15bond.tsi_word             := i.tsi_word;    
       v_JCL15bond.tsi_chr              := i.tsi_chr;
       v_JCL15bond.prin_signor          := i.prin_signor;
       v_JCL15bond.prin_designation     := i.designation;
       v_JCL15bond.contract_day         := i.contract_day;
       v_JCL15bond.contract_month_year  := i.contract_month_year;
       v_JCL15bond.contract_dtl         := i.contract_dtl;
       v_JCL15bond.bond_dtl             := i.bond_dtl;
       v_JCL15bond.issue_date           := i.issue_date;
       v_JCL15bond.issue_day            := i.issue_day;   
       v_JCL15bond.issue_month_year     := i.issue_month_year;                         
       v_JCL15bond.obligee_name         := i.obligee_name;
       v_JCL15bond.o_address            := i.o_address;
       v_JCL15bond.issue_place            := i.issue_place;
       v_JCL15bond.policy_id            := i.policy_id;
       v_JCL15bond.ref_pol_no           := NVL(i.ref_pol_no,'_______________');
       v_JCL15bond.res_cert             := i.res_cert;
       v_JCL15bond.iss_cd               := i.iss_cd;
       v_JCL15bond.indemnity_text       := NVL(i.indemnity_text, '_____________________________');
       
       
       
       PIPE ROW (v_JCL15bond);
    END LOOP;
  
  END Populate_text_for_JCL15bond;  
  /*****************ADDED*BY*WINDELL***********05*05*2011**************JCL15***********/
  
/*****************ADDED*BY*WINDELL***********05*06*2011**************JCL13***********/    
/*   Added by    : Windell Valle
**   Date Created: May 06, 2011
**   Last Revised: May 06, 2011
**   Description : Populate JCL13 Bond Documents
**   Client(s)   : UCPB,...
*/
FUNCTION Populate_text_for_JCL13bond (p_extract_id    GIXX_POLBASIC.extract_id%TYPE) 
    RETURN JCL13bond_tab PIPELINED
  
  IS
  
      v_JCL13bond         JCL13bond_type;
  
  BEGIN
  
    FOR i IN (SELECT A.assd_name,
                     LTRIM(RTRIM(A.bill_addr1||''||A.bill_addr2||''||A.bill_addr3)) address,
                     get_policy_no(P.policy_id) policy_no,
                     P.subline_cd,
                     sl.subline_name,
                     to_char(P.incept_date,'fmMonth DD, yyyy') incept_date,
                     to_char(P.expiry_date,'fmMonth DD, yyyy') expiry_date,
                     P.tsi_amt,
                     TO_CHAR(NVL(P.tsi_amt,0), '999,999,999,990.99') tsi_chr, 
                     DH_UTIL.SPELL(NVL(P.tsi_amt,0)) tsi_word_dh, 
                     s.prin_signor,
                     s.designation,
                     populate_text_for_bond_doc.get_spelled_number(P.tsi_amt) tsi_word,
                     NVL(TO_CHAR(b.contract_date,'Fmddth'),'______') contract_day,
                     NVL(TO_CHAR(b.contract_date,'fmMonth yyyy'),'_____________,______') contract_month_year, 
                     b.contract_dtl,
                     b.bond_dtl,
                     P.issue_date,
                     NVL(TO_CHAR(P.issue_date,'Fmddth'),'______') issue_day,
                     NVL(TO_CHAR(P.issue_date,'fmMonth yyyy'),'_____________,_______') issue_month_year,
                     h.obligee_name,
                     LTRIM(RTRIM(h.address1||''||h.address2||''||h.address3)) o_address,
                     s.issue_place,
                     P.policy_id,
                     P.ref_pol_no,         
                     s.res_cert,
                     P.iss_cd,
                     b.indemnity_text,
                     b.clause_type
                FROM giis_assured A,
                     giis_prin_signtry s,
                     gixx_bond_basic b,
                     giis_obligee h,
                     gixx_polbasic P,
                     giis_subline sl
               WHERE 1 = 1
                 --AND A.assd_no      = s.assd_no (+)  -- removed by robert sr 13376 06.14.2013        
                 AND A.assd_no      = P.assd_no         
                 AND P.extract_id    = b.extract_id  (+) -- modified by robert sr 13376 06.14.2013
                 AND b.obligee_no   = h.obligee_no (+)  -- modified by robert sr 13376 06.14.2013
                 AND P.extract_id    = p_extract_id
                 AND sl.subline_cd  = P.subline_cd (+)           
                 --AND p.subline_cd   = 'JCL13'
                 AND b.prin_id      = s.prin_id(+) -- modified by robert sr 13376 06.14.2013
                 )
    LOOP
       
       v_JCL13bond.assd_name            := i.assd_name;
       v_JCL13bond.address              := i.address;
       v_JCL13bond.policy_no            := i.policy_no;    
       v_JCL13bond.expiry_date          := i.expiry_date;
       v_JCL13bond.incept_date          := i.incept_date;
       v_JCL13bond.subline_cd           := i.subline_cd;
       v_JCL13bond.subline_name         := i.subline_name;
       v_JCL13bond.tsi_amt              := i.tsi_amt;
       v_JCL13bond.tsi_word_dh          := i.tsi_word_dh;
       v_JCL13bond.tsi_word             := i.tsi_word;    
       v_JCL13bond.tsi_chr              := i.tsi_chr;
       v_JCL13bond.prin_signor          := i.prin_signor;
       v_JCL13bond.prin_designation     := i.designation;
       v_JCL13bond.contract_day         := i.contract_day;
       v_JCL13bond.contract_month_year  := i.contract_month_year;
       v_JCL13bond.contract_dtl         := i.contract_dtl;
       v_JCL13bond.bond_dtl             := NVL(i.bond_dtl, ' ');
       v_JCL13bond.issue_date           := i.issue_date;
       v_JCL13bond.issue_day            := i.issue_day;   
       v_JCL13bond.issue_month_year     := i.issue_month_year;                         
       v_JCL13bond.obligee_name         := i.obligee_name;
       v_JCL13bond.o_address            := i.o_address;
       v_JCL13bond.issue_place            := i.issue_place;
       v_JCL13bond.policy_id            := i.policy_id;
       v_JCL13bond.ref_pol_no           := NVL(i.ref_pol_no,'_______________'); 
       v_JCL13bond.res_cert             := i.res_cert;
       v_JCL13bond.iss_cd               := i.iss_cd;
       --v_JCL13bond.indemnity_text       := NVL(i.indemnity_text, '_____________________________');
       v_JCL13bond.indemnity_text       := i.indemnity_text;    -- to generalize output for other reports using the function 7/5/11
       v_jcl13bond.clause_type          := i.clause_type;
       
       
       
       PIPE ROW (v_JCL13bond);
    END LOOP;
  
  END Populate_text_for_JCL13bond;  
  /*****************ADDED*BY*WINDELL***********05*06*2011**************JCL13***********/  
  
/*****************ADDED*BY*WINDELL***********05*06*2011**************JCL4***********/    
/*   Added by    : Windell Valle
**   Date Created: May 06, 2011
**   Last Revised: May 06, 2011
**   Description : Populate JCL4 Bond Documents
**   Client(s)   : UCPB,...
*/
FUNCTION Populate_text_for_JCL4bond (p_extract_id    GIXX_POLBASIC.extract_id%TYPE) 
    RETURN JCL4bond_tab PIPELINED
  
  IS
  
      v_JCL4bond         JCL4bond_type;
  
  BEGIN
  
    FOR i IN (SELECT A.assd_name,
                     LTRIM(RTRIM(A.bill_addr1||''||A.bill_addr2||''||A.bill_addr3)) address,
                     get_policy_no(P.policy_id) policy_no,
                     P.subline_cd,
                     sl.subline_name,
                     to_char(P.incept_date,'fmMonth DD, yyyy') incept_date,
                     to_char(P.expiry_date,'fmMonth DD, yyyy') expiry_date,
                     P.tsi_amt,
                     TO_CHAR(NVL(P.tsi_amt,0), '999,999,999,990.99') tsi_chr, 
                     DH_UTIL.SPELL(NVL(P.tsi_amt,0)) tsi_word_dh, 
                     s.prin_signor,
                     s.designation,
                     populate_text_for_bond_doc.get_spelled_number(P.tsi_amt) tsi_word,
                     NVL(TO_CHAR(b.contract_date,'Fmddth'),'______') contract_day,
                     NVL(TO_CHAR(b.contract_date,'fmMonth yyyy'),'_____________,______') contract_month_year, 
                     b.contract_dtl,
                     b.bond_dtl,
                     P.issue_date,
                     NVL(TO_CHAR(P.issue_date,'Fmddth'),'______') issue_day,
                     NVL(TO_CHAR(P.issue_date,'fmMonth yyyy'),'_____________,_______') issue_month_year,
                     h.obligee_name,
                     LTRIM(RTRIM(h.address1||''||h.address2||''||h.address3)) o_address,
                     s.issue_place,
                     P.policy_id,
                     P.ref_pol_no,         
                     s.res_cert,
                     P.iss_cd,
                     b.indemnity_text
                FROM giis_assured A,
                     giis_prin_signtry s,
                     gixx_bond_basic b,
                     giis_obligee h,
                     gixx_polbasic P,
                     giis_subline sl
               WHERE 1 = 1
                 -- AND A.assd_no      = s.assd_no (+)  -- removed by robert sr 13376 06.14.2013                
                 AND A.assd_no      = P.assd_no         
                 AND P.extract_id    = b.extract_id  (+)  -- modified by robert sr 13376 06.14.2013 
                 AND b.obligee_no   = h.obligee_no (+)  -- modified by robert sr 13376 06.14.2013 
                 AND P.extract_id    = p_extract_id
                 AND sl.subline_cd  = P.subline_cd  -- modified by robert sr 13376 06.14.2013         
                 --AND p.subline_cd   = 'JCL4'
                 AND b.prin_id      = s.prin_id(+)  -- modified by robert sr 13376 06.14.2013
                 )  
    LOOP
       
       v_JCL4bond.assd_name            := i.assd_name;
       v_JCL4bond.address              := i.address;
       v_JCL4bond.policy_no            := i.policy_no;    
       v_JCL4bond.expiry_date          := i.expiry_date;
       v_JCL4bond.incept_date          := i.incept_date;
       v_JCL4bond.subline_cd           := i.subline_cd;
       v_JCL4bond.subline_name         := i.subline_name;
       v_JCL4bond.tsi_amt              := i.tsi_amt;
       v_JCL4bond.tsi_word_dh          := i.tsi_word_dh;
       v_JCL4bond.tsi_word             := i.tsi_word;    
       v_JCL4bond.tsi_chr              := i.tsi_chr;
       v_JCL4bond.prin_signor          := i.prin_signor;
       v_JCL4bond.prin_designation     := i.designation;
       v_JCL4bond.contract_day         := i.contract_day;
       v_JCL4bond.contract_month_year  := i.contract_month_year;
       v_JCL4bond.contract_dtl         := i.contract_dtl;
       v_JCL4bond.bond_dtl             := NVL(i.bond_dtl, ' ');
       v_JCL4bond.issue_date           := i.issue_date;
       v_JCL4bond.issue_day            := i.issue_day;   
       v_JCL4bond.issue_month_year     := i.issue_month_year;                         
       v_JCL4bond.obligee_name         := i.obligee_name;
       v_JCL4bond.o_address            := i.o_address;
       v_JCL4bond.issue_place          :=  i.issue_place;
       v_JCL4bond.policy_id            := i.policy_id;
       v_JCL4bond.ref_pol_no           := NVL(i.ref_pol_no,'_______________');
       v_JCL4bond.res_cert             := i.res_cert;
       v_JCL4bond.iss_cd               := i.iss_cd;
       v_JCL4bond.indemnity_text       := NVL(i.indemnity_text, '_____________________________');
       
       
       
       PIPE ROW (v_JCL4bond);
    END LOOP;
  
  END Populate_text_for_JCL4bond;  
  /*****************ADDED*BY*WINDELL***********05*06*2011**************JCL4***********/    
  
  
  /*****************ADDED*BY*WINDELL***********05*09*2011**************NOTARYPUBLICDETAILS***********/    
/*   Added by    : Windell Valle
**   Date Created: May 09, 2011
**   Last Revised: May 09, 2011
**   Description : Notary Public Details
**   Client(s)   : UCPB,...
*/
FUNCTION Populate_Notary_Public_Details (p_policy_id    GIPI_POLBASIC.policy_id%TYPE) 
    RETURN notary_public_tab PIPELINED
  
  IS
  
      v_np         notary_public_type;
  
  BEGIN
  
    FOR np IN (
        SELECT d.np_name, d.issue_date, d.expiry_date, d.ptr_no,
               d.place_issue, d.remarks,  
               a.ref_pol_no, a.policy_id, a.iss_cd, a.issue_date pol_issue_date,
               a.subline_cd, a.tsi_amt,
               e.res_cert, 
               to_char(e.issue_date, 'fmMonth DD, RRRR') s_issue_date,
               c.clause_desc
          FROM gipi_polbasic a,
               gipi_bond_basic b,
               giis_bond_class_clause c,
               giis_notary_public d,
               giis_prin_signtry e
         WHERE 1 = 1   
           AND a.policy_id = b.policy_id(+)
           AND b.clause_type = c.clause_type(+)
           AND b.np_no = d.np_no(+)
           AND a.assd_no = e.assd_no(+)
           AND a.policy_id = p_policy_id) 
    LOOP        
        v_np.np_name        := np.np_name;
        v_np.np_issue_date  := np.issue_date;
        v_np.np_issue_year  := To_Char(np.issue_date, 'RRRR');        
        v_np.np_expiry_date := To_Char(np.expiry_date, 'fmMonth DD, RRRR') ;     
        v_np.np_ptr_no      := np.ptr_no;   
        v_np.np_place_issue := np.place_issue;
        v_np.np_remarks     := np.remarks;  
        v_np.ref_pol_no     := np.ref_pol_no; 
        v_np.res_cert       := np.res_cert; 
        v_np.s_issue_date   := np.s_issue_date; 
        v_np.clause_desc    := np.clause_desc; 
        
        v_np.policy_id      := np.policy_id;
        v_np.iss_cd         := np.iss_cd;
        v_np.pol_issue_date := np.pol_issue_date;
        v_np.subline_cd     := np.subline_cd;
        v_np.tsi_amt        := np.tsi_amt;
       
       PIPE ROW (v_np);
    END LOOP;
  
  END Populate_Notary_Public_Details;  
/*****************ADDED*BY*WINDELL***********05*09*2011**************NOTARYPUBLICDETAILS***********/   
 

/*****************ADDED*BY*WINDELL***********05*11*2011**************bond_policy***********/    
/*   Added by    : Windell Valle
**   Date Created: May 12, 2011
**   Last Revised: May 12, 2011
**   Description : For BOND POLICY DOC
**   Client(s)   : UCPB,...
**   Modified by : Abie
**   Revision Date : 06092011
*/

  FUNCTION get_bond_policy (p_policy_id    GIPI_POLBASIC.policy_id%TYPE) 
    RETURN bond_policy_tab PIPELINED
    
    IS v_int bond_policy_type;
    
    BEGIN  
        FOR i IN (SELECT A.policy_id, intrmdry_intm_no, collateral_val,
                         A.line_cd||'-'||A.subline_cd||'-'||A.iss_cd||'-'||
                         LTRIM(RTRIM(TO_CHAR(A.issue_yy,'00')))||'-'||
                         LTRIM(RTRIM(TO_CHAR(A.pol_seq_no,'000000'))) policy_no,
                         TO_CHAR(NVL(A.tsi_amt,0), '999,999,999,990.99') tsi_chr,
                         E.assd_name, LTRIM(RTRIM(A.address1||CHR(10)||A.address2||CHR(10)||
                         A.address3)) address, G.obligee_name, h.subline_name,
                         to_char(A.incept_date,'MM/DD/yyyy')||' To '||to_char(A.expiry_date,'MM/DD/yyyy') contract_period,
                         A.subline_cd||' '||A.ref_pol_no bond_no,
                         populate_text_for_bond_doc.get_spelled_number(A.tsi_amt) tsi_word,
                         f.indemnity_text,
                         NVL(TO_CHAR(A.issue_date,'Fmddth'),'______') issue_day,
                         NVL(TO_CHAR(A.issue_date,'fmMonth yyyy'),'_____________,_______') issue_month_year,
                         A.subline_cd, A.expiry_date, A.iss_cd,
                         a.issue_date, A.PREM_AMT, J.SHORT_NAME , B.PREM_AMT + B.TAX_AMT Total_amt -- columns added by abie 06092011
                    FROM gipi_polbasic A, gipi_invoice b, gipi_comm_invoice c, gipi_coll_par d,
                         giis_assured E, gipi_bond_basic f, giis_obligee G,
                         giis_subline h, 
                         giis_currency j -- abie 06092011
                   WHERE A.policy_id   = b.policy_id   (+)
                     AND A.policy_id   = d.policy_id   (+)
                     AND A.assd_no     = E.assd_no    
                     AND b.iss_cd       = c.iss_cd      (+)
                     AND b.prem_seq_no  = c.prem_seq_no (+)
                     AND A.policy_id    = f.policy_id
                     AND f.obligee_no   = G.obligee_no
                     AND A.subline_cd   = h.subline_cd
                     AND B.CURRENCY_CD = J.MAIN_CURRENCY_CD -- abie 06092011
                     AND A.policy_id   = p_policy_id) 
        LOOP
            v_int.bond_no                 := i.bond_no;
            v_int.policy_no               := i.policy_no;
            v_int.tsi_chr                 := i.tsi_chr;
            v_int.policy_id               := i.policy_id;
            v_int.intrmdry_intm_no        := i.intrmdry_intm_no;
            v_int.collateral              := i.collateral_val;
            v_int.assd_name               := i.assd_name;
            v_int.address                 := i.address;
            v_int.obligee_name            := i.obligee_name;
            v_int.subline_name            := i.subline_name;
            v_int.contract_period         := i.contract_period;
            v_int.tsi_word                := i.tsi_word;
            v_int.indemnity_text          := i.indemnity_text;
            v_int.issue_day               := i.issue_day;
            v_int.issue_month_year        := i.issue_month_year;
            v_int.subline_cd              := i.subline_cd;
            v_int.expiry_date             := i.expiry_date;
            v_int.iss_cd                  := i.iss_cd;
            v_int.issue_date              := i.issue_date; --abie 06092011
            v_int.prem_amt                := i.prem_amt; -- abie 06092011
            v_int.currency                := i.short_name; -- abie 06092011
            v_int.total_amt               := i.total_amt;  -- abie 06092011  
           PIPE ROW (v_int);
        END LOOP;    
    END;


/*****************ADDED*BY*WINDELL***********05*11*2011**************bond_policy***********/ 


/*****************ADDED*BY*WINDELL***********05*18*2011**************indemnity***********/    
/*   Added by    : Windell Valle
**   Date Created: May 18, 2011
**   Last Revised: May 18, 2011
**   Description : For BOND POLICY DOC; Indemnity
**   Client(s)   : UCPB,...
*/

  FUNCTION populate_indemnity(p_policy_id    GIPI_POLBASIC.policy_id%TYPE) 
    RETURN indemnity_tab PIPELINED
    
    IS v_ind indemnity_type;
    
    BEGIN  
        FOR i IN (SELECT DISTINCT 
                         A.assd_name,                    
                         P.tsi_amt,
                         TO_CHAR(NVL(P.tsi_amt,0), '999,999,999,990.00') tsi_chr, 
                         DH_UTIL.SPELL(NVL(P.tsi_amt,0)) tsi_word_dh,    
                         populate_text_for_bond_doc.get_spelled_number(NVL(P.tsi_amt,0)) tsi_word,                    
                         NVL(TO_CHAR(P.issue_date,'Fmddth'),'______') issue_day, 
                         NVL(TO_CHAR(P.issue_date,'yyyy'),'______') issue_year, 
                         NVL(TO_CHAR(P.issue_date,'fmMonth yyyy '),'_____________,_______') issue_month_year,
                         NVL(TO_CHAR(P.issue_date,'fmMonth DD, RRRR'),'___________________') issue_date,   
                         N.issue_date np_issue_date, 
                         P.prem_amt,                         
                         TO_CHAR(NVL(P.prem_amt,0), '999,999,999,990.99') prem_chr, 
                         DH_UTIL.SPELL(NVL(P.prem_amt,0)) prem_word_dh,
                         populate_text_for_bond_doc.get_spelled_number(NVL(P.prem_amt,0)) prem_word
                         , b.indemnity_text indem
                         , NVL(TRIM(p.address1 || ' ' || p.address2 || ' ' || p.address3)
                                ,TRIM(a.mail_addr1 || a.mail_addr2 || a.mail_addr3)) assd_addr
                         , s.prin_signor, s.designation prin_des, z.obligee_name
                    FROM giis_assured A,
                         giis_prin_signtry s,
                         gipi_bond_basic b,
                         gipi_polbasic P,
                         giis_obligee z,
                         giis_notary_public n
                   WHERE 1 = 1
                     --AND A.assd_no    = s.assd_no (+)                    
                     AND A.assd_no    = P.assd_no
                     AND b.np_no     = n.np_no(+)
                     AND b.policy_id  = P.policy_id    
                     AND s.prin_id(+) = b.prin_id                
                     AND z.obligee_no = b.obligee_no
                     AND b.policy_id  = p_policy_id  
                     
                    ) 
        LOOP
            v_ind.assd_name         := i.assd_name;
            v_ind.tsi_amt           := i.tsi_amt;
            v_ind.tsi_word_dh       := i.tsi_word_dh;
            v_ind.tsi_chr           := i.tsi_chr;
            v_ind.prem_amt          := i.prem_amt;
            v_ind.prem_word_dh      := i.prem_word_dh;
            v_ind.prem_chr          := i.prem_chr;
            v_ind.issue_date        := i.issue_date;
            v_ind.issue_day         := i.issue_day;
            v_ind.issue_month_year  := i.issue_month_year;
            v_ind.np_issue_year     := NVL(TO_CHAR(i.np_issue_date,'RRRR'), '_________');
            v_ind.assd_addr         := i.assd_addr;
            v_ind.indemnity_text    := i.indem;
            v_ind.obligee           := i.obligee_name;
            v_ind.prin_signor       := i.prin_signor;
            v_ind.prin_designation  := i.prin_des;
            v_ind.cosignatory       := POPULATE_TEXT_FOR_BOND_DOC.get_cosigner(p_policy_id);
           PIPE ROW (v_ind);
        END LOOP;    
    END;


/*****************ADDED*BY*WINDELL***********05*18*2011**************indemnity***********/ 


/*****************ADDED*BY*WINDELL***********05*19*2011**************bond_acknowledgment***********/    
/*   Added by    : Windell Valle
**   Date Created: May 19, 2011
**   Last Revised: May 19, 2011
**   Description : For BOND POLICY DOC; Bond Acknowledgment
**   Client(s)   : UCPB,...
*/

  FUNCTION populate_bond_acknowledgment(p_policy_id    GIPI_POLBASIC.policy_id%TYPE) 
    RETURN bond_acknowledgment_tab PIPELINED
    
    IS v_ba bond_acknowledgment_type;
    
    BEGIN  
        FOR i IN (
            SELECT a.policy_id,
                   d.prin_signor,
                   d.res_cert,
                   d.issue_place,
                   NVL(TO_CHAR(d.issue_date,'fmMonth, Dd yyyy '),'_____________,_______') s_issue_date,
                   d.remarks -- abie 06162011
              FROM gipi_polbasic a,
                   gipi_bond_basic b,
                   giis_assured c,
                   giis_prin_signtry d
             WHERE 1 = 1   
               AND a.policy_id = b.policy_id(+)
               AND a.assd_no = c.assd_no(+)   
               AND b.prin_id = d.prin_id(+)
               AND a.policy_id = p_policy_id) 
        LOOP
            v_ba.policy_id        := i.policy_id;
            v_ba.prin_signor   := NVL(i.prin_signor,'________________________' );
            v_ba.res_cert      := NVL(i.res_cert, '___________');
            v_ba.issue_place   := NVL(i.issue_place, '_____________________' );
            v_ba.issue_date    := NVL(i.s_issue_date, '_____________' );
            v_ba.remarks       := i.remarks;
                          
           PIPE ROW (v_ba);
        END LOOP;    
    END;

/*****************ADDED*BY*WINDELL***********05*19*2011**************bond_acknowledgment***********/  

  function populate_ack_names (p_policy_id  gipi_polbasic.policy_id%type)
    return bond_ack_names_tab pipelined
    -- used by function get_cosigner on the same package  
    is
        v_cosign      bond_cosign_type;
    begin
        FOR cosign IN (select a.policy_id, a.cosign_id, a.assd_no
                        , b.cosign_name, b.cosign_res_no
                        , DECODE(TO_CHAR(b.cosign_res_date, 'MM-DD-RRRR'), '01-01-1900', null, TO_CHAR(b.cosign_res_date, 'MM-DD-RRRR')) co_iss_dt
                        , DECODE(b.cosign_res_place, '-', null, b.cosign_res_place) co_iss_pl
                        , b.remarks
                        , a.bonds_flag, a.indem_flag 
                        from gipi_cosigntry a, giis_cosignor_res b
                      where a.cosign_id = b.cosign_id
                        and a.policy_id = p_policy_id)
            LOOP
                v_cosign.policy_id  :=  cosign.policy_id;
                v_cosign.assd_no    :=  cosign.assd_no;
                v_cosign.cosign     :=  cosign.cosign_name;
                v_cosign.co_iss_dt  :=  cosign.co_iss_dt;
                v_cosign.co_iss_pl  :=  cosign.co_iss_pl;
                v_cosign.remarks    :=  cosign.remarks;
                v_cosign.id_no      :=  cosign.cosign_res_no;
                v_cosign.report_id  :=  'BONDS'; 
                v_cosign.bonds_flag :=  cosign.bonds_flag;
                v_cosign.indem_flag :=  cosign.indem_flag;
                PIPE ROW(v_cosign);
                
            END LOOP;
    end;

  function get_cosigner (p_policy_id  gipi_polbasic.policy_id%type)
    return VARCHAR2
    is
    v_cosigner          VARCHAR2(2000)  := NULL;
    BEGIN
       FOR co IN (SELECT cosign 
                        FROM table (POPULATE_TEXT_FOR_BOND_DOC.populate_ack_names(p_policy_id))
                        WHERE bonds_flag = 'Y')
       LOOP
            if v_cosigner is not null then
                v_cosigner  := v_cosigner || ', ' || co.cosign;
            else
                v_cosigner  := co.cosign;
            end if;
       END LOOP;
       return v_cosigner;
    END;   
    
  function get_pol_issue_place (p_iss_cd gipi_polbasic.iss_cd%type)
    return varchar2
    is 
        v_return    varchar2(150)   := NULL;
    begin
        for iss in (select remarks 
                        from giis_issource
                      where iss_cd = p_iss_cd)
        LOOP
            v_return    := iss.remarks;
        END LOOP;
                      
        return v_return;
        
    end;
    
  function get_pol_rep (p_policy_id gipi_polbasic.policy_id%type)
    return varchar2    
    is 
        v_pol_rep   varchar2(50)    := NULL;
        
    begin
        for rep in (select get_policy_no(old_policy_id) old_policy
                        from gipi_polnrep
                        where new_policy_id = p_policy_id)
        loop
            v_pol_rep   := rep.old_policy;
        end loop;  
        
        return v_pol_rep;
         
    end;

/* 
 *  Added by:       Christian Santos
 *  Module:         GIPIS091
 *  Date Created:   March 19, 2012
 *  Description:    Fidelity Bond for FGIC
*/ 
  FUNCTION populate_text_for_fido2b (p_policy_id gipi_polbasic.policy_id%type)
  RETURN fido2b_tab PIPELINED IS
    
  v_bond fido2b_type;
  
  BEGIN
    FOR A IN(SELECT a.assd_name,
                    Get_Policy_No (p.policy_id) policy_no,
                    NVL(TO_CHAR(p.tsi_amt,'999,999,999.99'),'____________________') tsi_amt,
                    NVL(dh_util.spell(NVL(p.tsi_amt,0)),'______________') sp_tsi_amt,
                    NVL(TO_CHAR(p.prem_amt,'999,999,999.99'),'___________________') prem_amt,
                    NVL(dh_util.spell(NVL(p.prem_amt,0)),'______________') sp_prem_amt,
                    h.obligee_name,
                    NVL(TO_CHAR(p.incept_date,'ddth'),'______') contract_day, 
                    NVL(TO_CHAR(p.incept_date,'fmMonth, yyyy'),'_____________,______') contract_month_year,
                    NVL(TO_CHAR(p.expiry_date,'dd fmMonth yyyy'),'_____________________,_______') expiry_date,
                    NVL(TO_CHAR(p.eff_date,'dd fmMonth yyyy'),'__________________,_______') eff_date,
                    s.prin_signor,
                    s.designation,    
                    p.ref_pol_no,
                    NVL(b.bond_dtl,'_____________________________________________________________________') bond_dtl,
                    NVL(TO_CHAR(p.issue_date,'ddth'),'______') issue_day,
                    NVL(TO_CHAR(p.issue_date,'fmMonth, yyyy '),'_____________,_______') issue_month_year    
               FROM giis_assured a,
                    giis_prin_signtry s,
                    gipi_bond_basic b,
                    giis_obligee h,
                    gipi_polbasic p
              WHERE 1 = 1
                AND a.assd_no      = s.assd_no (+)                  
                AND a.assd_no      = p.assd_no 
                AND p.policy_id    = b.policy_id
                   AND b.obligee_no   = h.obligee_no
                AND p.subline_cd   IN ('FID02', 'FID2') 
                AND p.policy_id    = p_policy_id)
    
    LOOP
      v_bond.assd_name                  := A.assd_name;
      v_bond.policy_no                  := A.policy_no;
      v_bond.tsi_amt                    := A.tsi_amt;
      v_bond.sp_tsi_amt                 := A.sp_tsi_amt;
      v_bond.prem_amt                   := A.prem_amt;
      v_bond.sp_prem_amt                := A.sp_prem_amt;
      v_bond.obligee_name               := A.obligee_name;
      v_bond.contract_day               := A.contract_day;
      v_bond.contract_month_year        := A.contract_month_year;
      v_bond.expiry_date                := A.expiry_date;
      v_bond.eff_date                   := A.eff_date;
      v_bond.prin_signor                := A.prin_signor;
      v_bond.designation                := A.designation;
      v_bond.ref_pol_no                 := A.ref_pol_no;
      v_bond.bond_dtl                   := A.bond_dtl;
      v_bond.issue_day                  := A.issue_day;
      v_bond.issue_month_year           := A.issue_month_year;
    
      PIPE ROW(v_bond);
    END LOOP;
    
    RETURN;
  END populate_text_for_fido2b;
    
END POPULATE_TEXT_FOR_BOND_DOC;
/
