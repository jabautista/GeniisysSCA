CREATE OR REPLACE PACKAGE BODY CPI.GIISS031_PKG
AS
   FUNCTION get_rec_list(
        p_line_cd       VARCHAR2,
        p_trty_yy       VARCHAR2,
        p_share_cd      VARCHAR2
   )
      RETURN rec_tab PIPELINED
   IS 
      v_rec   rec_type;
   BEGIN
      FOR i IN (
                  SELECT line_cd, trty_seq_no, trty_yy, ri_cd, prnt_ri_cd, trty_shr_pct,
                       trty_shr_amt, ccall_limit, whtax_rt, broker_pct, broker, prem_res,
                       int_on_prem_res, ri_comm_rt, prof_rt, funds_held_pct, remarks, user_id,
                       last_update, int_tax_rt --benjo 08.03.2016 SR-5512
                    FROM giis_trty_panel
                   WHERE line_cd = p_line_cd
                     AND trty_yy = p_trty_yy --nieko 06282016, SR 22446, KB 3568, replace trty_yy by p_trty_yy 
                     AND trty_seq_no = p_share_cd
                   ORDER BY ri_cd
               )                   
      LOOP
         v_rec.line_cd           := i.line_cd;         
         v_rec.trty_seq_no       := i.trty_seq_no;     
         v_rec.trty_yy           := i.trty_yy;          
         v_rec.ri_cd             := i.ri_cd;           
         v_rec.prnt_ri_cd        := i.prnt_ri_cd;      
         v_rec.trty_shr_pct      := i.trty_shr_pct;    
         v_rec.trty_shr_amt      := i.trty_shr_amt;    
         v_rec.ccall_limit       := i.ccall_limit;     
         v_rec.whtax_rt          := i.whtax_rt;        
         v_rec.broker_pct        := i.broker_pct;      
         v_rec.broker            := i.broker;          
         v_rec.prem_res          := i.prem_res;        
         v_rec.int_on_prem_res   := i.int_on_prem_res;  
         v_rec.ri_comm_rt        := i.ri_comm_rt;      
         v_rec.prof_rt           := i.prof_rt;         
         v_rec.funds_held_pct    := i.funds_held_pct;  
         v_rec.remarks           := i.remarks;     
         v_rec.user_id           := i.user_id;   
         v_rec.last_update       := TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         v_rec.int_tax_rt        := i.int_tax_rt; --benjo 08.03.2016 SR-5512
         
         v_rec.prnt_ri_name      := get_ri_sname(i.prnt_ri_cd);
            
         FOR j IN(
                SELECT a.ri_sname, a.ri_name, a.ri_type,
                       DECODE (a.local_foreign_sw, 'L', 'Local', 'F', 'Foreign') ri_base,
                       b.ri_type_desc
                  FROM giis_reinsurer a, giis_reinsurer_type b
                 WHERE a.ri_cd = i.ri_cd 
                   AND a.ri_type = b.ri_type
         )
         LOOP
              v_rec.ri_sname        := j.ri_sname;
              v_rec.ri_name         := j.ri_name;
              v_rec.ri_type         := j.ri_type;
              v_rec.ri_base         := UPPER(j.ri_base);
              v_rec.ri_type_desc    := j.ri_type_desc;
              
         END LOOP;
         
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   PROCEDURE set_rec (p_rec giis_trty_panel%ROWTYPE)
   IS
   BEGIN
      MERGE INTO GIIS_TRTY_PANEL
         USING DUAL
         ON (line_cd = p_rec.line_cd
            AND trty_yy = p_rec.trty_yy
            AND trty_seq_no = p_rec.trty_seq_no
            AND ri_cd = p_rec.ri_cd)
         WHEN NOT MATCHED THEN
            INSERT (line_cd, trty_yy, trty_seq_no, ri_cd, prnt_ri_cd, trty_shr_pct, trty_shr_amt, ri_comm_rt, funds_held_pct, whtax_rt, int_on_prem_res, remarks, user_id, last_update, int_tax_rt) --benjo 08.03.2016 SR-5512
            VALUES (p_rec.line_cd, p_rec.trty_yy, p_rec.trty_seq_no, p_rec.ri_cd, p_rec.prnt_ri_cd, p_rec.trty_shr_pct, p_rec.trty_shr_amt, p_rec.ri_comm_rt, p_rec.funds_held_pct, p_rec.whtax_rt, p_rec.int_on_prem_res, p_rec.remarks, p_rec.user_id,  SYSDATE, p_rec.int_tax_rt) --benjo 08.03.2016 SR-5512
         WHEN MATCHED THEN
            UPDATE
               SET prnt_ri_cd = p_rec.prnt_ri_cd, trty_shr_pct = p_rec.trty_shr_pct, trty_shr_amt = p_rec.trty_shr_amt, ri_comm_rt = p_rec.ri_comm_rt,
                   funds_held_pct = p_rec.funds_held_pct, whtax_rt = p_rec.whtax_rt, int_on_prem_res = p_rec.int_on_prem_res,
                   remarks = p_rec.remarks, user_id = p_rec.user_id, last_update = SYSDATE, int_tax_rt = p_rec.int_tax_rt; --benjo 08.03.2016 SR-5512
   END;

   PROCEDURE del_rec (p_rec giis_trty_panel%ROWTYPE)
   AS
   BEGIN
      DELETE FROM GIIS_TRTY_PANEL
            WHERE line_cd = p_rec.line_cd
            AND trty_yy = p_rec.trty_yy
            AND trty_seq_no = p_rec.trty_seq_no
            AND ri_cd = p_rec.ri_cd;
   END;


   PROCEDURE val_add_rec (
      p_line_cd           giis_trty_panel.line_cd%TYPE,        
      p_trty_seq_no       giis_trty_panel.trty_seq_no%TYPE,    
      p_trty_yy           giis_trty_panel.trty_yy%TYPE,        
      p_ri_cd             giis_trty_panel.ri_cd%TYPE      
    )
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM GIIS_TRTY_PANEL
                 WHERE line_cd = p_line_cd
                   AND trty_yy = p_trty_yy
                   AND trty_seq_no = p_trty_seq_no
                   AND ri_cd = p_ri_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error (-20001,
                                  'Geniisys Exception#E#Record already exists with the same ri_cd.'
                                 );
      END IF;
   END;
   
   FUNCTION get_trty_rec_list (
        p_line_cd       VARCHAR2,
        p_share_cd      VARCHAR2
   )
   RETURN trty_rec_tab PIPELINED
   IS 
      v_rec   trty_rec_type;
   BEGIN
      FOR i IN (
                  SELECT line_cd, share_cd, trty_yy, old_trty_seq_no, trty_limit, trty_name,
                         prtfolio_sw, eff_date, expiry_date, acct_trty_type, tot_shr_pct,
                         profcomp_type, no_of_lines, inxs_amt, exc_loss_rt, est_prem_inc,
                         underlying, ccall_limit, dep_prem, share_type, loss_prtfolio_pct,
                         prem_prtfolio_pct, funds_held_pct, user_id, last_update
                    FROM giis_dist_share
                   WHERE line_cd = p_line_cd
                     AND share_cd = p_share_cd
               )                   
      LOOP
         v_rec.line_cd          := i.line_cd;          
         v_rec.share_cd         := i.share_cd;         
         v_rec.trty_yy          := i.trty_yy;         
         v_rec.old_trty_seq_no  := i.old_trty_seq_no;  
         v_rec.trty_limit       := i.trty_limit;
         v_rec.trty_name        := i.trty_name;        
         v_rec.prtfolio_sw      := i.prtfolio_sw;      
         v_rec.eff_date         := i.eff_date;         
         v_rec.expiry_date      := i.expiry_date;      
         v_rec.acct_trty_type   := i.acct_trty_type;   
         v_rec.tot_shr_pct      := i.tot_shr_pct;          --TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS TT');
         v_rec.profcomp_type    := i.profcomp_type;    
         v_rec.no_of_lines      := i.no_of_lines;      
         v_rec.inxs_amt         := i.inxs_amt;         
         v_rec.exc_loss_rt      := i.exc_loss_rt;      
         v_rec.est_prem_inc     := i.est_prem_inc;     
         v_rec.underlying       := i.underlying;       
         v_rec.ccall_limit      := i.ccall_limit;      
         v_rec.dep_prem         := i.dep_prem;         
         v_rec.share_type       := i.share_type;       
         v_rec.loss_prtfolio_pct:= i.loss_prtfolio_pct;
         v_rec.prem_prtfolio_pct:= i.prem_prtfolio_pct; 
         v_rec.funds_held_pct   := i.funds_held_pct;   
         v_rec.user_id          := i.user_id;          
         v_rec.last_update      := i.last_update; --TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS TT'); 
         
         v_rec.dsp_trty_no      := i.line_cd || ' -' || TO_CHAR(i.trty_yy, '09') || ' -' || TO_CHAR(i.share_cd, '009'); 
         
         FOR j IN (
                SELECT trty_sname
                  FROM GIIS_CA_TRTY_TYPE  
                WHERE ca_trty_type = i.acct_trty_type 
         )
         LOOP
            v_rec.dsp_acct_type := j.trty_sname;
         END LOOP;
          
         FOR j IN (
                SELECT lcf_desc
                  FROM GIIS_PROF_COM_TYPE
                 WHERE lcf_tag = i.profcomp_type
         )
         LOOP
            v_rec.dsp_profcomp_type := j.lcf_desc;
         END LOOP;
         
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;
   
   PROCEDURE update_treaty (
       p_line_cd            VARCHAR2, 
       p_share_cd           VARCHAR2, 
       p_trty_limit         VARCHAR2,
       p_trty_name          VARCHAR2,
       p_eff_date           VARCHAR2,
       p_expiry_date        VARCHAR2,
       p_funds_held_pct     VARCHAR2,
       p_loss_prtfolio_pct  VARCHAR2,
       p_prem_prtfolio_pct  VARCHAR2,
       p_prtfolio_sw        VARCHAR2,
       p_acct_trty_type     VARCHAR2,
       p_profcomp_type      VARCHAR2,
       p_old_trty_seq_no    VARCHAR2,
       p_user               VARCHAR2
   )
   IS
   BEGIN
      UPDATE GIIS_DIST_SHARE
         SET trty_limit = p_trty_limit, trty_name = p_trty_name,
             eff_date = to_date(p_eff_date,'MM-DD-YYYY'), expiry_date = to_date(p_expiry_date,'MM-DD-YYYY'),
             funds_held_pct = p_funds_held_pct, loss_prtfolio_pct = p_loss_prtfolio_pct, prem_prtfolio_pct = p_prem_prtfolio_pct,
             prtfolio_sw = p_prtfolio_sw , acct_trty_type = p_acct_trty_type, profcomp_type = p_profcomp_type, last_update = sysdate,
             user_id = p_user, old_trty_seq_no = p_old_trty_seq_no
       WHERE line_cd    = p_line_cd
         AND share_cd   = p_share_cd;
   END;
   
   FUNCTION get_acct_trty_list(
      p_search VARCHAR2
   ) 
      RETURN acct_trty_tab PIPELINED
   IS
      v_list acct_trty_type;
   BEGIN
        FOR i IN(
            SELECT ca_trty_type, trty_sname, trty_lname
              FROM giis_ca_trty_type
             WHERE ca_trty_type LIKE p_search
             ORDER BY ca_trty_type
        )
        LOOP
            v_list.ca_trty_type := i.ca_trty_type;
            v_list.trty_sname   := i.trty_sname;  
            v_list.trty_lname   := i.trty_lname;
            
            PIPE ROW(v_list);  
        END LOOP;
        RETURN;
   END;
   
   FUNCTION get_prof_comm_list(
        p_search    VARCHAR2
   )
      RETURN prof_comm_tab PIPELINED
   IS
      v_list prof_comm_type;
   BEGIN
        FOR i IN(
            SELECT lcf_tag, lcf_desc
              FROM giis_prof_com_type
             WHERE lcf_tag LIKE p_search
             ORDER BY lcf_tag
        )
        LOOP
            v_list.lcf_tag  := i.lcf_tag; 
            v_list.lcf_desc := i.lcf_desc;
            PIPE ROW(v_list);  
        END LOOP;
        RETURN;
   END;
   
   PROCEDURE validate_acct_trty(
      p_trty_name     IN OUT VARCHAR2, 
      p_trty_type     IN OUT VARCHAR2
   )
    IS
    BEGIN
    
        SELECT trty_sname , ca_trty_type
          INTO p_trty_name, p_trty_type
          FROM giis_ca_trty_type
         WHERE ca_trty_type = p_trty_type;  
        
    EXCEPTION
        WHEN TOO_MANY_ROWS THEN
            p_trty_name   := '---';
            p_trty_type   := '---';
        WHEN OTHERS THEN
            p_trty_name := NULL;
            p_trty_type := NULL;
    END;
    
    PROCEDURE validate_prof_comm(
      p_lcf_desc     IN OUT VARCHAR2, 
      p_lcf_tag      IN OUT VARCHAR2
   )
    IS
    BEGIN
    
        SELECT lcf_desc, lcf_tag
          INTO p_lcf_desc, p_lcf_tag 
          FROM giis_prof_com_type
         WHERE lcf_tag = p_lcf_tag;     
        
    EXCEPTION
        WHEN TOO_MANY_ROWS THEN
            p_lcf_desc   := '---';
            p_lcf_tag    := '---';
        WHEN OTHERS THEN
            p_lcf_desc := NULL;
            p_lcf_tag  := NULL;
    END;
    
   FUNCTION get_reinsurer_list(
      p_search  VARCHAR2
   )
      RETURN reinsurer_tab PIPELINED
   IS
      v_list reinsurer_type;
   BEGIN
        FOR i IN(
            SELECT a1801.ri_sname dsp_ri_sname,  a1801.ri_name dsp_ri_name,
                   a1801.ri_type dsp_ri_type, a1902.ri_type_desc dsp_ri_type_desc,
                   DECODE (a1801.local_foreign_sw,
                             'L', 'LOCAL',
                             'F', 'FOREIGN'
                            ) dsp_local_foreign_sw,
                     a1801.ri_cd ri_cd
             FROM giis_reinsurer a1801, giis_reinsurer_type a1902
            WHERE a1902.ri_type = a1801.ri_type
              AND (a1801.ri_sname LIKE UPPER(p_search)
               OR  a1801.ri_name LIKE UPPER(p_search))
            ORDER BY ri_cd
        )
        LOOP
            v_list.dsp_ri_sname         := i.dsp_ri_sname;        
            v_list.dsp_ri_name          := i.dsp_ri_name;         
            v_list.dsp_ri_type          := i.dsp_ri_type;         
            v_list.dsp_ri_type_desc     := i.dsp_ri_type_desc;    
            v_list.dsp_local_foreign_sw := i.dsp_local_foreign_sw;
            v_list.ri_cd                := i.ri_cd;               
            
            PIPE ROW(v_list);  
        END LOOP;
        RETURN;
   END;
   
   FUNCTION get_parent_ri_list(
      p_search  VARCHAR2
   ) 
      RETURN parent_ri_tab PIPELINED
   IS
      v_list parent_ri_type;
   BEGIN
        FOR i IN(
            SELECT ri_cd, ri_sname
              FROM giis_reinsurer
             WHERE (ri_sname LIKE UPPER(p_search)
                OR ri_cd LIKE UPPER(p_search))
        )
        LOOP
            v_list.ri_cd        := i.ri_cd;           
            v_list.ri_sname     := i.ri_sname;        
                          
            PIPE ROW(v_list);  
        END LOOP;
        RETURN;
   END;
   
   
   PROCEDURE validate_reinsurer(
      p_dsp_ri_sname             IN OUT VARCHAR2, 
      p_ri_cd                       OUT VARCHAR2,
      p_dsp_ri_name                 OUT VARCHAR2,
      p_dsp_ri_type                 OUT VARCHAR2,
      p_dsp_ri_type_desc            OUT VARCHAR2,    
      p_dsp_local_foreign_sw        OUT VARCHAR2
   )
    IS
    BEGIN
        SELECT a.ri_sname,  a.ri_name,
               a.ri_type, b.ri_type_desc,
        DECODE (a.local_foreign_sw,
                'L', 'LOCAL',
                'F', 'FOREIGN'),
               a.ri_cd
          INTO p_dsp_ri_sname, p_dsp_ri_name, p_dsp_ri_type, p_dsp_ri_type_desc, p_dsp_local_foreign_sw, p_ri_cd
             FROM giis_reinsurer a, giis_reinsurer_type b
            WHERE b.ri_type = a.ri_type
              AND UPPER(a.ri_sname) LIKE UPPER(p_dsp_ri_sname);
    EXCEPTION
        WHEN TOO_MANY_ROWS THEN
            p_dsp_ri_sname          := '---';
            p_ri_cd                 := '---';
            p_dsp_ri_name           := '---';
            p_dsp_ri_type           := '---';
            p_dsp_ri_type_desc      := '---';
            p_dsp_local_foreign_sw  := '---';
        WHEN OTHERS THEN
            p_dsp_ri_sname          := null;
            p_ri_cd                 := null;
            p_dsp_ri_name           := null;
            p_dsp_ri_type           := null;
            p_dsp_ri_type_desc      := null;
            p_dsp_local_foreign_sw  := null;
    END;
    
    PROCEDURE validate_parent_ri(
      p_prnt_sname     IN OUT VARCHAR2, 
      p_prnt_ri           OUT VARCHAR2
   )
    IS
    BEGIN
        SELECT ri_sname ,ri_cd 
          INTO p_prnt_sname, p_prnt_ri
          FROM giis_reinsurer
         WHERE UPPER(ri_sname) LIKE UPPER(p_prnt_sname);  
        
    EXCEPTION
        WHEN TOO_MANY_ROWS THEN
            p_prnt_sname    := '---';
            p_prnt_ri       := '---';
        WHEN OTHERS THEN
            p_prnt_sname  := NULL;
            p_prnt_ri     := NULL;
    END;
    
    FUNCTION get_non_prop_trty_list(
        p_xol_id    VARCHAR2
    )
      RETURN non_prop_trty_tab PIPELINED
    IS
        v_list  non_prop_trty_type;
    BEGIN
        FOR i IN(
            SELECT xol_id, line_cd, xol_yy, xol_seq_no, xol_trty_name, user_id, last_update
              FROM GIIS_XOL
             WHERE xol_id = p_xol_id
             ORDER BY line_cd
        )
        LOOP
            v_list.xol_id        := i.xol_id;       
            v_list.line_cd       := i.line_cd;      
            v_list.xol_yy        := i.xol_yy;       
            v_list.xol_seq_no    := i.xol_seq_no;   
            v_list.xol_trty_name := UPPER(i.xol_trty_name);
            v_list.user_id       := i.user_id;   
            v_list.last_update   := i.last_update;
            
            PIPE ROW(v_list);
        END LOOP; 
        
        RETURN;   
    
    END;
    
    
    FUNCTION get_np_trty_rec_list (
        p_line_cd       VARCHAR2,
        p_trty_yy       VARCHAR2,
        p_xol_id        VARCHAR2
   )
    RETURN np_trty_rec_tab PIPELINED
    IS
        v_list  np_trty_rec_type;
    BEGIN
        FOR i IN(
            SELECT line_cd, share_cd, layer_no, trty_name, xol_allowed_amount,
                   xol_aggregate_sum, reinstatement_limit, eff_date, expiry_date,
                   xol_reserve_amount, xol_allocated_amount, xol_prem_mindep,
                   xol_prem_rate, acct_trty_type, prtfolio_sw, xol_id, xol_ded, trty_yy,
                   trty_sw, share_type, xol_base_amount, remarks
              FROM giis_dist_share
             WHERE xol_id = p_xol_id
               AND line_cd = p_line_cd
               AND trty_yy = p_trty_yy
             ORDER BY layer_no
        )
        LOOP
            v_list.line_cd             := i.line_cd;             
            v_list.share_cd            := i.share_cd;            
            v_list.layer_no            := i.layer_no;            
            v_list.trty_name           := UPPER(i.trty_name);           
            v_list.xol_allowed_amount  := i.xol_allowed_amount;
            --v_list.xol_aggregate_sum   := i.xol_aggregate_sum;   
            v_list.reinstatement_limit := i.reinstatement_limit; 
            v_list.eff_date            := i.eff_date;            
            v_list.expiry_date         := i.expiry_date;         
            v_list.xol_reserve_amount  := i.xol_reserve_amount;  
            v_list.xol_allocated_amount:= i.xol_allocated_amount;
            v_list.xol_prem_mindep     := i.xol_prem_mindep;     
            v_list.xol_prem_rate       := i.xol_prem_rate;       
            v_list.acct_trty_type      := i.acct_trty_type;      
            v_list.prtfolio_sw         := i.prtfolio_sw;         
            v_list.xol_id              := i.xol_id;              
            v_list.xol_ded             := i.xol_ded;             
            v_list.trty_yy             := i.trty_yy;             
            v_list.trty_sw             := i.trty_sw;             
            v_list.share_type          := i.share_type;
            v_list.xol_base_amount     := i.xol_base_amount; 
            v_list.remarks             := i.remarks;   
            
            v_list.xol_aggregate_sum := 0;
            IF i.reinstatement_limit IS NOT NULL THEN
                v_list.xol_aggregate_sum := NULL;
            ELSE
                v_list.xol_aggregate_sum := i.xol_aggregate_sum;
            END IF;    
            
            PIPE ROW(v_list);
        END LOOP; 
        
        RETURN;   
    
    END;
    
    
   PROCEDURE set_np_rec (p_rec giis_dist_share%ROWTYPE)
   IS
        v_share_cd      VARCHAR2(3);
        v_trty_type     VARCHAR2(5);
        v_agg_sum       GIIS_DIST_SHARE.xol_aggregate_sum%TYPE;
   BEGIN
      SELECT MAX(share_cd)+1 share_cd
        INTO v_share_cd
        FROM GIIS_DIST_SHARE
       WHERE LINE_CD  = p_rec.line_cd
         AND SHARE_CD < 999
         AND SHARE_CD > 1;
		 
	  IF v_share_cd IS NULL THEN --added by robert
         v_share_cd := 2;
	  END IF;
         
      SELECT param_value_n
        INTO v_trty_type
        FROM giac_parameters
       WHERE param_name = 'XOL_ACCT_TRTY_TYPE';
      
      IF v_trty_type is null OR v_trty_type = '' THEN
            raise_application_error (-20001, 'Geniisys Exception#I#Please set up first the parameter, XOL_ACCT_TRTY_TYPE, in giac_parameters.');
      END IF;
      
      IF p_rec.reinstatement_limit IS NULL OR p_rec.reinstatement_limit = '' THEN
        v_agg_sum := p_rec.xol_aggregate_sum;
        
      ELSE
        v_agg_sum := (p_rec.reinstatement_limit + 1) * p_rec.xol_allowed_amount;
      END IF;
      
      MERGE INTO GIIS_DIST_SHARE
         USING DUAL
            ON (line_cd = p_rec.line_cd
           AND share_cd = p_rec.share_cd)
         WHEN NOT MATCHED THEN
            INSERT (line_cd, share_cd, layer_no, trty_name, xol_allowed_amount, 
                    xol_aggregate_sum, eff_date, expiry_date, xol_reserve_amount, xol_allocated_amount,
                    xol_prem_mindep, xol_prem_rate, xol_base_amount, xol_ded, reinstatement_limit, 
                    remarks, user_id, last_update,
                    acct_trty_type, xol_id, trty_yy, share_type, trty_sw, prtfolio_sw)
            VALUES (p_rec.line_cd, v_share_cd, p_rec.layer_no, p_rec.trty_name, p_rec.xol_allowed_amount,
                    v_agg_sum, p_rec.eff_date, p_rec.expiry_date, p_rec.xol_reserve_amount, p_rec.xol_allocated_amount, 
                    p_rec.xol_prem_mindep, p_rec.xol_prem_rate, p_rec.xol_base_amount, p_rec.xol_ded, p_rec.reinstatement_limit,
                    p_rec.remarks ,p_rec.user_id, SYSDATE,
                    v_trty_type, p_rec.xol_id, p_rec.trty_yy, 4, 'Y', 'N')
         WHEN MATCHED THEN
            UPDATE
               SET trty_name = p_rec.trty_name, xol_allowed_amount = p_rec.xol_allowed_amount, xol_aggregate_sum = v_agg_sum,
                   eff_date = p_rec.eff_date, expiry_date = p_rec.expiry_date, xol_reserve_amount= p_rec.xol_reserve_amount,
                   xol_allocated_amount = p_rec.xol_allocated_amount, xol_prem_mindep = p_rec.xol_prem_mindep, 
                   xol_prem_rate = p_rec.xol_prem_rate, xol_base_amount = p_rec.xol_base_amount, reinstatement_limit = p_rec.reinstatement_limit,
                   remarks = p_rec.remarks, user_id = p_rec.user_id, last_update = SYSDATE, xol_ded = p_rec.xol_ded
            ;
   END;

   PROCEDURE del_np_rec (p_rec giis_dist_share%ROWTYPE)
   AS
   BEGIN
      DELETE FROM GIIS_DIST_SHARE
            WHERE line_cd = p_rec.line_cd
              AND share_cd = p_rec.share_cd;
      
      DELETE FROM GIIS_TRTY_PANEL
            WHERE line_cd = p_rec.line_cd
              AND trty_seq_no = p_rec.share_cd;
   
   END;
   
   PROCEDURE validate_trty_name(
      p_trty_name     IN     VARCHAR2, 
      p_line_cd       IN     VARCHAR2,
      p_share_type    IN     VARCHAR2
    )
    IS
        v_exists VARCHAR2(1) := 'N';
    
    BEGIN
        FOR i IN (
            SELECT *
              FROM giis_dist_share
             WHERE line_cd = p_line_cd
               AND share_type = p_share_type
               AND trty_name = p_trty_name
        )
        LOOP
         v_exists := 'Y';
        END LOOP;
    
        IF v_exists = 'Y' THEN
            raise_application_error (-20001,
                                  'Geniisys Exception#E#Record already exists with the same trty_name.'
                                 );
        END IF;
    
    END;
    
    PROCEDURE validate_old_trty_seq(
      p_line_cd           IN     VARCHAR2, 
      p_old_trty_seq      IN     VARCHAR2,
      p_share_cd          IN     VARCHAR2,
      p_share_type        IN     VARCHAR2,
      p_acct_trty_type    IN     VARCHAR
   )
    IS
        v_trty_yy       giis_dist_share.trty_yy%TYPE := NULL;
        v_acct_type     giis_dist_share.acct_trty_type%TYPE; 
    BEGIN
        FOR i IN (
                SELECT trty_yy, acct_trty_type
                  FROM giis_dist_share
                 WHERE line_cd        =  p_line_cd
                   AND share_cd       =  p_old_trty_seq
                   AND share_cd       <> p_share_cd
                   AND share_type     =  p_share_type
        )
        LOOP
                 v_trty_yy   := i.trty_yy;
                 v_acct_type := i.acct_trty_type;
         
        END LOOP;
    
        IF v_trty_yy IS NULL THEN
            raise_application_error (-20001, 'Geniisys Exception#I#Treaty no. is not existing.');
            
        ELSIF v_acct_type <>  p_acct_trty_type  THEN                         
            raise_application_error (-20001, 'Geniisys Exception#I#Treaty no. should have same accounting treaty type.');                     
        END IF;
    
    END;
    
    PROCEDURE recompute_trty_panel(
      p_line_cd         IN  VARCHAR2,
      p_trty_yy         IN  VARCHAR2,
      p_trty_seq_no     IN  VARCHAR2,
      p_new_trty_limit  IN  NUMBER
   )
    IS
        v_new_trty_shr_amt  NUMBER;
    BEGIN
        FOR i IN(
            SELECT ri_cd, trty_shr_pct 
              FROM GIIS_TRTY_PANEL
             WHERE line_cd = p_line_cd
               AND trty_yy = p_trty_yy
               AND trty_seq_no = p_trty_seq_no
        )
        LOOP
            v_new_trty_shr_amt := (i.trty_shr_pct / 100) * p_new_trty_limit;
            
            UPDATE GIIS_TRTY_PANEL
               SET trty_shr_amt = v_new_trty_shr_amt
             WHERE line_cd = p_line_cd
               AND trty_yy = p_trty_yy
               AND trty_seq_no = p_trty_seq_no
               AND ri_cd = i.ri_cd; 
        
        END LOOP;
    END;
    
    PROCEDURE val_add_np_rec (
      p_xol_id            giis_dist_share.xol_id%TYPE,
      p_layer_no          giis_dist_share.layer_no%TYPE      
   )
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM GIIS_DIST_SHARE
                 WHERE xol_id = p_xol_id
                   AND layer_no = p_layer_no
               )
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error (-20001,
                                  'Geniisys Exception#E#Record already exists with the same layer_no.'
                                 );
      END IF;
   END;
   
   PROCEDURE set_np_rec (p_rec giis_trty_panel%ROWTYPE)
   IS
        v_share_cd NUMBER(3);   
   BEGIN
    IF p_rec.trty_seq_no IS NULL THEN
          SELECT MAX(share_cd) share_cd
            INTO v_share_cd
            FROM GIIS_DIST_SHARE
           WHERE LINE_CD  = p_rec.line_cd
             and TRTY_YY  = p_rec.trty_yy
             AND SHARE_CD < 999
             AND SHARE_CD > 1;
    ELSE
          v_share_cd := p_rec.trty_seq_no;     
    END IF;
      
   
      MERGE INTO GIIS_TRTY_PANEL
         USING DUAL
         ON (line_cd = p_rec.line_cd
            AND trty_yy = p_rec.trty_yy
            AND trty_seq_no = p_rec.trty_seq_no
            AND ri_cd = p_rec.ri_cd)
         WHEN NOT MATCHED THEN
            INSERT (line_cd, trty_yy, trty_seq_no, ri_cd, prnt_ri_cd, trty_shr_pct, trty_shr_amt, ri_comm_rt, funds_held_pct, whtax_rt, int_on_prem_res, remarks, user_id, last_update)
            VALUES (p_rec.line_cd, p_rec.trty_yy, v_share_cd, p_rec.ri_cd, p_rec.prnt_ri_cd, p_rec.trty_shr_pct, p_rec.trty_shr_amt, p_rec.ri_comm_rt, p_rec.funds_held_pct, p_rec.whtax_rt, p_rec.int_on_prem_res, p_rec.remarks, p_rec.user_id,  SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET prnt_ri_cd = p_rec.prnt_ri_cd, trty_shr_pct = p_rec.trty_shr_pct, trty_shr_amt = p_rec.trty_shr_amt, ri_comm_rt = p_rec.ri_comm_rt,
                   funds_held_pct = p_rec.funds_held_pct, whtax_rt = p_rec.whtax_rt, int_on_prem_res = p_rec.int_on_prem_res,
                   remarks = p_rec.remarks, user_id = p_rec.user_id, last_update = SYSDATE;
   END;
   
   PROCEDURE val_del_rec_prop(
        p_line_cd       GIIS_TRTY_PANEL.line_cd%TYPE,    
        p_trty_seq_no   GIIS_TRTY_PANEL.trty_seq_no%TYPE,
        p_trty_yy       GIIS_TRTY_PANEL.trty_yy%TYPE,    
        p_ri_cd         GIIS_TRTY_PANEL.ri_cd%TYPE      
   )
   IS
   BEGIN
        FOR i IN (
            SELECT * FROM GIAC_OUTWARD_OBLIG_PAYTS
             WHERE A630_RI_CD       = p_ri_cd
               AND A630_LINE_CD     = p_line_cd 
               AND A630_TRTY_YY     = p_trty_yy
               AND A630_TRTY_SEQ_NO = p_trty_seq_no 
        )
        LOOP
            raise_application_error (-20001,'Geniisys Exception#E#Cannot delete record from GIIS_TRTY_PANEL while dependent record(s) in GIAC_OUTWARD_OBLIG_PAYTS exists.');
        END LOOP;
        
        FOR i IN (
            SELECT * FROM GIAC_OUT_TREATY_QTR_SOA
             WHERE A630_A180_RI_CD  = p_ri_cd
               AND A630_LINE_CD     = p_line_cd 
               AND A630_TRTY_YY     = p_trty_yy
               AND A630_TRTY_SEQ_NO = p_trty_seq_no 
        )
        LOOP
            raise_application_error (-20001,'Geniisys Exception#E#Cannot delete record from GIIS_TRTY_PANEL while dependent record(s) in GIAC_OUT_TREATY_QTR_SOA exists.');
        END LOOP;
        
        FOR i IN (
            SELECT * FROM GIAC_TREATY_CESSIONS
             WHERE RI_CD    = p_ri_cd
               AND LINE_CD  = p_line_cd 
               AND TREATY_YY  = p_trty_yy
               AND share_cd = p_trty_seq_no 
        )
        LOOP
            raise_application_error (-20001,'Geniisys Exception#E#Cannot delete record from GIIS_TRTY_PANEL while dependent record(s) in GIAC_TREATY_CESSIONS exists.');
        END LOOP;
   END;
   
   PROCEDURE val_del_rec_np_dist(
        p_line_cd       giis_dist_share.line_cd%TYPE,    
        p_share_cd      giis_dist_share.share_cd%TYPE
   )
   IS
   BEGIN
        FOR i IN (
            SELECT * FROM GIAC_TREATY_CESSIONS
             WHERE line_cd      = p_line_cd 
               AND share_cd     = p_share_cd
        )
        LOOP
            raise_application_error (-20001,'Geniisys Exception#E#Cannot delete record from GIIS_TRTY_PANEL while dependent record(s) in GIAC_TREATY_CESSIONS exists.');
        END LOOP;
        
        FOR i IN (
            SELECT * FROM GIIS_DEFAULT_DIST_GROUP
             WHERE line_cd      = p_line_cd 
               AND share_cd     = p_share_cd
        )
        LOOP
            raise_application_error (-20001,'Geniisys Exception#E#Cannot delete record from GIIS_TRTY_PANEL while dependent record(s) in GIIS_DEFAULT_DIST_GROUP exists.');
        END LOOP;
        
        FOR i IN (
            SELECT * FROM GIIS_DEFAULT_DIST_PERIL
             WHERE line_cd      = p_line_cd 
               AND share_cd     = p_share_cd
        )
        LOOP
            raise_application_error (-20001,'Geniisys Exception#E#Cannot delete record from GIIS_TRTY_PANEL while dependent record(s) in GIIS_DEFAULT_DIST_PERIL exists.');
        END LOOP;
        
        FOR i IN (
            SELECT * FROM GIIS_TRTY_PERIL
             WHERE line_cd      = p_line_cd 
               AND trty_seq_no  = p_share_cd
        )
        LOOP
            raise_application_error (-20001,'Geniisys Exception#E#Cannot delete record from GIIS_TRTY_PANEL while dependent record(s) in GIIS_TRTY_PERIL exists.');
        END LOOP;
        
        FOR i IN (
            SELECT * FROM GIRI_TRTY_RECIPROCITY
             WHERE line_cd      = p_line_cd 
               AND trty_seq_no  = p_share_cd
        )
        LOOP
            raise_application_error (-20001,'Geniisys Exception#E#Cannot delete record from GIIS_TRTY_PANEL while dependent record(s) in GIRI_TRTY_RECIPROCITY exists.');
        END LOOP;
        
        FOR i IN (
            SELECT * FROM GIUW_DIST_BATCH_DTL
             WHERE line_cd      = p_line_cd 
               AND share_cd     = p_share_cd
        )
        LOOP
            raise_application_error (-20001,'Geniisys Exception#E#Cannot delete record from GIIS_TRTY_PANEL while dependent record(s) in GIUW_DIST_BATCH_DTL exists.');
        END LOOP;
        
        FOR i IN (
            SELECT * FROM GIUW_ITEMPERILDS_DTL
             WHERE line_cd      = p_line_cd 
               AND share_cd     = p_share_cd
        )
        LOOP
            raise_application_error (-20001,'Geniisys Exception#E#Cannot delete record from GIIS_TRTY_PANEL while dependent record(s) in GIUW_ITEMPERILDS_DTL exists.');
        END LOOP;
        
        FOR i IN (
            SELECT * FROM GIUW_POLICYDS_DTL
             WHERE line_cd      = p_line_cd 
               AND share_cd     = p_share_cd
        )
        LOOP
            raise_application_error (-20001,'Geniisys Exception#E#Cannot delete record from GIIS_TRTY_PANEL while dependent record(s) in GIUW_POLICYDS_DTL exists.');
        END LOOP;
        
        FOR i IN (
            SELECT * FROM GIUW_WITEMDS_DTL
             WHERE line_cd      = p_line_cd 
               AND share_cd     = p_share_cd
        )
        LOOP
            raise_application_error (-20001,'Geniisys Exception#E#Cannot delete record from GIIS_TRTY_PANEL while dependent record(s) in GIUW_WITEMDS_DTL exists.');
        END LOOP;
        
        FOR i IN (
            SELECT * FROM GIUW_WITEMPERILDS_DTL
             WHERE line_cd      = p_line_cd 
               AND share_cd     = p_share_cd
        )
        LOOP
            raise_application_error (-20001,'Geniisys Exception#E#Cannot delete record from GIIS_TRTY_PANEL while dependent record(s) in GIUW_WITEMPERILDS_DTL exists.');
        END LOOP;
        
        FOR i IN (
            SELECT * FROM GIUW_WPERILDS_DTL
             WHERE line_cd      = p_line_cd 
               AND share_cd     = p_share_cd
        )
        LOOP
            raise_application_error (-20001,'Geniisys Exception#E#Cannot delete record from GIIS_TRTY_PANEL while dependent record(s) in GIUW_WPERILDS_DTL exists.');
        END LOOP;
        
        FOR i IN (
            SELECT * FROM GIUW_WPOLICYDS_DTL
             WHERE line_cd      = p_line_cd 
               AND share_cd     = p_share_cd
        )
        LOOP
            raise_application_error (-20001,'Geniisys Exception#E#Cannot delete record from GIIS_TRTY_PANEL while dependent record(s) in GIUW_WPOLICYDS_DTL exists.');
        END LOOP;
   END;
   
END;
/


