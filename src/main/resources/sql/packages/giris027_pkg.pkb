CREATE OR REPLACE PACKAGE BODY CPI.giris027_pkg
AS   
   FUNCTION get_ri_lov
      RETURN ri_lov_tab PIPELINED
   IS
      v_list ri_lov_type;
   BEGIN
      FOR i IN(SELECT DISTINCT ri_cd, ri_name
                 FROM giis_reinsurer
                WHERE ri_cd IN (SELECT ri_cd
                                  FROM giri_inpolbas
                             UNION ALL
                                SELECT ri_cd
                                  FROM giri_winpolbas)
                ORDER BY ri_name)
      LOOP
         v_list.ri_cd := i.ri_cd;
         v_list.ri_name := i.ri_name;
         PIPE ROW(v_list);
      END LOOP;                
   END get_ri_lov;
   
   FUNCTION populate_giris027 (
      p_ri_cd VARCHAR2,
      p_user_id VARCHAR2
   )
      RETURN giris027_tab PIPELINED
   IS
      v_list giris027_type;
   BEGIN
      FOR i IN (SELECT a.par_id, line_cd, iss_cd, par_yy, par_seq_no, quote_seq_no, par_status,
                       b.accept_date, b.accept_no, b.assd_no, c.assd_name,
                       b.accept_by, b.ri_cd, b.ref_accept_no, b.writer_cd, d.ri_name,
                       b.ri_policy_no, b.ri_binder_no, b.ri_endt_no, b.offer_date,
                       b.offered_by, b.amount_offered, b.orig_tsi_amt, b.orig_prem_amt,
                       b.remarks
                  FROM gipi_parlist a,
                       (SELECT b.par_id, accept_date,
                               accept_no, b.assd_no, accept_by, ri_cd, ref_accept_no,
                               writer_cd, ri_policy_no, ri_binder_no, ri_endt_no,
                               offer_date, offered_by, amount_offered, orig_tsi_amt,
                               orig_prem_amt, a.remarks
                          FROM giri_inpolbas a, gipi_polbasic b
                         WHERE a.policy_id = b.policy_id
                           AND ri_cd = p_ri_cd
                        UNION
                        SELECT a.par_id, accept_date, accept_no, b.assd_no,
                               accept_by, ri_cd, ref_accept_no, writer_cd, ri_policy_no,
                               ri_binder_no, ri_endt_no, offer_date, offered_by,
                               amount_offered, orig_tsi_amt, orig_prem_amt, a.remarks
                          FROM giri_winpolbas a, gipi_parlist b
                         WHERE a.par_id = b.par_id
                           AND a.ri_cd = p_ri_cd
                           ) b,
                       giis_assured c,
                       giis_reinsurer d
                  WHERE a.par_id = b.par_id
                   AND b.assd_no = c.assd_no
                   AND b.writer_cd = d.ri_cd(+)
                   AND check_user_per_line2 (line_cd, iss_cd, 'GIRIS027', p_user_id) = 1
              ORDER BY line_cd, iss_cd, par_yy, par_seq_no, quote_seq_no)
      LOOP
         v_list.line_cd := i.line_cd;
         v_list.iss_cd := i.iss_cd;
         v_list.par_yy := i.par_yy;
         v_list.par_seq_no := i.par_seq_no;
         v_list.quote_seq_no := i.quote_seq_no;
         v_list.par_status := i.par_status;
         v_list.accept_date := i.accept_date;
         v_list.accept_no := i.accept_no;
         v_list.assd_no := i.assd_no;
         v_list.assd_name := i.assd_name;
         v_list.accept_by := i.accept_by;
         v_list.ri_cd := i.ri_cd;
         v_list.ref_accept_no := i.ref_accept_no;
         v_list.writer_cd := i.writer_cd;
         v_list.ri_name := i.ri_name;
         v_list.ri_policy_no := i.ri_policy_no;
         v_list.ri_binder_no := i.ri_binder_no;
         v_list.ri_endt_no := i.ri_endt_no;
         v_list.offer_date := i.offer_date;
         v_list.offered_by := i.offered_by;
         v_list.amount_offered := i.amount_offered;
         v_list.orig_tsi_amt := i.orig_tsi_amt;
         v_list.orig_prem_amt := i.orig_prem_amt;
         v_list.remarks := i.remarks;
         
         BEGIN
            SELECT get_policy_no (policy_id)
              INTO v_list.policy_no
              FROM gipi_polbasic
             WHERE par_id = i.par_id;
         EXCEPTION WHEN NO_DATA_FOUND THEN
            v_list.policy_no := NULL;     
         END;

         PIPE ROW(v_list);
      END LOOP;
   END populate_giris027;
   
END GIRIS027_PKG;
/


