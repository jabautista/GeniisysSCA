CREATE OR REPLACE PACKAGE BODY CPI.gipi_quote_pkg
AS
   FUNCTION get_gipi_quote (v_quote_id gipi_quote.quote_id%TYPE)
      RETURN gipi_quote_tab PIPELINED
   IS
      v_gipi_quote   gipi_quote_type;
   BEGIN
      FOR i IN
         (SELECT   quote_id, --robert 06-14-2012
                   a.line_cd
                   || '-'
                   || subline_cd
                   || '-'
                   || iss_cd
                   || '-'
                   || TO_CHAR (quotation_yy, '0009')
                   || '-'
                   || TO_CHAR (quotation_no, '000009')
                   || '-'
                   || TO_CHAR (proposal_no, '009') quote_no,
                   assd_name, incept_date, expiry_date, incept_tag,
                   expiry_tag,
                   TRUNC (expiry_date) - TRUNC (incept_date) no_of_days,
                   accept_dt, /*underwriter 05.07.2012*/ a.user_id userid, a.line_cd, menu_line_cd,
                   giis_line_pkg.get_line_name (a.line_cd) line_name,
                   subline_cd,
                   giis_subline_pkg.get_subline_name2
                                                     (a.line_cd,
                                                      subline_cd
                                                     ) subline_name,
                   iss_cd, giis_issource_pkg.get_iss_name (iss_cd) iss_name,
                   quotation_yy, quotation_no, proposal_no, cred_branch,
                   giis_issource_pkg.get_iss_name
                                                (cred_branch)
                                                            cred_branch_name,
                   valid_date,
                   giis_assured_pkg.get_assd_name (acct_of_cd) acct_of,
                   address1, address2, address3, prorate_flag, header,
                   footer, a.remarks, reason_cd,
                   giis_loss_bid_pkg.get_reason_desc (reason_cd) reason_desc,
                   comp_sw, short_rt_percent, acct_of_cd, assd_no, prem_amt,
                   ann_prem_amt, tsi_amt, bank_ref_no,
                   a.account_sw -- Added by Jerome 08.18.2016 SR 5586
              FROM gipi_quote a, giis_line b
             WHERE a.quote_id = v_quote_id AND a.line_cd = b.line_cd
          ORDER BY quote_no)
      LOOP
         v_gipi_quote.quote_id := i.quote_id;  --robert 06-14-2012
         v_gipi_quote.quote_no := i.quote_no;
         v_gipi_quote.assd_name := i.assd_name;
         v_gipi_quote.incept_date := i.incept_date;
         v_gipi_quote.expiry_date := i.expiry_date;
         v_gipi_quote.incept_tag := i.incept_tag;
         v_gipi_quote.expiry_tag := i.expiry_tag;
         v_gipi_quote.no_of_days := i.no_of_days;
         v_gipi_quote.accept_dt := i.accept_dt;
         v_gipi_quote.userid := i.userid;
         v_gipi_quote.line_cd := i.line_cd;
         v_gipi_quote.menu_line_cd := i.menu_line_cd;
         v_gipi_quote.line_name := i.line_name;
         v_gipi_quote.subline_cd := i.subline_cd;
         v_gipi_quote.subline_name := i.subline_name;
         v_gipi_quote.iss_cd := i.iss_cd;
         v_gipi_quote.iss_name := i.iss_name;
         v_gipi_quote.quotation_yy := i.quotation_yy;
         v_gipi_quote.quotation_no := i.quotation_no;
         v_gipi_quote.proposal_no := i.proposal_no;
         v_gipi_quote.cred_branch := i.cred_branch;
         v_gipi_quote.cred_branch_name := i.cred_branch_name;
         v_gipi_quote.valid_date := i.valid_date;
         v_gipi_quote.acct_of := i.acct_of;
         v_gipi_quote.address1 := i.address1;
         v_gipi_quote.address2 := i.address2;
         v_gipi_quote.address3 := i.address3;
         v_gipi_quote.prorate_flag := i.prorate_flag;
         v_gipi_quote.header := i.header;
         v_gipi_quote.footer := i.footer;
         v_gipi_quote.remarks := i.remarks;
         v_gipi_quote.reason_cd := i.reason_cd;
         v_gipi_quote.reason_desc := i.reason_desc;
         v_gipi_quote.comp_sw := i.comp_sw;
         v_gipi_quote.short_rt_percent := i.short_rt_percent;
         v_gipi_quote.acct_of_cd := i.acct_of_cd;
         v_gipi_quote.assd_no := i.assd_no;
         v_gipi_quote.prem_amt := i.prem_amt;
         v_gipi_quote.ann_prem_amt := i.ann_prem_amt;
         v_gipi_quote.tsi_amt := i.tsi_amt;
         v_gipi_quote.bank_ref_no := i.bank_ref_no;
         v_gipi_quote.account_sw := i.account_sw;
         PIPE ROW (v_gipi_quote);
      END LOOP;

      RETURN;
   END get_gipi_quote;

   FUNCTION get_quote_listing (
      p_user                 giis_users.user_id%TYPE, 
      p_module               giis_modules.module_id%TYPE,
      p_line                 giis_line.line_cd%TYPE,
      p_filter_assd_name     gipi_quote.assd_name%type, --added by pjsantos @pcic 09/20/2016, for optimization GENQA 5670
      p_filter_incept_dt     VARCHAR2,                  --added by pjsantos @pcic 09/20/2016, for optimization GENQA 5670
      p_filter_expiry_dt     VARCHAR2,                  --added by pjsantos @pcic 09/20/2016, for optimization GENQA 5670
      p_filter_valid_dt      VARCHAR2,                  --added by pjsantos @pcic 09/20/2016, for optimization GENQA 5670
      p_filter_user_id       VARCHAR2,                  --added by pjsantos @pcic 09/20/2016, for optimization GENQA 5670
      p_filter_quote_no      VARCHAR2,                  --added by pjsantos @pcic 09/20/2016, for optimization GENQA 5670
      p_filter_iss_cd        VARCHAR2,                  --added by pjsantos @pcic 09/20/2016, for optimization GENQA 5670
      p_filter_quotation_yy  VARCHAR2,                  --added by pjsantos @pcic 09/20/2016, for optimization GENQA 5670
      p_filter_quotation_no  VARCHAR2,                  --added by pjsantos @pcic 09/20/2016, for optimization GENQA 5670
      p_filter_proposal_no   VARCHAR2,                  --added by pjsantos @pcic 09/20/2016, for optimization GENQA 5670
      p_filter_remarks       VARCHAR2,                  --added by pjsantos @pcic 09/20/2016, for optimization GENQA 5670
      p_filter_subline_cd    VARCHAR2,                  --added by pjsantos @pcic 09/20/2016, for optimization GENQA 5670
      p_order_by             VARCHAR2,                  --added by pjsantos @pcic 09/20/2016, for optimization GENQA 5670
      p_asc_desc_flag        VARCHAR2,                  --added by pjsantos @pcic 09/20/2016, for optimization GENQA 5670
      p_first_row            NUMBER,                    --added by pjsantos @pcic 09/20/2016, for optimization GENQA 5670
      p_last_row             NUMBER                     --added by pjsantos @pcic 09/20/2016, for optimization GENQA 5670
   )
      RETURN quote_listing_tab PIPELINED
   IS
      v_quote   quote_listing_type;
      v_sql     VARCHAR2(32767);             --added by pjsantos @pcic 09/20/2016, for optimization GENQA 5670
      TYPE      cur_type IS REF CURSOR;      --added by pjsantos @pcic 09/20/2016, for optimization GENQA 5670
      c         cur_type;                    --added by pjsantos @pcic 09/20/2016, for optimization GENQA 5670
   BEGIN/*
      FOR i IN (SELECT   a.quote_id,
                            a.line_cd
                         || '-'
                         || a.subline_cd
                         || '-'
                         || a.iss_cd 
                         || '-'
                         || a.quotation_yy
                         || '-'
                         || TO_CHAR (a.quotation_no, '000009')
                         || '-'
                         || TO_CHAR (a.proposal_no, '009') quote_no,
                         a.assd_name, a.incept_date, a.expiry_date,
                         a.valid_date, a.user_id, a.assd_no, a.accept_dt,
                         a.iss_cd, a.quotation_no, a.quotation_yy,
                         a.proposal_no, a.subline_cd, a.remarks,
                         a.pack_pol_flag, a.pack_quote_id,
                         (SELECT    p.line_cd
                                 || '-'
                                 || p.subline_cd
                                 || '-'
                                 || p.iss_cd
                                 || '-'
                                 || p.quotation_yy
                                 || '-'
                                 || TO_CHAR (p.quotation_no, '000009')
                                 || '-'
                                 || TO_CHAR (p.proposal_no, '009')
                            FROM gipi_pack_quote p
                           WHERE a.pack_quote_id = p.pack_quote_id)
                                                               pack_quote_no
                    FROM gipi_quote a
                   WHERE a.status NOT IN ('D', 'W', 'L', 'P')    -- andrew - 02.02.2012 --added 'L' by robert 12.22.14 --Added 'P' by Jerome 09.19.2016 SR 5646
                     AND a.user_id =
                            (SELECT DECODE (b.all_user_sw,
                                            'Y', a.user_id,
                                            'N', p_user,
                                            p_user
                                           )
                               FROM giis_users b
                              WHERE b.user_id = p_user)
                     -- AND A.status = 'N'
                     -- AND pack_pol_flag IS NULL
                     AND check_user_per_line2 (line_cd,
                                               iss_cd,
                                               p_module,
                                               p_user
                                              ) = 1
                     AND check_user_per_iss_cd2 (p_line,
                                                 iss_cd,
                                                 p_module,
                                                 p_user
                                                ) = 1
                     AND a.line_cd = p_line
                     AND a.pack_quote_id is NULL --added by steven 11.7.2012 so that the Package sub-quotations will not be included in the quotation listing. 
                ORDER BY    a.line_cd
                         || '-'
                         || a.subline_cd
                         || '-'
                         || a.iss_cd
                         || '-'
                         || a.quotation_yy
                         || '-'
                         || TO_CHAR (a.quotation_no, '000009') 
                         || '-'
                         || TO_CHAR (a.proposal_no, '009'),
                         a.accept_dt DESC)
      LOOP
         v_quote.quote_id := i.quote_id;
         v_quote.quote_no := i.quote_no;
         v_quote.assd_name := i.assd_name;
         v_quote.incept_date := i.incept_date;
         v_quote.expiry_date := i.expiry_date;
         v_quote.valid_date := i.valid_date;
         v_quote.user_id := i.user_id;
         v_quote.assd_no := i.assd_no;
         v_quote.accept_dt := i.accept_dt;
         v_quote.iss_cd := i.iss_cd;
         v_quote.quotation_no := i.quotation_no;
         v_quote.quotation_yy := i.quotation_yy;
         v_quote.proposal_no := i.proposal_no;
         v_quote.subline_cd := i.subline_cd;
         v_quote.remarks := i.remarks;        --escape_value_clob(i.remarks);
         v_quote.pack_pol_flag := i.pack_pol_flag;
         v_quote.pack_quote_id := i.pack_quote_id;
         v_quote.pack_quote_no := i.pack_quote_no;
         PIPE ROW (v_quote);
      END LOOP;*/
      /*Comment out by pjsantos 09/20/2016, for optimization GENQA 5670*/
      v_sql := 'SELECT mainsql.*
                   FROM (
                    SELECT COUNT (1) OVER () count_, outersql.* 
                      FROM (
                            SELECT ROWNUM rownum_, innersql.* 
                              FROM (SELECT   a.quote_id,
                            a.line_cd
                         || ''-''
                         || a.subline_cd
                         || ''-''
                         || a.iss_cd
                         || ''-''
                         || a.quotation_yy
                         || ''-''
                         || TO_CHAR (a.quotation_no, ''000009'')
                         || ''-''
                         || TO_CHAR (a.proposal_no, ''009'') quote_no,
                         a.assd_name, a.incept_date, a.expiry_date,
                         a.valid_date, a.user_id, a.assd_no, a.accept_dt,
                         a.iss_cd, a.quotation_no, a.quotation_yy,
                         a.proposal_no, a.subline_cd, a.remarks,
                         a.pack_pol_flag, a.pack_quote_id,
                         (SELECT    p.line_cd
                                 || ''-''
                                 || p.subline_cd
                                 || ''-''
                                 || p.iss_cd
                                 || ''-''
                                 || p.quotation_yy
                                 || ''-''
                                 || TO_CHAR (p.quotation_no, ''000009'')
                                 || ''-''
                                 || TO_CHAR (p.proposal_no, ''009'')
                            FROM gipi_pack_quote p
                           WHERE a.pack_quote_id = p.pack_quote_id)
                                                               pack_quote_no
                    FROM gipi_quote a
                   WHERE a.status NOT IN (''D'', ''W'', ''L'', ''P'', ''X'')    
                     AND a.user_id =
                            (SELECT DECODE (b.all_user_sw,
                                            ''Y'', a.user_id,
                                            ''N'', :p_user,
                                            :p_user
                                           )
                               FROM giis_users b
                              WHERE b.user_id = :p_user)
                      AND EXISTS (SELECT ''X''
                                 FROM TABLE (security_access.get_branch_line (''UW'', :p_module, :p_user_id))
                                WHERE branch_cd = a.iss_cd)
                     AND a.line_cd = :p_line
                     AND a.pack_quote_id is NULL
                     AND UPPER (NVL (assd_name, ''*'')) LIKE
                              UPPER (NVL (:p_filter_assd_name,DECODE (assd_name, NULL, ''*'', assd_name)))
                     AND TRUNC(incept_date) = NVL(TRUNC(TO_DATE(:p_filter_incept_dt, ''MM-DD-YYYY'')), TRUNC(incept_date))
                     AND TRUNC(expiry_date) = NVL(TRUNC(TO_DATE(:p_filter_expiry_dt, ''MM-DD-YYYY'')), TRUNC(expiry_date))
                     AND TRUNC(NVL(valid_date, SYSDATE)) = NVL(TRUNC(TO_DATE(:p_filter_valid_dt, ''MM-DD-YYYY'')), TRUNC(NVL(valid_date, SYSDATE)))
                     AND UPPER(user_id) LIKE UPPER(NVL (:p_filter_user_id, user_Id))
                     AND quotation_no LIKE NVL(:p_filter_quotation_no, quotation_no)
                     AND UPPER(iss_cd)  LIKE UPPER(NVL(:p_filter_iss_cd, iss_cd)) 
                     AND TO_CHAR(''%''||quotation_yy||''%'') = TO_CHAR(NVL(:p_filter_quotation_yy, ''%''||quotation_yy||''%''))                     
                     AND proposal_no LIKE NVL(:p_filter_proposal_no, proposal_no)
                     AND NVL(UPPER(remarks), ''%'') LIKE NVL(UPPER(:p_filter_remarks), ''%'')
                     AND NVL(UPPER(remarks), ''*'') LIKE UPPER (NVL (:p_filter_remarks,DECODE (remarks, NULL, ''*'', remarks)))
                     AND UPPER(subline_cd) LIKE UPPER(NVL(:p_filter_subline_cd, subline_cd)) ';         
          
     IF p_order_by IS NOT NULL
      THEN
        IF p_order_by = 'quoteNo' 
         THEN        
          v_sql := v_sql || ' ORDER BY quote_no ';
        ELSIF  p_order_by = 'assdName'
         THEN
          v_sql := v_sql || ' ORDER BY assd_name ';
        ELSIF  p_order_by = 'remarks'
         THEN
          v_sql := v_sql || ' ORDER BY remarks ';
        ELSIF  p_order_by = 'userId'
         THEN
          v_sql := v_sql || ' ORDER BY user_id '; 
        ELSIF  p_order_by = 'inceptDate'
         THEN
          v_sql := v_sql || ' ORDER BY incept_date ';  
        ELSIF  p_order_by = 'expiryDate'
         THEN
          v_sql := v_sql || ' ORDER BY expiry_date '; 
        ELSIF  p_order_by = 'validDate'
         THEN
          v_sql := v_sql || ' ORDER BY valid_date ';        
        END IF;
        
        IF p_asc_desc_flag IS NOT NULL
        THEN
           v_sql := v_sql || p_asc_desc_flag;
        ELSE
           v_sql := v_sql || ' ASC';
        END IF; 
    END IF;
    
    v_sql := v_sql || ') innersql';
    v_sql := v_sql || ' WHERE UPPER(quote_no) LIKE UPPER(NVL(:p_filter_quote_no, quote_no))) outersql) mainsql WHERE rownum_ BETWEEN '|| p_first_row ||' AND ' || p_last_row;
    
    OPEN C FOR v_sql USING p_user, p_user, p_user, p_module, p_user, p_line, p_filter_assd_name, p_filter_incept_dt, p_filter_expiry_dt,
                           p_filter_valid_dt, p_filter_user_id, p_filter_quote_no, p_filter_iss_cd, p_filter_quotation_yy,  
                           p_filter_proposal_no, p_filter_remarks, p_filter_remarks, p_filter_subline_cd,p_filter_quotation_no; 
    LOOP
      FETCH c INTO 
         v_quote.count_,
         v_quote.rownum_,
         v_quote.quote_id,
         v_quote.quote_no, 
         v_quote.assd_name,
         v_quote.incept_date,
         v_quote.expiry_date,
         v_quote.valid_date,
         v_quote.user_id,
         v_quote.assd_no,
         v_quote.accept_dt,
         v_quote.iss_cd,
         v_quote.quotation_no,
         v_quote.quotation_yy,
         v_quote.proposal_no,
         v_quote.subline_cd,
         v_quote.remarks,
         v_quote.pack_pol_flag,
         v_quote.pack_quote_id, 
         v_quote.pack_quote_no;
       EXIT WHEN c%NOTFOUND;              
         PIPE ROW (v_quote);
      END LOOP;      
      CLOSE c;   
      RETURN;
   END get_quote_listing;
   
   /*
    **  Created by     : Veronica V. Raymundo
    **  Date Created   : 12.13.2012
    **  Reference By   : GIIMM013 - Reassign Quotation
    **  Description    : Retrieve list of valid quotation for reassignment
    */
   
   FUNCTION get_reassign_quote_listing (
      p_user_id                 giis_users.user_id%TYPE,
      p_module_id               giis_modules.module_id%TYPE,
      p_line_cd                 giis_line.line_cd%TYPE,
      /*added by pjsantos 10/18/2016, for optimization GENQA 5780*/
      p_filter_assd_name        VARCHAR2,
      p_filter_incept_date      VARCHAR2,
      p_filter_expiry_date      VARCHAR2,
      p_filter_valid_date       VARCHAR2,
      p_filter_user_id          VARCHAR2,
      p_filter_quote_no         VARCHAR2,
      p_filter_iss_cd           VARCHAR2,
      p_filter_quotation_yy     VARCHAR2,
      p_filter_quotation_no     VARCHAR2,
      p_filter_proposal_no      VARCHAR2,
      p_filter_remarks          VARCHAR2,
      p_filter_subline_cd       VARCHAR2,
      p_order_by                VARCHAR2,      
      p_asc_desc_flag           VARCHAR2,     
      p_first_row               NUMBER,        
      p_last_row                NUMBER 
      /*pjsantos end*/
   )
      RETURN quote_listing_tab PIPELINED
   IS
      v_quote   quote_listing_type;
      /*added by pjsantos 10/18/2016, for optimization GENQA 5786*/
      TYPE cur_type IS REF CURSOR;      
      c        cur_type;                
      v_sql    VARCHAR2(32767);
      /*pjsantos end*/
   BEGIN
      --FOR i IN (
      v_sql:= 'SELECT mainsql.*
  FROM (SELECT COUNT (1) OVER () count_, outersql.*
          FROM (SELECT ROWNUM rownum_, innersql.*
                  FROM (SELECT a.quote_id,
                                                 a.line_cd || ''-''
                                              || a.subline_cd
                                              || ''-''
                                         || a.iss_cd 
                                         || ''-''
                                    || a.quotation_yy
                                    || ''-''
                               || LTRIM(TO_CHAR (a.quotation_no, ''000009''))
                         || ''-''
                         || LTRIM(TO_CHAR (a.proposal_no, ''009'')) quote_no, 
                         a.assd_name, a.incept_date, a.expiry_date,
                         a.valid_date, a.underwriter, a.assd_no, a.accept_dt,a.reason_cd,
                         a.iss_cd, a.quotation_no, a.quotation_yy,
                         a.proposal_no, a.subline_cd, a.remarks,
                         a.pack_pol_flag, a.pack_quote_id,
                         (SELECT    p.line_cd
                                 || ''-''
                                 || p.subline_cd
                                 || ''-''
                                 || p.iss_cd
                                 || ''-''
                                 || p.quotation_yy
                                 || ''-''
                                 || TO_CHAR (p.quotation_no, ''000009'')
                                 || ''-''
                                 || TO_CHAR (p.proposal_no, ''009'')
                            FROM gipi_pack_quote p
                           WHERE p.pack_quote_id = a.pack_quote_id) pack_quote_no
                           , 
                           (SELECT p.line_cd
                             FROM gipi_pack_quote p
                            WHERE p.pack_quote_id = a.pack_quote_id) pack_quote_line_cd
                    FROM gipi_quote a
                   WHERE a.status NOT IN (''D'', ''W'')
                     AND a.user_id =
                            (SELECT DECODE (b.all_user_sw,
                                            ''Y'', a.user_id,
                                            ''N'', :p_user_id,
                                            :p_user_id
                                           )
                               FROM giis_users b
                              WHERE b.user_id = :p_user_id ';
                     /*AND check_user_per_line2 (line_cd,
                                               iss_cd,
                                               p_module_id,
                                               p_user_id
                                              ) = 1
                     AND check_user_per_iss_cd2 (p_line_cd,
                                                 iss_cd,
                                                 p_module_id,
                                                 p_user_id
                                                ) = 1 modified by pjsantos 10/18/2016,for optimization GENQA 5786*/
                 IF p_filter_assd_name IS NOT NULL
                    THEN  
                      v_sql := v_sql || 'AND UPPER (NVL (assd_name, ''*'')) LIKE
                              UPPER (NVL (' ||''''|| p_filter_assd_name||''''|| ',DECODE (assd_name, NULL, ''*'', assd_name)))';
                 END IF;
                 
                 IF p_filter_incept_date IS NOT NULL
                    THEN
                       v_sql := v_sql || ' AND TRUNC(incept_date) = NVL(TRUNC(TO_DATE(' ||''''||REPLACE(p_filter_incept_date,'''','''''')||'''' || ', ''MM-DD-YYYY'')), TRUNC(incept_date)) ';
                 END IF;
                 
                 IF p_filter_expiry_date IS NOT NULL
                    THEN
                       v_sql := v_sql || ' AND TRUNC(expiry_date) = NVL(TRUNC(TO_DATE(' ||''''||REPLACE(p_filter_expiry_date ,'''','''''')||'''' || ', ''MM-DD-YYYY'')), TRUNC(expiry_date)) ';
                 END IF;
                 
                 IF p_filter_valid_date IS NOT NULL
                    THEN
                       v_sql := v_sql || ' AND TRUNC(NVL(valid_date, SYSDATE)) = NVL(TRUNC(TO_DATE('||''''||REPLACE(p_filter_valid_date,'''','''''')||''''||', ''MM-DD-YYYY'')), TRUNC(NVL(valid_date, SYSDATE))) ';
                 END IF;
               
                 IF p_filter_user_id IS NOT NULL
                    THEN
                    
                       v_sql := v_sql || ' AND UPPER(underwriter) LIKE UPPER(NVL ('||''''||p_filter_user_id||''''||', user_Id)) ';
                 END IF;
                 
                 IF p_filter_quote_no IS NOT NULL
                    THEN
                       v_sql := v_sql || ' AND UPPER(a.line_cd || ''-'' || a.subline_cd || ''-''|| a.iss_cd || ''-'' || a.quotation_yy || ''-'' || LTRIM(TO_CHAR (a.quotation_no, ''000009''))
                         || ''-''|| LTRIM(TO_CHAR (a.proposal_no, ''009''))) LIKE UPPER(NVL('||''''||p_filter_quote_no||''''||', a.line_cd || ''-'' || a.subline_cd || ''-''|| a.iss_cd || ''-'' || a.quotation_yy || ''-'' || LTRIM(TO_CHAR (a.quotation_no, ''000009''))
                         || ''-''|| LTRIM(TO_CHAR (a.proposal_no, ''009'')))) ';
                 END IF;     
                 
                 IF p_filter_iss_cd IS NOT NULL
                    THEN                    
                       v_sql := v_sql || ' AND UPPER(iss_cd)  LIKE UPPER(NVL('||''''|| p_filter_iss_cd||''''||', iss_cd)) ';
                 END IF ; 
                 
                 IF p_filter_quotation_yy IS NOT NULL
                    THEN
                       v_sql := v_sql || ' AND quotation_yy = NVL('||''''||p_filter_quotation_yy||''''||', quotation_yy) ';                     
                 END IF;   
                 
                 IF p_filter_quotation_no IS NOT NULL
                    THEN
                       v_sql := v_sql || ' AND quotation_no = NVL('||''''||p_filter_quotation_no||''''||', quotation_no) ';
                 END IF;  
                 
                 IF p_filter_proposal_no IS NOT NULL
                    THEN
                       v_sql := v_sql || ' AND proposal_no = NVL('||''''||p_filter_proposal_no||''''||', proposal_no) ';
                 END IF; 
                 
                 IF p_filter_remarks IS NOT NULL
                    THEN
                       v_sql := v_sql || ' AND NVL(UPPER(remarks), ''%'') LIKE NVL(UPPER('||''''||REPLACE(p_filter_remarks,'''','''''')||''''||'), ''%'') ';
                 END IF; 
                 
                 IF p_filter_remarks IS NOT NULL
                    THEN
                       v_sql := v_sql || ' AND NVL(UPPER(remarks), ''*'') LIKE UPPER (NVL ('||''''||REPLACE(p_filter_remarks,'''','''''')||''''||',DECODE (remarks, NULL, ''*'', remarks)))' ;
                 END IF; 
                 
                 IF p_filter_subline_cd IS NOT NULL
                    THEN
                       v_sql := v_sql || ' AND UPPER(subline_cd) LIKE UPPER(NVL('||''''||p_filter_subline_cd||''''||', subline_cd))' ;
                 END IF;                 
                       
        v_sql := v_sql ||' AND EXISTS (SELECT ''X''
                                 FROM TABLE (security_access.get_branch_line (''UW'','|| ''''||p_module_id||''''||','||''''|| p_user_id||''''||'))
                                WHERE branch_cd = a.iss_cd AND line_cd = '||''''||p_line_cd||''''||')';
        v_sql := v_sql || ' AND a.line_cd = '||''''||p_line_cd||''''||')';
                         
      IF p_order_by IS NOT NULL
      THEN
        IF p_order_by = 'quoteNo'
         THEN        
          v_sql := v_sql || ' ORDER BY quote_no ';
        ELSIF  p_order_by = 'assdName'
         THEN
          v_sql := v_sql || ' ORDER BY assd_name ';
        ELSIF  p_order_by = 'remarks'
         THEN
          v_sql := v_sql || ' ORDER BY remarks ';
        ELSIF  p_order_by = 'userId'
         THEN
          v_sql := v_sql || ' ORDER BY underwriter '; 
        ELSIF  p_order_by = 'inceptDate'
         THEN
          v_sql := v_sql || ' ORDER BY incept_date ';    
        ELSIF  p_order_by = 'expiryDate'
         THEN
          v_sql := v_sql || ' ORDER BY expiry_date ';  
        ELSIF  p_order_by = 'validDate'
         THEN
          v_sql := v_sql || ' ORDER BY valid_date ';         
        END IF;
        
        IF p_asc_desc_flag IS NOT NULL
        THEN
           v_sql := v_sql || p_asc_desc_flag;
        ELSE
           v_sql := v_sql || ' ASC';
        END IF; 
    ELSE
    v_sql:= v_sql || 'ORDER BY    a.line_cd
                         || ''-''
                         || a.subline_cd
                         || ''-''
                         || a.iss_cd
                         || ''-''
                         || a.quotation_yy
                         || ''-''
                         || TO_CHAR (a.quotation_no, ''000009'')
                         || ''-''
                         || TO_CHAR (a.proposal_no, ''009''),
                         a.accept_dt DESC ';
    END IF;
    
    v_sql := v_sql || ') innersql) outersql) mainsql WHERE rownum_ BETWEEN '|| p_first_row ||' AND ' || p_last_row;
    OPEN c FOR v_sql USING p_user_id, p_user_id, p_user_id;
      LOOP
      FETCH c INTO 
         v_quote.count_,
         v_quote.rownum_,
         v_quote.quote_id,      --  := i.quote_id;
         v_quote.quote_no,      --  := i.quote_no;
         v_quote.assd_name ,    --:= i.assd_name;
         v_quote.incept_date,   --:= i.incept_date;
         v_quote.expiry_date,   --:= i.expiry_date;
         v_quote.valid_date,    --:= i.valid_date;
         v_quote.user_id,       --:= i.user_id;
         v_quote.assd_no,       -- := i.assd_no;
         v_quote.accept_dt,     --   := i.accept_dt;
         v_quote.reason_cd,
         v_quote.iss_cd,        --:= i.iss_cd;    
         v_quote.quotation_no,  --:= i.quotation_no;
         v_quote.quotation_yy,  --:= i.quotation_yy;
         v_quote.proposal_no,   --:= i.proposal_no;
         v_quote.subline_cd,    --:= i.subline_cd;
         v_quote.remarks,       -- := i.remarks;
         v_quote.pack_pol_flag, --:= i.pack_pol_flag;
         v_quote.pack_quote_id, --:= i.pack_quote_id;
         v_quote.pack_quote_no,
         v_quote.pack_quote_line_cd;--:= i.pack_quote_no;
         
         -- shan 08.27.2014
        /* v_quote.pack_quote_line_cd := NULL;
         FOR j IN (SELECT p.line_cd
                     FROM gipi_pack_quote p
                    WHERE p.pack_quote_id = i.pack_quote_id) 
         LOOP
            v_quote.pack_quote_line_cd  := j.line_cd;
            EXIT;
         END LOOP; comment out by pjsantos 10/18/2016, for optimization GENQA 5786*/
         -- end 08.27.2014
         
         
         EXIT WHEN c%NOTFOUND;              
         PIPE ROW (v_quote);
      END LOOP;
      CLOSE c;  
      

      RETURN;
   END get_reassign_quote_listing;

   FUNCTION get_filtered_quote_listing (
      p_line           gipi_quote.line_cd%TYPE,
      p_subline        gipi_quote.subline_cd%TYPE,
      p_iss_cd         gipi_quote.iss_cd%TYPE,
      p_quote_yy       gipi_quote.quotation_yy%TYPE,
      p_quote_seq_no   gipi_quote.quotation_no%TYPE,
      p_proposal_no    gipi_quote.proposal_no%TYPE,
      p_assd_name      gipi_quote.assd_name%TYPE,
      p_module         giis_modules.module_id%TYPE,
      p_user_id        giis_users.user_id%TYPE
   )
      RETURN quote_listing_tab PIPELINED
   IS
      v_quote   quote_listing_type;
   BEGIN
      FOR i IN
         (SELECT   a.quote_id,
                      a.line_cd
                   || '-'
                   || a.subline_cd
                   || '-'
                   || a.iss_cd
                   || '-'
                   || a.quotation_yy
                   || '-'
                   || TO_CHAR (a.quotation_no, '000009')
                   || '-'
                   || TO_CHAR (a.proposal_no, '009') quote_no,
                   a.assd_name, a.incept_date, a.expiry_date, a.valid_date,
                   a.user_id, a.assd_no, a.accept_dt, a.reason_cd
              FROM gipi_quote a
             WHERE a.user_id =
                      (SELECT DECODE (b.all_user_sw,
                                      'Y', a.user_id,
                                      'N', USER,
                                      USER
                                     )
                         FROM giis_users b
                        WHERE b.user_id = USER)
               AND a.status = 'N'
               AND pack_pol_flag IS NULL
               AND check_user_per_line2 (line_cd, iss_cd, p_module, p_user_id) =
                                                                             1
               AND check_user_per_iss_cd2 (p_line, iss_cd, p_module,
                                           p_user_id) = 1
               AND a.line_cd = NVL (p_line, a.line_cd)
               AND a.subline_cd = NVL (p_subline, a.subline_cd)
               AND a.iss_cd = NVL (p_iss_cd, a.iss_cd)
               AND a.quotation_yy = NVL (p_quote_yy, a.quotation_yy)
               AND a.quotation_no = NVL (p_quote_seq_no, a.quotation_no)
               AND a.proposal_no = NVL (p_proposal_no, a.proposal_no)
               AND NVL (a.assd_name, '*') LIKE
                         '%'
                      || UPPER (NVL (p_assd_name,
                                     -- edited By Irwin, march 3, 2011
                                     DECODE (a.assd_name,
                                             NULL, '*',
                                             a.assd_name
                                            )
                                    )
                               )
                      || '%'
          --AND a.assd_name LIKE '%'||UPPER(p_assd_name)||'%'
          ORDER BY    a.line_cd
                   || '-'
                   || a.subline_cd
                   || '-'
                   || a.iss_cd
                   || '-'
                   || a.quotation_yy
                   || '-'
                   || TO_CHAR (a.quotation_no, '000009')
                   || '-'
                   || TO_CHAR (a.proposal_no, '009'),
                   accept_dt DESC)
      LOOP
         v_quote.quote_id := i.quote_id;
         v_quote.quote_no := i.quote_no;
         v_quote.assd_name := i.assd_name;
         v_quote.incept_date := i.incept_date;
         v_quote.expiry_date := i.expiry_date;
         v_quote.valid_date := i.valid_date;
         v_quote.user_id := i.user_id;
         v_quote.assd_no := i.assd_no;
         v_quote.accept_dt := i.accept_dt;
         v_quote.reason_cd := i.reason_cd;
         PIPE ROW (v_quote);
      END LOOP;

      RETURN;
   END get_filtered_quote_listing;

   FUNCTION get_checked_quote_list (
      p_iss_cd      giis_issource.iss_cd%TYPE,
      p_module_id   giis_modules.module_id%TYPE,
      p_user_id     giis_users.user_id%TYPE
   )
      RETURN checked_quote_list_tab PIPELINED
   IS
      v_quote   checked_quote_list_type;
   BEGIN
      FOR i IN (SELECT   quote_id, line_cd, iss_cd, subline_cd, quotation_yy,
                         TO_CHAR (quotation_no, '000009') quote_no,
                         TO_CHAR (proposal_no, '009') proposal_no,
                         TO_CHAR (assd_no, '000000000009') assd_no,
                         assd_name
                    FROM gipi_quote
                   WHERE status = 'N'
                     AND iss_cd = p_iss_cd
                     AND check_user_per_line2 (line_cd,
                                               p_iss_cd,
                                               p_module_id,
                                               p_user_id
                                              ) = 1
                ORDER BY line_cd,
                         iss_cd,
                         subline_cd,
                         quotation_yy,
                         TO_CHAR (quotation_no, '000009'),
                         TO_CHAR (proposal_no, '009'))
      LOOP
         v_quote.quote_id := i.quote_id;
         v_quote.line_cd := i.line_cd;
         v_quote.iss_cd := i.iss_cd;
         v_quote.subline_cd := i.subline_cd;
         v_quote.quotation_yy := i.quotation_yy;
         v_quote.quote_no := i.quote_no;
         v_quote.proposal_no := i.proposal_no;
         v_quote.assd_no := i.assd_no;
         v_quote.assd_name := i.assd_name;
         PIPE ROW (v_quote);
      END LOOP;

      RETURN;
   END get_checked_quote_list;

   FUNCTION get_checked_quote_line_list (
      p_line_cd     giis_line.line_cd%TYPE,
      p_iss_cd      giis_issource.iss_cd%TYPE,
      p_module_id   giis_modules.module_id%TYPE,
      p_user_id     giis_users.user_id%TYPE
   )
      RETURN checked_quote_list_tab PIPELINED
   IS
      v_quote   checked_quote_list_type;
   BEGIN
      FOR i IN (SELECT   quote_id, line_cd, subline_cd, iss_cd, quotation_yy,
                         TO_CHAR (quotation_no, '000009') quote_no,
                         TO_CHAR (proposal_no, '009') proposal_no,
                         TO_CHAR (assd_no, '000000000009') assd_no,
                         assd_name
                    FROM gipi_quote
                   WHERE status = 'N'
                     AND line_cd = p_line_cd
                     AND iss_cd = p_iss_cd
                     AND check_user_per_line2 (p_line_cd,
                                               p_iss_cd,
                                               p_module_id,
                                               p_user_id
                                              ) = 1
                ORDER BY line_cd,
                         iss_cd,
                         subline_cd,
                         quotation_yy,
                         TO_CHAR (quotation_no, '000009'),
                         TO_CHAR (proposal_no, '009'))
      LOOP
         v_quote.quote_id := i.quote_id;
         v_quote.line_cd := i.line_cd;
         v_quote.iss_cd := i.iss_cd;
         v_quote.subline_cd := i.subline_cd;
         v_quote.quotation_yy := i.quotation_yy;
         v_quote.quote_no := i.quote_no;
         v_quote.proposal_no := i.proposal_no;
         v_quote.assd_no := i.assd_no;
         v_quote.assd_name := i.assd_name;
         PIPE ROW (v_quote);
      END LOOP;

      RETURN;
   END get_checked_quote_line_list;

   FUNCTION get_quote_list_status (
      p_date_from   gipi_quote.accept_dt%TYPE,
      p_date_to     gipi_quote.accept_dt%TYPE,
      p_status      gipi_quote.status%TYPE,
      p_user        giis_users.user_id%TYPE,
      p_module      giis_modules.module_id%TYPE,
      p_keyword     VARCHAR2
   )
      RETURN quote_list_status_tab PIPELINED
   IS
      v_quote   quote_list_status_type;
   BEGIN
      FOR i IN
         (SELECT   a.quote_id,
                      a.line_cd
                   || '-'
                   || a.subline_cd
                   || '-'
                   || a.iss_cd
                   || '-'
                   || a.quotation_yy
                   || '-'
                   || RTRIM (LTRIM (TO_CHAR (a.quotation_no, '000009')))
                   || '-'
                   || RTRIM (LTRIM (TO_CHAR (a.proposal_no, '009')))
                                                                    quote_no,
                   a.assd_name, a.incept_date, a.expiry_date, a.valid_date,
                   a.user_id, a.assd_no, a.accept_dt,
                   cg_ref_codes_pkg.get_rv_meaning
                                                 ('GIPI_QUOTE.STATUS',
                                                  a.status
                                                 ) status,
                   giis_assured_pkg.get_assd_name (b.assd_no) par_assd,
                   c.reason_desc,
                      b.line_cd
                   || '-'
                   || b.iss_cd
                   || '-'
                   || TO_CHAR (b.par_yy, '09')
                   || '-'
                   || TO_CHAR (par_seq_no, '000009')
                   || '-'
                   || TO_CHAR (b.quote_seq_no, '09') par_no,
                   (SELECT    z.line_cd
                           || '-'
                           || z.subline_cd
                           || '-'
                           || z.iss_cd
                           || '-'
                           || TO_CHAR (z.issue_yy, '09')
                           || '-'
                           || TO_CHAR (z.pol_seq_no, '000009')
                           || '-'
                           || TO_CHAR (z.renew_no, '09')
                      FROM gipi_polbasic z
                     WHERE z.par_id = b.par_id) pol_no
              FROM gipi_quote a, gipi_parlist b, giis_lost_bid c
             WHERE a.user_id =
                      (SELECT DECODE (b.all_user_sw,
                                      'Y', a.user_id,
                                      'N', p_user,
                                      p_user
                                     )
                         FROM giis_users b
                        WHERE b.user_id = p_user)
               AND a.pack_pol_flag IS NULL
               AND a.quote_id = b.quote_id(+)
               AND a.reason_cd = c.reason_cd(+)
               AND check_user_per_line2 (a.line_cd, a.iss_cd, p_module,
                                         p_user) = 1
               AND check_user_per_iss_cd2 (a.line_cd,
                                           a.iss_cd,
                                           p_module,
                                           p_user
                                          ) = 1
               AND a.accept_dt BETWEEN NVL (p_date_from, a.accept_dt)
                                   AND NVL (p_date_to, a.accept_dt)
               AND a.status = NVL (p_status, a.status)
               AND (   a.quote_id LIKE UPPER ('%' || p_keyword || '%')
                    OR a.assd_name LIKE UPPER ('%' || p_keyword || '%')
                    OR a.incept_date LIKE UPPER ('%' || p_keyword || '%')
                    OR a.user_id LIKE UPPER ('%' || p_keyword || '%')
                    OR a.line_cd LIKE UPPER ('%' || p_keyword || '%')
                    OR a.subline_cd LIKE UPPER ('%' || p_keyword || '%')
                    OR a.iss_cd LIKE UPPER ('%' || p_keyword || '%')
                    OR a.quotation_no LIKE UPPER ('%' || p_keyword || '%')
                    OR a.quotation_yy LIKE UPPER ('%' || p_keyword || '%')
                    OR a.proposal_no LIKE UPPER ('%' || p_keyword || '%')
                    OR cg_ref_codes_pkg.get_rv_meaning ('GIPI_QUOTE.STATUS',
                                                        a.status
                                                       ) LIKE
                                               UPPER ('%' || p_keyword || '%')
                   )
          ORDER BY    a.line_cd
                   || '-'
                   || a.subline_cd
                   || '-'
                   || a.iss_cd
                   || '-'
                   || a.quotation_yy
                   || '-'
                   || TO_CHAR (a.quotation_no, '000009')
                   || '-'
                   || TO_CHAR (a.proposal_no, '009'),
                   a.accept_dt DESC)
      LOOP
         v_quote.quote_id := i.quote_id;
         v_quote.quote_no := i.quote_no;
         v_quote.assd_name := i.assd_name;
         v_quote.incept_date := i.incept_date;
         v_quote.expiry_date := i.expiry_date;
         v_quote.valid_date := i.valid_date;
         v_quote.user_id := i.user_id;
         v_quote.assd_no := i.assd_no;
         v_quote.accept_dt := i.accept_dt;
         v_quote.status := i.status;
         v_quote.par_assd := i.par_assd;
         v_quote.reason_desc := i.reason_desc;
         v_quote.par_no := i.par_no;
         v_quote.pol_no := i.pol_no;
         PIPE ROW (v_quote);
      END LOOP;

      RETURN;
   END get_quote_list_status;

   /*
    ** Created by: Whofeih
    ** Created date: 02/12/2010
    */
   PROCEDURE reassign_quotation (
      p_user_id    gipi_quote.user_id%TYPE,
      p_quote_id   gipi_quote.quote_id%TYPE,
      p_remarks    gipi_quote.remarks%TYPE
   )
   IS
   BEGIN
      UPDATE gipi_quote
         SET user_id = p_user_id,
             remarks = p_remarks
       WHERE quote_id = p_quote_id;
   END;

   FUNCTION get_copied_quote_id (p_quote_id gipi_quote.quote_id%TYPE)
      RETURN gipi_quote.copied_quote_id%TYPE
   IS
      v_copied_quote_id   gipi_quote.copied_quote_id%TYPE;
   BEGIN
      FOR i IN (SELECT copied_quote_id
                  FROM gipi_quote
                 WHERE quote_id = p_quote_id)
      LOOP
         v_copied_quote_id := i.copied_quote_id;
         EXIT;
      END LOOP;

      RETURN (v_copied_quote_id);
   END get_copied_quote_id;

   PROCEDURE set_gipi_quote (
      v_quote_id                IN OUT   gipi_quote.quote_id%TYPE,
      v_line_name               IN       giis_line.line_name%TYPE,
      v_subline_name            IN       giis_subline.subline_name%TYPE,
      v_iss_name                IN       giis_issource.iss_name%TYPE,
      v_quotation_yy            IN       gipi_quote.quotation_yy%TYPE,
      v_quotation_no            IN       gipi_quote.quotation_no%TYPE,
      v_proposal_no             IN       gipi_quote.proposal_no%TYPE,
      v_assd_no                 IN       gipi_quote.assd_no%TYPE,
      v_assd_name               IN       gipi_quote.assd_name%TYPE,
      v_tsi_amt                 IN       gipi_quote.tsi_amt%TYPE,
      v_prem_amt                IN       gipi_quote.prem_amt%TYPE,
      v_print_dt                IN       gipi_quote.print_dt%TYPE,
      v_accept_dt               IN       gipi_quote.accept_dt%TYPE,
      v_post_dt                 IN       gipi_quote.post_dt%TYPE,
      v_denied_dt               IN       gipi_quote.denied_dt%TYPE,
      v_status                  IN       gipi_quote.status%TYPE,
      v_print_tag               IN       gipi_quote.print_tag%TYPE,
      v_header                  IN       gipi_quote.header%TYPE,
      v_footer                  IN       gipi_quote.footer%TYPE,
      v_remarks                 IN       gipi_quote.remarks%TYPE,
      v_user_id                 IN       gipi_quote.user_id%TYPE,
      v_last_update             IN       gipi_quote.last_update%TYPE,
      v_cpi_rec_no              IN       gipi_quote.cpi_rec_no%TYPE,
      v_cpi_branch_cd           IN       gipi_quote.cpi_branch_cd%TYPE,
      v_quotation_printed_cnt   IN       gipi_quote.cpi_rec_no%TYPE,
      v_incept_date             IN       gipi_quote.incept_date%TYPE,
      v_expiry_date             IN       gipi_quote.expiry_date%TYPE,
      v_origin                  IN       gipi_quote.origin%TYPE,
      v_reason_cd               IN       gipi_quote.reason_cd%TYPE,
      v_address1                IN       gipi_quote.address1%TYPE,
      v_address2                IN       gipi_quote.address2%TYPE,
      v_address3                IN       gipi_quote.address3%TYPE,
      v_valid_date              IN       gipi_quote.valid_date%TYPE,
      v_prorate_flag            IN       gipi_quote.prorate_flag%TYPE,
      v_short_rt_percent        IN       gipi_quote.short_rt_percent%TYPE,
      v_comp_sw                 IN       gipi_quote.comp_sw%TYPE,
      v_underwriter             IN       gipi_quote.underwriter%TYPE,
      v_insp_no                 IN       gipi_quote.insp_no%TYPE,
      v_ann_prem_amt            IN       gipi_quote.ann_prem_amt%TYPE,
      v_ann_tsi_amt             IN       gipi_quote.ann_tsi_amt%TYPE,
      v_with_tariff_sw          IN       gipi_quote.with_tariff_sw%TYPE,
      v_incept_tag              IN       gipi_quote.incept_tag%TYPE,
      v_expiry_tag              IN       gipi_quote.expiry_tag%TYPE,
      v_cred_branch             IN       giis_issource.iss_name%TYPE,
      v_acct_of_cd              IN       gipi_quote.acct_of_cd%TYPE,
      v_acct_of_cd_sw           IN       gipi_quote.acct_of_cd_sw%TYPE,
      v_pack_quote_id           IN       gipi_quote.pack_quote_id%TYPE,
      v_pack_pol_flag           IN       gipi_quote.pack_pol_flag%TYPE
      ,v_bank_ref_no            IN       gipi_quote.bank_ref_no%TYPE    --added by Gzelle 12.12.2013 SR398
   )
   IS
      v_exist     VARCHAR2 (1)               := 'N';
      var_quote   gipi_quote.quote_id%TYPE;
      v_line_cd   gipi_quote.line_cd%TYPE;
      v_short_rt_percent_temp   gipi_quote.short_rt_percent%TYPE;
      v_reason_cd_temp            gipi_quote.reason_cd%TYPE;
      v_acct_of_cd_temp         gipi_quote.acct_of_cd%TYPE;
   BEGIN
    v_short_rt_percent_temp := v_short_rt_percent;
    v_reason_cd_temp := v_reason_cd;
    v_acct_of_cd_temp := v_acct_of_cd;
      FOR a IN (SELECT 1
                  FROM gipi_quote
                 WHERE quote_id = v_quote_id)
      LOOP
         v_exist := 'Y';
      END LOOP;

      v_line_cd := giis_line_pkg.get_line_code (v_line_name);
      IF v_prorate_flag = 2 THEN --added by steven 11.05.2012 base on SR 0011185
          v_short_rt_percent_temp := null;
      END IF;
      
      IF v_reason_cd = 0 THEN --added by steven 11.05.2012 base on SR 0011185
             v_reason_cd_temp := null;
      END IF;
      
      IF v_acct_of_cd = 0 THEN --added by steven 11.05.2012 base on SR 0011185
             v_acct_of_cd_temp := null;
      END IF;

      IF v_exist = 'Y'
      THEN
         UPDATE gipi_quote
            SET line_cd = v_line_cd,
                subline_cd =
                   giis_subline_pkg.get_subline_code2 (v_line_cd,
                                                       v_subline_name
                                                      ),
                iss_cd = giis_issource_pkg.get_iss_code (v_iss_name),
                quotation_yy = v_quotation_yy,
                quotation_no = v_quotation_no,
                proposal_no = v_proposal_no,
                assd_no = v_assd_no,
                assd_name = v_assd_name,
                tsi_amt = v_tsi_amt,
                prem_amt = v_prem_amt,
                print_dt = v_print_dt,
                accept_dt = v_accept_dt,
                post_dt = v_post_dt,
                denied_dt = v_denied_dt,
                status = 'N',
                print_tag = v_print_tag,
                header = v_header,
                footer = v_footer,
                remarks = v_remarks,
                user_id = v_user_id,
                last_update = SYSDATE,
                cpi_rec_no = v_cpi_rec_no,
                cpi_branch_cd = v_cpi_branch_cd,
                quotation_printed_cnt = v_cpi_rec_no,
                incept_date = v_incept_date,
                expiry_date = v_expiry_date,
                origin = v_origin,
                reason_cd = v_reason_cd_temp,    --change by steven 11.05.2012
                address1 = v_address1,
                address2 = v_address2,
                address3 = v_address3,
                valid_date = v_valid_date,
                prorate_flag = v_prorate_flag,
                short_rt_percent = v_short_rt_percent_temp, --change by steven 11.05.2012
                comp_sw = v_comp_sw,
                underwriter = v_underwriter,
                insp_no = v_insp_no,
                ann_prem_amt = v_ann_prem_amt,
                ann_tsi_amt = v_ann_tsi_amt,
                with_tariff_sw = v_with_tariff_sw,
                incept_tag = v_incept_tag,
                expiry_tag = v_expiry_tag,
                cred_branch = giis_issource_pkg.get_iss_code (v_cred_branch),
                acct_of_cd = v_acct_of_cd_temp,  --change by steven 11.05.2012
                acct_of_cd_sw = v_acct_of_cd_sw,
                pack_quote_id = v_pack_quote_id,
                pack_pol_flag = v_pack_pol_flag
                ,bank_ref_no = v_bank_ref_no    --added by Gzelle 12.12.2013 SR398
          WHERE quote_id = v_quote_id;
      ELSE
         /*  SELECT Quote_quote_id_s.NEXTVAL
            INTO v_quote_id
            FROM DUAL;*/
         INSERT INTO gipi_quote
                     (quote_id, line_cd,
                      subline_cd,
                      iss_cd,
                      quotation_yy, quotation_no, proposal_no,
                      assd_no, assd_name, tsi_amt, prem_amt, print_dt,
                      accept_dt, post_dt, denied_dt, status, print_tag,
                      header, footer, remarks, user_id, last_update,
                      cpi_rec_no, cpi_branch_cd,
                      quotation_printed_cnt, incept_date, expiry_date,
                      origin, reason_cd, address1, address2,
                      address3, valid_date, prorate_flag,
                      short_rt_percent, comp_sw, underwriter,
                      insp_no, ann_prem_amt, ann_tsi_amt,
                      with_tariff_sw, incept_tag, expiry_tag,
                      cred_branch,
                      acct_of_cd, acct_of_cd_sw, pack_quote_id,
                      pack_pol_flag
                      ,bank_ref_no      --added by Gzelle 12.12.2013 SR398
                     )
              VALUES (v_quote_id, v_line_cd,
                      giis_subline_pkg.get_subline_code2 (v_line_cd,
                                                          v_subline_name
                                                         ),
                      giis_issource_pkg.get_iss_code (v_iss_name),
                      v_quotation_yy, v_quotation_no, v_proposal_no,
                      v_assd_no, v_assd_name, v_tsi_amt, v_prem_amt, NULL,
                      SYSDATE, v_post_dt, v_denied_dt, 'N', 'N',
                      v_header, v_footer, v_remarks, v_underwriter, SYSDATE,
                      v_cpi_rec_no, v_cpi_branch_cd,
                      v_quotation_printed_cnt, v_incept_date, v_expiry_date,
                      v_origin, v_reason_cd_temp, v_address1, v_address2,    --change by steven 11.05.2012
                      v_address3, v_valid_date, v_prorate_flag,
                      v_short_rt_percent_temp, v_comp_sw, v_underwriter,     --change by steven 11.05.2012
                      v_insp_no, v_ann_prem_amt, v_ann_tsi_amt,
                      v_with_tariff_sw, v_incept_tag, v_expiry_tag,
                      giis_issource_pkg.get_iss_code (v_cred_branch),
                      v_acct_of_cd_temp, v_acct_of_cd_sw, v_pack_quote_id,   --change by steven 11.05.2012
                      v_pack_pol_flag
                      ,v_bank_ref_no    --added by Gzelle 12.12.2013 SR398
                     );
      END IF;
   END set_gipi_quote;
   
   PROCEDURE set_gipi_quote_2 (
      v_quote_id                IN OUT   gipi_quote.quote_id%TYPE,
      v_line_name               IN       giis_line.line_name%TYPE,
      v_subline_cd              IN       giis_subline.subline_cd%TYPE,
      v_subline_name            IN       giis_subline.subline_name%TYPE,
      v_iss_name                IN       giis_issource.iss_name%TYPE,
      v_quotation_yy            IN       gipi_quote.quotation_yy%TYPE,
      v_quotation_no            IN       gipi_quote.quotation_no%TYPE,
      v_proposal_no             IN       gipi_quote.proposal_no%TYPE,
      v_assd_no                 IN       gipi_quote.assd_no%TYPE,
      v_assd_name               IN       gipi_quote.assd_name%TYPE,
      v_tsi_amt                 IN       gipi_quote.tsi_amt%TYPE,
      v_prem_amt                IN       gipi_quote.prem_amt%TYPE,
      v_print_dt                IN       gipi_quote.print_dt%TYPE,
      v_accept_dt               IN       gipi_quote.accept_dt%TYPE,
      v_post_dt                 IN       gipi_quote.post_dt%TYPE,
      v_denied_dt               IN       gipi_quote.denied_dt%TYPE,
      v_status                  IN       gipi_quote.status%TYPE,
      v_print_tag               IN       gipi_quote.print_tag%TYPE,
      v_header                  IN       gipi_quote.header%TYPE,
      v_footer                  IN       gipi_quote.footer%TYPE,
      v_remarks                 IN       gipi_quote.remarks%TYPE,
      v_user_id                 IN       gipi_quote.user_id%TYPE,
      v_last_update             IN       gipi_quote.last_update%TYPE,
      v_cpi_rec_no              IN       gipi_quote.cpi_rec_no%TYPE,
      v_cpi_branch_cd           IN       gipi_quote.cpi_branch_cd%TYPE,
      v_quotation_printed_cnt   IN       gipi_quote.cpi_rec_no%TYPE,
      v_incept_date             IN       gipi_quote.incept_date%TYPE,
      v_expiry_date             IN       gipi_quote.expiry_date%TYPE,
      v_origin                  IN       gipi_quote.origin%TYPE,
      v_reason_cd               IN       gipi_quote.reason_cd%TYPE,
      v_address1                IN       gipi_quote.address1%TYPE,
      v_address2                IN       gipi_quote.address2%TYPE,
      v_address3                IN       gipi_quote.address3%TYPE,
      v_valid_date              IN       gipi_quote.valid_date%TYPE,
      v_prorate_flag            IN       gipi_quote.prorate_flag%TYPE,
      v_short_rt_percent        IN       gipi_quote.short_rt_percent%TYPE,
      v_comp_sw                 IN       gipi_quote.comp_sw%TYPE,
      v_underwriter             IN       gipi_quote.underwriter%TYPE,
      v_insp_no                 IN       gipi_quote.insp_no%TYPE,
      v_ann_prem_amt            IN       gipi_quote.ann_prem_amt%TYPE,
      v_ann_tsi_amt             IN       gipi_quote.ann_tsi_amt%TYPE,
      v_with_tariff_sw          IN       gipi_quote.with_tariff_sw%TYPE,
      v_incept_tag              IN       gipi_quote.incept_tag%TYPE,
      v_expiry_tag              IN       gipi_quote.expiry_tag%TYPE,
      v_cred_branch             IN       giis_issource.iss_name%TYPE,
      v_acct_of_cd              IN       gipi_quote.acct_of_cd%TYPE,
      v_acct_of_cd_sw           IN       gipi_quote.acct_of_cd_sw%TYPE,
      v_pack_quote_id           IN       gipi_quote.pack_quote_id%TYPE,
      v_pack_pol_flag           IN       gipi_quote.pack_pol_flag%TYPE,
      v_account_sw              IN       gipi_quote.account_sw%TYPE,
      v_bank_ref_no			    IN		 gipi_quote.bank_ref_no%TYPE
   )
   IS
      v_exist     VARCHAR2 (1)               := 'N';
      var_quote   gipi_quote.quote_id%TYPE;
      v_line_cd   gipi_quote.line_cd%TYPE;
      v_short_rt_percent_temp   gipi_quote.short_rt_percent%TYPE;
      v_reason_cd_temp            gipi_quote.reason_cd%TYPE;
   BEGIN
       v_short_rt_percent_temp := v_short_rt_percent;
    v_reason_cd_temp := v_reason_cd;
      FOR a IN (SELECT 1
                  FROM gipi_quote
                 WHERE quote_id = v_quote_id)
      LOOP
         v_exist := 'Y';
      END LOOP;

      v_line_cd := giis_line_pkg.get_line_code (v_line_name);
      IF v_prorate_flag = 2 THEN --added by steven 10.30.2012 base on SR 0011112
          v_short_rt_percent_temp := null;
      END IF;
      IF v_exist = 'Y'
      THEN
         UPDATE gipi_quote
            SET line_cd = v_line_cd,
                subline_cd =
                   NVL(v_subline_cd, giis_subline_pkg.get_subline_code2 (v_line_cd,
                                                       v_subline_name
                                                      )),
                iss_cd = giis_issource_pkg.get_iss_code (v_iss_name),
                quotation_yy = v_quotation_yy,
                quotation_no = v_quotation_no,
                proposal_no = v_proposal_no,
                assd_no = v_assd_no,
                assd_name = v_assd_name,
                --tsi_amt = v_tsi_amt,    --remove by steven 9/7/2012
                --prem_amt = v_prem_amt,
                print_dt = v_print_dt,
                accept_dt = v_accept_dt,
                post_dt = v_post_dt,
                denied_dt = v_denied_dt,
                status = 'N',
                print_tag = 'N',
                header = v_header,
                footer = v_footer,
                remarks = v_remarks,
                user_id = v_user_id,
                last_update = SYSDATE,
                cpi_rec_no = v_cpi_rec_no,
                cpi_branch_cd = v_cpi_branch_cd,
                quotation_printed_cnt = v_cpi_rec_no,
                incept_date = v_incept_date,
                expiry_date = v_expiry_date,
                origin = v_origin,
                reason_cd = v_reason_cd,
                address1 = v_address1,
                address2 = v_address2,
                address3 = v_address3,
                valid_date = v_valid_date,
                prorate_flag = v_prorate_flag,
                short_rt_percent = v_short_rt_percent_temp, --replace by steven 10/30/2012
                comp_sw = v_comp_sw,
                underwriter = v_underwriter,
                insp_no = v_insp_no,
                --ann_prem_amt = v_ann_prem_amt, --remove by steven 9/7/2012
                --ann_tsi_amt = v_ann_tsi_amt,
                with_tariff_sw = v_with_tariff_sw,
                incept_tag = v_incept_tag,
                expiry_tag = v_expiry_tag,
                cred_branch = giis_issource_pkg.get_iss_code (v_cred_branch),
                acct_of_cd = v_acct_of_cd,
                acct_of_cd_sw = v_acct_of_cd_sw,
                pack_quote_id = v_pack_quote_id,
                pack_pol_flag = v_pack_pol_flag,
                account_sw = v_account_sw,
                bank_ref_no = v_bank_ref_no
          WHERE quote_id = v_quote_id;
      ELSE
         /*  SELECT Quote_quote_id_s.NEXTVAL
            INTO v_quote_id
            FROM DUAL;*/
         IF v_reason_cd = 0 THEN --added by steven 10.30.2012 base on SR 0011112
             v_reason_cd_temp := null;
         END IF;
         INSERT INTO gipi_quote
                     (quote_id, line_cd,
                      subline_cd,
                      iss_cd,
                      quotation_yy, quotation_no, proposal_no,
                      assd_no, assd_name, tsi_amt, prem_amt, print_dt,
                      accept_dt, post_dt, denied_dt, status, print_tag,
                      header, footer, remarks, user_id, last_update,
                      cpi_rec_no, cpi_branch_cd,
                      quotation_printed_cnt, incept_date, expiry_date,
                      origin, reason_cd, address1, address2,
                      address3, valid_date, prorate_flag,
                      short_rt_percent, comp_sw, underwriter,
                      insp_no, ann_prem_amt, ann_tsi_amt,
                      with_tariff_sw, incept_tag, expiry_tag,
                      cred_branch,
                      acct_of_cd, acct_of_cd_sw, pack_quote_id,
                      pack_pol_flag, account_sw, bank_ref_no
                     )
              VALUES (v_quote_id, v_line_cd,
                      NVL(v_subline_cd, giis_subline_pkg.get_subline_code2 (v_line_cd,
                                                          v_subline_name
                                                         )),
                      giis_issource_pkg.get_iss_code (v_iss_name),
                      v_quotation_yy, v_quotation_no, v_proposal_no,
                      v_assd_no, v_assd_name, v_tsi_amt, v_prem_amt, NULL,
                      SYSDATE, v_post_dt, v_denied_dt, 'N', 'N',
                      v_header, v_footer, v_remarks, v_underwriter, SYSDATE,
                      v_cpi_rec_no, v_cpi_branch_cd,
                      v_quotation_printed_cnt, v_incept_date, v_expiry_date,
                      v_origin, v_reason_cd_temp, v_address1, v_address2,
                      v_address3, v_valid_date, v_prorate_flag,
                      v_short_rt_percent_temp, v_comp_sw, v_underwriter,  --replace by steven 10/30/2012
                      v_insp_no, v_ann_prem_amt, v_ann_tsi_amt,
                      v_with_tariff_sw, v_incept_tag, v_expiry_tag,
                      giis_issource_pkg.get_iss_code (v_cred_branch),
                      v_acct_of_cd, v_acct_of_cd_sw, v_pack_quote_id,
                      v_pack_pol_flag, v_account_sw, v_bank_ref_no
                     );
      END IF;
   END set_gipi_quote_2;

   PROCEDURE copy_quotation (
      p_quote_id   IN   gipi_quote.quote_id%TYPE,
      p_user       IN   giis_users.user_id%TYPE
   )
   IS
      v_new_quote_id   gipi_quote.quote_id%TYPE;
      v_quotation_no   gipi_quote.quotation_no%TYPE;
      v_quote_inv_no   gipi_quote_invoice.quote_inv_no%TYPE;
      v_menu_line_cd   giis_line.menu_line_cd%TYPE;
      v_fire_cd        giis_line.line_cd%TYPE;
      v_motor_cd       giis_line.line_cd%TYPE;
      v_accident_cd    giis_line.line_cd%TYPE;
      v_hull_cd        giis_line.line_cd%TYPE;
      v_cargo_cd       giis_line.line_cd%TYPE;
      v_casualty_cd    giis_line.line_cd%TYPE;
      v_engrng_cd      giis_line.line_cd%TYPE;
      v_surety_cd      giis_line.line_cd%TYPE;
      v_aviation_cd    giis_line.line_cd%TYPE;
   BEGIN
      giis_line_pkg.get_param_line_cd (v_fire_cd,
                                       v_motor_cd,
                                       v_accident_cd,
                                       v_hull_cd,
                                       v_cargo_cd,
                                       v_casualty_cd,
                                       v_engrng_cd,
                                       v_surety_cd,
                                       v_aviation_cd
                                      );

      --generate new quote_id
      FOR a IN (SELECT quote_quote_id_s.NEXTVAL new_quote
                  FROM DUAL)
      LOOP
         v_new_quote_id := a.new_quote;
      END LOOP;

   /* -- removed, the original qoute should not have the newly generated quotation id
      UPDATE gipi_quote
         SET copied_quote_id = v_new_quote_id
       WHERE quote_id = p_quote_id;*/

      FOR b IN (SELECT line_cd, subline_cd, iss_cd, quotation_yy, proposal_no,
                       assd_no, assd_name, tsi_amt, prem_amt, remarks, header,
                       footer, status, print_tag, incept_date, expiry_date,
                       accept_dt, address1, address2, address3, cred_branch,
                       acct_of_cd, acct_of_cd_sw, incept_tag, expiry_tag,
                       prorate_flag, comp_sw, with_tariff_sw
                  FROM gipi_quote
                 WHERE quote_id = p_quote_id)
      LOOP
         gipi_quote_pkg.compute_quote_no (b.line_cd,
                                          b.subline_cd,
                                          b.iss_cd,
                                          b.quotation_yy,
                                          v_quotation_no
                                         );

         INSERT INTO gipi_quote
                     (quotation_no, quote_id, line_cd,
                      subline_cd, iss_cd, quotation_yy, proposal_no,
                      assd_no, assd_name, tsi_amt, prem_amt,
                      remarks, header, footer, status, print_tag,
                      incept_date, expiry_date, last_update,
                      user_id, accept_dt, valid_date,
                      address1, address2, address3, cred_branch,
                      acct_of_cd, acct_of_cd_sw, incept_tag,
                      expiry_tag, prorate_flag, comp_sw,
                      with_tariff_sw, underwriter, copied_quote_id
                     )
              VALUES (v_quotation_no, v_new_quote_id, b.line_cd,
                      b.subline_cd, b.iss_cd, TO_CHAR (SYSDATE, 'YYYY'), 0,
                      b.assd_no, b.assd_name, b.tsi_amt, b.prem_amt,
                      b.remarks, b.header, b.footer, 'N', b.print_tag,
                      b.incept_date, b.expiry_date, SYSDATE,
                      NVL (p_user, USER), b.accept_dt, SYSDATE + 30,
                      b.address1, b.address2, b.address3, b.cred_branch,
                      b.acct_of_cd, b.acct_of_cd_sw, b.incept_tag,
                      b.expiry_tag, b.prorate_flag, b.comp_sw,
                      b.with_tariff_sw, NVL (p_user, USER), p_quote_id
                     );

         --insert  copied values to gipi_item,gipi_quote_itmperil,
         FOR v IN (SELECT item_no, item_title, item_desc, currency_cd,
                          currency_rate, pack_line_cd, pack_subline_cd,
                          tsi_amt, prem_amt
                     FROM gipi_quote_item
                    WHERE quote_id = p_quote_id)
         LOOP
            INSERT INTO gipi_quote_item
                        (quote_id, item_no, item_title,
                         item_desc, currency_cd, currency_rate,
                         pack_line_cd, pack_subline_cd, tsi_amt,
                         prem_amt
                        )
                 VALUES (v_new_quote_id, v.item_no, v.item_title,
                         v.item_desc, v.currency_cd, v.currency_rate,
                         v.pack_line_cd, v.pack_subline_cd, v.tsi_amt,
                         v.prem_amt
                        );

            FOR m IN (SELECT item_no, peril_cd, tsi_amt, prem_amt, prem_rt,
                             comp_rem
                        FROM gipi_quote_itmperil
                       WHERE quote_id = p_quote_id AND item_no = v.item_no)
            LOOP
               INSERT INTO gipi_quote_itmperil
                           (quote_id, item_no, peril_cd,
                            tsi_amt, prem_amt, prem_rt, comp_rem
                           )
                    VALUES (v_new_quote_id, m.item_no, m.peril_cd,
                            m.tsi_amt, m.prem_amt, m.prem_rt, m.comp_rem
                           );
            END LOOP;
         END LOOP;

         FOR a IN (SELECT iss_cd, intm_no, currency_cd, currency_rt, prem_amt,
                          tax_amt
                     FROM gipi_quote_invoice
                    WHERE quote_id = p_quote_id)
         LOOP
            FOR j IN (SELECT quote_inv_no
                        FROM giis_quote_inv_seq
                       WHERE iss_cd = b.iss_cd)
            LOOP
               v_quote_inv_no := j.quote_inv_no + 1;
               EXIT;
            END LOOP;

            INSERT INTO gipi_quote_invoice
                        (quote_id, iss_cd, quote_inv_no, intm_no,
                         currency_cd, currency_rt, prem_amt, tax_amt
                        )
                 VALUES (v_new_quote_id, a.iss_cd, v_quote_inv_no, a.intm_no,
                         a.currency_cd, a.currency_rt, a.prem_amt, a.tax_amt
                        );

            FOR e IN (SELECT line_cd, tax_cd, tax_id, tax_amt, rate
                        FROM gipi_quote_invtax
                       WHERE quote_inv_no = v_quote_inv_no
                         AND iss_cd = a.iss_cd)
            LOOP
               INSERT INTO gipi_quote_invtax
                           (line_cd, iss_cd, quote_inv_no, tax_cd,
                            tax_id, tax_amt, rate
                           )
                    VALUES (b.line_cd, a.iss_cd, v_quote_inv_no, e.tax_cd,
                            e.tax_id, e.tax_amt, e.rate
                           );
            END LOOP;
         END LOOP;

         -- to get the value of the menu_line_cd for the given line
         FOR a IN (SELECT menu_line_cd
                     FROM giis_line
                    WHERE line_cd = b.line_cd)
         LOOP
            v_menu_line_cd := a.menu_line_cd;
            EXIT;
         END LOOP;

         IF v_menu_line_cd = 'AC' OR b.line_cd = v_accident_cd
         THEN
            FOR ac IN (SELECT item_no, no_of_persons, position_cd,
                              monthly_salary, salary_grade, destination,
                              ac_class_cd, age, civil_status, date_of_birth,
                              group_print_sw, height, level_cd,
                              parent_level_cd, sex, weight
                         FROM gipi_quote_ac_item
                        WHERE quote_id = p_quote_id)
            LOOP
               INSERT INTO gipi_quote_ac_item
                           (quote_id, item_no, no_of_persons,
                            position_cd, monthly_salary,
                            salary_grade, destination, ac_class_cd,
                            age, civil_status, date_of_birth,
                            group_print_sw, height, level_cd,
                            parent_level_cd, sex, weight, user_id,
                            last_update
                           )
                    VALUES (v_new_quote_id, ac.item_no, ac.no_of_persons,
                            ac.position_cd, ac.monthly_salary,
                            ac.salary_grade, ac.destination, ac.ac_class_cd,
                            ac.age, ac.civil_status, ac.date_of_birth,
                            ac.group_print_sw, ac.height, ac.level_cd,
                            ac.parent_level_cd, ac.sex, ac.weight, USER,
                            SYSDATE
                           );
            END LOOP;
         ELSIF v_menu_line_cd = 'MC' OR b.line_cd = v_motor_cd
         THEN
            FOR mc IN (SELECT item_no, plate_no, motor_no, serial_no,
                              subline_type_cd, mot_type, car_company_cd,
                              coc_yy, coc_seq_no, coc_serial_no, coc_type,
                              repair_lim, color, model_year, make, est_value,
                              towing, assignee, no_of_pass, tariff_zone,
                              coc_issue_date, mv_file_no, acquired_from,
                              ctv_tag, type_of_body_cd, unladen_wt, make_cd,
                              series_cd, basic_color_cd, color_cd, origin,
                              destination, coc_atcn, subline_cd
                         FROM gipi_quote_item_mc
                        WHERE quote_id = p_quote_id)
            LOOP
               INSERT INTO gipi_quote_item_mc
                           (quote_id, item_no, plate_no,
                            motor_no, serial_no, subline_type_cd,
                            mot_type, car_company_cd, coc_yy,
                            coc_seq_no, coc_serial_no, coc_type,
                            repair_lim, color, model_year, make,
                            est_value, towing, assignee,
                            no_of_pass, tariff_zone,
                            coc_issue_date, mv_file_no,
                            acquired_from, ctv_tag,
                            type_of_body_cd, unladen_wt, make_cd,
                            series_cd, basic_color_cd, color_cd,
                            origin, destination, coc_atcn,
                            subline_cd, user_id, last_update
                           )
                    VALUES (v_new_quote_id, mc.item_no, mc.plate_no,
                            mc.motor_no, mc.serial_no, mc.subline_type_cd,
                            mc.mot_type, mc.car_company_cd, mc.coc_yy,
                            mc.coc_seq_no, mc.coc_serial_no, mc.coc_type,
                            mc.repair_lim, mc.color, mc.model_year, mc.make,
                            mc.est_value, mc.towing, mc.assignee,
                            mc.no_of_pass, mc.tariff_zone,
                            mc.coc_issue_date, mc.mv_file_no,
                            mc.acquired_from, mc.ctv_tag,
                            mc.type_of_body_cd, mc.unladen_wt, mc.make_cd,
                            mc.series_cd, mc.basic_color_cd, mc.color_cd,
                            mc.origin, mc.destination, mc.coc_atcn,
                            mc.subline_cd, USER, SYSDATE
                           );
            END LOOP;
         ELSIF v_menu_line_cd = 'FI' OR b.line_cd = v_fire_cd
         THEN
            FOR fi IN (SELECT item_no, district_no, eq_zone, tarf_cd,
                              block_no, fr_item_type, loc_risk1, loc_risk2,
                              loc_risk3, tariff_zone, typhoon_zone,
                              construction_cd, construction_remarks, front,
                              RIGHT, LEFT, rear, occupancy_cd,
                              occupancy_remarks, flood_zone, assignee,
                              block_id, risk_cd
                         FROM gipi_quote_fi_item
                        WHERE quote_id = p_quote_id)
            LOOP
               INSERT INTO gipi_quote_fi_item
                           (quote_id, item_no, district_no,
                            eq_zone, tarf_cd, block_no,
                            fr_item_type, loc_risk1, loc_risk2,
                            loc_risk3, tariff_zone, typhoon_zone,
                            construction_cd, construction_remarks,
                            front, RIGHT, LEFT, rear,
                            occupancy_cd, occupancy_remarks,
                            flood_zone, assignee, block_id,
                            risk_cd, user_id, last_update
                           )
                    VALUES (v_new_quote_id, fi.item_no, fi.district_no,
                            fi.eq_zone, fi.tarf_cd, fi.block_no,
                            fi.fr_item_type, fi.loc_risk1, fi.loc_risk2,
                            fi.loc_risk3, fi.tariff_zone, fi.typhoon_zone,
                            fi.construction_cd, fi.construction_remarks,
                            fi.front, fi.RIGHT, fi.LEFT, fi.rear,
                            fi.occupancy_cd, fi.occupancy_remarks,
                            fi.flood_zone, fi.assignee, fi.block_id,
                            fi.risk_cd, USER, SYSDATE
                           );
            END LOOP;
         ELSIF v_menu_line_cd = 'EN' OR b.line_cd = v_engrng_cd
         THEN
            FOR en IN (SELECT engg_basic_infonum, contract_proj_buss_title,
                              site_location, construct_start_date,
                              construct_end_date, maintain_start_date,
                              maintain_end_date, testing_start_date,
                              testing_end_date, weeks_test, time_excess,
                              mbi_policy_no
                         FROM gipi_quote_en_item
                        WHERE quote_id = p_quote_id)
            LOOP
               INSERT INTO gipi_quote_en_item
                           (quote_id, engg_basic_infonum,
                            contract_proj_buss_title, site_location,
                            construct_start_date, construct_end_date,
                            maintain_start_date, maintain_end_date,
                            testing_start_date, testing_end_date,
                            weeks_test, time_excess, mbi_policy_no,
                            user_id, last_update
                           )
                    VALUES (v_new_quote_id, en.engg_basic_infonum,
                            en.contract_proj_buss_title, en.site_location,
                            en.construct_start_date, en.construct_end_date,
                            en.maintain_start_date, en.maintain_end_date,
                            en.testing_start_date, en.testing_end_date,
                            en.weeks_test, en.time_excess, en.mbi_policy_no,
                            USER, SYSDATE
                           );
            END LOOP;
         ELSIF v_menu_line_cd = 'CA' OR b.line_cd = v_casualty_cd
         THEN
            FOR ca IN (SELECT item_no, section_line_cd, section_subline_cd,
                              section_or_hazard_cd, capacity_cd,
                              property_no_type, property_no, LOCATION,
                              conveyance_info, interest_on_premises,
                              limit_of_liability, section_or_hazard_info
                         FROM gipi_quote_ca_item
                        WHERE quote_id = p_quote_id)
            LOOP
               INSERT INTO gipi_quote_ca_item
                           (quote_id, item_no, section_line_cd,
                            section_subline_cd, section_or_hazard_cd,
                            capacity_cd, property_no_type,
                            property_no, LOCATION, conveyance_info,
                            interest_on_premises, limit_of_liability,
                            section_or_hazard_info, user_id, last_update
                           )
                    VALUES (v_new_quote_id, ca.item_no, ca.section_line_cd,
                            ca.section_subline_cd, ca.section_or_hazard_cd,
                            ca.capacity_cd, ca.property_no_type,
                            ca.property_no, ca.LOCATION, ca.conveyance_info,
                            ca.interest_on_premises, ca.limit_of_liability,
                            ca.section_or_hazard_info, USER, SYSDATE
                           );
            END LOOP;
         ELSIF v_menu_line_cd = 'MN' OR b.line_cd = v_cargo_cd
         THEN
            FOR ves IN (SELECT vessel_cd, rec_flag, vescon, voy_limit
                          FROM gipi_quote_ves_air
                         WHERE quote_id = p_quote_id)
            LOOP
               INSERT INTO gipi_quote_ves_air
                           (quote_id, vessel_cd, rec_flag,
                            vescon, voy_limit
                           )
                    VALUES (v_new_quote_id, ves.vessel_cd, ves.rec_flag,
                            ves.vescon, ves.voy_limit
                           );
            END LOOP;

            FOR mn IN (SELECT item_no, vessel_cd, geog_cd, cargo_class_cd,
                              voyage_no, bl_awb, origin, destn, etd, eta,
                              cargo_type, pack_method, tranship_origin,
                              tranship_destination, lc_no, print_tag,
                              deduct_text, rec_flag
                         FROM gipi_quote_cargo
                        WHERE quote_id = p_quote_id)
            LOOP
               INSERT INTO gipi_quote_cargo
                           (quote_id, item_no, vessel_cd,
                            geog_cd, cargo_class_cd, voyage_no,
                            bl_awb, origin, destn, etd, eta,
                            cargo_type, pack_method,
                            tranship_origin, tranship_destination,
                            lc_no, print_tag, deduct_text,
                            rec_flag, user_id, last_update
                           )
                    VALUES (v_new_quote_id, mn.item_no, mn.vessel_cd,
                            mn.geog_cd, mn.cargo_class_cd, mn.voyage_no,
                            mn.bl_awb, mn.origin, mn.destn, mn.etd, mn.eta,
                            mn.cargo_type, mn.pack_method,
                            mn.tranship_origin, mn.tranship_destination,
                            mn.lc_no, mn.print_tag, mn.deduct_text,
                            mn.rec_flag, USER, SYSDATE
                           );
            END LOOP;
         ELSIF v_menu_line_cd = 'AV' OR b.line_cd = v_aviation_cd
         THEN
            FOR av IN (SELECT item_no, vessel_cd, total_fly_time,
                              qualification, purpose, geog_limit,
                              deduct_text, rec_flag, fixed_wing, rotor,
                              prev_util_hrs, est_util_hrs
                         FROM gipi_quote_av_item
                        WHERE quote_id = p_quote_id)
            LOOP
               INSERT INTO gipi_quote_av_item
                           (quote_id, item_no, vessel_cd,
                            total_fly_time, qualification, purpose,
                            geog_limit, deduct_text, rec_flag,
                            fixed_wing, rotor, prev_util_hrs,
                            est_util_hrs, user_id, last_update
                           )
                    VALUES (v_new_quote_id, av.item_no, av.vessel_cd,
                            av.total_fly_time, av.qualification, av.purpose,
                            av.geog_limit, av.deduct_text, av.rec_flag,
                            av.fixed_wing, av.rotor, av.prev_util_hrs,
                            av.est_util_hrs, USER, SYSDATE
                           );
            END LOOP;
         ELSIF v_menu_line_cd = 'MH' OR b.line_cd = v_hull_cd
         THEN
            FOR ves IN (SELECT vessel_cd, rec_flag, vescon, voy_limit
                          FROM gipi_quote_ves_air
                         WHERE quote_id = p_quote_id)
            LOOP
               INSERT INTO gipi_quote_ves_air
                           (quote_id, vessel_cd, rec_flag,
                            vescon, voy_limit
                           )
                    VALUES (v_new_quote_id, ves.vessel_cd, ves.rec_flag,
                            ves.vescon, ves.voy_limit
                           );
            END LOOP;

            FOR mh IN (SELECT item_no, vessel_cd, geog_limit, rec_flag,
                              deduct_text, dry_date, dry_place
                         FROM gipi_quote_mh_item
                        WHERE quote_id = p_quote_id)
            LOOP
               INSERT INTO gipi_quote_mh_item
                           (quote_id, item_no, vessel_cd,
                            geog_limit, rec_flag, deduct_text,
                            dry_date, dry_place, user_id, last_update
                           )
                    VALUES (v_new_quote_id, mh.item_no, mh.vessel_cd,
                            mh.geog_limit, mh.rec_flag, mh.deduct_text,
                            mh.dry_date, mh.dry_place, USER, SYSDATE
                           );
            END LOOP;
         ELSIF v_menu_line_cd = 'SU' OR b.line_cd = v_surety_cd
         THEN
            FOR su IN (SELECT obligee_no, prin_id, val_period_unit,
                              val_period, coll_flag, clause_type, np_no,
                              contract_dtl, contract_date, co_prin_sw,
                              waiver_limit, indemnity_text, bond_dtl,
                              endt_eff_date, remarks
                         FROM gipi_quote_bond_basic
                        WHERE quote_id = p_quote_id)
            LOOP
               INSERT INTO gipi_quote_bond_basic
                           (quote_id, obligee_no, prin_id,
                            val_period_unit, val_period, coll_flag,
                            clause_type, np_no, contract_dtl,
                            contract_date, co_prin_sw,
                            waiver_limit, indemnity_text, bond_dtl,
                            endt_eff_date, remarks
                           )
                    VALUES (v_new_quote_id, su.obligee_no, su.prin_id,
                            su.val_period_unit, su.val_period, su.coll_flag,
                            su.clause_type, su.np_no, su.contract_dtl,
                            su.contract_date, su.co_prin_sw,
                            su.waiver_limit, su.indemnity_text, su.bond_dtl,
                            su.endt_eff_date, su.remarks
                           );
            END LOOP;
         END IF;

         FOR wc IN (SELECT line_cd, wc_cd, print_seq_no, wc_title, wc_title2,
                           wc_text01, wc_text02, wc_text03, wc_text04,
                           wc_text05, wc_text06, wc_text07, wc_text08,
                           wc_text09, wc_text10, wc_text11, wc_text12,
                           wc_text13, wc_text14, wc_text15, wc_text16,
                           wc_text17, wc_remarks, print_sw, change_tag
                      FROM gipi_quote_wc
                     WHERE quote_id = p_quote_id)
         LOOP
            INSERT INTO gipi_quote_wc
                        (quote_id, line_cd, wc_cd,
                         print_seq_no, wc_title, wc_title2,
                         wc_text01, wc_text02, wc_text03,
                         wc_text04, wc_text05, wc_text06,
                         wc_text07, wc_text08, wc_text09,
                         wc_text10, wc_text11, wc_text12,
                         wc_text13, wc_text14, wc_text15,
                         wc_text16, wc_text17, wc_remarks,
                         print_sw, change_tag, user_id, last_update
                        )
                 VALUES (v_new_quote_id, wc.line_cd, wc.wc_cd,
                         wc.print_seq_no, wc.wc_title, wc.wc_title2,
                         wc.wc_text01, wc.wc_text02, wc.wc_text03,
                         wc.wc_text04, wc.wc_text05, wc.wc_text06,
                         wc.wc_text07, wc.wc_text08, wc.wc_text09,
                         wc.wc_text10, wc.wc_text11, wc.wc_text12,
                         wc.wc_text13, wc.wc_text14, wc.wc_text15,
                         wc.wc_text16, wc.wc_text17, wc.wc_remarks,
                         wc.print_sw, wc.change_tag, USER, SYSDATE
                        );
         END LOOP;

         FOR co IN (SELECT cosign_id, assd_no, indem_flag, bonds_flag,
                           bonds_ri_flag
                      FROM gipi_quote_cosign
                     WHERE quote_id = p_quote_id)
         LOOP
            INSERT INTO gipi_quote_cosign
                        (quote_id, cosign_id, assd_no,
                         indem_flag, bonds_flag, bonds_ri_flag
                        )
                 VALUES (v_new_quote_id, co.cosign_id, co.assd_no,
                         co.indem_flag, co.bonds_flag, co.bonds_ri_flag
                        );
         END LOOP;

         FOR idis IN (SELECT surcharge_rt, surcharge_amt, subline_cd,
                             SEQUENCE, remarks, orig_prem_amt, net_prem_amt,
                             net_gross_tag, line_cd, item_no, disc_rt,
                             disc_amt
                        FROM gipi_quote_item_discount
                       WHERE quote_id = p_quote_id)
         LOOP
            INSERT INTO gipi_quote_item_discount
                        (quote_id, surcharge_rt,
                         surcharge_amt, subline_cd, SEQUENCE,
                         remarks, orig_prem_amt,
                         net_prem_amt, net_gross_tag,
                         line_cd, item_no, disc_rt,
                         disc_amt, last_update
                        )
                 VALUES (v_new_quote_id, idis.surcharge_rt,
                         idis.surcharge_amt, idis.subline_cd, idis.SEQUENCE,
                         idis.remarks, idis.orig_prem_amt,
                         idis.net_prem_amt, idis.net_gross_tag,
                         idis.line_cd, idis.item_no, idis.disc_rt,
                         idis.disc_amt, SYSDATE
                        );
         END LOOP;

         FOR dis IN (SELECT line_cd, subline_cd, disc_rt, disc_amt,
                            net_gross_tag, orig_prem_amt, SEQUENCE,
                            net_prem_amt, remarks, surcharge_rt,
                            surcharge_amt
                       FROM gipi_quote_polbasic_discount
                      WHERE quote_id = p_quote_id)
         LOOP
            INSERT INTO gipi_quote_polbasic_discount
                        (quote_id, line_cd, subline_cd,
                         disc_rt, disc_amt, net_gross_tag,
                         orig_prem_amt, SEQUENCE, net_prem_amt,
                         remarks, surcharge_rt, surcharge_amt,
                         last_update
                        )
                 VALUES (v_new_quote_id, dis.line_cd, dis.subline_cd,
                         dis.disc_rt, dis.disc_amt, dis.net_gross_tag,
                         dis.orig_prem_amt, dis.SEQUENCE, dis.net_prem_amt,
                         dis.remarks, dis.surcharge_rt, dis.surcharge_amt,
                         SYSDATE
                        );
         END LOOP;

         FOR prin IN (SELECT principal_cd, engg_basic_infonum, subcon_sw
                        FROM gipi_quote_principal
                       WHERE quote_id = p_quote_id)
         LOOP
            INSERT INTO gipi_quote_principal
                        (quote_id, principal_cd,
                         engg_basic_infonum, subcon_sw
                        )
                 VALUES (v_new_quote_id, prin.principal_cd,
                         prin.engg_basic_infonum, prin.subcon_sw
                        );
         END LOOP;

         FOR pic IN (SELECT item_no, file_name, file_type, file_ext, remarks
                       FROM gipi_quote_pictures
                      WHERE quote_id = p_quote_id)
         LOOP
            INSERT INTO gipi_quote_pictures
                        (quote_id, item_no, file_name,
                         file_type, file_ext, remarks, user_id,
                         last_update
                        )
                 VALUES (v_new_quote_id, pic.item_no, pic.file_name,
                         pic.file_type, pic.file_ext, pic.remarks, USER,
                         SYSDATE
                        );
         END LOOP;

         FOR d IN (SELECT item_no, peril_cd, ded_deductible_cd,
                          deductible_amt, deductible_text, deductible_rt
                     FROM gipi_quote_deductibles
                    WHERE quote_id = p_quote_id)
         LOOP
            INSERT INTO gipi_quote_deductibles
                        (quote_id, item_no, peril_cd,
                         ded_deductible_cd, deductible_text,
                         deductible_amt, deductible_rt, user_id, last_update
                        )
                 VALUES (v_new_quote_id, d.item_no, d.peril_cd,
                         d.ded_deductible_cd, d.deductible_text,
                         d.deductible_amt, d.deductible_rt, USER, SYSDATE
                        );
         END LOOP;

         FOR pd IN (SELECT item_no, line_cd, peril_cd, disc_rt, level_tag,
                           disc_amt, net_gross_tag, discount_tag, subline_cd,
                           orig_peril_prem_amt, SEQUENCE, net_prem_amt,
                           remarks, surcharge_rt, surcharge_amt
                      FROM gipi_quote_peril_discount
                     WHERE quote_id = p_quote_id)
         LOOP
            INSERT INTO gipi_quote_peril_discount
                        (quote_id, item_no, line_cd,
                         peril_cd, disc_rt, level_tag, disc_amt,
                         net_gross_tag, discount_tag, subline_cd,
                         orig_peril_prem_amt, SEQUENCE,
                         net_prem_amt, remarks, surcharge_rt,
                         surcharge_amt, last_update
                        )
                 VALUES (v_new_quote_id, pd.item_no, pd.line_cd,
                         pd.peril_cd, pd.disc_rt, pd.level_tag, pd.disc_amt,
                         pd.net_gross_tag, pd.discount_tag, pd.subline_cd,
                         pd.orig_peril_prem_amt, pd.SEQUENCE,
                         pd.net_prem_amt, pd.remarks, pd.surcharge_rt,
                         pd.surcharge_amt, SYSDATE
                        );
         END LOOP;

         FOR gqm IN (SELECT iss_cd, item_no, mortg_cd, amount, remarks
                       FROM gipi_quote_mortgagee
                      WHERE quote_id = p_quote_id)
         LOOP
            INSERT INTO gipi_quote_mortgagee
                        (quote_id, iss_cd, item_no,
                         mortg_cd, amount, remarks, user_id, last_update
                        )
                 VALUES (v_new_quote_id, gqm.iss_cd, gqm.item_no,
                         gqm.mortg_cd, gqm.amount, gqm.remarks, USER, SYSDATE
                        );
         END LOOP;
      END LOOP;
   END;

   PROCEDURE delete_quotation (p_quote_id gipi_quote.quote_id%TYPE)
   IS
      v_line_cd       gipi_quote.line_cd%TYPE;
      v_menu_line     gipi_quote.line_cd%TYPE;
      v_accident_cd   gipi_quote.line_cd%TYPE;
      v_motor_cd      gipi_quote.line_cd%TYPE;
      v_fire_cd       gipi_quote.line_cd%TYPE;
      v_engrng_cd     gipi_quote.line_cd%TYPE;
      v_casualty_cd   gipi_quote.line_cd%TYPE;
      v_aviation_cd   gipi_quote.line_cd%TYPE;
      v_hull_cd       gipi_quote.line_cd%TYPE;
      v_surety_cd     gipi_quote.line_cd%TYPE;
      v_cargo_cd      gipi_quote.line_cd%TYPE;
   BEGIN
      FOR a IN (SELECT a.line_cd, b.menu_line_cd
                  FROM gipi_quote a, giis_line b
                 WHERE a.line_cd = b.line_cd AND quote_id = p_quote_id)
      LOOP
         v_line_cd := a.line_cd;
         v_menu_line := a.menu_line_cd;
      END LOOP;

      IF v_line_cd = 'AC' OR v_line_cd = v_accident_cd
      THEN
         DELETE FROM gipi_quote_ac_item
               WHERE quote_id = p_quote_id;
      ELSIF v_line_cd = 'MC' OR v_line_cd = v_motor_cd
      THEN
         DELETE FROM gipi_quote_item_mc
               WHERE quote_id = p_quote_id;
      ELSIF v_line_cd = 'FI' OR v_line_cd = v_fire_cd
      THEN
         DELETE FROM gipi_quote_fi_item
               WHERE quote_id = p_quote_id;
      ELSIF v_line_cd = 'EN' OR v_line_cd = v_engrng_cd
      THEN
         DELETE FROM gipi_quote_en_item
               WHERE quote_id = p_quote_id;
      ELSIF v_line_cd = 'CA' OR v_line_cd = v_casualty_cd
      THEN
         DELETE FROM gipi_quote_ca_item
               WHERE quote_id = p_quote_id;
      ELSIF v_line_cd = 'AV' OR v_line_cd = v_aviation_cd
      THEN
         DELETE FROM gipi_quote_av_item
               WHERE quote_id = p_quote_id;
      ELSIF v_line_cd = 'MH' OR v_line_cd = v_hull_cd
      THEN
         DELETE FROM gipi_quote_mh_item
               WHERE quote_id = p_quote_id;

         DELETE FROM gipi_quote_ves_air
               WHERE quote_id = p_quote_id;
      ELSIF v_line_cd = 'SU' OR v_line_cd = v_surety_cd
      THEN
         DELETE FROM gipi_quote_bond_basic
               WHERE quote_id = p_quote_id;
      ELSIF v_line_cd = 'MN' OR v_line_cd = v_cargo_cd
      THEN
         DELETE FROM gipi_quote_cargo
               WHERE quote_id = p_quote_id;

         DELETE FROM gipi_quote_ves_air
               WHERE quote_id = p_quote_id;
      END IF;

      DELETE FROM gipi_quote_deductibles
            WHERE quote_id = p_quote_id;

      DELETE FROM gipi_quote_mortgagee
            WHERE quote_id = p_quote_id;

      DELETE FROM gipi_quote_wc
            WHERE quote_id = p_quote_id;

      DELETE FROM gipi_quote_item_discount
            WHERE quote_id = p_quote_id;

      DELETE FROM gipi_quote_peril_discount
            WHERE quote_id = p_quote_id;

      DELETE FROM gipi_quote_pictures
            WHERE quote_id = p_quote_id;

      DELETE FROM gipi_quote_polbasic_discount
            WHERE quote_id = p_quote_id;

      DELETE FROM gipi_quote_principal
            WHERE quote_id = p_quote_id;

      DELETE FROM gipi_quote_cosign
            WHERE quote_id = p_quote_id;

      --deletion from subtable gipi_quote_invoice and its corresponding
      --child records from gipi_quote_invtax
      FOR invoice IN (SELECT iss_cd, quote_inv_no
                        FROM gipi_quote_invoice
                       WHERE quote_id = p_quote_id)
      LOOP
         --delete child records from gipi_quote_invtax
         FOR invtax IN (SELECT tax_cd
                          FROM gipi_quote_invtax
                         WHERE iss_cd = invoice.iss_cd
                           AND quote_inv_no = invoice.quote_inv_no)
         LOOP
            DELETE FROM gipi_quote_invtax
                  WHERE iss_cd = invoice.iss_cd
                    AND quote_inv_no = invoice.quote_inv_no
                    AND tax_cd = invtax.tax_cd;
         END LOOP;
      END LOOP;

      DELETE FROM gipi_quote_invoice
            WHERE quote_id = p_quote_id;

      DELETE FROM gipi_quote_itmperil
            WHERE quote_id = p_quote_id;

      --deletion from subtable gipi_quote_item and its corresponding
      --child records from gipi_quote_item_mc
      FOR item IN (SELECT item_no
                     FROM gipi_quote_item
                    WHERE quote_id = p_quote_id)
      LOOP
         --delete child records from gipi_quote_item_mc
         FOR item_mc IN (SELECT item_no
                           FROM gipi_quote_item_mc
                          WHERE quote_id = p_quote_id
                            AND item_no = item.item_no)
         LOOP
            DELETE FROM gipi_quote_item_mc
                  WHERE quote_id = p_quote_id AND item_no = item.item_no;
         END LOOP;

         DELETE FROM gipi_quote_item
               WHERE quote_id = p_quote_id;
      END LOOP;

      --delete from the main table gipi_quote.
      DELETE FROM gipi_quote
            WHERE quote_id = p_quote_id;
   --COMMIT;
   END;

   PROCEDURE deny_quotation (p_quote_id IN gipi_quote.quote_id%TYPE)
   IS
   BEGIN
      UPDATE gipi_quote
         SET status = 'D',
          denied_dt = sysdate, -- added denied date - irwin,
          last_update = sysdate
       WHERE quote_id = p_quote_id;
   END;

   PROCEDURE compute_quote_no (
      p_line_cd        IN       gipi_quote.line_cd%TYPE,
      p_subline_cd     IN       gipi_quote.subline_cd%TYPE,
      p_iss_cd         IN       gipi_quote.iss_cd%TYPE,
      p_quotation_yy   IN       gipi_quote.quotation_yy%TYPE,
      p_quotation_no   OUT      gipi_quote.quotation_no%TYPE
   )
   IS
      v_quote_no   gipi_quote.quotation_no%TYPE;
   BEGIN
      SELECT MAX (quotation_no)
        INTO v_quote_no
        FROM giis_quotation_no
       WHERE line_cd = p_line_cd
         AND subline_cd = p_subline_cd
         AND iss_cd = p_iss_cd
         AND quotation_yy = p_quotation_yy;

      p_quotation_no := v_quote_no + 1;
   END;

   PROCEDURE duplicate_quotation (
      p_quote_id   IN   gipi_quote.quote_id%TYPE,
      p_user       IN   giis_users.user_id%TYPE
   )
   IS
      v_new_quote_id   gipi_quote.quote_id%TYPE;
      v_quote_inv_no   gipi_quote_invoice.quote_inv_no%TYPE;
      v_proposal_no    gipi_quote.proposal_no%TYPE;
      v_menu_line_cd   giis_line.menu_line_cd%TYPE;
      v_fire_cd        giis_line.line_cd%TYPE;
      v_motor_cd       giis_line.line_cd%TYPE;
      v_accident_cd    giis_line.line_cd%TYPE;
      v_hull_cd        giis_line.line_cd%TYPE;
      v_cargo_cd       giis_line.line_cd%TYPE;
      v_casualty_cd    giis_line.line_cd%TYPE;
      v_engrng_cd      giis_line.line_cd%TYPE;
      v_surety_cd      giis_line.line_cd%TYPE;
      v_aviation_cd    giis_line.line_cd%TYPE;
   BEGIN
      giis_line_pkg.get_param_line_cd (v_fire_cd,
                                       v_motor_cd,
                                       v_accident_cd,
                                       v_hull_cd,
                                       v_cargo_cd,
                                       v_casualty_cd,
                                       v_engrng_cd,
                                       v_surety_cd,
                                       v_aviation_cd
                                      );

      BEGIN
         SELECT quote_quote_id_s.NEXTVAL
           INTO v_new_quote_id
           FROM DUAL;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;
/* --removed, irwin - 2.7.2012
      UPDATE gipi_quote
         SET copied_quote_id = v_new_quote_id
       WHERE quote_id = p_quote_id;*/

      -- Check if the given quote_id exists in GIPI_QUOTE.....
      -- IF quote_id is existing do the ff line of code, else raise from trigger failure
      FOR a IN (SELECT line_cd, subline_cd, iss_cd, quotation_yy,
                       quotation_no, assd_no, assd_name, tsi_amt, prem_amt,
                       remarks, header, footer, status, print_tag,
                       incept_date, expiry_date, accept_dt, address1,
                       address2, address3, cred_branch, acct_of_cd,
                       acct_of_cd_sw, incept_tag, expiry_tag, valid_date
                  FROM gipi_quote
                 WHERE quote_id = p_quote_id)
      LOOP
         INSERT INTO gipi_quote
                     (proposal_no,
                      quote_id, line_cd, subline_cd, iss_cd,
                      quotation_yy, quotation_no, assd_no,
                      assd_name, tsi_amt, prem_amt, remarks,
                      header, footer, status, print_tag, incept_date,
                      expiry_date, last_update, user_id, accept_dt,
                      address1, address2, address3, cred_branch,
                      acct_of_cd, acct_of_cd_sw, incept_tag,
                      expiry_tag, valid_date,
                      underwriter, copied_quote_id
                     )
              VALUES (gipi_quote_pkg.compute_proposal (a.line_cd,
                                                       a.subline_cd,
                                                       a.iss_cd,
                                                       a.quotation_yy,
                                                       a.quotation_no
                                                      ),
                      v_new_quote_id, a.line_cd, a.subline_cd, a.iss_cd,
                      a.quotation_yy, a.quotation_no, a.assd_no,
                      a.assd_name, a.tsi_amt, a.prem_amt, a.remarks,
                      a.header, a.footer, 'N', a.print_tag, a.incept_date,
                      a.expiry_date, SYSDATE, NVL (p_user, USER), SYSDATE,
                      a.address1, a.address2, a.address3, a.cred_branch,
                      a.acct_of_cd, a.acct_of_cd_sw, a.incept_tag,
                      a.expiry_tag, ADD_MONTHS (SYSDATE, 1),
                      NVL (p_user, USER), p_quote_id
                     );

         FOR v IN (SELECT item_no, item_title, item_desc, currency_cd,
                          currency_rate, pack_line_cd, pack_subline_cd,
                          tsi_amt, prem_amt
                     FROM gipi_quote_item
                    WHERE quote_id = p_quote_id)
         LOOP
            INSERT INTO gipi_quote_item
                        (quote_id, item_no, item_title,
                         item_desc, currency_cd, currency_rate,
                         pack_line_cd, pack_subline_cd, tsi_amt,
                         prem_amt
                        )
                 VALUES (v_new_quote_id, v.item_no, v.item_title,
                         v.item_desc, v.currency_cd, v.currency_rate,
                         v.pack_line_cd, v.pack_subline_cd, v.tsi_amt,
                         v.prem_amt
                        );

            FOR m IN (SELECT item_no, peril_cd, tsi_amt, prem_amt, prem_rt,
                             comp_rem
                        FROM gipi_quote_itmperil
                       WHERE quote_id = p_quote_id AND item_no = v.item_no)
            LOOP
               INSERT INTO gipi_quote_itmperil
                           (quote_id, item_no, peril_cd,
                            tsi_amt, prem_amt, prem_rt, comp_rem
                           )
                    VALUES (v_new_quote_id, m.item_no, m.peril_cd,
                            m.tsi_amt, m.prem_amt, m.prem_rt, m.comp_rem
                           );
            END LOOP;

            FOR b IN (SELECT quote_inv_no, iss_cd, intm_no, currency_cd,
                             currency_rt, prem_amt, tax_amt
                        FROM gipi_quote_invoice
                       WHERE quote_id = p_quote_id)
            LOOP
               FOR j IN (SELECT quote_inv_no
                           FROM giis_quote_inv_seq
                          WHERE iss_cd = a.iss_cd)
               LOOP
                  v_quote_inv_no := j.quote_inv_no + 1;
                  EXIT;
               END LOOP;

               INSERT INTO gipi_quote_invoice
                           (quote_id, iss_cd, quote_inv_no,
                            intm_no, currency_cd, currency_rt,
                            prem_amt, tax_amt
                           )
                    VALUES (v_new_quote_id, b.iss_cd, v_quote_inv_no,
                            b.intm_no, b.currency_cd, b.currency_rt,
                            b.prem_amt, b.tax_amt
                           );

               FOR dbt IN (SELECT line_cd, iss_cd, tax_cd, tax_id, tax_amt,
                                  rate
                             FROM gipi_quote_invtax
                            WHERE quote_inv_no = b.quote_inv_no
                              AND iss_cd = b.iss_cd)
               LOOP
                  INSERT INTO gipi_quote_invtax
                              (line_cd, iss_cd, quote_inv_no,
                               tax_cd, tax_id, tax_amt, rate
                              )
                       VALUES (dbt.line_cd, dbt.iss_cd, v_quote_inv_no,
                               dbt.tax_cd, dbt.tax_id, dbt.tax_amt, dbt.rate
                              );
               END LOOP;
            END LOOP;
         END LOOP;

         FOR z IN (SELECT menu_line_cd
                     FROM giis_line
                    WHERE line_cd = a.line_cd)
         LOOP
            v_menu_line_cd := z.menu_line_cd;
            EXIT;
         END LOOP;

         IF v_menu_line_cd = 'AC' OR a.line_cd = v_accident_cd
         THEN
            FOR ac IN (SELECT item_no, no_of_persons, position_cd,
                              monthly_salary, salary_grade, destination,
                              ac_class_cd, age, civil_status, date_of_birth,
                              group_print_sw, height, level_cd,
                              parent_level_cd, sex, weight
                         FROM gipi_quote_ac_item
                        WHERE quote_id = p_quote_id)
            LOOP
               INSERT INTO gipi_quote_ac_item
                           (quote_id, item_no, no_of_persons,
                            position_cd, monthly_salary,
                            salary_grade, destination, ac_class_cd,
                            age, civil_status, date_of_birth,
                            group_print_sw, height, level_cd,
                            parent_level_cd, sex, weight, user_id,
                            last_update
                           )
                    VALUES (v_new_quote_id, ac.item_no, ac.no_of_persons,
                            ac.position_cd, ac.monthly_salary,
                            ac.salary_grade, ac.destination, ac.ac_class_cd,
                            ac.age, ac.civil_status, ac.date_of_birth,
                            ac.group_print_sw, ac.height, ac.level_cd,
                            ac.parent_level_cd, ac.sex, ac.weight, USER,
                            SYSDATE
                           );
            END LOOP;
         ELSIF v_menu_line_cd = 'MC' OR a.line_cd = v_motor_cd
         THEN
            FOR mc IN (SELECT item_no, plate_no, motor_no, serial_no,
                              subline_type_cd, mot_type, car_company_cd,
                              coc_yy, coc_seq_no, coc_serial_no, coc_type,
                              repair_lim, color, model_year, make, est_value,
                              towing, assignee, no_of_pass, tariff_zone,
                              coc_issue_date, mv_file_no, acquired_from,
                              ctv_tag, type_of_body_cd, unladen_wt, make_cd,
                              series_cd, basic_color_cd, color_cd, origin,
                              destination, coc_atcn, subline_cd
                         FROM gipi_quote_item_mc
                        WHERE quote_id = p_quote_id)
            LOOP
               INSERT INTO gipi_quote_item_mc
                           (quote_id, item_no, plate_no,
                            motor_no, serial_no, subline_type_cd,
                            mot_type, car_company_cd, coc_yy,
                            coc_seq_no, coc_serial_no, coc_type,
                            repair_lim, color, model_year, make,
                            est_value, towing, assignee,
                            no_of_pass, tariff_zone,
                            coc_issue_date, mv_file_no,
                            acquired_from, ctv_tag,
                            type_of_body_cd, unladen_wt, make_cd,
                            series_cd, basic_color_cd, color_cd,
                            origin, destination, coc_atcn,
                            subline_cd, user_id, last_update
                           )
                    VALUES (v_new_quote_id, mc.item_no, mc.plate_no,
                            mc.motor_no, mc.serial_no, mc.subline_type_cd,
                            mc.mot_type, mc.car_company_cd, mc.coc_yy,
                            mc.coc_seq_no, mc.coc_serial_no, mc.coc_type,
                            mc.repair_lim, mc.color, mc.model_year, mc.make,
                            mc.est_value, mc.towing, mc.assignee,
                            mc.no_of_pass, mc.tariff_zone,
                            mc.coc_issue_date, mc.mv_file_no,
                            mc.acquired_from, mc.ctv_tag,
                            mc.type_of_body_cd, mc.unladen_wt, mc.make_cd,
                            mc.series_cd, mc.basic_color_cd, mc.color_cd,
                            mc.origin, mc.destination, mc.coc_atcn,
                            mc.subline_cd, USER, SYSDATE
                           );
            END LOOP;
         ELSIF v_menu_line_cd = 'FI' OR a.line_cd = v_fire_cd
         THEN
            FOR fi IN (SELECT item_no, district_no, eq_zone, tarf_cd,
                              block_no, fr_item_type, loc_risk1, loc_risk2,
                              loc_risk3, tariff_zone, typhoon_zone,
                              construction_cd, construction_remarks, front,
                              RIGHT, LEFT, rear, occupancy_cd,
                              occupancy_remarks, flood_zone, assignee,
                              block_id, risk_cd
                         FROM gipi_quote_fi_item
                        WHERE quote_id = p_quote_id)
            LOOP
               INSERT INTO gipi_quote_fi_item
                           (quote_id, item_no, district_no,
                            eq_zone, tarf_cd, block_no,
                            fr_item_type, loc_risk1, loc_risk2,
                            loc_risk3, tariff_zone, typhoon_zone,
                            construction_cd, construction_remarks,
                            front, RIGHT, LEFT, rear,
                            occupancy_cd, occupancy_remarks,
                            flood_zone, assignee, block_id,
                            risk_cd, user_id, last_update
                           )
                    VALUES (v_new_quote_id, fi.item_no, fi.district_no,
                            fi.eq_zone, fi.tarf_cd, fi.block_no,
                            fi.fr_item_type, fi.loc_risk1, fi.loc_risk2,
                            fi.loc_risk3, fi.tariff_zone, fi.typhoon_zone,
                            fi.construction_cd, fi.construction_remarks,
                            fi.front, fi.RIGHT, fi.LEFT, fi.rear,
                            fi.occupancy_cd, fi.occupancy_remarks,
                            fi.flood_zone, fi.assignee, fi.block_id,
                            fi.risk_cd, USER, SYSDATE
                           );
            END LOOP;
         ELSIF v_menu_line_cd = 'EN' OR a.line_cd = v_engrng_cd
         THEN
            FOR en IN (SELECT engg_basic_infonum, contract_proj_buss_title,
                              site_location, construct_start_date,
                              construct_end_date, maintain_start_date,
                              maintain_end_date, testing_start_date,
                              testing_end_date, weeks_test, time_excess,
                              mbi_policy_no
                         FROM gipi_quote_en_item
                        WHERE quote_id = p_quote_id)
            LOOP
               INSERT INTO gipi_quote_en_item
                           (quote_id, engg_basic_infonum,
                            contract_proj_buss_title, site_location,
                            construct_start_date, construct_end_date,
                            maintain_start_date, maintain_end_date,
                            testing_start_date, testing_end_date,
                            weeks_test, time_excess, mbi_policy_no,
                            user_id, last_update
                           )
                    VALUES (v_new_quote_id, en.engg_basic_infonum,
                            en.contract_proj_buss_title, en.site_location,
                            en.construct_start_date, en.construct_end_date,
                            en.maintain_start_date, en.maintain_end_date,
                            en.testing_start_date, en.testing_end_date,
                            en.weeks_test, en.time_excess, en.mbi_policy_no,
                            USER, SYSDATE
                           );
            END LOOP;
         ELSIF v_menu_line_cd = 'CA' OR a.line_cd = v_casualty_cd
         THEN
            FOR ca IN (SELECT item_no, section_line_cd, section_subline_cd,
                              section_or_hazard_cd, capacity_cd,
                              property_no_type, property_no, LOCATION,
                              conveyance_info, interest_on_premises,
                              limit_of_liability, section_or_hazard_info
                         FROM gipi_quote_ca_item
                        WHERE quote_id = p_quote_id)
            LOOP
               INSERT INTO gipi_quote_ca_item
                           (quote_id, item_no, section_line_cd,
                            section_subline_cd, section_or_hazard_cd,
                            capacity_cd, property_no_type,
                            property_no, LOCATION, conveyance_info,
                            interest_on_premises, limit_of_liability,
                            section_or_hazard_info, user_id, last_update
                           )
                    VALUES (v_new_quote_id, ca.item_no, ca.section_line_cd,
                            ca.section_subline_cd, ca.section_or_hazard_cd,
                            ca.capacity_cd, ca.property_no_type,
                            ca.property_no, ca.LOCATION, ca.conveyance_info,
                            ca.interest_on_premises, ca.limit_of_liability,
                            ca.section_or_hazard_info, USER, SYSDATE
                           );
            END LOOP;
         ELSIF v_menu_line_cd = 'MN' OR a.line_cd = v_cargo_cd
         THEN
            FOR ves IN (SELECT vessel_cd, rec_flag, vescon, voy_limit
                          FROM gipi_quote_ves_air
                         WHERE quote_id = p_quote_id)
            LOOP
               INSERT INTO gipi_quote_ves_air
                           (quote_id, vessel_cd, rec_flag,
                            vescon, voy_limit
                           )
                    VALUES (v_new_quote_id, ves.vessel_cd, ves.rec_flag,
                            ves.vescon, ves.voy_limit
                           );
            END LOOP;

            FOR mn IN (SELECT item_no, vessel_cd, geog_cd, cargo_class_cd,
                              voyage_no, bl_awb, origin, destn, etd, eta,
                              cargo_type, pack_method, tranship_origin,
                              tranship_destination, lc_no, print_tag,
                              deduct_text, rec_flag
                         FROM gipi_quote_cargo
                        WHERE quote_id = p_quote_id)
            LOOP
               INSERT INTO gipi_quote_cargo
                           (quote_id, item_no, vessel_cd,
                            geog_cd, cargo_class_cd, voyage_no,
                            bl_awb, origin, destn, etd, eta,
                            cargo_type, pack_method,
                            tranship_origin, tranship_destination,
                            lc_no, print_tag, deduct_text,
                            rec_flag, user_id, last_update
                           )
                    VALUES (v_new_quote_id, mn.item_no, mn.vessel_cd,
                            mn.geog_cd, mn.cargo_class_cd, mn.voyage_no,
                            mn.bl_awb, mn.origin, mn.destn, mn.etd, mn.eta,
                            mn.cargo_type, mn.pack_method,
                            mn.tranship_origin, mn.tranship_destination,
                            mn.lc_no, mn.print_tag, mn.deduct_text,
                            mn.rec_flag, USER, SYSDATE
                           );
            END LOOP;
         ELSIF v_menu_line_cd = 'AV' OR a.line_cd = v_aviation_cd
         THEN
            FOR av IN (SELECT item_no, vessel_cd, total_fly_time,
                              qualification, purpose, geog_limit,
                              deduct_text, rec_flag, fixed_wing, rotor,
                              prev_util_hrs, est_util_hrs
                         FROM gipi_quote_av_item
                        WHERE quote_id = p_quote_id)
            LOOP
               INSERT INTO gipi_quote_av_item
                           (quote_id, item_no, vessel_cd,
                            total_fly_time, qualification, purpose,
                            geog_limit, deduct_text, rec_flag,
                            fixed_wing, rotor, prev_util_hrs,
                            est_util_hrs, user_id, last_update
                           )
                    VALUES (v_new_quote_id, av.item_no, av.vessel_cd,
                            av.total_fly_time, av.qualification, av.purpose,
                            av.geog_limit, av.deduct_text, av.rec_flag,
                            av.fixed_wing, av.rotor, av.prev_util_hrs,
                            av.est_util_hrs, USER, SYSDATE
                           );
            END LOOP;
         ELSIF v_menu_line_cd = 'MH' OR a.line_cd = v_hull_cd
         THEN
            FOR ves IN (SELECT vessel_cd, rec_flag, vescon, voy_limit
                          FROM gipi_quote_ves_air
                         WHERE quote_id = p_quote_id)
            LOOP
               INSERT INTO gipi_quote_ves_air
                           (quote_id, vessel_cd, rec_flag,
                            vescon, voy_limit
                           )
                    VALUES (v_new_quote_id, ves.vessel_cd, ves.rec_flag,
                            ves.vescon, ves.voy_limit
                           );
            END LOOP;

            FOR mh IN (SELECT item_no, vessel_cd, geog_limit, rec_flag,
                              deduct_text, dry_date, dry_place
                         FROM gipi_quote_mh_item
                        WHERE quote_id = p_quote_id)
            LOOP
               INSERT INTO gipi_quote_mh_item
                           (quote_id, item_no, vessel_cd,
                            geog_limit, rec_flag, deduct_text,
                            dry_date, dry_place, user_id, last_update
                           )
                    VALUES (v_new_quote_id, mh.item_no, mh.vessel_cd,
                            mh.geog_limit, mh.rec_flag, mh.deduct_text,
                            mh.dry_date, mh.dry_place, USER, SYSDATE
                           );
            END LOOP;
         ELSIF v_menu_line_cd = 'SU' OR a.line_cd = v_surety_cd
         THEN
            FOR su IN (SELECT obligee_no, prin_id, val_period_unit,
                              val_period, coll_flag, clause_type, np_no,
                              contract_dtl, contract_date, co_prin_sw,
                              waiver_limit, indemnity_text, bond_dtl,
                              endt_eff_date, remarks
                         FROM gipi_quote_bond_basic
                        WHERE quote_id = p_quote_id)
            LOOP
               INSERT INTO gipi_quote_bond_basic
                           (quote_id, obligee_no, prin_id,
                            val_period_unit, val_period, coll_flag,
                            clause_type, np_no, contract_dtl,
                            contract_date, co_prin_sw,
                            waiver_limit, indemnity_text, bond_dtl,
                            endt_eff_date, remarks
                           )
                    VALUES (v_new_quote_id, su.obligee_no, su.prin_id,
                            su.val_period_unit, su.val_period, su.coll_flag,
                            su.clause_type, su.np_no, su.contract_dtl,
                            su.contract_date, su.co_prin_sw,
                            su.waiver_limit, su.indemnity_text, su.bond_dtl,
                            su.endt_eff_date, su.remarks
                           );
            END LOOP;
         END IF;

         FOR wc IN (SELECT line_cd, wc_cd, print_seq_no, wc_title, wc_title2,
                           wc_text01, wc_text02, wc_text03, wc_text04,
                           wc_text05, wc_text06, wc_text07, wc_text08,
                           wc_text09, wc_text10, wc_text11, wc_text12,
                           wc_text13, wc_text14, wc_text15, wc_text16,
                           wc_text17, wc_remarks, print_sw, change_tag
                      FROM gipi_quote_wc
                     WHERE quote_id = p_quote_id)
         LOOP
            INSERT INTO gipi_quote_wc
                        (quote_id, line_cd, wc_cd,
                         print_seq_no, wc_title, wc_title2,
                         wc_text01, wc_text02, wc_text03,
                         wc_text04, wc_text05, wc_text06,
                         wc_text07, wc_text08, wc_text09,
                         wc_text10, wc_text11, wc_text12,
                         wc_text13, wc_text14, wc_text15,
                         wc_text16, wc_text17, wc_remarks,
                         print_sw, change_tag, user_id, last_update
                        )
                 VALUES (v_new_quote_id, wc.line_cd, wc.wc_cd,
                         wc.print_seq_no, wc.wc_title, wc.wc_title2,
                         wc.wc_text01, wc.wc_text02, wc.wc_text03,
                         wc.wc_text04, wc.wc_text05, wc.wc_text06,
                         wc.wc_text07, wc.wc_text08, wc.wc_text09,
                         wc.wc_text10, wc.wc_text11, wc.wc_text12,
                         wc.wc_text13, wc.wc_text14, wc.wc_text15,
                         wc.wc_text16, wc.wc_text17, wc.wc_remarks,
                         wc.print_sw, wc.change_tag, USER, SYSDATE
                        );
         END LOOP;

         FOR co IN (SELECT cosign_id, assd_no, indem_flag, bonds_flag,
                           bonds_ri_flag
                      FROM gipi_quote_cosign
                     WHERE quote_id = p_quote_id)
         LOOP
            INSERT INTO gipi_quote_cosign
                        (quote_id, cosign_id, assd_no,
                         indem_flag, bonds_flag, bonds_ri_flag
                        )
                 VALUES (v_new_quote_id, co.cosign_id, co.assd_no,
                         co.indem_flag, co.bonds_flag, co.bonds_ri_flag
                        );
         END LOOP;

         FOR dis IN (SELECT surcharge_rt, surcharge_amt, subline_cd, SEQUENCE,
                            remarks, orig_prem_amt, net_prem_amt,
                            net_gross_tag, line_cd, item_no, disc_rt,
                            disc_amt
                       FROM gipi_quote_item_discount
                      WHERE quote_id = p_quote_id)
         LOOP
            INSERT INTO gipi_quote_item_discount
                        (quote_id, surcharge_rt,
                         surcharge_amt, subline_cd, SEQUENCE,
                         remarks, orig_prem_amt, net_prem_amt,
                         net_gross_tag, line_cd, item_no,
                         disc_rt, disc_amt, last_update
                        )
                 VALUES (v_new_quote_id, dis.surcharge_rt,
                         dis.surcharge_amt, dis.subline_cd, dis.SEQUENCE,
                         dis.remarks, dis.orig_prem_amt, dis.net_prem_amt,
                         dis.net_gross_tag, dis.line_cd, dis.item_no,
                         dis.disc_rt, dis.disc_amt, SYSDATE
                        );
         END LOOP;

         FOR pol IN (SELECT line_cd, subline_cd, disc_rt, disc_amt,
                            net_gross_tag, orig_prem_amt, SEQUENCE,
                            net_prem_amt, remarks, surcharge_rt,
                            surcharge_amt
                       FROM gipi_quote_polbasic_discount
                      WHERE quote_id = p_quote_id)
         LOOP
            INSERT INTO gipi_quote_polbasic_discount
                        (quote_id, line_cd, subline_cd,
                         disc_rt, disc_amt, net_gross_tag,
                         orig_prem_amt, SEQUENCE, net_prem_amt,
                         remarks, surcharge_rt, surcharge_amt,
                         last_update
                        )
                 VALUES (v_new_quote_id, pol.line_cd, pol.subline_cd,
                         pol.disc_rt, pol.disc_amt, pol.net_gross_tag,
                         pol.orig_prem_amt, pol.SEQUENCE, pol.net_prem_amt,
                         pol.remarks, pol.surcharge_rt, pol.surcharge_amt,
                         SYSDATE
                        );
         END LOOP;

         FOR prin IN (SELECT principal_cd, engg_basic_infonum, subcon_sw
                        FROM gipi_quote_principal
                       WHERE quote_id = p_quote_id)
         LOOP
            INSERT INTO gipi_quote_principal
                        (quote_id, principal_cd,
                         engg_basic_infonum, subcon_sw
                        )
                 VALUES (v_new_quote_id, prin.principal_cd,
                         prin.engg_basic_infonum, prin.subcon_sw
                        );
         END LOOP;

         FOR pic IN (SELECT item_no, file_name, file_type, file_ext, remarks
                       FROM gipi_quote_pictures
                      WHERE quote_id = p_quote_id)
         LOOP
            INSERT INTO gipi_quote_pictures
                        (quote_id, item_no, file_name,
                         file_type, file_ext, remarks, user_id,
                         last_update
                        )
                 VALUES (v_new_quote_id, pic.item_no, pic.file_name,
                         pic.file_type, pic.file_ext, pic.remarks, USER,
                         SYSDATE
                        );
         END LOOP;

         FOR d IN (SELECT item_no, peril_cd, ded_deductible_cd,
                          deductible_amt, deductible_text, deductible_rt
                     FROM gipi_quote_deductibles
                    WHERE quote_id = p_quote_id)
         LOOP
            INSERT INTO gipi_quote_deductibles
                        (quote_id, item_no, peril_cd,
                         ded_deductible_cd, deductible_text,
                         deductible_amt, deductible_rt, user_id, last_update
                        )
                 VALUES (v_new_quote_id, d.item_no, d.peril_cd,
                         d.ded_deductible_cd, d.deductible_text,
                         d.deductible_amt, d.deductible_rt, USER, SYSDATE
                        );
         END LOOP;

         FOR pd IN (SELECT item_no, line_cd, peril_cd, disc_rt, level_tag,
                           disc_amt, net_gross_tag, discount_tag, subline_cd,
                           orig_peril_prem_amt, SEQUENCE, net_prem_amt,
                           remarks, surcharge_rt, surcharge_amt
                      FROM gipi_quote_peril_discount
                     WHERE quote_id = p_quote_id)
         LOOP
            INSERT INTO gipi_quote_peril_discount
                        (quote_id, item_no, line_cd,
                         peril_cd, disc_rt, level_tag, disc_amt,
                         net_gross_tag, discount_tag, subline_cd,
                         orig_peril_prem_amt, SEQUENCE,
                         net_prem_amt, remarks, surcharge_rt,
                         surcharge_amt, last_update
                        )
                 VALUES (v_new_quote_id, pd.item_no, pd.line_cd,
                         pd.peril_cd, pd.disc_rt, pd.level_tag, pd.disc_amt,
                         pd.net_gross_tag, pd.discount_tag, pd.subline_cd,
                         pd.orig_peril_prem_amt, pd.SEQUENCE,
                         pd.net_prem_amt, pd.remarks, pd.surcharge_rt,
                         pd.surcharge_amt, SYSDATE
                        );
         END LOOP;

         FOR gqm IN (SELECT iss_cd, item_no, mortg_cd, amount, remarks
                       FROM gipi_quote_mortgagee
                      WHERE quote_id = p_quote_id)
         LOOP
            INSERT INTO gipi_quote_mortgagee
                        (quote_id, iss_cd, item_no,
                         mortg_cd, amount, remarks, user_id, last_update
                        )
                 VALUES (v_new_quote_id, gqm.iss_cd, gqm.item_no,
                         gqm.mortg_cd, gqm.amount, gqm.remarks, USER, SYSDATE
                        );
         END LOOP;
      END LOOP;
   END;

   FUNCTION compute_proposal (
      p_line_cd        IN   VARCHAR2,
      p_subline_cd     IN   VARCHAR2,
      p_iss_cd         IN   VARCHAR2,
      p_quotation_yy   IN   NUMBER,
      p_quotation_no   IN   NUMBER
   )
      RETURN NUMBER
   IS
      v_proposal_no   NUMBER := 0;
   BEGIN
      SELECT MAX (proposal_no)
        INTO v_proposal_no
        FROM gipi_quote
       WHERE line_cd = p_line_cd
         AND subline_cd = p_subline_cd
         AND iss_cd = p_iss_cd
         AND quotation_yy = p_quotation_yy
         AND quotation_no = p_quotation_no;

      v_proposal_no := v_proposal_no + 1;
      RETURN (v_proposal_no);
   END;

   /* BRYAN
   for GIPIS050 SELECT QUOTATION
   */
   FUNCTION get_quote_list (
      p_iss_cd    gipi_quote.iss_cd%TYPE,
      p_line_cd   gipi_quote.line_cd%TYPE,
      p_module    giis_user_grp_modules.module_id%TYPE,
      p_keyword   VARCHAR2,
      p_user_id   giis_users.user_id%TYPE
   )
      RETURN gipi_quote_list_tab PIPELINED
   IS
      v_quote   gipi_quote_list_type;
   BEGIN
      FOR i IN
         (SELECT   a.quote_id, a.line_cd, a.iss_cd, a.subline_cd,
                   TO_CHAR (a.quotation_yy) quotation_yy,
                   TO_CHAR (a.quotation_no, '000009') quotation_no,
                   TO_CHAR (a.proposal_no, '009') proposal_no,
                   LTRIM (TO_CHAR (a.assd_no, '000000000009')) assd_no,
                   NVL (b.assd_name, a.assd_name) assd_name,
                   NVL (b.active_tag, 'N') assd_active_tag, a.valid_date,
                   a.incept_date, a.expiry_date,
                      a.line_cd
                   || '-'
                   || a.subline_cd
                   || '-'
                   || a.iss_cd
                   || '-'
                   || TO_CHAR (a.quotation_yy)
                   || '-'
                   || TO_CHAR (a.quotation_no, '000009')
                   || '-'
                   || TO_CHAR (a.proposal_no, '009') quote_no
              FROM gipi_quote a, giis_assured b
             WHERE status = 'N'
               AND iss_cd = NVL (p_iss_cd, iss_cd)
               AND line_cd = NVL (p_line_cd, line_cd)
               AND check_user_per_line2 (line_cd,
                                         p_iss_cd,
                                         p_module,
                                         p_user_id
                                        ) = 1
               AND b.assd_no(+) = a.assd_no
               AND (   UPPER (a.line_cd) LIKE '%' || UPPER (p_keyword) || '%'
                    OR UPPER (a.iss_cd) LIKE '%' || UPPER (p_keyword) || '%'
                    OR UPPER (a.subline_cd) LIKE
                                                '%' || UPPER (p_keyword)
                                                || '%'
                    OR UPPER (a.quotation_yy) LIKE
                                                '%' || UPPER (p_keyword)
                                                || '%'
                    OR UPPER (a.quotation_no) LIKE
                                                '%' || UPPER (p_keyword)
                                                || '%'
                    OR UPPER (a.proposal_no) LIKE
                                                '%' || UPPER (p_keyword)
                                                || '%'
                    OR UPPER (a.assd_no) LIKE '%' || UPPER (p_keyword) || '%'
                    OR UPPER (a.assd_name) LIKE '%' || UPPER (p_keyword)
                                                || '%'
                    OR UPPER (   a.line_cd
                              || '-'
                              || a.subline_cd
                              || '-'
                              || a.iss_cd
                              || '-'
                              || TO_CHAR (a.quotation_yy)
                              || '-'
                              || TO_CHAR (a.quotation_no, '000009')
                              || '-'
                              || TO_CHAR (a.proposal_no, '009')
                             ) LIKE UPPER (NVL (p_keyword, '%%'))
                   )
          ORDER BY a.line_cd,
                   a.subline_cd,
                   a.iss_cd,
                   a.quotation_yy,
                   a.quotation_no,
                   a.proposal_no)
      LOOP
         v_quote.quote_id := i.quote_id;
         v_quote.line_cd := i.line_cd;
         v_quote.iss_cd := i.iss_cd;
         v_quote.subline_cd := i.subline_cd;
         v_quote.quotation_yy := i.quotation_yy;
         v_quote.quotation_no := i.quotation_no;
         v_quote.proposal_no := i.proposal_no;
         v_quote.assd_no := i.assd_no;
         v_quote.assd_name := i.assd_name;
         v_quote.assd_active_tag := i.assd_active_tag;
         v_quote.valid_date := i.valid_date;
         v_quote.quote_no := i.quote_no;
         v_quote.incept_date := i.incept_date;
         v_quote.expiry_date := i.expiry_date;
         PIPE ROW (v_quote);
      END LOOP;

      RETURN;
   END;

   /*BRYAN February 19, 2010
   */
   PROCEDURE set_quote_to_par_updates (
      p_quote_id   gipi_quote.quote_id%TYPE,
      p_assd_no    gipi_quote.assd_no%TYPE,
      p_line_cd    gipi_quote.line_cd%TYPE,
      p_iss_cd     gipi_quote.iss_cd%TYPE
   )
   IS
      v_quote      NUMBER;
      v_subline    VARCHAR2 (8);
      v_quote_yy   gipi_quote.quotation_yy%TYPE;
      p_message    VARCHAR2 (4000);
   BEGIN
      UPDATE gipi_quote
         SET status = 'W'
       WHERE quote_id = p_quote_id;

      SELECT quotation_no, quotation_yy, subline_cd
        INTO v_quote, v_quote_yy, v_subline
        FROM gipi_quote
       WHERE quote_id = p_quote_id;

      UPDATE gipi_quote
         SET status = 'X'
       WHERE line_cd = p_line_cd
         AND iss_cd = p_iss_cd
         AND quotation_yy = v_quote_yy
         AND quotation_no = v_quote
         AND subline_cd = v_subline
         AND quote_id != p_quote_id;
   /*GIPI_WPOLBAS_PKG.create_gipi_wpolbas(p_quote_id, p_par_id, p_line_cd, p_iss_cd,
                                                     p_assd_no, USER, p_message);*/
   --COMMIT; --commented for transaction purposes
   END set_quote_to_par_updates;

   PROCEDURE update_status (
      p_line_cd        gipi_quote.line_cd%TYPE,
      p_iss_cd         gipi_quote.iss_cd%TYPE,
      p_quotation_yy   gipi_quote.quotation_yy%TYPE,
      p_quotation_no   gipi_quote.quotation_no%TYPE,
      p_subline_cd     gipi_quote.subline_cd%TYPE,
      p_status         gipi_quote.status%TYPE
   )
   IS
   BEGIN
      UPDATE gipi_quote
         SET status = p_status
       WHERE line_cd = p_line_cd
         AND iss_cd = p_iss_cd
         AND quotation_yy = p_quotation_yy
         AND quotation_no = p_quotation_no
         AND subline_cd = p_subline_cd;
   END update_status;

   PROCEDURE updatequotepremamt (
      p_quote_id   gipi_quote.quote_id%TYPE,
      p_premamt    gipi_quote.prem_amt%TYPE
   )
   IS
   BEGIN
      UPDATE gipi_quote
         SET prem_amt = p_premamt
       WHERE quote_id = p_quote_id;
   END updatequotepremamt;

   PROCEDURE update_return_from_par_status (
      p_quote_id   gipi_quote.quote_id%TYPE
   )
   IS
   BEGIN
      UPDATE gipi_quote
         SET status = 'N'
       WHERE quote_id = p_quote_id;
   END update_return_from_par_status;

   PROCEDURE update_reason_cd (
      p_quote_id    gipi_quote.quote_id%TYPE,
      p_reason_cd   gipi_quote.reason_cd%TYPE
   )
   IS
   BEGIN
      UPDATE gipi_quote
         SET reason_cd = p_reason_cd
       WHERE quote_id = p_quote_id;
   END update_reason_cd;

    /**
        added v_exist2 - irwin
    */
   FUNCTION get_existing_quotes_pol_list (
      p_line_cd     gipi_quote.line_cd%TYPE,
      p_assd_no     gipi_quote.assd_no%TYPE,
      p_assd_name   gipi_quote.assd_name%TYPE,
      v_exist2      varchar2
   )
      RETURN existing_quotes_tab PIPELINED
   IS
      v_rec   existing_quotes_type;
   BEGIN
     --IF nvl(p_assd_no, '') <> '' -- andrew 04.23.2013 - use this query if p_assd_no is not null or not empty
     IF NVL(p_assd_no, 0) = 0 --robert 09.10.2013, -- apollo 12.08.2014 changed '' to 0  
      THEN
         FOR i IN (SELECT a.quote_id, a.quotation_yy, a.quotation_no,
                          a.proposal_no, a.incept_date, a.expiry_date,
                          NULL par_id, NULL par_yy, NULL par_seq_no,
                          NULL quote_seq_no, NULL policy_id, a.subline_cd,
                          NULL issue_yy, NULL pol_seq_no, NULL endt_iss_cd,
                          NULL endt_yy, NULL endt_seq_no, NULL renew_no,
                          a.line_cd, a.iss_cd, a.tsi_amt tsi_amt,
                          a.address1 address1, NULL assd_no, NULL assd_name,
                          a.address2 address2, a.address3 address3,
                          a.status status
                     FROM gipi_quote a
                    WHERE 1 = 1
                      AND a.line_cd = p_line_cd
                      AND a.assd_name = p_assd_name)
         LOOP
            v_rec.quotation_no := i.quotation_no;
            v_rec.quote_id := i.quote_id;
            v_rec.quotation_yy := i.quotation_yy;
            v_rec.proposal_no := i.proposal_no;
            v_rec.incept_date := i.incept_date;
            v_rec.expiry_date := i.expiry_date;
            v_rec.status :=
               cg_ref_codes_pkg.get_rv_meaning ('GIPI_QUOTE.STATUS',
                                                i.status);
            v_rec.par_id := i.par_id;
            v_rec.par_yy := i.par_yy;
            v_rec.par_seq_no := i.par_seq_no;
            v_rec.quote_seq_no := i.quote_seq_no;
            v_rec.policy_id := i.policy_id;
            v_rec.subline_cd := i.subline_cd;
            v_rec.issue_yy := i.issue_yy;
            v_rec.pol_seq_no := i.pol_seq_no;
            v_rec.endt_iss_cd := i.endt_iss_cd;
            v_rec.endt_yy := i.endt_yy;
            v_rec.endt_seq_no := i.endt_seq_no;
            v_rec.renew_no := i.renew_no;
            v_rec.line_cd := i.line_cd;
            v_rec.iss_cd := i.iss_cd;
            v_rec.tsi_amt := i.tsi_amt;
            v_rec.assd_name := i.assd_name;
            v_rec.assd_no := i.assd_no;
            v_rec.address1 := i.address1;
            v_rec.address2 := i.address2;
            v_rec.address3 := i.address3;

            FOR asd IN (SELECT mail_addr1,
                     mail_addr2,
                     mail_addr3,
                     assd_name
                FROM giis_assured
               WHERE assd_no = p_assd_no)
            LOOP
               v_rec.address := asd.mail_addr1||' '||asd.mail_addr2||' '||asd.mail_addr3;
        end loop;
            IF i.quote_id IS NOT NULL
            THEN
               v_rec.quote_no :=
                     i.line_cd
                  || '-'
                  || i.subline_cd
                  || '-'
                  || i.iss_cd
                  || '-'
                  || TO_CHAR (i.quotation_yy, '0999')
                  || '-'
                  || TO_CHAR (i.quotation_no, '099999')
                  || '-'
                  || TO_CHAR (i.proposal_no, '099');
            ELSE
               v_rec.quote_no := NULL;
            END IF;

            IF i.par_id IS NOT NULL
            THEN
               v_rec.par_no :=
                     i.line_cd
                  || '-'
                  || i.iss_cd
                  || '-'
                  || TO_CHAR (i.par_yy, '09')
                  || '-'
                  || TO_CHAR (i.par_seq_no, '099999');
            ELSE
               v_rec.par_no := NULL;
            END IF;

            IF i.policy_id IS NOT NULL
            THEN
               v_rec.pol_no :=
                     i.line_cd
                  || '-'
                  || i.subline_cd
                  || '-'
                  || i.iss_cd
                  || '-'
                  || TO_CHAR (i.issue_yy, '09')
                  || '-'
                  || TO_CHAR (i.pol_seq_no, '0999999')
                  || '-'
                  || TO_CHAR (i.renew_no, '09');

               IF NVL (i.endt_seq_no, 0) <> 0
               THEN
                  v_rec.pol_no :=
                        v_rec.pol_no
                     || ' / '
                     || i.endt_iss_cd
                     || '-'
                     || LTRIM (TO_CHAR (i.endt_yy, '09'))
                     || '-'
                     || LTRIM (TO_CHAR (i.endt_seq_no, '9999999'));
               END IF;
               FOR pol IN (SELECT policy_id FROM GIPI_POLBASIC a
                            WHERE a.line_cd = i.line_cd
                              AND a.subline_cd = i.subline_cd
                              AND a.iss_cd = i.iss_cd
                              AND a.issue_yy = i.issue_yy
                              AND a.pol_seq_no = i.pol_seq_no
                              AND a.renew_no = i.renew_no
                              AND a.endt_seq_no = 0)
               LOOP
                   v_rec.orig_policy_id := pol.policy_id;
                EXIT;
               END LOOP;
            ELSE
               v_rec.pol_no := NULL;
               v_rec.orig_policy_id := NULL;
            END IF;

            PIPE ROW (v_rec);
         END LOOP;
      ELSE
      FOR i IN (SELECT a.quote_id, a.quotation_yy, a.quotation_no,
                          a.proposal_no, a.incept_date, a.expiry_date,
                          NULL par_id, NULL par_yy, NULL par_seq_no,
                          NULL quote_seq_no, NULL policy_id, a.subline_cd,
                          NULL issue_yy, NULL pol_seq_no, NULL endt_iss_cd,
                          NULL endt_yy, NULL endt_seq_no, NULL renew_no,
                          a.line_cd, a.iss_cd, a.tsi_amt tsi_amt,
                          b.assd_name assd_name, b.assd_no assd_no,
                          a.address1 address1, a.address2 address2,
                          a.address3 address3, a.status status
                     FROM giis_assured b, gipi_quote a
                    WHERE 1 = 1
                      AND b.assd_no = a.assd_no
                      AND a.line_cd = p_line_cd
                      AND a.assd_no = p_assd_no
                      AND NOT EXISTS (SELECT 1
                                        FROM gipi_parlist z
                                       WHERE z.quote_id = a.quote_id)
                   UNION
                   SELECT a.quote_id, NULL quotation_yy, NULL quotation_no,
                          NULL proposal_no, b.incept_date, b.expiry_date,
                          a.par_id, a.par_yy, a.par_seq_no, a.quote_seq_no,
                          NULL policy_id, b.subline_cd, b.issue_yy,
                          b.pol_seq_no, b.endt_iss_cd, b.endt_yy,
                          b.endt_seq_no, b.renew_no, a.line_cd line_cd,
                          a.iss_cd iss_cd, b.tsi_amt tsi_amt,
                          c.assd_name assd_name, c.assd_no assd_no,
                          a.address1 address1, a.address2 address2,
                          a.address3 address3, NULL status
                     FROM giis_assured c, gipi_wpolbas b, gipi_parlist a
                    WHERE 1 = 1
                      AND c.assd_no = a.assd_no
                      AND b.par_id = a.par_id
                      AND a.par_status NOT IN (98, 99, 10)
                      AND a.line_cd = p_line_cd
                      AND a.assd_no = p_assd_no
                      AND NOT EXISTS (SELECT 1
                                        FROM gipi_quote z
                                       WHERE z.quote_id = a.quote_id)
                   UNION
                   SELECT a.quote_id, d.quotation_yy, d.quotation_no,
                          d.proposal_no, b.incept_date, b.expiry_date,
                          a.par_id, a.par_yy, a.par_seq_no, a.quote_seq_no,
                          NULL policy_id, b.subline_cd, b.issue_yy,
                          b.pol_seq_no, b.endt_iss_cd, b.endt_yy,
                          b.endt_seq_no, b.renew_no, a.line_cd line_cd,
                          a.iss_cd iss_cd, b.tsi_amt tsi_amt,
                          c.assd_name assd_name, c.assd_no assd_no,
                          a.address1 address1, a.address2 address2,
                          a.address3 address3, d.status status
                     FROM gipi_quote d,
                          giis_assured c,
                          gipi_wpolbas b,
                          gipi_parlist a
                    WHERE 1 = 1
                      AND d.quote_id = a.quote_id
                      AND c.assd_no = a.assd_no
                      AND b.par_id = a.par_id
                      AND a.par_status NOT IN (98, 99, 10)
                      AND a.line_cd = p_line_cd
                      AND a.assd_no = p_assd_no
                   UNION
                   SELECT a.quote_id, NULL quotation_yy, NULL quotation_no,
                          NULL proposal_no, b.incept_date, b.expiry_date,
                          a.par_id, a.par_yy, a.par_seq_no, a.quote_seq_no,
                          b.policy_id, b.subline_cd, b.issue_yy, b.pol_seq_no,
                          b.endt_iss_cd, b.endt_yy, b.endt_seq_no, b.renew_no,
                          a.line_cd line_cd, a.iss_cd iss_cd,
                          b.tsi_amt tsi_amt, c.assd_name assd_name,
                          c.assd_no assd_no, a.address1 address1,
                          a.address2 address2, a.address3 address3,
                          NULL status
                     FROM giis_assured c, gipi_polbasic b, gipi_parlist a
                    WHERE 1 = 1
                      AND c.assd_no = a.assd_no
                      AND b.par_id = a.par_id
                      AND a.par_status = 10
                      AND a.line_cd = p_line_cd
                      AND a.assd_no = p_assd_no
                      AND NOT EXISTS (SELECT 1
                                        FROM gipi_quote z
                                       WHERE z.quote_id = a.quote_id)
                   UNION
                   SELECT a.quote_id, d.quotation_yy, d.quotation_no,
                          d.proposal_no, b.incept_date, b.expiry_date,
                          a.par_id, a.par_yy, a.par_seq_no, a.quote_seq_no,
                          b.policy_id, b.subline_cd, b.issue_yy, b.pol_seq_no,
                          b.endt_iss_cd, b.endt_yy, b.endt_seq_no, b.renew_no,
                          a.line_cd line_cd, a.iss_cd iss_cd,
                          b.tsi_amt tsi_amt, c.assd_name assd_name,
                          c.assd_no assd_no, a.address1 address1,
                          a.address2 address2, a.address3 address3,
                          d.status status
                     FROM gipi_quote d,
                          giis_assured c,
                          gipi_polbasic b,
                          gipi_parlist a
                    WHERE 1 = 1
                      AND d.quote_id = a.quote_id
                      AND c.assd_no = a.assd_no
                      AND b.par_id = a.par_id
                      AND a.par_status = 10
                      AND a.line_cd = p_line_cd
                      AND a.assd_no = p_assd_no)
         LOOP
            v_rec.quotation_no := i.quotation_no;
            v_rec.quote_id := i.quote_id;
            v_rec.quotation_yy := i.quotation_yy;
            v_rec.proposal_no := i.proposal_no;
            v_rec.incept_date := i.incept_date;
            v_rec.expiry_date := i.expiry_date;
            v_rec.status :=
               cg_ref_codes_pkg.get_rv_meaning ('GIPI_QUOTE.STATUS',
                                                i.status);
            v_rec.par_id := i.par_id;
            v_rec.par_yy := i.par_yy;
            v_rec.par_seq_no := i.par_seq_no;
            v_rec.quote_seq_no := i.quote_seq_no;
            v_rec.policy_id := i.policy_id;
            v_rec.subline_cd := i.subline_cd;
            v_rec.issue_yy := i.issue_yy;
            v_rec.pol_seq_no := i.pol_seq_no;
            v_rec.endt_iss_cd := i.endt_iss_cd;
            v_rec.endt_yy := i.endt_yy;
            v_rec.endt_seq_no := i.endt_seq_no;
            v_rec.renew_no := i.renew_no;
            v_rec.line_cd := i.line_cd;
            v_rec.iss_cd := i.iss_cd;
            v_rec.tsi_amt := i.tsi_amt;
            v_rec.assd_name := i.assd_name;
            v_rec.assd_no := i.assd_no;
            v_rec.address1 := i.address1;
            v_rec.address2 := i.address2;
            v_rec.address3 := i.address3;

            FOR asd IN (SELECT mail_addr1,
                     mail_addr2,
                     mail_addr3,
                     assd_name
                FROM giis_assured
               WHERE assd_no = p_assd_no)
            LOOP
               v_rec.address := asd.mail_addr1||' '||asd.mail_addr2||' '||asd.mail_addr3;
        end loop;

            IF i.quote_id IS NOT NULL
            THEN
               v_rec.quote_no :=
                     i.line_cd
                  || '-'
                  || i.subline_cd
                  || '-'
                  || i.iss_cd
                  || '-'
                  || TO_CHAR (i.quotation_yy, '0999')
                  || '-'
                  || TO_CHAR (i.quotation_no, '099999')
                  || '-'
                  || TO_CHAR (i.proposal_no, '099');
            ELSE
               v_rec.quote_no := NULL;
            END IF;

            IF i.par_id IS NOT NULL
            THEN
               v_rec.par_no :=
                     i.line_cd
                  || '-'
                  || i.iss_cd
                  || '-'
                  || TO_CHAR (i.par_yy, '09')
                  || '-'
                  || TO_CHAR (i.par_seq_no, '099999');
            ELSE
               v_rec.par_no := NULL;
            END IF;

            IF i.policy_id IS NOT NULL
            THEN
               v_rec.pol_no :=
                     i.line_cd
                  || '-'
                  || i.subline_cd
                  || '-'
                  || i.iss_cd
                  || '-'
                  || TO_CHAR (i.issue_yy, '09')
                  || '-'
                  || TO_CHAR (i.pol_seq_no, '0999999')
                  || '-'
                  || TO_CHAR (i.renew_no, '09');

               IF NVL (i.endt_seq_no, 0) <> 0
               THEN
                  v_rec.pol_no :=
                        v_rec.pol_no
                     || ' / '
                     || i.endt_iss_cd
                     || '-'
                     || LTRIM (TO_CHAR (i.endt_yy, '09'))
                     || '-'
                     || LTRIM (TO_CHAR (i.endt_seq_no, '9999999'));
               END IF;
               FOR pol IN (SELECT policy_id FROM GIPI_POLBASIC a
                            WHERE a.line_cd = i.line_cd
                              AND a.subline_cd = i.subline_cd
                              AND a.iss_cd = i.iss_cd
                              AND a.issue_yy = i.issue_yy
                              AND a.pol_seq_no = i.pol_seq_no
                              AND a.renew_no = i.renew_no
                              AND a.endt_seq_no = 0)
               LOOP
                   v_rec.orig_policy_id := pol.policy_id;
                EXIT;
               END LOOP;
            ELSE
               v_rec.pol_no := NULL;
               v_rec.orig_policy_id := NULL;
            END IF;

            PIPE ROW (v_rec);
         END LOOP; 
         
      END IF;

      RETURN;
   END get_existing_quotes_pol_list;

   FUNCTION get_agent_prod_list (
      p_line_cd     gipi_quote.line_cd%TYPE,
      p_intm_no     VARCHAR2,
      p_from_date   VARCHAR2,
      p_to_date     VARCHAR2
   )
      RETURN agent_prod_list_tab PIPELINED
   IS
      v_agent   agent_prod_list_type;
      v_header  BOOLEAN := TRUE;--Kenneth 05.13.2014
   BEGIN
      FOR i IN (SELECT   b.intrmdry_intm_no intm_no,
                         b.intrmdry_intm_no || '-'
                         || d.intm_name intermediary,
                         c.line_name,
                            a.line_cd
                         || '-'
                         || a.subline_cd
                         || '-'
                         || a.iss_cd
                         || '-'
                         || a.quotation_yy
                         || '-'
                         || TO_CHAR (a.quotation_no, '000009')
                         || '-'
                         || TO_CHAR (a.proposal_no, '009') quotation,
                         g.assd_name,
                            h.line_cd
                         || '-'
                         || h.subline_cd
                         || '-'
                         || h.iss_cd
                         || '-'
                         || TO_CHAR (h.issue_yy, '09')
                         || '-'
                         || TO_CHAR (h.pol_seq_no, '0000009')
                         || '-'
                         || TO_CHAR (h.renew_no, '09') POLICY,
                         h.incept_date, NVL (k.prem_amt, 0) prem_amt,
                         (NVL (k.prem_amt, 0) + NVL (k.tax_amt, 0)
                         ) total_premium,
                         NVL (a.remarks, f.remarks) remarks, a.line_cd
                    FROM gipi_quote a,
                         gipi_comm_invoice b,
                         giis_line c,
                         giis_intermediary d,
                         gipi_parlist f,
                         giis_assured g,
                         gipi_polbasic h,
                         gipi_invoice k
                   WHERE a.line_cd = c.line_cd
                     --gipiquot and giisline by line_cd
                     AND h.assd_no = g.assd_no
                     --polbasic and giisassured by assd_no
                     AND k.iss_cd = b.iss_cd
                     AND k.prem_seq_no = b.prem_seq_no
                     AND b.intrmdry_intm_no = d.intm_no
                     --comm_invoice and giis_intmdry by intm_no
                     AND b.policy_id = h.policy_id
                     --comminvoice and polbasic by policy_id
                     AND k.policy_id = h.policy_id
                     --gipi_invoice and polbasic by policy_id
                     AND h.pol_flag IN ('1', '2', '3')
                     AND f.par_id = h.par_id  --parlist and polbasic by par_id
                     AND a.quote_id = f.quote_id
                     --parlist and gipiquote by quote_id
                     AND a.line_cd = NVL (p_line_cd, a.line_cd)
                     AND b.intrmdry_intm_no =
                               NVL (TO_NUMBER (p_intm_no), b.intrmdry_intm_no)
                     AND a.incept_date >=
                                    NVL (TO_DATE (p_from_date), a.incept_date)
                     AND a.incept_date <=
                                      NVL (TO_DATE (p_to_date), a.incept_date)
                ORDER BY c.line_name,
                         a.line_cd,
                         a.subline_cd,
                         a.iss_cd,
                         a.quotation_yy,
                         a.quotation_no,
                         a.proposal_no)
      LOOP
         v_header := FALSE;--Kenneth 05.13.2014
         v_agent.intm_no := i.intm_no;
         v_agent.intermediary := i.intermediary;
         v_agent.line_name := i.line_name;
         v_agent.quotation_no := i.quotation;
         v_agent.assd_name := i.assd_name;
         v_agent.policy_no := i.POLICY;
         v_agent.incept_date := i.incept_date;
         v_agent.prem_amt := i.prem_amt;
         v_agent.total_prem := i.total_premium;
         v_agent.remarks := i.remarks;
         v_agent.line_cd := i.line_cd;
         v_agent.print_header := 'Y';--Kenneth 05.13.2014
         PIPE ROW (v_agent);
      END LOOP;
      
      IF v_header--Kenneth 05.13.2014
      THEN
        v_agent.print_header := 'N';
        PIPE ROW (v_agent);
      END IF;

      RETURN;
   END;

   FUNCTION get_converted_quote (
      p_from_date   VARCHAR2,
      p_to_date     VARCHAR2,
      p_intm_no     VARCHAR2,
      p_line_cd     gipi_quote.line_cd%TYPE
   )
      RETURN converted_quote_tab PIPELINED
   IS
      v_conv_quote   converted_quote_type;
      v_header  BOOLEAN := TRUE;--Kenneth 05.13.2014
   BEGIN
      FOR i IN (SELECT   a.line_cd,
                         b.intrmdry_intm_no || '-'
                         || d.intm_name intermediary,
                         c.line_name,
                            a.line_cd
                         || '-'
                         || a.subline_cd
                         || '-'
                         || a.iss_cd
                         || '-'
                         || a.quotation_yy
                         || '-'
                         || LPAD (a.quotation_no, 7, '0')
                         || '-'
                         || LPAD (a.proposal_no, 2, '0') quotation,
                         g.assd_name,
                            h.line_cd
                         || '-'
                         || h.subline_cd
                         || '-'
                         || h.iss_cd
                         || '-'
                         || h.issue_yy
                         || '-'
                         || LPAD (h.pol_seq_no, 7, '0')
                         || '-'
                         || LPAD (h.renew_no, 2, '0') POLICY,
                         h.incept_date, NVL (k.prem_amt, 0) prem_amt,
                         (NVL (k.prem_amt, 0) + NVL (k.tax_amt, 0)
                         ) total_premium,
                         NVL (a.remarks, f.remarks) remarks
                    FROM gipi_quote a,
                         gipi_comm_invoice b,
                         giis_line c,
                         giis_intermediary d,
                         gipi_parlist f,
                         giis_assured g,
                         gipi_polbasic h,
                         gipi_invoice k
                   WHERE a.line_cd = c.line_cd
                     --gipiquot and giisline by line_cd
                     AND h.assd_no = g.assd_no
                     --polbasic and giisassured by assd_no
                     AND k.iss_cd = b.iss_cd
                     AND k.prem_seq_no = b.prem_seq_no
                     AND b.intrmdry_intm_no = d.intm_no
                     --comm_invoice and giis_intmdry by intm_no
                     AND b.policy_id = h.policy_id
                     --comminvoice and polbasic by policy_id
                     AND k.policy_id = h.policy_id
                     --gipi_invoice and polbasic by policy_id
                     AND h.pol_flag IN ('1', '2', '3')
                     AND f.par_id = h.par_id  --parlist and polbasic by par_id
                     AND a.quote_id = f.quote_id
                     --parlist and gipiquote by quote_id
                     AND a.line_cd = NVL (UPPER (p_line_cd), a.line_cd)
                     AND b.intrmdry_intm_no =
                               NVL (TO_NUMBER (p_intm_no), b.intrmdry_intm_no)
                     AND a.incept_date >=
                                    NVL (TO_DATE (p_from_date), a.incept_date)
                     AND a.incept_date <=
                                      NVL (TO_DATE (p_to_date), a.incept_date)
                ORDER BY c.line_name,
                         a.line_cd,
                         a.subline_cd,
                         a.iss_cd,
                         a.quotation_yy,
                         a.quotation_no,
                         a.proposal_no)
      LOOP
         v_header := FALSE;--Kenneth 05.13.2014
         v_conv_quote.line_cd := i.line_cd;
         v_conv_quote.line_name := i.line_name;
         v_conv_quote.quotation := i.quotation;
         v_conv_quote.assd_name := i.assd_name;
         v_conv_quote.POLICY := i.POLICY;
         v_conv_quote.incept_date := i.incept_date;
         v_conv_quote.intermediary := i.intermediary;
         v_conv_quote.remarks := i.remarks;
         v_conv_quote.prem_amt := i.prem_amt;
         v_conv_quote.total_prem := i.total_premium;
         v_conv_quote.print_header := 'Y';--Kenneth 05.13.2014
         PIPE ROW (v_conv_quote);
      END LOOP;
    
      IF v_header--Kenneth 05.13.2014
      THEN
        v_conv_quote.print_header := 'N';
        PIPE ROW (v_conv_quote);
      END IF;
      
      RETURN;
   END get_converted_quote;

   FUNCTION get_agent_broker_prod_rep (
      p_line_cd     gipi_quote.line_cd%TYPE,
      p_intm_no     gipi_comm_invoice.intrmdry_intm_no%TYPE,
      p_from_date   gipi_quote.incept_date%TYPE,
      p_to_date     gipi_quote.incept_date%TYPE
   )
      RETURN agent_broker_prod_rep_tab PIPELINED
   IS
      v_agent_broker   agent_broker_prod_rep_type;
      v_header  BOOLEAN := TRUE;--Kenneth 05.13.2014
   BEGIN
      FOR i IN (SELECT d.intm_no || '-' || e.intm_name intermediary,
                       b.line_name,
                          a.line_cd
                       || '-'
                       || a.subline_cd
                       || '-'
                       || a.iss_cd
                       || '-'
                       || a.quotation_yy
                       || '-'
                       || LTRIM (TO_CHAR (a.quotation_no, '000009'))
                       || '-'
                       || LTRIM (TO_CHAR (a.proposal_no, '009')) quotation,
                       a.assd_name assured, a.incept_date effectivity,
                       NVL (d.prem_amt, 0) net_premium,
                       NVL (d.prem_amt, 0) + NVL (d.tax_amt, 0)
                                                               total_premium,
                       c.reason_desc
                  FROM gipi_quote a,
                       giis_line b,
                       giis_lost_bid c,
                       gipi_quote_invoice d,
                       giis_intermediary e
                 WHERE a.line_cd = b.line_cd
                   AND a.line_cd = c.line_cd
                   AND NVL (a.reason_cd, c.reason_cd) = c.reason_cd
                   AND d.intm_no = e.intm_no(+)
                   AND a.status = 'D'
                   AND a.quote_id = d.quote_id(+)
                   AND a.line_cd = NVL (p_line_cd, a.line_cd)
                   --AND d.intm_no = NVL (TO_NUMBER (p_intm_no), d.intm_no) // replaced by: Nica 03.21.2014 - to handle records without intermediary
                   AND NVL(d.intm_no, 0) = NVL (TO_NUMBER (p_intm_no), NVL(d.intm_no, 0))
                   AND a.incept_date >=
                                    NVL (TO_CHAR (p_from_date), a.incept_date)
                   AND a.incept_date <=
                                      NVL (TO_CHAR (p_to_date), a.incept_date))
      LOOP
         v_header := FALSE;--Kenneth 05.13.2014
         v_agent_broker.intermediary := i.intermediary;
         v_agent_broker.line_name := i.line_name;
         v_agent_broker.quotation_no := i.quotation;
         v_agent_broker.assd_name := i.assured;
         v_agent_broker.incept_date := i.effectivity;
         v_agent_broker.prem_amt := i.net_premium;
         v_agent_broker.total_prem := i.total_premium;
         v_agent_broker.reason_desc := i.reason_desc;
         v_agent_broker.print_header := 'Y';--Kenneth 05.13.2014
         PIPE ROW (v_agent_broker);
      END LOOP;

      IF v_header--Kenneth 05.13.2014
      THEN
        v_agent_broker.print_header := 'N';
        PIPE ROW (v_agent_broker);
      END IF;
      
      RETURN;
   END get_agent_broker_prod_rep;

   --Modified by Apollo Cruz 12.08.2014 - added p_assd_no
   FUNCTION check_assd_name (p_assd_name giis_assured.assd_name%TYPE, p_assd_no VARCHAR2)
      RETURN check_assd_name_tab PIPELINED
   IS
      v_assd     check_assd_name_type;
      v_count     NUMBER := 0;
   BEGIN
      FOR v IN (SELECT assd_no
                  FROM giis_assured
                 WHERE assd_name = p_assd_name
                   AND assd_no = NVL(p_assd_no, assd_no)
                   AND NVL(active_tag, 'N') = 'Y') -- added checking of active tag - Apollo Cruz 12.08.2014
      LOOP
         v_assd.assd_no := v.assd_no;
         v_assd.v_exist1 := 'Y';
         v_count := v_count + 1;  
      END LOOP;

      FOR x in (SELECT assd_name
                   from gipi_quote
                   where assd_name = p_assd_name
                     AND NVL(assd_no, 0) = NVL(p_assd_no, NVL(assd_no, 0)) -- Apollo Cruz 12.08.2014
                   )
       LOOP
             v_assd.v_exist2 := 'Y';
    end loop;

      FOR rec IN (SELECT mail_addr1, mail_addr2, mail_addr3
                    FROM giis_assured
                   WHERE assd_no = v_assd.assd_no)
      --Description: To get client address from giis_assured.
      LOOP
         v_assd.address1 := rec.mail_addr1;
         v_assd.address2 := rec.mail_addr2;
         v_assd.address3 := rec.mail_addr3;
      END LOOP;
      
      v_assd.v_count := v_count; --if v_count retunrs more than 1, assd_lov will be shown
      
      PIPE ROW (v_assd);
      RETURN;
   END check_assd_name;

   FUNCTION get_pack_quotations (
      p_pack_quote_id   gipi_quote.pack_quote_id%TYPE,
      p_user_id         gipi_quote.user_id%TYPE
   )
      RETURN gipi_pack_quotations_tab PIPELINED
   IS
      v_pack_quotations   gipi_pack_quotations_type;
   BEGIN
      FOR a IN
         (SELECT line_cd, giis_line_pkg.get_line_name (line_cd) line_name,
                 subline_cd,
                 giis_subline_pkg.get_subline_name2 (line_cd,
                                                     subline_cd
                                                    ) subline_name,
                 quote_id, iss_cd, quotation_yy, quotation_no, proposal_no,
                 remarks
            FROM gipi_quote
           WHERE pack_quote_id = p_pack_quote_id
             AND user_id = p_user_id
             AND status = 'N')
      LOOP
         v_pack_quotations.line_cd := a.line_cd;
         v_pack_quotations.line_name := a.line_name;
         v_pack_quotations.subline_cd := a.subline_cd;
         v_pack_quotations.subline_name := a.subline_name;
         v_pack_quotations.quote_id := a.quote_id;
         v_pack_quotations.iss_cd := a.iss_cd;
         v_pack_quotations.quotation_yy := a.quotation_yy;
         v_pack_quotations.quotation_no := a.quotation_no;
         v_pack_quotations.proposal_no := a.proposal_no;
         v_pack_quotations.remarks := a.remarks;
         PIPE ROW (v_pack_quotations);
      END LOOP;

      RETURN;
   END;

/*
**  Created by    : Veronica V. Raymundo
**  Date Created  : May 18, 2011
**  Reference By  : GIIMM002 - Quotation Information (Package)
**  Description   : Function returns details of a quote/list of quotes under
**                    a package quotation
*/
   FUNCTION get_gipi_pack_quote_list (
      p_pack_quote_id   gipi_quote.pack_quote_id%TYPE
   )
      RETURN gipi_quote_tab PIPELINED
   IS
      v_gipi_quote   gipi_quote_type;
   BEGIN
      FOR i IN
         (SELECT   a.quote_id,
                      a.line_cd
                   || '-'
                   || subline_cd
                   || '-'
                   || iss_cd
                   || '-'
                   || TO_CHAR (quotation_yy, '0009')
                   || '-'
                   || TO_CHAR (quotation_no, '000009')
                   || '-'
                   || TO_CHAR (proposal_no, '09') quote_no,
                   assd_name, incept_date, expiry_date, incept_tag,
                   expiry_tag,
                   TRUNC (expiry_date) - TRUNC (incept_date) no_of_days,
                   accept_dt, a.user_id userid, a.line_cd, menu_line_cd,
                   giis_line_pkg.get_line_name (a.line_cd) line_name,
                   subline_cd,
                   giis_subline_pkg.get_subline_name2
                                                     (a.line_cd,
                                                      subline_cd
                                                     ) subline_name,
                   iss_cd, giis_issource_pkg.get_iss_name (iss_cd) iss_name,
                   quotation_yy, quotation_no, proposal_no, cred_branch,
                   giis_issource_pkg.get_iss_name
                                                (cred_branch)
                                                            cred_branch_name,
                   valid_date,
                   giis_assured_pkg.get_assd_name (acct_of_cd) acct_of,
                   address1, address2, address3, prorate_flag, header,
                   footer, a.remarks, reason_cd,
                   giis_loss_bid_pkg.get_reason_desc (reason_cd) reason_desc,
                   comp_sw, short_rt_percent, acct_of_cd, assd_no, prem_amt,
                   ann_prem_amt, tsi_amt
              FROM gipi_quote a, giis_line b
             WHERE a.pack_quote_id = p_pack_quote_id
                   AND a.line_cd = b.line_cd
          ORDER BY quote_no)
      LOOP
         v_gipi_quote.quote_id := i.quote_id;
         v_gipi_quote.quote_no := i.quote_no;
         v_gipi_quote.assd_name := i.assd_name;
         v_gipi_quote.incept_date := i.incept_date;
         v_gipi_quote.expiry_date := i.expiry_date;
         v_gipi_quote.incept_tag := i.incept_tag;
         v_gipi_quote.expiry_tag := i.expiry_tag;
         v_gipi_quote.no_of_days := i.no_of_days;
         v_gipi_quote.accept_dt := i.accept_dt;
         v_gipi_quote.userid := i.userid;
         v_gipi_quote.line_cd := i.line_cd;
         v_gipi_quote.menu_line_cd := i.menu_line_cd;
         v_gipi_quote.line_name := i.line_name;
         v_gipi_quote.subline_cd := i.subline_cd;
         v_gipi_quote.subline_name := i.subline_name;
         v_gipi_quote.iss_cd := i.iss_cd;
         v_gipi_quote.iss_name := i.iss_name;
         v_gipi_quote.quotation_yy := i.quotation_yy;
         v_gipi_quote.quotation_no := i.quotation_no;
         v_gipi_quote.proposal_no := i.proposal_no;
         v_gipi_quote.cred_branch := i.cred_branch;
         v_gipi_quote.cred_branch_name := i.cred_branch_name;
         v_gipi_quote.valid_date := i.valid_date;
         v_gipi_quote.acct_of := i.acct_of;
         v_gipi_quote.address1 := i.address1;
         v_gipi_quote.address2 := i.address2;
         v_gipi_quote.address3 := i.address3;
         v_gipi_quote.prorate_flag := i.prorate_flag;
         v_gipi_quote.header := i.header;
         v_gipi_quote.footer := i.footer;
         v_gipi_quote.remarks := i.remarks;
         v_gipi_quote.reason_cd := i.reason_cd;
         v_gipi_quote.reason_desc := i.reason_desc;
         v_gipi_quote.comp_sw := i.comp_sw;
         v_gipi_quote.short_rt_percent := i.short_rt_percent;
         v_gipi_quote.acct_of_cd := i.acct_of_cd;
         v_gipi_quote.assd_no := i.assd_no;
         v_gipi_quote.prem_amt := i.prem_amt;
         v_gipi_quote.ann_prem_amt := i.ann_prem_amt;
         v_gipi_quote.tsi_amt := i.tsi_amt;
         PIPE ROW (v_gipi_quote);
      END LOOP;

      RETURN;
   END get_gipi_pack_quote_list;

   PROCEDURE generate_quote_bank_ref_no (
      p_quote_id               gipi_quote.quote_id%TYPE,
      p_acct_iss_cd   IN       giis_ref_seq.acct_iss_cd%TYPE,
      p_branch_cd     IN       giis_ref_seq.branch_cd%TYPE,
      p_bank_ref_no   OUT      gipi_wpolbas.bank_ref_no%TYPE,
      p_msg_alert     OUT      VARCHAR2
   )
   IS
      v_ref_no       giis_ref_seq.ref_no%TYPE;
      v_dsp_mod_no   gipi_ref_no_hist.mod_no%TYPE;
   BEGIN
      generate_ref_no (p_acct_iss_cd, p_branch_cd, v_ref_no, 'GIIMM001');

      SELECT mod_no
        INTO v_dsp_mod_no
        FROM gipi_ref_no_hist
       WHERE acct_iss_cd = p_acct_iss_cd
         AND branch_cd = p_branch_cd
         AND ref_no = v_ref_no;

      --this switch disables the initialization of 0 values for the reference number.
      --variables.v_bank_ref_no_sw := TRUE;
      p_bank_ref_no :=
            LPAD (p_acct_iss_cd, 2, 0)
         || '-'
         || LPAD (p_branch_cd, 4, 0)
         || '-'
         || LPAD (v_ref_no, 7, 0)
         || '-'
         || LPAD (v_ref_no, 2, 0);

      UPDATE gipi_quote
         SET bank_ref_no = p_bank_ref_no
       WHERE quote_id = p_quote_id;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         p_msg_alert :=
            'Please double check your data in generating a bank reference number.';
         ROLLBACK;
         RETURN;
   END;

      /*
   **  Created by    : Rey M. Jadlocon
   **  Date Created  : July 12,2011
   **  Reference By  : GIIMM004 -Quotation Status Listing
   **  Description   : Function return list of Quotation Status
   */
   FUNCTION get_quote_list_status2 (
      p_line_cd        gipi_quote.line_cd%TYPE,
      p_user           giis_users.user_id%TYPE,
      p_module         giis_modules.module_id%TYPE,
      p_date_from      VARCHAR2,
      p_date_to        VARCHAR2,
      p_status         gipi_quote.status%TYPE,
      p_proposal_no    gipi_quote.proposal_no%TYPE,
      p_quotation_yy   gipi_quote.quotation_yy%TYPE,
      p_quotation_no   gipi_quote.quotation_no%TYPE,
      p_iss_cd         gipi_quote.iss_cd%TYPE,
      p_assd_name      gipi_quote.assd_name%TYPE,
      p_quote_id       gipi_quote.quote_id%TYPE,
      p_create_user    gipi_quote.user_id%TYPE,
      p_subline_cd     gipi_quote.subline_cd%TYPE,
      p_incept_date    VARCHAR2,
      p_expiry_date    VARCHAR2,
      p_par_assd       giis_assured.assd_name%TYPE,
      p_quote_no       VARCHAR2
   )
      RETURN quote_list_status_tab PIPELINED
   IS
      v_quote   quote_list_status_type;
   BEGIN
      FOR i IN
         (SELECT   a.quote_id, a.pack_pol_flag, a.pack_quote_id,
                      a.line_cd
                   || '-'
                   || a.subline_cd
                   || '-'
                   || a.iss_cd
                   || '-'
                   || a.quotation_yy
                   || '-'
                   || TO_CHAR (TRIM (a.quotation_no), '000009')
                   || '-'
                   || TO_CHAR (TRIM (a.proposal_no), '009') quote_no,
                   a.assd_name, a.incept_date, a.expiry_date, a.valid_date,
                   a.user_id, a.assd_no, a.accept_dt,
                   cg_ref_codes_pkg.get_rv_meaning
                                                 ('GIPI_QUOTE.STATUS',
                                                  a.status
                                                 ) status,
                   giis_assured_pkg.get_assd_name (b.assd_no) par_assd,
                   c.reason_desc,
                   (SELECT    y.line_cd
                           || '-'
                           || y.iss_cd
                           || '-'
                           || TO_CHAR (y.par_yy, '09')
                           || '-'
                           || TO_CHAR (y.par_seq_no, '000009')
                           || '-'
                           || TO_CHAR (y.quote_seq_no, '09')
                      FROM gipi_parlist y
                     WHERE y.par_id = b.par_id) par_no,

--                b.line_cd
--             || '-'
--             || b.iss_cd
--             || '-'
--             || TO_CHAR (b.par_yy, '09')
--             || '-'
--             || TO_CHAR (par_seq_no, '000009')
--             || '-'
--             || TO_CHAR (b.quote_seq_no, '09') par_no,
                   (SELECT    z.line_cd
                           || '-'
                           || z.subline_cd
                           || '-'
                           || z.iss_cd
                           || '-'
                           || TO_CHAR (z.issue_yy, '09')
                           || '-'
                           || TO_CHAR (z.pol_seq_no, '000009')
                           || '-'
                           || TO_CHAR (z.renew_no, '09')
                      FROM gipi_polbasic z
                     WHERE z.par_id = b.par_id) pol_no,
                   (SELECT    w.line_cd
                           || '-'
                           || w.subline_cd
                           || '-'
                           || w.iss_cd
                           || '-'
                           || w.quotation_yy
                           || '-'
                           || TO_CHAR (TRIM (w.quotation_no), '000009')
                           || '-'
                           || TO_CHAR (TRIM (w.proposal_no), '009')
                      FROM gipi_pack_quote w
                     WHERE w.pack_quote_id = a.pack_quote_id
                       AND a.pack_pol_flag = 'Y') pack_quote_no
              FROM gipi_quote a, gipi_parlist b, giis_lost_bid c
             WHERE a.quote_id = b.quote_id(+)
               AND b.par_status(+) NOT IN (98, 99)
               AND a.line_cd = c.line_cd(+)
               AND a.reason_cd = c.reason_cd(+)
               AND a.line_cd = NVL (p_line_cd, a.line_cd)
               AND a.subline_cd LIKE NVL (p_subline_cd, a.subline_cd)
               AND a.user_id =
                      (SELECT DECODE (b.all_user_sw,
                                      'Y', a.user_id,
                                      'N', p_user,
                                      p_user
                                     )
                         FROM giis_users b
                        WHERE b.user_id = p_user)
               AND check_user_per_line2 (a.line_cd, a.iss_cd, p_module,
                                         p_user) = 1
               AND check_user_per_iss_cd2 (a.line_cd,
                                           a.iss_cd,
                                           p_module,
                                           p_user
                                          ) = 1
               AND a.status =
                      (DECODE (UPPER (p_status),
                               'NOT SELECTED', 'X',
                               'DENIED', 'D',
                               'WITH PAR', 'W',
                               'NEW', 'N',
                               'POSTED POLICY', 'P',
                               a.status
                              )
                      )
               AND a.line_cd = UPPER (NVL (p_line_cd, a.line_cd))
               AND a.subline_cd LIKE UPPER (NVL (p_subline_cd, a.subline_cd))
               AND a.iss_cd LIKE UPPER (NVL (p_iss_cd, a.iss_cd))
               AND a.quotation_yy = NVL (p_quotation_yy, a.quotation_yy)
               AND NVL (a.assd_name, '%%') LIKE
                                               UPPER (NVL (p_assd_name, '%%'))
               AND a.quotation_no = NVL (p_quotation_no, a.quotation_no)
               AND a.proposal_no = NVL (p_proposal_no, a.proposal_no)
               AND NVL (giis_assured_pkg.get_assd_name (b.assd_no), '%%') LIKE
                                                UPPER (NVL (p_par_assd, '%%'))
               AND TRUNC (a.incept_date) =
                      TRUNC (NVL (TO_DATE (p_incept_date, 'MM-DD-RRRR'),
                                  a.incept_date
                                 )
                            )
               AND TRUNC (a.expiry_date) =
                      TRUNC (NVL (TO_DATE (p_expiry_date, 'MM-DD-RRRR'),
                                  a.expiry_date
                                 )
                            )
               AND TRUNC (a.accept_dt)
                      BETWEEN TRUNC (NVL (TO_DATE (p_date_from, 'MM-DD-RRRR'),
                                          a.accept_dt
                                         )
                                    )
                          AND TRUNC (NVL (TO_DATE (p_date_to, 'MM-DD-RRRR'),
                                          a.accept_dt
                                         )
                                    )                               --361 rows
               AND NVL (   a.line_cd
                        || '-'
                        || a.subline_cd
                        || '-'
                        || a.iss_cd
                        || '-'
                        || a.quotation_yy
                        || '-'
                        || TO_CHAR (TRIM (a.quotation_no), '000009')
                        || '-'
                        || TO_CHAR (TRIM (a.proposal_no), '009'),
                        '%%'
                       ) LIKE NVL (p_quote_no, '%%')
          ORDER BY    a.line_cd
                   || '-'
                   || a.subline_cd
                   || '-'
                   || a.iss_cd
                   || '-'
                   || a.quotation_yy
                   || '-'
                   || TO_CHAR (a.quotation_no, '000009')
                   || '-'
                   || TO_CHAR (a.proposal_no, '009'),
                   a.accept_dt DESC)
      LOOP
         v_quote.quote_id := i.quote_id;
         v_quote.quote_no := i.quote_no;
         v_quote.assd_name := i.assd_name;
         v_quote.incept_date := i.incept_date;
         v_quote.expiry_date := i.expiry_date;
         v_quote.valid_date := i.valid_date;
         v_quote.user_id := i.user_id;
         v_quote.assd_no := i.assd_no;
         v_quote.accept_dt := i.accept_dt;
         v_quote.status := i.status;
         v_quote.par_assd := i.par_assd;
         v_quote.reason_desc := i.reason_desc;
         v_quote.par_no := i.par_no;
         v_quote.pol_no := i.pol_no;
         v_quote.pack_pol_flag := i.pack_pol_flag;
         v_quote.pack_quote_id := i.pack_quote_id;
         v_quote.pack_quote_no := i.pack_quote_no;
         PIPE ROW (v_quote);
      END LOOP;

      RETURN;
   END get_quote_list_status2;

   PROCEDURE reassign_package_quotation (
      p_user_id         gipi_quote.user_id%TYPE,
      p_quote_id        gipi_quote.quote_id%TYPE,
      p_remarks         gipi_quote.remarks%TYPE,
      p_pack_quote_id   gipi_quote.pack_quote_id%TYPE
   )
   IS
   BEGIN
      UPDATE gipi_quote
         SET user_id = p_user_id
       WHERE pack_quote_id = p_pack_quote_id;

      UPDATE gipi_pack_quote
         SET user_id = p_user_id
       WHERE pack_quote_id = p_pack_quote_id;

      UPDATE gipi_quote
         SET remarks = p_remarks
       WHERE quote_id = p_quote_id;
   END;

      /*
    **  Created by   : Veronica V. Raymundo
    **  Date Created : April 18, 2012
    **  Reference By : GIIMM001 - Quotation Listing
    **  Description  : This procedure will copy the quotation with the given
    **                 quote_id and return the quote_id of the newly created quotation.
    */

    PROCEDURE copy_quotation_2 (
          p_quote_id        IN   GIPI_QUOTE.quote_id%TYPE,
          p_user_id         IN   GIIS_USERS.user_id%TYPE,
          p_new_quote_id    OUT  GIPI_QUOTE.quote_id%TYPE
       )
       IS
          v_new_quote_id   GIPI_QUOTE.quote_id%TYPE;
          v_quotation_no   GIPI_QUOTE.quotation_no%TYPE;
          v_quote_inv_no   GIPI_QUOTE_INVOICE.quote_inv_no%TYPE;
          v_menu_line_cd   GIIS_LINE.menu_line_cd%TYPE;
          v_fire_cd        GIIS_LINE.line_cd%TYPE;
          v_motor_cd       GIIS_LINE.line_cd%TYPE;
          v_accident_cd    GIIS_LINE.line_cd%TYPE;
          v_hull_cd        GIIS_LINE.line_cd%TYPE;
          v_cargo_cd       GIIS_LINE.line_cd%TYPE;
          v_casualty_cd    GIIS_LINE.line_cd%TYPE;
          v_engrng_cd      GIIS_LINE.line_cd%TYPE;
          v_surety_cd      GIIS_LINE.line_cd%TYPE;
          v_aviation_cd    GIIS_LINE.line_cd%TYPE;

       BEGIN
          GIIS_LINE_PKG.get_param_line_cd (v_fire_cd,
                                           v_motor_cd,
                                           v_accident_cd,
                                           v_hull_cd,
                                           v_cargo_cd,
                                           v_casualty_cd,
                                           v_engrng_cd,
                                           v_surety_cd,
                                           v_aviation_cd
                                          );

          --generate new quote_id
          FOR a IN (SELECT quote_quote_id_s.NEXTVAL new_quote
                      FROM DUAL)
          LOOP
             v_new_quote_id := a.new_quote;
             p_new_quote_id := a.new_quote;
          END LOOP;

       /* -- removed, the original qoute should not have the newly generated quotation id
          UPDATE gipi_quote
             SET copied_quote_id = v_new_quote_id
           WHERE quote_id = p_quote_id;*/

          FOR b IN (SELECT line_cd, subline_cd, iss_cd, quotation_yy, proposal_no,
                           assd_no, assd_name, tsi_amt, prem_amt, remarks, header,
                           footer, status, print_tag, incept_date, expiry_date,
                           accept_dt, address1, address2, address3, cred_branch,
                           acct_of_cd, acct_of_cd_sw, incept_tag, expiry_tag,
                           prorate_flag, comp_sw, with_tariff_sw, ann_tsi_amt, ann_prem_amt,
                           short_rt_percent -- bonok :: 09.30.2013 :: SR 388 - GENQA
                      FROM GIPI_QUOTE
                     WHERE quote_id = p_quote_id)
          LOOP
             GIPI_QUOTE_PKG.compute_quote_no (b.line_cd,
                                              b.subline_cd,
                                              b.iss_cd,
                                              b.quotation_yy,
                                              v_quotation_no
                                             );

             INSERT INTO GIPI_QUOTE
                         (quotation_no, quote_id, line_cd,
                          subline_cd, iss_cd, quotation_yy, proposal_no,
                          assd_no, assd_name, tsi_amt, prem_amt,
                          remarks, header, footer, status, print_tag,
                          incept_date, expiry_date, last_update,
                          user_id, accept_dt, valid_date,
                          address1, address2, address3, cred_branch,
                          acct_of_cd, acct_of_cd_sw, incept_tag,
                          expiry_tag, prorate_flag, comp_sw,
                          with_tariff_sw, underwriter, copied_quote_id, ann_tsi_amt, ann_prem_amt,
                          short_rt_percent -- bonok :: 09.30.2013 :: SR 388 - GENQA
                         )
                  VALUES (v_quotation_no, v_new_quote_id, b.line_cd,
                          b.subline_cd, b.iss_cd, TO_CHAR (SYSDATE, 'YYYY'), 0,
                          b.assd_no, b.assd_name, b.tsi_amt, b.prem_amt,
                          b.remarks, b.header, b.footer, 'N', b.print_tag,
                          b.incept_date, b.expiry_date, SYSDATE,
                          NVL (p_user_id, USER), b.accept_dt, SYSDATE + 30,
                          b.address1, b.address2, b.address3, b.cred_branch,
                          b.acct_of_cd, b.acct_of_cd_sw, b.incept_tag,
                          b.expiry_tag, b.prorate_flag, b.comp_sw,
                          b.with_tariff_sw, NVL (p_user_id, USER), p_quote_id, b.ann_tsi_amt, b.ann_prem_amt,
                          b.short_rt_percent -- bonok :: 09.30.2013 :: SR 388 - GENQA
                         );

             --insert  copied values to gipi_item,gipi_quote_itmperil,
             FOR v IN (SELECT item_no, item_title, item_desc, currency_cd,
                              currency_rate, pack_line_cd, pack_subline_cd,
                              tsi_amt, prem_amt, ann_tsi_amt, ann_prem_amt
                         FROM GIPI_QUOTE_ITEM
                        WHERE quote_id = p_quote_id)
             LOOP
                INSERT INTO GIPI_QUOTE_ITEM
                            (quote_id, item_no, item_title,
                             item_desc, currency_cd, currency_rate,
                             pack_line_cd, pack_subline_cd, tsi_amt,
                             prem_amt,ann_tsi_amt, ann_prem_amt
                            )
                     VALUES (v_new_quote_id, v.item_no, v.item_title,
                             v.item_desc, v.currency_cd, v.currency_rate,
                             v.pack_line_cd, v.pack_subline_cd, v.tsi_amt,
                             v.prem_amt , v.ann_tsi_amt, v.ann_prem_amt
                            );

                FOR m IN (SELECT item_no, peril_cd, tsi_amt, prem_amt, prem_rt,
                                 comp_rem,ann_prem_amt, ann_tsi_amt, line_cd , peril_type
                            FROM GIPI_QUOTE_ITMPERIL
                           WHERE quote_id = p_quote_id AND item_no = v.item_no)
                LOOP
                   INSERT INTO GIPI_QUOTE_ITMPERIL
                               (quote_id, item_no, peril_cd,
                                tsi_amt, prem_amt, prem_rt, comp_rem,ann_prem_amt, ann_tsi_amt, line_cd , peril_type
                               )
                        VALUES (v_new_quote_id, m.item_no, m.peril_cd,
                                m.tsi_amt, m.prem_amt, m.prem_rt, m.comp_rem, m.ann_prem_amt, m.ann_tsi_amt, m.line_cd , m.peril_type
                               );
                END LOOP;
             END LOOP;

             FOR a IN (SELECT iss_cd, intm_no, currency_cd, currency_rt, prem_amt,
                              tax_amt, quote_inv_no
                         FROM GIPI_QUOTE_INVOICE
                        WHERE quote_id = p_quote_id)
             LOOP
                FOR j IN (SELECT quote_inv_no
                            FROM GIIS_QUOTE_INV_SEQ
                           WHERE iss_cd = b.iss_cd)
                LOOP
                   v_quote_inv_no := j.quote_inv_no + 1;
                   EXIT;
                END LOOP;

                INSERT INTO GIPI_QUOTE_INVOICE
                            (quote_id, iss_cd, quote_inv_no, intm_no,
                             currency_cd, currency_rt, prem_amt, tax_amt
                            )
                     VALUES (v_new_quote_id, a.iss_cd, v_quote_inv_no, a.intm_no,
                             a.currency_cd, a.currency_rt, a.prem_amt, a.tax_amt
                            );

                FOR e IN (SELECT line_cd, tax_cd, tax_id, tax_amt, rate
                            FROM GIPI_QUOTE_INVTAX
                           WHERE quote_inv_no = a.quote_inv_no --v_quote_inv_no replaced by: Nica 05.31.2012
                             AND iss_cd = a.iss_cd)
                LOOP
                   INSERT INTO GIPI_QUOTE_INVTAX
                               (line_cd, iss_cd, quote_inv_no, tax_cd,
                                tax_id, tax_amt, rate
                               )
                        VALUES (b.line_cd, a.iss_cd, v_quote_inv_no, e.tax_cd,
                                e.tax_id, e.tax_amt, e.rate
                               );
                END LOOP;
             END LOOP;

             -- to get the value of the menu_line_cd for the given line
             FOR a IN (SELECT menu_line_cd
                         FROM GIIS_LINE
                        WHERE line_cd = b.line_cd)
             LOOP
                v_menu_line_cd := a.menu_line_cd;
                EXIT;
             END LOOP;

             IF v_menu_line_cd = 'AC' OR b.line_cd = v_accident_cd
             THEN
                FOR ac IN (SELECT item_no, no_of_persons, position_cd,
                                  monthly_salary, salary_grade, destination,
                                  ac_class_cd, age, civil_status, date_of_birth,
                                  group_print_sw, height, level_cd,
                                  parent_level_cd, sex, weight
                             FROM GIPI_QUOTE_AC_ITEM
                            WHERE quote_id = p_quote_id)
                LOOP
                   INSERT INTO GIPI_QUOTE_AC_ITEM
                               (quote_id, item_no, no_of_persons,
                                position_cd, monthly_salary,
                                salary_grade, destination, ac_class_cd,
                                age, civil_status, date_of_birth,
                                group_print_sw, height, level_cd,
                                parent_level_cd, sex, weight, user_id,
                                last_update
                               )
                        VALUES (v_new_quote_id, ac.item_no, ac.no_of_persons,
                                ac.position_cd, ac.monthly_salary,
                                ac.salary_grade, ac.destination, ac.ac_class_cd,
                                ac.age, ac.civil_status, ac.date_of_birth,
                                ac.group_print_sw, ac.height, ac.level_cd,
                                ac.parent_level_cd, ac.sex, ac.weight, NVL (p_user_id, USER),
                                SYSDATE
                               );
                END LOOP;
             ELSIF v_menu_line_cd = 'MC' OR b.line_cd = v_motor_cd
             THEN
                FOR mc IN (SELECT item_no, plate_no, motor_no, serial_no,
                                  subline_type_cd, mot_type, car_company_cd,
                                  coc_yy, coc_seq_no, coc_serial_no, coc_type,
                                  repair_lim, color, model_year, make, est_value,
                                  towing, assignee, no_of_pass, tariff_zone,
                                  coc_issue_date, mv_file_no, acquired_from,
                                  ctv_tag, type_of_body_cd, unladen_wt, make_cd,
                                  series_cd, basic_color_cd, color_cd, origin,
                                  destination, coc_atcn, subline_cd
                             FROM GIPI_QUOTE_ITEM_MC
                            WHERE quote_id = p_quote_id)
                LOOP
                   INSERT INTO GIPI_QUOTE_ITEM_MC
                               (quote_id, item_no, plate_no,
                                motor_no, serial_no, subline_type_cd,
                                mot_type, car_company_cd, coc_yy,
                                coc_seq_no, coc_serial_no, coc_type,
                                repair_lim, color, model_year, make,
                                est_value, towing, assignee,
                                no_of_pass, tariff_zone,
                                coc_issue_date, mv_file_no,
                                acquired_from, ctv_tag,
                                type_of_body_cd, unladen_wt, make_cd,
                                series_cd, basic_color_cd, color_cd,
                                origin, destination, coc_atcn,
                                subline_cd, user_id, last_update
                               )
                        VALUES (v_new_quote_id, mc.item_no, mc.plate_no,
                                mc.motor_no, mc.serial_no, mc.subline_type_cd,
                                mc.mot_type, mc.car_company_cd, mc.coc_yy,
                                mc.coc_seq_no, mc.coc_serial_no, mc.coc_type,
                                mc.repair_lim, mc.color, mc.model_year, mc.make,
                                mc.est_value, mc.towing, mc.assignee,
                                mc.no_of_pass, mc.tariff_zone,
                                mc.coc_issue_date, mc.mv_file_no,
                                mc.acquired_from, mc.ctv_tag,
                                mc.type_of_body_cd, mc.unladen_wt, mc.make_cd,
                                mc.series_cd, mc.basic_color_cd, mc.color_cd,
                                mc.origin, mc.destination, mc.coc_atcn,
                                mc.subline_cd, NVL (p_user_id, USER), SYSDATE
                               );
                END LOOP;
             ELSIF v_menu_line_cd = 'FI' OR b.line_cd = v_fire_cd
             THEN
                FOR fi IN (SELECT item_no, district_no, eq_zone, tarf_cd,
                                  block_no, fr_item_type, loc_risk1, loc_risk2,
                                  loc_risk3, tariff_zone, typhoon_zone,
                                  construction_cd, construction_remarks, front,
                                  RIGHT, LEFT, rear, occupancy_cd,
                                  occupancy_remarks, flood_zone, assignee,
                                  block_id, risk_cd
                             FROM GIPI_QUOTE_FI_ITEM
                            WHERE quote_id = p_quote_id)
                LOOP
                   INSERT INTO GIPI_QUOTE_FI_ITEM
                               (quote_id, item_no, district_no,
                                eq_zone, tarf_cd, block_no,
                                fr_item_type, loc_risk1, loc_risk2,
                                loc_risk3, tariff_zone, typhoon_zone,
                                construction_cd, construction_remarks,
                                front, RIGHT, LEFT, rear,
                                occupancy_cd, occupancy_remarks,
                                flood_zone, assignee, block_id,
                                risk_cd, user_id, last_update
                               )
                        VALUES (v_new_quote_id, fi.item_no, fi.district_no,
                                fi.eq_zone, fi.tarf_cd, fi.block_no,
                                fi.fr_item_type, fi.loc_risk1, fi.loc_risk2,
                                fi.loc_risk3, fi.tariff_zone, fi.typhoon_zone,
                                fi.construction_cd, fi.construction_remarks,
                                fi.front, fi.RIGHT, fi.LEFT, fi.rear,
                                fi.occupancy_cd, fi.occupancy_remarks,
                                fi.flood_zone, fi.assignee, fi.block_id,
                                fi.risk_cd, NVL (p_user_id, USER), SYSDATE
                               );
                END LOOP;
             ELSIF v_menu_line_cd = 'EN' OR b.line_cd = v_engrng_cd
             THEN
                FOR en IN (SELECT engg_basic_infonum, contract_proj_buss_title,
                                  site_location, construct_start_date,
                                  construct_end_date, maintain_start_date,
                                  maintain_end_date, testing_start_date,
                                  testing_end_date, weeks_test, time_excess,
                                  mbi_policy_no
                             FROM GIPI_QUOTE_EN_ITEM
                            WHERE quote_id = p_quote_id)
                LOOP
                   INSERT INTO GIPI_QUOTE_EN_ITEM
                               (quote_id, engg_basic_infonum,
                                contract_proj_buss_title, site_location,
                                construct_start_date, construct_end_date,
                                maintain_start_date, maintain_end_date,
                                testing_start_date, testing_end_date,
                                weeks_test, time_excess, mbi_policy_no,
                                user_id, last_update
                               )
                        VALUES (v_new_quote_id, en.engg_basic_infonum,
                                en.contract_proj_buss_title, en.site_location,
                                en.construct_start_date, en.construct_end_date,
                                en.maintain_start_date, en.maintain_end_date,
                                en.testing_start_date, en.testing_end_date,
                                en.weeks_test, en.time_excess, en.mbi_policy_no,
                                NVL (p_user_id, USER), SYSDATE
                               );
                END LOOP;
             ELSIF v_menu_line_cd = 'CA' OR b.line_cd = v_casualty_cd
             THEN
                FOR ca IN (SELECT item_no, section_line_cd, section_subline_cd,
                                  section_or_hazard_cd, capacity_cd,
                                  property_no_type, property_no, LOCATION,
                                  conveyance_info, interest_on_premises,
                                  limit_of_liability, section_or_hazard_info
                             FROM GIPI_QUOTE_CA_ITEM
                            WHERE quote_id = p_quote_id)
                LOOP
                   INSERT INTO GIPI_QUOTE_CA_ITEM
                               (quote_id, item_no, section_line_cd,
                                section_subline_cd, section_or_hazard_cd,
                                capacity_cd, property_no_type,
                                property_no, LOCATION, conveyance_info,
                                interest_on_premises, limit_of_liability,
                                section_or_hazard_info, user_id, last_update
                               )
                        VALUES (v_new_quote_id, ca.item_no, ca.section_line_cd,
                                ca.section_subline_cd, ca.section_or_hazard_cd,
                                ca.capacity_cd, ca.property_no_type,
                                ca.property_no, ca.LOCATION, ca.conveyance_info,
                                ca.interest_on_premises, ca.limit_of_liability,
                                ca.section_or_hazard_info, NVL (p_user_id, USER), SYSDATE
                               );
                END LOOP;
             ELSIF v_menu_line_cd = 'MN' OR b.line_cd = v_cargo_cd
             THEN
                FOR ves IN (SELECT vessel_cd, rec_flag, vescon, voy_limit
                              FROM GIPI_QUOTE_VES_AIR
                             WHERE quote_id = p_quote_id)
                LOOP
                   INSERT INTO GIPI_QUOTE_VES_AIR
                               (quote_id, vessel_cd, rec_flag,
                                vescon, voy_limit
                               )
                        VALUES (v_new_quote_id, ves.vessel_cd, ves.rec_flag,
                                ves.vescon, ves.voy_limit
                               );
                END LOOP;

                FOR mn IN (SELECT item_no, vessel_cd, geog_cd, cargo_class_cd,
                                  voyage_no, bl_awb, origin, destn, etd, eta,
                                  cargo_type, pack_method, tranship_origin,
                                  tranship_destination, lc_no, print_tag,
                                  deduct_text, rec_flag
                             FROM GIPI_QUOTE_CARGO
                            WHERE quote_id = p_quote_id)
                LOOP
                   INSERT INTO GIPI_QUOTE_CARGO
                               (quote_id, item_no, vessel_cd,
                                geog_cd, cargo_class_cd, voyage_no,
                                bl_awb, origin, destn, etd, eta,
                                cargo_type, pack_method,
                                tranship_origin, tranship_destination,
                                lc_no, print_tag, deduct_text,
                                rec_flag, user_id, last_update
                               )
                        VALUES (v_new_quote_id, mn.item_no, mn.vessel_cd,
                                mn.geog_cd, mn.cargo_class_cd, mn.voyage_no,
                                mn.bl_awb, mn.origin, mn.destn, mn.etd, mn.eta,
                                mn.cargo_type, mn.pack_method,
                                mn.tranship_origin, mn.tranship_destination,
                                mn.lc_no, mn.print_tag, mn.deduct_text,
                                mn.rec_flag, NVL (p_user_id, USER), SYSDATE
                               );
                END LOOP;
             ELSIF v_menu_line_cd = 'AV' OR b.line_cd = v_aviation_cd
             THEN
                FOR av IN (SELECT item_no, vessel_cd, total_fly_time,
                                  qualification, purpose, geog_limit,
                                  deduct_text, rec_flag, fixed_wing, rotor,
                                  prev_util_hrs, est_util_hrs
                             FROM GIPI_QUOTE_AV_ITEM
                            WHERE quote_id = p_quote_id)
                LOOP
                   INSERT INTO GIPI_QUOTE_AV_ITEM
                               (quote_id, item_no, vessel_cd,
                                total_fly_time, qualification, purpose,
                                geog_limit, deduct_text, rec_flag,
                                fixed_wing, rotor, prev_util_hrs,
                                est_util_hrs, user_id, last_update
                               )
                        VALUES (v_new_quote_id, av.item_no, av.vessel_cd,
                                av.total_fly_time, av.qualification, av.purpose,
                                av.geog_limit, av.deduct_text, av.rec_flag,
                                av.fixed_wing, av.rotor, av.prev_util_hrs,
                                av.est_util_hrs, NVL (p_user_id, USER), SYSDATE
                               );
                END LOOP;
             ELSIF v_menu_line_cd = 'MH' OR b.line_cd = v_hull_cd
             THEN
                FOR ves IN (SELECT vessel_cd, rec_flag, vescon, voy_limit
                              FROM GIPI_QUOTE_VES_AIR
                             WHERE quote_id = p_quote_id)
                LOOP
                   INSERT INTO GIPI_QUOTE_VES_AIR
                               (quote_id, vessel_cd, rec_flag,
                                vescon, voy_limit
                               )
                        VALUES (v_new_quote_id, ves.vessel_cd, ves.rec_flag,
                                ves.vescon, ves.voy_limit
                               );
                END LOOP;

                FOR mh IN (SELECT item_no, vessel_cd, geog_limit, rec_flag,
                                  deduct_text, dry_date, dry_place
                             FROM GIPI_QUOTE_MH_ITEM
                            WHERE quote_id = p_quote_id)
                LOOP
                   INSERT INTO GIPI_QUOTE_MH_ITEM
                               (quote_id, item_no, vessel_cd,
                                geog_limit, rec_flag, deduct_text,
                                dry_date, dry_place, user_id, last_update
                               )
                        VALUES (v_new_quote_id, mh.item_no, mh.vessel_cd,
                                mh.geog_limit, mh.rec_flag, mh.deduct_text,
                                mh.dry_date, mh.dry_place, NVL (p_user_id, USER), SYSDATE
                               );
                END LOOP;
             ELSIF v_menu_line_cd = 'SU' OR b.line_cd = v_surety_cd
             THEN
                FOR su IN (SELECT obligee_no, prin_id, val_period_unit,
                                  val_period, coll_flag, clause_type, np_no,
                                  contract_dtl, contract_date, co_prin_sw,
                                  waiver_limit, indemnity_text, bond_dtl,
                                  endt_eff_date, remarks
                             FROM GIPI_QUOTE_BOND_BASIC
                            WHERE quote_id = p_quote_id)
                LOOP
                   INSERT INTO GIPI_QUOTE_BOND_BASIC
                               (quote_id, obligee_no, prin_id,
                                val_period_unit, val_period, coll_flag,
                                clause_type, np_no, contract_dtl,
                                contract_date, co_prin_sw,
                                waiver_limit, indemnity_text, bond_dtl,
                                endt_eff_date, remarks
                               )
                        VALUES (v_new_quote_id, su.obligee_no, su.prin_id,
                                su.val_period_unit, su.val_period, su.coll_flag,
                                su.clause_type, su.np_no, su.contract_dtl,
                                su.contract_date, su.co_prin_sw,
                                su.waiver_limit, su.indemnity_text, su.bond_dtl,
                                su.endt_eff_date, su.remarks
                               );
                END LOOP;
             END IF;

             FOR wc IN (SELECT line_cd, wc_cd, print_seq_no, wc_title, wc_title2,
                               wc_text01, wc_text02, wc_text03, wc_text04,
                               wc_text05, wc_text06, wc_text07, wc_text08,
                               wc_text09, wc_text10, wc_text11, wc_text12,
                               wc_text13, wc_text14, wc_text15, wc_text16,
                               wc_text17, wc_remarks, print_sw, change_tag
                          FROM GIPI_QUOTE_WC
                         WHERE quote_id = p_quote_id)
             LOOP
                INSERT INTO GIPI_QUOTE_WC
                            (quote_id, line_cd, wc_cd,
                             print_seq_no, wc_title, wc_title2,
                             wc_text01, wc_text02, wc_text03,
                             wc_text04, wc_text05, wc_text06,
                             wc_text07, wc_text08, wc_text09,
                             wc_text10, wc_text11, wc_text12,
                             wc_text13, wc_text14, wc_text15,
                             wc_text16, wc_text17, wc_remarks,
                             print_sw, change_tag, user_id, last_update
                            )
                     VALUES (v_new_quote_id, wc.line_cd, wc.wc_cd,
                             wc.print_seq_no, wc.wc_title, wc.wc_title2,
                             wc.wc_text01, wc.wc_text02, wc.wc_text03,
                             wc.wc_text04, wc.wc_text05, wc.wc_text06,
                             wc.wc_text07, wc.wc_text08, wc.wc_text09,
                             wc.wc_text10, wc.wc_text11, wc.wc_text12,
                             wc.wc_text13, wc.wc_text14, wc.wc_text15,
                             wc.wc_text16, wc.wc_text17, wc.wc_remarks,
                             wc.print_sw, wc.change_tag, NVL (p_user_id, USER), SYSDATE
                            );
             END LOOP;

             FOR co IN (SELECT cosign_id, assd_no, indem_flag, bonds_flag,
                               bonds_ri_flag
                          FROM GIPI_QUOTE_COSIGN
                         WHERE quote_id = p_quote_id)
             LOOP
                INSERT INTO GIPI_QUOTE_COSIGN
                            (quote_id, cosign_id, assd_no,
                             indem_flag, bonds_flag, bonds_ri_flag
                            )
                     VALUES (v_new_quote_id, co.cosign_id, co.assd_no,
                             co.indem_flag, co.bonds_flag, co.bonds_ri_flag
                            );
             END LOOP;

             FOR idis IN (SELECT surcharge_rt, surcharge_amt, subline_cd,
                                 SEQUENCE, remarks, orig_prem_amt, net_prem_amt,
                                 net_gross_tag, line_cd, item_no, disc_rt,
                                 disc_amt
                            FROM GIPI_QUOTE_ITEM_DISCOUNT
                           WHERE quote_id = p_quote_id)
             LOOP
                INSERT INTO GIPI_QUOTE_ITEM_DISCOUNT
                            (quote_id, surcharge_rt,
                             surcharge_amt, subline_cd, SEQUENCE,
                             remarks, orig_prem_amt,
                             net_prem_amt, net_gross_tag,
                             line_cd, item_no, disc_rt,
                             disc_amt, last_update
                            )
                     VALUES (v_new_quote_id, idis.surcharge_rt,
                             idis.surcharge_amt, idis.subline_cd, idis.SEQUENCE,
                             idis.remarks, idis.orig_prem_amt,
                             idis.net_prem_amt, idis.net_gross_tag,
                             idis.line_cd, idis.item_no, idis.disc_rt,
                             idis.disc_amt, SYSDATE
                            );
             END LOOP;

             FOR dis IN (SELECT line_cd, subline_cd, disc_rt, disc_amt,
                                net_gross_tag, orig_prem_amt, SEQUENCE,
                                net_prem_amt, remarks, surcharge_rt,
                                surcharge_amt
                           FROM GIPI_QUOTE_POLBASIC_DISCOUNT
                          WHERE quote_id = p_quote_id)
             LOOP
                INSERT INTO GIPI_QUOTE_POLBASIC_DISCOUNT
                            (quote_id, line_cd, subline_cd,
                             disc_rt, disc_amt, net_gross_tag,
                             orig_prem_amt, SEQUENCE, net_prem_amt,
                             remarks, surcharge_rt, surcharge_amt,
                             last_update
                            )
                     VALUES (v_new_quote_id, dis.line_cd, dis.subline_cd,
                             dis.disc_rt, dis.disc_amt, dis.net_gross_tag,
                             dis.orig_prem_amt, dis.SEQUENCE, dis.net_prem_amt,
                             dis.remarks, dis.surcharge_rt, dis.surcharge_amt,
                             SYSDATE
                            );
             END LOOP;

             FOR prin IN (SELECT principal_cd, engg_basic_infonum, subcon_sw
                            FROM GIPI_QUOTE_PRINCIPAL
                           WHERE quote_id = p_quote_id)
             LOOP
                INSERT INTO GIPI_QUOTE_PRINCIPAL
                            (quote_id, principal_cd,
                             engg_basic_infonum, subcon_sw
                            )
                     VALUES (v_new_quote_id, prin.principal_cd,
                             prin.engg_basic_infonum, prin.subcon_sw
                            );
             END LOOP;

             FOR pic IN (SELECT item_no, file_name, file_type, file_ext, remarks
                           FROM GIPI_QUOTE_PICTURES
                          WHERE quote_id = p_quote_id)
             LOOP
                INSERT INTO GIPI_QUOTE_PICTURES
                            (quote_id, item_no, file_name,
                             file_type, file_ext, remarks, user_id,
                             last_update
                            )
                     VALUES (v_new_quote_id, pic.item_no, pic.file_name,
                             pic.file_type, pic.file_ext, pic.remarks, NVL (p_user_id, USER),
                             SYSDATE
                            );
             END LOOP;

             FOR d IN (SELECT item_no, peril_cd, ded_deductible_cd,
                              deductible_amt, deductible_text, deductible_rt
                         FROM GIPI_QUOTE_DEDUCTIBLES
                        WHERE quote_id = p_quote_id)
             LOOP
                INSERT INTO GIPI_QUOTE_DEDUCTIBLES
                            (quote_id, item_no, peril_cd,
                             ded_deductible_cd, deductible_text,
                             deductible_amt, deductible_rt, user_id, last_update
                            )
                     VALUES (v_new_quote_id, d.item_no, d.peril_cd,
                             d.ded_deductible_cd, d.deductible_text,
                             d.deductible_amt, d.deductible_rt, NVL (p_user_id, USER), SYSDATE
                            );
             END LOOP;

             FOR pd IN (SELECT item_no, line_cd, peril_cd, disc_rt, level_tag,
                               disc_amt, net_gross_tag, discount_tag, subline_cd,
                               orig_peril_prem_amt, SEQUENCE, net_prem_amt,
                               remarks, surcharge_rt, surcharge_amt
                          FROM GIPI_QUOTE_PERIL_DISCOUNT
                         WHERE quote_id = p_quote_id)
             LOOP
                INSERT INTO gipi_quote_peril_discount
                            (quote_id, item_no, line_cd,
                             peril_cd, disc_rt, level_tag, disc_amt,
                             net_gross_tag, discount_tag, subline_cd,
                             orig_peril_prem_amt, SEQUENCE,
                             net_prem_amt, remarks, surcharge_rt,
                             surcharge_amt, last_update
                            )
                     VALUES (v_new_quote_id, pd.item_no, pd.line_cd,
                             pd.peril_cd, pd.disc_rt, pd.level_tag, pd.disc_amt,
                             pd.net_gross_tag, pd.discount_tag, pd.subline_cd,
                             pd.orig_peril_prem_amt, pd.SEQUENCE,
                             pd.net_prem_amt, pd.remarks, pd.surcharge_rt,
                             pd.surcharge_amt, SYSDATE
                            );
             END LOOP;

             FOR gqm IN (SELECT iss_cd, item_no, mortg_cd, amount, remarks
                           FROM GIPI_QUOTE_MORTGAGEE
                          WHERE quote_id = p_quote_id)
             LOOP
                INSERT INTO GIPI_QUOTE_MORTGAGEE
                            (quote_id, iss_cd, item_no,
                             mortg_cd, amount, remarks, user_id, last_update
                            )
                     VALUES (v_new_quote_id, gqm.iss_cd, gqm.item_no,
                             gqm.mortg_cd, gqm.amount, gqm.remarks, NVL (p_user_id, USER), SYSDATE
                            );
             END LOOP;
          END LOOP;
       END copy_quotation_2;

    /*
    **  Created by   : Veronica V. Raymundo
    **  Date Created : April 18, 2012
    **  Reference By : GIIMM001 - Quotation Listing
    **  Description  : This procedure will duplicate the quotation with the given
    **                 quote_id and return the quote_id of the newly created quotation.
    */

    PROCEDURE duplicate_quotation_2 (
          p_quote_id        IN   GIPI_QUOTE.quote_id%TYPE,
          p_user_id         IN   GIIS_USERS.user_id%TYPE,
          p_new_quote_id    OUT  GIPI_QUOTE.quote_id%TYPE
       )
       IS
          v_new_quote_id   GIPI_QUOTE.quote_id%TYPE;
          v_quote_inv_no   GIPI_QUOTE_INVOICE.quote_inv_no%TYPE;
          v_proposal_no    GIPI_QUOTE.proposal_no%TYPE;
          v_menu_line_cd   GIIS_LINE.menu_line_cd%TYPE;
          v_fire_cd        GIIS_LINE.line_cd%TYPE;
          v_motor_cd       GIIS_LINE.line_cd%TYPE;
          v_accident_cd    GIIS_LINE.line_cd%TYPE;
          v_hull_cd        GIIS_LINE.line_cd%TYPE;
          v_cargo_cd       GIIS_LINE.line_cd%TYPE;
          v_casualty_cd    GIIS_LINE.line_cd%TYPE;
          v_engrng_cd      GIIS_LINE.line_cd%TYPE;
          v_surety_cd      GIIS_LINE.line_cd%TYPE;
          v_aviation_cd    GIIS_LINE.line_cd%TYPE;
       BEGIN
          GIIS_LINE_PKG.get_param_line_cd (v_fire_cd,
                                           v_motor_cd,
                                           v_accident_cd,
                                           v_hull_cd,
                                           v_cargo_cd,
                                           v_casualty_cd,
                                           v_engrng_cd,
                                           v_surety_cd,
                                           v_aviation_cd
                                          );

          BEGIN
             SELECT quote_quote_id_s.NEXTVAL
               INTO v_new_quote_id
               FROM DUAL;
          EXCEPTION
             WHEN NO_DATA_FOUND
             THEN
                NULL;
          END;

          p_new_quote_id := v_new_quote_id;

    /* --removed, irwin - 2.7.2012
          UPDATE gipi_quote
             SET copied_quote_id = v_new_quote_id
           WHERE quote_id = p_quote_id;*/

          -- Check if the given quote_id exists in GIPI_QUOTE.....
          -- IF quote_id is existing do the ff line of code, else raise from trigger failure
          FOR a IN (SELECT line_cd, subline_cd, iss_cd, quotation_yy,
                           quotation_no, assd_no, assd_name, tsi_amt, prem_amt,
                           remarks, header, footer, status, print_tag,
                           incept_date, expiry_date, accept_dt, address1,
                           address2, address3, cred_branch, acct_of_cd,
                           acct_of_cd_sw, incept_tag, expiry_tag, valid_date, ann_tsi_amt, ann_prem_amt,
                           prorate_flag, short_rt_percent -- bonok :: 09.30.2013 :: SR 388 - GENQA
                      FROM GIPI_QUOTE
                     WHERE quote_id = p_quote_id)
          LOOP
             INSERT INTO GIPI_QUOTE
                         (proposal_no,
                          quote_id, line_cd, subline_cd, iss_cd,
                          quotation_yy, quotation_no, assd_no,
                          assd_name, tsi_amt, prem_amt, remarks,
                          header, footer, status, print_tag, incept_date,
                          expiry_date, last_update, user_id, accept_dt,
                          address1, address2, address3, cred_branch,
                          acct_of_cd, acct_of_cd_sw, incept_tag,
                          expiry_tag, valid_date,
                          underwriter, copied_quote_id, ann_tsi_amt, ann_prem_amt,
                          prorate_flag, short_rt_percent -- bonok :: 09.30.2013 :: SR 388 - GENQA
                         )
                  VALUES (GIPI_QUOTE_PKG.compute_proposal (a.line_cd,
                                                           a.subline_cd,
                                                           a.iss_cd,
                                                           a.quotation_yy,
                                                           a.quotation_no
                                                          ),
                          v_new_quote_id, a.line_cd, a.subline_cd, a.iss_cd,
                          a.quotation_yy, a.quotation_no, a.assd_no,
                          a.assd_name, a.tsi_amt, a.prem_amt, a.remarks,
                          a.header, a.footer, 'N', a.print_tag, a.incept_date,
                          a.expiry_date, SYSDATE, NVL(p_user_id, USER), SYSDATE,
                          a.address1, a.address2, a.address3, a.cred_branch,
                          a.acct_of_cd, a.acct_of_cd_sw, a.incept_tag,
                          a.expiry_tag, ADD_MONTHS (SYSDATE, 1),
                          NVL(p_user_id, USER), p_quote_id, a.ann_tsi_amt, a.ann_prem_amt,
                          a.prorate_flag, a.short_rt_percent -- bonok :: 09.30.2013 :: SR 388 - GENQA
                         );

             FOR v IN (SELECT item_no, item_title, item_desc, currency_cd,
                              currency_rate, pack_line_cd, pack_subline_cd,
                              tsi_amt, prem_amt, ann_tsi_amt, ann_prem_amt
                         FROM GIPI_QUOTE_ITEM
                        WHERE quote_id = p_quote_id)
             LOOP
                INSERT INTO GIPI_QUOTE_ITEM
                            (quote_id, item_no, item_title,
                             item_desc, currency_cd, currency_rate,
                             pack_line_cd, pack_subline_cd, tsi_amt,
                             prem_amt, ann_tsi_amt, ann_prem_amt
                            )
                     VALUES (v_new_quote_id, v.item_no, v.item_title,
                             v.item_desc, v.currency_cd, v.currency_rate,
                             v.pack_line_cd, v.pack_subline_cd, v.tsi_amt,
                             v.prem_amt , v.ann_tsi_amt, v.ann_prem_amt
                            );

                FOR m IN (SELECT item_no, peril_cd, tsi_amt, prem_amt, prem_rt,
                                 comp_rem,ann_prem_amt, ann_tsi_amt, line_cd , peril_type
                            FROM GIPI_QUOTE_ITMPERIL
                           WHERE quote_id = p_quote_id AND item_no = v.item_no)
                LOOP
                   INSERT INTO GIPI_QUOTE_ITMPERIL
                               (quote_id, item_no, peril_cd,
                                tsi_amt, prem_amt, prem_rt, comp_rem,ann_prem_amt, ann_tsi_amt, line_cd , peril_type
                               )
                        VALUES (v_new_quote_id, m.item_no, m.peril_cd,
                                m.tsi_amt, m.prem_amt, m.prem_rt, m.comp_rem, m.ann_prem_amt, m.ann_tsi_amt, m.line_cd , m.peril_type
                               );
                END LOOP;
             END LOOP;
             
             --Apollo Cruz 10.24.2014 - transferred copying of gipi_quote_invoice
             FOR b IN (SELECT quote_inv_no, iss_cd, intm_no, currency_cd,
                              currency_rt, prem_amt, tax_amt
                         FROM GIPI_QUOTE_INVOICE
                        WHERE quote_id = p_quote_id)
             LOOP
                FOR j IN (SELECT quote_inv_no
                            FROM GIIS_QUOTE_INV_SEQ
                           WHERE iss_cd = a.iss_cd)
                LOOP
                   v_quote_inv_no := j.quote_inv_no + 1;
                   EXIT;
                END LOOP;

                INSERT INTO GIPI_QUOTE_INVOICE
                            (quote_id, iss_cd, quote_inv_no,
                             intm_no, currency_cd, currency_rt,
                             prem_amt, tax_amt
                            )
                     VALUES (v_new_quote_id, b.iss_cd, v_quote_inv_no,
                             b.intm_no, b.currency_cd, b.currency_rt,
                             b.prem_amt, b.tax_amt
                            );

                FOR dbt IN (SELECT line_cd, iss_cd, tax_cd, tax_id, tax_amt,
                                   rate
                              FROM GIPI_QUOTE_INVTAX
                             WHERE quote_inv_no = b.quote_inv_no
                               AND iss_cd = b.iss_cd)
                LOOP
                   INSERT INTO GIPI_QUOTE_INVTAX
                               (line_cd, iss_cd, quote_inv_no,
                                tax_cd, tax_id, tax_amt, rate
                               )
                        VALUES (dbt.line_cd, dbt.iss_cd, v_quote_inv_no,
                                dbt.tax_cd, dbt.tax_id, dbt.tax_amt, dbt.rate
                               );
                END LOOP;
             END LOOP;

             FOR z IN (SELECT menu_line_cd
                         FROM GIIS_LINE
                        WHERE line_cd = a.line_cd)
             LOOP
                v_menu_line_cd := z.menu_line_cd;
                EXIT;
             END LOOP;

             IF v_menu_line_cd = 'AC' OR a.line_cd = v_accident_cd
             THEN
                FOR ac IN (SELECT item_no, no_of_persons, position_cd,
                                  monthly_salary, salary_grade, destination,
                                  ac_class_cd, age, civil_status, date_of_birth,
                                  group_print_sw, height, level_cd,
                                  parent_level_cd, sex, weight
                             FROM GIPI_QUOTE_AC_ITEM
                            WHERE quote_id = p_quote_id)
                LOOP
                   INSERT INTO GIPI_QUOTE_AC_ITEM
                               (quote_id, item_no, no_of_persons,
                                position_cd, monthly_salary,
                                salary_grade, destination, ac_class_cd,
                                age, civil_status, date_of_birth,
                                group_print_sw, height, level_cd,
                                parent_level_cd, sex, weight, user_id,
                                last_update
                               )
                        VALUES (v_new_quote_id, ac.item_no, ac.no_of_persons,
                                ac.position_cd, ac.monthly_salary,
                                ac.salary_grade, ac.destination, ac.ac_class_cd,
                                ac.age, ac.civil_status, ac.date_of_birth,
                                ac.group_print_sw, ac.height, ac.level_cd,
                                ac.parent_level_cd, ac.sex, ac.weight, NVL(p_user_id, USER),
                                SYSDATE
                               );
                END LOOP;
             ELSIF v_menu_line_cd = 'MC' OR a.line_cd = v_motor_cd
             THEN
                FOR mc IN (SELECT item_no, plate_no, motor_no, serial_no,
                                  subline_type_cd, mot_type, car_company_cd,
                                  coc_yy, coc_seq_no, coc_serial_no, coc_type,
                                  repair_lim, color, model_year, make, est_value,
                                  towing, assignee, no_of_pass, tariff_zone,
                                  coc_issue_date, mv_file_no, acquired_from,
                                  ctv_tag, type_of_body_cd, unladen_wt, make_cd,
                                  series_cd, basic_color_cd, color_cd, origin,
                                  destination, coc_atcn, subline_cd
                             FROM GIPI_QUOTE_ITEM_MC
                            WHERE quote_id = p_quote_id)
                LOOP
                   INSERT INTO GIPI_QUOTE_ITEM_MC
                               (quote_id, item_no, plate_no,
                                motor_no, serial_no, subline_type_cd,
                                mot_type, car_company_cd, coc_yy,
                                coc_seq_no, coc_serial_no, coc_type,
                                repair_lim, color, model_year, make,
                                est_value, towing, assignee,
                                no_of_pass, tariff_zone,
                                coc_issue_date, mv_file_no,
                                acquired_from, ctv_tag,
                                type_of_body_cd, unladen_wt, make_cd,
                                series_cd, basic_color_cd, color_cd,
                                origin, destination, coc_atcn,
                                subline_cd, user_id, last_update
                               )
                        VALUES (v_new_quote_id, mc.item_no, mc.plate_no,
                                mc.motor_no, mc.serial_no, mc.subline_type_cd,
                                mc.mot_type, mc.car_company_cd, mc.coc_yy,
                                mc.coc_seq_no, mc.coc_serial_no, mc.coc_type,
                                mc.repair_lim, mc.color, mc.model_year, mc.make,
                                mc.est_value, mc.towing, mc.assignee,
                                mc.no_of_pass, mc.tariff_zone,
                                mc.coc_issue_date, mc.mv_file_no,
                                mc.acquired_from, mc.ctv_tag,
                                mc.type_of_body_cd, mc.unladen_wt, mc.make_cd,
                                mc.series_cd, mc.basic_color_cd, mc.color_cd,
                                mc.origin, mc.destination, mc.coc_atcn,
                                mc.subline_cd, NVL(p_user_id, USER), SYSDATE
                               );
                END LOOP;
             ELSIF v_menu_line_cd = 'FI' OR a.line_cd = v_fire_cd
             THEN
                FOR fi IN (SELECT item_no, district_no, eq_zone, tarf_cd,
                                  block_no, fr_item_type, loc_risk1, loc_risk2,
                                  loc_risk3, tariff_zone, typhoon_zone,
                                  construction_cd, construction_remarks, front,
                                  RIGHT, LEFT, rear, occupancy_cd,
                                  occupancy_remarks, flood_zone, assignee,
                                  block_id, risk_cd
                             FROM GIPI_QUOTE_FI_ITEM
                            WHERE quote_id = p_quote_id)
                LOOP
                   INSERT INTO GIPI_QUOTE_FI_ITEM
                               (quote_id, item_no, district_no,
                                eq_zone, tarf_cd, block_no,
                                fr_item_type, loc_risk1, loc_risk2,
                                loc_risk3, tariff_zone, typhoon_zone,
                                construction_cd, construction_remarks,
                                front, RIGHT, LEFT, rear,
                                occupancy_cd, occupancy_remarks,
                                flood_zone, assignee, block_id,
                                risk_cd, user_id, last_update
                               )
                        VALUES (v_new_quote_id, fi.item_no, fi.district_no,
                                fi.eq_zone, fi.tarf_cd, fi.block_no,
                                fi.fr_item_type, fi.loc_risk1, fi.loc_risk2,
                                fi.loc_risk3, fi.tariff_zone, fi.typhoon_zone,
                                fi.construction_cd, fi.construction_remarks,
                                fi.front, fi.RIGHT, fi.LEFT, fi.rear,
                                fi.occupancy_cd, fi.occupancy_remarks,
                                fi.flood_zone, fi.assignee, fi.block_id,
                                fi.risk_cd, NVL(p_user_id, USER), SYSDATE
                               );
                END LOOP;
             ELSIF v_menu_line_cd = 'EN' OR a.line_cd = v_engrng_cd
             THEN
                FOR en IN (SELECT engg_basic_infonum, contract_proj_buss_title,
                                  site_location, construct_start_date,
                                  construct_end_date, maintain_start_date,
                                  maintain_end_date, testing_start_date,
                                  testing_end_date, weeks_test, time_excess,
                                  mbi_policy_no
                             FROM GIPI_QUOTE_EN_ITEM
                            WHERE quote_id = p_quote_id)
                LOOP
                   INSERT INTO GIPI_QUOTE_EN_ITEM
                               (quote_id, engg_basic_infonum,
                                contract_proj_buss_title, site_location,
                                construct_start_date, construct_end_date,
                                maintain_start_date, maintain_end_date,
                                testing_start_date, testing_end_date,
                                weeks_test, time_excess, mbi_policy_no,
                                user_id, last_update
                               )
                        VALUES (v_new_quote_id, en.engg_basic_infonum,
                                en.contract_proj_buss_title, en.site_location,
                                en.construct_start_date, en.construct_end_date,
                                en.maintain_start_date, en.maintain_end_date,
                                en.testing_start_date, en.testing_end_date,
                                en.weeks_test, en.time_excess, en.mbi_policy_no,
                                NVL(p_user_id, USER), SYSDATE
                               );
                END LOOP;
             ELSIF v_menu_line_cd = 'CA' OR a.line_cd = v_casualty_cd
             THEN
                FOR ca IN (SELECT item_no, section_line_cd, section_subline_cd,
                                  section_or_hazard_cd, capacity_cd,
                                  property_no_type, property_no, LOCATION,
                                  conveyance_info, interest_on_premises,
                                  limit_of_liability, section_or_hazard_info
                             FROM GIPI_QUOTE_CA_ITEM
                            WHERE quote_id = p_quote_id)
                LOOP
                   INSERT INTO GIPI_QUOTE_CA_ITEM
                               (quote_id, item_no, section_line_cd,
                                section_subline_cd, section_or_hazard_cd,
                                capacity_cd, property_no_type,
                                property_no, LOCATION, conveyance_info,
                                interest_on_premises, limit_of_liability,
                                section_or_hazard_info, user_id, last_update
                               )
                        VALUES (v_new_quote_id, ca.item_no, ca.section_line_cd,
                                ca.section_subline_cd, ca.section_or_hazard_cd,
                                ca.capacity_cd, ca.property_no_type,
                                ca.property_no, ca.LOCATION, ca.conveyance_info,
                                ca.interest_on_premises, ca.limit_of_liability,
                                ca.section_or_hazard_info, NVL(p_user_id, USER), SYSDATE
                               );
                END LOOP;
             ELSIF v_menu_line_cd = 'MN' OR a.line_cd = v_cargo_cd
             THEN
                FOR ves IN (SELECT vessel_cd, rec_flag, vescon, voy_limit
                              FROM GIPI_QUOTE_VES_AIR
                             WHERE quote_id = p_quote_id)
                LOOP
                   INSERT INTO GIPI_QUOTE_VES_AIR
                               (quote_id, vessel_cd, rec_flag,
                                vescon, voy_limit
                               )
                        VALUES (v_new_quote_id, ves.vessel_cd, ves.rec_flag,
                                ves.vescon, ves.voy_limit
                               );
                END LOOP;

                FOR mn IN (SELECT item_no, vessel_cd, geog_cd, cargo_class_cd,
                                  voyage_no, bl_awb, origin, destn, etd, eta,
                                  cargo_type, pack_method, tranship_origin,
                                  tranship_destination, lc_no, print_tag,
                                  deduct_text, rec_flag
                             FROM GIPI_QUOTE_CARGO
                            WHERE quote_id = p_quote_id)
                LOOP
                   INSERT INTO GIPI_QUOTE_CARGO
                               (quote_id, item_no, vessel_cd,
                                geog_cd, cargo_class_cd, voyage_no,
                                bl_awb, origin, destn, etd, eta,
                                cargo_type, pack_method,
                                tranship_origin, tranship_destination,
                                lc_no, print_tag, deduct_text,
                                rec_flag, user_id, last_update
                               )
                        VALUES (v_new_quote_id, mn.item_no, mn.vessel_cd,
                                mn.geog_cd, mn.cargo_class_cd, mn.voyage_no,
                                mn.bl_awb, mn.origin, mn.destn, mn.etd, mn.eta,
                                mn.cargo_type, mn.pack_method,
                                mn.tranship_origin, mn.tranship_destination,
                                mn.lc_no, mn.print_tag, mn.deduct_text,
                                mn.rec_flag, NVL(p_user_id, USER), SYSDATE
                               );
                END LOOP;
             ELSIF v_menu_line_cd = 'AV' OR a.line_cd = v_aviation_cd
             THEN
                FOR av IN (SELECT item_no, vessel_cd, total_fly_time,
                                  qualification, purpose, geog_limit,
                                  deduct_text, rec_flag, fixed_wing, rotor,
                                  prev_util_hrs, est_util_hrs
                             FROM GIPI_QUOTE_AV_ITEM
                            WHERE quote_id = p_quote_id)
                LOOP
                   INSERT INTO GIPI_QUOTE_AV_ITEM
                               (quote_id, item_no, vessel_cd,
                                total_fly_time, qualification, purpose,
                                geog_limit, deduct_text, rec_flag,
                                fixed_wing, rotor, prev_util_hrs,
                                est_util_hrs, user_id, last_update
                               )
                        VALUES (v_new_quote_id, av.item_no, av.vessel_cd,
                                av.total_fly_time, av.qualification, av.purpose,
                                av.geog_limit, av.deduct_text, av.rec_flag,
                                av.fixed_wing, av.rotor, av.prev_util_hrs,
                                av.est_util_hrs, NVL(p_user_id, USER), SYSDATE
                               );
                END LOOP;
             ELSIF v_menu_line_cd = 'MH' OR a.line_cd = v_hull_cd
             THEN
                FOR ves IN (SELECT vessel_cd, rec_flag, vescon, voy_limit
                              FROM GIPI_QUOTE_VES_AIR
                             WHERE quote_id = p_quote_id)
                LOOP
                   INSERT INTO GIPI_QUOTE_VES_AIR
                               (quote_id, vessel_cd, rec_flag,
                                vescon, voy_limit
                               )
                        VALUES (v_new_quote_id, ves.vessel_cd, ves.rec_flag,
                                ves.vescon, ves.voy_limit
                               );
                END LOOP;

                FOR mh IN (SELECT item_no, vessel_cd, geog_limit, rec_flag,
                                  deduct_text, dry_date, dry_place
                             FROM GIPI_QUOTE_MH_ITEM
                            WHERE quote_id = p_quote_id)
                LOOP
                   INSERT INTO GIPI_QUOTE_MH_ITEM
                               (quote_id, item_no, vessel_cd,
                                geog_limit, rec_flag, deduct_text,
                                dry_date, dry_place, user_id, last_update
                               )
                        VALUES (v_new_quote_id, mh.item_no, mh.vessel_cd,
                                mh.geog_limit, mh.rec_flag, mh.deduct_text,
                                mh.dry_date, mh.dry_place, NVL(p_user_id, USER), SYSDATE
                               );
                END LOOP;
             ELSIF v_menu_line_cd = 'SU' OR a.line_cd = v_surety_cd
             THEN
                FOR su IN (SELECT obligee_no, prin_id, val_period_unit,
                                  val_period, coll_flag, clause_type, np_no,
                                  contract_dtl, contract_date, co_prin_sw,
                                  waiver_limit, indemnity_text, bond_dtl,
                                  endt_eff_date, remarks
                             FROM GIPI_QUOTE_BOND_BASIC
                            WHERE quote_id = p_quote_id)
                LOOP
                   INSERT INTO GIPI_QUOTE_BOND_BASIC
                               (quote_id, obligee_no, prin_id,
                                val_period_unit, val_period, coll_flag,
                                clause_type, np_no, contract_dtl,
                                contract_date, co_prin_sw,
                                waiver_limit, indemnity_text, bond_dtl,
                                endt_eff_date, remarks
                               )
                        VALUES (v_new_quote_id, su.obligee_no, su.prin_id,
                                su.val_period_unit, su.val_period, su.coll_flag,
                                su.clause_type, su.np_no, su.contract_dtl,
                                su.contract_date, su.co_prin_sw,
                                su.waiver_limit, su.indemnity_text, su.bond_dtl,
                                su.endt_eff_date, su.remarks
                               );
                END LOOP;
             END IF;

             FOR wc IN (SELECT line_cd, wc_cd, print_seq_no, wc_title, wc_title2,
                               wc_text01, wc_text02, wc_text03, wc_text04,
                               wc_text05, wc_text06, wc_text07, wc_text08,
                               wc_text09, wc_text10, wc_text11, wc_text12,
                               wc_text13, wc_text14, wc_text15, wc_text16,
                               wc_text17, wc_remarks, print_sw, change_tag
                          FROM GIPI_QUOTE_WC
                         WHERE quote_id = p_quote_id)
             LOOP
                INSERT INTO GIPI_QUOTE_WC
                            (quote_id, line_cd, wc_cd,
                             print_seq_no, wc_title, wc_title2,
                             wc_text01, wc_text02, wc_text03,
                             wc_text04, wc_text05, wc_text06,
                             wc_text07, wc_text08, wc_text09,
                             wc_text10, wc_text11, wc_text12,
                             wc_text13, wc_text14, wc_text15,
                             wc_text16, wc_text17, wc_remarks,
                             print_sw, change_tag, user_id, last_update
                            )
                     VALUES (v_new_quote_id, wc.line_cd, wc.wc_cd,
                             wc.print_seq_no, wc.wc_title, wc.wc_title2,
                             wc.wc_text01, wc.wc_text02, wc.wc_text03,
                             wc.wc_text04, wc.wc_text05, wc.wc_text06,
                             wc.wc_text07, wc.wc_text08, wc.wc_text09,
                             wc.wc_text10, wc.wc_text11, wc.wc_text12,
                             wc.wc_text13, wc.wc_text14, wc.wc_text15,
                             wc.wc_text16, wc.wc_text17, wc.wc_remarks,
                             wc.print_sw, wc.change_tag, NVL(p_user_id, USER), SYSDATE
                            );
             END LOOP;

             FOR co IN (SELECT cosign_id, assd_no, indem_flag, bonds_flag,
                               bonds_ri_flag
                          FROM GIPI_QUOTE_COSIGN
                         WHERE quote_id = p_quote_id)
             LOOP
                INSERT INTO GIPI_QUOTE_COSIGN
                            (quote_id, cosign_id, assd_no,
                             indem_flag, bonds_flag, bonds_ri_flag
                            )
                     VALUES (v_new_quote_id, co.cosign_id, co.assd_no,
                             co.indem_flag, co.bonds_flag, co.bonds_ri_flag
                            );
             END LOOP;

             FOR dis IN (SELECT surcharge_rt, surcharge_amt, subline_cd, SEQUENCE,
                                remarks, orig_prem_amt, net_prem_amt,
                                net_gross_tag, line_cd, item_no, disc_rt,
                                disc_amt
                           FROM GIPI_QUOTE_ITEM_DISCOUNT
                          WHERE quote_id = p_quote_id)
             LOOP
                INSERT INTO GIPI_QUOTE_ITEM_DISCOUNT
                            (quote_id, surcharge_rt,
                             surcharge_amt, subline_cd, SEQUENCE,
                             remarks, orig_prem_amt, net_prem_amt,
                             net_gross_tag, line_cd, item_no,
                             disc_rt, disc_amt, last_update
                            )
                     VALUES (v_new_quote_id, dis.surcharge_rt,
                             dis.surcharge_amt, dis.subline_cd, dis.SEQUENCE,
                             dis.remarks, dis.orig_prem_amt, dis.net_prem_amt,
                             dis.net_gross_tag, dis.line_cd, dis.item_no,
                             dis.disc_rt, dis.disc_amt, SYSDATE
                            );
             END LOOP;

             FOR pol IN (SELECT line_cd, subline_cd, disc_rt, disc_amt,
                                net_gross_tag, orig_prem_amt, SEQUENCE,
                                net_prem_amt, remarks, surcharge_rt,
                                surcharge_amt
                           FROM GIPI_QUOTE_POLBASIC_DISCOUNT
                          WHERE quote_id = p_quote_id)
             LOOP
                INSERT INTO GIPI_QUOTE_POLBASIC_DISCOUNT
                            (quote_id, line_cd, subline_cd,
                             disc_rt, disc_amt, net_gross_tag,
                             orig_prem_amt, SEQUENCE, net_prem_amt,
                             remarks, surcharge_rt, surcharge_amt,
                             last_update
                            )
                     VALUES (v_new_quote_id, pol.line_cd, pol.subline_cd,
                             pol.disc_rt, pol.disc_amt, pol.net_gross_tag,
                             pol.orig_prem_amt, pol.SEQUENCE, pol.net_prem_amt,
                             pol.remarks, pol.surcharge_rt, pol.surcharge_amt,
                             SYSDATE
                            );
             END LOOP;

             FOR prin IN (SELECT principal_cd, engg_basic_infonum, subcon_sw
                            FROM GIPI_QUOTE_PRINCIPAL
                           WHERE quote_id = p_quote_id)
             LOOP
                INSERT INTO GIPI_QUOTE_PRINCIPAL
                            (quote_id, principal_cd,
                             engg_basic_infonum, subcon_sw
                            )
                     VALUES (v_new_quote_id, prin.principal_cd,
                             prin.engg_basic_infonum, prin.subcon_sw
                            );
             END LOOP;

             FOR pic IN (SELECT item_no, file_name, file_type, file_ext, remarks
                           FROM GIPI_QUOTE_PICTURES
                          WHERE quote_id = p_quote_id)
             LOOP
                INSERT INTO GIPI_QUOTE_PICTURES
                            (quote_id, item_no, file_name,
                             file_type, file_ext, remarks, user_id,
                             last_update
                            )
                     VALUES (v_new_quote_id, pic.item_no, pic.file_name,
                             pic.file_type, pic.file_ext, pic.remarks, NVL(p_user_id, USER),
                             SYSDATE
                            );
             END LOOP;

             FOR d IN (SELECT item_no, peril_cd, ded_deductible_cd,
                              deductible_amt, deductible_text, deductible_rt
                         FROM GIPI_QUOTE_DEDUCTIBLES
                        WHERE quote_id = p_quote_id)
             LOOP
                INSERT INTO GIPI_QUOTE_DEDUCTIBLES
                            (quote_id, item_no, peril_cd,
                             ded_deductible_cd, deductible_text,
                             deductible_amt, deductible_rt, user_id, last_update
                            )
                     VALUES (v_new_quote_id, d.item_no, d.peril_cd,
                             d.ded_deductible_cd, d.deductible_text,
                             d.deductible_amt, d.deductible_rt, NVL(p_user_id, USER), SYSDATE
                            );
             END LOOP;

             FOR pd IN (SELECT item_no, line_cd, peril_cd, disc_rt, level_tag,
                               disc_amt, net_gross_tag, discount_tag, subline_cd,
                               orig_peril_prem_amt, SEQUENCE, net_prem_amt,
                               remarks, surcharge_rt, surcharge_amt
                          FROM GIPI_QUOTE_PERIL_DISCOUNT
                         WHERE quote_id = p_quote_id)
             LOOP
                INSERT INTO GIPI_QUOTE_PERIL_DISCOUNT
                            (quote_id, item_no, line_cd,
                             peril_cd, disc_rt, level_tag, disc_amt,
                             net_gross_tag, discount_tag, subline_cd,
                             orig_peril_prem_amt, SEQUENCE,
                             net_prem_amt, remarks, surcharge_rt,
                             surcharge_amt, last_update
                            )
                     VALUES (v_new_quote_id, pd.item_no, pd.line_cd,
                             pd.peril_cd, pd.disc_rt, pd.level_tag, pd.disc_amt,
                             pd.net_gross_tag, pd.discount_tag, pd.subline_cd,
                             pd.orig_peril_prem_amt, pd.SEQUENCE,
                             pd.net_prem_amt, pd.remarks, pd.surcharge_rt,
                             pd.surcharge_amt, SYSDATE
                            );
             END LOOP;

             FOR gqm IN (SELECT iss_cd, item_no, mortg_cd, amount, remarks
                           FROM GIPI_QUOTE_MORTGAGEE
                          WHERE quote_id = p_quote_id)
             LOOP
                INSERT INTO GIPI_QUOTE_MORTGAGEE
                            (quote_id, iss_cd, item_no,
                             mortg_cd, amount, remarks, user_id, last_update
                            )
                     VALUES (v_new_quote_id, gqm.iss_cd, gqm.item_no,
                             gqm.mortg_cd, gqm.amount, gqm.remarks, NVL(p_user_id, USER), SYSDATE
                            );
             END LOOP;
          END LOOP;
       END duplicate_quotation_2;
       
    FUNCTION get_vat_tag(
        p_quote_id          GIPI_QUOTE.quote_id%TYPE
    )
      RETURN VARCHAR2 AS
        v_vat_tag           VARCHAR2(1);
    BEGIN
        SELECT NVL(vat_tag,3) vat_tag
          INTO v_vat_tag
          FROM GIIS_ASSURED b,
               GIPI_QUOTE a
         WHERE b.assd_no = a.assd_no
           AND a.quote_id = p_quote_id;
        RETURN v_vat_tag;
    END;

/*
** Modified by reymon 02192013
** Added trunc to all dates
** Added nvl for quotation assured with null assd_no
** Changed the package quote no. par number and policy number 
*/
FUNCTION get_quotation_status_list (
      p_line_cd        gipi_quote.line_cd%TYPE,
      p_user_id        giis_users.user_id%TYPE,
      p_user_id2       giis_users.user_id%TYPE, --added by steven 11.7.2012
      p_date_from      VARCHAR2,
      p_date_to        VARCHAR2,
      p_status         gipi_quote.status%TYPE,
      p_proposal_no    gipi_quote.proposal_no%TYPE,
      p_quotation_yy   gipi_quote.quotation_yy%TYPE,
      p_quotation_no   gipi_quote.quotation_no%TYPE,
      p_iss_cd         gipi_quote.iss_cd%TYPE,
      p_assd_name      gipi_quote.assd_name%TYPE,
      p_quote_id       gipi_quote.quote_id%TYPE,
      p_subline_cd     gipi_quote.subline_cd%TYPE,
      p_incept_date    VARCHAR2,
      p_expiry_date    VARCHAR2,
      p_par_assd       giis_assured.assd_name%TYPE,
      p_quote_no       VARCHAR2,
      --Added by MarkS SR5780 10.24.2016 optimization
      p_filter_status  VARCHAR2,
      p_order_by       VARCHAR2,
      p_asc_desc_flag  VARCHAR2,
      p_from           NUMBER,
      p_to             NUMBER
      --SR5780 10.24.2016
   )
      RETURN quote_list_status_tab PIPELINED
   IS
      --v_quote   quote_list_status_type; --commented out by MarkS 10.25.2016 SR5780
      TYPE cur_type IS REF CURSOR;
      c        cur_type;
      v_rec   quote_list_status_type;
      v_sql   VARCHAR2(32767);
   BEGIN
   --modified  by MarkS 10.25.2016 SR5780 OPTIMIZATION
    v_sql := 'SELECT mainsql.*
                   FROM (
                    SELECT COUNT (1) OVER () count_, outersql.* 
                      FROM (
                            SELECT ROWNUM rownum_, innersql.*
                              FROM (SELECT a.quote_id, a.pack_pol_flag, a.pack_quote_id,
                      a.line_cd
                   || ''-''
                   || a.subline_cd
                   || ''-''
                   || a.iss_cd
                   || ''-''
                   || a.quotation_yy
                   || ''-''
                   || TO_CHAR (TRIM (a.quotation_no), ''000009'')
                   || ''-''
                   || TO_CHAR (TRIM (a.proposal_no), ''009'') quote_no,
                  TRUNC(a.incept_date) incept_date, TRUNC(a.expiry_date) expiry_date, TRUNC(a.valid_date) valid_date, a.user_id,
                   TRUNC(a.accept_dt) accept_dt,
                   (SELECT   UPPER (rv_meaning) rv_meaning
                     FROM cg_ref_codes
                    WHERE rv_domain = ''GIPI_QUOTE.STATUS''
                      AND rv_low_value = a.status) status_mean, --added by MarkS 10.24.2016 SR5780
                   a.reason_cd, p.par_id,
                   DECODE(p.par_id, NULL, NULL, --added by reymon 02192013
                      p.line_cd
                   || ''-''
                   || p.iss_cd
                   || ''-''
                   || TO_CHAR (p.par_yy, ''09'')
                   || ''-''
                   || TO_CHAR (p.par_seq_no, ''000009'')
                   || ''-''
                   || TO_CHAR (p.quote_seq_no, ''09'')) par_no,
                   (SELECT    line_cd
                         || ''-''
                         || subline_cd
                         || ''-''
                         || iss_cd
                         || ''-''
                         || LTRIM (TO_CHAR (issue_yy, ''09''))
                         || ''-''
                         || LTRIM (TO_CHAR (pol_seq_no, ''0999999''))
                         || ''-''
                         || LTRIM (TO_CHAR (renew_no, ''09''))
                         || DECODE (
                               NVL (endt_seq_no, 0),
                               0, '''',
                                  '' / ''
                               || endt_iss_cd
                               || ''-''
                               || LTRIM (TO_CHAR (endt_yy, ''09''))
                               || ''-''
                               || LTRIM (TO_CHAR (endt_seq_no, ''0999999''))
                            ) policy_no
                    FROM gipi_polbasic
                    WHERE policy_id = z.policy_id) pol_no, --added by MarkS 10.24.2016 SR5780
                   a.assd_no,
                   (SELECT    p.line_cd
                                 || ''-''
                                 || p.subline_cd
                                 || ''-''
                                 || p.iss_cd
                                 || ''-''
                                 || p.quotation_yy
                                 || ''-''
                                 || TO_CHAR (p.quotation_no, ''000009'')
                                 || ''-''
                                 || TO_CHAR (p.proposal_no, ''009'')
                            FROM gipi_pack_quote p
                           WHERE p.pack_quote_id = a.pack_quote_id) pack_quote_no,a.assd_name quote_assd_name,--added by MarkS 10.24.2016 SR5780
                           DECODE(p.assd_no,a.assd_no,v.assd_no,null) par_assd_name, --added by MarkS 10.24.2016 SR5780
                           DECODE(a.status,''D'',DECODE(reason_cd,NULL,NULL,(
                                                                                (SELECT reason_desc
                                                                                    FROM giis_lost_bid
                                                                                 WHERE reason_cd = a.reason_cd
                                                                                 AND line_cd = '''|| p_line_cd ||''')
                                                                             )
                                                       )
                                 ) reason_desc --added by MarkS 10.24.2016 SR5780
              FROM gipi_quote a,
                   gipi_parlist p,
                   gipi_polbasic z,
                   giis_assured v--,
             WHERE a.line_cd = '''||p_line_cd||'''  
               AND a.quote_id = p.quote_id(+)
               AND a.assd_no = p.assd_no(+)
               AND p.par_id = z.par_id(+)
               AND a.assd_no = v.assd_no(+)
               AND a.subline_cd LIKE UPPER (NVL ('''||p_subline_cd||''', a.subline_cd))
               AND EXISTS (SELECT ''X''
                                 FROM TABLE (security_access.get_branch_line (''UW'', ''GIIMM004'', '''||p_user_id2||'''))
                                WHERE branch_cd = a.iss_cd)';
               IF p_iss_cd IS NOT NULL THEN
                   v_sql := v_sql || ' AND a.iss_cd LIKE UPPER (NVL ('''||p_iss_cd||''', a.iss_cd))';
               END IF;                                
               
               IF p_quotation_yy IS NOT NULL THEN
                   v_sql := v_sql || ' AND a.quotation_yy = NVL ('''||p_quotation_yy||''', a.quotation_yy)';
               END IF; 
               
               IF p_quotation_yy IS NOT NULL THEN
                   v_sql := v_sql || ' AND NVL (a.assd_name, ''%%'') LIKE UPPER (NVL ('''||p_assd_name||''', ''%%''))';
               END IF;
               
               IF p_quotation_no IS NOT NULL THEN
                   v_sql := v_sql || ' AND a.quotation_no = NVL ('''||p_quotation_no||''', a.quotation_no)';
               END IF;
               
               IF p_proposal_no IS NOT NULL THEN
                   v_sql := v_sql || 'AND a.proposal_no = NVL ('''||p_proposal_no||''', a.proposal_no)';
               END IF;
               
               IF p_incept_date IS NOT NULL THEN
                   v_sql := v_sql || 'AND TRUNC (a.incept_date) = TRUNC (NVL (TO_DATE ('''||p_incept_date||''', ''MM-DD-RRRR''),
                                                                                TRUNC(a.incept_date)
                                                                        )
                                                )';
               END IF;
               
               IF p_expiry_date IS NOT NULL THEN
                   v_sql := v_sql || 'AND TRUNC (a.expiry_date) = TRUNC (NVL (TO_DATE ('''||p_expiry_date||''', ''MM-DD-RRRR''),
                                                                                TRUNC(a.expiry_date)
                                                                        )
                                                )';
               END IF;
               
               IF p_date_from IS NOT NULL OR p_date_to IS NOT NULL  THEN
                   v_sql := v_sql || ' AND TRUNC (a.accept_dt)
                      BETWEEN TRUNC (NVL (TO_DATE ('''||p_date_from||''', ''MM-DD-RRRR''),
                                          TRUNC(a.accept_dt)
                                         )
                                    )
                              AND TRUNC (NVL (TO_DATE ('''||p_date_to||''', ''MM-DD-RRRR''),
                                          TRUNC(a.accept_dt)
                                         )
                                    )';
               END IF;
               
               IF p_quote_no IS NOT NULL THEN
                   v_sql := v_sql || ' AND NVL (   a.line_cd
                                                            || ''-''
                                                            || a.subline_cd
                                                            || ''-''
                                                            || a.iss_cd
                                                            || ''-''
                                                            || a.quotation_yy
                                                            || ''-''
                                                            || TO_CHAR (TRIM (a.quotation_no), ''000009'')
                                                            || ''-''
                                                            || TO_CHAR (TRIM (a.proposal_no), ''009''),
                                                            ''%%''
                                                           ) LIKE NVL ('''||p_quote_no||''', ''%%'')';  
               END IF;
               
               IF p_status IS NOT NULL THEN
                   v_sql := v_sql || ' AND a.status = (DECODE (UPPER ('''||p_status||'''),
                                                               ''NOT SELECTED'', ''X'',
                                                               ''DENIED'', ''D'',
                                                               ''WITH PAR'', ''W'',
                                                               ''NEW'', ''N'',
                                                               ''POSTED POLICY'', ''P'',
                                                               a.status
                                                              )
                                                      )';
               END IF;
               
               IF p_user_id IS NOT NULL THEN
                   v_sql := v_sql || ' AND UPPER(a.user_id) LIKE UPPER(NVL ('''||p_user_id||''', ''%%''))';
               END IF;
       IF p_order_by IS NOT NULL 
        THEN
            IF p_order_by = 'quoteNo' THEN
               v_sql := v_sql || ' ORDER BY quote_no ';
            ELSIF p_order_by = 'assdName' THEN
               v_sql := v_sql || ' ORDER BY quote_assd_name ';
            ELSIF p_order_by = 'acceptDate' THEN
               v_sql := v_sql || ' ORDER BY accept_dt ';
            ELSIF p_order_by = 'userId' THEN
               v_sql := v_sql || ' ORDER BY user_id ';
            ELSIF p_order_by = 'status' THEN
               v_sql := v_sql || ' ORDER BY status_mean ';
            END IF; 
            
            IF p_asc_desc_flag IS NOT NULL 
            THEN
                IF p_asc_desc_flag = 'DESC' THEN
                    v_sql := v_sql || ' DESC';
                ELSE
                    v_sql := v_sql || ' ASC';
                END IF; 
            END IF; 
            v_sql := v_sql || ') innersql ';
       ELSE
           v_sql := v_sql || ' ORDER BY    a.line_cd   || ''-''
                                                       || a.subline_cd
                                                       || ''-''
                                                       || a.iss_cd
                                                       || ''-''
                                                       || a.quotation_yy
                                                       || ''-''
                                                       || TO_CHAR (a.quotation_no, ''000009'')
                                                       || ''-''
                                                       || TO_CHAR (a.proposal_no, ''009''),
                                                       a.accept_dt DESC) innersql ';            
       END IF;
       
        IF p_filter_status IS NOT NULL THEN
            v_sql := v_sql || ' WHERE UPPER(innersql.status_mean) LIKE UPPER(NVL('''||p_filter_status||''', ''%%'')) ';
        END IF;
        
        v_sql := v_sql || ') outersql
                         ) mainsql
                    WHERE rownum_ BETWEEN '|| p_from ||' AND ' || p_to;
      OPEN c FOR v_sql; 
        LOOP
        FETCH c INTO v_rec.count_, 
            v_rec.rownum_,
            v_rec.quote_id,
            v_rec.pack_pol_flag,
            v_rec.pack_quote_id,
            v_rec.quote_no,
            v_rec.incept_date,
            v_rec.expiry_date,
            v_rec.valid_date,
            v_rec.user_id,
            v_rec.accept_dt,
            v_rec.status,
            v_rec.reason_cd,
            v_rec.par_id,
            v_rec.par_no,
            v_rec.pol_no,
            v_rec.assd_no,
            v_rec.pack_quote_no,
            v_rec.assd_name,
            v_rec.par_assd,
            v_rec.reason_desc;
         EXIT WHEN c%NOTFOUND;
        PIPE ROW (v_rec);
      END LOOP;
      CLOSE c;
      RETURN;
      --ENDmodified  by MarkS 10.25.2016 SR5780 OPTIMIZATION
--------------------------------------------------------------
      -- Commented out by MarkS 10.25.2016 SR5780 OPTIMIZATION
--       FOR i IN
--         (
--            SELECT a.quote_id, a.pack_pol_flag, a.pack_quote_id,
--                      a.line_cd
--                   || '-'
--                   || a.subline_cd
--                   || '-'
--                   || a.iss_cd
--                   || '-'
--                   || a.quotation_yy
--                   || '-'
--                   || TO_CHAR (TRIM (a.quotation_no), '000009')
--                   || '-'
--                   || TO_CHAR (TRIM (a.proposal_no), '009') quote_no,
--                   --a.assd_name, modified by robert 01.14.2013
--                  TRUNC(a.incept_date) incept_date, TRUNC(a.expiry_date) expiry_date, TRUNC(a.valid_date) valid_date, a.user_id,
--                   --a.assd_no, modified by robert 01.14.2013 
--                   TRUNC(a.accept_dt) accept_dt, a.status, a.line_cd,
----                   cg_ref_codes_pkg.get_rv_meaning ('GIPI_QUOTE.STATUS',
----                                                    a.status
----                                                   ) status_mean --commented by MarkS 10.24.2016 SR5780
--                   (SELECT   UPPER (rv_meaning) rv_meaning
--                     FROM cg_ref_codes
--                    WHERE rv_domain = 'GIPI_QUOTE.STATUS'
--                      AND rv_low_value = a.status) status_mean, --added by MarkS 10.24.2016 SR5780
--                   a.reason_cd, p.par_id,
--                   DECODE(p.par_id, NULL, NULL, --added by reymon 02192013
--                      p.line_cd
--                   || '-'
--                   || p.iss_cd
--                   || '-'
--                   || TO_CHAR (p.par_yy, '09')
--                   || '-'
--                   || TO_CHAR (p.par_seq_no, '000009')
--                   || '-'
--                   || TO_CHAR (p.quote_seq_no, '09')) par_no,
--                   /* Commented out and changed by reymon 02192013
--                      z.line_cd
--                   || '-'
--                   || z.subline_cd
--                   || '-'
--                   || z.iss_cd
--                   || '-'
--                   || TO_CHAR (z.issue_yy, '09')
--                   || '-'
--                   || TO_CHAR (z.pol_seq_no, '000009')
--                   || '-'
--                   || TO_CHAR (z.renew_no, '09') */
--                   --added by MarkS 10.24.2016 SR5780
--                   (SELECT    line_cd
--                         || '-'
--                         || subline_cd
--                         || '-'
--                         || iss_cd
--                         || '-'
--                         || LTRIM (TO_CHAR (issue_yy, '09'))
--                         || '-'
--                         || LTRIM (TO_CHAR (pol_seq_no, '0999999'))
--                         || '-'
--                         || LTRIM (TO_CHAR (renew_no, '09'))
--                         || DECODE (
--                               NVL (endt_seq_no, 0),
--                               0, '',
--                                  ' / '
--                               || endt_iss_cd
--                               || '-'
--                               || LTRIM (TO_CHAR (endt_yy, '09'))
--                               || '-'
--                               || LTRIM (TO_CHAR (endt_seq_no, '0999999'))
--                            ) policy_no
--                    FROM gipi_polbasic
--                    WHERE policy_id = z.policy_id) pol_no, --added by MarkS 10.24.2016 SR5780
----                   get_policy_no(z.policy_id) pol_no, --commented by MarkS 10.24.2016 SR5780
--                   a.assd_no, NVL(v.assd_name, a.assd_name) assd_name,
--                   /* commented out and changed by reymon 02192013
--                   (   j.line_cd
--                    || '-'
--                    || j.subline_cd
--                    || '-'
--                    || j.iss_cd
--                    || '-'
--                    || j.quotation_yy
--                    || '-'
--                    || LTRIM (TO_CHAR (j.quotation_no, '099999'))
--                    || '-'
--                    || LTRIM (TO_CHAR (j.proposal_no, '099'))
--                   )*/
--                   (SELECT    p.line_cd
--                                 || '-'
--                                 || p.subline_cd
--                                 || '-'
--                                 || p.iss_cd
--                                 || '-'
--                                 || p.quotation_yy
--                                 || '-'
--                                 || TO_CHAR (p.quotation_no, '000009')
--                                 || '-'
--                                 || TO_CHAR (p.proposal_no, '009')
--                            FROM gipi_pack_quote p
--                           WHERE p.pack_quote_id = a.pack_quote_id) pack_quote_no,a.assd_name quote_assd_name,--added by MarkS 10.24.2016 SR5780
--                           DECODE(p.assd_no,a.assd_no,v.assd_no,null) par_assd_name --added by MarkS 10.24.2016 SR5780
--              FROM gipi_quote a,
--                   gipi_parlist p,
--                   gipi_polbasic z,
--                   giis_assured v--,
--                   --gipi_pack_quote j commented out by reymon 02192013
--             WHERE a.line_cd = p_line_cd  
--               -- modified by robert 01.14.2013
--               AND a.quote_id = p.quote_id(+)
--               AND a.assd_no = p.assd_no(+)
--               AND p.par_id = z.par_id(+)
--               AND a.assd_no = v.assd_no(+)
--               --AND a.pack_quote_id = j.pack_quote_id(+) commented out by reymon 02192013
--               AND a.subline_cd LIKE UPPER (NVL (p_subline_cd, a.subline_cd))
----               AND a.iss_cd in (SELECT b.iss_cd --added by steven 11.7.2012 so that user can only view the record if the iss_cd is present in the user access
----                                    FROM giis_users a ,giis_user_grp_line b
----                                    WHERE a.user_id = p_user_id2
----                                    AND b.line_cd = p_line_cd
----                                    AND a.user_grp = b.user_grp
----                                    AND b.tran_cd = 15)
--               AND EXISTS (SELECT 'X'
--                                 FROM TABLE (security_access.get_branch_line ('UW', 'GIIMM004', p_user_id2))
--                                WHERE branch_cd = a.iss_cd) 
----               AND a.iss_cd =
----                             DECODE (
----                                check_user_per_iss_cd2 (UPPER (a.line_cd),
----                                                       a.iss_cd,
----                                                       'GIIMM004', p_user_id2),
----                                1, a.iss_cd,
----                                NULL) --opti
--               AND a.iss_cd LIKE UPPER (NVL (p_iss_cd, a.iss_cd))
--               AND a.quotation_yy = NVL (p_quotation_yy, a.quotation_yy)
--               AND NVL (a.assd_name, '%%') LIKE
--                                               UPPER (NVL (p_assd_name, '%%'))
--               AND a.quotation_no = NVL (p_quotation_no, a.quotation_no)
--               AND a.proposal_no = NVL (p_proposal_no, a.proposal_no)
--               AND TRUNC (a.incept_date) =
--                      TRUNC (NVL (TO_DATE (p_incept_date, 'MM-DD-RRRR'),
--                                  TRUNC(a.incept_date)
--                                 )
--                            )
--               AND TRUNC (a.expiry_date) =
--                      TRUNC (NVL (TO_DATE (p_expiry_date, 'MM-DD-RRRR'),
--                                  TRUNC(a.expiry_date)
--                                 )
--                            )
--               AND TRUNC (a.accept_dt)
--                      BETWEEN TRUNC (NVL (TO_DATE (p_date_from, 'MM-DD-RRRR'),
--                                          TRUNC(a.accept_dt)
--                                         )
--                                    )
--                          AND TRUNC (NVL (TO_DATE (p_date_to, 'MM-DD-RRRR'),
--                                          TRUNC(a.accept_dt)
--                                         )
--                                    )
--               AND NVL (   a.line_cd
--                        || '-'
--                        || a.subline_cd
--                        || '-'
--                        || a.iss_cd
--                        || '-'
--                        || a.quotation_yy
--                        || '-'
--                        || TO_CHAR (TRIM (a.quotation_no), '000009')
--                        || '-'
--                        || TO_CHAR (TRIM (a.proposal_no), '009'),
--                        '%%'
--                       ) LIKE NVL (p_quote_no, '%%')
--               AND a.status =
--                      (DECODE (UPPER (p_status),
--                               'NOT SELECTED', 'X',
--                               'DENIED', 'D',
--                               'WITH PAR', 'W',
--                               'NEW', 'N',
--                               'POSTED POLICY', 'P',
--                               a.status
--                              )
--                      )
--               --AND a.user_id = NVL (p_user_id, a.user_id) changed by Kenneth L to allow filter using %
--               AND UPPER(a.user_id) LIKE UPPER(NVL (p_user_id, '%%'))
--          ORDER BY    a.line_cd
--                   || '-'
--                   || a.subline_cd
--                   || '-'
--                   || a.iss_cd
--                   || '-'
--                   || a.quotation_yy
--                   || '-'
--                   || TO_CHAR (a.quotation_no, '000009')
--                   || '-'
--                   || TO_CHAR (a.proposal_no, '009'),
--                   a.accept_dt DESC)
--      LOOP
--         v_quote.quote_id := i.quote_id;
--         v_quote.quote_no := i.quote_no;
--         --v_quote.assd_name := i.assd_name; --comment out by jeffdojello 10.22.2013
--         v_quote.incept_date := i.incept_date;
--         v_quote.expiry_date := i.expiry_date;
--         v_quote.valid_date := i.valid_date;
--         v_quote.user_id := i.user_id;
--         v_quote.assd_no := i.assd_no;
--         v_quote.accept_dt := i.accept_dt;
--         v_quote.status := i.status_mean;
--         v_quote.reason_cd := i.reason_cd;
--         v_quote.pack_quote_id  := i.pack_quote_id; --added by steven 11/6/2012
--         v_quote.par_id := null;    --added by steven 11/6/2012
--         v_quote.par_no := null;    --added by steven 11/6/2012
--         v_quote.pol_no := null;    --added by steven 11/6/2012
--         v_quote.assd_no := null;   --added by steven 11/6/2012
--         v_quote.par_assd := null;  --added by steven 11/6/2012
--         v_quote.pack_quote_no := null;
--         
--         -- robert 01.14.2013
--         v_quote.par_id := i.par_id;
--         v_quote.par_no := i.par_no;
--         v_quote.pol_no := i.pol_no;
--         v_quote.assd_no := i.assd_no;
--         --v_quote.par_assd := i.assd_name; --comment out by jeffdojello 10.22.2013
--         v_quote.pack_quote_no := i.pack_quote_no;
--         
--         --comment out
--         ---added by jeffdojello 10.22.2013---
--         ------------GENQA SR-707-------------
----         FOR j IN (SELECT a.assd_name --commented by MarkS 10.24.2016 SR5780
----                     FROM gipi_quote a
----                    WHERE a.quote_id = i.quote_id)
----         LOOP
----            v_quote.assd_name := j.assd_name;
----         END LOOP;
--         
--         v_quote.assd_name := i.quote_assd_name; --added by MarkS 10.24.2016 SR5780
--         v_quote.par_assd  := i.par_assd_name; --added by MarkS 10.24.2016 SR5780
----         FOR k IN (SELECT a.assd_name
----                     FROM giis_assured a,
----                          gipi_parlist b
----                    WHERE b.quote_id = i.quote_id
----                      AND a.assd_no = b.assd_no)
----         LOOP
----            v_quote.par_assd := k.assd_name;
----         END LOOP; --commented by MarkS 10.24.2016 SR5780
----         --------------------------------------
----                  

--         IF i.status = 'D'
--         THEN
--            IF v_quote.reason_cd IS NULL
--            THEN
--               v_quote.reason_desc := NULL;
--            ELSE
--               FOR v IN (SELECT reason_desc
--                           FROM giis_lost_bid
--                          WHERE reason_cd = v_quote.reason_cd
--                            AND line_cd = i.line_cd)
--               LOOP
--                  v_quote.reason_desc := v.reason_desc;
--               END LOOP;
--            END IF;
--         ELSE
--            v_quote.reason_desc := NULL;    
--         END IF;
--         
--        --commented out by robert 01.14.2013 
----         FOR v IN (SELECT p.par_id, p.line_cd, p.iss_cd, p.par_yy,
----                          p.par_seq_no, p.quote_seq_no
----                     FROM gipi_parlist p
----                    WHERE quote_id = v_quote.quote_id) --added by steven 11/6/2012
----         LOOP
----            v_quote.par_id := v.par_id;
----            v_quote.par_no :=
----                  v.line_cd
----               || '-'
----               || v.iss_cd
----               || '-'
----               || TO_CHAR (v.par_yy, '09')
----               || '-'
----               || TO_CHAR (v.par_seq_no, '000009')
----               || '-'
----               || TO_CHAR (v.quote_seq_no, '09');
----         END LOOP;

----         FOR z IN (SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no,
----                          renew_no
----                     FROM gipi_polbasic
----                    WHERE par_id = v_quote.par_id)
----         LOOP
----            v_quote.pol_no :=
----                  z.line_cd
----               || '-'
----               || z.subline_cd
----               || '-'
----               || z.iss_cd
----               || '-'
----               || TO_CHAR (z.issue_yy, '09')
----               || '-'
----               || TO_CHAR (z.pol_seq_no, '000009')
----               || '-'
----               || TO_CHAR (z.renew_no, '09');
----         END LOOP;

----         FOR v IN (SELECT a.assd_no, b.assd_name
----                     FROM gipi_parlist a, giis_assured b
----                    WHERE a.quote_id = v_quote.quote_id
----                      AND a.assd_no = b.assd_no)
----         LOOP
----            v_quote.assd_no := v.assd_no;
----            v_quote.par_assd := v.assd_name;
----         END LOOP;

----         FOR j IN (SELECT line_cd, subline_cd, iss_cd, quotation_yy,
----                          quotation_no, proposal_no
----                     FROM gipi_pack_quote
----                    WHERE pack_quote_id = v_quote.pack_quote_id)
----         LOOP
----            v_quote.pack_quote_no :=
----               (   j.line_cd
----                || '-'
----                || j.subline_cd
----                || '-'
----                || j.iss_cd
----                || '-'
----                || j.quotation_yy
----                || '-'
----                || LTRIM (TO_CHAR (j.quotation_no, '099999'))
----                || '-'
----                || LTRIM (TO_CHAR (j.proposal_no, '099'))
----               );
----         END LOOP;

--         PIPE ROW (v_quote);
--      END LOOP;
      -- end MarkS 10.25.2016 SR5780 OPTIMIZATION
   END;
   
   FUNCTION set_exist_msg (
      p_line_cd   VARCHAR2,
      p_assd_no   VARCHAR2,
      p_assd_name VARCHAR2,
      p_quote_id  VARCHAR2
   )
      RETURN VARCHAR2
   IS
      v_quote_cnt       NUMBER          := 0;
      v_par_cnt         NUMBER          := 0;
      v_pol_cnt         NUMBER          := 0;
      v_alert_msg_txt   VARCHAR2(1000)  := 'SUCCESS';
   BEGIN
      SELECT COUNT(*)
        INTO v_quote_cnt
        FROM gipi_quote
       WHERE quote_id <> p_quote_id
         AND line_cd = p_line_cd
         AND UPPER(TRIM(assd_name)) = UPPER(TRIM(p_assd_name));
       
      SELECT COUNT(*)
        INTO v_par_cnt
        FROM gipi_parlist 
       WHERE par_status NOT IN (98,99,10)
         AND line_cd = p_line_cd
         AND assd_no = p_assd_no;  

      SELECT COUNT(*)
        INTO v_pol_cnt
        FROM gipi_parlist 
       WHERE par_status = 10
         AND line_cd = p_line_cd 
         AND assd_no = p_assd_no;
         
      IF v_quote_cnt <> 0 AND    v_par_cnt <> 0 AND    v_pol_cnt <> 0  THEN     
         v_alert_msg_txt := 'Assured is already existing in other Quotation/s, PAR/s and Policies.';          
      ELSIF v_quote_cnt = 0 AND    v_par_cnt <> 0 AND    v_pol_cnt <> 0  THEN     
         v_alert_msg_txt := 'Assured is already existing in other PAR/s and Policies.';
      ELSIF v_quote_cnt <> 0 AND    v_par_cnt = 0 AND    v_pol_cnt <> 0  THEN     
         v_alert_msg_txt := 'Assured is already existing in other Quotation/s and Policies.';
      ELSIF v_quote_cnt <> 0 AND    v_par_cnt <> 0 AND    v_pol_cnt = 0  THEN     
         v_alert_msg_txt := 'Assured is already existing in other Quotation/s and PAR/s.';
      ELSIF v_quote_cnt = 0 AND    v_par_cnt = 0 AND    v_pol_cnt <> 0  THEN     
         v_alert_msg_txt := 'Assured is already existing in Policy records.';
      ELSIF v_quote_cnt = 0 AND    v_par_cnt <> 0 AND    v_pol_cnt = 0  THEN
         v_alert_msg_txt := 'Assured is already existing in PAR records.';
      ELSIF v_quote_cnt <> 0 AND    v_par_cnt = 0 AND    v_pol_cnt = 0  THEN     
         v_alert_msg_txt := 'Assured is already existing in another Quotation.';              
      END IF;
                                                                                               
      RETURN(v_alert_msg_txt);
   END set_exist_msg;   
   
   PROCEDURE delete_quotation2 (p_quote_id IN gipi_quote.quote_id%TYPE)
   IS
   BEGIN
         UPDATE gipi_quote
         SET status = 'L',
             last_update = sysdate,
             user_id = NVL(giis_users_pkg.app_user,USER)
       WHERE quote_id = p_quote_id;
       
       -- SR-21674 JET JAN-31-2017
       DELETE -- attachments
         FROM gipi_quote_pictures
        WHERE quote_id = p_quote_id;
   END delete_quotation2;  
   
END gipi_quote_pkg;
/
