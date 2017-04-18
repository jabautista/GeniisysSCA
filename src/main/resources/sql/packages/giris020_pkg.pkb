CREATE OR REPLACE PACKAGE BODY CPI.GIRIS020_PKG
AS

    /*
    ** Created by: Marie Kris Felipe
    ** Date Created: 09.11.2013
    ** Reference:   GIRIS020 - View Outward RI/Outstanding Broker Accounts
    ** Description: Gets the list of binder information based on the given ri_Cd
    */
    FUNCTION get_binder_list(
        p_ri_cd     GIRI_FRPS_OUTFACUL_PREM_V.ri_cd%TYPE,
        p_user_id   giis_users.user_id%TYPE
    ) RETURN outward_ri_tab PIPELINED
    IS
        v_detail        outward_ri_type;
    BEGIN
    
        FOR rec IN (SELECT ri_cd, line_cd, endt_iss_cd, endt_yy, endt_seq_no, frps_yy, frps_seq_no,
                           binder_yy, binder_seq_no,
                           bindeR_date, net_due, payments, balance, 
                           ri_prem_amt, ri_prem_vat, ri_comm_amt, ri_comm_vat,
                           assd_name, confirm_no, confirm_date,
                           line_cd || ' - ' || LTRIM(TO_CHAR(binder_yy, '09')) || ' - ' || LTRIM(TO_CHAR(binder_seq_no, '000009')) binder_no, 
                           line_cd || ' - ' || subline_cd || ' - ' || iss_cd || ' - ' || LTRIM(TO_CHAR(issue_yy, '09')) || ' - ' || LTRIM(TO_CHAR(pol_seq_no, '0000009')) || ' - ' || LTRIM(TO_CHAR(renew_no, '09')) policy_no,
                           endt_iss_cd || ' - ' || LTRIM(TO_CHAR(endt_yy, '09')) || ' - ' || LTRIM(TO_CHAR(endt_seq_no, '0000009')) endt_no,
                           line_cd || ' - ' || LTRIM(TO_CHAR(frps_yy, '09')) || ' - ' || LTRIM(TO_CHAR(frps_seq_no, '000000009')) frps_no  
                      FROM GIRI_FRPS_OUTFACUL_PREM_V
                     WHERE ri_cd = p_ri_cd
                       AND check_user_per_line2(line_cd, iss_cd, 'GIRIS020', p_user_id ) = 1
                       AND check_user_per_iss_cd2(line_cd, iss_cd, 'GIRIS020', p_user_id ) = 1 
                     ORDER BY line_cd, binder_yy, binder_seq_no)
        LOOP
            v_detail.ri_cd := rec.ri_cd;
            v_detail.line_cd := rec.line_cd;
            v_detail.endt_iss_cd := rec.endt_iss_cd;
            v_detail.endt_yy := rec.endt_yy;
            v_detail.endt_seq_no := rec.endt_seq_no;
            v_detail.frps_yy := rec.frps_yy;
            v_detail.frps_seq_no := rec.frps_seq_no;
            v_detail.binder_yy := rec.binder_yy;
            v_detail.binder_seq_no := rec.binder_seq_no;
            
            v_detail.binder_no := rec.binder_no;
            v_detail.bindeR_date_str := TO_CHAR(rec.bindeR_date, 'mm-dd-yyyy');
            v_detail.bindeR_date := rec.bindeR_date;
            v_detail.net_due := rec.net_due;
            v_detail.payments := rec.payments;
            v_detail.balance := rec.balance;
            v_detail.ri_prem_amt := rec.ri_prem_amt;
            v_detail.ri_prem_vat := rec.ri_prem_vat;
            v_detail.ri_comm_amt := rec.ri_comm_amt;
            v_detail.ri_comm_vat := rec.ri_comm_vat;
            v_detail.assd_name := rec.assd_name;
            v_detail.confirm_no := rec.confirm_no;
            v_detail.confirm_date := TO_CHAR(rec.confirm_date, 'mm-dd-yyyy');
            v_detail.policy_no := rec.policy_no;            
            v_detail.frps_no := rec.frps_no;
            
            IF rec.endt_seq_no <> 0 THEN
                v_detail.endt_no := rec.endt_no;
            END IF;
            
            IF rec.CONFIRM_NO IS NOT NULL THEN
                v_detail.w_confirmation := 'Y';
            ELSE
    	        v_detail.w_confirmation := 'N';
            END IF;
            
            PIPE ROW(v_detail);
        END LOOP;
    
    END get_binder_list;

END GIRIS020_PKG;
/


