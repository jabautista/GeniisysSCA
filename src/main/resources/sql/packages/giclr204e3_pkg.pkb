CREATE OR REPLACE PACKAGE BODY CPI.GICLR204E3_PKG AS
FUNCTION populate_prem_writn_priod(
    p_session_id    gicl_lratio_curr_prem_ext.SESSION_ID%TYPE,
    p_curr_start_date   varchar2,
    p_curr_end_date     varchar2,
    p_print_date        varchar2
)
RETURN prem_writn_priod_tab PIPELINED as 

    v_rec prem_writn_priod_type;
BEGIN
    FOR a IN(
        SELECT  b.assd_no,
                a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||LTRIM (TO_CHAR (a.issue_yy, '09'))||'-'||LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))||'-'||LTRIM (TO_CHAR (a.renew_no, '09')) policy_no, 
                a.endt_iss_cd, 
                a.policy_id,
                a.endt_yy, 
                a.endt_seq_no, 
                a.incept_date, 
                a.expiry_date, 
                a.tsi_amt, 
                SUM(b.prem_amt) sum_prem_amt, 
                c.assd_name, 
                TO_CHAR(date_for_24th,'MONTH YYYY') transaction_month,
                'PREMIUMS WRITTEN FOR '|| p_curr_start_date || ' TO ' ||  p_curr_end_date time_period
            FROM    gipi_polbasic a, 
                    gicl_lratio_curr_prem_ext b, 
                    giis_assured c
            WHERE   b.policy_id = a.policy_id
            AND     b.assd_no = c.assd_no (+)
            AND     b.session_id = p_session_id
            GROUP BY    b.assd_no, 
                        'PREMIUMS WRITTEN FOR '|| p_curr_start_date || ' TO ' ||  p_curr_end_date, 
                        a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||LTRIM (TO_CHAR (a.issue_yy, '09'))||'-'||LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))||'-'||LTRIM (TO_CHAR (a.renew_no, '09')), 
                        a.endt_iss_cd, 
                        a.policy_id,
                        a.endt_yy, 
                        a.endt_seq_no, 
                        a.incept_date, 
                        a.expiry_date, 
                        a.tsi_amt, 
                        c.assd_name, 
                        TO_CHAR(date_for_24th,'MONTH YYYY')
            ORDER BY    TO_CHAR(date_for_24th,'MONTH YYYY') DESC, 
                        policy_no



        )
        LOOP
            v_rec.assd_no           :=  a.assd_no; 
            v_rec.policy_no         :=  a.policy_no;
            v_rec.endt_iss_cd       :=  a.endt_iss_cd;
            v_rec.endt_yy           :=  a.endt_yy;
            v_rec.endt_seq_no       :=  a.endt_seq_no;     
            v_rec.incept_date       :=  a.incept_date ;    
            v_rec.expiry_date       :=  a.expiry_date;       
            v_rec.tsi_amt           :=  a.tsi_amt;
            v_rec.sum_prem_amt      :=  a.sum_prem_amt;   
            v_rec.assd_name         :=  a.assd_name;              
            v_rec.policy_id         :=  a.policy_id;  
            v_rec.header_date       := a.time_period;
            v_rec.v_date            := GICLR204E3_PKG.GET_DATEVALUE(p_print_date,a.policy_id);
            v_rec.transaction_month  := a.transaction_month;
            PIPE ROW (v_rec);
            
        END LOOP;
        
       
 
END populate_prem_writn_priod;

FUNCTION populate_prem_writn_year(
    p_session_id  gicl_lratio_curr_prem_ext.SESSION_ID%TYPE,
    p_prev_year   varchar2,
    p_print_date  varchar2
)
RETURN prem_writn_year_tab PIPELINED as 

    v_rec prem_writn_year_type;
BEGIN
    FOR a IN(
        SELECT      b.assd_no, 
                    a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||LTRIM (TO_CHAR (a.issue_yy, '09'))||'-'||LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))||'-'||LTRIM (TO_CHAR (a.renew_no, '09')) policy_no, 
                    a.endt_iss_cd, 
                    a.endt_yy, 
                    a.endt_seq_no, 
                    a.incept_date, 
                    a.expiry_date, 
                    a.tsi_amt, 
                    SUM(b.prem_amt) sum_prem_amt,
                    c.assd_name, 
                    a.policy_id,
                    TO_CHAR(date_for_24th,'MONTH YYYY') transaction_month,
                    'PREMIUMS WRITTEN FOR THE YEAR ' ||  p_prev_year time_period
        FROM        gipi_polbasic a, 
                    gicl_lratio_prev_prem_ext b,
                    giis_assured c
        WHERE       b.policy_id = a.policy_id
        AND         b.assd_no = c.assd_no (+)
        AND         b.session_id = p_session_id
        GROUP BY    b.assd_no, a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||LTRIM (TO_CHAR (a.issue_yy, '09'))||'-'||LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))||'-'||LTRIM (TO_CHAR (a.renew_no, '09')), 
                    a.endt_iss_cd, 
                    a.endt_yy, 
                    a.endt_seq_no, 
                    a.incept_date, 
                    a.expiry_date, 
                    a.tsi_amt, 
                    c.assd_name, 
                    a.policy_id,
                    TO_CHAR(date_for_24th,'MONTH YYYY'),
                    'PREMIUMS WRITTEN FOR THE YEAR ' ||  p_prev_year 
        ORDER BY    TO_CHAR(date_for_24th,'MONTH YYYY') DESC, policy_no


        )
        LOOP
            v_rec.assd_no           :=  a.assd_no; 
            v_rec.policy_no         :=  a.policy_no;
            v_rec.endt_iss_cd       :=  a.endt_iss_cd;
            v_rec.endt_yy           :=  a.endt_yy;
            v_rec.endt_seq_no       :=  a.endt_seq_no;     
            v_rec.incept_date       :=  a.incept_date ;    
            v_rec.expiry_date       :=  a.expiry_date;       
            v_rec.tsi_amt           :=  a.tsi_amt;
            v_rec.sum_prem_amt      :=  a.sum_prem_amt;   
            v_rec.assd_name         :=  a.assd_name;              
            v_rec.policy_id         :=  a.policy_id;  
            v_rec.header_date       := a.time_period;
            v_rec.v_date            := GICLR204E3_PKG.GET_DATEVALUE(p_print_date,a.policy_id);
            v_rec.transaction_month  := a.transaction_month;
            
            PIPE ROW (v_rec);
            
        END LOOP;
        
       
 
END populate_prem_writn_year;

FUNCTION populate_outstndng_loss_as_of(
    p_session_id    gicl_lratio_curr_prem_ext.SESSION_ID%TYPE,
    p_curr_end_date varchar2
)
RETURN outstndng_loss_as_of_tab PIPELINED as 

    v_rec outstndng_loss_as_of_type;
BEGIN
    FOR a IN(
            SELECT  a.assd_no, 
                    d.assd_name,
                    a.assd_no ||'-'||        d.assd_name assured, 
                    a.claim_id, 
                    SUM(os_amt) sum_os_amt, 
                    b.dsp_loss_date, 
                    b.clm_file_date, 
                    b.line_cd||'-'||b.subline_cd||'-'||b.iss_cd||'-'||LTRIM(TO_CHAR(b.clm_yy, '09'))||'-'||LTRIM(TO_CHAR(b.clm_seq_no, '0000009'))  claim_no,
                    'OUTSTANDING LOSS AS OF ' ||  p_curr_end_date  time_period
            FROM    gicl_lratio_curr_os_ext a, 
                    gicl_claims b, 
                    giis_assured d
            WHERE   a.session_id = p_session_id
            AND     a.claim_id = b.claim_id 
            AND     a.assd_no = d.assd_no
            GROUP BY    a.assd_no, 
                        d.assd_name, 
                        a.claim_id, 
                        b.dsp_loss_date, 
                        b.clm_file_date,
                        b.line_cd||'-'||b.subline_cd||'-'||b.iss_cd||'-'||LTRIM(TO_CHAR(b.clm_yy, '09'))||'-'||LTRIM(TO_CHAR(b.clm_seq_no, '0000009')),
                        'OUTSTANDING LOSS AS OF ' ||  p_curr_end_date 
            ORDER BY claim_no


            )
        LOOP
                     
            v_rec.assd_no   :=  a.assd_no;     
            v_rec.claim_no  :=  a.claim_no;
            v_rec.os_amt    :=  a.sum_os_amt;
            v_rec.assd_name :=  a.assd_name;
            v_rec.header_date   :=  a.time_period;        
            v_rec.assured :=  a.assured;   
            v_rec.claim_id  :=  a.claim_id;
            v_rec.dsp_loss_date := a.dsp_loss_date;
            v_rec.clm_file_date := a.clm_file_date;

            PIPE ROW (v_rec);
            
        END LOOP;
        
       
 
END populate_outstndng_loss_as_of;


FUNCTION populate_outstndng_loss_prev(
    p_session_id    gicl_lratio_curr_prem_ext.SESSION_ID%TYPE,
    p_prev_end_date varchar2
)
RETURN outstndng_loss_as_of_tab PIPELINED as 

    v_rec outstndng_loss_as_of_type;
BEGIN
    FOR a IN(
                SELECT  a.assd_no ||' - '||d.assd_name assured,
                        a.assd_no, 
                        d.assd_name, 
                        a.claim_id, SUM(os_amt) sum_os_amt, 
                        b.dsp_loss_date, 
                        b.clm_file_date, 
                        b.line_cd||'-'||b.subline_cd||'-'||b.iss_cd||'-'||LTRIM(TO_CHAR(b.clm_yy, '09'))||'-'||LTRIM(TO_CHAR(b.clm_seq_no, '0000009'))  claim_no,
                        a.session_id,
                        'OUTSTANDING LOSS AS OF' ||p_prev_end_date  time_period
                FROM    gicl_lratio_prev_os_ext a, gicl_claims b, giis_assured d
                WHERE   a.claim_id = b.claim_id 
                AND     a.assd_no = d.assd_no
                AND     a.session_id = p_session_id
                GROUP BY    a.assd_no,
                            a.session_id, 
                            d.assd_name, 
                            a.claim_id, 
                            b.dsp_loss_date, 
                            b.clm_file_date,b.line_cd||'-'||b.subline_cd||'-'||b.iss_cd||'-'||LTRIM(TO_CHAR(b.clm_yy, '09'))||'-'||LTRIM(TO_CHAR(b.clm_seq_no, '0000009')),
                            'OUTSTANDING LOSS AS OF' ||p_prev_end_date     
                ORDER BY claim_no


             )
        LOOP
                     
            v_rec.assd_no   :=  a.assd_no;     
            v_rec.claim_no  :=  a.claim_no;
            v_rec.os_amt    :=  a.sum_os_amt;
            v_rec.assd_name :=  a.assd_name;
            v_rec.header_date   :=  a.time_period;        
            v_rec.assured   :=  a.assured;   
            v_rec.claim_id  :=  a.claim_id;
            v_rec.dsp_loss_date := a.dsp_loss_date;
            v_rec.clm_file_date := a.clm_file_date;

            PIPE ROW (v_rec);
            
        END LOOP;
        
END populate_outstndng_loss_prev;



FUNCTION populate_losses_pd_curr_year(
    p_session_id    gicl_lratio_curr_prem_ext.SESSION_ID%TYPE,
    p_curr_year      varchar
)
RETURN losses_pd_curr_year_tab PIPELINED as 

    v_rec losses_pd_curr_year_type;
BEGIN
    FOR a IN(
            SELECT  a.assd_no, 
                    c.assd_name, 
                    b.line_cd||'-'||b.subline_cd||'-'||b.iss_cd||'-'||LTRIM(TO_CHAR(b.clm_yy, '09'))||'-'||LTRIM(TO_CHAR(b.clm_seq_no, '0000009'))  claim_no,
                    b.dsp_loss_date, 
                    SUM(a.loss_paid) sum_loss_paid,
                    'LOSSES PAID FOR THE YEAR ' ||  p_curr_year time_period  
            FROM    gicl_lratio_loss_paid_ext a, 
                    gicl_claims b, 
                    giis_assured c
            WHERE   a.session_id = p_session_id
            AND     a.assd_no = c.assd_no
            AND     a.claim_id = b.claim_id
            GROUP BY    a.assd_no, 
                        c.assd_name, 
                        b.line_cd||'-'||b.subline_cd||'-'||b.iss_cd||'-'||LTRIM(TO_CHAR(b.clm_yy, '09'))||'-'||LTRIM(TO_CHAR(b.clm_seq_no, '0000009')),
                        b.dsp_loss_date,
                        'LOSSES PAID FOR THE YEAR ' ||  p_curr_year  
            ORDER BY claim_no
        )
        LOOP
            v_rec.assd_no   :=  a.assd_no;     
            v_rec.claim_no  :=  a.claim_no;
            v_rec.sum_loss_paid    :=  a.sum_loss_paid;
            v_rec.assd_name :=  a.assd_name;
            v_rec.header_date   :=  a.time_period;        
            v_rec.dsp_loss_date := a.dsp_loss_date;
            
            PIPE ROW (v_rec);
            
        END LOOP;
        
END populate_losses_pd_curr_year;


FUNCTION populate_loss_recovery_period(
    p_session_id    gicl_lratio_curr_prem_ext.SESSION_ID%TYPE,
    p_curr_start_dt varchar2,
    p_curr_end_dt varchar2
)
RETURN loss_recovery_period_tab PIPELINED as 

    v_rec loss_recovery_period_type;
BEGIN
    FOR a IN(
            SELECT      a.assd_no, 
                        b.assd_name, 
                        d.rec_type_desc, 
                        SUM(a.recovered_amt) sum_recovered_amt, 
                        e.dsp_loss_date,       
                        c.line_cd||'-'||c.iss_cd||'-'||LTRIM(TO_CHAR(rec_year,'0999'))||'-'||LTRIM(TO_CHAR(rec_seq_no, '009')) recovery_no,
                        'LOSS RECOVERY FOR THE PERIOD ' || P_CURR_START_DT || ' TO ' ||  P_CURR_END_DT time_period
            FROM        gicl_lratio_curr_recovery_ext a, 
                        giis_assured b, 
                        gicl_clm_recovery c, 
                        giis_recovery_type d,
                        gicl_claims e
            WHERE       a.assd_no = b.assd_no
            AND         a.recovery_id = c.recovery_id
            AND         c.rec_type_cd = d.rec_type_cd
            AND         c.claim_id = e.claim_id
            AND         a.session_id = p_session_id
            GROUP BY    a.assd_no, 
                        b.assd_name, 
                        d.rec_type_desc, 
                        e.dsp_loss_date,       
                        c.line_cd||'-'||c.iss_cd||'-'||LTRIM(TO_CHAR(rec_year,'0999'))||'-'||LTRIM(TO_CHAR(rec_seq_no, '009')),
                        'LOSS RECOVERY FOR THE PERIOD ' || P_CURR_START_DT || ' TO ' ||  P_CURR_END_DT
            ORDER BY    recovery_no


            )
        LOOP
            v_rec.assd_name   :=  a.assd_name;   
            v_rec.assd_no       :=  a.assd_no;  
            v_rec.rec_type_desc := a.rec_type_desc;
            v_rec.recovery_no   := a.recovery_no;
            v_rec.sum_recovered_amt    :=  a.sum_recovered_amt;
            v_rec.dsp_loss_date := a.dsp_loss_date;
            v_rec.header_date   :=  a.time_period;
            
            PIPE ROW (v_rec);
            
        END LOOP;
END populate_loss_recovery_period;

FUNCTION populate_loss_recovery_year(
    p_session_id    gicl_lratio_curr_prem_ext.SESSION_ID%TYPE,
    p_prev_year number
)
RETURN loss_recovery_year_tab PIPELINED as 

    v_rec loss_recovery_year_type;
BEGIN
    FOR a IN(
            SELECT      a.assd_no, 
                        b.assd_name, 
                        d.rec_type_desc, 
                        SUM(a.recovered_amt) sum_recovered_amt, 
                        e.dsp_loss_date,       
                        c.line_cd||'-'||c.iss_cd||'-'||LTRIM(TO_CHAR(rec_year,'0999'))||'-'||LTRIM(TO_CHAR(rec_seq_no, '009')) recovery_no,
                        'LOSS RECOVERY FOR THE YEAR ' || p_prev_year time_period
            FROM        gicl_lratio_prev_recovery_ext a, 
                        giis_assured b, 
                        gicl_clm_recovery c, 
                        giis_recovery_type d,
                        gicl_claims e
            WHERE       a.assd_no = b.assd_no
            AND         a.recovery_id = c.recovery_id
            AND         c.rec_type_cd = d.rec_type_cd
            AND         c.claim_id = e.claim_id
            AND         a.session_id = p_session_id
            GROUP BY    a.assd_no, 
                        b.assd_name, 
                        d.rec_type_desc, 
                        e.dsp_loss_date,       
                        c.line_cd||'-'||c.iss_cd||'-'||LTRIM(TO_CHAR(rec_year,'0999'))||'-'||LTRIM(TO_CHAR(rec_seq_no, '009')),
                        'LOSS RECOVERY FOR THE YEAR ' || p_prev_year 
            ORDER BY    recovery_no

         
    
            )
        LOOP
            v_rec.assd_no     :=  a.assd_no;
            v_rec.recovery_no   := a.recovery_no;       
            v_rec.assd_name   :=  a.assd_name;     
            v_rec.rec_type_desc := a.rec_type_desc;
            v_rec.sum_recovered_amt    :=  a.sum_recovered_amt;
            v_rec.dsp_loss_date := a.dsp_loss_date;
            v_rec.header_date   :=  a.time_period;
            
            PIPE ROW (v_rec);
            
        END LOOP;
END populate_loss_recovery_year;

FUNCTION populate_main
RETURN main_tab PIPELINED as 

    v_rec main_type;
BEGIN
            v_rec.company_name      :=  giacp.v('COMPANY_NAME');
            v_rec.company_address   :=  giacp.v('COMPANY_ADDRESS');
            PIPE ROW (v_rec);
    
            
    
END populate_MAIN;


FUNCTION get_datevalue(
    p_prnt_date     varchar2,
    p_policy_id       GIPI_POLBASIC.POLICY_ID%TYPE
)
RETURN varchar2 as
    v_date      varchar2(50);   
BEGIN
    IF p_prnt_date = '1' THEN
       SELECT to_char(issue_date,'MM-DD-RRRR') into v_date
                     FROM gipi_polbasic
                    WHERE policy_id = p_policy_id;
       return(v_date);
  ELSIF p_prnt_date = '3' THEN
       SELECT TO_CHAR(acct_ent_date,'MM-DD-RRRR') into v_date
                     FROM gipi_polbasic
                    WHERE policy_id = p_policy_id;
  return(v_date);
  ELSIF p_prnt_date = '4' THEN
       SELECT booking_mth||' '||TO_CHAR(booking_year) into v_date
                     FROM gipi_polbasic
                    WHERE policy_id = p_policy_id;
    return(v_date);                    
  ELSE
     return (null);
  END IF;  
END  get_datevalue;

END GICLR204E3_PKG;
/


