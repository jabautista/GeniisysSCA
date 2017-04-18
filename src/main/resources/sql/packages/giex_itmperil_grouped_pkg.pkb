CREATE OR REPLACE PACKAGE BODY CPI.giex_itmperil_grouped_pkg
AS

    /*
    **  Created by       : Robert John Virrey
    **  Date Created     : 02.20.2012
    **  Reference By     : (GIEXS007- Edit Peril Information)
    **  Description      : update_witem_grp program unit
    */
    PROCEDURE update_witem_grp(
        p_policy_id       IN    giex_itmperil_grouped.policy_id%TYPE,
        p_item_no         IN    giex_itmperil_grouped.item_no%TYPE,
        p_grouped_item_no IN    giex_itmperil_grouped.grouped_item_no%TYPE,
        p_recompute_tax   IN    VARCHAR2,
        p_tax_sw          IN    VARCHAR2,
        p_nbt_prem_amt   OUT    giex_itmperil_grouped.prem_amt%TYPE,
        p_ann_prem_amt   OUT    giex_itmperil_grouped.ann_prem_amt%TYPE,
        p_nbt_tsi_amt    OUT    giex_itmperil_grouped.tsi_amt%TYPE,
        p_ann_tsi_amt    OUT    giex_itmperil_grouped.ann_tsi_amt%TYPE
    ) 
    IS
      CURSOR d1 IS --added by bdarusin, 12052002, copied from create_winvoice
        SELECT param_value_n
          FROM giac_parameters
         WHERE param_name = 'DOC_STAMPS';

      CURSOR e1 IS
        SELECT param_value_v
          FROM giis_parameters
         WHERE param_name = 'COMPUTE_OLD_DOC_STAMPS';
         
      CURSOR f1 IS --added by roset, 9/30/2010
        SELECT param_value_v
          FROM giis_parameters
         WHERE param_name = 'COMPUTE_PA_DOC_STAMPS';
         
      v_menu_line           giis_line.menu_line_cd%TYPE;      --roset, 9/30/2010         
      v_param_pa_doc        giis_parameters.param_value_v%TYPE; --added by roset, 9/30/2010 
      v_doc_stamps          giis_tax_charges.tax_cd%TYPE;
      v_param_old_doc       giis_parameters.param_value_v%TYPE; 
      v_tax_amount2         giex_new_group_tax.tax_amt%TYPE := 0; --end of added codes, bdarusin, 12052002
      v_tax_amount          giex_new_group_tax.tax_amt%TYPE := 0;
      v_sum_tax_amt         giex_expiry.tax_amt%TYPE := 0;
      v_prem_amt            giex_itmperil.prem_amt%TYPE :=0;
      v_tsi_amt             giex_itmperil.tsi_amt%TYPE :=0;
      v_exist               VARCHAR2(1):='N';
      v_peril_sw            giis_tax_peril.peril_sw%TYPE;
      v_peril_prem          giex_itmperil.prem_amt%TYPE :=0;
      v_line_cd             gipi_polbasic.line_cd%TYPE;
      v_lgt_exist           VARCHAR2(1):='N';
    BEGIN
      OPEN d1; --added by bdarusin, copied from create_winvoice
      FETCH d1
       INTO v_doc_stamps;
      CLOSE d1;
      OPEN e1;
      FETCH e1
       INTO v_param_old_doc;
      CLOSE e1; --end of added codes, bdarusin, 12052002
      OPEN f1; --added by roset, 9/30/2010
      FETCH f1
       INTO v_param_pa_doc;
      CLOSE f1;
      
      IF p_recompute_tax = 'N' THEN
          FOR A IN (SELECT  sum(NVL(prem_amt,0)) prem,
                            sum(NVL(ann_prem_amt,0)) ann_prem
                      FROM  giex_itmperil_grouped
                     WHERE  policy_id  =  p_policy_id
                       AND  item_no = p_item_no
                       AND  grouped_item_no = p_grouped_item_no) 
          LOOP
                 p_nbt_prem_amt     :=  A.prem;
                 p_ann_prem_amt     :=  A.ann_prem;
          END LOOP;
          FOR B IN (SELECT  sum(NVL(a.tsi_amt,0)) tsi,
                            sum(NVL(a.ann_tsi_amt,0)) ann_tsi                        
                      FROM  giex_itmperil_grouped a,giis_peril b
                     WHERE  a.line_cd    =  b.line_cd
                       AND  a.peril_cd   =  b.peril_cd
                       AND  b.peril_type =  'B'
                       AND  a.policy_id  =  p_policy_id
                       AND  item_no = p_item_no 
                       AND  grouped_item_no = p_grouped_item_no) 
          LOOP
                 p_nbt_tsi_amt     :=  B.tsi;
                 p_ann_tsi_amt     :=  B.ann_tsi;
                 v_tsi_amt         :=  B.tsi;
          END LOOP;
        /*beth 09112000 insert records in table giex_new_group_peril */
          DELETE giex_new_group_peril
           WHERE policy_id = p_policy_id;
          --CLEAR_MESSAGE;
        END IF;  
      FOR C IN (SELECT sum(nvl(a.prem_amt,0)) prem_amt,
                       sum(nvl(a.tsi_amt,0)) tsi_amt,
                       a.line_cd, a.peril_cd
                  FROM giex_itmperil_grouped a
                 WHERE policy_id = p_policy_id
              GROUP BY a.line_cd, a.peril_cd)
      LOOP
        v_prem_amt := v_prem_amt + c.prem_amt;
        IF p_recompute_tax = 'N' THEN
              INSERT INTO giex_new_group_peril
                         (policy_id,        line_cd,      peril_cd,     prem_amt,    tsi_amt)
                   VALUES(p_policy_id,    c.line_cd,    c.peril_cd,   c.prem_amt, c.tsi_amt);
          END IF;         
      END LOOP;                         
      
      /*UPDATE giex_expiry
         SET ren_tsi_amt  = v_tsi_amt,
             ren_prem_amt = v_prem_amt
       WHERE policy_id = :b240.policy_id;*/
      
    /*richelle 12062000 insert records in table giex_new_group_tax */
      FOR E IN (SELECT '1' 
                  FROM giex_new_group_tax
                 WHERE policy_id=p_policy_id) 
      LOOP
         v_exist := 'Y';
      END LOOP;
      IF v_exist = 'N' OR
           p_tax_sw = 'N' THEN
         DELETE giex_new_group_tax
          WHERE policy_id = p_policy_id;
           --CLEAR_MESSAGE;
           FOR D IN (SELECT DISTINCT a.line_cd, a.iss_cd, a.tax_cd, a.tax_id, a.tax_desc,--added DISTINCT by Edison 05.04.2012
                               /*Modified by Edison04.25.2012, to get the rate of the tax in giis_tax_issue_place
                               **if the policy has an issue place 
                               **NVL (b.rate, 0) rate,*/
                               DECODE (c.place_cd, NULL, b.rate, 
                               DECODE( a.line_cd||'-'||a.iss_cd||'-'||a.tax_cd||'-'||a.tax_id||'-'||c.place_cd,
                                       d.line_cd||'-'||d.iss_cd||'-'||d.tax_cd||'-'||d.tax_id||'-'||d.place_cd, d.rate, b.rate ))rate,
                               --end of modification
                               a.tax_amt, a.currency_tax_amt, b.peril_sw --a.currency_tax_amt - Added by Jerome Bautista 03.03.2016 SR 21634
                          FROM giex_old_group_tax a, giis_tax_charges b,
                               gipi_polbasic c, giis_tax_issue_place d --added by Edison04.25.2012
                         WHERE a.line_cd = b.line_cd
                           AND a.iss_cd = b.iss_cd
                           AND a.tax_cd = b.tax_cd
                           AND a.tax_id = b.tax_id --uncommented by gmi to resolve foreign key constraint err
                         --modified condition by Edison 05.14.2012
						   AND (a.line_cd = d.line_cd (+)                        
                           AND a.iss_cd = d.iss_cd (+))
   						   AND DECODE(c.place_Cd,NULL,'1',a.iss_cd) = DECODE(c.place_cd,NULL,'1',NVL(d.iss_cd,a.iss_cd))
                           AND DECODE(c.place_Cd,NULL,'1',a.line_cd) = DECODE(c.place_cd,NULL,'1',NVL(d.line_cd,a.line_cd))
                           AND DECODE(c.place_Cd,NULL,'1',c.place_cd) = DECODE(c.place_cd,NULL,'1',NVL(d.place_cd,c.place_cd))
                           AND a.policy_id = c.policy_id 
   						--end of modified condition 05.14.2012 
                           AND nvl(b.expired_sw,'N') != 'Y'
                           AND b.pol_endt_sw in ('B','P')  
                            AND ((b.eff_start_date <= (SELECT ADD_MONTHS(nvl(eff_date,incept_date),12)
                                                                                   FROM gipi_polbasic
                                                                             WHERE policy_id = p_policy_id)
                                                                               AND NVL(b.issue_date_tag,'N') = 'N')
                                                                            /*AND b.eff_end_date >= (select ADD_MONTHS(nvl(eff_date,incept_date),12) 
                                                                                                                                        from gipi_polbasic
                                                                                                                               where policy_id = :b240.policy_id)
                                                                                                                                    and NVL(b.issue_date_tag,'N') = 'N') */
                       OR
                            (b.eff_start_date <= (SELECT ADD_MONTHS(issue_date,12) 
                                                                               FROM gipi_polbasic
                                                                         WHERE policy_id = p_policy_id)
                                                                           AND nvl(b.issue_date_tag,'N') = 'Y')
                                                                          /*AND b.eff_end_date >= (select ADD_MONTHS(issue_date,12)
                                                                                                                                    from gipi_polbasic
                                                                                                                         where policy_id = :b240.policy_id)
                                                                                                                              and nvl(b.issue_date_tag,'N') = 'Y')*/)
                           AND a.policy_id = p_policy_id) 
            loop
                    v_peril_sw := D.peril_sw;
                    /*added by roset menu line cd 9/30/2010*/
            SELECT menu_line_cd
              INTO v_menu_line
              FROM giis_line
             WHERE line_cd = d.line_cd;


                    IF v_peril_sw = 'N' THEN             
                       v_tax_amount        := v_prem_amt * d.rate / 100;
                       IF d.tax_cd = v_doc_stamps AND v_param_old_doc  = 'Y' THEN --added by bdarusin, copied from create_winvoice
                          IF v_menu_line = 'AC' AND v_param_pa_doc = 2 THEN --added by roset, 9/30/2010
                               v_tax_amount := CEIL(v_prem_amt / 200) * (0.5);
                          ELSE
                               v_tax_amount := CEIL(v_prem_amt / 4) * (0.5); 
                          END IF;
                       END IF;                                                                                                         --end of added codes, bdarusin, 12052002
                    ELSE
                       FOR E IN ( SELECT SUM(NVL(A.prem_amt,0)) prem_amt
                                FROM giex_new_group_peril A
                                WHERE A.peril_cd IN (SELECT peril_cd
                                                      FROM giis_tax_peril
                                                        WHERE line_cd = D.line_cd
                                                       AND iss_cd  = D.iss_cd
                                                      AND tax_cd  = D.tax_cd)
                                AND A.policy_id   = p_policy_id
                        GROUP BY A.peril_cd)  
                        LOOP
                             v_peril_prem := v_peril_prem + e.prem_amt;                   
                        END LOOP;   
                        v_tax_amount        := v_peril_prem * d.rate / 100;    
                          IF d.tax_cd = v_doc_stamps AND v_param_old_doc  = 'Y' THEN --added by bdarusin, copied from create_winvoice
                               IF v_menu_line = 'AC' AND v_param_pa_doc = 2 THEN --added by roset, 9/30/2010
                                   v_tax_amount := CEIL(v_peril_prem / 200) * (0.5);
                               ELSE
                                   v_tax_amount := CEIL(v_peril_prem / 4) * (0.5);
                               END IF;               
                          END IF;                                                                                                         --end of added codes, bdarusin, 12052002
                     
                     END IF;

                     IF d.rate = 0 THEN
                          v_tax_amount2 := d.tax_amt;
                         IF d.tax_cd = v_doc_stamps AND v_param_old_doc  = 'Y' THEN --added by bdarusin, copied from create_winvoice
                            IF v_menu_line = 'AC' AND v_param_pa_doc = 2 THEN --added by roset, 9/30/2010
                                v_tax_amount2 := CEIL(v_prem_amt / 200) * (0.5);
                            ELSE
                                   v_tax_amount2 := CEIL(v_prem_amt / 4) * (0.5);
                            END IF;       
                        END IF;                                                                                                         --end of added codes, bdarusin, 12052002
                       
                        INSERT INTO giex_new_group_tax
                                            (policy_id,                     line_cd,             iss_cd,         tax_cd,            tax_id,            
                                           tax_desc,                      tax_amt,                  currency_tax_amt,            rate) -- currency_tax_amt - Added by Jerome Bautista SR 21634
                                  VALUES(p_policy_id,     d.line_cd,             d.iss_cd,     d.tax_cd,     d.tax_id, 
                                                d.tax_desc,              v_tax_amount2,       d.currency_tax_amt,                d.rate);  --v_tax_amt2 was previously d.tax_amt, bdarusin, 12052002 -- d.currency_tax_amt - Added by Jerome Bautista SR 21634
                     ELSE             
                       INSERT INTO giex_new_group_tax
                                            (policy_id,                     line_cd,                 iss_cd,         tax_cd,            tax_id,            
                                           tax_desc,                      tax_amt,                  currency_tax_amt,                rate) -- currency_tax_amt - Added by Jerome Bautista SR 21634
                                   VALUES(p_policy_id,     d.line_cd,             d.iss_cd,     d.tax_cd,     d.tax_id, 
                                                d.tax_desc,              v_tax_amount,       d.currency_tax_amt,        d.rate); -- d.currency_tax_amt - Added by Jerome Bautista SR 21634
                     END IF;
                V_LINE_CD := D.LINE_CD;
            END LOOP;
    -- TEMPORARY SOLUTION FOR LGT...
    /*    FOR F IN (SELECT '1'
                                FROM giex_new_group_tax
                             WHERE tax_cd = 9
                               AND policy_id = :b240.policy_id) LOOP
              v_lgt_exist := 'Y'; 
        EXIT;
        END LOOP;
                             
    --        IF V_LINE_CD = 'MC' THEN
        IF v_lgt_exist = 'N' THEN
                 V_TAX_AMOUNT := V_PREM_AMT * .0075;
               INSERT INTO giex_new_group_tax
                     (policy_id,                     line_cd,                 iss_cd,         tax_cd,            tax_id,            
                    tax_desc,                      tax_amt,                rate)
               VALUES
                 (:b240.policy_id,       v_line_cd,             'HO',         9,                     2, 
                       'LOCAL GOVT TAX',   v_tax_amount,        .75);
            END IF;*/
        END IF;                       
    END;
    
    /*
    **  Created by       : Robert John Virrey
    **  Date Created     : 02.20.2012
    **  Reference By     : (GIEXS007- Edit Peril Information)
    **  Description      : get_latest_grouped_item_title program unit
    */
    FUNCTION GET_LATEST_GROUPED_ITEM_TITLE(
        p_line_cd 	 IN gipi_polbasic.line_cd%TYPE,
        p_subline_cd IN gipi_polbasic.subline_cd%TYPE,
        p_iss_cd     IN gipi_polbasic.iss_cd%TYPE,
        p_issue_yy 	 IN gipi_polbasic.issue_yy%TYPE,
        p_pol_seq_no IN gipi_polbasic.pol_seq_no%TYPE,
        p_renew_no 	 IN gipi_polbasic.renew_no%TYPE,
        p_grouped_no IN gipi_grouped_items.grouped_item_no%TYPE
    ) 
    RETURN VARCHAR2 
    IS
        latest_title gipi_item.item_title%TYPE;
    BEGIN
      FOR get IN (SELECT c.grouped_item_title item_title
                                FROM gipi_polbasic a, gipi_item b, gipi_grouped_items c
                               WHERE 1 = 1
                                 AND a.policy_id = b.policy_id
                                 AND a.policy_id = c.policy_id
                                 and b.item_no   = c.item_no
                                 AND c.grouped_item_no = p_grouped_no
                                 AND a.line_cd = p_line_cd
                                 AND a.subline_cd = p_subline_Cd
                                 AND a.iss_cd = p_iss_cd
                                 AND a.issue_yy = p_issue_yy
                                 AND a.pol_seq_no = p_pol_seq_no
                                 AND a.renew_no = p_renew_no
                               ORDER BY a.endt_seq_no DESC)
        LOOP		
              latest_title := get.item_title;
              EXIT;
        END LOOP;						     
      RETURN latest_title;   
    END;
    
    /*
    **  Created by       : Robert John Virrey
    **  Date Created     : 02.20.2012
    **  Reference By     : (GIEXS007- Edit Peril Information)
    **  Description      : Retrieves B480_grp data block 
    */
    FUNCTION get_giexs007_b480_grp_info (
        p_policy_id   GIEX_ITMPERIL_GROUPED.policy_id%TYPE
    )
    RETURN giex_itmperil_grouped_tab PIPELINED
    IS
        v_itmperil_grp   giex_itmperil_grouped_type;
        v_line_cd 	 gipi_polbasic.line_cd%TYPE;
        v_subline_cd gipi_polbasic.subline_cd%TYPE;
        v_iss_cd 	 gipi_polbasic.iss_cd%TYPE;
        v_issue_yy 	 gipi_polbasic.issue_yy%TYPE;
        v_pol_seq_no gipi_polbasic.pol_seq_no%TYPE;
        v_renew_no 	 gipi_polbasic.renew_no%TYPE;
    BEGIN
      SELECT line_cd,subline_cd,iss_cd,issue_yy, pol_seq_no, renew_no
       INTO v_line_cd,v_subline_cd,v_iss_cd,v_issue_yy,v_pol_seq_no,v_renew_no
       FROM gipi_polbasic 
      WHERE policy_id = p_policy_id;  
    
      FOR i IN (SELECT DISTINCT LINE_CD, ITEM_NO, GROUPED_ITEM_NO, POLICY_ID 
                  FROM GIEX_ITMPERIL_GROUPED
                 WHERE policy_id = p_policy_id)
        LOOP
         v_itmperil_grp.line_cd             := i.line_cd;
         v_itmperil_grp.item_no             := i.item_no;
         v_itmperil_grp.grouped_item_no     := i.grouped_item_no;
         v_itmperil_grp.policy_id           := i.policy_id;
         
        
         FOR A IN (SELECT  sum(NVL(prem_amt,0)) prem,
                            sum(NVL(ann_prem_amt,0)) ann_prem
                      FROM  giex_itmperil_grouped
                     WHERE  policy_id       = i.policy_id
                       AND  item_no         = i.item_no
                       AND  grouped_item_no = i.grouped_item_no) 
          LOOP
                 v_itmperil_grp.nbt_prem_amt     :=  A.prem;
                 v_itmperil_grp.ann_prem_amt     :=  A.ann_prem;
          END LOOP;
          
          FOR B IN (SELECT  sum(NVL(a.tsi_amt,0)) tsi,
                            sum(NVL(a.ann_tsi_amt,0)) ann_tsi                        
                      FROM  giex_itmperil_grouped a,giis_peril b
                     WHERE  a.line_cd    =  b.line_cd
                       AND  a.peril_cd   =  b.peril_cd
                       AND  b.peril_type =  'B'
                       AND  a.policy_id     = i.policy_id
                       AND  item_no         = i.item_no 
                       AND  grouped_item_no = i.grouped_item_no) 
          LOOP
                 v_itmperil_grp.nbt_tsi_amt     :=  B.tsi;
                 v_itmperil_grp.ann_tsi_amt     :=  B.ann_tsi;
          END LOOP;
         v_itmperil_grp.nbt_item_title := giex_itmperil_pkg.get_latest_item_title(v_line_cd,v_subline_cd,v_iss_cd,v_issue_yy,v_pol_seq_no,v_renew_no,i.item_no);
         v_itmperil_grp.nbt_grouped_item_title := giex_itmperil_grouped_pkg.get_latest_grouped_item_title(v_line_cd,v_subline_cd,v_iss_cd,v_issue_yy,v_pol_seq_no,v_renew_no,i.grouped_item_no);
         
        
         PIPE ROW (v_itmperil_grp);
        END LOOP;
    END get_giexs007_b480_grp_info;
     
    /*
    **  Created by       : Robert John Virrey
    **  Date Created     : 02.21.2012
    **  Reference By     : (GIEXS007- Edit Peril Information)
    **  Description      : Retrieves B490_grp data block 
    */
    FUNCTION get_giexs007_b490_grp_info (
        p_policy_id         GIEX_ITMPERIL_GROUPED.policy_id%TYPE,
        p_item_no           GIEX_ITMPERIL_GROUPED.item_no%TYPE,
        p_grouped_item_no   GIEX_ITMPERIL_GROUPED.grouped_item_no%TYPE
    )
    RETURN giex_itmperil_grouped_tab PIPELINED
    IS
        v_itmperil_grp   giex_itmperil_grouped_type;
    BEGIN
      FOR i IN (SELECT * 
                  FROM GIEX_ITMPERIL_GROUPED
                 WHERE policy_id = p_policy_id
                   AND item_no = p_item_no
                   AND grouped_item_no = p_grouped_item_no) --Added by Jerome Bautista 11.26.2015 SR 21016
        LOOP
            v_itmperil_grp.peril_cd        := i.peril_cd;
            v_itmperil_grp.prem_rt         := i.prem_rt;
            v_itmperil_grp.tsi_amt         := i.tsi_amt;
            v_itmperil_grp.prem_amt        := i.prem_amt;
            v_itmperil_grp.policy_id       := i.policy_id;
            v_itmperil_grp.item_no         := i.item_no;
            v_itmperil_grp.line_cd         := i.line_cd;
            v_itmperil_grp.ann_tsi_amt     := i.ann_tsi_amt;
            v_itmperil_grp.ann_prem_amt    := i.ann_prem_amt;
            v_itmperil_grp.aggregate_sw    := i.aggregate_sw;
            v_itmperil_grp.no_of_days      := i.no_of_days;
            v_itmperil_grp.base_amt        := i.base_amt;
         
            DECLARE
              CURSOR A IS
                SELECT   peril_name,peril_type,basc_perl_cd
                  FROM   giis_peril
                 WHERE   line_cd   =  i.line_cd
                   AND   peril_cd  =  i.peril_cd;
               peril     A%rowtype;
            BEGIN
              /* Update specific items in each record that would be
              ** used as basis for future transactions.
              ** Created by   : Bismark
              ** Last Update  : 12 May 1998
              */
              OPEN A;
              FETCH A INTO peril;
              v_itmperil_grp.dsp_peril_name   :=  peril.peril_name;
              v_itmperil_grp.dsp_peril_type   :=  peril.peril_type;
              v_itmperil_grp.dsp_basc_perl_cd :=  peril.basc_perl_cd;
              CLOSE A;
            END; 
         
         PIPE ROW (v_itmperil_grp);
        END LOOP;
    END get_giexs007_b490_grp_info;
    
    PROCEDURE POPULATE_PERIL_GRP(
        p_line_cd         IN     gipi_polbasic.line_cd%TYPE,
        p_subline_cd      IN     gipi_polbasic.subline_cd%TYPE,
        p_iss_cd          IN     gipi_polbasic.iss_cd%TYPE,
        p_nbt_issue_yy    IN     gipi_polbasic.issue_yy%TYPE,
        p_nbt_pol_seq_no  IN     gipi_polbasic.pol_seq_no%TYPE,
        p_nbt_renew_no    IN     gipi_polbasic.renew_no%TYPE,
        p_policy_id       IN     giex_itmperil.policy_id%TYPE,
        p_pack_pol_flag   IN     giis_line.pack_pol_flag%TYPE,
        p_for_delete      IN OUT VARCHAR2 
    ) 
    IS
      --rg_id              RECORDGROUP;
      rg_name            VARCHAR2(30) := 'GROUP_POLICY_GRP';
      rg_count           NUMBER;
      rg_count2          NUMBER;
      rg_col             VARCHAR2(50) := rg_name || '.policy_id';
      item_exist         VARCHAR2(1); 
      v_row              NUMBER;
      v_policy_id        gipi_polbasic.policy_id%TYPE;
      v_endt_id          gipi_polbasic.policy_id%TYPE;
      v_peril_cd         gipi_witmperl.peril_cd%TYPE;
      v_line_cd          gipi_witmperl.line_cd%TYPE;
      v_no_of_days       gipi_witmperl_grouped.no_of_days%TYPE;
      v_base_amt         gipi_witmperl_grouped.base_amt%TYPE;
      v_ri_comm_rate     gipi_witmperl_grouped.ri_comm_rate%TYPE;
      v_ri_comm_amt      gipi_witmperl_grouped.ri_comm_amt%TYPE;
      v_prem_rt          gipi_witmperl.prem_rt%TYPE;
      v_currency_rt      gipi_witem.currency_rt%TYPE;
      v_tsi_amt          gipi_witmperl.tsi_amt%TYPE;
      v_prem_amt         gipi_witmperl.prem_amt%TYPE;  
      v_item_title       gipi_witem.item_title%TYPE;
      v_grp_item_title       gipi_witem.item_title%TYPE;
      expire_sw          VARCHAR2(1) := 'N';
      v_dep_pct    NUMBER(3,2) := Giisp.n('MC_DEP_PCT')/100;
      v_tot_ren_tsi      giex_expiry.ren_tsi_amt%TYPE:=0;
      v_tot_ren_prem     giex_expiry.ren_prem_amt%TYPE:=0;  
      v_round_off GIIS_PARAMETERS.PARAM_VALUE_N%TYPE;
    BEGIN    
      --rg_id := Find_Group( 'GROUP_POLICY_GRP' ); 
      --IF NOT Id_Null(rg_id) THEN 
      --  Delete_Group( rg_id ); 
      --END IF; 
      --CHECK_POLICY_GROUP(rg_name);    
      --rg_id     := FIND_GROUP(rg_name);
      --rg_count  := GET_GROUP_ROW_COUNT(rg_id);
      --rg_count2 := rg_count;
      --FOR ROW_NO IN 1 .. rg_count  
      FOR b IN (SELECT policy_id , nvl(endt_seq_no,0) endt_seq_no, pol_flag
                  FROM gipi_polbasic
                 WHERE line_cd     = p_line_cd
                   AND subline_cd  = p_subline_cd
                   AND iss_cd      = p_iss_cd
                   AND issue_yy    = to_char(p_nbt_issue_yy)
                   AND pol_seq_no  = to_char(p_nbt_pol_seq_no)
                   AND renew_no    = to_char(p_nbt_renew_no)
                   AND (endt_seq_no = 0 OR 
                       (endt_seq_no > 0 AND 
                       TRUNC(endt_expiry_date) >= TRUNC(expiry_date))) --added by gmi
                   AND pol_flag IN ('1','2','3')      
                 ORDER BY eff_date, endt_seq_no)
      LOOP
        --v_policy_id  := GET_GROUP_NUMBER_CELL(rg_col,row_no);    
        v_policy_id  := b.policy_id;
        v_row        := v_row + 1;
        FOR DATA IN (SELECT a.peril_cd,      a.ann_prem_amt prem_amt,        a.ann_tsi_amt tsi_amt,
                            a.prem_rt,       a.line_cd,         a.item_no,
                            a.no_of_days,    a.base_amt,        a.ri_comm_rate,
                            a.ri_comm_amt,   a.aggregate_sw,
                            a.grouped_item_no,
                            b.item_title,    c.grouped_item_title,
                            b.pack_subline_cd,                  b.currency_rt        
                       FROM gipi_itmperil_grouped a, gipi_item b, gipi_grouped_items c
                      WHERE a.policy_id = c.policy_id
                        AND a.item_no = c.item_no
                        AND a.grouped_item_no = c.grouped_item_no
                        AND c.item_no = b.item_no
                        AND c.policy_id = b.policy_id
                        AND a.policy_id = v_policy_id)            
        LOOP
          item_exist := 'N';
          FOR CHK_ITEM IN (SELECT '1'
                            FROM giex_itmperil_grouped
                           WHERE peril_cd = data.peril_cd
                             AND item_no  = data.item_no
                             AND grouped_item_no = data.grouped_item_no
                             AND policy_id = p_policy_id)
          LOOP
            item_exist := 'Y';
            EXIT;
          END LOOP;
          IF item_exist = 'N' THEN            
             v_currency_rt      := data.currency_rt;     
             v_peril_cd         := data.peril_cd;
             v_line_cd          := data.line_cd;
             v_prem_amt         := data.prem_amt;
             v_tsi_amt          := data.tsi_amt;
             v_item_title       := data.item_title;
             v_grp_item_title   := data.grouped_item_title;
             v_prem_rt          := data.prem_rt; 
             v_ri_comm_rate     := data.ri_comm_rate;        
             v_ri_comm_amt      := data.ri_comm_amt;
             v_base_amt         := data.base_amt;
             v_no_of_days       := data.no_of_days;         
             
             FOR c IN (SELECT policy_id , nvl(endt_seq_no,0) endt_seq_no, pol_flag
                  FROM gipi_polbasic
                 WHERE line_cd     = p_line_cd
                   AND subline_cd  = p_subline_cd
                   AND iss_cd      = p_iss_cd
                   AND issue_yy    = to_char(p_nbt_issue_yy)
                   AND pol_seq_no  = to_char(p_nbt_pol_seq_no)
                   AND renew_no    = to_char(p_nbt_renew_no)
                   AND (endt_seq_no = 0 OR 
                       (endt_seq_no > 0 AND 
                       TRUNC(endt_expiry_date) >= TRUNC(expiry_date))) --added by gmi
                   AND pol_flag IN ('1','2','3')      
                 ORDER BY eff_date, endt_seq_no)
             --FOR row_no2 IN  v_row..rg_count2 
             LOOP
               --v_endt_id  := GET_GROUP_NUMBER_CELL(rg_col,row_no2);
               v_endt_id  := c.policy_id;
               FOR DATA2 IN (SELECT a.ann_prem_amt prem_amt,        a.ann_tsi_amt tsi_amt,
                                    a.prem_rt,         
                                    a.no_of_days,    a.base_amt,        a.ri_comm_rate,
                                    a.ri_comm_amt,
                                    b.item_title,      c.grouped_item_title
                               FROM gipi_itmperil_grouped a, gipi_item b, gipi_grouped_items c
                              WHERE a.policy_id = c.policy_id
                                AND a.item_no = c.item_no
                                AND a.grouped_item_no = c.grouped_item_no
                                AND c.item_no = b.item_no
                                AND c.policy_id = b.policy_id
                                AND peril_cd  = v_peril_cd
                                AND a.item_no = data.item_no
                                AND a.grouped_item_no = data.grouped_item_no          
                                AND a.policy_id = v_endt_id)
               LOOP
                 IF v_policy_id <> v_endt_id THEN    
                    v_item_title       := NVL(data2.item_title, v_item_title);
                    v_grp_item_title   := NVL(data2.grouped_item_title, v_grp_item_title);
                    --v_prem_amt         := NVL(v_prem_amt,0) + NVL(data2.prem_amt,0);
                    v_prem_amt         := NVL(data2.prem_amt,0);
                    --v_tsi_amt          := NVL(v_tsi_amt,0) + NVL(data2.tsi_amt,0);
                    v_tsi_amt          := NVL(data2.tsi_amt,0);
    --                v_no_of_days       := NVL(v_no_of_days,0) + NVL(data2.no_of_days,0);
                    v_base_amt         := NVL(v_base_amt,0) + NVL(data2.base_amt,0);
                    v_ri_comm_amt      := NVL(v_ri_comm_amt,0) + NVL(data2.ri_comm_amt,0);
                    IF NVL(data2.prem_rt,0) > 0 THEN
                       v_prem_rt          := data2.prem_rt;
                    END IF;                
                 END IF;                   
               END LOOP;
             END LOOP;     
             
             /* JEROME.O 10102008 
               Added for rounding off/depreciate renewal tsi amount  
               */
               SELECT DECODE(param_value_n,10,-1,100,-2,1000,-3,10000,-4,100000,-5,1000000,-6,9)
                 INTO v_round_off
                 FROM giis_parameters
                WHERE param_name = 'ROUND_OFF_PLACE' ;
             
             IF NVL(v_tsi_amt,0) > 0  THEN
                --CLEAR_MESSAGE;
                --MESSAGE('Copying peril info ...',NO_ACKNOWLEDGE);
                --SYNCHRONIZE;
                --msg_alert(v_line_cd||'-'||v_peril_cd,'I',FALSE);  -- jenny vi lim 03312005
                /*FOR a IN (
                         SELECT '1'                
                                     FROM giex_dep_perl b
                               WHERE b.line_cd  = v_line_cd
                                AND b.peril_cd  = v_peril_cd
                                AND Giisp.v('AUTO_COMPUTE_MC_DEP') = 'Y')
                            LOOP            
                              --v_tsi_amt  := v_tsi_amt - (v_tsi_amt*v_dep_pct);
                              v_tsi_amt  := ROUND((v_tsi_amt - (v_tsi_amt*v_dep_pct)),v_round_off);
                              --v_prem_amt := v_prem_amt - (v_prem_amt*v_dep_pct);--v_tsi_amt * (v_prem_rt/100); made comment by roset, 11/24/2010
                              v_prem_amt := v_tsi_amt * (v_prem_rt/100);    --roset, 11/24/2010, premium based on rounded off tsi                      
                            END LOOP;
                            --v_prem_rt := ((NVL(v_prem_amt,0) / NVL(v_tsi_amt,0)) * 100); --added by gmi 101107 --made comment by roset 11/24/2010
                            */ --benjo 11.23.2016 UCPBGEN-SR-23130 comment out
                            
                            compute_depreciation_amounts (v_policy_id, data.item_no, v_line_cd, v_peril_cd, v_tsi_amt); --benjo 11.23.2016 UCPBGEN-SR-23130
                            
                            IF p_for_delete = 'Y' THEN
                                v_tot_ren_tsi  := v_tot_ren_tsi  + v_tsi_amt;
                                v_tot_ren_prem := v_tot_ren_prem + v_prem_amt;
                            ELSE                        
                            INSERT INTO giex_itmperil_grouped (
                                             policy_id,         item_no,        grouped_item_no,
                                             peril_cd, 
                                             line_cd,           tsi_amt,        prem_amt,
                                             prem_rt,           ann_tsi_amt,    ann_prem_amt,
                                             ri_comm_rate,      ri_comm_amt,    no_of_days,
                                             base_amt,          aggregate_sw)
                                      VALUES(p_policy_id,   data.item_no,   data.grouped_item_no,
                                             v_peril_cd,
                                             v_line_cd,         v_tsi_amt,      v_prem_amt,
                                             v_prem_rt,         v_tsi_amt,      v_prem_amt,
                                             v_ri_comm_rate,    v_ri_comm_amt,  v_no_of_days,
                                             v_base_amt,        data.aggregate_sw);                     
                                v_peril_cd         := NULL;
                                v_line_cd          := NULL;
                                v_prem_amt         := NULL;
                                v_tsi_amt          := NULL;
                                v_prem_rt          := NULL;                        
                           END IF;      
             END IF;                 
          ELSE
             NULL;         
          END IF;                        
        END LOOP;
      END LOOP;
      /*IF variables.for_delete = 'Y' THEN
          UPDATE giex_expiry
             SET ren_tsi_amt = v_tot_ren_tsi,
                 ren_prem_amt = v_tot_ren_prem
           WHERE policy_id = :b240.policy_id;
      END IF;*/
    END;
    
    PROCEDURE POPULATE_PERIL2_GRP(
        p_pack_pol_flag     giis_line.pack_pol_flag%TYPE,
        p_subline_cd        giex_itmperil.subline_cd%TYPE,
        p_policy_id         giex_itmperil.policy_id%TYPE,
        p_for_delete        VARCHAR2
    ) 
    IS
      v_dep_pct	NUMBER(3,2);
      v_tot_ren_tsi      giex_expiry.ren_tsi_amt%TYPE:=0;
      v_tot_ren_prem     giex_expiry.ren_prem_amt%TYPE:=0;  
    BEGIN	
      v_dep_pct := Giisp.n('MC_DEP_PCT')/100;
      FOR DATA IN (SELECT a.peril_cd,      a.ann_prem_amt prem_amt,        a.ann_tsi_amt tsi_amt,
                          a.prem_rt,       b.item_title,      c.grouped_item_title,
                          a.line_cd,       a.item_no,         a.grouped_item_no,
                          a.ri_comm_rate,  a.ri_comm_amt,     a.no_of_days,
                          a.aggregate_sw,  a.base_amt,				a.rec_flag, 
                          NVL(a.ann_tsi_amt, a.tsi_amt) ann_tsi_amt,
                          NVL(a.ann_prem_amt,a.prem_amt) ann_prem_amt,
                          DECODE(NVL(p_pack_pol_flag, 'N'), 'N', p_subline_cd,b.pack_subline_cd) subline_cd
                     FROM gipi_itmperil_grouped a, gipi_item b, gipi_grouped_items c
                    WHERE a.policy_id = c.policy_id
                      AND a.item_no = c.item_no
                      AND a.grouped_item_no = c.grouped_item_no
                      AND c.item_no = b.item_no
                      AND c.policy_id = b.policy_id
                      AND a.policy_id = p_policy_id)
      LOOP
        /*FOR a IN (
           SELECT '1'			    
             FROM giex_dep_perl b
            WHERE b.line_cd  = data.line_cd
              AND b.peril_cd = data.peril_cd
              AND Giisp.v('AUTO_COMPUTE_MC_DEP') = 'Y')
            LOOP			
                data.tsi_amt      := data.tsi_amt - (data.tsi_amt*v_dep_pct);
                data.ann_tsi_amt  := data.ann_tsi_amt - (data.ann_tsi_amt*v_dep_pct);
--                data.prem_amt     := data.tsi_amt * (data.prem_rt/100);
--                data.ann_prem_amt := data.tsi_amt * (data.prem_rt/100);
                data.prem_amt      := data.ann_prem_amt - (data.ann_prem_amt*v_dep_pct);
                data.ann_prem_amt  := data.ann_prem_amt - (data.ann_prem_amt*v_dep_pct);
            END LOOP;*/ --benjo 11.23.2016 UCPBGEN-SR-23130 comment out
            
            compute_depreciation_amounts (p_policy_id, data.item_no, data.line_cd, data.peril_cd, data.tsi_amt); --benjo 11.23.2016 UCPBGEN-SR-23130
            
            data.prem_rt := ((NVL(data.prem_amt,0) / NVL(data.tsi_amt,0)) * 100); --added by gmi 101107
            IF p_for_delete = 'Y' THEN
                v_tot_ren_tsi  := v_tot_ren_tsi + data.ann_tsi_amt;
                v_tot_ren_prem := v_tot_ren_prem + data.ann_prem_amt;
            ELSE		
                INSERT INTO giex_itmperil_grouped(
                              policy_id,         item_no,        grouped_item_no,
                              peril_cd,          line_cd,        tsi_amt,        
                              prem_amt,          prem_rt,        ann_tsi_amt,    
                              ann_prem_amt,      
                              ri_comm_rate,      ri_comm_amt,    no_of_days,
                              aggregate_sw,      base_amt,			 rec_flag)
                       VALUES(p_policy_id,       data.item_no,      data.grouped_item_no,
                              data.peril_cd,     data.line_cd,      data.tsi_amt,      
                              data.prem_amt,     data.prem_rt,      data.ann_tsi_amt,  
                              data.ann_prem_amt,
                              data.ri_comm_rate, data.ri_comm_amt,  data.no_of_days,
                              data.aggregate_sw, data.base_amt,		data.rec_flag);
            END IF;
      END LOOP;
    END;
    
    PROCEDURE CREATE_PERIL_GRP(
        p_policy_id       IN     giex_expiry.policy_id%TYPE,
        p_pack_policy_id  IN     giex_expiry.pack_policy_id%TYPE,
        p_summary_sw      IN     giex_expiry.summary_sw%TYPE,
        p_line_cd         IN     gipi_polbasic.line_cd%TYPE,
        p_subline_cd      IN     gipi_polbasic.subline_cd%TYPE,
        p_iss_cd          IN     gipi_polbasic.iss_cd%TYPE,
        p_nbt_issue_yy    IN     gipi_polbasic.issue_yy%TYPE,
        p_nbt_pol_seq_no  IN     gipi_polbasic.pol_seq_no%TYPE,
        p_nbt_renew_no    IN     gipi_polbasic.renew_no%TYPE,
        p_pack_pol_flag   IN     giis_line.pack_pol_flag%TYPE,
        p_item_no         IN     giex_itmperil.item_no%TYPE,
        p_grouped_item_no IN     giex_itmperil_grouped.grouped_item_no%TYPE,
        p_recompute_tax   IN     VARCHAR2,
        p_tax_sw          IN     VARCHAR2,
        p_for_delete      IN OUT VARCHAR2,
        p_nbt_prem_amt       OUT giex_itmperil.prem_amt%TYPE,
        p_ann_prem_amt       OUT giex_itmperil.ann_prem_amt%TYPE,
        p_nbt_tsi_amt        OUT giex_itmperil.tsi_amt%TYPE,
        p_ann_tsi_amt        OUT giex_itmperil.ann_tsi_amt%TYPE
    )
    IS
    BEGIN
     /*GO_BLOCK('B490_GRP');        
      IF :b490_grp.peril_cd IS NOT NULL THEN
         alert_id   := FIND_ALERT('DEFAULT');
         alert_but  := SHOW_ALERT(ALERT_ID);
         IF alert_but = ALERT_BUTTON1 THEN 
            NULL;
         ELSE
            RAISE FORM_TRIGGER_FAILURE;
         END IF;
      END IF; 
      CLEAR_BLOCK(NO_VALIDATE);
      GO_BLOCK('B480_GRP');
      CLEAR_BLOCK(NO_VALIDATE);
      rg_id := Find_Group( 'EXISTING_PERILS_GRP' ); 
      IF NOT Id_Null(rg_id) THEN 
        Delete_Group( rg_id ); 
      END IF;  */
       
      DELETE giex_itmperil_grouped
       WHERE policy_id = p_policy_id;
       
      DELETE giex_new_group_peril
       WHERE policy_id = p_policy_id;
       
      DELETE giex_new_group_tax
       WHERE policy_id = p_policy_id;
       
      --FORMS_DDL('COMMIT');  
      IF NVL(p_summary_sw, 'N') = 'Y' THEN
           --pause; --jenny vi lim 03312005
         giex_itmperil_grouped_pkg.populate_peril_grp(p_line_cd, p_subline_cd, p_iss_cd, p_nbt_issue_yy, p_nbt_pol_seq_no, p_nbt_renew_no, p_policy_id, p_pack_pol_flag, p_for_delete);
      ELSE
         giex_itmperil_grouped_pkg.populate_peril2_grp(p_pack_pol_flag, p_subline_cd, p_policy_id, p_for_delete);
      END IF;  
      giex_itmperil_grouped_pkg.update_witem_grp(p_policy_id, p_item_no, p_grouped_item_no, p_recompute_tax, p_tax_sw, p_nbt_prem_amt, p_ann_prem_amt, p_nbt_tsi_amt, p_ann_tsi_amt);
      --FORMS_DDL('COMMIT');   
      --update_tsi_per_peril;
      --FORMS_DDL('COMMIT');   
      --GO_BLOCK('B480_GRP');
      --EXECUTE_QUERY;
      --CLEAR_MESSAGE;
     -- CHECK_FOR_EXISTING_GROUP('EXISTING_PERILS');
      --SET_ITEM_PROPERTY('CONTROL.CREATE_PERIL_GRP',LABEL,'Recreate Peril(s)');
      --SET_ITEM_PROPERTY('CONTROL.DELETE_PERIL_GRP',ENABLED, PROPERTY_TRUE);
      --SET_ITEM_PROPERTY('CONTROL.EDIT_TAX_CHARGES_GRP',ENABLED, PROPERTY_TRUE);
      --:B490_GRP.PREM_AMT := :B490_GRP.PREM_AMT;
      /*giex_itmperil_pkg.initial_create_peril(p_policy_id, p_pack_policy_id, p_summary_sw, p_line_cd, p_subline_cd, p_iss_cd, p_nbt_issue_yy,
                                             p_nbt_pol_seq_no, p_nbt_renew_no, p_pack_pol_flag, p_item_no, p_grouped_item_no, p_recompute_tax,
                                             p_tax_sw, p_for_delete, p_nbt_prem_amt, p_ann_prem_amt, p_nbt_tsi_amt, p_ann_tsi_amt);*/
    END;
    
    PROCEDURE DELETE_PERIL_GRP(
        p_policy_id       IN     giex_expiry.policy_id%TYPE,
        p_summary_sw      IN     giex_expiry.summary_sw%TYPE,
        p_line_cd         IN     gipi_polbasic.line_cd%TYPE,
        p_subline_cd      IN     gipi_polbasic.subline_cd%TYPE,
        p_iss_cd          IN     gipi_polbasic.iss_cd%TYPE,
        p_nbt_issue_yy    IN     gipi_polbasic.issue_yy%TYPE,
        p_nbt_pol_seq_no  IN     gipi_polbasic.pol_seq_no%TYPE,
        p_nbt_renew_no    IN     gipi_polbasic.renew_no%TYPE,
        p_pack_pol_flag   IN     giis_line.pack_pol_flag%TYPE
    )
    IS
        v_for_delete  VARCHAR2(1);
    BEGIN
     /*GO_BLOCK('B490_GRP');
      IF :B490_GRP.peril_cd IS NOT NULL THEN
         alert_id   := FIND_ALERT('DELETE');
         alert_but  := SHOW_ALERT(ALERT_ID);
         IF alert_but = ALERT_BUTTON1 THEN 
            NULL;
         ELSE
            RAISE FORM_TRIGGER_FAILURE;
         END IF;
      END IF; 
      CLEAR_BLOCK(NO_VALIDATE);
      GO_BLOCK('B480_GRP');
      CLEAR_BLOCK(NO_VALIDATE);*/
      
      DELETE giex_itmperil_grouped
       WHERE policy_id = p_policy_id;
       
      DELETE giex_new_group_peril
       WHERE policy_id = p_policy_id;
       
      DELETE giex_new_group_tax
       WHERE policy_id = p_policy_id;
       
      v_for_delete := 'Y'; 
      IF NVL(p_summary_sw, 'N') = 'Y' THEN
           --pause; --jenny vi lim 03312005
         giex_itmperil_grouped_pkg.populate_peril_grp(p_line_cd, p_subline_cd, p_iss_cd, p_nbt_issue_yy, p_nbt_pol_seq_no, p_nbt_renew_no, p_policy_id, p_pack_pol_flag, v_for_delete);
      ELSE
         giex_itmperil_grouped_pkg.populate_peril2_grp(p_pack_pol_flag, p_subline_cd, p_policy_id, v_for_delete);
      END IF;
      v_for_delete := 'N';   
      
      /*GO_BLOCK('B480_GRP');
      EXECUTE_QUERY;
      CLEAR_MESSAGE;
      SET_ITEM_PROPERTY('CONTROL.CREATE_PERIL_GRP',LABEL,'Create Peril(s)');
      SET_ITEM_PROPERTY('CONTROL.DELETE_PERIL_GRP',ENABLED, PROPERTY_FALSE);
      SET_ITEM_PROPERTY('CONTROL.EDIT_TAX_CHARGES_GRP',ENABLED, PROPERTY_FALSE);
      :B240.POLICY_ID := :B240.POLICY_ID;*/
    END;
    
    PROCEDURE set_b490_grp_dtls (
        p_policy_id         giex_itmperil_grouped.policy_id%TYPE,
        p_item_no           giex_itmperil_grouped.item_no%TYPE,
        p_grouped_item_no   giex_itmperil_grouped.grouped_item_no%TYPE,
        p_line_cd           giex_itmperil_grouped.line_cd%TYPE,
        p_peril_cd          giex_itmperil_grouped.peril_cd%TYPE,
        p_prem_rt           giex_itmperil_grouped.prem_rt%TYPE,
        p_prem_amt          giex_itmperil_grouped.prem_amt%TYPE,
        p_tsi_amt           giex_itmperil_grouped.tsi_amt%TYPE,
        p_ann_tsi_amt       giex_itmperil_grouped.ann_tsi_amt%TYPE,
        p_ann_prem_amt      giex_itmperil_grouped.ann_prem_amt%TYPE,
        p_aggregate_sw      giex_itmperil_grouped.aggregate_sw%TYPE,
        p_base_amt          giex_itmperil_grouped.base_amt%TYPE,
        p_no_of_days        giex_itmperil_grouped.no_of_days%TYPE
    ) 
    IS
    BEGIN
        MERGE INTO giex_itmperil_grouped
        USING dual ON (policy_id        = p_policy_id       AND
                       item_no          = p_item_no         AND
                       grouped_item_no  = p_grouped_item_no AND
                       peril_cd         = p_peril_cd)
         WHEN NOT MATCHED THEN
            INSERT (
                policy_id,         item_no,         grouped_item_no,       line_cd,             peril_cd,   
                prem_rt,           prem_amt,        tsi_amt,               ann_tsi_amt,         ann_prem_amt,
                aggregate_sw,      base_amt,        no_of_days
            )
            VALUES (
                p_policy_id,       p_item_no,       p_grouped_item_no,     p_line_cd,           p_peril_cd,   
                p_prem_rt,         p_prem_amt,      p_tsi_amt,             p_ann_tsi_amt,       p_ann_prem_amt,
                p_aggregate_sw,    p_base_amt,      p_no_of_days
            )
            WHEN MATCHED THEN
            UPDATE SET  line_cd         = p_line_cd,
                        prem_rt         = p_prem_rt,
                        prem_amt        = p_prem_amt,
                        tsi_amt         = p_tsi_amt,
                        ann_tsi_amt     = p_ann_tsi_amt,
                        ann_prem_amt    = p_ann_prem_amt,
                        aggregate_sw    = p_aggregate_sw,
                        base_amt        = p_base_amt,
                        no_of_days      = p_no_of_days;
    END set_b490_grp_dtls;

END giex_itmperil_grouped_pkg;
/


