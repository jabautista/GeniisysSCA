CREATE OR REPLACE PACKAGE BODY CPI.GIRIS012_PKG AS
   
   FUNCTION get_frps_lov (
      p_line_cd      VARCHAR2,
      p_frps_yy      VARCHAR2,
      p_frps_seq_no  VARCHAR2,
      p_eff_date     VARCHAR2,
      p_expiry_date  VARCHAR2,
      p_subline_cd   VARCHAR2,   
      p_iss_cd       VARCHAR2,
      p_issue_yy     VARCHAR2,
      p_pol_seq_no   VARCHAR2,
      p_renew_no     VARCHAR2,
      p_endt_iss_cd  VARCHAR2,
      p_endt_yy      VARCHAR2,
      p_endt_seq_no  VARCHAR2,
      p_assured      VARCHAR2,
      p_user_id      VARCHAR2
   )
      RETURN frps_lov_tab PIPELINED
   IS
      v_list frps_lov_type;
   BEGIN
      FOR i IN (SELECT line_cd, frps_yy, frps_seq_no, subline_cd,
                       iss_cd, issue_yy, pol_seq_no, renew_no, 
                       assured, eff_date, expiry_date, endt_iss_cd,
                       endt_yy, endt_seq_no
                  FROM giri_distfrps_v
                 WHERE line_cd LIKE DECODE(check_user_per_line2(line_cd, iss_cd,'GIRIS012', p_user_id),1,line_cd,NULL)
                   AND iss_cd LIKE DECODE(check_user_per_iss_cd2(line_cd,iss_cd,'GIRIS012', p_user_id),1,iss_cd,NULL)
                   AND UPPER(line_cd) LIKE UPPER(NVL(p_line_cd, line_cd))
                   AND frps_yy = NVL(p_frps_yy, frps_yy)
                   AND frps_seq_no = NVL(p_frps_seq_no, frps_seq_no)
                   AND TRUNC(eff_date) = NVL(TO_DATE(p_eff_date, 'mm-dd-yyyy'), TRUNC(eff_date))
                   AND TRUNC(expiry_date) = NVL(TO_DATE(p_expiry_date, 'mm-dd-yyyy'), TRUNC(expiry_date))
                   AND UPPER(subline_cd) LIKE UPPER(NVL(p_subline_cd, subline_cd))
                   AND UPPER(iss_cd) LIKE UPPER(NVL(p_iss_cd, iss_cd))
                   AND issue_yy = NVL(p_issue_yy, issue_yy)
                   AND pol_seq_no = NVL(p_pol_seq_no, pol_seq_no)
                   AND renew_no = NVL(p_renew_no, renew_no)
                   AND UPPER(endt_iss_cd) LIKE UPPER(NVL(p_endt_iss_cd, endt_iss_cd))
                   AND endt_yy = NVL(p_endt_yy, endt_yy)
                   AND endt_seq_no = NVL(p_endt_seq_no, endt_seq_no)
                   AND UPPER(assured) LIKE UPPER(NVL(p_assured, assured)))
      LOOP
         v_list.line_cd := i.line_cd;    
         v_list.frps_yy := i.frps_yy;    
         v_list.frps_seq_no := i.frps_seq_no;
         v_list.subline_cd := i.subline_cd; 
         v_list.iss_cd := i.iss_cd;     
         v_list.issue_yy := i.issue_yy;   
         v_list.pol_seq_no := i.pol_seq_no; 
         v_list.renew_no := i.renew_no;   
         v_list.assured := i.assured;    
         v_list.eff_date   := i.eff_date;   
         v_list.expiry_date := i.expiry_date;
         v_list.endt_iss_cd := i.endt_iss_cd;
         v_list.endt_yy := i.endt_yy;    
         v_list.endt_seq_no := i.endt_seq_no;
      
         PIPE ROW(v_list);
      END LOOP;
   END get_frps_lov;
   
   FUNCTION populate_main_tg (
      p_line_cd      VARCHAR2,
      p_frps_yy      VARCHAR2,
      p_frps_seq_no  VARCHAR2,
      p_user_id      VARCHAR2   
   )
      RETURN main_tg_tab PIPELINED
   IS
      v_list main_tg_type;
   BEGIN
      FOR i IN(SELECT a.line_cd line_cd, a.frps_yy frps_yy, a.frps_seq_no frps_seq_no,
                      a.fnl_binder_id fnl_binder_id, NVL (a.ri_prem_amt, 0) ri_prem_amt,
                      NVL (a.prem_tax, 0) prem_tax, a.ri_cd ri_cd, b.ri_sname ri_sname2,
                         c.line_cd
                      || '-'
                      || TO_CHAR (c.binder_yy, '09')
                      || '-'
                      || TO_CHAR (c.binder_seq_no, '09999') binder_no,
                      DECODE (local_foreign_sw,
                              'L', NVL ((  (c.ri_prem_amt + NVL (c.ri_prem_vat, 0))
                                         - (c.ri_comm_amt + NVL (c.ri_comm_vat, 0))
                                        ),
                                        0
                                       ),
                                NVL ((  (c.ri_prem_amt + NVL (c.ri_prem_vat, 0))
                                      - (c.ri_comm_amt + NVL (c.ri_comm_vat, 0))
                                     ),
                                     0
                                    )
                              - NVL (c.ri_wholding_vat, 0)
                             ) net_due,
                      c.ri_comm_amt ri_comm_amt,
                      NVL (get_outfacul_tot_amt (d.line_cd,
                                                 b.ri_cd,
                                                 c.fnl_binder_id,
                                                 frps_yy,
                                                 frps_seq_no
                                                ),
                           0
                          ) total_amt_paid,
                        DECODE (local_foreign_sw,
                                'L', NVL ((  (c.ri_prem_amt + NVL (c.ri_prem_vat, 0))
                                           - (c.ri_comm_amt + NVL (c.ri_comm_vat, 0))
                                          ),
                                          0
                                         ),
                                  NVL ((  (c.ri_prem_amt + NVL (c.ri_prem_vat, 0))
                                        - (c.ri_comm_amt + NVL (c.ri_comm_vat, 0))
                                       ),
                                       0
                                      )
                                - NVL (c.ri_wholding_vat, 0)
                               )
                      - NVL (get_outfacul_tot_amt (d.line_cd,
                                                   b.ri_cd,
                                                   c.fnl_binder_id,
                                                   a.frps_yy,
                                                   a.frps_seq_no
                                                  ),
                             0
                            ) disbursement_amt
                 FROM giri_frps_ri a, giis_reinsurer b, giri_binder c, giis_line d
                WHERE 1 = 1
                  AND NVL (a.reverse_sw, 'N') = 'N'
                  AND NVL (a.delete_sw, 'N') = 'N'
                  AND a.ri_cd = b.ri_cd
                  AND c.fnl_binder_id = a.fnl_binder_id
                  AND c.line_cd = a.line_cd
                  AND a.line_cd = d.line_cd
                  AND a.line_cd = p_line_cd
                  AND a.frps_yy = p_frps_yy
                  AND a.frps_seq_no = p_frps_seq_no)
      LOOP
         v_list.binder_no := i.binder_no;
         v_list.ri_sname2 := i.ri_sname2;
         v_list.net_due := i.net_due;
         v_list.tot_amt_paid := i.total_amt_paid;
         v_list.disbursement_amt := i.disbursement_amt;
         v_list.line_cd := i.line_cd;
         v_list.frps_yy := i.frps_yy;
         v_list.frps_seq_no := i.frps_seq_no;
         v_list.fnl_binder_id := i.fnl_binder_id;
         v_list.ri_prem_amt := i.ri_prem_amt;
         v_list.ri_comm_amt := i.ri_comm_amt;
         v_list.prem_tax := i.prem_tax;
         v_list.ri_cd := i.ri_cd;
         
         BEGIN
            SELECT DISTINCT ROUND(convert_rate * i.net_due, 2)
              INTO v_list.net_due_computed
              FROM giac_outfacul_prem_payts
             WHERE d010_fnl_binder_id = i.fnl_binder_id;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               SELECT currency_rt * i.net_due
                 INTO v_list.net_due_computed
                 FROM giri_distfrps
                WHERE line_cd  = i.line_cd
                  AND frps_yy = i.frps_yy
                  AND frps_seq_no = i.frps_seq_no;
         END;
         
         v_list.balance := v_list.net_due_computed - v_list.tot_amt_paid;
         
--         v_list.ri_sname
--         v_list.frps_no
      
         PIPE ROW(v_list);
      END LOOP;
   END populate_main_tg;
   
   FUNCTION get_details (
      p_fnl_binder_id   VARCHAR2
   )
      RETURN details_tab PIPELINED
   IS
      v_list details_type;
   BEGIN
      FOR i IN (SELECT gacc.tran_class, get_ref_no (gacc.tran_id) ref_no,
                       gacc.tran_date pay_date, gopp.disbursement_amt disbursement_amt,
                       gopp.d010_fnl_binder_id d010_fnl_binder_id, gacc.tran_id gacc_tran_id
                  FROM giac_disb_vouchers gidv,
                       giac_order_of_payts giop,
                       giac_acctrans gacc,
                       giac_outfacul_prem_payts gopp
                 WHERE 1 = 1
                   AND gopp.d010_fnl_binder_id = p_fnl_binder_id
                   AND gopp.gacc_tran_id = gacc.tran_id
                   AND gacc.tran_id = giop.gacc_tran_id(+)
                   AND gacc.tran_id = gidv.gacc_tran_id(+)
                   AND get_ref_no (gacc.tran_id) IS NOT NULL
                   AND gacc.tran_flag <> 'D'
                   AND NOT EXISTS (
                          SELECT c.gacc_tran_id
                            FROM giac_reversals c, giac_acctrans d
                           WHERE c.reversing_tran_id = d.tran_id
                             AND d.tran_flag <> 'D'
                             AND c.gacc_tran_id = gidv.gacc_tran_id)
                UNION
                SELECT gacc.tran_class, get_payment_request_no (gacc.tran_id) ref_no,
                       request_date pay_date, gopp.disbursement_amt disbursement_amt,
                       gopp.d010_fnl_binder_id d010_fnl_binder_id, gacc.tran_id gacc_tran_id
                  FROM giac_acctrans gacc,
                       giac_outfacul_prem_payts gopp,
                       giac_payt_requests_dtl gprd,
                       giac_payt_requests gprq
                 WHERE 1 = 1
                   AND gopp.d010_fnl_binder_id = p_fnl_binder_id
                   AND gacc.tran_id = gopp.gacc_tran_id
                   AND gacc.tran_id = gprd.tran_id
                   AND gprq.ref_id = gprd.gprq_ref_id
                   AND NVL (gprq.with_dv, 'N') = 'N'
                   AND gacc.tran_flag <> 'D'
                   AND NOT EXISTS (
                          SELECT c.gacc_tran_id
                            FROM giac_reversals c, giac_acctrans d
                           WHERE c.reversing_tran_id = d.tran_id
                             AND d.tran_flag <> 'D'
                             AND c.gacc_tran_id = gprd.tran_id))
      LOOP
         v_list.gacc_tran_id := i.gacc_tran_id;
         v_list.d010_fnl_binder_id := i.d010_fnl_binder_id;
         v_list.tran_class := i.tran_class;
         v_list.ref_no := i.ref_no;
         v_list.pay_date := i.pay_date;
         v_list.disbursement_amt := i.disbursement_amt;
         PIPE ROW(v_list);
      END LOOP;
   END get_details;      
      
END;
/


