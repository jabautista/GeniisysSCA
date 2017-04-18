CREATE OR REPLACE PACKAGE BODY CPI.GIACS121_PKG
AS

    FUNCTION get_last_extract(
        p_user_id   giis_users.user_id%TYPE
    )
        RETURN last_extract_tab PIPELINED
    IS
        v_last  last_extract_type;
    BEGIN
        FOR c IN (SELECT from_date, to_date, cut_off_date
                    FROM giac_ri_stmt_ext 
                   WHERE user_id = p_user_id)
        LOOP
            v_last.from_date    := c.from_date;
            v_last.to_date      := c.to_date;
            v_last.cut_off_date := c.cut_off_date;
            PIPE ROW(v_last);
        EXIT;
        END LOOP;
    END get_last_extract;
    
   /*
   **  Created by   :  Maria Gzelle Ison
   **  Date Created : 07.22.2013
   **  Reference By : GIACS121
   **  Remarks      : line list of values
   */
    FUNCTION get_soa_facul_ri_line(
        p_ri_cd     giac_aging_ri_soa_details.a180_ri_cd%TYPE,
        p_user_id   giis_users.user_id%TYPE
    )
        RETURN soa_facul_ri_lov_tab PIPELINED
    IS
        v_line   soa_facul_ri_lov_type;
    BEGIN
        FOR q IN (SELECT DISTINCT d.a150_line_cd line_code, f.line_name 
                    FROM giac_aging_ri_soa_details d, giis_line f 
                   WHERE d.a180_ri_cd= decode(p_ri_cd, null, d.a180_ri_cd, p_ri_cd) 
--                     AND check_user_per_line2(line_cd, null, 'GIACS121', p_user_id) = 1 commented out by gab 10.15.2015
                     AND d.a150_line_cd = f.line_cd 
                ORDER BY f.line_name )
        LOOP
            v_line.line_cd     := q.line_code;
            v_line.line_name   := q.line_name;
            PIPE ROW(v_line);
        END LOOP;
    END get_soa_facul_ri_line;

    FUNCTION get_soa_facul_ri_lov
        RETURN soa_facul_ri_lov_tab PIPELINED
    IS
        v_ri   soa_facul_ri_lov_type;
    BEGIN
        FOR q IN (SELECT DISTINCT d.a180_ri_cd, e.ri_name 
                    FROM giac_aging_ri_soa_details d, giis_reinsurer e 
                   WHERE d.a180_ri_cd = e.ri_cd 
                ORDER BY e.ri_name)
        LOOP
            v_ri.ri_cd     := q.a180_ri_cd;
            v_ri.ri_name   := q.ri_name;
            PIPE ROW(v_ri);
        END LOOP;
    END get_soa_facul_ri_lov;        

    PROCEDURE delete_soa_facul_ri(
        p_user_id            giis_users.user_id%TYPE    
    )
    AS
    BEGIN
        DELETE FROM giac_ri_stmt_ext 
         WHERE user_id = p_user_id;
    END delete_soa_facul_ri;

   /*
   **  Created by   :  Maria Gzelle Ison
   **  Date Created : 07.22.2013
   **  Reference By : GIACS121
   **  Remarks      : extract program unit (**added NVL to booking month and booking year 
   **                 - causes invalid month error when records does not have booking mnth and year in gipi_invoice)
   */
    PROCEDURE extract_soa_facul_ri(
        p_date_tag      VARCHAR2,
        p_curr_tag      VARCHAR2,
        p_from_date     VARCHAR2,
        p_to_date       VARCHAR2,
        p_cut_off_date  VARCHAR2,
        p_line_cd       giis_line.line_cd%TYPE,
        p_ri_cd         giac_aging_ri_soa_details.a180_ri_cd%TYPE,
        p_user_id       giis_users.user_id%TYPE,
        p_msg     OUT   VARCHAR2  
    )
    AS  
        v_gross_prem_amt    giac_aging_ri_soa_details.prem_balance_due%type;
        v_inst_no           giac_ri_stmt_ext.inst_no%type;
        v_iss_cd            giac_ri_stmt_ext.iss_cd%type;
        v_prem_seq_no       giac_ri_stmt_ext.prem_seq_no%type;
        v_assd_no           giac_ri_stmt_ext.assd_no%type;
        v_assd_name         VARCHAR2(500);
        v_prem_amt          giac_inwfacul_prem_collns.premium_amt%type;
        row_counter         NUMBER:=0;
        v_branch_cd         giac_ri_stmt_ext.branch_cd%type;
        v_fund_cd           giac_ri_stmt_ext.fund_cd%type; 
        v_tax_amt           giac_aging_ri_soa_details.tax_amount%type;
        v_comm_amt          giac_aging_ri_soa_details.comm_balance_due%type;
        v_amt_insured       giac_ri_stmt_ext.amt_insured%type;
        v_due_date          giac_ri_stmt_ext.invoice_date%type;
        v_comm_inwfacul     giac_inwfacul_prem_collns.comm_amt%type;
        v_aging_id          giac_aging_parameters.aging_id%type;
        v_days              NUMBER;
        v_over_due_tag      VARCHAR2(1);
        v_column_no         giac_ri_stmt_ext.column_no%type;
        v_after_prem        giac_ri_stmt_ext.after_date_prem%TYPE;  
        v_after_comm        giac_ri_stmt_ext.after_date_comm%TYPE;  
        v_after_comm_vat    giac_ri_stmt_ext.after_date_comm_vat%TYPE; 
        v_date_tag          giac_ri_stmt_ext.date_tag%type;    
        v_ext_count         NUMBER; 
        v_prem_vat          giac_ri_stmt_ext.prem_vat%type;   
        v_comm_vat          giac_ri_stmt_ext.comm_vat%type;   
        v_comm_vat_inwfacul giac_inwfacul_prem_collns.comm_vat%type; 
        v_prem_vat_inwfacul giac_inwfacul_prem_collns.tax_amount%type;
        v_curr_cd           giac_ri_stmt_ext.currency_cd%type; 
        v_curr_rt           giac_ri_stmt_ext.currency_rt%type; 
        v_from_date         DATE;
        v_to_date           DATE;
        v_cut_off_date      DATE;        

    BEGIN
    /***********for acct_ent_date as booking_date**************************/
        v_from_date         := TO_DATE(p_from_date,'MM/DD/YYYY');
        v_to_date           := TO_DATE(p_to_date,'MM/DD/YYYY');
        v_cut_off_date      := TO_DATE(p_cut_off_date,'MM/DD/YYYY');
        
        IF p_date_tag = 'AC' THEN
            v_date_tag := 'AC';
        ELSIF p_date_tag = 'BK' THEN
            v_date_tag := 'BK';      
        ELSIF p_date_tag = 'IN' THEN
            v_date_tag := 'IN';
        END IF;              

        BEGIN
            SELECT PARAM_VALUE_V
              INTO V_BRANCH_CD
              FROM GIAC_PARAMETERS
             WHERE PARAM_NAME = 'BRANCH_CD';
                
            SELECT PARAM_VALUE_V
              INTO V_FUND_CD
              FROM GIAC_PARAMETERS
             WHERE PARAM_NAME = 'FUND_CD';
        END;

        FOR c1 IN (SELECT a.policy_id, DECODE( a.endt_seq_no, 0,
                                               SUBSTR(a.line_cd ||'-'|| a.subline_cd||'-'|| a.iss_cd||'-'|| LTRIM(TO_CHAR(a.issue_yy, '09'))
                                               ||'-'|| LTRIM(TO_CHAR(a.pol_seq_no, '0000009'))||'-'|| TO_CHAR(a.renew_no), 1,37),
                                               SUBSTR(a.line_cd ||'-'|| a.subline_cd||'-'|| a.ISS_CD||'-'|| TO_CHAR(a.issue_yy)
                                               ||'-'|| TO_CHAR(a.pol_seq_no) ||'-'|| TO_CHAR(a.renew_no)||'-'|| a.endt_iss_cd
                                               ||'-'|| TO_CHAR(a.endt_yy) ||'-'||TO_CHAR(a.endt_seq_no), 1,37)) policy_no,
                          DECODE(p_date_tag,
                                    'AC',nvl(i.acct_ent_date, a.acct_ent_date), 
                                    'BK',LAST_DAY(TO_DATE(i.multi_booking_mm||', '||TO_CHAR(i.multi_booking_yy),'FMMonth, YYYY')),
                                    'IN',a.incept_date) booking_date,
                          a.spld_date, a.assd_no, e.assd_name, a.line_cd, d.ri_cd, f.ri_name, a.iss_cd, a.acct_ent_date, f.bill_address1 ||' '|| f.bill_address2 ||' '|| f.bill_address3 bill_address, 
                          h.line_name line_name, a.incept_date, d.ri_policy_no, d.ri_binder_no, a.pol_flag
                     FROM gipi_polbasic a,
                          giri_inpolbas d,
                          giis_assured e,
                          giis_reinsurer f,
                          gipi_parlist g,
                          giis_line h,
                          gipi_invoice i  
                    WHERE DECODE(p_date_tag,
                                    'AC',TRUNC(nvl(i.acct_ent_date, a.acct_ent_date)),
                                    'BK',LAST_DAY(TO_DATE(NVL(i.multi_booking_mm,a.booking_mth)|| ', ' ||TO_CHAR(NVL(i.multi_booking_yy,a.booking_year)),'FMMonth, YYYY')),
                                    'IN',TRUNC(a.incept_date)) 
                          BETWEEN DECODE(p_date_tag,'BK',LAST_DAY(v_from_date),v_from_date) 
                      AND DECODE(p_date_tag,'BK',LAST_DAY(v_to_date),v_to_date)                              
                      AND a.par_id = g.par_id
                      AND a.assd_no = e.assd_no
                      AND d.policy_id = a.policy_id
                      AND d.ri_cd = f.ri_cd
                      AND a.line_cd = h.line_cd
                      AND a.policy_id = i.policy_id
                      AND d.ri_cd = NVL(p_ri_cd,d.ri_cd)
                      AND a.line_cd = NVL(p_line_cd,a.line_cd)
--                      AND check_user_per_line2(NVL(p_line_cd,a.line_cd), a.iss_cd, 'GIACS121', p_user_id) = 1     --commented out by gab 10.1.2015
--                      AND check_user_per_iss_cd_acctg2(p_line_cd, a.iss_cd, 'GIACS121', p_user_id) = 1
                      AND a.iss_cd IN (SELECT branch_cd FROM TABLE(security_access.get_branch_line ('AC','GIACS121',p_user_id)))-- added by gab 10.1.2015
                      AND a.reg_policy_sw = 'Y')
        LOOP
            IF (c1.spld_date is NULL) OR ((trunc(c1.spld_date) > v_cut_off_date AND c1.spld_date IS NOT NULL)AND c1.pol_flag = 5) THEN
            row_counter := row_counter + 1;

                FOR c2 IN (SELECT iss_cd, prem_seq_no,currency_rt, currency_cd  
                             FROM gipi_invoice 
                            WHERE policy_id = c1.policy_id
                              AND iss_cd = c1.iss_cd ) 
                LOOP
                    IF p_curr_tag = 'Y' THEN
                        v_curr_cd := c2.currency_cd; 
                        v_curr_rt := c2.currency_rt;      
                    END IF;
                    
                    FOR c3 IN (SELECT due_date, inst_no
                                 FROM gipi_installment
                                WHERE iss_cd = c2.iss_cd
                                  AND prem_seq_no = c2.prem_seq_no
                             ORDER BY inst_no) 
                    LOOP
                        v_inst_no        := c3.inst_no;
                        v_iss_cd         := c2.iss_cd;
                        v_prem_seq_no    := c2.prem_seq_no;
                        v_gross_prem_amt := 0;
                        v_due_date       := c3.due_date;

                        FOR soa IN (SELECT NVL(prem_balance_due,0)gross_prem_amt, NVL(comm_balance_due - wholding_tax_bal,0) comm_amt,
                                           NVL(tax_amount,0) prem_vat, NVL(comm_vat,0) comm_vat
                                      FROM giac_aging_ri_soa_details
                                     WHERE a180_ri_cd = c1.ri_cd
                                       AND prem_seq_no = c2.prem_seq_no
                                       AND inst_no  = c3.inst_no
                                       AND a150_line_cd  = c1.line_cd
                                       AND a020_assd_no = c1.assd_no)
                        LOOP
                            v_gross_prem_amt := soa.gross_prem_amt;
                            v_comm_amt := soa.comm_amt;
                            v_prem_vat := soa.prem_vat;
                            v_comm_vat := soa.comm_vat;
                            v_prem_amt := 0;
               
                            FOR col IN (SELECT SUM(NVL(premium_amt,0)) prem, SUM(NVL(tax_amount,0)) tax_amount,      
                                               SUM(NVL(comm_amt,0) - NVL(wholding_tax,0)) comm,NVL(comm_vat,0) comm_vat
                                          FROM giac_inwfacul_prem_collns a,
                                               giac_acctrans  b
                                         WHERE a.A180_ri_cd = c1.ri_cd
                                           AND a.gacc_tran_id = b.tran_id
                                           AND a.b140_iss_cd = v_iss_cd 
                                           AND a.b140_prem_seq_no = v_prem_seq_no 
                                           AND a.inst_no = v_inst_no 
                                           AND a.gacc_tran_id NOT IN (SELECT c.gacc_tran_id
                                                                        FROM giac_reversals c, giac_acctrans d
                                                                       WHERE c.reversing_tran_id = d.tran_id
                                                                         AND d.tran_flag <> 'D')
                                           AND b.tran_flag != 'D'
                                           AND TRUNC(b.tran_date) > v_cut_off_date--p_cut_off_date  Gzelle 12.5.2013
                                      GROUP BY a.inst_no,nvl(comm_vat,0))
                            LOOP   
                                v_prem_amt := col.prem;
                                v_comm_inwfacul := col.comm; 
                                v_comm_vat_inwfacul := col.comm_vat;
                                v_prem_vat_inwfacul := col.tax_amount; 
                                v_gross_prem_amt := nvl(v_gross_prem_amt,0) +  nvl(v_prem_amt,0);                
                                v_comm_amt := nvl(v_comm_amt,0) + nvl(v_comm_inwfacul,0);  
                                v_comm_vat := nvl(v_comm_vat,0) + nvl(v_comm_vat_inwfacul,0);
                                v_prem_vat := nvl(v_prem_vat, 0 ) + nvl(v_prem_vat_inwfacul, 0 ); 
                                     
                            
                                FOR ad IN (SELECT sum(nvl(premium_amt,0) + nvl(tax_amount,0)) a_prem, sum(nvl(comm_amt,0) - nvl(wholding_tax,0)) a_comm, sum(nvl(comm_vat,0)) a_comm_vat
                                             FROM giac_inwfacul_prem_collns a,
                                                  giac_acctrans  b
                                            WHERE a.A180_ri_cd = c1.ri_cd
                                              AND a.gacc_tran_id = b.tran_id
                                              AND a.b140_iss_cd = v_iss_cd 
                                              AND a.b140_prem_seq_no = v_prem_seq_no 
                                              AND a.inst_no   = v_inst_no 
                                              AND a.gacc_tran_id NOT IN (SELECT c.gacc_tran_id
                                                                           FROM giac_reversals c, giac_acctrans d
                                                                          WHERE c.reversing_tran_id = d.tran_id
                                                                            AND d.tran_flag <> 'D' )
                                              AND b.tran_flag != 'D'
                                              AND TRUNC(b.tran_date) > v_cut_off_date
                                              AND TRUNC(b.tran_date) <=  SYSDATE
                                         GROUP BY a.inst_no)
                                LOOP      
                                    v_after_prem := ad.a_prem;
                                    v_after_comm := ad.a_comm;
                                    v_after_comm_vat := ad.a_comm_vat;
                                END LOOP;
                            END LOOP;  -- col
                        END LOOP;   -- soa
                    
                        IF p_curr_tag = 'Y' THEN 
                            FOR tsi IN (SELECT SUM(a.tsi_amt)amt_insured
                                          FROM gipi_item a, gipi_invoice b
                                         WHERE a.policy_id = b.policy_id
                                           AND a.policy_id = c1.policy_id
                                           AND a.item_grp = b.item_grp)
                            LOOP              
                                v_amt_insured := tsi.amt_insured;
                            END LOOP;
                        ELSE
                            FOR tsi IN (SELECT SUM(a.tsi_amt * b.currency_rt)amt_insured
                                          FROM gipi_item a, gipi_invoice b
                                         WHERE a.policy_id = b.policy_id
                                           AND a.policy_id = c1.policy_id
                                           AND a.item_grp = b.item_grp)
                            LOOP              
                                v_amt_insured := tsi.amt_insured;
                            END LOOP;
                        END IF; 
                        
                        IF c1.spld_date IS NOT NULL THEN          
                            IF trunc(c1.spld_date) > v_cut_off_date  THEN 
                                IF p_curr_tag = 'Y' THEN
                                    FOR sp IN (SELECT (NVL(prem_amt,0) + NVL(other_charges,0) + NVL(notarial_fee,0)) balance, NVL(tax_amt,0) tax_amt, 
                                                       NVL(ri_comm_amt,0) commission, NVL(comm_vat,0) comm_vat, NVL(currency_cd,0) curr_cd, NVL(currency_rt,0) curr_rt
                                                  FROM gipi_invoice a, giac_aging_ri_soa_details b
                                                 WHERE a.policy_id = c1.policy_id
                                                   AND a.prem_seq_no = b.prem_seq_no)
                                    LOOP                   
                                        v_gross_prem_amt := sp.balance;
                                        v_comm_amt := sp.commission;         
                                        v_prem_vat := sp.tax_amt;
                                        v_comm_vat := sp.comm_vat;     
                                        v_curr_cd  := sp.curr_cd;
                                        v_curr_rt  := sp.curr_rt;     
                                    END LOOP;
                                ELSE
                                    FOR sp IN (SELECT (NVL(prem_amt,0) + NVL(other_charges,0) + NVL(notarial_fee,0)) * NVL(currency_rt,1) balance,                           
                                                      NVL(tax_amt,0) * NVL(currency_rt,1) tax_amt, NVL(ri_comm_amt,0) * NVL(currency_rt,1) commission, 
                                                      NVL(comm_vat,0) * NVL(currency_rt,1) comm_vat
                                                 FROM gipi_invoice a, giac_aging_ri_soa_details b
                                                WHERE a.policy_id = c1.policy_id
                                                  AND a.prem_seq_no = b.prem_seq_no)
                                    LOOP                   
                                        v_gross_prem_amt := sp.balance;
                                        v_comm_amt := sp.commission;         
                                        v_prem_vat := sp.tax_amt;
                                        v_comm_vat := sp.comm_vat;          
                                    END LOOP;
                                END IF;
                            END IF;
                        END IF;
                    
                        BEGIN
                            v_days := (TRUNC(v_cut_off_date) - TRUNC(v_due_date));
                            v_aging_id := 0;
                            IF v_days > 0 THEN
                                v_over_due_tag := 'Y';
                            ELSE
                                v_over_due_tag := 'N';
                            END IF;
                            
                            SELECT aging_id, column_no 
                              INTO v_aging_id, v_column_no 
                              FROM giac_aging_parameters
                             WHERE gibr_gfun_fund_cd = v_fund_cd 
                              AND gibr_branch_cd = v_branch_cd
                              AND min_no_days <= ABS(v_days)
                              AND max_no_days >= ABS(v_days)
                              AND over_due_tag = v_over_due_tag;
                            EXCEPTION
                            WHEN NO_DATA_FOUND THEN
                                p_msg := 'Please check values in GIAC_AGING_PARAMETERS';
                        END;

                        IF (v_gross_prem_amt - (v_comm_amt+ v_comm_vat))  <> 0 THEN            
                            IF p_curr_tag = 'Y' THEN
                                INSERT INTO GIAC_RI_STMT_EXT
                                            (fund_cd             , branch_cd              , ri_cd              , ri_name        , assd_no       , assd_name       ,
                                             aging_id            , iss_cd                 , prem_seq_no        , inst_no        , policy_id     , policy_no       ,
                                             amt_insured         , gross_prem_amt         , ri_comm_exp        , from_date      , to_date       , cut_off_date    , 
                                             booking_date        , invoice_date           , bill_address       , line_name      , incept_date   , line_cd         , 
                                             ri_policy_no        , ri_binder_no           , user_id            , column_no      , due_date      , acct_ent_date   , 
                                             extract_date        , after_date_prem        , after_date_comm    , date_tag       , prem_vat      , comm_vat        , 
                                             currency_cd         , currency_rt)
                                     VALUES (v_fund_cd           , v_branch_cd            , c1.ri_cd           , c1.ri_name     , c1.assd_no    , c1.assd_name    , 
                                             v_aging_id          , v_iss_cd               , v_prem_seq_no      , v_inst_no      , c1.policy_id  , c1.policy_no    ,
                                             NVL(v_amt_insured,0), NVL(v_gross_prem_amt,0), NVL(v_comm_amt,0)  , v_from_date    , v_to_date     , v_cut_off_date  , 
                                             c1.booking_date     , v_due_date             , c1.bill_address    , c1.line_name   , c1.incept_date, c1.line_cd      ,  
                                             c1.ri_policy_no     , c1.ri_binder_no        , p_user_id          , v_column_no    , v_due_date    , c1.acct_ent_date, 
                                             SYSDATE             , NVL(v_after_prem,0)    , NVL(v_after_comm,0), v_date_tag     , v_prem_vat    , v_comm_vat      , 
                                             v_curr_cd           , v_curr_rt);
                            ELSE
                                INSERT INTO GIAC_RI_STMT_EXT
                                            (fund_cd             , branch_cd              , ri_cd              , ri_name                , assd_no       , assd_name       ,  
                                             aging_id            , iss_cd                 , prem_seq_no        , inst_no                , policy_id     , policy_no       , 
                                             amt_insured         , gross_prem_amt         , ri_comm_exp        , from_date              , to_date       , cut_off_date    ,   
                                             booking_date        , invoice_date           , bill_address       , line_name              , incept_date   , line_cd         , 
                                             ri_policy_no        , ri_binder_no           , user_id            , column_no              , due_date      , acct_ent_date   ,
                                             extract_date        , after_date_prem        , after_date_comm    , after_date_comm_vat    , date_tag      , prem_vat        ,
                                             comm_vat)
                                     VALUES (v_fund_cd           , v_branch_cd            , c1.ri_cd           , c1.ri_name             , c1.assd_no    , c1.assd_name    ,
                                             v_aging_id          , v_iss_cd               , v_prem_seq_no      , v_inst_no              , c1.policy_id  , c1.policy_no    ,
                                             NVL(v_amt_insured,0), NVL(v_gross_prem_amt,0), NVL(v_comm_amt,0)  , v_from_date            , v_to_date     , v_cut_off_date  , 
                                             c1.booking_date     , v_due_date             , c1.bill_address    , c1.line_name           , c1.incept_date, c1.line_cd      ,  
                                             c1.ri_policy_no     , c1.ri_binder_no        , p_user_id          , v_column_no            , v_due_date    , c1.acct_ent_date,
                                             SYSDATE             , NVL(v_after_prem,0)    , NVL(v_after_comm,0), NVL(v_after_comm_vat,0), v_date_tag    , v_prem_vat      ,
                                             v_comm_vat);
                            END IF; 
                        END IF;
                    END LOOP;--C3
                EXIT;
                END LOOP;--C2
             END IF;
        END LOOP;--C1
  
        SELECT COUNT(*) 
          INTO v_ext_count
          FROM giac_ri_stmt_ext
         WHERE from_date = v_from_date
         AND to_date = v_to_date
         AND cut_off_date = v_cut_off_date
         AND user_id = p_user_id;
        IF v_ext_count = 0 THEN
            p_msg := 'Extraction finished. No records extracted.';        
        ELSE   
            p_msg := 'Extraction finished. '||v_ext_count||' records extracted.';
        END IF;
    END extract_soa_facul_ri;               
END GIACS121_PKG;
/


