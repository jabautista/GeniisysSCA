CREATE OR REPLACE PACKAGE BODY CPI.GIACR296A_PKG AS

FUNCTION populate_giacr296a_old(
    p_as_of         VARCHAR2,
    p_cut_off       VARCHAR2,
    p_ri_cd         NUMBER,
    p_line_cd       VARCHAR2,
    p_user          VARCHAR2
)
RETURN giacr296a_tab_old PIPELINED AS

v_rec       giacr296a_type_old;
v_not_exist BOOLEAN := TRUE;
v_as_of     DATE    := TO_DATE(p_as_of,'MM/DD/YYYY');
v_cut_off   DATE    := TO_DATE(p_cut_off,'MM/DD/YYYY');

BEGIN

    FOR b IN (SELECT upper(param_value_v) param_value_v
              FROM giis_parameters
              WHERE param_name = 'COMPANY_NAME') 
    LOOP
        v_rec.company_name := b.param_value_v;
        EXIT;
    END LOOP;
    
    FOR c IN (SELECT upper(param_value_v) address            
              FROM giis_parameters 
                 WHERE param_name = 'COMPANY_ADDRESS')
    LOOP
          v_rec.company_address := c.address;
          EXIT;
    END LOOP;
  
        v_rec.as_of_cut_off := 'As of '||TO_CHAR(v_as_of,'fmMonth DD,')||
                               ' Cut-off '||TO_CHAR(v_cut_off,'fmMonth DD, YYYY');
                                   
    FOR i IN(SELECT a.ri_cd, 
                    a.ri_name, 
                    a.line_cd, 
                    b.line_name,
                    a.eff_date, 
                    a.booking_date, 
                    a.binder_no,
                    a.policy_no,
                    a.assd_name,
                    a.lprem_amt, 
                    a.lprem_vat, 
                    a.lcomm_amt, 
                    a.lcomm_vat, 
                    a.lwholding_vat, 
                    a.lnet_due,
                    a.policy_id,
                    a.fnl_binder_id,
                    a.ppw
    FROM giis_line b, giac_outfacul_soa_ext a 
    WHERE a.line_cd = b.line_cd
      AND a.cut_off_date = v_cut_off
      AND a.as_of_date = v_as_of
      AND a.ri_cd = nvl(p_ri_cd, a.ri_cd)
      AND a.line_cd = nvl(p_line_cd,a.line_cd)
      AND a.lnet_due <> 0
      AND a.user_id = p_user
    ORDER BY  a.ri_name,  b.line_name, a.eff_date,  a.booking_date, a.binder_no, a.policy_no
    )
    LOOP
        v_not_exist             := FALSE;
        v_rec.ri_name           := i.ri_name;
        v_rec.line_name         := i.line_name;
        v_rec.eff_date          := i.eff_date;
        v_rec.booking_date      := i.booking_date;
        v_rec.binder_no         := i.binder_no;
        v_rec.ppw               := i.ppw;
        v_rec.policy_no         := i.policy_no;
        v_rec.assd_name         := i.assd_name;
        v_rec.lprem_amt         := i.lprem_amt;
        v_rec.lprem_vat         := i.lprem_vat;
        v_rec.lcomm_amt         := i.lcomm_amt;
        v_rec.lcomm_vat         := i.lcomm_vat;
        v_rec.lwholding_vat     := i.lwholding_vat;
        v_rec.lnet_due          := i.lnet_due;
        v_rec.policy_id         := i.policy_id;
        v_rec.fnl_binder_id     := i.fnl_binder_id;
        v_rec.ri_cd             := i.ri_cd;
        v_rec.line_cd           := i.line_cd;
        PIPE ROW(v_rec);
    END LOOP;
    
    IF v_not_exist THEN
        v_rec.v_not_exist := 'T';
        PIPE ROW(v_rec);
    END IF;

END populate_giacr296a_old;


FUNCTION populate_giacr296a_matrix(
    p_as_of         VARCHAR2,
    p_cut_off       VARCHAR2,    
    p_ri_cd         NUMBER, 
    p_line_cd       VARCHAR2,
    p_user          VARCHAR2,
    p_policy_id     NUMBER,
    p_fnl_binder_id NUMBER
)
RETURN giacr296a_matrix_tab PIPELINED AS

    v_rec       giacr296a_matrix_type;
    v_as_of     DATE := TO_DATE(p_as_of,'MM/DD/YYYY');
    v_cut_off   DATE := TO_DATE(p_cut_off,'MM/DD/YYYY');
    v_user_branch    giis_issource.iss_cd%TYPE ;    -- jhing GENQA 4099, 4100, 4102, 4101
BEGIN
    -- jhing GENQA 4099, 4100, 4102, 4101
     FOR tx IN(SELECT b.grp_iss_cd
                      FROM giis_users a, giis_user_grp_hdr b
                     WHERE a.user_grp = b.user_grp AND a.user_id = p_user)
     LOOP
     
        v_user_branch := tx.grp_iss_cd; 
     END LOOP; 

    FOR i IN(SELECT a.ri_cd, 
                    a.ri_name, 
                    a.line_cd, 
                    b.line_name,
                    a.eff_date, 
                    a.booking_date, 
                    a.binder_no,
                    a.policy_no,
                    a.assd_name,
                    a.lprem_amt, 
                    a.lprem_vat, 
                    a.lcomm_amt, 
                    a.lcomm_vat, 
                    a.lwholding_vat, 
                    a.lnet_due,
                    a.policy_id,
                    a.fnl_binder_id,
                    a.ppw
    FROM giis_line b, giac_outfacul_soa_ext a 
    WHERE a.line_cd = b.line_cd
      AND a.cut_off_date = v_cut_off
      AND a.as_of_date = v_as_of
      AND a.ri_cd = NVL(p_ri_cd, a.ri_cd)
      AND a.line_cd = NVL(p_line_cd, a.line_cd)
      AND a.lnet_due <> 0
      AND a.user_id = p_user
      AND a.policy_id = nvl(p_policy_id, a.policy_id)
      AND a.fnl_binder_id = nvl(p_fnl_binder_id, a.fnl_binder_id)
    ORDER BY  a.ri_name,  b.line_name, a.eff_date,  a.booking_date, a.binder_no, a.policy_no
    )
    LOOP
        FOR z IN(SELECT column_no, column_title
                 FROM giis_report_aging
                 WHERE report_id = 'GIACR296'
                 AND (   (branch_cd IS NOT NULL AND branch_cd = v_user_branch)-- jhing GENQA 4099, 4100, 4102, 4101
                                OR (    branch_cd IS NULL
                                    AND (SELECT COUNT (1)
                                           FROM giis_report_aging t
                                          WHERE t.branch_cd = v_user_branch AND t.report_id = 'GIACR296') =
                                           0)) 
                 ORDER BY column_no asc)
        LOOP
            v_rec.column_no     := z.column_no;

            FOR rec IN(SELECT a.ri_cd,
                              a.line_cd, 
                              a.policy_id,
                              a.fnl_binder_id,
                              a.lnet_due,
                              c.column_no
                       FROM giis_report_aging c, giac_outfacul_soa_ext a 
                       WHERE 1=1
                       AND c.report_id = 'GIACR296'
                       AND (   (c.branch_cd IS NOT NULL AND c.branch_cd = v_user_branch)
                                OR (    c.branch_cd IS NULL
                                    AND (SELECT COUNT (1)
                                           FROM giis_report_aging t
                                          WHERE t.branch_cd = v_user_branch AND t.report_id = 'GIACR296') =
                                           0))
                       AND c.column_no = a.column_no
                       AND a.cut_off_date = v_cut_off
                       AND a.as_of_date = v_as_of
                       AND a.ri_cd = i.ri_cd --nvl(p_ri_cd,i.ri_cd)
                       AND a.line_cd = i.line_cd --nvl(p_line_cd,i.line_cd)
                       AND a.lnet_due <> 0
                       AND a.user_id = p_user
                       AND a.lnet_due = i.lnet_due
                       AND a.policy_id = i.policy_id --nvl(p_policy_id, i.policy_id)
                       AND a.fnl_binder_id = i.fnl_binder_id --nvl(p_fnl_binder_id,i.fnl_binder_id)
                       

            )
            LOOP
                IF z.column_no = rec.column_no THEN
                       v_rec.lnet_due   := rec.lnet_due;
                ELSE
                       v_rec.lnet_due   := null;
                END IF;
                v_rec.ri_cd         := i.ri_cd;
                v_rec.line_cd       := i.line_cd;
                v_rec.policy_id     := i.policy_id;
                v_rec.fnl_binder_id := i.fnl_binder_id;
                PIPE ROW(v_rec);           
            END LOOP;
            
        END LOOP;
    END LOOP;

END populate_giacr296a_matrix;

FUNCTION get_giacr296a_matrix_header (p_user_id VARCHAR2 ) -- jhing GENQA 4099, 4100, 4102, 4101 added p_user_id
RETURN giacr296a_matrix_header_tab PIPELINED AS
    v_rec   giacr296a_matrix_header_type;
    v_user_branch    giis_issource.iss_cd%TYPE ;            -- jhing GENQA 4099, 4100, 4102, 4101 added p_user_id  
BEGIN

     -- jhing GENQA 4099, 4100, 4102, 4101 added p_user_id  
     FOR tx IN(SELECT b.grp_iss_cd
                      FROM giis_users a, giis_user_grp_hdr b
                     WHERE a.user_grp = b.user_grp AND a.user_id = p_user_id)
     LOOP
     
        v_user_branch := tx.grp_iss_cd; 
     END LOOP; 
     

    FOR i IN(SELECT column_no, column_title
             FROM giis_report_aging
             WHERE report_id = 'GIACR296'
              AND (   (branch_cd IS NOT NULL AND branch_cd = v_user_branch)
                                OR (    branch_cd IS NULL
                                    AND (SELECT COUNT (1)
                                           FROM giis_report_aging t
                                          WHERE t.branch_cd = v_user_branch AND t.report_id = 'GIACR296') =
                                           0)) 
             ORDER BY column_no asc)
    LOOP
        v_rec.column_no     := i.column_no;
        v_rec.column_title  := i.column_title;
        PIPE ROW(v_rec);
    END LOOP;
END get_giacr296a_matrix_header;

   FUNCTION get_csv_cols
      RETURN csv_col_tab PIPELINED
   IS
      v_list csv_col_type;
   BEGIN
      FOR i IN (SELECT argument_name
                  FROM all_arguments
   		        WHERE owner = 'CPI'
     	             AND package_name = 'CSV_SOA'
     	             AND object_name = 'CSV_GIACR296A'
     	             AND in_out = 'OUT'
     	             AND argument_name IS NOT NULL
	           ORDER BY position)
      LOOP
         
         
         IF i.argument_name = 'RI_CD' THEN
            v_list.col_name := 'RI CODE';
         ELSIF i.argument_name = 'RI_NAME' THEN
            v_list.col_name := 'REINSURER';
         ELSIF i.argument_name = 'LINE_CD' THEN
            v_list.col_name := 'LINE CODE';
         ELSIF i.argument_name = 'LINE_NAME' THEN
            v_list.col_name := 'LINE';
         ELSIF i.argument_name = 'EFF_DATE' THEN
            v_list.col_name := 'EFF DATE';
         ELSIF i.argument_name = 'BOOKING_DATE' THEN
            v_list.col_name := 'BOOKING DATE';
         ELSIF i.argument_name = 'BINDER_NO' THEN
            v_list.col_name := 'BINDER NUMBER';
         ELSIF i.argument_name = 'POLICY_NO' THEN
            v_list.col_name := 'POLICY NUMBER';
         ELSIF i.argument_name = 'ASSD_NAME' THEN
            v_list.col_name := 'ASSURED NAME';
         ELSIF i.argument_name = 'LPREM_AMT' THEN
            v_list.col_name := 'PREMIUM AMT';
         ELSIF i.argument_name = 'LPREM_VAT' THEN
            v_list.col_name := 'VAT ON PREM';
         ELSIF i.argument_name = 'LCOMM_AMT' THEN
            v_list.col_name := 'COMMISSION AMT';
         ELSIF i.argument_name = 'LCOMM_VAT' THEN
            v_list.col_name := 'VAT ON COMM';
         ELSIF i.argument_name = 'LWHOLDING_VAT' THEN
            v_list.col_name := 'WHOLDING VAT';
         ELSIF i.argument_name = 'LNET_DUE' THEN
            v_list.col_name := 'NET DUE';
         ELSIF i.argument_name = 'POLICY_ID' THEN
            v_list.col_name := 'POLICY ID';
         ELSIF i.argument_name = 'FNL_BINDER_ID' THEN
            v_list.col_name := 'FNL BINDER ID';
         ELSIF i.argument_name = 'COLUMN_NO' THEN
            v_list.col_name := 'COLUMN NUMBER';
         ELSIF i.argument_name = 'COLUMN_TITLE' THEN
            v_list.col_name := 'COLUMN TITLE';                                                    
         ELSE
            v_list.col_name := i.argument_name;
         END IF;   
         
         PIPE ROW(v_list);
      END LOOP;              
   END get_csv_cols;

   -- bonok :: 5.4.2016 :: SR-4099,4100,4103,4102,4101,5281,21898 start
   FUNCTION get_column_header(
      p_user_id      giis_users.user_id%TYPE
   ) RETURN column_header_tab PIPELINED
   AS
      rep               column_header_type;
      v_title_tab       title_tab;
      v_index           NUMBER := 0;
      v_id              NUMBER := 0;
      v_user_branch     giis_issource.iss_cd%TYPE;
   BEGIN
      v_title_tab := title_tab ();
      
      FOR tx IN(SELECT b.grp_iss_cd
                  FROM giis_users a, giis_user_grp_hdr b
                 WHERE a.user_grp = b.user_grp AND a.user_id = p_user_id)
      LOOP
         v_user_branch := tx.grp_iss_cd; 
      END LOOP; 
      
      FOR t IN (SELECT column_no col_no, column_title col_title
                  FROM giis_report_aging c
                 WHERE report_id = 'GIACR296'
                   AND ((c.branch_cd IS NOT NULL AND c.branch_cd = v_user_branch)
                        OR (c.branch_cd IS NULL
                            AND (SELECT COUNT (1)
                                   FROM giis_report_aging t
                                  WHERE t.branch_cd = v_user_branch AND t.report_id = 'GIACR296') = 0))
                 ORDER BY column_no ASC)
      LOOP
         v_index := v_index + 1;
         v_title_tab.EXTEND;
         v_title_tab (v_index).col_title := t.col_title;
         v_title_tab (v_index).col_no := t.col_no;
      END LOOP;
      
      v_index := 1;
      
      LOOP
         v_id := v_id + 1;
         rep.dummy := v_id;            
                     
         rep.col_title1 := NULL;
         rep.col_no1 := NULL;
         rep.col_title2 := NULL;
         rep.col_no2 := NULL;
         rep.col_title3 := NULL;
         rep.col_no3 := NULL;
         rep.col_title4 := NULL;
         rep.col_no4 := NULL;
         rep.row1 := NULL;
         rep.row2 := NULL;
         rep.row3 := NULL;
         rep.row4 := NULL;
                     
         IF v_title_tab.EXISTS (v_index)
         THEN
            rep.col_title1 := v_title_tab (v_index).col_title;
            rep.col_no1 := v_title_tab (v_index).col_no;
            rep.row1 := v_index;
            v_index := v_index + 1;
         END IF;

         IF v_title_tab.EXISTS (v_index)
         THEN
            rep.col_title2 := v_title_tab (v_index).col_title;
            rep.col_no2 := v_title_tab (v_index).col_no;
            rep.row2 := v_index;
            v_index := v_index + 1;
         END IF;

         IF v_title_tab.EXISTS (v_index)
         THEN
            rep.col_title3 := v_title_tab (v_index).col_title;
            rep.col_no3 := v_title_tab (v_index).col_no;
            rep.row3 := v_index;
            v_index := v_index + 1;
         END IF;

         IF v_title_tab.EXISTS (v_index)
         THEN
            rep.col_title4 := v_title_tab (v_index).col_title;
            rep.col_no4 := v_title_tab (v_index).col_no;
            rep.row4 := v_index;
            v_index := v_index + 1;
         END IF;

         PIPE ROW (rep);
         EXIT WHEN v_index > v_title_tab.COUNT;
      END LOOP;
   END;
   
   FUNCTION populate_giacr296a(
      p_as_of         VARCHAR2,
      p_cut_off       VARCHAR2,
      p_ri_cd         NUMBER,
      p_line_cd       VARCHAR2,
      p_user          VARCHAR2
   ) RETURN giacr296a_tab PIPELINED AS
      v_list          giacr296a_type;
      v_not_exist     BOOLEAN := TRUE;
      v_as_of         DATE    := TO_DATE(p_as_of,'MM/DD/YYYY');
      v_cut_off       DATE    := TO_DATE(p_cut_off,'MM/DD/YYYY');
      v_counter       NUMBER  := 1;
      v_row_count     NUMBER  := 1;
      v_user_branch   giis_issource.iss_cd%TYPE;
   BEGIN
      FOR b IN (SELECT upper(param_value_v) param_value_v
                  FROM giis_parameters
                 WHERE param_name = 'COMPANY_NAME') 
      LOOP
         v_list.company_name := b.param_value_v;
         EXIT;
      END LOOP;
    
      FOR c IN (SELECT upper(param_value_v) address            
                  FROM giis_parameters 
                 WHERE param_name = 'COMPANY_ADDRESS')
      LOOP
         v_list.company_address := c.address;
         EXIT;
      END LOOP;
  
      v_list.as_of_cut_off := 'As of '||TO_CHAR(v_as_of,'fmMonth DD,')||' Cut-off '||TO_CHAR(v_cut_off,'fmMonth DD, YYYY');
      
      FOR tx IN(SELECT b.grp_iss_cd
                  FROM giis_users a, giis_user_grp_hdr b
                 WHERE a.user_grp = b.user_grp AND a.user_id = p_user)
      LOOP
         v_user_branch := tx.grp_iss_cd; 
      END LOOP; 
                                   
      FOR i IN(SELECT a.ri_cd, a.ri_name, a.line_cd, b.line_name, a.eff_date, 
                      a.booking_date, a.binder_no, a.policy_no, a.assd_name, a.lprem_amt, 
                      a.lprem_vat, a.lcomm_amt, a.lcomm_vat, a.lwholding_vat, a.lnet_due,
                      a.policy_id, a.fnl_binder_id, a.ppw, a.column_no,
                      COUNT(DISTINCT a.line_cd) OVER (PARTITION BY a.ri_cd) line_count
                 FROM giis_line b, giac_outfacul_soa_ext a 
                WHERE a.line_cd = b.line_cd
                  AND a.cut_off_date = v_cut_off
                  AND a.as_of_date = v_as_of
                  AND a.ri_cd = nvl(p_ri_cd, a.ri_cd)
                  AND a.line_cd = nvl(p_line_cd,a.line_cd)
                  AND a.lnet_due <> 0
                  AND a.user_id = p_user
                ORDER BY a.ri_name,  b.line_name, a.eff_date,  a.booking_date, a.binder_no, a.policy_no)
      LOOP
         v_not_exist              := FALSE;
         v_list.print_details     := 'Y';
         v_list.ri_name           := i.ri_name;
         v_list.line_name         := i.line_name;
         v_list.eff_date          := i.eff_date;
         v_list.booking_date      := i.booking_date;
         v_list.binder_no         := i.binder_no;
         v_list.ppw               := i.ppw;
         v_list.policy_no         := i.policy_no;
         v_list.assd_name         := i.assd_name;
         v_list.lprem_amt         := i.lprem_amt;
         v_list.lprem_vat         := i.lprem_vat;
         v_list.lcomm_amt         := i.lcomm_amt;
         v_list.lcomm_vat         := i.lcomm_vat;
         v_list.lwholding_vat     := i.lwholding_vat;
         v_list.lnet_due          := i.lnet_due;
         v_list.policy_id         := i.policy_id;
         v_list.fnl_binder_id     := i.fnl_binder_id;
         v_list.ri_cd             := i.ri_cd;
         v_list.line_cd           := i.line_cd;
         v_list.line_count        := i.line_count;

         v_counter := 1;
         v_row_count := 1;            
                         
         v_list.col1 := NULL;
         v_list.col_no1 := NULL;
         v_list.col2 := NULL;
         v_list.col_no2 := NULL;
         v_list.col3 := NULL;
         v_list.col_no3 := NULL;
         v_list.col4 := NULL;
         v_list.col_no4 := NULL; 
         
         FOR j IN (SELECT *
                     FROM TABLE(GIACR296A_PKG.get_column_header(p_user)))
         LOOP
            v_list.ri_cd_dummy     :=  v_list.ri_cd || '_' || j.dummy;
            v_list.dummy           := j.dummy;                                             
            v_list.col1            := j.col_title1;
            v_list.col_no1         := j.col_no1;
            v_list.col2            := j.col_title2;
            v_list.col_no2         := j.col_no2;
            v_list.col3            := j.col_title3;
            v_list.col_no3         := j.col_no3;
            v_list.col4            := j.col_title4;
            v_list.col_no4         := j.col_no4;
                         
            IF j.col_no1 IS NOT NULL THEN
               v_list.lnet_due1 := 0;
            ELSE
               v_list.lnet_due1 := NULL;
            END IF;
                            
            IF j.col_no2 IS NOT NULL THEN
               v_list.lnet_due2 := 0;
            ELSE
               v_list.lnet_due2 := NULL;
            END IF;
                            
            IF j.col_no3 IS NOT NULL THEN
               v_list.lnet_due3 := 0;
            ELSE
               v_list.lnet_due3 := NULL;
            END IF;
                            
            IF j.col_no4 IS NOT NULL THEN
               v_list.lnet_due4 := 0;
            ELSE
               v_list.lnet_due4 := NULL;
            END IF;
         
            FOR l IN  (SELECT a.ri_cd,
                              a.line_cd, 
                              a.policy_id,
                              a.fnl_binder_id,
                              a.lnet_due,
                              c.column_no
                         FROM giis_report_aging c, giac_outfacul_soa_ext a 
                        WHERE 1=1
                         AND c.report_id = 'GIACR296'
                         AND ((c.branch_cd IS NOT NULL AND c.branch_cd = v_user_branch)
                               OR (c.branch_cd IS NULL
                                   AND (SELECT COUNT (1)
                                          FROM giis_report_aging t
                                         WHERE t.branch_cd = v_user_branch AND t.report_id = 'GIACR296') = 0))
                         AND c.column_no = a.column_no
                         AND a.cut_off_date = v_cut_off
                         AND a.as_of_date = v_as_of
                         AND a.ri_cd = i.ri_cd
                         AND a.line_cd = i.line_cd
                         AND a.lnet_due <> 0
                         AND a.user_id = p_user
                         AND a.lnet_due = i.lnet_due
                         AND a.policy_id = i.policy_id
                         AND a.fnl_binder_id = i.fnl_binder_id)
            LOOP 
               IF j.col_no1 = l.column_no THEN
                  v_list.lnet_due1 := NVL(l.lnet_due,0);
                  v_list.column_no1 := j.row1;
               ELSIF j.col_no2 = l.column_no THEN
                  v_list.lnet_due2 := NVL(l.lnet_due,0);
                  v_list.column_no2 := j.row2;
               ELSIF j.col_no3 = l.column_no THEN
                  v_list.lnet_due3 := NVL(l.lnet_due,0);
                  v_list.column_no3 := j.row3;
               ELSIF j.col_no4 = l.column_no THEN
                  v_list.lnet_due4 := NVL(l.lnet_due,0);
                  v_list.column_no4 := j.row4;
               END IF;
               
               PIPE ROW(v_list);
            END LOOP;
         END LOOP;
      END LOOP;
    
      IF v_not_exist THEN
         v_list.v_not_exist := 'T';
         PIPE ROW(v_list);
      END IF;
   END;
   -- bonok :: 5.4.2016 :: SR-4099,4100,4103,4102,4101,5281,21898 end
   
END GIACR296A_PKG;
/


