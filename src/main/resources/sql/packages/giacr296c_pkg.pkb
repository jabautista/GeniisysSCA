CREATE OR REPLACE PACKAGE BODY CPI.GIACR296C_PKG AS
 /*
    **  Created by   :  Melvin John O. Ostia
    **  Date Created : 07.011.2013
    **  Reference By : GIACR296C_PKG - PREMIUMS DUE TO REINSURER
    */
FUNCTION populate_giacr296c_matrix(
    p_as_of         varchar2,
    p_cut_off       varchar2,
    p_ri_cd         NUMBER,
    p_line_cd       VARCHAR2,
    p_user          VARCHAR2, 
    p_currency_cd   NUMBER,
    p_currency_rt   NUMBER,
    p_policy_id     NUMBER,
    p_fnl_binder_id NUMBER,
    p_fnet_due      NUMBER
  --  p_column_no     NUMBER
)
RETURN giacr296c_matrix_tab PIPELINED
AS
    v_rec giacr296c_matrix_type;
    v_as_of     DATE    := TO_DATE(p_as_of,'fmMM/DD/YYYY');
    v_cut_off   DATE    := TO_DATE(p_cut_off,'fmMM/DD/YYYY');
    v_user_branch    giis_issource.iss_cd%TYPE ;         -- jhing 01.30.2016 GENQA 4099,4100,4103,4102,4101
BEGIN

-- jhing 01.30.2016 GENQA 4099,4100,4103,4102,4101
FOR tx IN(SELECT b.grp_iss_cd
              FROM giis_users a, giis_user_grp_hdr b
             WHERE a.user_grp = b.user_grp AND a.user_id = p_user)
LOOP
     
v_user_branch := tx.grp_iss_cd; 
END LOOP; 


FOR i IN (
                SELECT a.ri_cd, 
                                    a.ri_name, 
                                    a.line_cd, 
                                    b.line_name,
                                    a.eff_date, 
                                    a.booking_date, 
                                    a.binder_no,
                                    a.policy_no,
                                    a.assd_name,
                                    a.fprem_amt, 
                                    a.fprem_vat, 
                                    a.fcomm_amt, 
                                    a.fcomm_vat, 
                                    a.fwholding_vat, 
                                    a.fnet_due,
                                    a.currency_cd, 
                                    a.currency_rt,
                                    c.currency_desc,
                                    a.policy_id,
                                    a.fnl_binder_id,
                                    a.ppw
                    FROM giis_line b, giis_currency c, giac_outfacul_soa_ext a 
                    WHERE a.currency_cd = c.main_currency_cd
                      AND a.line_cd = b.line_cd
                      AND a.cut_off_date = v_cut_off
                      AND a.as_of_date = v_as_of
                      AND a.ri_cd = nvl(p_ri_cd,a.ri_cd)
                      AND a.line_cd = nvl(p_line_cd,a.line_cd)
                      AND a.fnet_due <> 0
                      AND a.user_id = p_user
                      AND a.policy_id = nvl(p_policy_id,a.policy_id)
                      AND a.fnl_binder_id = nvl(p_fnl_binder_id,a.fnl_binder_id)
                ORDER BY  a.ri_name,  b.line_name, a.eff_date,  a.booking_date, a.binder_no, a.policy_no, a.currency_cd, a.currency_rt
       )
LOOP
    FOR b IN (
            SELECT column_no, column_title
                   FROM giis_report_aging
                WHERE report_id = 'GIACR296'
                AND (   (branch_cd IS NOT NULL AND branch_cd = v_user_branch)   -- jhing 01.30.2016 GENQA 4099,4100,4103,4102,4101
                                OR (    branch_cd IS NULL
                                    AND (SELECT COUNT (1)
                                           FROM giis_report_aging t
                                          WHERE t.branch_cd = v_user_branch AND t.report_id = 'GIACR296') =
                                           0))
                ORDER BY column_no asc
                )
    LOOP
    v_rec.d_column_no := b.column_no; 
        FOR z IN (
                                  SELECT   a.ri_cd, 
                                  a.line_cd, 
                                  a.fnet_due,
                                  a.currency_cd, 
                                  a.currency_rt,
                                  a.policy_id,
                                  a.fnl_binder_id,
                                  c.column_no
                                  
                       FROM giis_report_aging c, giac_outfacul_soa_ext a 
                       WHERE 1=1
                          AND c.report_id = 'GIACR296'
                          AND c.column_no = a.column_no
                          AND a.cut_off_date = v_cut_off
                          AND a.as_of_date = v_as_of
                          AND a.ri_cd = i.ri_cd
                          AND a.line_cd = i.line_cd
                          AND a.fnet_due <> 0
                          AND a.user_id = p_user
                          AND a.currency_cd = nvl(p_currency_cd,i.currency_cd)
                          AND a.currency_rt = nvl(p_currency_rt,i.currency_rt)
                          AND a.policy_id = nvl(p_policy_id,i.policy_id)
                          AND a.fnl_binder_id = nvl(p_fnl_binder_id,i.fnl_binder_id)
                          AND a.fnet_due = nvl(p_fnet_due,i.fnet_due)
                          AND (   (c.branch_cd IS NOT NULL AND c.branch_cd = v_user_branch)   -- jhing 01.30.2016 GENQA 4099,4100,4103,4102,4101
                                OR (    c.branch_cd IS NULL
                                    AND (SELECT COUNT (1)
                                           FROM giis_report_aging t
                                          WHERE t.branch_cd = v_user_branch AND t.report_id = 'GIACR296') =
                                           0))
                  )
        LOOP
            IF b.column_no = z.column_no THEN
                      v_rec.d_fnet_due   := z.fnet_due;
                      
            ELSE
                      v_rec.d_fnet_due   := null;
                      
            END IF;
            v_rec.d_ri_cd := z.ri_cd;
            v_rec.d_line_cd := z.line_cd;
            v_rec.d_currency_cd := z.currency_cd;
            v_rec.d_currency_rt := z.currency_rt;
            v_rec.d_policy_id := z.policy_id;
            v_rec.d_fnl_binder_id := z.fnl_binder_id;
            
            PIPE ROW(v_rec);
        END LOOP;  
                       
    END LOOP;
END LOOP;
END populate_giacr296c_matrix;
FUNCTION populate_giacr296c_header ( p_user_id VARCHAR2 )  -- jhing added p_user_id 01.30.2016 GENQA 4099,4100,4103,4102,4101
RETURN giacr296c_header_tab PIPELINED
AS
    v_rec giacr296c_header_type;
    v_user_branch    giis_issource.iss_cd%TYPE ;   
BEGIN

 -- jhing 01.30.2016 GENQA 4099,4100,4103,4102,4101
FOR tx IN(SELECT b.grp_iss_cd
                      FROM giis_users a, giis_user_grp_hdr b
                     WHERE a.user_grp = b.user_grp AND a.user_id = p_user_id)
LOOP
     
   v_user_branch := tx.grp_iss_cd; 
END LOOP;   

FOR i IN (
            SELECT column_no, column_title
               FROM giis_report_aging
            WHERE report_id = 'GIACR296'
                AND (   (branch_cd IS NOT NULL AND branch_cd = v_user_branch)   -- jhing 01.30.2016 GENQA 4099,4100,4103,4102,4101
                                OR (    branch_cd IS NULL
                                    AND (SELECT COUNT (1)
                                           FROM giis_report_aging t
                                          WHERE t.branch_cd = v_user_branch AND t.report_id = 'GIACR296') =
                                           0))
            ORDER BY column_no asc
            )
LOOP
    v_rec.column_no := i.column_no;
    v_rec.column_title := i.column_title;
PIPE ROW(v_rec);
END LOOP;            
END populate_giacr296c_header;
FUNCTION populate_giacr296c_old(
    p_as_of         varchar2,
    p_cut_off       varchar2,
    p_ri_cd         NUMBER,
    p_line_cd       VARCHAR2,
    p_user          VARCHAR2
)
RETURN giacr296c_tab_old PIPELINED AS

v_rec       giacr296c_type_old;
v_as_of     DATE    := TO_DATE(p_as_of,'fmMM/DD/YYYY');
v_cut_off   DATE    := TO_DATE(p_cut_off,'fmMM/DD/YYYY');

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
                    a.fprem_amt, 
                    a.fprem_vat, 
                    a.fcomm_amt, 
                    a.fcomm_vat, 
                    a.fwholding_vat, 
                    a.fnet_due,
                    a.currency_cd, 
                    a.currency_rt,
                    c.currency_desc,
                    a.policy_id,
                    a.fnl_binder_id,
                    a.ppw
    FROM giis_line b, giis_currency c, giac_outfacul_soa_ext a 
    WHERE a.currency_cd = c.main_currency_cd
      AND a.line_cd = b.line_cd
      AND a.cut_off_date = v_cut_off
      AND a.as_of_date = v_as_of
      AND a.ri_cd = nvl(p_ri_cd, a.ri_cd)
      AND a.line_cd = nvl(p_line_cd,a.line_cd)
      AND a.fnet_due <> 0
      AND a.user_id = p_user
ORDER BY  a.ri_name,  b.line_name, a.eff_date,  a.booking_date, a.binder_no, a.policy_no, a.currency_cd, a.currency_rt

    )
    LOOP
        v_rec.ri_name           := i.ri_name;
        v_rec.line_name         := i.line_name;
        v_rec.eff_date          := i.eff_date;
        v_rec.booking_date      := i.booking_date;
        v_rec.binder_no         := i.binder_no;
        v_rec.ppw               := i.ppw;
        v_rec.policy_no         := i.policy_no;
        v_rec.assd_name         := i.assd_name;
        v_rec.fprem_amt         := i.fprem_amt;
        v_rec.fprem_vat         := i.fprem_vat;
        v_rec.fcomm_amt         := i.fcomm_amt;
        v_rec.fcomm_vat         := i.fcomm_vat;
        v_rec.fwholding_vat     := i.fwholding_vat;
        v_rec.fnet_due          := i.fnet_due;
        v_rec.policy_id         := i.policy_id;
        v_rec.fnl_binder_id     := i.fnl_binder_id;
        v_rec.ri_cd             := i.ri_cd;
        v_rec.line_cd           := i.line_cd;
        v_rec.currency_cd       := i.currency_cd;
        v_rec.currency_rt       := i.currency_rt;
        v_rec.currency_desc     := i.currency_desc;

        PIPE ROW(v_rec);
    END LOOP;
END populate_giacr296c_old;

   FUNCTION get_csv_cols
      RETURN csv_col_tab PIPELINED
   IS
      v_list csv_col_type;
   BEGIN
      FOR i IN (SELECT argument_name
                  FROM all_arguments
   		        WHERE owner = 'CPI'
     	             AND package_name = 'CSV_SOA'
     	             AND object_name = 'CSV_GIACR296C'
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
         ELSIF i.argument_name = 'FPREM_AMT' THEN
            v_list.col_name := 'PREMIUM AMT';
         ELSIF i.argument_name = 'FPREM_VAT' THEN
            v_list.col_name := 'VAT ON PREM';
         ELSIF i.argument_name = 'FCOMM_AMT' THEN
            v_list.col_name := 'COMMISSION AMT';
         ELSIF i.argument_name = 'FCOMM_VAT' THEN
            v_list.col_name := 'VAT ON COMM';
         ELSIF i.argument_name = 'FWHOLDING_VAT' THEN
            v_list.col_name := 'WHOLDING VAT';
         ELSIF i.argument_name = 'FNET_DUE' THEN
            v_list.col_name := 'NET DUE';
         ELSIF i.argument_name = 'CURRENCY_CD' THEN
            v_list.col_name := 'CURRENCY CODE';
         ELSIF i.argument_name = 'CURRENCY_RT' THEN
            v_list.col_name := 'CONVERT RATE';
         ELSIF i.argument_name = 'CURRENCY_DESC' THEN
            v_list.col_name := 'CURRENCY DESC';           
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
   
   FUNCTION populate_giacr296c(
      p_as_of         VARCHAR2,
      p_cut_off       VARCHAR2,
      p_ri_cd         NUMBER,
      p_line_cd       VARCHAR2,
      p_user          VARCHAR2
   ) RETURN giacr296c_tab PIPELINED AS
      v_list          giacr296c_type;
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
      
      FOR tx IN (SELECT b.grp_iss_cd
                   FROM giis_users a, giis_user_grp_hdr b
                  WHERE a.user_grp = b.user_grp AND a.user_id = p_user)
      LOOP
         v_user_branch := tx.grp_iss_cd; 
      END LOOP; 
                                   
      FOR i IN (SELECT a.ri_cd, a.ri_name, a.line_cd, b.line_name, a.eff_date, 
                       a.booking_date, a.binder_no, a.policy_no, a.assd_name,
                       a.fprem_amt, a.fprem_vat, a.fcomm_amt, a.fcomm_vat, a.fwholding_vat, 
                       a.fnet_due, a.currency_cd, a.currency_rt, c.currency_desc, a.policy_id,
                       a.fnl_binder_id, a.ppw
                  FROM giis_line b, giis_currency c, giac_outfacul_soa_ext a 
                 WHERE a.currency_cd = c.main_currency_cd
                   AND a.line_cd = b.line_cd
                   AND a.cut_off_date = v_cut_off
                   AND a.as_of_date = v_as_of
                   AND a.ri_cd = nvl(p_ri_cd, a.ri_cd)
                   AND a.line_cd = nvl(p_line_cd,a.line_cd)
                   AND a.fnet_due <> 0
                   AND a.user_id = p_user
                 ORDER BY a.ri_name, b.line_name, a.eff_date,  a.booking_date, a.binder_no, a.policy_no, a.currency_cd, a.currency_rt)
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
         v_list.fprem_amt         := i.fprem_amt;
         v_list.fprem_vat         := i.fprem_vat;
         v_list.fcomm_amt         := i.fcomm_amt;
         v_list.fcomm_vat         := i.fcomm_vat;
         v_list.fwholding_vat     := i.fwholding_vat;
         v_list.fnet_due          := i.fnet_due;
         v_list.policy_id         := i.policy_id;
         v_list.fnl_binder_id     := i.fnl_binder_id;
         v_list.ri_cd             := i.ri_cd;
         v_list.line_cd           := i.line_cd;
         v_list.currency_cd       := i.currency_cd;
         v_list.currency_rt       := i.currency_rt;
         v_list.currency_desc     := i.currency_desc;

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
         
         FOR cs IN (SELECT SUM(a.fnet_due) fnet_due, SUM(a.fprem_amt) fprem_amt, SUM(a.fprem_vat) fprem_vat, 
                       SUM(a.fcomm_amt) fcomm_amt, SUM(a.fcomm_vat) fcomm_vat, SUM(a.fwholding_vat) fwholding_vat
                     FROM giis_report_aging c, giac_outfacul_soa_ext a 
                    WHERE 1=1
                      AND c.report_id = 'GIACR296'
                      AND c.column_no = a.column_no
                      AND a.cut_off_date = v_cut_off
                      AND a.as_of_date = v_as_of
                      AND a.ri_cd = i.ri_cd
                      AND a.line_cd = i.line_cd
                      AND a.fnet_due <> 0
                      AND a.user_id = p_user
                      AND a.currency_cd = i.currency_cd
                      AND ((c.branch_cd IS NOT NULL AND c.branch_cd = v_user_branch)
                            OR (c.branch_cd IS NULL
                                AND (SELECT COUNT (1)
                                       FROM giis_report_aging t
                                      WHERE t.branch_cd = v_user_branch AND t.report_id = 'GIACR296') = 0)))
         LOOP
            v_list.sum_curr_fprem_amt        := cs.fprem_amt;
            v_list.sum_curr_fprem_vat        := cs.fprem_vat;
            v_list.sum_curr_fcomm_amt        := cs.fcomm_amt;
            v_list.sum_curr_fcomm_vat        := cs.fcomm_vat;
            v_list.sum_curr_fwholding_vat    := cs.fwholding_vat;
            v_list.sum_curr_fnet_due         := cs.fnet_due;
         END LOOP;
         
         FOR j IN (SELECT *
                     FROM TABLE(GIACR296C_PKG.get_column_header(p_user)))
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
               v_list.fnet_due1 := 0;
            ELSE
               v_list.fnet_due1 := NULL;
            END IF;
                            
            IF j.col_no2 IS NOT NULL THEN
               v_list.fnet_due2 := 0;
            ELSE
               v_list.fnet_due2 := NULL;
            END IF;
                            
            IF j.col_no3 IS NOT NULL THEN
               v_list.fnet_due3 := 0;
            ELSE
               v_list.fnet_due3 := NULL;
            END IF;
                            
            IF j.col_no4 IS NOT NULL THEN
               v_list.fnet_due4 := 0;
            ELSE
               v_list.fnet_due4 := NULL;
            END IF;
         
            BEGIN
               SELECT COUNT(DISTINCT currency_rt)
                 INTO v_list.curr_rt_count
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
                  AND a.currency_cd = i.currency_cd
                  AND a.lnet_due <> 0
                  AND a.user_id = p_user;
            EXCEPTION WHEN NO_DATA_FOUND THEN
               v_list.curr_rt_count := 1;
            END;
            
            SELECT MAX(currency_rt)
              INTO v_list.curr_rt_max
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
               AND a.currency_cd = i.currency_cd
               AND a.lnet_due <> 0
               AND a.user_id = p_user;
         
            FOR l IN (SELECT a.ri_cd, 
                             a.line_cd, 
                             a.fnet_due,
                             a.currency_cd, 
                             a.currency_rt,
                             a.policy_id,
                             a.fnl_binder_id,
                             c.column_no  
                        FROM giis_report_aging c, giac_outfacul_soa_ext a 
                       WHERE 1=1
                          AND c.report_id = 'GIACR296'
                          AND c.column_no = a.column_no
                          AND a.cut_off_date = v_cut_off
                          AND a.as_of_date = v_as_of
                          AND a.ri_cd = i.ri_cd
                          AND a.line_cd = i.line_cd
                          AND a.fnet_due <> 0
                          AND a.user_id = p_user
                          AND a.currency_cd = i.currency_cd
                          AND a.currency_rt = i.currency_rt
                          AND a.policy_id = i.policy_id
                          AND a.fnl_binder_id = i.fnl_binder_id
                          AND a.fnet_due = i.fnet_due
                          AND ((c.branch_cd IS NOT NULL AND c.branch_cd = v_user_branch)
                                OR (c.branch_cd IS NULL
                                    AND (SELECT COUNT (1)
                                           FROM giis_report_aging t
                                          WHERE t.branch_cd = v_user_branch AND t.report_id = 'GIACR296') =
                                           0)))
            LOOP 
               IF j.col_no1 = l.column_no THEN
                  v_list.fnet_due1 := NVL(l.fnet_due,0);
                  v_list.column_no1 := j.row1;
                  v_list.sum_curr_fnet_due1 := giacr296c_pkg.get_currency_row_total(p_cut_off, p_as_of, i.ri_cd, i.line_cd, i.currency_cd, j.row1, v_user_branch, p_user);
               ELSIF j.col_no2 = l.column_no THEN
                  v_list.fnet_due2 := NVL(l.fnet_due,0);
                  v_list.column_no2 := j.row2;
                  v_list.sum_curr_fnet_due2 := giacr296c_pkg.get_currency_row_total(p_cut_off, p_as_of, i.ri_cd, i.line_cd, i.currency_cd, j.row2, v_user_branch, p_user);
               ELSIF j.col_no3 = l.column_no THEN
                  v_list.fnet_due3 := NVL(l.fnet_due,0);
                  v_list.column_no3 := j.row3;
                  v_list.sum_curr_fnet_due3 := giacr296c_pkg.get_currency_row_total(p_cut_off, p_as_of, i.ri_cd, i.line_cd, i.currency_cd, j.row3, v_user_branch, p_user);
               ELSIF j.col_no4 = l.column_no THEN
                  v_list.fnet_due4 := NVL(l.fnet_due,0);
                  v_list.column_no4 := j.row4;
                  v_list.sum_curr_fnet_due4 := giacr296c_pkg.get_currency_row_total(p_cut_off, p_as_of, i.ri_cd, i.line_cd, i.currency_cd, j.row4, v_user_branch, p_user);
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
   
   FUNCTION get_currency_row_total(
      p_cut_off         VARCHAR2,
      p_as_of           VARCHAR2,
      p_ri_cd           giac_outfacul_soa_ext.ri_cd%TYPE,
      p_line_cd         giac_outfacul_soa_ext.line_cd%TYPE,
      p_currency_cd     giac_outfacul_soa_ext.currency_cd%TYPE,
      p_column_no       giac_outfacul_soa_ext.column_no%TYPE,
      p_user_branch     giis_report_aging.branch_cd%TYPE,
      p_user_id         giac_outfacul_soa_ext.user_id%TYPE
   ) RETURN NUMBER AS
      v_sum_fnet_due    giac_outfacul_soa_ext.fnet_due%TYPE;
      v_as_of           DATE    := TO_DATE(p_as_of,'MM/DD/YYYY');
      v_cut_off         DATE    := TO_DATE(p_cut_off,'MM/DD/YYYY');
   BEGIN
      FOR i IN (SELECT SUM(a.fnet_due) sum_fnet_due
                  FROM giis_report_aging c, giac_outfacul_soa_ext a 
                 WHERE 1=1
                   AND c.report_id = 'GIACR296'
                   AND c.column_no = a.column_no
                   AND a.column_no = p_column_no
                   AND a.cut_off_date = v_cut_off
                   AND a.as_of_date = v_as_of
                   AND a.ri_cd = p_ri_cd
                   AND a.line_cd = p_line_cd
                   AND a.fnet_due <> 0
                   AND a.user_id = p_user_id
                   AND a.currency_cd = p_currency_cd
                   AND ((c.branch_cd IS NOT NULL AND c.branch_cd = p_user_branch)
                         OR (c.branch_cd IS NULL
                             AND (SELECT COUNT (1)
                                    FROM giis_report_aging t
                                   WHERE t.branch_cd = p_user_branch AND t.report_id = 'GIACR296') = 0)))
      LOOP
         v_sum_fnet_due := i.sum_fnet_due;
         
         RETURN v_sum_fnet_due; 
      END LOOP;
   END;
   -- bonok :: 5.4.2016 :: SR-4099,4100,4103,4102,4101,5281,21898 start
   
END GIACR296C_PKG;
/


