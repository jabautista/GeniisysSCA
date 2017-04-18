CREATE OR REPLACE PACKAGE BODY CPI.giri_distfrps_wdistfrps_pkg
AS
    FUNCTION get_giri_frpslist (
        p_policy_id     gipi_polbasic.policy_id%TYPE
    )
        RETURN giri_distfrps_wdistfrps_tab PIPELINED
    IS
        v_frpslist      giri_distfrps_wdistfrps_type;

    BEGIN
        FOR i IN (SELECT par_id,line_cd||'-'||frps_yy||'-'||frps_seq_no frps_no,
                         line_cd||'-'||iss_cd||'-'||par_yy||'-'||par_seq_no||'-'||quote_seq_no par_no,
                         endt_iss_cd||'-'||endt_yy||'-'||endt_seq_no endorsement_no,
                         assd_name,eff_date,expiry_date,
                         dist_no,dist_seq_no,tsi_amt,tot_fac_tsi,
                         currency_desc,dist_flag,prem_amt,tot_fac_prem
                    FROM giri_distfrps_wdistfrps_v
                 )
        LOOP
            BEGIN
                SELECT ref_pol_no
                  INTO v_frpslist.ref_policy_no
                  FROM gipi_polbasic
                 WHERE policy_id = p_policy_id;
             EXCEPTION
            WHEN NO_DATA_FOUND THEN
               NULL;
            END;

            BEGIN
                SELECT rv_meaning
                  INTO v_frpslist.dist_desc
                  FROM cg_ref_codes
                 WHERE rv_domain = 'GIUW_POL_DIST.DIST_FLAG'
                 AND RV_LOW_VALUE = i.dist_flag;
             EXCEPTION
            WHEN NO_DATA_FOUND THEN
                NULL;
            END;

            BEGIN
                SELECT par_type
                  INTO v_frpslist.par_type
                  FROM gipi_parlist
                 WHERE par_id = i.par_id;

             EXCEPTION
            WHEN NO_DATA_FOUND THEN
                NULL;
            END;

            v_frpslist.par_id           := i.par_id;
            v_frpslist.frps_no          := i.frps_no;
            v_frpslist.par_no           := i.par_no;
            v_frpslist.endorsement_no   := i.endorsement_no;
            v_frpslist.policy_no        := get_policy_no(p_policy_id);
            v_frpslist.assd_name        := i.assd_name;
            v_frpslist.pack_policy_no   := get_pack_policy_no(p_policy_id);
            v_frpslist.eff_date         := i.eff_date;
            v_frpslist.expiry_date      := i.expiry_date;
            v_frpslist.dist_no          := i.dist_no;
            v_frpslist.dist_seq_no      := i.dist_seq_no;
            v_frpslist.tsi_amt          := i.tsi_amt;
            v_frpslist.tot_fac_tsi      := i.tot_fac_tsi;
            v_frpslist.currency_desc    := i.currency_desc;
            v_frpslist.dist_flag        := i.dist_flag;
            v_frpslist.prem_amt         := i.prem_amt;
            v_frpslist.tot_fac_prem     := i.tot_fac_prem;
            PIPE ROW (v_frpslist);
        END LOOP;

       RETURN;
    END get_giri_frpslist;
   end;
/


