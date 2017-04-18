CREATE OR REPLACE PACKAGE BODY CPI.gicls273_pkg
AS
   FUNCTION get_rec_list (
      p_search_by   VARCHAR2, 
      p_as_of_date  VARCHAR2, 
      p_from_date   VARCHAR2, 
      p_to_date     VARCHAR2, 
      p_user_id     VARCHAR2
   )
      RETURN rec_tab PIPELINED
   IS
      v_list         rec_type;
      
      TYPE cur_type IS REF CURSOR;

      TYPE tot_type IS REF CURSOR;

      
      rec            cur_type;
      total          tot_type;
      v_temp         VARCHAR2 (3200);
      v_query        VARCHAR2 (3200);
      v_tot_query    VARCHAR2 (3200);
      v_column       VARCHAR2 (3200);
      v_search       VARCHAR2 (3200);
      v_loss         VARCHAR2 (3200);                                                                                                                                              --basis is loss date
      v_claim        VARCHAR2 (3200);                                                                                                                                        --basis is claim file date
      v_loss_pd      NUMBER              := 0;
      v_loss_res     NUMBER              := 0;
      v_exp_pd       NUMBER              := 0;
      v_exp_res      NUMBER              := 0;
      v_as_of_date   DATE;
      v_from_date    DATE;
      v_to_date      DATE;
      
   BEGIN
      IF p_search_by IS NOT NULL THEN
          v_as_of_date  := NVL (TO_DATE (p_as_of_date, 'MM-DD-RRRR'), NULL);
          v_from_date   := NVL (TO_DATE (p_from_date, 'MM-DD-RRRR'), NULL);
          v_to_date     := NVL (TO_DATE (p_to_date, 'MM-DD-RRRR'), NULL);
          
          v_column :=
             'SELECT claim_id, line_cd, subline_cd, iss_cd, clm_yy, clm_seq_no, clm_stat_cd, assd_no, NVL(loss_pd_amt,0), NVL(loss_res_amt,0),
                     NVL(exp_pd_amt,0), NVL(exp_res_amt,0), TO_CHAR(clm_file_date,''MM-DD-YYYY HH:MI:SS AM''), TO_CHAR(loss_date,''MM-DD-YYYY HH:MI:SS AM''), 
                     issue_yy, pol_iss_cd, pol_seq_no, renew_no, loss_cat_cd
                FROM gicl_claims WHERE ';
                
          v_query :=
                ' claim_id IN (SELECT claim_id
                                        FROM gicl_clm_loss_exp
                                       WHERE ex_gratia_sw = ''Y'' 
                                         AND NVL (cancel_sw, ''N'') <> ''Y'') ';
             
          --claim file date
          v_claim := ' AND (trunc(clm_file_date) >= ''' || v_from_date || ''' AND trunc(clm_file_date) <= ''' || v_to_date || ''' OR trunc(clm_file_date) <= ''' || v_as_of_date || ''' )';
          
          --loss date
          v_loss := 'AND (trunc(loss_date) >= ''' || v_from_date || ''' AND trunc(loss_date) <= ''' || v_to_date || ''' OR trunc(loss_date) <= ''' || v_as_of_date || ''' )';

          IF p_search_by = '1' THEN                                                                                                                                                        
             v_search := v_claim;
          ELSIF p_search_by = '2' THEN                                                                                                                                                     
             v_search := v_loss;
          END IF;

          /*Get total TSI and Premium amounts*/
          v_tot_query :=
                'SELECT DISTINCT SUM(loss_pd_amt) tot_loss_pd, SUM(loss_res_amt) tot_loss_res,
                                  SUM(exp_pd_amt) tot_exp_pd, SUM(exp_res_amt) tot_exp_res
                   FROM gicl_claims
                  WHERE ' || v_query || ' ' || v_search;
                  
          OPEN total FOR v_tot_query;

          LOOP
             FETCH total
              INTO v_loss_pd, v_loss_res, v_exp_pd, v_exp_res;

             EXIT WHEN total%NOTFOUND;
          END LOOP;          

          /*Get records*/
          v_temp := v_column || ' ' || v_query || ' ' || v_search;

          OPEN rec FOR v_temp;

          LOOP
             FETCH rec
              INTO v_list.claim_id, v_list.line_cd, v_list.subline_cd, v_list.iss_cd, v_list.clm_yy, v_list.clm_seq_no, v_list.clm_stat_cd, v_list.assd_no, 
                   v_list.loss_pd_amt, v_list.loss_res_amt, v_list.exp_pd_amt, v_list.exp_res_amt, v_list.clm_file_date, v_list.loss_date, 
                   v_list.issue_yy, v_list.pol_iss_cd, v_list.pol_seq_no, v_list.renew_no, v_list.loss_cat_cd;

             FOR i IN (SELECT clm_stat_desc
                         FROM giis_clm_stat
                        WHERE clm_stat_cd = v_list.clm_stat_cd)
             LOOP
                v_list.clm_stat_desc := i.clm_stat_desc;
             END LOOP;

             v_list.assd_name       := get_assd_name (v_list.assd_no);
             v_list.claim_no        := get_clm_no (v_list.claim_id);
             v_list.policy_no       :=
                                       v_list.line_cd
                                    || '-'
                                    || v_list.subline_cd
                                    || '-'
                                    || v_list.pol_iss_cd
                                    || '-'
                                    || LTRIM (TO_CHAR (v_list.issue_yy, '09'))
                                    || '-'
                                    || LTRIM (TO_CHAR (v_list.pol_seq_no, '0999999'))
                                    || '-'
                                    || LTRIM (TO_CHAR (v_list.renew_no, '09'));
             v_list.tot_loss_pd     := NVL (v_loss_pd, 0);
             v_list.tot_loss_res    := NVL (v_loss_res, 0);
             v_list.tot_exp_pd      := NVL (v_exp_pd, 0);
             v_list.tot_exp_res     := NVL (v_exp_res, 0);
                                              
             EXIT WHEN rec%NOTFOUND;
             
             PIPE ROW (v_list);
          END LOOP;      
      END IF;
   END;

   FUNCTION get_sub_rec_list (
      p_search_by       VARCHAR2,
      p_as_of_date      VARCHAR2,    
      p_from_date       VARCHAR2,
      p_to_date         VARCHAR2,
      p_user_id         VARCHAR2,
      p_claim_id        gicl_claims.claim_id%TYPE
   )
      RETURN sub_rec_tab PIPELINED
   IS
      v_rec sub_rec_type;
   BEGIN 
        FOR b IN (SELECT payee_cd, payee_class_cd, peril_cd, item_no, hist_seq_no, ex_gratia_sw, claim_id,
                         NVL(paid_amt,0) paid_amt, NVL(net_amt,0) net_amt, NVL(advise_amt,0) advise_amt
                    FROM gicl_clm_loss_exp
                   WHERE claim_id = p_claim_id)
        LOOP
            v_rec.paid_amt      := b.paid_amt;
            v_rec.net_amt       := b.net_amt;
            v_rec.advise_amt    := b.advise_amt;
            v_rec.peril_cd      := b.peril_cd;
            v_rec.hist_seq_no   := b.hist_seq_no;
            v_rec.item_no       := b.item_no;
            v_rec.ex_gratia_sw  := b.ex_gratia_sw;
            v_rec.claim_no     := get_clm_no (b.claim_id);
                                
            FOR c IN (SELECT payee_last_name||DECODE(payee_first_name,'', ' ',', '||payee_first_name) payee_name
                        FROM giis_payees
                       WHERE payee_no = b.payee_cd
                         AND payee_class_cd = b.payee_class_cd)
            LOOP
                v_rec.payee_name := c.payee_name;
            END LOOP;
                    
            FOR d IN (SELECT class_desc
                        FROM giis_payee_class
                       WHERE payee_class_cd = b.payee_class_cd) 
            LOOP
                v_rec.class_desc := d.class_desc;
            END LOOP;
                    
            FOR h IN (SELECT assd_no, line_cd, subline_cd, pol_iss_cd, issue_yy, pol_seq_no, renew_no, loss_date, loss_cat_cd
                        FROM gicl_claims
                       WHERE claim_id = p_claim_id)
            LOOP
                v_rec.policy_no :=
                                   h.line_cd
                                || '-'
                                || h.subline_cd
                                || '-'
                                || h.pol_iss_cd
                                || '-'
                                || LTRIM (TO_CHAR (h.issue_yy, '09'))
                                || '-'
                                || LTRIM (TO_CHAR (h.pol_seq_no, '0999999'))
                                || '-'
                                || LTRIM (TO_CHAR (h.renew_no, '09'));
                v_rec.assd_name := get_assd_name (h.assd_no);    
                v_rec.loss_date :=  TO_CHAR(h.loss_date,'MM-DD-YYYY HH:MI:SS AM');     
                
                FOR e IN (SELECT loss_cat_des
                            FROM giis_loss_ctgry
                           WHERE line_cd     = h.line_cd
                             AND loss_cat_cd = h.loss_cat_cd) 
                LOOP
                    v_rec.loss_cat_des := e.loss_cat_des;
                END LOOP;      
                               
                FOR f IN (SELECT peril_name
                            FROM giis_peril
                           WHERE line_cd  = h.line_cd
                             AND peril_cd = b.peril_cd) 
                LOOP
                    v_rec.peril_name := f.peril_name;
                END LOOP;  

                FOR g IN (SELECT item_title||DECODE(NVL(grouped_item_no,0), 0, ' ',
                                 '-'||get_gpa_item_title(claim_id,h.line_cd,item_no,grouped_item_no)) title
                            FROM gicl_clm_item
                           WHERE claim_id = p_claim_id
                             AND item_no  = b.item_no
                             AND NVL(grouped_item_no,0) = NVL(b.item_no,0))
                LOOP
                    v_rec.item_title := g.title;
                END LOOP;
                                          
            END LOOP;                    
                    
            PIPE ROW(v_rec);
        END LOOP;                
   END;   
END;
/


