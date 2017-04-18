CREATE OR REPLACE PACKAGE BODY CPI.GIPI_LOAD_HIST_PKG 
AS

  variables_v_max_sw     VARCHAR2(1) := 'N';
  
    /*
    **  Created by        : Jerome Orio  
    **  Date Created     : 06.08.2010  
    **  Reference By     : (GIPIS196- View Uploaded Files)   
    **  Description     : Uploaded files 
    */    
  FUNCTION get_gipi_load_hist
    RETURN gipi_load_hist_tab PIPELINED IS
    v_load gipi_load_hist_type;
  BEGIN
    FOR i IN (SELECT DISTINCT upload_no, filename, TRUNC (date_loaded) date_loaded,
                               no_of_records, user_id, TRUNC (last_update) last_update,
                              par_id
                            FROM gipi_load_hist
                        WHERE par_id IS NULL 
                        GROUP BY upload_no,
                                   filename,
                                 TRUNC (date_loaded),
                                 no_of_records,
                                 user_id,
                                 TRUNC (last_update),
                                 par_id
                        ORDER BY upload_no)
    LOOP
      v_load.upload_no            := i.upload_no;
      v_load.filename            := i.filename;
      v_load.par_id                := i.par_id;
      v_load.date_loaded        := i.date_loaded;
      v_load.no_of_records        := i.no_of_records;
      v_load.user_id            := i.user_id;
      v_load.last_update        := i.last_update;
      PIPE ROW(v_load);
    END LOOP;            
    RETURN;                 
  END;    
  
       /*
    **  Created by        : Jerome Orio  
    **  Date Created     : 06.09.2010  
    **  Reference By     : (GIPIS196- View Uploaded Files)   
    **  Description     : GET_GRPITM_POLICY Program Unit 
    */    
  --gmi 08/04/06
  PROCEDURE GET_GRPITM_POLICY (p_grp_no OUT NUMBER,
                                 p_parid       GIPI_PARLIST.par_id%TYPE,                                                
                                   p_itmnum       GIPI_WITEM.item_no%TYPE,
                                 p_polid    IN GIPI_POLBASIC.policy_id%TYPE) 
              IS    
    v_eff_date        gipi_polbasic.eff_date%TYPE;
    v_max_eff_date      gipi_polbasic.eff_date%TYPE;
    v_expiry_date       gipi_polbasic.expiry_date%TYPE;
    v_max_endt_seq      gipi_polbasic.endt_seq_no%TYPE;
    v_max                     NUMBER;
  BEGIN    
  -- first get the expiry_date of the policy
  FOR A1 in (SELECT expiry_date
              FROM gipi_polbasic a
             WHERE a.policy_id = p_polid
               AND a.pol_flag in ('1','2','3','X')
               AND NVL(a.endt_seq_no,0) = 0)
  LOOP
    v_expiry_date  := a1.expiry_date;    
    -- then check and retrieve for any change of expiry in case there is 
    -- endorsement of expiry date
    FOR B1 IN (SELECT expiry_date, endt_seq_no
                 FROM gipi_polbasic a
                WHERE a.policy_id = p_polid
                  AND a.pol_flag IN ('1','2','3','X')
                  AND NVL(a.endt_seq_no,0) > 0
                  AND expiry_date <> a1.expiry_date
                  AND expiry_date = endt_expiry_date
                ORDER BY a.eff_date DESC)
    LOOP
      v_expiry_date  := b1.expiry_date;
      v_max_endt_seq := b1.endt_seq_no;      
      FOR B2 IN (SELECT expiry_date, endt_seq_no
                   FROM gipi_polbasic a
                  WHERE a.policy_id = p_polid
                    AND NVL(a.endt_seq_no,0) > b1.endt_seq_no
                    AND expiry_date <> B1.expiry_date
                    AND expiry_date = endt_expiry_date
               ORDER BY a.eff_date desc)
      LOOP
        v_expiry_date  := b2.expiry_date;
        v_max_endt_seq := b2.endt_seq_no;        
        EXIT;
     END LOOP;
      --check for change in expiry using backward endt. 
      FOR C IN (SELECT expiry_date
                  FROM gipi_polbasic a
                 WHERE a.policy_id = p_polid
                   AND a.pol_flag in ('1','2','3','X')
                   AND NVL(a.endt_seq_no,0) > 0
                   AND expiry_date <> a1.expiry_date
                   AND expiry_date = endt_expiry_date
                   AND nvl(a.back_stat,5) = 2
                   AND NVL(a.endt_seq_no,0) > v_max_endt_seq
              ORDER BY a.endt_seq_no desc)
      LOOP
        v_expiry_date  := c.expiry_date;        
        EXIT;
      END LOOP;    
      EXIT;
    END LOOP;
  END LOOP;
----------------------------------------------     
    SELECT eff_date
      INTO v_eff_date
      FROM gipi_wpolbas
     WHERE par_id = p_parid;         
        FOR a IN (SELECT MAX(b252.grouped_item_no) max_grp_no
                          FROM gipi_polbasic b250, gipi_item b251, gipi_grouped_items b252 
                         WHERE b250.policy_id = p_polid
                           AND b250.pol_flag   IN ('1','2','3','X') 
                           AND b250.policy_id  = b251.policy_id
                           AND b251.policy_id  = b252.policy_id
                           AND b251.item_no    = b252.item_no
                           AND b251.item_no    = p_itmnum
                           AND TRUNC(b250.eff_date) <=  TRUNC(v_eff_date)      
                           AND TRUNC(DECODE(NVL(b250.endt_expiry_date, b250.expiry_date), b250.expiry_date,
                               v_expiry_date, b250.expiry_date,b250.endt_expiry_date)) >= TRUNC(v_eff_date)                           
                            ORDER BY b250.eff_date DESC) LOOP                                
                                    SELECT NVL(max(grouped_item_no),0)
                                      INTO v_max
                                        FROM gipi_wgrouped_items
                                     WHERE par_id  = p_parid
                                       AND item_no = p_itmnum;                                       
                                    IF v_max <= a.max_grp_no THEN   
                                        p_grp_no := a.max_grp_no;
                                    ELSE
                                        p_grp_no := 0;
                                    END IF;    
                                EXIT;
                            END LOOP;     
    variables_v_max_sw := 'Y';
  END;
  
     /*
    **  Created by        : Jerome Orio  
    **  Date Created     : 06.09.2010  
    **  Reference By     : (GIPIS196- View Uploaded Files)   
    **  Description     : insert_values Program Unit 
    */    
  PROCEDURE insert_values(p_upload_no  GIPI_LOAD_HIST.upload_no%TYPE,
                            p_parid       GIPI_PARLIST.par_id%TYPE,                                                
                            p_itmnum       GIPI_WITEM.item_no%TYPE,
                          p_polid       GIPI_POLBASIC.policy_id%TYPE)
    IS
       v_ctrl_exists          BOOLEAN                                   := FALSE;
       status_width           NUMBER;
       status_width2          NUMBER;
       v_row                  NUMBER;
       v_max                  NUMBER;
       v_records              NUMBER;
       v_temp                 NUMBER                                    := 0;
       v_temp1                NUMBER                                    := 0;
       -- for uploading to gipi_wgrp_items_beneficiary --
       v_values_ben           VARCHAR2 (500);
                                        -- values for gipi_wgrp_items_beneficiary
       v_columns_ben          VARCHAR2 (500);
                                       -- columns for gipi_wgrp_items_beneficiary
       v_max_ben              NUMBER                                    := 0;
                                 -- numbering of beneficiary_no for working table
       v_err_bencnt           NUMBER                                    := 0;
                                     -- numbering of beneficiary_no for error_log
       v_ben_sw               BOOLEAN                                   := FALSE;
    -- to know whether this procedure will upload records to gipi_wgrp_items_beneficiary
       v_exist1               BOOLEAN                                   := FALSE;
    -- checks existing records for beneficiary, if true then transfer values to error_log
       -- for uploading to gipi_witmperl_grouped --
       v_ann_prem_amt         gipi_witmperl_grouped.ann_prem_amt%TYPE   := 0;
                                                      -- storage for ann_prem_amt
       v_ann_tsi_amt          gipi_witmperl_grouped.ann_tsi_amt%TYPE    := 0;
                                                       -- storage for ann_tsi_amt
       v_peril_cd             gipi_witmperl_grouped.peril_cd%TYPE       := 0;
       v_line_cd              gipi_witmperl_grouped.line_cd%TYPE;
               -- fetches line_cd from giis_parlist and used in inserting records
       v_perl_sw              BOOLEAN                                   := FALSE;
    -- to know whether this procedure will upload records to gipi_witmperl_grouped
       v_exist2               BOOLEAN                                   := FALSE;
    -- checks existing records for perils, if true then overwrite the existing record
       v_values_perl          VARCHAR2 (500);
                                             -- values for gipi_witemperl_grouped
       v_columns_perl         VARCHAR2 (500);
                                            -- columns for gipi_witemperl_grouped
       v_values               VARCHAR2 (500);   -- values for gipi_wgrouped_items
       v_values2              VARCHAR2 (500);
                                             -- values for gipi_grouped_error_log
       v_columns              VARCHAR2 (500);  -- columns for gipi_wgrouped_items
       v_columns2             VARCHAR2 (500);
                                            -- columns for gipi_grouped_error_log
       v_stmnt                VARCHAR2 (1000);
                                              -- storage for the insert statement
       v_grp_no               NUMBER                                    := 0;
                                              -- system generated grouped_item_no
       v_grp_no2              NUMBER                                    := 0;
                   -- system generated grouped_item_no for perils and beneficiary
       v_grpxist              BOOLEAN                                   := FALSE;
               -- if control_cd already exist in gipi_wgrouped_items then true...
       v_grouped_item_no      NUMBER;
       v_grouped_item_title   VARCHAR2 (50);
       cnt                    NUMBER                                    := 0;
       
       
       /* NOTE : lagay ko muna ito sa mga variable na ito kasi di ko 
                         pa magagamit pa EDIT NALANG kung gagamitin nio. hehe */ 
                 
        p_GLOBALline_cd           GIPI_POLBASIC.line_cd%TYPE;
        p_GLOBALsubline_cd        GIPI_POLBASIC.subline_cd%TYPE;
        p_GLOBALiss_cd            GIPI_POLBASIC.iss_cd%TYPE;
        p_GLOBALissue_yy          GIPI_POLBASIC.issue_yy%TYPE;
        p_GLOBALpol_seq_no        GIPI_POLBASIC.pol_seq_no%TYPE;
        p_GLOBALrenew_no          GIPI_POLBASIC.renew_no%TYPE;
        p_GLOBALitem_no           GIPI_GROUPED_ITEMS.item_no%TYPE;
        
        v_par_type            VARCHAR2(1) := 'P';
  BEGIN
      FOR i IN(SELECT par_type
                 FROM GIPI_PARLIST
                WHERE par_id = p_parid)
      LOOP
         v_par_type := i.par_type;
         EXIT;
      END LOOP;
  
       FOR a IN
          (SELECT   REPLACE(grouped_item_title, '''', '''''') grouped_item_title, -- andrew - 3.22.2013 - added replace to handle single quote SR 12597 
                    sex, civil_status, TO_CHAR (date_of_birth, 'MM/DD/YYYY') date_of_birth,
                    TRUNC (MONTHS_BETWEEN (SYSDATE, date_of_birth) / 12) age,
                    salary, salary_grade, amount_coverage, control_cd,
                    control_type_cd,                               --gmi 10/07/05
                                    upload_no, filename, remarks, user_id,
                    last_update,                                  -- gmi 10/11/05
                                TO_CHAR (from_date, 'MM/DD/YYYY') from_date,
                                                        --danny tamayo 05/11/2009
                    TO_CHAR (TO_DATE, 'MM/DD/YYYY') TO_DATE
                                                        --danny tamayo 05/11/2009
               FROM gipi_upload_temp
              WHERE upload_no = p_upload_no      --allan 09/08/2008
           ORDER BY upload_seq_no -- changed control_cd to upload_seq_no to order records based on the template - apollo cruz 04.16.2015 
		   --upload_seq_no ASC
		   )
       LOOP
          --gmi 10/19/05 ---
          --message(:gipi_load_hist.upload_no||'par_id'||:global.parid||'Item_num'||:global.itmnum);
          --message(:gipi_load_hist.upload_no||'par_id'||:global.parid||'Item_num'||:global.itmnum);
          v_max := 0;
          v_grpxist := FALSE; -- marco - 05.08.2014 - reset variable upon iteration
          
          -- This loop is used to check if a row being processed is existing in GIPI_WGROUPED_ITEMS
          FOR x IN (SELECT grouped_item_no, grouped_item_title
                      FROM gipi_wgrouped_items
                     WHERE par_id = p_parid
                       AND item_no = p_itmnum
                       AND control_cd = a.control_cd
                       AND control_type_cd = a.control_type_cd)
          LOOP
             v_grpxist := TRUE;
             v_temp1 := 1;
             v_grouped_item_no := x.grouped_item_no;
             v_grouped_item_title := x.grouped_item_title;
             EXIT;
          END LOOP;
    
          --autonumbering of grouped_item_no--
          --IF p_polid IS NULL --marco - 05.08.2014 - replaced
          IF v_par_type = 'P'
          THEN
             SELECT MAX (grouped_item_no)
               INTO v_grp_no
               FROM gipi_wgrouped_items
              WHERE par_id = p_parid AND item_no = p_itmnum;
          ELSE
             IF v_grp_no = 0 THEN
                BEGIN
                  SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no
                    INTO p_GLOBALline_cd, p_GLOBALsubline_cd, p_GLOBALiss_cd, p_GLOBALissue_yy, p_GLOBALpol_seq_no, p_GLOBALrenew_no
                    FROM GIPI_WPOLBAS
                   WHERE par_id = p_parid;
                EXCEPTION
                  WHEN OTHERS THEN
                     NULL;
                END;
          
                BEGIN
                   SELECT NVL(MAX(grouped_item_no), 0)
                     INTO v_grp_no
                     FROM gipi_wgrouped_items
                    WHERE par_id = p_parid
                      AND item_no = p_itmnum;
                EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                     v_grp_no := 0;
                END;
          
                BEGIN
                   SELECT DECODE(SIGN(NVL(MAX(grouped_item_no), 0) - v_grp_no), 1, NVL(MAX(grouped_item_no), 0), 0, NVL(MAX(grouped_item_no), 0), v_grp_no)
                     INTO v_grp_no
                     FROM gipi_polbasic a, gipi_grouped_items b
                    WHERE a.line_cd = p_GLOBALline_cd
                      AND a.subline_cd = p_GLOBALsubline_cd
                      AND a.iss_cd = p_GLOBALiss_cd
                      AND a.issue_yy = p_GLOBALissue_yy
                      AND a.pol_seq_no = p_GLOBALpol_seq_no
                      AND a.renew_no = p_GLOBALrenew_no
                      AND a.pol_flag IN ('1', '2', '3', 'X')
                      AND a.policy_id = b.policy_id
                      AND b.item_no = p_itmnum;
                EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                     v_grp_no := 0;
                END;
             ELSE
               SELECT MAX (grouped_item_no)
                 INTO v_grp_no
                 FROM gipi_wgrouped_items
                WHERE par_id = p_parid
                  AND item_no = p_itmnum;
             END IF;
          END IF;
          
          v_ben_sw := FALSE;
          v_perl_sw := FALSE;
          v_max_ben := 0;
    
          FOR c1 IN (SELECT MAX (beneficiary_no) max_ben
                       FROM gipi_wgrp_items_beneficiary
                      WHERE par_id = p_parid
                        AND item_no = p_itmnum
                        AND grouped_item_no = v_grp_no)
          LOOP
             v_max_ben := c1.max_ben;
             EXIT;
          END LOOP;
    
          FOR x IN (SELECT '1'
                      FROM gipi_upload_beneficiary
                     WHERE upload_no = p_upload_no
                       AND control_cd = a.control_cd
                       AND control_type_cd = a.control_type_cd)
          LOOP
             v_ben_sw := TRUE;
             EXIT;
          END LOOP;
    
          FOR y IN (SELECT '1'
                      FROM gipi_upload_itmperil
                     WHERE upload_no = p_upload_no
                       AND control_cd = a.control_cd
                       AND control_type_cd = a.control_type_cd)
          LOOP
             v_perl_sw := TRUE;
             EXIT;
          END LOOP;
    
          --columns for gipi_wgrouped_items
          v_columns :=
             'par_id, item_no, grouped_item_no, grouped_item_title, sex, civil_status, date_of_birth, age, salary, salary_grade, amount_covered,include_tag, control_cd, FROM_DATE, TO_DATE, control_type_cd';
                                                                    --gmi 10/07/05
          --gmi 10/11/05 ---for error_log
          --COLUMNS FOR GIPI_GROUPED_ERROR_LOG
          v_columns2 :=
             'PAR_ID, UPLOAD_NO, FILENAME, GROUPED_ITEM_NO, GROUPED_ITEM_TITLE, SEX, CIVIL_STATUS, DATE_OF_BIRTH, AGE, SALARY, SALARY_GRADE, AMOUNT_COVERAGE, REMARKS, USER_ID, LAST_UPDATE, CONTROL_CD, FROM_DATE, TO_DATE, CONTROL_TYPE_CD';
          v_values := 'VALUES('||''''||p_parid||''''||', '||
                                 ''''||p_itmnum||''''||', '||
                                 ''''||(nvl(v_grp_no,0) + 1)||''''||', '||                                                      
                                 ''''||a.grouped_item_title||''''||', '||
                                 ''''||a.sex||''''||', '||
                                   ''''||a.civil_status||''''||', '||
                                   'TO_DATE('''||a.date_of_birth||''',''MM/DD/YYYY''),'||
                                   ''''||a.age||''''||', '|| 
                                   ''''||a.salary||''''||', '||
                                   ''''||a.salary_grade||''''||', '||
                                   ''''||a.amount_coverage||''''||', '||
                                   ''''||'N'||''''||', '||
                                   ''''||a.control_cd||''''||', '|| --gmi 10/07/05
                                   'TO_DATE('''||a.FROM_DATE||''',''MM/DD/YYYY''),'|| --danny tamayo 05/11/2009
                                   'TO_DATE('''||a.TO_DATE||''',''MM/DD/YYYY''),'||   --danny tamayo 05/11/2009
                                   ''''||a.control_type_cd||''''||')'; --gmi 10/07/05
           
          --gmi 10/11/05---                                                     
          v_values2 := 'VALUES('||''''||p_parid||''''||', '||
                                 ''''||p_upload_no||''''||', '||
                                 ''''||a.filename||''''||', '||
                                 ''''||(nvl(v_grp_no,0) + 1)||''''||', '||                 
                                 ''''||a.grouped_item_title||''''||', '||
                                 ''''||a.sex||''''||', '||
                                   ''''||a.civil_status||''''||', '||
                                   'TO_DATE('''||a.date_of_birth||''',''MM/DD/YYYY''),'||
                                   ''''||a.age||''''||', '|| 
                                   ''''||a.salary||''''||', '||
                                   ''''||a.salary_grade||''''||', '||
                                   ''''||a.amount_coverage||''''||', '||
                                   ''''||a.remarks||''''||', '||
                                   ''''||a.user_id||''''||', '||
                                   ''''||a.last_update||''''||', '||                                                   
                                   ''''||a.control_cd||''''||', '|| 
                                   'TO_DATE('''||a.FROM_DATE||''',''MM/DD/YYYY''),'|| --danny tamayo 05/11/2009
                                   'TO_DATE('''||a.TO_DATE||''',''MM/DD/YYYY''),'||   --danny tamayo 05/11/2009
                                   ''''||a.control_type_cd||''''||')';                         
    
          IF NVL (p_polid, 0) = 0
          THEN
             IF v_grpxist
             THEN
                --********************************Anthony Santos Nov 3. 2008************************
                /* IF NVL (v_max, 0) = 0
                THEN
                   SELECT max(grouped_item_no)
                        INTO v_max
                         FROM gipi_wgrouped_items
                       WHERE par_id  = :global.parid
                         AND item_no = :global.itmnum;
                   SELECT MAX (grouped_item_no)
                     INTO v_max
                     FROM gipi_wgrouped_items
                    WHERE par_id = p_parid AND item_no = p_itmnum;
    --------------------------------------
                END IF;
                
                v_values:= 'VALUES('||''''||p_parid||''''||', '||
                                     ''''||p_itmnum||''''||', '||
                                     ''''||(nvl(v_max,0) + 1)||''''||', '||
                                     ''''||a.grouped_item_title||''''||', '||
                                     ''''||a.sex||''''||', '||
                                       ''''||a.civil_status||''''||', '||
                                       'TO_DATE('''||a.date_of_birth||''',''MM/DD/YYYY''),'||
                                       ''''||a.age||''''||', '|| 
                                       ''''||a.salary||''''||', '||
                                       ''''||a.salary_grade||''''||', '||
                                       ''''||a.amount_coverage||''''||', '||
                                       ''''||'N'||''''||', '||
                                       ''''||a.control_cd||''''||', '||
                                       'TO_DATE('''||a.FROM_DATE||''',''MM/DD/YYYY''),'|| --danny tamayo 05/11/2009
                                       'TO_DATE('''||a.TO_DATE||''',''MM/DD/YYYY''),'||   --danny tamayo 05/11/2009 
                                       ''''||a.control_type_cd||''''||')'; 
                
                v_stmnt :=
                      'INSERT INTO GIPI_WGROUPED_ITEMS('
                   || v_columns
                   || ') '
                   || v_values;
                --create_file(v_stmnt);
                exec_immediate (v_stmnt); */
                
                --marco - 05.08.2014 - replaced codes above - update gipi_gwrouped_items if record is already existing
                v_stmnt := 'UPDATE GIPI_WGROUPED_ITEMS ' ||
                              'SET grouped_item_title = ''' || a.grouped_item_title || ''', ' ||
                                  'sex = ''' || a.sex || ''', ' ||
                                  'civil_status = ''' || a.civil_status || ''', ' ||
                                  'date_of_birth = ' || 'TO_DATE('''||NVL(a.date_of_birth, '')||''',''MM/DD/YYYY''),' ||
                                  'age = ''' || a.age || ''', ' ||
                                  'salary = ''' || a.salary || ''', ' ||
                                  'salary_grade = ''' || a.salary_grade || ''', ' ||
                                  'amount_covered = ''' || a.amount_coverage || ''', ' ||
                                  'include_tag = ''N'', ' ||
                                  'control_cd = ''' || a.control_cd || ''', ' ||
                                  'from_date = ' || 'TO_DATE('''||NVL(a.from_date, '')||''',''MM/DD/YYYY''),' ||
                                  'to_date = ' || 'TO_DATE('''||NVL(a.to_date, '')||''',''MM/DD/YYYY'') ' ||
                            'WHERE par_id = ''' || p_parid || ''' ' ||
                              'AND item_no = ''' || p_itmnum || ''' ' ||
                              'AND control_cd = ''' || a.control_cd || ''' ' ||
                              'AND control_type_cd = ''' || a.control_type_cd || ''' ' ||
                              'AND grouped_item_no = ''' || v_grouped_item_no || '''';
                              
               exec_immediate (v_stmnt);
                                  
          --********************************************************************
    -- null;
             ELSE
                v_stmnt :=
                      'INSERT INTO GIPI_WGROUPED_ITEMS('
                   || v_columns
                   || ') '
                   || v_values;
                --create_file(v_stmnt);
                exec_immediate (v_stmnt);
                --FORMS_DDL ('COMMIT');
             END IF;
          ELSE
             /* modified 07/06/06
             ** moved "end loop" code to avoid unnecessary loop in inserting records to gipi_wgrouped_items
             */
             FOR b2 IN (SELECT control_cd
                          FROM gipi_grouped_items
                         WHERE policy_id = p_polid
                           AND item_no = p_itmnum
                           AND delete_sw <> 'Y' /*jason 04302009*/)
             LOOP
                IF a.control_cd = b2.control_cd
                THEN
                   v_ctrl_exists := TRUE;
                   EXIT;
                ELSE
                   v_ctrl_exists := FALSE;
                END IF;
             END LOOP;                                    -- <--modified end loop;
    
             IF v_ctrl_exists
             THEN
                v_stmnt :=
                      'INSERT INTO GIPI_GROUPED_ERROR_LOG('
                   || v_columns2
                   || ') '
                   || v_values2;
                --create_file(v_stmnt);
                exec_immediate (v_stmnt);
             ELSE
                --added by gmi 08/04/06
                IF variables_v_max_sw = 'N'
                THEN
                   get_grpitm_policy (v_max,p_parid,p_itmnum,p_polid);
                END IF;
    
                   --gmi--gmi--gmi--
                /* IF NVL(v_max,0) = 0 THEN
                      SELECT max(grouped_item_no)
                        INTO v_max
                         FROM gipi_wgrouped_items
                       WHERE par_id  = :global.parid
                         AND item_no = :global.itmnum;
                   END IF;*/
    
                --******************ANTHONY SANTOS NOV 4 2008*******************
                IF p_polid IS NULL
                THEN
                   SELECT MAX (grouped_item_no)
                     INTO v_max
                     FROM gipi_wgrouped_items
                    WHERE par_id = p_parid AND item_no = p_itmnum;
                ELSE
    --------------------------------------
                   IF v_grpxist
                   THEN
                      SELECT MAX (grouped_item_no)
                        INTO v_max
                        FROM gipi_wgrouped_items
                       WHERE par_id = p_parid AND item_no = p_itmnum;
                   ELSE
                      IF v_temp = 0
                      THEN
                         SELECT MAX (b.grouped_item_no)
                           INTO v_max
                           FROM gipi_polbasic a, gipi_grouped_items b
                          WHERE a.line_cd = p_GLOBALline_cd
                            AND a.subline_cd = p_GLOBALsubline_cd
                            AND a.iss_cd = p_GLOBALiss_cd
                            AND a.issue_yy = p_GLOBALissue_yy
                            AND a.pol_seq_no = p_GLOBALpol_seq_no
                            AND a.renew_no = p_GLOBALrenew_no
                            AND a.pol_flag IN ('1', '2', '3', 'X')
                            AND a.policy_id = b.policy_id
                            AND b.item_no = p_GLOBALitem_no;
    
                         v_temp := 1;
                      ELSE
                         SELECT MAX (grouped_item_no)
                           INTO v_max
                           FROM gipi_wgrouped_items
                          WHERE par_id = p_parid AND item_no = p_itmnum;
                      END IF;
                   END IF;                --**************************************
                END IF;
                
                v_values:= 'VALUES('||''''||p_parid||''''||', '||
                                     ''''||p_itmnum||''''||', '||
                                     ''''||(nvl(v_max,0) + 1)||''''||', '||
                                     ''''||a.grouped_item_title||''''||', '||
                                     ''''||a.sex||''''||', '||
                                       ''''||a.civil_status||''''||', '||
                                       'TO_DATE('''||a.date_of_birth||''',''MM/DD/YYYY''),'||
                                       ''''||a.age||''''||', '|| 
                                       ''''||a.salary||''''||', '||
                                       ''''||a.salary_grade||''''||', '||
                                       ''''||a.amount_coverage||''''||', '||
                                       ''''||'N'||''''||', '||
                                       ''''||a.control_cd||''''||', '||
                                       'TO_DATE('''||a.FROM_DATE||''',''MM/DD/YYYY''),'|| --danny tamayo 05/11/2009
                                       'TO_DATE('''||a.TO_DATE||''',''MM/DD/YYYY''),'||   --danny tamayo 05/11/2009 
                                       ''''||a.control_type_cd||''''||')'; 
                 
                v_stmnt :=
                      'INSERT INTO GIPI_WGROUPED_ITEMS('
                   || v_columns
                   || ') '
                   || v_values;
                   --create_file(v_stmnt);
                -- commit;
                exec_immediate (v_stmnt);
             END IF;
          END IF;
    
    -----------------------------for gipi_wgrp_items_beneficiary----------------------------10/19/05 gmi
          IF v_ben_sw
          THEN
             IF v_grpxist
             THEN
                v_grp_no2 := NVL (v_grouped_item_no, 0);
             ELSE
                v_grp_no2 := NVL (v_grp_no, 0) + 1;
             END IF;
    
             FOR ben IN (SELECT upload_no, filename, control_type_cd, control_cd,
                                beneficiary_name, beneficiary_addr, relation,
                                TO_CHAR (date_of_birth,
                                         'MM/DD/YYYY'
                                        ) date_of_birth,
                                age, civil_status, sex, user_id, last_update
                           FROM gipi_upload_beneficiary
                          WHERE upload_no = p_upload_no
                            AND filename = a.filename
                            AND control_cd = a.control_cd
                            AND control_type_cd = a.control_type_cd)
             LOOP
                v_max_ben := NVL (v_max_ben, 0) + 1;
                v_columns_ben :=
                   'PAR_ID, ITEM_NO, GROUPED_ITEM_NO, BENEFICIARY_NO, 
                                                          BENEFICIARY_NAME, BENEFICIARY_ADDR, RELATION, DATE_OF_BIRTH, 
                                                          AGE, CIVIL_STATUS, SEX';
    
                FOR ben2 IN (SELECT beneficiary_name bname, date_of_birth bday
                               FROM gipi_wgrp_items_beneficiary
                              WHERE par_id = p_parid
                                AND item_no = p_itmnum
                                AND grouped_item_no = v_grp_no2)
                LOOP
                   IF     (ben.beneficiary_name = ben2.bname)
                      AND (ben.date_of_birth = ben2.bday)
                   THEN
                      v_exist1 := TRUE;
                      EXIT;
                   ELSE
                      v_exist1 := FALSE;
                   END IF;
                END LOOP;
    
                IF v_exist1
                THEN
                   v_err_bencnt := NVL (v_err_bencnt, 0) + 1;
                   
                   v_values_ben :='VALUES('||''''||p_parid||''''||', '||
                                             ''''||p_itmnum||''''||', '||                                                      
                                             ''''||nvl(v_grp_no2,0)||''''||', '||                                                      
                                             ''''||v_err_bencnt||''''||', '||
                                             ''''||ben.beneficiary_name||''''||', '||
                                               ''''||ben.beneficiary_addr||''''||', '||
                                               ''''||ben.relation||''''||', '|| 
                                               'TO_DATE('''||ben.date_of_birth||''',''MM/DD/YYYY''),'||
                                               ''''||ben.age||''''||', '||
                                               ''''||ben.civil_status||''''||', '||
                                               ''''||ben.sex||''''||')'; 
                      
                   v_stmnt :=
                         'INSERT INTO GIPI_BENEFICIARY_ERROR_LOG('
                      || v_columns_ben
                      || ') '
                      || v_values_ben;
                   --create_file(v_stmnt);
                   exec_immediate (v_stmnt);
                ELSE
                   v_values_ben :='VALUES('||''''||p_parid||''''||', '||
                                             ''''||p_itmnum||''''||', '||                                                      
                                             ''''||nvl(v_grp_no2,0)||''''||', '||                                                      
                                             ''''||v_max_ben||''''||', '||
                                             ''''||ben.beneficiary_name||''''||', '||
                                               ''''||ben.beneficiary_addr||''''||', '||
                                               ''''||ben.relation||''''||', '|| 
                                               'TO_DATE('''||ben.date_of_birth||''',''MM/DD/YYYY''),'||
                                               ''''||ben.age||''''||', '||
                                               ''''||ben.civil_status||''''||', '||
                                               ''''||ben.sex||''''||')';
                   v_stmnt :=
                         'INSERT INTO GIPI_WGRP_ITEMS_BENEFICIARY('
                      || v_columns_ben
                      || ') '
                      || v_values_ben;
                   --create_file(v_stmnt);
                   exec_immediate (v_stmnt);
                END IF;
             END LOOP;
          END IF;
    
    ------------------------------------------------------------------------- 10/19/05 gmi
    
          -----------------------------for gipi_witmperl_grouped----------------------------10/20/05 gmi
          IF v_perl_sw
          THEN
             IF v_grpxist
             THEN
                v_grp_no2 := NVL (v_grouped_item_no, 0);
             ELSE
                v_grp_no2 := NVL (v_grp_no, 0) + 1;
             END IF;
    
             FOR perl IN (SELECT upload_no, filename, control_type_cd, control_cd,
                                 peril_cd, prem_rt, tsi_amt, prem_amt,
                                 aggregate_sw, base_amt, ri_comm_rate,
                                 ri_comm_amt, user_id, last_update, no_of_days
                            FROM gipi_upload_itmperil
                           WHERE upload_no = p_upload_no
                             AND filename = a.filename
                             AND control_cd = a.control_cd
                             AND control_type_cd = a.control_type_cd)
             LOOP
                ------computations------
                v_ann_prem_amt :=
                   ROUND (((NVL (perl.prem_rt, 0)) / 100) * NVL (perl.tsi_amt, 0),
                          2
                         );
    
                FOR comp IN (SELECT peril_type
                               FROM giis_peril
                              WHERE peril_cd = perl.peril_cd)
                LOOP
                   IF comp.peril_type = 'B'
                   THEN
                      v_ann_tsi_amt := perl.tsi_amt;
                   END IF;
                END LOOP;
    
                ------computations------
                v_columns_perl :=
                   'PAR_ID, ITEM_NO, GROUPED_ITEM_NO, LINE_CD, PERIL_CD, 
                                                            REC_FLAG, NO_OF_DAYS, PREM_RT, TSI_AMT, PREM_AMT, ANN_TSI_AMT, 
                                                            ANN_PREM_AMT, AGGREGATE_SW, BASE_AMT, RI_COMM_RATE, RI_COMM_AMT';
                v_exist2 := FALSE; -- marco - 05-08-2014 - reset variable upon iteration
                FOR perl2 IN (SELECT peril_cd
                                FROM gipi_witmperl_grouped
                               WHERE par_id = p_parid
                                 AND item_no = p_itmnum
                                 AND grouped_item_no = v_grp_no2)
                LOOP
                   IF perl2.peril_cd = perl.peril_cd
                   THEN
                      v_exist2 := TRUE;
                      v_peril_cd := perl2.peril_cd;
                      EXIT;
                   ELSE
                      v_exist2 := FALSE;
                   END IF;
                END LOOP;
    
                FOR p IN (SELECT line_cd
                            FROM gipi_parlist
                           WHERE par_id = p_parid)
                LOOP
                   v_line_cd := p.line_cd;
                   EXIT;
                END LOOP;
    
                IF v_exist2
                THEN
                   UPDATE gipi_witmperl_grouped
                      SET rec_flag = 'C',
                          no_of_days = perl.no_of_days,
                          prem_rt = perl.prem_rt,
                          tsi_amt = perl.tsi_amt,
                          prem_amt = perl.prem_amt,
                          ann_tsi_amt = v_ann_tsi_amt,
                          ann_prem_amt = v_ann_prem_amt,
                          aggregate_sw = perl.aggregate_sw,
                          base_amt = perl.base_amt,
                          ri_comm_rate = perl.ri_comm_rate,
                          ri_comm_amt = perl.ri_comm_amt
                    WHERE par_id = p_parid
                      AND item_no = p_itmnum
                      AND grouped_item_no = v_grp_no2
                      AND line_cd = v_line_cd
                      AND peril_cd = v_peril_cd;
                ELSE
                   v_values_perl:='VALUES('||''''||p_parid||''''||', '||
                                             ''''||p_itmnum||''''||', '||                                                      
                                             ''''||nvl(v_grp_no2,0)||''''||', '||                                                      
                                             ''''||v_line_cd||''''||', '||
                                             ''''||perl.peril_cd||''''||', '||
                                               ''''||'C'||''''||', '||
                                               ''''||perl.no_of_days||''''||', '|| 
                                               ''''||perl.prem_rt||''''||', '|| 
                                               ''''||perl.tsi_amt||''''||', '||
                                               ''''||perl.prem_amt||''''||', '||
                                               ''''||v_ann_tsi_amt||''''||', '||
                                               ''''||v_ann_prem_amt||''''||', '||
                                               ''''||perl.aggregate_sw||''''||', '||
                                               ''''||perl.base_amt||''''||', '||
                                               ''''||perl.ri_comm_rate||''''||', '||
                                               ''''||perl.ri_comm_amt||''''||')';
                   v_stmnt :=
                         'INSERT INTO GIPI_WITMPERL_GROUPED('
                      || v_columns_perl
                      || ') '
                      || v_values_perl;
                   --create_file(v_stmnt);
                   exec_immediate (v_stmnt);
                END IF;
             END LOOP;
          END IF;
    
    ------------------------------------------------------------------------- 10/20/05 gmi
         /* variables.v_insert_chk := 'Y';
          SET_ITEM_PROPERTY ('start_btn', label, 'Ok');
          status_width := GET_ITEM_PROPERTY ('STATUS', width);
          status_width2 := status_width + CEIL (260 / (v_row - 1));
          SYNCHRONIZE;
    
          IF status_width2 > 260
          THEN
             SET_ITEM_PROPERTY ('STATUS', width, 260);
             SYNCHRONIZE;
          ELSIF status_width2 <= 260
          THEN
             SET_ITEM_PROPERTY ('STATUS', width, status_width2);
             SYNCHRONIZE;
          END IF;
    
          SET_ITEM_PROPERTY ('cg$ctrl.start_btn', enabled, property_true);
          SET_ITEM_PROPERTY ('cg$ctrl.cancel_btn', enabled, property_true);*/
       END LOOP;
    
       BEGIN
          SELECT COUNT (par_id)
            INTO v_records
            FROM gipi_wgrouped_items
           WHERE par_id = p_parid AND item_no = p_itmnum;
       EXCEPTION
          WHEN NO_DATA_FOUND
          THEN
             v_records := 0;
       END;
    
       UPDATE gipi_waccident_item
          SET no_of_persons = v_records
        WHERE par_id = p_parid AND item_no = p_itmnum;
    
       UPDATE gipi_parlist
          SET upload_no = p_upload_no
        WHERE par_id = p_parid;
    
       UPDATE gipi_load_hist
          SET par_id = p_parid
        WHERE upload_no = p_upload_no;
    
       --END LOOP;
       --    EXCEPTION
       --     WHEN OTHERS THEN
       --       msg_alert('Record already exists. Uploading Files Unsuccessful','I',FALSE);
       --SET_ITEM_PROPERTY ('cg$ctrl.start_btn', enabled, property_true);
       --SET_ITEM_PROPERTY ('cg$ctrl.cancel_btn', enabled, property_true);
  END;

     /*
    **  Created by        : Jerome Orio  
    **  Date Created     : 04.29.2011  
    **  Reference By     : (GIPIS012-  Accident Item Screen)     
    **  Description     : CREATE_INVOICE_ITEM program unit  
    */    
    PROCEDURE CREATE_INVOICE_ITEM(
        p_par_id            gipi_wpolbas.par_id%TYPE,
        p_line_cd           gipi_wpolbas.line_cd%TYPE,
        p_iss_cd            gipi_wpolbas.iss_cd%TYPE
        ) IS
       p_exist    NUMBER;
    BEGIN
        FOR A IN (SELECT   '1'
                    FROM       gipi_witmperl_grouped
                   WHERE   par_id  = p_par_id) LOOP
            create_wgrp_invoice(0,0,0,p_par_id,p_line_cd,p_iss_cd);       
        EXIT;
        END LOOP; 

       SELECT   distinct 1
         INTO   p_exist
         FROM   gipi_witmperl a, gipi_witem b
        WHERE   a.par_id   =  b.par_id
          AND   a.par_id   =  p_par_id
          AND   a.item_no  =  b.item_no
     GROUP BY   b.par_id,b.item_grp,a.peril_cd;
       CREATE_WINVOICE(0,0,0,p_par_id,p_line_cd,p_iss_cd); -- modified by aivhie 120601
          
     EXCEPTION
       WHEN NO_DATA_FOUND THEN
          DELETE   gipi_wcomm_inv_perils
           WHERE   par_id = p_par_id;
          DELETE   gipi_winvperl
           WHERE   par_id = p_par_id;
          DELETE   gipi_winv_tax
           WHERE   par_id = p_par_id;
          DELETE   gipi_winstallment
           WHERE   par_id = p_par_id;
          DELETE   gipi_wcomm_invoices
           WHERE   par_id = p_par_id;
          DELETE   gipi_wpackage_inv_tax
           WHERE   par_id = p_par_id;
          DELETE   gipi_winvoice
           WHERE   par_id = p_par_id;
    END;

     /*
    **  Created by        : Jerome Orio  
    **  Date Created     : 04.29.2011  
    **  Reference By     : (GIPIS012-  Accident Item Screen)     
    **  Description     : insert_recgrp_witem program unit  
    */    
    PROCEDURE insert_recgrp_witem(
        p_par_id            gipi_witem.par_id%TYPE,
        p_line_cd           gipi_wpolbas.line_cd%TYPE,
        p_item_no           gipi_witem.item_no%TYPE
        ) IS
    BEGIN
        FOR a IN (SELECT no_of_persons
                    FROM gipi_waccident_item
                    WHERE par_id = p_par_id
                     AND item_no = p_item_no)
        LOOP        
            FOR i IN (SELECT grouped_item_no
                        FROM gipi_wgrouped_items
                       WHERE par_id = p_par_id
                         AND item_no = p_item_no)
            LOOP              
                GIPI_WGROUPED_ITEMS_PKG.insert_recgrp_witem(
                    p_par_id, p_item_no, p_line_cd, i.grouped_item_no, a.no_of_persons);
            END LOOP;
        END LOOP;
    END;
    
    /*    Date        Author            Description
    *    ==========    ===============    ============================
    *    10.21.2011    mark jm            retrieve records on gipi_load_hist based on given parameters (tablegrid version)
    */
    FUNCTION get_gipi_load_hist_tg (p_filename IN VARCHAR2)
    RETURN gipi_load_hist_tab PIPELINED
    IS
        v_load gipi_load_hist_type;
    BEGIN
        FOR i IN (
            SELECT DISTINCT upload_no, filename, TRUNC (date_loaded) date_loaded,
                   no_of_records, user_id, TRUNC (last_update) last_update,
                   par_id
              FROM gipi_load_hist
             WHERE par_id IS NULL
               AND UPPER(filename) LIKE UPPER(NVL(p_filename, '%%'))
          GROUP BY upload_no, filename, TRUNC (date_loaded), no_of_records,
                   user_id, TRUNC (last_update), par_id
          ORDER BY upload_no)
        LOOP
            v_load.upload_no        := i.upload_no;
            v_load.filename            := i.filename;
            v_load.par_id            := i.par_id;
            v_load.date_loaded        := i.date_loaded;
            v_load.no_of_records    := i.no_of_records;
            v_load.user_id            := i.user_id;
            v_load.last_update        := i.last_update;
            PIPE ROW(v_load);
        END LOOP;            
        RETURN;                 
    END get_gipi_load_hist_tg;    
END;
/


