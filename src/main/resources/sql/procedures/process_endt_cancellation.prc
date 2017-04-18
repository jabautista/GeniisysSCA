DROP PROCEDURE CPI.PROCESS_ENDT_CANCELLATION;

CREATE OR REPLACE PROCEDURE CPI.Process_Endt_Cancellation (
	p_par_id			IN GIPI_WPOLBAS.par_id%TYPE,
	p_policy_id			IN GIPI_POLBASIC.policy_id%TYPE,
	p_line_cd			IN GIPI_WPOLBAS.line_cd%TYPE,
	p_subline_cd		IN GIPI_WPOLBAS.subline_cd%TYPE,
	p_iss_cd			IN GIPI_WPOLBAS.iss_cd%TYPE,
	p_issue_yy			IN GIPI_WPOLBAS.issue_yy%TYPE,
	p_pol_seq_no		IN GIPI_WPOLBAS.pol_seq_no%TYPE,
	p_renew_no			IN GIPI_WPOLBAS.renew_no%TYPE,	
	p_pack_pol_flag		IN GIPI_WPOLBAS.pack_pol_flag%TYPE,
	p_cancel_type		IN GIPI_WPOLBAS.cancel_type%TYPE,
	p_eff_date			IN OUT VARCHAR2,
	p_endt_expiry_date	OUT VARCHAR2,
	p_expiry_date		OUT VARCHAR2,
	p_tsi_amt			OUT GIPI_WPOLBAS.tsi_amt%TYPE,
	p_prem_amt			OUT GIPI_WPOLBAS.prem_amt%TYPE,
	p_ann_tsi_amt        OUT GIPI_WPOLBAS.ann_tsi_amt%TYPE,
    p_ann_prem_amt        OUT GIPI_WPOLBAS.ann_prem_amt%TYPE,
    p_prorate_flag        OUT GIPI_WPOLBAS.prorate_flag%TYPE,
    p_prov_prem_pct        OUT GIPI_WPOLBAS.prov_prem_pct%TYPE,
    p_prov_prem_tag        OUT GIPI_WPOLBAS.prov_prem_tag%TYPE,
    p_short_rt_percent    OUT GIPI_WPOLBAS.short_rt_percent%TYPE,    
    p_comp_sw            OUT GIPI_WPOLBAS.comp_sw%TYPE,
    p_msg_alert            OUT VARCHAR2)
AS
    /*    Date            Author                    Reference                            Description
    **    ==========    ====================    ===================================    ============================================================
    **    07.09.2010    mark jm                 GIPIS031 - Endt Basic Information    creates negated records on item and item peril table    
    **    09.09.2011    mark jm                 UW-SPECS-2011-00037 (Applied)        replace FOR LOOP statement that verify and correct the 
    **                                                                                annual amounts in GIPI_POLBASIC and GIPI_ITEM table 
    **                                                                                when pack_pol_flag <> 'Y'    
    */
    
    v_eff_date            GIPI_POLBASIC.eff_date%TYPE := TO_DATE(p_eff_date, 'MM-DD-RRRR HH24:MI:SS');
    v_expiry_date        GIPI_POLBASIC.expiry_date%TYPE := TO_DATE(p_expiry_date, 'MM-DD-RRRR HH24:MI:SS');
    v_endt_expiry_date     GIPI_POLBASIC.endt_expiry_date%TYPE := TO_DATE(p_endt_expiry_date, 'MM-DD-RRRR HH24:MI:SS');
    v_prorate            NUMBER;
    v_item_ann_prem        GIPI_ITEM.ann_prem_amt%TYPE;
    v_item_ann_tsi        GIPI_ITEM.ann_tsi_amt%TYPE;
    v_perl_ann_prem        GIPI_ITEM.ann_prem_amt%TYPE;
    v_perl_ann_tsi        GIPI_ITEM.ann_tsi_amt%TYPE;
    v_item_prem            GIPI_ITEM.ann_prem_amt%TYPE;
    v_item_tsi            GIPI_ITEM.ann_tsi_amt%TYPE;
    v_perl_prem            GIPI_ITEM.ann_prem_amt%TYPE;
    v_perl_tsi            GIPI_ITEM.ann_tsi_amt%TYPE;
    v_pol_prem            GIPI_POLBASIC.ann_prem_amt%TYPE;
    v_pol_tsi            GIPI_POLBASIC.ann_tsi_amt%TYPE;
    v_pol_ann_prem        GIPI_POLBASIC.ann_prem_amt%TYPE;
    v_comp_prem            GIPI_ITEM.ann_prem_amt%TYPE;
    v_comp_var            NUMBER;
    v_prov_discount        NUMBER(12,9);
    v_post_sw            VARCHAR2(1) := 'Y';
    v_agg_sw            GIPI_ITMPERIL.aggregate_sw%TYPE;
    
    CURSOR cur_item IS
        SELECT a.item_no,        a.item_title,    a.item_grp,
               a.ann_tsi_amt,    a.ann_prem_amt,    a.currency_cd,
               a.currency_rt,    a.pack_line_cd,    a.pack_subline_cd,
               a.group_cd,        a.tsi_amt,        a.prem_amt,
               b.region_cd,        a.item_desc,    a.item_desc2,
               a.coverage_cd,    a.from_date,    a.TO_DATE
          FROM GIPI_ITEM a, GIPI_POLBASIC b
         WHERE a.policy_id = b.policy_id
           AND a.policy_id = p_policy_id;
    
    CURSOR cur_peril(p_item_no IN GIPI_WITMPERL.item_no%TYPE) IS
        SELECT a.item_no,        a.line_cd,                a.peril_cd,        a.tarf_cd,  
               a.prem_rt,        a.tsi_amt,                a.prem_amt,        a.ann_tsi_amt,
               a.ann_prem_amt,    a.ri_comm_amt comm_amt,    a.ri_comm_rate comm_rate,
               a.aggregate_sw, a.comp_rem   --added a.comp_rem to get the remarks; John Daniel SR-21423
          FROM GIPI_ITMPERIL a
         WHERE a.policy_id = p_policy_id
         AND a.item_no = p_item_no;
         
   v_ann_tsi_amt NUMBER;
   v_ann_prem_amt NUMBER;
   v_msg_alert VARCHAR2(1000);         
         
BEGIN

   get_amounts(p_par_id, p_line_cd, p_subline_cd, p_iss_cd, p_issue_yy, p_pol_seq_no,
               p_renew_no, v_eff_date, v_ann_tsi_amt, v_ann_prem_amt, v_msg_alert); -- Apollo Cruz - fetching of correct ann amts 
    
    FOR C1 IN (
        SELECT eff_date,      endt_expiry_date, prorate_flag,
               prov_prem_pct, prov_prem_tag, short_rt_percent, 
               ann_tsi_amt,   ann_prem_amt,  comp_sw, expiry_date,
               incept_date
          FROM GIPI_POLBASIC
         WHERE policy_id = p_policy_id
           AND pol_flag IN ('1','2','3'))
    LOOP
        v_pol_prem := 0;
        v_pol_tsi  := 0;
        v_pol_ann_prem := 0;
        
        FOR C2 IN (
            SELECT DISTINCT item_no    item
              FROM GIPI_ITMPERIL
             WHERE policy_id = p_policy_id
               AND (NVL(tsi_amt,0)<>0 OR NVL(prem_amt,0)<>0))
        LOOP
            FOR C3 IN (
                SELECT '1'
                  FROM GIPI_ITMPERIL a, GIPI_POLBASIC b 
                 WHERE a.policy_id = b.policy_id
                   AND b.pol_flag IN ('1','2','3')
                   AND (NVL(a.tsi_amt,0) <>0 OR
                        NVL(a.prem_amt,0)<>0) 
                   AND b.line_cd = p_line_cd
                   AND b.subline_cd = p_subline_cd
                   AND b.iss_cd     = p_iss_cd
                   AND b.issue_yy   = p_issue_yy
                   AND b.pol_seq_no = p_pol_seq_no
                   AND b.renew_no   = p_renew_no
                   AND TRUNC(b.eff_date) > TRUNC(c1.eff_date)
                   AND a.item_no = c2.item
                   --robert 11.14.2012
                   ---added the ff codes to eliminate the cancellation endt and cancelled endt.
                   AND b.policy_id not in (select CANCELLED_ENDT_ID from gipi_polbasic)
                                   AND b.cancel_type <> 3)
                                   --robert 11.14.2012
            LOOP
                p_msg_alert := 'This endorsement cannot be cancelled there is an existing affecting endorsement that will be affected.';
                GOTO RAISE_FORM_TRIGGER_FAILURE;
            END LOOP;
        END LOOP;        
        
        Delete_All_Tables (p_par_id, p_line_cd,    p_subline_cd, p_iss_cd,
            p_issue_yy, p_pol_seq_no, p_renew_no, v_eff_date,
            p_msg_alert);
            
        IF p_msg_alert IS NOT NULL THEN
            GOTO RAISE_FORM_TRIGGER_FAILURE;
        END IF;
    
        p_prorate_flag         := c1.prorate_flag;
        p_prov_prem_pct     := c1.prov_prem_pct;
        p_prov_prem_tag     := c1.prov_prem_tag;
        p_short_rt_percent  := c1.short_rt_percent;
        p_comp_sw           := c1.comp_sw;
        p_prem_amt          := 0;
        p_tsi_amt           := 0;
        
        IF NVL(c1.prov_prem_tag,'N') = 'N' THEN
            v_prov_discount := 1;
        ELSE
            v_prov_discount := NVL(c1.prov_prem_pct/100,1);
        END IF;
        
        /* computation is based on prorate */
        IF c1.prorate_flag = '1' THEN
            v_eff_date := c1.eff_date + (1/1440);
            v_endt_expiry_date := c1.endt_expiry_date;
            v_expiry_date := c1.expiry_date;
            p_ann_prem_amt := c1.ann_prem_amt;
            p_ann_tsi_amt := c1.ann_tsi_amt;
            
            IF NVL(c1.comp_sw,'N') ='N' THEN
                v_comp_var  := 0;
            ELSIF NVL(c1.comp_sw,'N') ='Y' THEN
                v_comp_var  := 1;
            ELSE
                v_comp_var  := -1;
            END IF;
            
            v_prorate := ((TRUNC(C1.endt_expiry_date) - TRUNC(C1.eff_date)) + v_comp_var) /
                     Check_Duration(c1.incept_date, c1.expiry_date);
            
            FOR ITEM IN cur_item                       
            LOOP
                INSERT INTO GIPI_WITEM (
                    item_no,        item_title,        item_grp,
                    ann_tsi_amt,    ann_prem_amt,    currency_cd,
                    currency_rt,    pack_line_cd,    pack_subline_cd,
                    group_cd,        rec_flag,        tsi_amt,
                    prem_amt,        par_id,            region_cd,
                    item_desc,        item_desc2,        coverage_cd,
                    from_date,        TO_DATE)
                VALUES (
                    item.item_no,        item.item_title,    item.item_grp,
                    item.ann_tsi_amt,    item.ann_prem_amt,    item.currency_cd,
                    item.currency_rt,    item.pack_line_cd,    item.pack_subline_cd,
                    item.group_cd,        'C',                0,
                    0,                    p_par_id,            item.region_cd,
                    item.item_desc,        item.item_desc2,    item.coverage_cd,
                    item.from_date,        item.TO_DATE);
                
                --v_item_ann_tsi  := NVL(item.ann_tsi_amt,0) - NVL(item.tsi_amt,0); --commented out by John Daniel SR-21423
                --v_item_ann_prem := item.ann_prem_amt;
                v_pol_tsi := v_pol_tsi + (item.tsi_amt * item.currency_rt);
                v_pol_prem := v_pol_prem + (item.prem_amt * item.currency_rt);
                
                IF NVL(item.tsi_amt,0) = 0 THEN
                    v_item_tsi  := 0;
                ELSE
                    v_item_tsi  := -item.tsi_amt;
                END IF;

                IF NVL(item.prem_amt,0) = 0 THEN
                    v_item_prem  := 0;
                ELSE
                    v_item_prem  := -item.prem_amt;
                END IF;
            
                FOR PERL IN cur_peril(item.item_no)
                LOOP
                    v_perl_ann_tsi := NVL(perl.ann_tsi_amt,0) - NVL(perl.tsi_amt,0);
                    v_perl_ann_prem := NVL(perl.ann_prem_amt, 0) - NVL(perl.prem_amt, 0); --added by John Daniel SR-21423           
                    v_comp_prem := 0;
                    v_agg_sw := NVL(perl.aggregate_sw,'N');
                    
                    IF NVL(perl.comm_amt,0) = 0 THEN
                        perl.comm_amt  := 0;
                    ELSE
                        --perl.comm_amt  := -perl.prem_amt;
						perl.comm_amt  := -perl.comm_amt; -- bonok :: 10.02.2014
                    END IF;

                    IF NVL(perl.tsi_amt,0) = 0 THEN
                        v_perl_tsi  := 0;
                    ELSE
                        v_perl_tsi  := -perl.tsi_amt;
                    END IF;

                    IF NVL(perl.prem_amt,0) = 0 THEN
                        v_perl_prem  := 0;
                    ELSE
                        v_perl_prem  := -perl.prem_amt;
                    END IF;
                    
                    --commented out by John Daniel SR-21423 May 2, 2016
                    --IF NVL(perl.prem_amt,0) <> 0 OR  NVL(perl.tsi_amt,0) <>0 THEN                        
                    --    IF NVL(perl.tsi_amt,0) <> 0 AND NVL(perl.prem_rt,0) <> 0 THEN 
                    --        v_comp_prem := ((perl.tsi_amt * perl.prem_rt) /100) * v_prov_discount;
                    --    ELSE
                    --        v_comp_prem := perl.prem_amt/v_prorate;
                    --    END IF;
                        
                    --    v_pol_ann_prem  := v_pol_ann_prem + (v_comp_prem * item.currency_rt);
                    --   v_perl_ann_prem := perl.ann_prem_amt - v_comp_prem;
                    --    v_item_ann_prem := v_item_ann_prem - v_comp_prem;
                    --END IF;
                    
                    --added by John Daniel SR-21423; gets the total prem_amt and tsi_amt minus the endt to be cancelled
                    BEGIN
                        SELECT SUM(B.PREM_AMT), SUM(B.TSI_AMT)
                        INTO v_perl_ann_prem, v_perl_ann_tsi
                        FROM GIPI_POLBASIC A,
                             GIPI_ITMPERIL B
                        WHERE A.POL_FLAG <> 5
                        AND A.LINE_CD = p_line_cd
                        AND A.SUBLINE_CD = p_subline_cd
                        AND A.ISS_CD = p_iss_cd
                        AND A.ISSUE_YY = p_issue_yy
                        AND A.POL_SEQ_NO = p_pol_seq_no
                        AND A.RENEW_NO = p_renew_no
                        AND B.POLICY_ID = A.POLICY_ID
                        AND B.ITEM_NO = ITEM.ITEM_NO
                        AND A.POLICY_ID <> p_policy_id
                        AND B.PERIL_CD = perl.peril_cd
                        GROUP BY B.PERIL_CD;
                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN --meaning the item to be cancelled is also the item added to the endt
                        v_perl_ann_prem := 0;
                        v_perl_ann_tsi := 0;                    
                    END;
                    
                    v_item_ann_prem := NVL(v_item_ann_prem, 0) + v_perl_ann_prem;
                    v_item_ann_tsi := NVL(v_item_ann_tsi, 0) + v_perl_ann_tsi;
                    
                    INSERT INTO GIPI_WITMPERL (
                        par_id,         item_no,        line_cd,      peril_cd,    
                        prem_rt,        tarf_cd,        tsi_amt,      prem_amt,
                        ann_tsi_amt,    ann_prem_amt,   ri_comm_amt,  ri_comm_rate,
                        aggregate_sw, comp_rem) --added comp_rem for updating remark  
                    VALUES (
                        p_par_id,        item.item_no,       perl.line_cd,     perl.peril_cd,
                        perl.prem_rt,   perl.tarf_cd,       v_perl_tsi,       v_perl_prem,
                        v_perl_ann_tsi, v_perl_ann_prem,    perl.comm_amt,    perl.comm_rate,
                        v_agg_sw, perl.comp_rem); --added comp_rem for updating remark
                END LOOP;
                
                UPDATE GIPI_WITEM
                   SET prem_amt = v_item_prem,
                       tsi_amt  = v_item_tsi,
                       ann_prem_amt = v_item_ann_prem,
                       ann_tsi_amt  = v_item_ann_tsi
                 WHERE par_id  = p_par_id
                   AND item_no = item.item_no;
            END LOOP;
        /* computation is based on 1 year span */
        ELSIF c1.prorate_flag = '2' THEN
            IF c1.eff_date > v_eff_date THEN               
                v_eff_date := c1.eff_date + (1/1440);
                v_endt_expiry_date := c1.endt_expiry_date;
                v_expiry_date  := c1.expiry_date;
                p_ann_prem_amt := c1.ann_prem_amt;
                p_ann_tsi_amt  := c1.ann_tsi_amt;
            END IF;
            
            FOR ITEM IN cur_item                       
            LOOP
                INSERT INTO GIPI_WITEM (
                    item_no,        item_title,        item_grp,
                    ann_tsi_amt,    ann_prem_amt,    currency_cd,
                    currency_rt,    pack_line_cd,    pack_subline_cd,
                    group_cd,        rec_flag,        tsi_amt,
                    prem_amt,        par_id,            region_cd,
                    item_desc,        item_desc2,        coverage_cd,
                    from_date,        TO_DATE)
                VALUES (
                    item.item_no,        item.item_title,    item.item_grp,
                    item.ann_tsi_amt,    item.ann_prem_amt,    item.currency_cd,
                    item.currency_rt,    item.pack_line_cd,    item.pack_subline_cd,
                    item.group_cd,        'C',                0,
                    0,                    p_par_id,            item.region_cd,
                    item.item_desc,        item.item_desc2,    item.coverage_cd,
                    item.from_date,        item.TO_DATE);
                
                --v_item_ann_tsi  := NVL(item.ann_tsi_amt,0) - NVL(item.tsi_amt,0); --commented out by John Daniel SR-21423
                --v_item_ann_prem := item.ann_prem_amt;   
                v_pol_tsi := v_pol_tsi   + (item.tsi_amt * item.currency_rt);
                v_pol_prem := v_pol_prem + (item.prem_amt * item.currency_rt);
                
                IF NVL(item.tsi_amt,0) = 0 THEN
                    v_item_tsi  := 0;
                ELSE
                    v_item_tsi  := -item.tsi_amt;
                END IF;

                IF NVL(item.prem_amt,0) = 0 THEN
                    v_item_prem  := 0;
                ELSE
                    v_item_prem  := -item.prem_amt;
                END IF;
                
                FOR PERL IN cur_peril(item.item_no)
                LOOP
                    v_perl_ann_tsi := NVL(perl.ann_tsi_amt,0) - NVL(perl.tsi_amt,0);
                    v_perl_ann_prem := NVL(perl.ann_prem_amt, 0) - NVL(perl.prem_amt, 0); --added by John Daniel SR-21423 
                    v_agg_sw := NVL(perl.aggregate_sw,'N');
                    
                    IF NVL(perl.comm_amt,0) = 0 THEN
                        perl.comm_amt  := 0;
                    ELSE
                        --perl.comm_amt  := -perl.prem_amt;
						perl.comm_amt  := -perl.comm_amt; -- bonok :: 10.02.2014
                    END IF;

                    IF NVL(perl.tsi_amt,0) = 0 THEN
                        v_perl_tsi  := 0;
                    ELSE
                        v_perl_tsi  := -perl.tsi_amt;
                    END IF;

                    IF NVL(perl.prem_amt,0) = 0 THEN
                        v_perl_prem  := 0;
                    ELSE
                        v_perl_prem  := -perl.prem_amt;
                    END IF;
                    
                    --IF NVL(perl.prem_amt,0) <> 0 OR  NVL(perl.tsi_amt,0) <>0 THEN --commented out by John Daniel SR-21423
                    --    IF NVL(perl.tsi_amt,0) <> 0 AND NVL(perl.prem_rt,0) <> 0 THEN          
                    --        v_comp_prem := ((perl.tsi_amt * perl.prem_rt) /100) * v_prov_discount; 
                    --    ELSE
                    --        v_comp_prem := perl.prem_amt;
                    --    END IF;
                        
                    --    v_pol_ann_prem  := v_pol_ann_prem + (v_comp_prem * item.currency_rt);
                    --    v_perl_ann_prem := perl.ann_prem_amt - v_comp_prem;
                    --    v_item_ann_prem := v_item_ann_prem - v_comp_prem;
                    --END IF;
                    
                    --added by John Daniel SR-21423; gets the total prem_amt and tsi_amt minus the endt to be cancelled
                    BEGIN
                        SELECT SUM(B.PREM_AMT), SUM(B.TSI_AMT)
                        INTO v_perl_ann_prem, v_perl_ann_tsi
                        FROM GIPI_POLBASIC A,
                             GIPI_ITMPERIL B
                        WHERE A.POL_FLAG <> 5
                        AND A.LINE_CD = p_line_cd
                        AND A.SUBLINE_CD = p_subline_cd
                        AND A.ISS_CD = p_iss_cd
                        AND A.ISSUE_YY = p_issue_yy
                        AND A.POL_SEQ_NO = p_pol_seq_no
                        AND A.RENEW_NO = p_renew_no
                        AND B.POLICY_ID = A.POLICY_ID
                        AND B.ITEM_NO = ITEM.ITEM_NO
                        AND A.POLICY_ID <> p_policy_id
                        AND B.PERIL_CD = perl.peril_cd
                        GROUP BY B.PERIL_CD;
                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN --meaning the item to be cancelled is also the item added to the endt
                        v_perl_ann_prem := 0;
                        v_perl_ann_tsi := 0;                    
                    END;
                    
                    v_item_ann_prem := NVL(v_item_ann_prem, 0) + v_perl_ann_prem;
                    v_item_ann_tsi := NVL(v_item_ann_tsi, 0) + v_perl_ann_tsi;
                    
                    INSERT INTO GIPI_WITMPERL (
                        par_id,         item_no,        line_cd,      peril_cd,    
                        prem_rt,        tarf_cd,        tsi_amt,      prem_amt,
                        ann_tsi_amt,    ann_prem_amt,   ri_comm_amt,  ri_comm_rate,
                        aggregate_sw, comp_rem) --added comp_rem for updating remark
                    VALUES (
                        p_par_id,        item.item_no,       perl.line_cd,     perl.peril_cd,
                        perl.prem_rt,   perl.tarf_cd,       v_perl_tsi,       v_perl_prem,
                        v_perl_ann_tsi, v_perl_ann_prem,    perl.comm_amt,    perl.comm_rate,
                        v_agg_sw, perl.comp_rem); --added comp_rem for updating remark
                END LOOP;
                
                UPDATE GIPI_WITEM
                   SET prem_amt = v_item_prem,
                       tsi_amt  = v_item_tsi,
                       ann_prem_amt = v_item_ann_prem,
                       ann_tsi_amt  = v_item_ann_tsi
                 WHERE par_id  = p_par_id
                   AND item_no = item.item_no;
            END LOOP;
        /* computation is based on short rate */
        ELSIF c1.prorate_flag = '3' THEN
            IF c1.eff_date > v_eff_date  THEN               
                v_eff_date := c1.eff_date + (1/1440);
                v_endt_expiry_date := c1.endt_expiry_date;
                v_expiry_date  := c1.expiry_date;
                p_ann_prem_amt := c1.ann_prem_amt;
                p_ann_tsi_amt  := c1.ann_tsi_amt; 
            END IF;
            
            FOR ITEM IN cur_item
            LOOP
                INSERT INTO GIPI_WITEM (
                    item_no,        item_title,        item_grp,
                    ann_tsi_amt,    ann_prem_amt,    currency_cd,
                    currency_rt,    pack_line_cd,    pack_subline_cd,
                    group_cd,        rec_flag,        tsi_amt,
                    prem_amt,        par_id,            region_cd,
                    item_desc,        item_desc2,        coverage_cd,
                    from_date,        TO_DATE)
                VALUES (
                    item.item_no,        item.item_title,    item.item_grp,
                    item.ann_tsi_amt,    item.ann_prem_amt,    item.currency_cd,
                    item.currency_rt,    item.pack_line_cd,    item.pack_subline_cd,
                    item.group_cd,        'C',                0,
                    0,                    p_par_id,            item.region_cd,
                    item.item_desc,        item.item_desc2,    item.coverage_cd,
                    item.from_date,        item.TO_DATE);
                
                --v_item_ann_tsi := NVL(item.ann_tsi_amt,0) - NVL(item.tsi_amt,0); --commented out by John Daniel SR-21423
                --v_item_ann_prem := item.ann_prem_amt;
                v_pol_tsi := v_pol_tsi + (item.tsi_amt * item.currency_rt);
                v_pol_prem := v_pol_prem + (item.prem_amt * item.currency_rt); 
                
                IF NVL(item.tsi_amt,0) = 0 THEN
                    v_item_tsi  := 0;
                ELSE
                    v_item_tsi  := -item.tsi_amt;
                END IF;

                IF NVL(item.prem_amt,0) = 0 THEN
                    v_item_prem  := 0;
                ELSE
                    v_item_prem  := -item.prem_amt;
                END IF;
                
                FOR PERL IN cur_peril(item.item_no)
                LOOP
                    v_perl_ann_tsi  := NVL(perl.ann_tsi_amt,0) - NVL(perl.tsi_amt,0);
                    v_perl_ann_prem := NVL(perl.ann_prem_amt, 0) - NVL(perl.prem_amt, 0); --added by John Daniel SR-21423 
                    v_agg_sw        := NVL(perl.aggregate_sw,'N');
                    
                    IF NVL(perl.tsi_amt,0) = 0 THEN
                        v_perl_tsi  := 0;
                    ELSE
                        v_perl_tsi  := -perl.tsi_amt;
                    END IF;

                    IF NVL(perl.prem_amt,0) = 0 THEN
                        v_perl_prem  := 0;
                    ELSE
                        v_perl_prem  := -perl.prem_amt;
                    END IF;

                    IF NVL(perl.comm_amt,0) = 0 THEN
                        perl.comm_amt  := 0;
                    ELSE
                        --perl.comm_amt  := -perl.prem_amt;
						perl.comm_amt  := -perl.comm_amt; -- bonok :: 10.02.2014
                    END IF;
                    
                    --IF NVL(perl.prem_amt,0) <> 0 OR  NVL(perl.tsi_amt,0) <>0 THEN --commented out by John Daniel SR-21423
                    --    IF NVL(perl.tsi_amt,0) <> 0 AND NVL(perl.prem_rt,0) <> 0 THEN
                    --        v_comp_prem := ((perl.tsi_amt * perl.prem_rt) /100) * v_prov_discount;
                    --    ELSE
                    --        v_comp_prem := perl.prem_amt/(NVL(c1.short_rt_percent,1) /100);
                    --    END IF;                            

                    --    v_pol_ann_prem  := v_pol_ann_prem + (v_comp_prem * item.currency_rt);
                    --    v_perl_ann_prem := perl.ann_prem_amt - v_comp_prem;
                    --    v_item_ann_prem := v_item_ann_prem - v_comp_prem;
                    --END IF;
                    
                    --added by John Daniel SR-21423; gets the total prem_amt and tsi_amt minus the endt to be cancelled
                    BEGIN
                        SELECT SUM(B.PREM_AMT), SUM(B.TSI_AMT)
                        INTO v_perl_ann_prem, v_perl_ann_tsi
                        FROM GIPI_POLBASIC A,
                             GIPI_ITMPERIL B
                        WHERE A.POL_FLAG <> 5
                        AND A.LINE_CD = p_line_cd
                        AND A.SUBLINE_CD = p_subline_cd
                        AND A.ISS_CD = p_iss_cd
                        AND A.ISSUE_YY = p_issue_yy
                        AND A.POL_SEQ_NO = p_pol_seq_no
                        AND A.RENEW_NO = p_renew_no
                        AND B.POLICY_ID = A.POLICY_ID
                        AND B.ITEM_NO = ITEM.ITEM_NO
                        AND A.POLICY_ID <> p_policy_id
                        AND B.PERIL_CD = perl.peril_cd
                        GROUP BY B.PERIL_CD;
                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN --meaning the item to be cancelled is also the item added to the endt
                        	v_perl_ann_prem := 0;
                        	v_perl_ann_tsi := 0;                    
                    END;
                    
                    v_item_ann_prem := NVL(v_item_ann_prem, 0) + v_perl_ann_prem;
                    v_item_ann_tsi := NVL(v_item_ann_tsi, 0) + v_perl_ann_tsi;
                    
                    INSERT INTO GIPI_WITMPERL (
                        par_id,         item_no,         line_cd,       peril_cd,    
                        prem_rt,        tarf_cd,         tsi_amt,       prem_amt,
                        ann_tsi_amt,    ann_prem_amt,    ri_comm_amt,   ri_comm_rate,
                        aggregate_sw, comp_rem)   --added comp_rem for updating remark
                    VALUES (
                        p_par_id,        item.item_no,    perl.line_cd,  perl.peril_cd,
                        perl.prem_rt,   perl.tarf_cd,    v_perl_tsi,    v_perl_prem,
                        v_perl_ann_tsi, v_perl_ann_prem, perl.comm_amt, perl.comm_rate,
                        v_agg_sw, perl.comp_rem); --added comp_rem for updating remark
                END LOOP;
                
                UPDATE GIPI_WITEM
                   SET prem_amt = v_item_prem,
                       tsi_amt  = v_item_tsi,
                       ann_prem_amt = v_item_ann_prem,
                       ann_tsi_amt  = v_item_ann_tsi
                 WHERE par_id = p_par_id
                   AND item_no = item.item_no;
            END LOOP;
        END IF;
        
--        commented out by robert | 10.08.2012
--        p_tsi_amt  := -v_pol_tsi;
--        p_prem_amt := -v_pol_prem;
--        p_ann_tsi_amt  := p_ann_tsi_amt  - v_pol_tsi;
--        p_ann_prem_amt := p_ann_prem_amt - v_pol_ann_prem;        
    END LOOP;
    
    UPDATE GIPI_WPOLBAS
       SET cancelled_endt_id = p_policy_id
     WHERE par_id = p_par_id;
    
    IF p_pack_pol_flag = 'Y' THEN
        FOR PACK IN (
            SELECT pack_line_cd, item_no
              FROM GIPI_WITEM
             WHERE par_id = p_par_id)
        LOOP
            FOR A IN (
                SELECT '1'
                  FROM GIPI_WITMPERL
                 WHERE par_id  = p_par_id) 
            LOOP
                Create_Winvoice(0, 0, 0, p_par_id, pack.pack_line_cd, p_iss_cd);
                EXIT;
            END LOOP;
        END LOOP;
    ELSE
        FOR A IN (
            SELECT '1'
              FROM GIPI_WITMPERL
             WHERE par_id  = p_par_id)
        LOOP
            Create_Winvoice(0, 0, 0, p_par_id, p_line_cd, p_iss_cd);
            --robert | 10.08.2012 start 
            
            FOR ann1 IN (SELECT ann_tsi_amt, ann_prem_amt
                           FROM gipi_wpolbas
                          WHERE par_id = p_par_id)
            LOOP
               p_ann_tsi_amt := ann1.ann_tsi_amt;
               p_ann_prem_amt := ann1.ann_prem_amt;
            END LOOP;
            --Apollo Cruz 11.24.2014 - multiplied amt to currency_rt
            FOR x IN (SELECT SUM (tsi_amt * NVL(currency_rt, 1)) tsi_amt, SUM (prem_amt * NVL(currency_rt, 1)) prem_amt
                     FROM gipi_witem
                    WHERE par_id = p_par_id
                 GROUP BY currency_rt)
             LOOP
                --IF p_cancel_type != '4' //removed by robert to correct amounts for COI cancellation
                --THEN                   
                   p_ann_prem_amt := p_ann_prem_amt + x.prem_amt;
                   p_ann_tsi_amt := p_ann_tsi_amt + x.tsi_amt;
                   p_tsi_amt := p_tsi_amt + x.tsi_amt;
                   p_prem_amt := p_prem_amt + x.prem_amt;
                --END IF;
             END LOOP;
            --robert | 10.08.2012 end
            -- UW-SPECS-2011-0037 starts here -- UW-SPECS-2011-0037 commented out by John Daniel SR-21423 - May 03, 2016
            /*DECLARE
                v_itm_ann_tsi_amt gipi_witem.ann_tsi_amt%TYPE := 0;
                v_itm_ann_prem_amt gipi_witem.ann_prem_amt%TYPE := 0;
                v_pol_ann_tsi_amt gipi_polbasic.ann_tsi_amt%TYPE := 0;
                v_pol_ann_prem_amt gipi_polbasic.ann_prem_amt%TYPE := 0;
            BEGIN
                FOR c_policy_id IN (
                    SELECT DISTINCT b.item_no, a.line_cd, a.subline_cd,
                            a.iss_cd, a.issue_yy, a.pol_seq_no, a.renew_no
                      FROM gipi_polbasic a,
                           gipi_item b
                     WHERE line_cd = p_line_cd
                       AND subline_cd = p_subline_cd
                       AND iss_cd = p_iss_cd
                       AND issue_yy = p_issue_yy
                       AND pol_seq_no = p_pol_seq_no
                       AND renew_no = p_renew_no
                       AND a.eff_date < TO_DATE(p_eff_date, 'MM-DD-RRRR HH24:MI:SS')
                       AND a.policy_id <> p_policy_id
                       AND a.endt_type <> 'N'
                       AND a.policy_id = b.policy_id
                  ORDER BY item_no)
                LOOP
                    FOR c_item IN (
                        SELECT b.peril_cd, SUM(b.tsi_amt) ann_tsi_amt,
                               SUM(DECODE(a.prorate_flag, 
                                    '1', b.prem_amt / ROUND(a.expiry_date - a.eff_date, 0) * check_duration(a.incept_date, a.expiry_date),
                                    '3', (b.prem_amt*100) / a.short_rt_percent,
                                    b.prem_amt)) ann_prem_amt, c.peril_type
                          FROM gipi_polbasic a,
                               gipi_itmperil b,
                               giis_peril c
                         WHERE a.line_cd = c_policy_id.line_cd
                           AND a.policy_id <> p_policy_id
                           AND a.eff_date < TO_DATE(p_eff_date, 'MM-DD-RRRR HH24:MI:SS')
                           AND a.subline_cd = c_policy_id.subline_cd
                           AND a.iss_cd = c_policy_id.iss_cd
                           AND a.issue_yy = c_policy_id.issue_yy
                           AND a.pol_seq_no = c_policy_id.pol_seq_no
                           AND a.renew_no = c_policy_id.renew_no
                           AND b.item_no = c_policy_id.item_no
                           AND a.policy_id = b.policy_id
                           AND b.peril_cd = c.peril_cd
                           AND b.line_cd = c.line_cd
                           AND a.endt_type <> 'N'
                      GROUP BY b.peril_cd, c.peril_type)
                    LOOP
                        IF c_item.peril_type = 'B' THEN
                            v_itm_ann_tsi_amt := v_itm_ann_tsi_amt + c_item.ann_tsi_amt;
                            v_itm_ann_prem_amt := v_itm_ann_prem_amt + c_item.ann_prem_amt;
                            
                            UPDATE gipi_witmperl
                               SET ann_tsi_amt = c_item.ann_tsi_amt,
                                   ann_prem_amt = c_item.ann_prem_amt
                             WHERE par_id = p_par_id
                               AND item_no = c_policy_id.item_no
                               AND peril_cd = c_item.peril_cd;
                        END IF;
                    END LOOP;
                    
                    UPDATE gipi_witem
                       SET ann_tsi_amt = v_pol_ann_tsi_amt,
                           ann_prem_amt = v_pol_ann_prem_amt
                     WHERE par_id = p_par_id
                       AND item_no = c_policy_id.item_no;
                       
                    v_pol_ann_tsi_amt := v_pol_ann_tsi_amt + v_itm_ann_tsi_amt;
                    v_pol_ann_prem_amt := v_pol_ann_prem_amt + v_itm_ann_prem_amt;
                    v_itm_ann_tsi_amt := 0;
                    v_itm_ann_prem_amt := 0;                    
                END LOOP;
                
                --Apollo Cruz 11.24.2014 - removed codes below, ann amts will be updated on tha latter part
--                UPDATE gipi_wpolbas
--                   SET ann_tsi_amt = v_pol_ann_tsi_amt,
--                       ann_prem_amt = v_pol_ann_prem_amt
--                 WHERE par_id = p_par_id;
            END;*/
            -- UW-SPECS-2011-0037 ends here
            
            /*
            FOR X IN (
                SELECT a.tsi_amt, b.prem_rt, a.ann_tsi_amt, a.ann_prem_amt  
                  FROM GIPI_WITEM a, GIPI_WITMPERL b
                 WHERE a.par_id = p_par_id
                   AND a.par_id = b.par_id)
            LOOP
                IF p_cancel_type != '4'  THEN
                    p_ann_prem_amt := X.ann_prem_amt;
                    p_ann_tsi_amt  := X.ann_tsi_amt;
                END IF;
                
                UPDATE GIPI_WITEM
                    SET ann_tsi_amt = p_ann_tsi_amt,
                        ann_prem_amt = p_ann_prem_amt
                WHERE par_id = p_par_id;               
               
                UPDATE GIPI_WITMPERL
                   SET ann_tsi_amt = p_ann_tsi_amt,
                       ann_prem_amt = p_ann_prem_amt
                 WHERE par_id = p_par_id;                
            END LOOP;
            */
               UPDATE gipi_wpolbas
                  SET ann_prem_amt = v_ann_prem_amt,-- + p_prem_amt, --Commented out by Jerome 12.16.2016 SR 23384
                      ann_tsi_amt = v_ann_tsi_amt + p_tsi_amt,  
                      tsi_amt = p_tsi_amt,
                      prem_amt = p_prem_amt,
                      eff_date = v_eff_date
                WHERE par_id = p_par_id;
            EXIT;
        END LOOP;
    END IF;
    
    Cr_Bill_Dist.get_tsi(p_par_id);
 
    /*UPDATE GIPI_WPOLBAS
         SET cancelled_endt_id = p_policy_id
       WHERE par_id = p_par_id;*/
    
    p_eff_date := TO_CHAR(v_eff_date, 'MM-DD-RRRR HH24:MI:SS');
    p_endt_expiry_date := TO_CHAR(v_endt_expiry_date, 'MM-DD-RRRR HH24:MI:SS');
    p_expiry_date := TO_CHAR(v_expiry_date, 'MM-DD-RRRR HH24:MI:SS');

    
    <<RAISE_FORM_TRIGGER_FAILURE>>
    NULL;
END Process_Endt_Cancellation;
/


