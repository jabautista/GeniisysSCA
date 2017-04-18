CREATE OR REPLACE PACKAGE BODY CPI.GIPIS100_PKG AS

   FUNCTION get_query_policy_list (
      p_line_cd         gipi_polbasic.line_cd%TYPE,
      p_subline_cd      gipi_polbasic.subline_cd%TYPE,
      p_iss_cd          gipi_polbasic.iss_cd%TYPE,
      p_issue_yy        gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no      gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no        gipi_polbasic.renew_no%TYPE,
      p_ref_pol_no      gipi_polbasic.ref_pol_no%TYPE,
      p_nbt_line_cd     gipi_polbasic.line_cd%TYPE,
      p_nbt_iss_cd      gipi_polbasic.iss_cd%TYPE,
      p_par_yy          gipi_parlist.par_yy%TYPE,
      p_par_seq_no      gipi_parlist.par_seq_no%TYPE,
      p_quote_seq_no    gipi_parlist.quote_seq_no%TYPE,
      p_user_id         giis_users.user_id%TYPE,
      p_module_id       giis_modules.module_id%TYPE,
      p_order_by        VARCHAR2,
      p_asc_desc_flag   VARCHAR2,
      p_from            NUMBER,
      p_to              NUMBER
   )
      RETURN pol_tab PIPELINED
   AS
      TYPE cur_type IS REF CURSOR;
      c     cur_type;
      v_rec pol_type;
      v_sql VARCHAR2(5000);
   BEGIN
      v_sql := 'SELECT mainsql.*
                   FROM (
                    SELECT COUNT (1) OVER () count_, outersql.* 
                      FROM (
                            SELECT ROWNUM rownum_, innersql.*
                              FROM (
                                    SELECT a.policy_id, a.line_cd, a.subline_cd, a.iss_cd, a.issue_yy,
                                           a.pol_seq_no, a.renew_no, a.ref_pol_no, a.endt_seq_no,
                                           TO_CHAR (a.expiry_date, ''MM-DD-RRRR'') expiry_date, a.assd_no,
                                           a.cred_branch, TO_CHAR (a.issue_date, ''MM-DD-RRRR'') issue_date,
                                           TO_CHAR (a.incept_date, ''MM-DD-RRRR'') incept_date, a.pol_flag,
                                           a.pack_policy_id,
                                           DECODE (a.pol_flag,
                                                   ''1'', ''New'',
                                                   ''2'', ''Renewal'',
                                                   ''3'', ''Replacement'',
                                                   ''4'', ''Cancelled Endorsement'',
                                                   ''5'', ''Spoiled'',
                                                   ''X'', ''Expired''
                                                  ) mean_pol_flag,
                                           b.line_cd nbt_line_cd, b.iss_cd nbt_iss_cd, b.par_yy, b.par_seq_no,
                                           b.quote_seq_no, UPPER (d.designation || d.assd_name) assd_name                                  
                                      FROM gipi_polbasic a,
                                           gipi_parlist b,
                                           giis_assured d
                                     WHERE a.endt_seq_no = 0
                                       AND a.par_id = b.par_id
                                       AND d.assd_no = a.assd_no';                                                                                                                                                         
                         
      IF p_line_cd IS NOT NULL
      THEN
        v_sql := v_sql || ' AND UPPER (a.line_cd) LIKE '''||UPPER(p_line_cd)||'''';
      END IF;
      
      IF p_subline_cd IS NOT NULL
      THEN
        v_sql := v_sql || ' AND UPPER (a.subline_cd) LIKE '''||UPPER(p_subline_cd)||'''';
      END IF;
      
      IF p_iss_cd IS NOT NULL
      THEN
        v_sql := v_sql || ' AND UPPER (a.iss_cd) LIKE '''||UPPER(p_iss_cd)||'''';
      END IF;      

      IF p_issue_yy IS NOT NULL
      THEN
        v_sql := v_sql || ' AND a.issue_yy = '||p_issue_yy;
      END IF;
      
      IF p_pol_seq_no IS NOT NULL
      THEN
        v_sql := v_sql || ' AND a.pol_seq_no = '||p_pol_seq_no;
      END IF;

      IF p_renew_no IS NOT NULL
      THEN
        v_sql := v_sql || ' AND a.renew_no = '||p_renew_no;
      END IF;
   
      IF p_ref_pol_no IS NOT NULL
      THEN
        v_sql := v_sql || ' AND a.ref_pol_no LIKE '''||p_ref_pol_no||''''; --SR#22332. changed = to LIKE. 05.31.16 apignas_jr.
      END IF;   

      IF p_nbt_line_cd IS NOT NULL
      THEN
        v_sql := v_sql || ' AND UPPER (b.line_cd) LIKE '''||p_nbt_line_cd||'''';
      END IF;

      IF p_nbt_iss_cd IS NOT NULL
      THEN
        v_sql := v_sql || ' AND UPPER (b.iss_cd) LIKE '''||p_nbt_iss_cd||'''';
      END IF;
   
      IF p_par_yy IS NOT NULL
      THEN
        v_sql := v_sql || ' AND b.par_yy = '||p_par_yy;
      END IF;    

      IF p_par_seq_no IS NOT NULL
      THEN
        v_sql := v_sql || ' AND b.par_seq_no = '||p_par_seq_no;
      END IF;

      IF p_quote_seq_no IS NOT NULL
      THEN
        v_sql := v_sql || ' AND b.quote_seq_no = '||p_quote_seq_no;
      END IF;

      v_sql := v_sql || ' AND check_user_per_iss_cd2 (a.line_cd, a.iss_cd, :p_module_id, :p_user_id) = 1';

      IF p_order_by IS NOT NULL
      THEN
        IF p_order_by = 'policyNo'
        THEN        
          v_sql := v_sql || ' ORDER BY line_cd '||p_asc_desc_flag||', subline_cd '||p_asc_desc_flag||', iss_cd '||p_asc_desc_flag||', issue_yy '||p_asc_desc_flag||', pol_seq_no '||p_asc_desc_flag||', renew_no '||p_asc_desc_flag;
        ELSIF p_order_by = 'parNo'
        THEN
          v_sql := v_sql || ' ORDER BY line_cd '||p_asc_desc_flag||', iss_cd '||p_asc_desc_flag||', par_yy '||p_asc_desc_flag||', par_seq_no '||p_asc_desc_flag||', quote_seq_no '||p_asc_desc_flag;
        ELSIF p_order_by = 'assdName'
        THEN
          v_sql := v_sql || ' ORDER BY assd_name ';
        END IF;        
      ELSE
        v_sql := v_sql || ' ORDER BY line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no ASC';
      END IF;
                                       
      v_sql := v_sql || '
                                   ) innersql
                            ) outersql
                         ) mainsql
                    WHERE rownum_ BETWEEN '|| p_from ||' AND ' || p_to;
            
      OPEN c FOR v_sql USING p_module_id, p_user_id;
      LOOP
         FETCH c INTO v_rec.count_, 
                      v_rec.rownum_, 
                      v_rec.policy_id, 
                      v_rec.line_cd, 
                      v_rec.subline_cd,
                      v_rec.iss_cd,
                      v_rec.issue_yy,
                      v_rec.pol_seq_no, 
                      v_rec.renew_no, 
                      v_rec.ref_pol_no, 
                      v_rec.endt_seq_no,
                      v_rec.expiry_date,
                      v_rec.assd_no, 
                      v_rec.cred_branch, 
                      v_rec.issue_date, 
                      v_rec.incept_date, 
                      v_rec.pol_flag,
                      v_rec.pack_policy_id,
                      v_rec.mean_pol_flag,
                      v_rec.nbt_line_cd, 
                      v_rec.nbt_iss_cd, 
                      v_rec.par_yy, 
                      v_rec.par_seq_no, 
                      v_rec.quote_seq_no,
                      v_rec.assd_name;  
         EXIT WHEN c%NOTFOUND;       
         
         FOR i IN 
            (
                SELECT c.line_cd line_cd_rn, c.iss_cd iss_cd_rn, c.rn_yy, c.rn_seq_no
                  FROM giex_rn_no c
                 WHERE c.policy_id = v_rec.policy_id
            )
         LOOP
           v_rec.line_cd_rn := i.line_cd_rn;
           v_rec.iss_cd_rn := i.iss_cd_rn;
           v_rec.rn_yy := i.rn_yy;
           v_rec.rn_seq_no := i.rn_seq_no;
           EXIT;
         END LOOP;
         
         IF v_rec.pack_policy_id IS NOT NULL
         THEN
           v_rec.pack_pol_no := GET_PACK_POLICY_NO(v_rec.pack_policy_id);
         ELSE
           v_rec.pack_pol_no := NULL;
         END IF;    
                  
         PIPE ROW (v_rec);
      END LOOP;
      
      CLOSE c;   
   END get_query_policy_list;   

   FUNCTION get_gipi_related_polinfo (
      p_line_cd          gipi_polbasic.line_cd%TYPE,
      p_subline_cd       gipi_polbasic.subline_cd%TYPE,
      p_iss_cd           gipi_polbasic.iss_cd%TYPE,
      p_issue_yy         gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no       gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no         gipi_polbasic.renew_no%TYPE,      
      p_endorsement_no   VARCHAR2,
      p_par_no           VARCHAR2,
      p_eff_date         VARCHAR2,
      p_issue_date       VARCHAR2,
      p_acct_ent_date    VARCHAR2,
      p_ref_pol_no       gipi_polbasic.ref_pol_no%TYPE,
      p_status           VARCHAR,
      p_order_by         VARCHAR2,
      p_asc_desc_flag    VARCHAR2,
      p_from             NUMBER,
      p_to               NUMBER
   )
      RETURN gipi_polinfo_tab PIPELINED
   AS
      TYPE cur_type IS REF CURSOR;
      c             cur_type;
      v_rec         gipi_polinfo_type;
      v_sql         VARCHAR2(5000);
      v_status      VARCHAR (50);
      v_status2     VARCHAR (50);
      v_spld_flag   NUMBER (5);
   BEGIN
      v_status := p_status;

      IF    ('SPOILED' LIKE '%' || NVL (p_status, 'MBC') || '%')
         OR ('TAGGED FOR SPOILAGE' LIKE '%' || p_status || '%')
      THEN
         v_status := NULL;

         IF ('SPOILED' LIKE '%' || NVL (p_status, 'MBC') || '%')
         THEN
            v_status2 := 'SPOILED';
            v_spld_flag := 3;
         ELSIF ('TAGGED FOR SPOILAGE' LIKE '%' || NVL (p_status, 'MBC') || '%'
               )
         THEN
            v_status2 := 'TAGGED FOR SPOILAGE';
            v_spld_flag := 2;
         END IF;
      END IF;   
   
      v_sql := 'SELECT mainsql.*
                   FROM (
                    SELECT COUNT (1) OVER () count_, outersql.* 
                      FROM (
                            SELECT ROWNUM rownum_, innersql.*
                              FROM (
                                      SELECT *
                                        FROM (SELECT a.policy_id,
                                                     DECODE (a.endt_seq_no,
                                                             0, a.endt_type,
                                                                a.endt_iss_cd
                                                             || ''-''
                                                             || LPAD (a.endt_yy, 2, 0)
                                                             || ''-''
                                                             || LPAD (a.endt_seq_no, 6, 0)
                                                             || ''-''
                                                             || a.endt_type
                                                            ) endorsement_no,
                                                     a.endt_type, TRUNC (a.eff_date) eff_date,
                                                     TRUNC (a.issue_date) issue_date,
                                                     TRUNC (a.acct_ent_date) acct_ent_date,
                                                        b.line_cd
                                                     || ''-''
                                                     || b.iss_cd
                                                     || ''-''
                                                     || LPAD (b.par_yy, 2, 0)
                                                     || ''-''
                                                     || LPAD (b.par_seq_no, 6, 0)
                                                     || ''-''
                                                     || LPAD (b.quote_seq_no, 2, 0) par_no,
                                                     a.ref_pol_no, a.prem_amt, a.pol_flag, a.spld_flag,
                                                     DECODE (a.pol_flag,
                                                             ''1'', ''New'',
                                                             ''2'', ''Renewal'',
                                                             ''3'', ''Replacement'',
                                                             ''4'', ''Cancelled Endorsement'',
                                                             ''5'', ''Spoiled'',
                                                             ''X'', ''Expired''
                                                            ) mean_pol_flag,
                                                     a.reinstate_tag
                                                FROM gipi_polbasic a, gipi_parlist b
                                               WHERE a.par_id = b.par_id
                                                 AND a.line_cd = :p_line_cd
                                                 AND a.subline_cd = :p_subline_cd
                                                 AND a.iss_cd = :p_iss_cd
                                                 AND a.issue_yy = :p_issue_yy
                                                 AND a.pol_seq_no = :p_pol_seq_no
                                                 AND a.renew_no = :p_renew_no
                                              )
                                       WHERE 1=1';                           
                      
      IF p_endorsement_no IS NOT NULL
      THEN
        v_sql := v_sql || ' AND UPPER (endorsement_no) LIKE '''||UPPER(p_endorsement_no)||'''';
      END IF;
      
      IF p_par_no IS NOT NULL
      THEN
        v_sql := v_sql || ' AND UPPER (par_no) LIKE '''||UPPER(p_par_no)||'''';
      END IF;
      
      IF p_eff_date IS NOT NULL
      THEN
        v_sql := v_sql || ' AND TRUNC (eff_date) = TO_DATE('''||p_eff_date||''', ''MM-DD-YYYY'')';
      END IF;      

      IF p_issue_date IS NOT NULL
      THEN
        v_sql := v_sql || ' AND TRUNC (issue_date) = TO_DATE('''||p_issue_date||''', ''MM-DD-YYYY'')';
      END IF;
      
      IF p_acct_ent_date IS NOT NULL
      THEN
        v_sql := v_sql || ' AND TRUNC (acct_ent_date) = TO_DATE('''||p_acct_ent_date||''', ''MM-DD-YYYY'')'; 
      END IF;

      IF p_ref_pol_no IS NOT NULL
      THEN
        v_sql := v_sql || ' AND UPPER (ref_pol_no) LIKE '''||UPPER(p_ref_pol_no)||'''';
      END IF;
   
      IF v_status IS NOT NULL
      THEN
        v_sql := v_sql || ' AND UPPER (mean_pol_flag) LIKE '''||UPPER(v_status)||'''';
      END IF;   
                                
      v_sql := v_sql || ' ORDER BY policy_id
                                   ) innersql
                            ) outersql
                         ) mainsql
                    WHERE rownum_ BETWEEN '|| p_from ||' AND ' || p_to;           
      
      OPEN c FOR v_sql USING p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no;
      LOOP
         FETCH c INTO v_rec.count_, 
                      v_rec.rownum_, 
                      v_rec.policy_id, 
                      v_rec.endorsement_no, 
                      v_rec.endt_type,
                      v_rec.eff_date,
                      v_rec.issue_date,
                      v_rec.acct_ent_date, 
                      v_rec.par_no, 
                      v_rec.ref_pol_no, 
                      v_rec.prem_amt,
                      v_rec.pol_flag,
                      v_rec.spld_flag, 
                      v_rec.mean_pol_flag, 
                      v_rec.reinstate_tag;                      
         EXIT WHEN c%NOTFOUND;       
         
         FOR i IN (SELECT rv_meaning
                     FROM cg_ref_codes
                    WHERE rv_domain = 'GIPI_POLBASIC.SPLD_FLAG'
                      AND rv_low_value = v_rec.spld_flag
                      AND rv_low_value IN ('3', '2'))
         LOOP
            v_rec.mean_pol_flag := NVL (i.rv_meaning, v_rec.mean_pol_flag);
         END LOOP;
                           
         PIPE ROW (v_rec);
      END LOOP;
      
      CLOSE c;   
   END get_gipi_related_polinfo;

   FUNCTION get_motor_cars(
      p_item_no         gipi_vehicle.item_no%TYPE,
      p_motor_no        gipi_vehicle.motor_no%TYPE,
      p_plate_no        gipi_vehicle.plate_no%TYPE,
      p_serial_no       gipi_vehicle.serial_no%TYPE,
      p_model_year      gipi_vehicle.model_year%TYPE,
      p_coc_type        gipi_vehicle.coc_type%TYPE,
      p_coc_serial_no   gipi_vehicle.coc_serial_no%TYPE,
      p_coc_yy          gipi_vehicle.coc_yy%TYPE,
      p_policy_no       VARCHAR2,
      p_pol_flag        gipi_polbasic.pol_flag%TYPE,
      p_order_by        VARCHAR2,
      p_asc_desc_flag   VARCHAR2,
      p_from            NUMBER,
      p_to              NUMBER
   ) RETURN motor_cars_tab PIPELINED
   IS
      TYPE cur_type IS REF CURSOR;
      c             cur_type;
      v_rec         motor_cars_type;
      v_sql         VARCHAR2(5000);
   BEGIN   
      v_sql := 'SELECT mainsql.*
                   FROM (
                    SELECT COUNT (1) OVER () count_, outersql.* 
                      FROM (
                            SELECT ROWNUM rownum_, innersql.*
                              FROM (
                                    SELECT * 
                                      FROM (
                                              SELECT a.policy_id, a.item_no, a.motor_no, a.plate_no,
                                                     a.serial_no, a.model_year, a.coc_type,
                                                     a.coc_serial_no, a.coc_yy, b.pol_flag, b.line_cd,
                                                     b.subline_cd, b.iss_cd, b.issue_yy, b.pol_seq_no,
                                                     b.renew_no,
                                                        b.line_cd
                                                     || ''-''
                                                     || b.subline_cd
                                                     || ''-''
                                                     || b.iss_cd
                                                     || ''-''
                                                     || TO_CHAR (b.issue_yy, ''09'')
                                                     || ''-''
                                                     || TO_CHAR (b.pol_seq_no, ''0000009'')
                                                     || ''-''
                                                     || TO_CHAR (b.renew_no, ''09'') policy_no
                                                FROM gipi_vehicle a, gipi_polbasic b
                                               WHERE a.policy_id = b.policy_id
                                            )
                                      WHERE 1=1';                           
                      
      IF p_item_no IS NOT NULL
      THEN
        v_sql := v_sql || ' AND item_no = '|| p_item_no;
      END IF;
      
      IF p_motor_no IS NOT NULL
      THEN
        v_sql := v_sql || ' AND UPPER (motor_no) LIKE '''||UPPER(REPLACE(p_motor_no, '''', ''''''))||'''';
      END IF;
      
      IF p_plate_no IS NOT NULL
      THEN
        v_sql := v_sql || ' AND UPPER (plate_no) LIKE '''||UPPER(REPLACE(p_plate_no, '''', ''''''))||'''';
      END IF;

      IF p_serial_no IS NOT NULL
      THEN
        v_sql := v_sql || ' AND UPPER (serial_no) LIKE '''||UPPER(REPLACE(p_serial_no, '''', ''''''))||'''';
      END IF;

      IF p_model_year IS NOT NULL
      THEN
        v_sql := v_sql || ' AND model_year = '|| p_model_year;
      END IF;

      IF p_coc_type IS NOT NULL
      THEN
        v_sql := v_sql || ' AND UPPER (coc_type) LIKE '''||UPPER(REPLACE(p_coc_type, '''', ''''''))||'''';
      END IF;

      IF p_coc_serial_no IS NOT NULL
      THEN
        v_sql := v_sql || ' AND coc_serial_no = '|| p_coc_serial_no;
      END IF;

      IF p_coc_yy IS NOT NULL
      THEN
        v_sql := v_sql || ' AND coc_yy = '|| p_coc_yy;
      END IF;

      IF p_policy_no IS NOT NULL
      THEN
        v_sql := v_sql || ' AND UPPER (policy_no) LIKE '''||UPPER(REPLACE(p_policy_no, '''', ''''''))||'''';
      END IF;


      IF p_pol_flag IS NOT NULL
      THEN
        v_sql := v_sql || ' AND pol_flag = '''|| REPLACE(p_pol_flag, '''', '''''')||'''';
      END IF;

      IF p_order_by IS NOT NULL
      THEN
        IF p_order_by = 'itemNo'
        THEN        
          v_sql := v_sql || ' ORDER BY item_no '||p_asc_desc_flag;
        ELSIF p_order_by = 'motorNo'
        THEN
          v_sql := v_sql || ' ORDER BY motor_no '||p_asc_desc_flag;
        ELSIF p_order_by = 'plateNo'
        THEN
          v_sql := v_sql || ' ORDER BY plate_no '||p_asc_desc_flag;
        ELSIF p_order_by = 'serialNo'
        THEN
          v_sql := v_sql || ' ORDER BY serial_no '||p_asc_desc_flag;
        ELSIF p_order_by = 'modelYear'
        THEN
          v_sql := v_sql || ' ORDER BY model_year '||p_asc_desc_flag;
        ELSIF p_order_by = 'cocType cocSerialNo cocYy'
        THEN
          v_sql := v_sql || ' ORDER BY coc_type '||p_asc_desc_flag||', coc_serial_no '||p_asc_desc_flag||', coc_yy '||p_asc_desc_flag;
        ELSIF p_order_by = 'policyNo'
        THEN
          v_sql := v_sql || ' ORDER BY policy_no '||p_asc_desc_flag;
        ELSIF p_order_by = 'polFlag status'
        THEN
          v_sql := v_sql || ' ORDER BY pol_flag '||p_asc_desc_flag;                                        
        END IF;
      ELSE
        v_sql := v_sql || ' ORDER BY motor_no, plate_no, serial_no, model_year, coc_type, coc_serial_no, coc_yy';
      END IF;
             
      v_sql := v_sql || '
                                   ) innersql
                            ) outersql
                         ) mainsql
                    WHERE rownum_ BETWEEN '|| p_from ||' AND ' || p_to;           
      
      OPEN c FOR v_sql;
      LOOP
         FETCH c INTO v_rec.count_, 
                      v_rec.rownum_, 
                      v_rec.policy_id, 
                      v_rec.item_no, 
                      v_rec.motor_no,
                      v_rec.plate_no,
                      v_rec.serial_no,
                      v_rec.model_year, 
                      v_rec.coc_type, 
                      v_rec.coc_serial_no, 
                      v_rec.coc_yy,
                      v_rec.pol_flag,
                      v_rec.line_cd, 
                      v_rec.subline_cd, 
                      v_rec.iss_cd, 
                      v_rec.issue_yy, 
                      v_rec.pol_seq_no, 
                      v_rec.renew_no,
                      v_rec.policy_no;                    
         EXIT WHEN c%NOTFOUND;       
         
         SELECT rv_meaning
           INTO v_rec.status
           FROM cg_ref_codes
          WHERE rv_domain = 'GIPI_POLBASIC.POL_FLAG'
            AND rv_low_value = v_rec.pol_flag;
         
         BEGIN
            SELECT 'Y'
              INTO v_rec.has_attachment
              FROM gipi_pictures
             WHERE policy_id = v_rec.policy_id
               AND item_no = v_rec.item_no;
         EXCEPTION WHEN NO_DATA_FOUND THEN
               v_rec.has_attachment := 'N';
            WHEN TOO_MANY_ROWS THEN -- bonok :: 7.21.2015 :: UCPB SR 19835
               v_rec.has_attachment := 'Y';
         END;
                           
       PIPE ROW (v_rec);      
      END LOOP;
   END get_motor_cars;

END;
/


