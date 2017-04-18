CREATE OR REPLACE PACKAGE BODY CPI.GIACS180_PKG
AS
    /*
    **  Created by   :  Marie Kris Felipe
    **  Date Created :  04.30.2013
    **  Reference By : (GIACS180 - Statement of Account)
    **  Description  : To get the extract_aging_days (mod1), then save it to the corresponding variable (mod2 and 3) --modified '&' by 'and' to prevent script from requesting a value for parameter by MAC 11/06/2013
    **                      then save the queried extract_aging_days to the parameter p_extract_days (mod4)
    **                 Executes set_default_dates procedure
    */
    FUNCTION get_default_dates(
        p_user_id       giis_users.user_id%TYPE        
    ) RETURN soa_params_tab PIPELINED IS
        CURSOR c1 IS
            SELECT rep_date, param_date, as_of_date, from_date1,
                   to_date1, from_date2, to_date2, date_tag,
                   branch_cd, intm_no, intm_type, assd_no,
                   branch_param,
                   inc_special_pol special_pol,
                   extract_aging_days extract_days, --mod1 start/end
                   payt_date
              FROM giac_soa_rep_ext_param
             WHERE user_id = p_user_id;
             
            v_rep_date     giac_soa_rep_ext_param.rep_date%TYPE;
            v_cut_off_date giac_soa_rep_ext_param.param_date%TYPE;
            v_as_of_date   giac_soa_rep_ext_param.as_of_date%TYPE;
            v_from_date1   giac_soa_rep_ext_param.from_date1%TYPE;
            v_to_date1     giac_soa_rep_ext_param.to_date1%TYPE;
            v_from_date2   giac_soa_rep_ext_param.from_date2%TYPE;
            v_to_date2     giac_soa_rep_ext_param.to_date2%TYPE;
            v_date_tag     giac_soa_rep_ext_param.date_tag%TYPE;
            v_branch_cd      giac_soa_rep_ext_param.branch_cd%TYPE;
            v_intm_no        giac_soa_rep_ext_param.intm_no%TYPE;
            v_intm_type      giac_soa_rep_ext_param.intm_type%TYPE;
            v_assd_no        giac_soa_rep_ext_param.assd_no%TYPE;
            v_special_pol    giac_soa_rep_ext_param.inc_special_pol%TYPE;
            v_extract_days    giac_soa_rep_ext_param.extract_aging_days%TYPE;    --mod2 start/end
            v_payt_date         giac_soa_rep_ext_param.PAYT_DATE%TYPE; -- shan 02.27.2015
            
            v_old_data     VARCHAR2(2);
            
            v_params        soa_params_type;
    BEGIN
    
        FOR c1_rec IN c1
        LOOP
            v_rep_date     := c1_rec.rep_date;
            v_cut_off_date := c1_rec.param_date;
            v_as_of_date   := c1_rec.as_of_date;
            v_from_date1   := TO_DATE(TO_CHAR(c1_rec.from_date1, 'mm-dd-yyyy'), 'mm-dd-yyyy');
            v_to_date1     := TO_DATE(TO_CHAR(c1_rec.to_date1, 'mm-dd-yyyy'), 'mm-dd-yyyy');
            v_from_date2   := TO_DATE(TO_CHAR(c1_rec.from_date2, 'mm-dd-yyyy'), 'mm-dd-yyyy');
            v_to_date2     := TO_DATE(TO_CHAR(c1_rec.to_date2, 'mm-dd-yyyy'), 'mm-dd-yyyy');
            v_date_tag     := c1_rec.date_tag;
            v_branch_cd    := c1_rec.branch_cd;
            v_intm_no      := c1_rec.intm_no;
            v_intm_type    := c1_rec.intm_type;
            v_assd_no      := c1_rec.assd_no;
            v_special_pol  := c1_rec.special_pol;
            v_extract_days := c1_rec.extract_days;    --mod3 start/end
            v_payt_date     := c1_rec.payt_date;
        --END LOOP;
        
            /*pass the values to the parameters with respect to the tag*/
            v_params.branch_param      := c1_rec.branch_param;
            v_params.rep_date       := v_rep_date;
            v_params.cut_off        := v_cut_off_date;
            v_params.date_as_of     := v_as_of_date;
            v_params.dsp_cut_off        := TO_CHAR(v_cut_off_date, 'mm-dd-yyyy'); --added by gab 10.13.2016 SR 4016
            v_params.dsp_date_as_of     := TO_CHAR(v_as_of_date, 'mm-dd-yyyy');    --added by gab 10.13.2016 SR 4016
            v_params.date_tag       := v_date_tag;
            v_params.intm_no          := v_intm_no;
            v_params.intm_type        := v_intm_type;
            v_params.assd_no          := v_assd_no;
            v_params.special_pol      := v_special_pol;
            v_params.extract_days      := v_extract_days;        --mod4 start/end
            v_params.branch_cd        := v_branch_cd;
            v_params.payt_date      := v_payt_date;
               
            v_params.book_tag  := 'N';
            v_params.incep_tag := 'N';
            v_params.issue_tag := 'N';
            
            IF v_date_tag = 'BK' THEN
                v_params.book_tag  := 'Y';
            ELSIF v_date_tag = 'IS' THEN
                v_params.issue_tag := 'Y';
            ELSIF v_date_tag = 'IN' THEN
                v_params.incep_tag := 'Y';
            ELSIF v_date_tag = 'BKIS' THEN
                v_params.book_tag  := 'Y';
                v_params.issue_tag := 'Y';
            ELSIF v_date_tag = 'BKIN' THEN
                v_params.book_tag  := 'Y';
                v_params.incep_tag := 'Y';
            END IF;
            
--            modified by gab 10.14.2016 SR 4016
            IF v_rep_date = 'F' THEN
                IF v_date_tag = 'BK' THEN
                    v_params.book_date_fr := v_from_date1;
                    v_params.book_date_to := v_to_date1;
                    v_params.dsp_book_date_fr := TO_CHAR(v_from_date1, 'mm-dd-yyyy');
                    v_params.dsp_book_date_to := TO_CHAR(v_to_date1, 'mm-dd-yyyy');
                ELSIF v_date_tag = 'IS' THEN
                    v_params.issue_date_fr := v_from_date1;
                    v_params.issue_date_to := v_to_date1;
                    v_params.dsp_issue_date_fr := TO_CHAR(v_from_date1, 'mm-dd-yyyy');
                    v_params.dsp_issue_date_to := TO_CHAR(v_to_date1, 'mm-dd-yyyy');
                ELSIF v_date_tag = 'IN' THEN
                    v_params.incep_date_fr := v_from_date1;
                    v_params.incep_date_to := v_to_date1;
                    v_params.dsp_incep_date_fr := TO_CHAR(v_from_date1, 'mm-dd-yyyy');
                    v_params.dsp_incep_date_to := TO_CHAR(v_to_date1, 'mm-dd-yyyy');
                ELSIF v_date_tag = 'BKIS' THEN
                    v_params.book_date_fr := v_from_date1;
                    v_params.book_date_to := v_to_date1;
                    v_params.issue_date_fr := v_from_date2;
                    v_params.issue_date_to := v_to_date2;
                    v_params.dsp_book_date_fr := TO_CHAR(v_from_date1, 'mm-dd-yyyy');
                    v_params.dsp_book_date_to := TO_CHAR(v_to_date1, 'mm-dd-yyyy');
                    v_params.dsp_issue_date_fr := TO_CHAR(v_from_date2, 'mm-dd-yyyy');
                    v_params.dsp_issue_date_to := TO_CHAR(v_to_date2, 'mm-dd-yyyy');
                ELSIF v_date_tag = 'BKIN' THEN
                    v_params.book_date_fr := v_from_date1;
                    v_params.book_date_to := v_to_date1;
                    v_params.incep_date_fr := v_from_date2;
                    v_params.incep_date_to := v_to_date2;
                    v_params.dsp_book_date_fr := TO_CHAR(v_from_date1, 'mm-dd-yyyy');
                    v_params.dsp_book_date_to := TO_CHAR(v_to_date1, 'mm-dd-yyyy');
                    v_params.dsp_incep_date_fr := TO_CHAR(v_from_date2, 'mm-dd-yyyy');
                    v_params.dsp_incep_date_to := TO_CHAR(v_to_date2, 'mm-dd-yyyy');
                ELSE
                    /*check if the user has extracted data but without the date parameters*/
                    FOR k IN(SELECT 'X' OLD
                         FROM giac_soa_rep_ext
                         WHERE user_id = p_user_id
                         AND ROWNUM = 1) 
                    LOOP
                        v_old_data :=  k.OLD;
                        EXIT;
                    END LOOP;
                    
                    IF v_old_data IS NULL THEN
                      --message('You have not extracted any values yet.');
                      v_params.message := 'You have not extracted any values yet';
                    ELSE
                      NULL;
                    END IF;
                END IF;      
                -- continuation in jsp.
            --ELSE  -- do else in jsp.
            END IF;
            
            IF v_branch_cd IS NOT NULL THEN
                FOR i IN (SELECT iss_name
                            FROM TABLE(GIIS_ISSOURCE_PKG.get_giacs180_iss_lov(p_user_id, 'GIACS180'))
                           WHERE iss_cd = v_branch_Cd)
                LOOP
                    v_params.branch_name := i.iss_name;
                END LOOP;
            END IF;
            
            IF v_intm_no IS NOT NULL THEN
                FOR i IN(SELECT intm_name 
                           FROM TABLE(GIIS_INTERMEDIARY_PKG.get_giacs180_intm_lov(v_intm_type))
                          WHERE intm_no = v_intm_no)
                LOOP
                    v_params.intm_name := i.intm_name;
                END LOOP;
            END IF;
            
            IF v_intm_type IS NOT NULL THEN
                FOR i IN(SELECT intm_desc 
                           FROM TABLE(GIIS_INTM_TYPE_PKG.get_intm_type_listing) 
                          WHERE intm_type = v_intm_type)
                LOOP
                    v_params.intm_type_desc := i.intm_desc;
                    EXIT;
                END LOOP;
            END IF;
            
            IF v_assd_no IS NOT NULL THEN
--                FOR i IN(SELECT assd_name 
--                           FROM TABLE(giis_assured_pkg.get_assd_name(v_assd_no)))
--                LOOP
                    v_params.assd_name := giis_assured_pkg.get_assd_name(v_assd_no);
--                END LOOP;
            END IF;

            PIPE ROW(v_params);
        END LOOP;
    END get_default_dates;
    
    
    /*
    **  Created by   :  Marie Kris Felipe
    **  Date Created :  04.30.2013
    **  Reference By : (GIACS180 - Statement of Account)
    **  Description  : Executes the get_extract_date procedure
    */
    FUNCTION get_extract_date(
        p_user_id       giis_users.user_id%TYPE ,
        p_rep_date      giac_soa_rep_ext_param.rep_date%TYPE          
    ) RETURN soa_params_tab PIPELINED
    IS
        CURSOR c1 IS
            SELECT rep_date, param_date, as_of_date,
                   from_date1, to_date1, from_date2,
                   to_date2, date_tag, branch_cd,
                   intm_no, intm_type, assd_no,
                   branch_param,
                   inc_special_pol special_pol, 
                   extract_aging_days extract_days,    --mod1 start/end
                   payt_date
              FROM giac_soa_rep_ext_param
             WHERE user_id = p_user_id;
             
           v_rep_date     giac_soa_rep_ext_param.rep_date%TYPE;
        v_cut_off_date giac_soa_rep_ext_param.param_date%TYPE;
        v_as_of_date   giac_soa_rep_ext_param.as_of_date%TYPE;
        v_from_date1   giac_soa_rep_ext_param.from_date1%TYPE;
        v_to_date1     giac_soa_rep_ext_param.to_date1%TYPE;
        v_from_date2   giac_soa_rep_ext_param.from_date2%TYPE;
        v_to_date2     giac_soa_rep_ext_param.to_date2%TYPE;
        v_date_tag     giac_soa_rep_ext_param.date_tag%TYPE;
        v_branch_cd    giac_soa_rep_ext_param.branch_cd%TYPE;
        v_intm_no      giac_soa_rep_ext_param.intm_no%TYPE;
        v_intm_type    giac_soa_rep_ext_param.intm_type%TYPE;
        v_assd_no      giac_soa_rep_ext_param.assd_no%TYPE;
        v_special_pol  giac_soa_rep_ext_param.inc_special_pol%TYPE;
        v_extract_days giac_soa_rep_ext_param.extract_aging_days%TYPE; --mod2 start/end
        v_payt_date    giac_soa_rep_ext_param.PAYT_DATE%TYPE; -- shan 02.27.2015

        v_old_data     VARCHAR2(2);
        v_params        soa_params_type;
    BEGIN
        FOR c1_rec IN c1
        LOOP
            v_rep_date     := c1_rec.rep_date;
            v_cut_off_date := c1_rec.param_date;
            v_as_of_date   := c1_rec.as_of_date;
            v_from_date1   := TO_DATE(TO_CHAR(c1_rec.from_date1, 'mm-dd-yyyy'), 'mm-dd-yyyy');
            v_to_date1     := TO_DATE(TO_CHAR(c1_rec.to_date1, 'mm-dd-yyyy'), 'mm-dd-yyyy');
            v_from_date2   := TO_DATE(TO_CHAR(c1_rec.from_date2, 'mm-dd-yyyy'), 'mm-dd-yyyy');
            v_to_date2     := TO_DATE(TO_CHAR(c1_rec.to_date2, 'mm-dd-yyyy'), 'mm-dd-yyyy');
            v_date_tag     := c1_rec.date_tag;
            v_branch_cd    := c1_rec.branch_cd;
            v_intm_no      := c1_rec.intm_no;
            v_intm_type    := c1_rec.intm_type;
            v_assd_no      := c1_rec.assd_no;
            v_special_pol  := c1_rec.special_pol;
            v_extract_days := c1_rec.extract_days;    --mod3 start/end
            v_payt_date    := c1_rec.payt_date;
            
            /*pass the values to the parameters with respect to the tag*/
            v_params.branch_param  := c1_rec.branch_param;
            v_params.rep_date      := v_rep_date;
            v_params.cut_off       := v_cut_off_date;
            v_params.date_tag      := v_date_tag;
            v_params.dsp_cut_off        := v_cut_off_date; --gab
            v_params.dsp_date_as_of     := v_as_of_date;    --gab
            v_params.branch_cd     := v_branch_cd;
            v_params.intm_no       := v_intm_no;
            v_params.intm_type     := v_intm_type;
            v_params.assd_no       := v_assd_no;
            v_params.special_pol   := v_special_pol;
            v_params.extract_days  := v_extract_days;    --mod4 start/end
            v_params.payt_date     := v_payt_date;
            v_params.book_date_fr  := NULL;
            v_params.book_date_to  := NULL;
            v_params.incep_date_fr := NULL;
            v_params.incep_date_to := NULL;
            v_params.issue_date_fr := NULL;
            v_params.issue_date_to := NULL;
            
            IF p_rep_date = 'F' THEN
                IF v_date_tag = 'BK' THEN
                    v_params.book_date_fr := v_from_date1;
                    v_params.book_date_to := v_to_date1;
                ELSIF v_date_tag = 'IS' THEN
                    v_params.issue_date_fr := v_from_date1;
                    v_params.issue_date_to := v_to_date1;
                ELSIF v_date_tag = 'IN' THEN
                    v_params.incep_date_fr := v_from_date1;
                    v_params.incep_date_to := v_to_date1;
                ELSIF v_date_tag = 'BKIS' THEN
                    v_params.book_date_fr := v_from_date1;
                    v_params.book_date_to := v_to_date1;
                    v_params.issue_date_fr := v_from_date2;
                    v_params.issue_date_to := v_to_date2;
                ELSIF v_date_tag = 'BKIN' THEN
                    v_params.book_date_fr := v_from_date1;
                    v_params.book_date_to := v_to_date1;
                    v_params.incep_date_fr := v_from_date2;
                    v_params.incep_date_to := v_to_date2;
                END IF;
            ELSE
                v_params.date_as_of := v_as_of_date; 
            END IF; 
            
            PIPE ROW(v_params);
        END LOOP;         
    
    END get_extract_date;
    
    /*
    **  Created by   :  Marie Kris Felipe
    **  Date Created :  05.02.2013
    **  Reference By : (GIACS180 - Statement of Account)
    **  Description  : Extracts the SOA report
    */
    PROCEDURE extract_soa_rep_dtls(
       p_special_pol    GIAC_SOA_REP_EXT_PARAM.INC_SPECIAL_POL%TYPE,
       p_branch_cd      GIAC_SOA_REP_EXT_PARAM.branch_cd%TYPE,
       p_intm_no        GIAC_SOA_REP_EXT_PARAM.intm_no%TYPE,
       p_intm_type      GIAC_SOA_REP_EXT_PARAM.intm_type%TYPE,
       p_assd_no        GIAC_SOA_REP_EXT_PARAM.assd_no%TYPE,
       p_rep_date       GIAC_SOA_REP_EXT_PARAM.rep_date%TYPE,
       p_book_tag       VARCHAR2, --GIAC_SOA_REP_EXT_PARAM.book_tag%TYPE,
       p_book_date_fr   giac_soa_rep_ext_param.from_date1%TYPE,     --GIAC_SOA_REP_EXT_PARAM.book_date_fr%TYPE,
       p_book_date_to   giac_soa_rep_ext_param.to_date1%TYPE,       --GIAC_SOA_REP_EXT_PARAM.book_date_to%TYPE,
       p_incep_tag      VARCHAR2, --GIAC_SOA_REP_EXT_PARAM.incep_tag%TYPE,
       p_incep_date_fr  giac_soa_rep_ext_param.from_date1%TYPE,     --GIAC_SOA_REP_EXT_PARAM.incep_date_fr%TYPE,
       p_incep_date_to  giac_soa_rep_ext_param.to_date1%TYPE,       --GIAC_SOA_REP_EXT_PARAM.incep_date_to%TYPE,
       p_issue_tag      VARCHAR2, --GIAC_SOA_REP_EXT_PARAM.issue_tag%TYPE,
       p_issue_date_fr  giac_soa_rep_ext_param.from_date1%TYPE,     --GIAC_SOA_REP_EXT_PARAM.issue_date_fr%TYPE,
       p_issue_date_to  giac_soa_rep_ext_param.to_date1%TYPE,       --GIAC_SOA_REP_EXT_PARAM.issue_date_to%TYPE,
       p_date_as_of     GIAC_SOA_REP_EXT_PARAM.as_of_date%TYPE,
       p_cut_off_date   GIAC_SOA_REP_EXT_PARAM.param_date%TYPE,
       p_inc_pdc        VARCHAR2, --GIAC_SOA_REP_EXT_PARAM.%TYPE,
       p_row_counter    OUT NUMBER,
       p_extract_days   GIAC_SOA_REP_EXT_PARAM.extract_aging_days%TYPE,          --mod1 start/end
       p_branch_param   GIAC_SOA_REP_EXT_PARAM.branch_param%TYPE,
       p_message        OUT VARCHAR2,
       p_user_id        GIAC_SOA_REP_EXT_PARAM.user_id%TYPE,
       p_payt_date      VARCHAR2        -- shan 12.09.2014
    ) IS    
    BEGIN
        p_message := 'SUCCESS';
        BEGIN
        
            giis_users_pkg.app_user := p_user_id;
            /*Extract_Soa_Rep(p_special_pol,  p_branch_cd,        p_intm_no, 
                            p_intm_type,    p_assd_no,          p_rep_date,     
                            p_book_tag,     p_book_date_fr,     p_book_date_to,
                            p_incep_tag,    p_incep_date_fr,    p_incep_date_to,
                            p_issue_tag,    p_issue_date_fr,    p_issue_date_to,
                            p_date_as_of,   p_cut_off_date,     p_inc_pdc,
                            p_row_counter,  p_extract_days,     p_branch_param);*/
            -- commented out, used the new procedure Extract_Soa_Rep2 which uses the parameter p_user_id instead of USER
                            
            Extract_Soa_Rep2(p_special_pol,  p_branch_cd,        p_intm_no, 
                             p_intm_type,    p_assd_no,          p_rep_date,     
                             p_book_tag,     p_book_date_fr,     p_book_date_to,
                             p_incep_tag,    p_incep_date_fr,    p_incep_date_to,
                             p_issue_tag,    p_issue_date_fr,    p_issue_date_to,
                             p_date_as_of,   p_cut_off_date,     p_inc_pdc,
                             p_row_counter,  p_extract_days,     p_branch_param, p_user_id, p_payt_date);
        EXCEPTION
            WHEN OTHERS THEN
                p_message := 'Unable to extract Direct Business Bills.';
        END;        
    
    END extract_soa_rep_dtls;
    
    /*
    **  Created by   :  Marie Kris Felipe
    **  Date Created :  05.03.2013
    **  Reference By : (GIACS180 - Statement of Account)
    **  Description  : Computes the tax payments
    */
    PROCEDURE break_taxes(
        p_user_id               giac_soa_rep_tax_ext.user_id%TYPE,
        p_cut_off_date          GIAC_SOA_REP_EXT_PARAM.param_date%TYPE,
        p_payt_date             VARCHAR2,        -- shan 04.10.2015
        p_message               OUT VARCHAR2
    ) IS
           v_tax_bal_due    GIAC_SOA_REP_TAX_EXT.tax_bal_due%type;
           v_max_inst_no    GIPI_INSTALLMENT.inst_no%type;
           ctr              NUMBER := 0;
    BEGIN
        p_message := 'Initializing tax breakdown procedure...';
        
        BEGIN
            DELETE 
              FROM giac_soa_rep_tax_ext
             WHERE user_id = p_user_id;
             
            p_message := p_message || chr(10) || 'Initializing tax breakdown procedure... SUCCESS'; 
             
            FOR soarep IN (SELECT fund_cd,      branch_cd,      iss_cd,
                                  prem_seq_no,  inst_no,        due_date,       aging_id,       
                                  column_no,    column_title,   tax_bal_due,    spld_date
                             FROM GIAC_SOA_REP_EXT    
                            WHERE 1 = 1
                              AND user_id = p_user_id)
            LOOP 
                --Get the tax_amount per tax_cd
                --First get the max inst no for that bill
                BEGIN
                     SELECT MAX(INST_NO)
                       INTO v_max_inst_no
                       FROM GIPI_INSTALLMENT 
                      WHERE ISS_CD = soarep.iss_cd
                        AND PREM_SEQ_NO = soarep.prem_seq_no;
                EXCEPTION
                     WHEN NO_DATA_FOUND THEN
                        v_max_inst_no := 1;
                END;
                
                --Included GIPI_INVOICE in the select stmt to compute foreign currency
                --Terrence 05-08-2002
                FOR invtax in (SELECT A.iss_cd, A.prem_seq_no, A.tax_cd,A.tax_amt*B.CURRENCY_RT TAX_AMT, A.tax_allocation
                                 FROM GIPI_INV_TAX A, GIPI_INVOICE B
                                WHERE A.iss_cd = B.iss_cd
                                  AND A.prem_seq_no = B.PREM_SEQ_NO
                                  AND A.iss_cd = soarep.iss_cd
                                  AND A.prem_seq_no = soarep.prem_seq_no)
                LOOP
                    --Set the total balances per inst no
                    --Start the computation of the per installment amount
                    IF invtax.tax_allocation = 'F' THEN
                        IF soarep.inst_no = 1 THEN
                           v_tax_bal_due := invtax.tax_amt;
                        ELSE
                           v_tax_bal_due := 0;
                        END IF;
                    ELSIF invtax.tax_allocation = 'S' THEN
                        IF soarep.inst_no = v_max_inst_no THEN
                           v_tax_bal_due := invtax.tax_amt - round((invtax.tax_amt/v_max_inst_no),2)*(v_max_inst_no - 1);
                        ELSE
                           v_tax_bal_due := round((invtax.tax_amt/v_max_inst_no),2);
                        END IF;
                    ELSIF invtax.tax_allocation = 'L' THEN
                        IF soarep.inst_no = v_max_inst_no THEN
                           v_tax_bal_due := invtax.tax_amt;
                        ELSE
                           v_tax_bal_due := 0;
                        END IF;
                    END IF;
                    
                    IF (soarep.spld_date IS NULL) THEN
                        FOR collns IN (SELECT b160_iss_Cd, b160_prem_seq_no, 
                                              b160_tax_cd, tax_amt 
                                         FROM GIAC_TAX_COLLNS a, GIAC_ACCTRANS b 
                                        WHERE 1 = 1
                                          AND a.gacc_tran_id = b.tran_id
                                          AND b.tran_flag != 'D'
                                          AND b.tran_id >= 0
                                          AND a.b160_iss_cd = soarep.iss_cd
                                          AND a.b160_prem_seq_no = soarep.prem_seq_no
                                          AND a.inst_no = soarep.inst_no
                                          AND a.b160_tax_cd = invtax.tax_cd
                                          AND NOT EXISTS (SELECT gr.gacc_tran_id
                                                            FROM GIAC_REVERSALS gr,
                                                                 GIAC_ACCTRANS  ga
                                                           WHERE gr.reversing_tran_id = ga.tran_id
                                                             AND ga.tran_flag        !='D'
                                                             AND ga.tran_id >= 0
                                                             AND gr.gacc_tran_id = a.gacc_tran_id
                                                          --added condition by albert 04142015; consider payments that were cancelled before cutoff date
                                                             AND DECODE (p_payt_date, 'T',
                                                                         TRUNC(ga.tran_date),
                                                                         TRUNC(ga.posting_date)
                                                                        ) <= p_cut_off_date
                                                          --end albert 04142015
                                                         )
                                          --AND trunc(b.tran_date) <= p_cut_off_date    -- replaced with codes below 
                                          AND DECODE (p_payt_date,
                                                     'T', TRUNC (b.tran_date),
                                                     TRUNC (b.posting_date)
                                                    ) <= p_cut_off_date)
                                        -- shan 04.10.2015
                        LOOP
                           v_tax_bal_due := v_tax_bal_due - collns.tax_amt;
                        END LOOP; --TAX_COLLNS
                        
                    END IF;
                    
                    --Insert the record to the soa_rep_tax table
                    INSERT 
                      INTO GIAC_SOA_REP_TAX_EXT
                           (ISS_CD,         PREM_SEQ_NO,        INST_NO,        TAX_CD,         TAX_BAL_DUE,    USER_ID)
                    VALUES (soarep.iss_cd,  soarep.prem_seq_no, soarep.inst_no, invtax.tax_cd,  v_tax_bal_due,  p_user_id);
                    ctr := ctr + 1;
                        
                END LOOP; --INVTAX
            END LOOP; --SOAREP
            
        EXCEPTION
            WHEN OTHERS THEN
                 --MSG_ALERT('Error in tax break down process.','I',TRUE);
                 raise_application_error(-20001, 'Geniisys Exception#I#Error in tax break down process.');
        END; 
        
        p_message := 'Tax extraction finished! ' || TO_CHAR(ctr) || ' records extracted.';
    END break_taxes;
    
    -- Executes set_default_dates1 procedure
    FUNCTION set_default_dates1(
        p_user_id       giac_soa_rep_ext_param.user_id%TYPE,
        p_rep_date      giac_soa_rep_ext_param.REP_DATE%type
    ) RETURN soa_params_tab PIPELINED 
    IS
            CURSOR c1 IS
                SELECT rep_date, param_date, as_of_date,
                       from_date1, to_date1, from_date2, to_date2,
                       date_tag, branch_cd, intm_no, intm_type,
                       assd_no, inc_special_pol special_pol,
                       extract_aging_days extract_days        --mod1 start/end
                  FROM giac_soa_rep_ext_param
                 WHERE user_id = p_user_id;
                 
                v_rep_date     giac_soa_rep_ext_param.rep_date%TYPE;
                v_cut_off_date giac_soa_rep_ext_param.param_date%TYPE;
                v_as_of_date   giac_soa_rep_ext_param.as_of_date%TYPE;
                v_from_date1   giac_soa_rep_ext_param.from_date1%TYPE;
                v_to_date1     giac_soa_rep_ext_param.to_date1%TYPE;
                v_from_date2   giac_soa_rep_ext_param.from_date2%TYPE;
                v_to_date2     giac_soa_rep_ext_param.to_date2%TYPE;
                v_date_tag     giac_soa_rep_ext_param.date_tag%TYPE;
                v_branch_cd    giac_soa_rep_ext_param.branch_cd%TYPE;
                v_intm_no      giac_soa_rep_ext_param.intm_no%TYPE;
                v_intm_type    giac_soa_rep_ext_param.intm_type%TYPE;
                v_assd_no      giac_soa_rep_ext_param.assd_no%TYPE;
                v_special_pol  giac_soa_rep_ext_param.inc_special_pol%TYPE;
                v_extract_days giac_soa_rep_ext_param.extract_aging_days%TYPE;    --mod2 start/end

                v_old_data     VARCHAR2(2);
                v_params       soa_params_type;
    BEGIN
        FOR c1_rec IN c1
        LOOP
            v_rep_date     := c1_rec.rep_date;
            v_cut_off_date := c1_rec.param_date;
            v_as_of_date   := c1_rec.as_of_date;
            v_from_date1   := TO_DATE(TO_CHAR(c1_rec.from_date1, 'mm-dd-yyyy'), 'mm-dd-yyyy');
            v_to_date1     := TO_DATE(TO_CHAR(c1_rec.to_date1, 'mm-dd-yyyy'), 'mm-dd-yyyy');
            v_from_date2   := TO_DATE(TO_CHAR(c1_rec.from_date2, 'mm-dd-yyyy'), 'mm-dd-yyyy');
            v_to_date2     := TO_DATE(TO_CHAR(c1_rec.to_date2, 'mm-dd-yyyy'), 'mm-dd-yyyy');
            v_date_tag     := c1_rec.date_tag;
            v_branch_cd    := c1_rec.branch_cd;
            v_intm_no      := c1_rec.intm_no;
            v_intm_type    := c1_rec.intm_type;
            v_assd_no      := c1_rec.assd_no;
            v_special_pol  := c1_rec.special_pol;
            v_extract_days := c1_rec.extract_days;    --mod3 start/end
        --END LOOP;
        
            --reset the parameters
            v_params.book_date_fr  := NULL;
            v_params.book_date_to  := NULL;
            v_params.incep_date_fr := NULL;
            v_params.incep_date_to := NULL;
            v_params.issue_date_fr := NULL;
            v_params.issue_date_to := NULL;
            v_params.cut_off       := NULL;
            v_params.date_as_of    := NULL;
            v_params.date_tag      := NULL;    
            v_params.branch_cd     := NULL;
            v_params.intm_no       := NULL;
            v_params.intm_type     := NULL;
            v_params.assd_no       := NULL;
            v_params.special_pol   := NULL;
            v_params.extract_days  := NULL;        --mod4 start/end
            
            /*pass the values to the parameters with respect to the tag*/
            v_params.cut_off    := v_cut_off_date;
            v_params.date_as_of := v_as_of_date; 
            v_params.date_tag   := v_date_tag;
            v_params.cut_off    := v_cut_off_date;
            v_params.date_as_of := v_as_of_date; 
            v_params.date_tag   := v_date_tag;
            v_params.branch_cd    := v_branch_cd;
            v_params.intm_no      := v_intm_no;
            v_params.intm_type    := v_intm_type;
            v_params.assd_no      := v_assd_no;
            v_params.special_pol  := v_special_pol;
            v_params.extract_days := v_extract_days;    --mod5 start/end
            
            IF p_rep_date = 'F' THEN
                IF v_date_tag = 'BK' THEN
                    v_params.book_date_fr := v_from_date1;
                    v_params.book_date_to := v_to_date1;
                ELSIF v_date_tag = 'IS' THEN
                    v_params.issue_date_fr := v_from_date1;
                    v_params.issue_date_to := v_to_date1;
                ELSIF v_date_tag = 'IN' THEN
                    v_params.incep_date_fr := v_from_date1;
                    v_params.incep_date_to := v_to_date1;
                ELSIF v_date_tag = 'BKIS' THEN
                    v_params.book_date_fr := v_from_date1;
                    v_params.book_date_to := v_to_date1;
                    v_params.issue_date_fr := v_from_date2;
                    v_params.issue_date_to := v_to_date2;
                ELSIF v_date_tag = 'BKIN' THEN
                    v_params.book_date_fr := v_from_date1;
                    v_params.book_date_to := v_to_date1;
                    v_params.incep_date_fr := v_from_date2;
                    v_params.incep_date_to := v_to_date2;
                ELSE
                    /*check if the user has extracted data but without the date parameters*/
                    FOR k IN(SELECT 'X' OLD
                               FROM giac_soa_rep_ext
                              WHERE user_id = p_user_id
                                AND ROWNUM = 1) 
                    LOOP
                      v_old_data :=  k.OLD;
                      EXIT;
                    END LOOP;
                    
                    IF v_old_data IS NULL THEN
                      --message('You have not extracted any values yet.');
                      v_params.message := 'You have not extracted any values yet';
                    ELSE
                      NULL;
                    END IF;
                END IF; -- continued in jsp                  
            --ELSE continuation in jsp
            END IF;
        
            PIPE ROW(v_params);
        END LOOP;           
    END set_default_dates1; 
    
    -- Retrieves remarks
    FUNCTION get_remarks 
        RETURN VARCHAR2
    IS
        v_remarks       giis_document.text%TYPE := '';
    BEGIN
        FOR x IN (SELECT text remark
                    FROM giis_document
                   WHERE report_id = 'SOA'
                     AND title = 'SOA_REMARKS')
        LOOP
            v_remarks := REGEXP_REPLACE(x.remark, CHR(10), '\\n');
        END LOOP;
        
        RETURN (v_remarks);
    END get_remarks;
    
    /*
    **  Created by   :  Marie Kris Felipe
    **  Date Created :  05.08.2013
    **  Reference By : (GIACS180 - Statement of Account)
    **  Description  : Gets the SOA rep details by intm_no [GSOA block]
    */
    FUNCTION get_intm_gsoa_dtl(
        p_intm_no      GIIS_INTERMEDIARY.INTM_NO%TYPE,
        p_user_id      giis_users.user_id%TYPE
    ) RETURN soa_detail_tab PIPELINED
    IS
        v_detail            soa_detail_type;
    BEGIN
        FOR i IN (SELECT intm_no, intm_name,
                         policy_no, iss_cd, prem_seq_no, inst_no,
                         aging_id, column_title, balance_amt_due
                    FROM GIAC_SOA_REP_EXT
                   WHERE intm_no = p_intm_no
                     AND user_id = p_user_id
                     AND balance_amt_due != 0)
        LOOP
            v_detail.intm_no := i.intm_no;
            v_detail.intm_name := i.intm_name;
            v_detail.policy_no := i.policy_no;
            v_detail.iss_cd := i.iss_cd;
            v_detail.prem_seq_no := i.prem_seq_no;
            v_detail.inst_no := i.inst_no;
            v_detail.aging_id := i.aging_id;
            v_detail.column_title := i.column_title;
            v_detail.balance_amt_due := i.balance_amt_due;
            v_detail.bill_no := i.iss_cd || '-' || TO_CHAR(i.prem_seq_no) || '-' || TO_CHAR(i.inst_no);
            --v_detail.total_amt_due := i.total_amt_due;
            v_detail.assd_no := null;
            v_detail.assd_name := null;
        
            PIPE ROW(v_detail);
        END LOOP;
        
    END get_intm_gsoa_dtl;
    
    
     /*
    **  Created by   :  Marie Kris Felipe
    **  Date Created :  05.08.2013
    **  Reference By : (GIACS180 - Statement of Account)
    **  Description  : Gets the SOA rep details by assd_no [GSOA block]
    */
    FUNCTION get_assd_gsoa_dtl(
        p_assd_no      GIIS_ASSURED.assd_no%TYPE,
        p_user_id      giis_users.user_id%TYPE
    ) RETURN soa_detail_tab PIPELINED
    IS
        v_detail            soa_detail_type;
    BEGIN
        FOR i IN (SELECT assd_no, assd_name,
                         policy_no, iss_cd, prem_seq_no, inst_no,
                         aging_id, column_title, balance_amt_due
                    FROM GIAC_SOA_REP_EXT
                   WHERE assd_no = p_assd_no
                     AND user_id = p_user_id
                     AND balance_amt_due != 0)
        LOOP
            v_detail.assd_no := i.assd_no;
            v_detail.assd_name := i.assd_name;
            v_detail.policy_no := i.policy_no;
            v_detail.iss_cd := i.iss_cd;
            v_detail.prem_seq_no := i.prem_seq_no;
            v_detail.inst_no := i.inst_no;
            v_detail.aging_id := i.aging_id;
            v_detail.column_title := i.column_title;
            v_detail.balance_amt_due := i.balance_amt_due;
            v_detail.bill_no := i.iss_cd || '-' || TO_CHAR(i.prem_seq_no) || '-' || TO_CHAR(i.inst_no);
        
            PIPE ROW(v_detail);
        END LOOP;
        
    END get_assd_gsoa_dtl;
    
    -- Retrieves list of intm when <List All> button is clicked    
    FUNCTION get_aging_intm_list (p_user_id VARCHAR2)
        RETURN soa_detail_tab PIPELINED
    IS
        v_aging_intm            soa_detail_type;
    BEGIN
        FOR rec IN(SELECT *
                     FROM (SELECT   SUM (balance_amt_due) balance_amt_due,
                                    SUM (prem_bal_due) prem_balance_due,
                                    SUM (tax_bal_due) tax_balance_due, intm_no, intm_name
                               FROM giac_soa_rep_ext
                              WHERE user_id = p_user_id
                                AND intm_no != 0
                                AND assd_no != 0
                           GROUP BY intm_no, intm_name)
                    WHERE balance_amt_due != 0)
--          Modified by Apollo Cruz, giac_aging_intm_v does not get the correct logged in user in genweb
--        FOR rec IN(SELECT balance_amt_due, prem_balance_due,
--                          tax_balance_due, intm_no, intm_name
--                     FROM giac_aging_intm_v
--                    WHERE balance_amt_due != 0 
--                      AND intm_no! = 0)
        LOOP
            v_aging_intm.balance_amt_due    := rec.balance_amt_due;
            --v_aging_intm.prem_balance_due   := rec.prem_balance_due;   used the column name from giac_soa_rep_ext instead
            v_aging_intm.prem_bal_due       := rec.prem_balance_due;
            --v_aging_intm.tax_balance_due    := rec.tax_balance_due;   used the column name from giac_soa_rep_ext instead
            v_aging_intm.tax_bal_due        := rec.tax_balance_due;
            v_aging_intm.intm_no            := rec.intm_no;
            v_aging_intm.intm_name          := rec.intm_name;
            
            PIPE ROW(v_aging_intm);
        END LOOP;
    END get_aging_intm_list;
    
    -- Retrieves list of assd when <List All> button is clicked
    FUNCTION get_aging_assd_list  (p_user_id VARCHAR2)
        RETURN soa_detail_tab PIPELINED
    IS
        v_aging_assd        soa_detail_type;
    BEGIN
        FOR rec IN (SELECT balance_amt_due, prem_balance_due,
                           tax_balance_due, assd_no, assd_name
                      FROM (SELECT SUM (balance_amt_due) balance_amt_due,
                                   SUM (prem_bal_due) prem_balance_due,
                                   SUM (tax_bal_due) tax_balance_due, assd_no, assd_name
                                  FROM giac_soa_rep_ext
                                 WHERE user_id = p_user_id
                                   AND assd_no != 0
                              GROUP BY assd_no, assd_name)
                     WHERE balance_amt_due != 0)
--        Modified by Apollo Cruz, giac_aging_assd_v does not get the correct logged in user in genweb
--        FOR rec IN(SELECT balance_amt_due, prem_balance_due,
--                          tax_balance_due, assd_no, assd_name
--                     FROM giac_aging_assd_v
--                    WHERE balance_amt_due != 0 
--                      AND assd_no! = 0)
        LOOP
            v_aging_assd.balance_amt_due    := rec.balance_amt_due;
            --v_aging_assd.prem_balance_due := rec.prem_balance_due;   used the column name from giac_soa_rep_ext instead
            v_aging_assd.prem_bal_due       := rec.prem_balance_due;
            --v_aging_assd.tax_balance_due  := rec.tax_balance_due;   used the column name from giac_soa_rep_ext instead
            v_aging_assd.tax_bal_due        := rec.tax_balance_due;
            v_aging_assd.assd_no            := rec.assd_no;
            v_aging_assd.assd_name          := rec.assd_name;
            
            PIPE ROW(v_aging_assd);
        END LOOP;
    END get_aging_assd_list;
    
    -- List All > Aging [Intm]
    FUNCTION get_list_all_aging (
        p_user_id           VARCHAR2,
        p_view_type         VARCHAR2,
        p_index             NUMBER,
        p_intm_no           giac_soa_rep_ext.INTM_NO%type,
        p_intm_name         giac_soa_rep_ext.INTM_NAME%type,
        p_assd_no           giac_soa_rep_ext.ASSD_NO%type,
        p_assd_name         giac_soa_rep_ext.ASSD_NAME%type,
        p_balance_amt_due   giac_soa_rep_ext.BALANCE_AMT_DUE%type
    ) RETURN soa_detail_tab PIPELINED
    IS
        v_aging     soa_detail_type;
        v_list      CLOB := get_coll_element(p_index);
    BEGIN
        FOR rec IN (SELECT gibr_gfun_fund_cd, gibr_branch_cd,
                           gagp_aging_id, 
                           balance_amt_due, prem_balance_due, tax_balance_due
                      FROM (SELECT a.aging_id gagp_aging_id, SUM (balance_amt_due) balance_amt_due,
                                   SUM (prem_bal_due) prem_balance_due,
                                   SUM (tax_bal_due) tax_balance_due, gibr_gfun_fund_cd,
                                   gibr_branch_cd
                              FROM giac_soa_rep_ext a, giac_aging_parameters b
                             WHERE a.aging_id = b.aging_id
                               AND a.fund_cd = gibr_gfun_fund_cd
                               AND a.branch_cd = gibr_branch_cd
                               AND a.user_id = p_user_id
                               AND a.assd_no = NVL(p_assd_no, a.assd_no)
                               AND a.assd_name LIKE NVL(p_assd_name, '%')
                               AND a.intm_no = NVL(p_intm_no, a.intm_no)
                               AND a.intm_name LIKE NVL(p_intm_name, '%')
                               AND a.balance_amt_due = NVL(p_balance_amt_due, a.balance_amt_due)
                               AND DECODE(p_view_type, 'I', intm_no, assd_no) IN (SELECT *
                                                                                    FROM TABLE(clob_to_table(v_list, ',')))
                          GROUP BY a.aging_id, gibr_gfun_fund_cd, gibr_branch_cd)
                     WHERE balance_amt_due != 0
                     ORDER BY gagp_aging_id)
--        Modified by Apollo Cruz, giac_aging_totals_v does not get the correct logged in user in genweb                     
--        FOR rec IN (SELECT gibr_gfun_fund_cd, gibr_branch_cd,
--                           gagp_aging_id, 
--                           balance_amt_due, prem_balance_due, tax_balance_due
--                      FROM GIAC_AGING_TOTALS_V
--                     WHERE balance_amt_due != 0
--                     ORDER BY gagp_aging_id)
        LOOP
            FOR i IN (SELECT GAGP1.COLUMN_HEADING
                        FROM GIAC_AGING_PARAMETERS GAGP1
                       WHERE GAGP1.AGING_ID = rec.GAGP_AGING_ID) 
            LOOP                         
               v_aging.age_level := i.column_heading;
            END LOOP;   
            
            v_aging.aging_id           := rec.gagp_aging_id;
            v_aging.fund_cd            := rec.gibr_gfun_fund_cd;
            v_aging.branch_cd          := rec.gibr_branch_cd;
            v_aging.aging_bal_amt_due  := rec.balance_amt_due;
            v_aging.aging_prem_bal_due := rec.prem_balance_due;
            v_aging.aging_tax_bal_due  := rec.tax_balance_due;
            
            PIPE ROW(v_aging);
        END LOOP;
    END;
    
    
    /**
    * Retrieves list of aging totals for Intm when Aging button is clicked.
    */
    FUNCTION get_aging_totals_intm(
        p_intm_no       GIAC_AGING_TOTALS_INTM_V.intm_no%TYPE,
        p_user_id       VARCHAR2
    ) RETURN soa_detail_tab PIPELINED
    IS
        v_totals    soa_detail_type;
    BEGIN
       FOR rec IN (SELECT aging_id, intm_no,
                          gibr_gfun_fund_cd, gibr_branch_cd,
                          balance_amt_due, prem_balance_due, tax_balance_due
                     FROM (SELECT a.aging_id, SUM (balance_amt_due) balance_amt_due,
                                  SUM (prem_bal_due) prem_balance_due,
                                  SUM (tax_bal_due) tax_balance_due, gibr_gfun_fund_cd,
                                  gibr_branch_cd, intm_no
                             FROM giac_soa_rep_ext a, giac_aging_parameters b
                            WHERE a.aging_id = b.aging_id
                              AND a.fund_cd = gibr_gfun_fund_cd
                              AND a.branch_cd = gibr_branch_cd
                              AND a.user_id = p_user_id
                         GROUP BY a.aging_id, gibr_gfun_fund_cd, gibr_branch_cd, intm_no)
                    WHERE balance_amt_due != 0
                      AND intm_no = NVL(p_intm_no, intm_no)
                    ORDER BY aging_id)
--        Modified by Apollo Cruz, giac_aging_totals_intm_v does not get the correct logged in user in genweb                     
--        FOR rec IN (SELECT aging_id, intm_no,
--                           gibr_gfun_fund_cd, gibr_branch_cd,
--                           balance_amt_due, prem_balance_due, tax_balance_due
--                      FROM GIAC_AGING_TOTALS_INTM_V
--                     WHERE balance_amt_due != 0
--                       AND intm_no = nvl(p_intm_no, intm_no)
--                     ORDER BY aging_id)
        LOOP
        
            FOR i IN (SELECT column_heading
                        FROM giac_aging_parameters
                       WHERE aging_id = rec.aging_id)
            LOOP
                v_totals.age_level := i.column_heading;
            END LOOP;
            
            v_totals.aging_id           := rec.aging_id;
            v_totals.intm_no            := rec.intm_no;
            v_totals.fund_cd            := rec.gibr_gfun_fund_cd;
            v_totals.branch_cd          := rec.gibr_branch_cd;
            v_totals.aging_bal_amt_due  := rec.balance_amt_due;
            v_totals.aging_prem_bal_due := rec.prem_balance_due;
            v_totals.aging_tax_bal_due  := rec.tax_balance_due;
            
            PIPE ROW(v_totals);
        END LOOP;
    END get_aging_totals_intm;
    
    /**
    * Retrieves list of aging totals for Assd when Aging button is clicked.
    */
    FUNCTION get_aging_totals_assd(
        p_assd_no       GIAC_AGING_TOTALS_ASSD_V.assd_no%TYPE,
        p_user_id       VARCHAR2
    ) RETURN soa_detail_tab PIPELINED
    IS
        v_totals    soa_detail_type;
    BEGIN
        FOR rec IN (SELECT aging_id, assd_no,
                           gibr_gfun_fund_cd, gibr_branch_cd,
                           balance_amt_due, prem_balance_due, tax_balance_due
                      FROM (SELECT a.aging_id, SUM (balance_amt_due) balance_amt_due,
                                   SUM (prem_bal_due) prem_balance_due,
                                   SUM (tax_bal_due) tax_balance_due, gibr_gfun_fund_cd,
                                   gibr_branch_cd, assd_no
                              FROM giac_soa_rep_ext a, giac_aging_parameters b
                             WHERE a.aging_id = b.aging_id
                               AND a.fund_cd = gibr_gfun_fund_cd
                               AND a.branch_cd = gibr_branch_cd
                               AND a.user_id = p_user_id
                          GROUP BY a.aging_id, gibr_gfun_fund_cd, gibr_branch_cd, assd_no)
                     WHERE balance_amt_due != 0
                       AND assd_no = NVL(p_assd_no, assd_no)
                     ORDER BY aging_id)
--        Modified by Apollo Cruz, giac_aging_totals_assd_v does not get the correct logged in user in genweb                     
--        FOR rec IN (SELECT aging_id, assd_no,
--                           gibr_gfun_fund_cd, gibr_branch_cd,
--                           balance_amt_due, prem_balance_due, tax_balance_due
--                      FROM GIAC_AGING_TOTALS_ASSD_V
--                     WHERE balance_amt_due != 0
--                       AND assd_no = nvl(p_assd_no, assd_no)
--                     ORDER BY aging_id)             
        LOOP
        
            FOR i IN (SELECT column_heading
                        FROM giac_aging_parameters
                       WHERE aging_id = rec.aging_id)
            LOOP
                v_totals.age_level := i.column_heading;
            END LOOP;
            
            v_totals.aging_id           := rec.aging_id;
            v_totals.assd_no            := rec.assd_no;
            v_totals.fund_cd            := rec.gibr_gfun_fund_cd;
            v_totals.branch_cd          := rec.gibr_branch_cd;
            v_totals.aging_bal_amt_due  := rec.balance_amt_due;
            v_totals.aging_prem_bal_due := rec.prem_balance_due;
            v_totals.aging_tax_bal_due  := rec.tax_balance_due;
            
            PIPE ROW(v_totals);
        END LOOP;
    END get_aging_totals_assd;
    
    
    -- saves the collection letter parameters before calling the report
    PROCEDURE populate_parameters(
        p_iss_cd                  giac_soa_rep_ext.iss_cd%TYPE,
        p_prem_seq_no             giac_soa_rep_ext.prem_seq_no%TYPE,
        p_inst_no                 giac_soa_rep_ext.inst_no%TYPE,
        p_balance_amt_due         giac_soa_rep_ext.balance_amt_due%TYPE,
        p_coll_let_no             OUT giac_colln_letter.coll_let_no%TYPE
    ) IS
        v_iss_cd                giac_soa_rep_ext.iss_cd%TYPE := p_iss_cd;
        v_prem_seq_no           giac_soa_rep_ext.prem_seq_no%TYPE := p_prem_seq_no;
        v_inst_no               giac_soa_rep_ext.inst_no%TYPE := p_inst_no;
        v_balance_amt_due       giac_soa_rep_ext.balance_amt_due%TYPE := p_balance_amt_due;
        v_coll_seq_temp         giac_colln_letter.coll_seq_no%TYPE;
        v_coll_seq_no           giac_colln_letter.coll_seq_no%TYPE;
        v_coll_let_no           giac_colln_letter.coll_let_no%TYPE;
        v_coll_let_temp         giac_colln_letter.coll_let_no%TYPE;
        v_coll_year             giac_colln_letter.coll_year%TYPE;
        v_client                giac_parameters.param_value_v%TYPE;
    BEGIN
    
        SELECT GIACP.V('COLL_LET_CLIENT')
          INTO v_client
          FROM dual; 
 
        SELECT MAX(coll_seq_no) 
          INTO v_coll_seq_temp
          FROM GIAC_COLLN_LETTER;
          
        IF v_coll_seq_temp IS NULL THEN
           v_coll_seq_no := 1;
        ELSE
           v_coll_seq_no := v_coll_seq_temp + 1;
        END IF;
        
        FOR rec IN (SELECT MAX(coll_let_no) coll_let_no
                      FROM GIAC_COLLN_LETTER
                     WHERE iss_cd = v_iss_cd
                       AND prem_seq_no = v_prem_seq_no
                       AND inst_no = v_inst_no)
        LOOP
          v_coll_let_temp := rec.coll_let_no;                                              
        END LOOP;
        
        /*IF v_client IN ('FGI', 'COV', 'CPI', 'PCI', 'FPA') THEN   -- prepare_parameters
        
            IF v_coll_let_temp is NULL THEN
               v_coll_let_no := 1;
            ELSE   
                v_coll_let_no := 1;
            END IF;
            
        ELSIF v_client IN ('AUI') THEN  -- prepare_parametersB
        
            IF v_coll_let_temp is NULL THEN
               v_coll_let_no:=1;
            ELSIF v_coll_let_temp = 1 THEN
               v_coll_let_no:=2;    
            ELSIF v_coll_let_temp = 2 THEN           
               v_coll_let_no:=3;
            ELSE
               raise_application_error(-20001, 'Geniisys Exception#I#Cannot issue another collection letter. This bill no. has already been issued a 3rd collection letter.');                       
            END IF;
            
        ELSIF v_client IN ('MET') THEN  -- prepare_parametersD
        
            IF v_coll_let_temp is NULL THEN
               v_coll_let_no := 1;
            ELSE   
                v_coll_let_no := 1;
            END IF;
        
        END IF;*/ -- replaced with codes below : SR-4913 ::: shan 09.16.2015
        
        IF v_client IN ('AUI') THEN  -- prepare_parametersB
        
            IF v_coll_let_temp is NULL THEN
               v_coll_let_no:=1;
            ELSIF v_coll_let_temp = 1 THEN
               v_coll_let_no:=2;    
            ELSIF v_coll_let_temp = 2 THEN           
               v_coll_let_no:=3;
            ELSE
               raise_application_error(-20001, 'Geniisys Exception#I#Cannot issue another collection letter. This bill no. has already been issued a 3rd collection letter.');                       
            END IF;
        ELSIF v_client IN ('NIA') THEN  --added by john 3.31.2016
        
            IF v_coll_let_temp is NULL THEN
               v_coll_let_no:=1;
            ELSIF v_coll_let_temp = 1 THEN
               v_coll_let_no:=2;    
            ELSIF v_coll_let_temp = 2 THEN           
               v_coll_let_no:=3;
            ELSE
               raise_application_error(-20001, 'Geniisys Exception#I#Cannot issue another collection letter. This bill no. has already been issued a 3rd collection letter.');                       
            END IF;
        ELSE
            v_coll_let_no := 1;
        END IF;
        
        p_coll_let_no := v_coll_let_no;
                
        INSERT 
          INTO giac_colln_letter
               (coll_seq_no,    coll_let_no,    coll_year,              iss_cd,
                prem_seq_no,    inst_no,        bal_amt_due)
        VALUES (v_coll_seq_no,  v_coll_let_no,  TO_CHAR(SYSDATE,'YY'),  v_iss_cd,
                v_prem_seq_no,  v_inst_no,      v_balance_amt_due);
            
    END populate_parameters;
    
    -- return the query to be passed to Jasper
    /*FUNCTION process_intm_assd(
        p_view_type         VARCHAR2
    ) RETURN VARCHAR2 
    IS
        v_query     VARCHAR2(4000);
    BEGIN
    
        IF p_view_type = 'I' THEN
    
            v_query := 'SELECT intm_name,
                               intm_no,  
                               policy_no policy, 
                               (SUBSTR(POLICY_NO,1,(INSTR(POLICY_NO,''-'',1,5)+1)))policy_no,  
                               (SUBSTR(POLICY_NO,INSTR(POLICY_NO,''-'',1,6)+1,LENGTH(POLICY_NO))) endt_no,
                               iss_cd,
                               prem_seq_no, 
                               prem_bal_due,
                               tax_bal_due,
                               balance_amt_due,
                               inst_no
                          FROM giac_soa_rep_ext
                         WHERE intm_no = p_intm_no                         
                           AND aging_id = p_aging_id
                           AND user_id = p_user_id';
    
        ELSIF p_view_type = 'A' THEN
    
            v_query := 'SELECT assd_name,
                               assd_no,  
                               policy_no policy, 
                               (SUBSTR(POLICY_NO,1,(INSTR(POLICY_NO,''-'',1,5)+1)))policy_no,  
                               (SUBSTR(POLICY_NO,INSTR(POLICY_NO,''-'',1,6)+1,LENGTH(POLICY_NO))) endt_no,
                               iss_cd,
                               prem_seq_no, 
                               prem_bal_due,
                               tax_bal_due,
                               balance_amt_due,
                               inst_no
                          FROM giac_soa_rep_ext
                         WHERE assd_no = p_assd_no                         
                           AND aging_id = p_aging_id
                           AND user_id = p_user_id';
        
        END IF;
        
        RETURN v_query;
    END process_intm_assd;*/
    
    
    FUNCTION process_intm_assd2(
        p_view_type     VARCHAR2,
        p_assd_no       giac_soa_rep_ext.assd_no%TYPE,
        p_intm_no       giac_soa_rep_ext.intm_no%TYPE,
        p_aging_id      giac_soa_rep_ext.aging_id%TYPE,
        p_user_id       giac_soa_rep_ext.user_id%TYPE,
        p_assd_no_list  VARCHAR2,
        p_intm_no_list  VARCHAR2,
        p_aging_id_list VARCHAR2,
        p_from_button   VARCHAR2
    ) RETURN VARCHAR2 --soa_detail_tab PIPELINED
    IS 
        v_detail        soa_detail_type;   
        
        v_assd_list     VARCHAR2(32767) := p_assd_no_list;
        v_intm_list     VARCHAR2(32767) := p_intm_no_list;
        v_aging_list    VARCHAR2(32767) := p_aging_id_list;
        
        v_assd_no       VARCHAR2(14); --giac_soa_rep_ext.assd_no%TYPE;
        v_intm_no       VARCHAR2(14); --giac_soa_rep_ext.intm_no%TYPE;
        v_aging_id      VARCHAR2(10); --giac_soa_rep_ext.aging_id%TYPE;   
        v_exists        VARCHAR2(1) := 'N'; 
        v_label         VARCHAR2(30);
    BEGIN
        IF p_view_type = 'A' THEN
        
           v_label := 'assured';
           
           IF p_from_button = 'listAllAging' THEN -- for GIACR190C
           
                FOR all_rec IN (SELECT DISTINCT assd_no assd_no, aging_id
                                  FROM giac_soa_rep_ext
                                 WHERE user_id = p_user_id
                                   /*AND aging_id IN (v_aging_list)*/ )
                LOOP
                    
                    v_assd_no   := '#' || all_rec.assd_no || '#';
                    v_aging_id  := '#' || all_rec.aging_id || '#';
                    
                    IF INSTR(v_assd_list, v_assd_no) != 0 /*AND INSTR(v_aging_list, v_aging_id) != 0*/ THEN
                        FOR rec IN (SELECT assd_name,
                                           assd_no,  
                                           policy_no policy, 
                                           (SUBSTR(POLICY_NO,1,(INSTR(POLICY_NO,'-',1,5)+1)))policy_no,  
                                           (SUBSTR(POLICY_NO,INSTR(POLICY_NO,'-',1,6)+1,LENGTH(POLICY_NO))) endt_no,
                                           iss_cd,
                                           prem_seq_no, 
                                           prem_bal_due,
                                           tax_bal_due,
                                           balance_amt_due,
                                           inst_no
                                      FROM giac_soa_rep_ext
                                     WHERE assd_no = REPLACE(v_assd_no, '#')                         
                                       AND aging_id = REPLACE(v_aging_id, '#')
                                       AND user_id = p_user_id)
                        LOOP
                            v_exists := 'Y';
                        END LOOP;
                    
                    END IF;
                
                END LOOP;
                
           ELSE --IF p_from_button = 'printCollectionLetterAging' THEN -- button = 'printCollectionLetter'
               
                v_assd_no := p_assd_no;
                
                FOR all_rec IN (SELECT DISTINCT aging_id aging_id
                                  FROM giac_soa_rep_ext
                                 WHERE assd_no = v_assd_no
                                   AND user_id = p_user_id)
                LOOP
                
                    v_aging_id := '#' || all_rec.aging_id || '#';
                    
                    IF INSTR(v_aging_list, v_aging_id) != 0 THEN
                        FOR rec IN (SELECT assd_name,
                                           assd_no,  
                                           policy_no policy, 
                                           (SUBSTR(POLICY_NO,1,(INSTR(POLICY_NO,'-',1,5)+1)))policy_no,  
                                           (SUBSTR(POLICY_NO,INSTR(POLICY_NO,'-',1,6)+1,LENGTH(POLICY_NO))) endt_no,
                                           iss_cd,
                                           prem_seq_no, 
                                           prem_bal_due,
                                           tax_bal_due,
                                           balance_amt_due,
                                           inst_no
                                      FROM giac_soa_rep_ext
                                     WHERE assd_no = v_assd_no                         
                                       AND aging_id = REPLACE(v_aging_id, '#')
                                       AND user_id = p_user_id)
                        LOOP
                            /*v_detail.assd_name          := rec.assd_name;
                            v_detail.assd_no            := rec.assd_no;
                            v_detail.policy_no          := rec.policy;
                            v_detail.policy_no2         := rec.policy_no;
                            v_detail.iss_cd             := rec.iss_cd;
                            v_detail.prem_seq_no        := rec.prem_seq_no;
                            v_detail.prem_bal_due       := rec.prem_bal_due;
                            v_detail.tax_bal_due        := rec.tax_bal_due;
                            v_detail.balance_amt_due    := rec.balance_amt_due;
                            v_detail.inst_no            := rec.inst_no;
                            v_detail.endt_no            := rec.endt_no;   */
                                            
                            --PIPE ROW(v_detail); test kris 6.24.2013
                            v_exists := 'Y';
                        END LOOP; 
                        
                    END IF;   -- end: INSTR 
                END LOOP;
           
           --ELSE
            --NULL;
           END IF; -- end: p_from_button
        
           
        
        ELSE -- viewType is Intermediary
               
            v_label := 'intermediary';
            
            IF p_from_button = 'listAllAging' THEN
            
                FOR all_rec IN (SELECT DISTINCT intm_no intm_no, aging_id
                                  FROM giac_soa_rep_ext
                                 WHERE user_id = p_user_id
                                   /*AND aging_id IN (v_aging_list)*/ )
                LOOP
                    
                    v_intm_no   := '#' || all_rec.intm_no || '#';
                    v_aging_id  := '#' || all_rec.aging_id || '#';
                    
                    IF INSTR(v_intm_list, v_intm_no) != 0 THEN
                    
                        FOR rec IN (SELECT intm_name,
                                           intm_no,  
                                           policy_no policy, 
                                           (SUBSTR(POLICY_NO,1,(INSTR(POLICY_NO,'-',1,5)+1)))policy_no,  
                                           (SUBSTR(POLICY_NO,INSTR(POLICY_NO,'-',1,6)+1,LENGTH(POLICY_NO))) endt_no,
                                           iss_cd,
                                           prem_seq_no, 
                                           prem_bal_due,
                                           tax_bal_due,
                                           balance_amt_due,
                                           inst_no,
                                           aging_id
                                      FROM giac_soa_rep_ext
                                     WHERE intm_no = REPLACE(v_intm_no, '#') --p_intm_no                         
                                       AND aging_id =  REPLACE(v_aging_id, '#') --p_aging_id
                                       AND user_id = p_user_id)
                        LOOP
                            /*v_detail.intm_name          := rec.intm_name;
                            v_detail.intm_no            := rec.intm_no;
                            v_detail.policy_no          := rec.policy;
                            v_detail.policy_no2         := rec.policy_no;
                            v_detail.iss_cd             := rec.iss_cd;
                            v_detail.prem_seq_no        := rec.prem_seq_no;
                            v_detail.prem_bal_due       := rec.prem_bal_due;
                            v_detail.tax_bal_due        := rec.tax_bal_due;
                            v_detail.balance_amt_due    := rec.balance_amt_due;
                            v_detail.inst_no            := rec.inst_no;
                            v_detail.endt_no            := rec.endt_no;*/
                            
                            --PIPE ROW(v_detail);
                            v_exists := 'Y';
                        END LOOP;    
                    
                    END IF;
                    
                END LOOP;
            
            ELSE --IF p_from_button = 'printCollectionLetterAging' THEN -- button = 'printCollectionLetter'
            
                v_intm_no := p_intm_no;
                
                FOR all_rec IN (SELECT DISTINCT aging_id aging_id
                                  FROM giac_soa_rep_ext
                                 WHERE intm_no = v_intm_no
                                   AND user_id = p_user_id)
                LOOP
                
                    v_aging_id := '#' || all_rec.aging_id || '#';
                    
                    IF INSTR(v_aging_list, v_aging_id) != 0 THEN
                        FOR rec IN (SELECT intm_name,
                                           intm_no,  
                                           policy_no policy, 
                                           (SUBSTR(POLICY_NO,1,(INSTR(POLICY_NO,'-',1,5)+1)))policy_no,  
                                           (SUBSTR(POLICY_NO,INSTR(POLICY_NO,'-',1,6)+1,LENGTH(POLICY_NO))) endt_no,
                                           iss_cd,
                                           prem_seq_no, 
                                           prem_bal_due,
                                           tax_bal_due,
                                           balance_amt_due,
                                           inst_no
                                      FROM giac_soa_rep_ext
                                     WHERE intm_no = v_intm_no                         
                                       AND aging_id = REPLACE(v_aging_id, '#')
                                       AND user_id = p_user_id)
                        LOOP
                            v_exists := 'Y';
                        END LOOP; 
                        
                    END IF;   -- end: INSTR 
                END LOOP;
            
            END IF;
        END IF;
        
        IF v_exists = 'Y' THEN
            RETURN (v_exists);
        ELSE
            raise_application_error(-20001, 'Geniisys Exception#I#No records with this age were fetched for this ' || v_label || '.');
        END IF;           

    END process_intm_assd2;
    
    -- for Reprint Collection Letter Button
    FUNCTION get_colln_letter(
        p_user_id           giac_colln_letter.user_id%TYPE
    ) RETURN soa_detail_tab PIPELINED
    IS
        v_letter        soa_detail_type;
    BEGIN
        FOR rec IN (SELECT coll_seq_no, coll_let_no, coll_year,
                           iss_cd, prem_seq_no, inst_no, 
                           bal_amt_due, user_id, last_update
                      FROM giac_colln_letter
                     WHERE user_id = p_user_id)
        LOOP
            v_letter.coll_seq_no        := rec.coll_seq_no;
            v_letter.coll_let_no        := rec.coll_let_no;
            v_letter.coll_year          := rec.coll_year;
            v_letter.iss_cd             := rec.iss_cd;
            v_letter.prem_seq_no        := rec.prem_seq_no;
            v_letter.inst_no            := rec.inst_no;
            v_letter.bill_no            := rec.iss_cd || '-' || TO_CHAR(rec.prem_seq_no) || '-' || TO_CHAR(rec.inst_no);             
            v_letter.balance_amt_due    := rec.bal_amt_due;
            v_letter.user_id            := rec.user_id;
            v_letter.last_update        := rec.last_update;
            v_letter.last_update2       := rec.last_update; --TO_CHAR(rec.last_update, 'mm-dd-yyyy');
        
            PIPE ROW(v_letter);
        END LOOP;    
    END get_colln_letter;
    
    -- used in Print button [populate_parameters A, C, E]
    FUNCTION fetch_parameters(
        p_iss_cd                  giac_soa_rep_ext.iss_cd%TYPE,
        p_prem_seq_no             giac_soa_rep_ext.prem_seq_no%TYPE,
        p_inst_no                 giac_soa_rep_ext.inst_no%TYPE,
        p_user_id                 giac_soa_rep_ext.user_id%TYPE
    ) RETURN soa_detail_tab PIPELINED
    IS
        v_params        soa_detail_type;
    BEGIN
        FOR rec IN (SELECT intm_name, 
                           intm_no,
                           assd_name,
                           assd_no,
                           policy_no
                      FROM giac_soa_rep_ext
                     WHERE prem_seq_no = p_prem_seq_no
                       AND iss_cd = p_iss_cd
                       AND inst_no = p_inst_no
                       AND USER_ID = p_user_id)
        LOOP
            v_params.intm_name      := rec.intm_name;
            v_params.intm_no        := rec.intm_no;
            v_params.assd_name      := rec.assd_name;
            v_params.assd_no        := rec.assd_no;
            v_params.policy_no      := rec.policy_no;
        
            PIPE ROW(v_params);
        END LOOP;    
    END fetch_parameters; 
    
    -- checks if user has data in extract table
    FUNCTION check_user_data(
        p_user_id           GIAC_SOA_REP_EXT.user_id%TYPE
    ) RETURN VARCHAR2
    IS
        v_user_data         VARCHAR2(2) := 'N';
    BEGIN
        FOR rec IN (SELECT 'Y' user_data
                      FROM GIAC_SOA_REP_EXT
                     WHERE user_id = p_user_id
                       AND ROWNUM = 1)
        LOOP
            v_user_data := NVL(rec.user_data, 'N');
            EXIT;
        END LOOP;
        
        RETURN (v_user_data);
    END check_user_data;
    
    PROCEDURE check_existing_report(
        p_report_id       giis_reports.report_id%TYPE
    ) IS    
        CURSOR rep IS
              SELECT report_id  ,
                     destype    ,
                     desname    ,
                     desformat  ,
                     paramform  ,
                     report_mode,
                     orientation
                FROM giis_reports
               WHERE report_id = p_report_id;
        v_report          rep%ROWTYPE;    
    BEGIN
        OPEN rep;
        FETCH rep INTO v_report;
        IF rep%NOTFOUND THEN
            raise_application_error(-20001, 'Geniisys Exception#E#No existing report ' || p_report_id || ' found in GIIS_REPORTS.');
            CLOSE rep;
        END IF;
        
        CLOSE rep;
    END check_existing_report;
    
    
    FUNCTION check_user_child_records(
        p_pdc_ext       VARCHAR2,
        p_user_id       GIAC_SOA_REP_EXT.user_id%TYPE
    ) RETURN VARCHAR2
    AS
        v_exists    VARCHAR2(1) := 'N';
    BEGIN
        IF p_pdc_ext = 'Y' THEN
            FOR i IN (SELECT 'Y'
                        FROM giac_soa_pdc_ext
                       WHERE user_id = p_user_id
                         AND rownum = 1)
            LOOP
                v_exists := 'Y';
                EXIT;
            END LOOP;
        ELSE
            FOR i IN (SELECT 'Y'
                        FROM giac_soa_rep_tax_ext
                       WHERE user_id = p_user_id
                         AND rownum = 1)
            LOOP
                v_exists := 'Y';
                EXIT;
            END LOOP;
        END IF;
        
        RETURN (v_exists);
    END check_user_child_records;

    FUNCTION get_giis_assured(
        p_user_id       VARCHAR2
    ) RETURN giis_assured_tab PIPELINED
    IS
      v_assured   giis_assured_type;
    BEGIN
        FOR i IN (SELECT DISTINCT assd_no
                    FROM GIAC_SOA_REP_EXT
                   WHERE user_id = p_user_id
                   ORDER BY assd_no)
        LOOP
            v_assured.assd_no := i.assd_no;
            v_assured.assd_name := NULL;
                             
            FOR j IN (SELECT assd_name
                        FROM giis_assured
                       WHERE assd_no = i.assd_no)
            LOOP
                v_assured.assd_name := j.assd_name;
                EXIT;
            END LOOP;
                             
            PIPE ROW (v_assured);
        END LOOP;

        RETURN;
    END get_giis_assured;
    
    
    FUNCTION get_giacs180_intm_lov(
        p_user_id       VARCHAR2
    ) RETURN intm_list_tab PIPELINED
    IS
        v_intm_list             intm_list_type;
    BEGIN
        FOR i IN (SELECT DISTINCT intm_no
                    FROM GIAC_SOA_REP_EXT
                   WHERE user_id = p_user_id
                   ORDER BY intm_no)
        LOOP
            v_intm_list.intm_no := i.intm_no;
            v_intm_list.intm_name := NULL;
                
            FOR j IN (SELECT intm_name
                        FROM giis_intermediary
                       WHERE intm_no = i.intm_no)
            LOOP
                 v_intm_list.intm_name := j.intm_name;
                 EXIT;
            END LOOP;
            
            PIPE ROW(v_intm_list);
        END LOOP;
    END get_giacs180_intm_lov; 
    
    
    FUNCTION add_to_collection(
        p_is_new_item   VARCHAR2,
        p_index         NUMBER,
        p_str           VARCHAR2
    ) RETURN NUMBER
    AS
        i       NUMBER;
    BEGIN                
        IF p_is_new_item = 'Y' THEN
            IF v_nt.COUNT = 0 THEN
                i := 0;
            ELSE
                i := v_nt.LAST + 1;
            END IF;
            /*v_nt.EXTEND;
            i := v_nt.LAST;*/
        ELSE
            i := p_index;
        END IF;
        
        IF v_nt.EXISTS(i) = TRUE THEN
            v_nt(i) := v_nt(i) || p_str;
        ELSE
            --raise_application_error(-20001, i);
            v_nt(i) := p_str;
        END IF;
        
        RETURN(i);
    END add_to_collection;
   

    FUNCTION get_coll_element(
        p_index     NUMBER
    ) RETURN CLOB
    AS
        v_str   CLOB;
    BEGIN
        IF v_nt.EXISTS(p_index) = TRUE THEN
            v_str := v_nt(p_index);
        END IF;
        
        RETURN(v_str);
    END get_coll_element;
    
    
    FUNCTION clob_to_table(
        p_value     clob,
        p_delimiter VARCHAR2
    ) RETURN sys.odcivarchar2list PIPELINED
    AS
       start_pos     PLS_INTEGER     := 0;
       end_pos       PLS_INTEGER     := 0;
       clob_length   PLS_INTEGER;
       str           VARCHAR2 (4000);
    BEGIN
       clob_length := DBMS_LOB.getlength (p_value);

       WHILE end_pos <= clob_length
       LOOP
          start_pos := end_pos + 1;
          end_pos := DBMS_LOB.INSTR (p_value, p_delimiter, start_pos, 1);

          IF end_pos <= 0 THEN
             end_pos := clob_length + 1;
          END IF;

          str := DBMS_LOB.SUBSTR (p_value, end_pos - start_pos, start_pos);
          PIPE ROW (str);
       END LOOP;
    END clob_to_table;
    
    
    PROCEDURE delete_coll_element(
        p_index     NUMBER
    )
    AS
    BEGIN
        IF v_nt.EXISTS(p_index) = TRUE THEN
            v_nt.DELETE(p_index);
        END IF;
        
    END delete_coll_element;
    
END GIACS180_PKG;
/
