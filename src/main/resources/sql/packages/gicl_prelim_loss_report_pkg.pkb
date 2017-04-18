CREATE OR REPLACE PACKAGE BODY CPI.GICL_PRELIM_LOSS_REPORT_PKG AS

/*
** Created by    : Marco Paolo Rebong
** Created date  : February 15, 2012
** Referenced by : (GICLS029 - Preliminary Loss Report)
** Description   : Retrieves the claim information for Preliminary Loss Report
*/
    FUNCTION get_prelim_loss_info (
        p_claim_id      GICL_CLAIMS.claim_id%TYPE
    )
      RETURN prelim_loss_info_tab PIPELINED AS
        v_info          prelim_loss_info_type;
    BEGIN
        
        FOR a IN (SELECT *
                    FROM GICL_CLAIMS
                   WHERE claim_id = p_claim_id)
        LOOP
            BEGIN
                SELECT DISTINCT intm_name, TO_CHAR(intrmdry_intm_no) intm_no
                  INTO v_info.intm_name, v_info.intm_no
                  FROM GICL_BASIC_INTM_V1
                 WHERE claim_id = p_claim_id;
            EXCEPTION
                WHEN OTHERS THEN
                    v_info.intm_name := NULL;
                    v_info.intm_no := NULL;
            END;
            
            BEGIN
                SELECT TO_CHAR(issue_date, 'MM-DD-YYYY') issue_date,
                       TO_CHAR(incept_date, 'MM-DD-YYYY') incept_date
                  INTO v_info.issue_date, v_info.incept_date
                  FROM GIPI_POLBASIC
                 WHERE renew_no = a.renew_no
                   AND pol_seq_no = a.pol_seq_no
                   AND issue_yy = a.issue_yy
                   --AND iss_cd = a.iss_cd -- marco - replaced 04.12.2013
                   AND iss_cd = a.pol_iss_cd
                   AND subline_cd = a.subline_cd
                   AND line_cd = a.line_cd
                   --AND eff_date < a.loss_date --marco - replaced 01.29.2013
                   AND TRUNC(eff_date) <= TRUNC(a.loss_date)
                   AND endt_seq_no = 0;
            EXCEPTION
                WHEN OTHERS THEN
                    v_info.issue_date := NULL;
                    v_info.incept_date := NULL;
            END;
            
            BEGIN
                SELECT DISTINCT(TO_CHAR(expiry_date, 'MM-DD-YYYY')) exp_date -- marco - 04.12.2013 - added distinct
                  INTO v_info.expiry_date
                  FROM GIPI_POLBASIC
                 WHERE renew_no = a.renew_no
                   AND pol_seq_no = a.pol_seq_no
                   AND issue_yy = a.issue_yy
                   --AND iss_cd = a.iss_cd -- marco - replaced 04.12.2013
                   AND iss_cd = a.pol_iss_cd
                   AND subline_cd = a.subline_cd
                   AND line_cd = a.line_cd
                   AND TRUNC(eff_date) = (SELECT TRUNC(MAX(b.eff_date))
                                            FROM GIPI_POLBASIC b
                                           WHERE b.renew_no = a.renew_no
                                             AND b.pol_seq_no = a.pol_seq_no
                                             AND b.issue_yy = a.issue_yy
                                             --AND iss_cd = a.iss_cd -- marco - replaced 04.12.2013
                                             AND iss_cd = a.pol_iss_cd
                                             AND b.subline_cd = a.subline_cd
                                             AND b.line_cd = a.line_cd
                                             AND TRUNC(b.eff_date) <= TRUNC(a.loss_date)); -- marco - 01.29.2013 - added trunc
            EXCEPTION
                WHEN OTHERS THEN
                    v_info.expiry_date := NULL;
            END;
            
            BEGIN
                SELECT assd_name, bill_addr1 ||' '|| bill_addr2 ||' '|| bill_addr3 address
                  INTO v_info.assd_name, v_info.bill_address
                  FROM GIIS_ASSURED
                 WHERE assd_no = a.assd_no;
            EXCEPTION
                WHEN OTHERS THEN
                    v_info.assd_name := NULL;
                    v_info.bill_address := NULL;
            END;
            
            BEGIN
                SELECT loss_cat_des
                  INTO v_info.loss_cat_des
                  FROM GIIS_LOSS_CTGRY
                 WHERE loss_cat_cd = a.loss_cat_cd
                   AND line_cd = a.line_cd;
            EXCEPTION
                WHEN OTHERS THEN
                    v_info.loss_cat_des := NULL;
            END;
            
            BEGIN
                SELECT DISTINCT mortg_name
                  INTO v_info.mortg_name
                  FROM GICL_MORTGAGEE_V1
                 WHERE claim_id = p_claim_id;
            EXCEPTION
                WHEN OTHERS THEN
                    v_info.mortg_name := NULL;
            END;
                       
            v_info.line_cd := a.line_cd;
            v_info.subline_cd := a.subline_cd;
            v_info.iss_cd := a.iss_cd;
            v_info.issue_yy := a.issue_yy;
            v_info.pol_seq_no := a.pol_seq_no;
            v_info.renew_no := a.renew_no;
            v_info.clm_yy := a.clm_yy;
            v_info.clm_seq_no := a.clm_seq_no;
            v_info.loss_loc1 := a.loss_loc1;
            v_info.loss_loc2 := a.loss_loc2;
            v_info.loss_loc3 := a.loss_loc3;
            v_info.loss_date := TO_CHAR(a.loss_date, 'MM-DD-YYYY');
            v_info.clm_file_date := TO_CHAR(a.clm_file_date, 'MM-DD-YYYY');
            v_info.policy_no := a.line_cd || '-' || a.subline_cd || '-' || a.pol_iss_cd || '-' ||
                                LTRIM(TO_CHAR(a.issue_yy, '09')) || '-' ||
                                LTRIM(TO_CHAR(a.pol_seq_no, '0999999')) || '-' ||
                                LTRIM(TO_CHAR(a.renew_no, '09'));
            v_info.claim_no := a.line_cd || '-' || a.subline_cd || '-' || a.iss_cd || '-' ||
                               LTRIM(TO_CHAR(a.clm_yy, '09')) || '-' ||
                               LTRIM(TO_CHAR(a.clm_seq_no, '0999999'));
            PIPE ROW(v_info);
        END LOOP;
    END;
    
    
    /*
    ** Created by    : Marco Paolo Rebong
    ** Created date  : February 15, 2012
    ** Referenced by : (GICLS029 - Preliminary Loss Report)
    ** Description   : Retrieves the item information for Line Fire
    */
    FUNCTION get_fire_item_information (
        p_claim_id      GICL_CLAIMS.claim_id%TYPE
    )
      RETURN fire_item_info_tab PIPELINED AS
        v_fire          fire_item_info_type;
    BEGIN
        FOR a IN (SELECT *
                    FROM GICL_FIRE_DTL
                   WHERE claim_id = p_claim_id)
        LOOP
            v_fire.item_no := a.item_no;
            v_fire.item_title := a.item_title;
            v_fire.loc_risk := a.loc_risk1 ||' '|| a.loc_risk2 ||' '|| a.loc_risk3;
            BEGIN
                SELECT SUM(NVL(ann_tsi_amt, 0)) ann_tsi_amt
                  INTO v_fire.ann_tsi_amt
                  FROM GICL_ITEM_PERIL b
                 WHERE b.item_no = a.item_no
                   AND b.claim_id = p_claim_id;
            EXCEPTION
                WHEN OTHERS THEN
                    v_fire.ann_tsi_amt := NULL;
            END;
            PIPE ROW(v_fire);    
        END LOOP;
    END;
    
    
    /*
    ** Created by    : Marco Paolo Rebong
    ** Created date  : February 15, 2012
    ** Referenced by : (GICLS029 - Preliminary Loss Report)
    ** Description   : Retrieves the item information for Line Aviation
    */
    FUNCTION get_aviation_item_information (
        p_claim_id      GICL_CLAIMS.claim_id%TYPE
    )
      RETURN aviation_item_info_tab PIPELINED AS
        v_aviation      aviation_item_info_type;
    BEGIN
        FOR a IN (SELECT *
                    FROM GICL_AVIATION_DTL
                   WHERE claim_id = p_claim_id)
        LOOP
            v_aviation.item_no := a.item_no;
            v_aviation.item_title := a.item_title;
            v_aviation.purpose := a.purpose;
            v_aviation.est_util_hrs := a.est_util_hrs;
            BEGIN
                SELECT vessel_name
                  INTO v_aviation.vessel_name
                  FROM GIIS_VESSEL b
                 WHERE b.vessel_cd = a.vessel_cd;
            EXCEPTION
                WHEN OTHERS THEN
                    v_aviation.vessel_name := NULL;
            END;
            PIPE ROW(v_aviation);
        END LOOP;
    END;
    
    /*
    ** Created by    : Marco Paolo Rebong
    ** Created date  : February 15, 2012
    ** Referenced by : (GICLS029 - Preliminary Loss Report)
    ** Description   : Retrieves the item information for Line Casualty
    */
    FUNCTION get_casualty_item_information (
        p_claim_id      GICL_CLAIMS.claim_id%TYPE
    )
      RETURN casualty_item_info_tab PIPELINED AS
        v_casualty      casualty_item_info_type;
    BEGIN
      FOR a IN (SELECT *
                  FROM GICL_CASUALTY_DTL
                 WHERE claim_id = p_claim_id)
      LOOP
            v_casualty.item_no := a.item_no;
            v_casualty.item_title := a.item_title;
            v_casualty.location := a.location;
            v_casualty.conveyance_info := a.conveyance_info;
            v_casualty.interest_on_premises := a.interest_on_premises;
            v_casualty.limit_of_liability := a.limit_of_liability;
            v_casualty.amount_coverage := a.amount_coverage;
            PIPE ROW(v_casualty);
      END LOOP;
    END;
    
    /*
    ** Created by    : Marco Paolo Rebong
    ** Created date  : February 15, 2012
    ** Referenced by : (GICLS029 - Preliminary Loss Report)
    ** Description   : Retrieves the item information for Line Engineering
    */
    FUNCTION get_en_item_information (
        p_claim_id      GICL_CLAIMS.claim_id%TYPE
    )
      RETURN en_item_info_tab PIPELINED AS
        v_en            en_item_info_type;
    BEGIN
        FOR a IN (SELECT *
                    FROM GICL_ENGINEERING_DTL
                   WHERE claim_id = p_claim_id)
        LOOP
            v_en.item_no := a.item_no;
            v_en.item_title := a.item_title;
            v_en.item_desc := a.item_desc;
            v_en.item_desc2 := a.item_desc2;
            BEGIN
                SELECT region_desc
                  INTO v_en.region_desc
                  FROM GIIS_REGION
                 WHERE region_cd = a.region_cd;
            EXCEPTION
                WHEN OTHERS THEN
                    v_en.region_desc := NULL;
            END;
            BEGIN
                SELECT province_desc
                  INTO v_en.province_desc
                  FROM GIIS_PROVINCE
                 WHERE province_cd = a.province_cd;
            EXCEPTION
                WHEN OTHERS THEN
                    v_en.province_desc := NULL;
            END;
            PIPE ROW(v_en);
        END LOOP;
    END;

    /*
    ** Created by    : Marco Paolo Rebong
    ** Created date  : February 15, 2012
    ** Referenced by : (GICLS029 - Preliminary Loss Report)
    ** Description   : Retrieves the item information for Line Motor Car
    */
    FUNCTION get_mc_item_information (
        p_claim_id          GICL_CLAIMS.claim_id%TYPE    
    )
      RETURN mc_item_info_tab PIPELINED AS
        v_mc                mc_item_info_type;
    BEGIN
        FOR a IN (SELECT *
                    FROM GICL_MOTOR_CAR_DTL
                   WHERE claim_id = p_claim_id)
        LOOP
            v_mc.item_no := a.item_no;
            v_mc.item_title := a.item_title;
            v_mc.motor_no := a.motor_no;
            v_mc.plate_no := a.plate_no;
            v_mc.serial_no := a.serial_no;
            BEGIN
                SELECT make
                  INTO v_mc.make
                  FROM GIIS_MC_MAKE
                 WHERE make_cd = a.make_cd
                   AND car_company_cd = a.motcar_comp_cd; --marco - 01.29.2013 - added condition
            EXCEPTION
                WHEN OTHERS THEN
                    v_mc.make := NULL;
            END;
            PIPE ROW(v_mc);
        END LOOP;
    END;
    
    /*
    ** Created by    : Marco Paolo Rebong
    ** Created date  : February 15, 2012
    ** Referenced by : (GICLS029 - Preliminary Loss Report)
    ** Description   : Retrieves the item information for Line Marine Hull
    */
    FUNCTION get_mh_item_information (
        p_claim_id          GICL_CLAIMS.claim_id%TYPE
    )
      RETURN mh_item_info_tab PIPELINED AS
        v_mh                mh_item_info_type;
    BEGIN
        FOR a IN (SELECT *
                    FROM GICL_HULL_DTL
                   WHERE claim_id = p_claim_id)
        LOOP
            BEGIN
                SELECT v.vessel_name,
                       h.hull_desc
                  INTO v_mh.vessel_name,
                       v_mh.hull_desc
                  FROM GIIS_VESSEL v,
                       GIIS_HULL_TYPE h
                 WHERE v.hull_type_cd = h.hull_type_cd
                   AND v.vessel_cd = a.vessel_cd;
            EXCEPTION
                WHEN OTHERS THEN
                    v_mh.vessel_name := NULL;
                    v_mh.hull_desc := NULL;
            END;
            v_mh.item_no := a.item_no;
            v_mh.item_title := a.item_title;
            v_mh.geog_limit := a.geog_limit;
            v_mh.dry_date := a.dry_date;
            v_mh.dry_place := a.dry_place;
            PIPE ROW(v_mh);
        END LOOP;   
    END;
    
    /*
    ** Created by    : Marco Paolo Rebong
    ** Created date  : February 15, 2012
    ** Referenced by : (GICLS029 - Preliminary Loss Report)
    ** Description   : Retrieves the item information for Line Marine Cargo
    */
    FUNCTION get_mn_item_information (
        p_claim_id          GICL_CLAIMS.claim_id%TYPE   
    )
      RETURN mn_item_info_tab PIPELINED AS
        v_mn                mn_item_info_type;
    BEGIN
        FOR a IN (SELECT *
                    FROM GICL_CARGO_DTL
                   WHERE claim_id = p_claim_id)
        LOOP
            v_mn.item_no := a.item_no;
            v_mn.item_title := a.item_title;
            v_mn.etd := a.etd;
            v_mn.eta := a.eta;
            v_mn.lc_no := a.lc_no;
            v_mn.bl_awb := a.bl_awb;
            BEGIN
                SELECT vessel_name
                  INTO v_mn.vessel_name
                  FROM GIIS_VESSEL
                 WHERE vessel_cd = a.vessel_cd;
            EXCEPTION
                WHEN OTHERS THEN
                    v_mn.vessel_name := NULL;
            END;
            BEGIN
                SELECT cargo_class_desc
                  INTO v_mn.cargo_class_desc
                  FROM GIIS_CARGO_CLASS
                 WHERE cargo_class_cd = a.cargo_class_cd;
            EXCEPTION
                WHEN OTHERS THEN
                    v_mn.cargo_class_desc := NULL;
            END;
            PIPE ROW(v_mn);
        END LOOP;
    END;
    
    /*
    ** Created by    : Marco Paolo Rebong
    ** Created date  : February 15, 2012
    ** Referenced by : (GICLS029 - Preliminary Loss Report)
    ** Description   : Retrieves the item information for Line Personal Accident
    */
    FUNCTION get_pa_item_information (
        p_claim_id          GICL_CLAIMS.claim_id%TYPE
    )
      RETURN pa_item_info_tab PIPELINED AS
        v_pa                pa_item_info_type;
    BEGIN
        FOR pa IN (SELECT a.claim_id, a.item_no, a.item_title, a.grouped_item_no, a.grouped_item_title, a.date_of_birth, a.position_cd,
                          b.beneficiary_name, b.beneficiary_addr, b.relation,
                          (SELECT position
                             FROM GIIS_POSITION c
                            WHERE position_cd = a.position_cd) position
                    FROM GICL_ACCIDENT_DTL a,
                         GICL_BENEFICIARY_DTL b
                   WHERE a.grouped_item_no = b.grouped_item_no(+)
                     AND a.item_no = b.item_no(+)
                     AND a.claim_id = b.claim_id(+)
                     AND a.claim_id = p_claim_id)
        LOOP
            v_pa.claim_id := pa.claim_id;
            v_pa.item_no := pa.item_no;
            v_pa.item_title := pa.item_title;
            v_pa.grouped_item_no := pa.grouped_item_no;
            v_pa.grouped_item_title := pa.grouped_item_title;
            v_pa.date_of_birth := pa.date_of_birth;
            v_pa.position_cd := pa.position_cd;
            v_pa.position := pa.position;
            v_pa.beneficiary_name := pa.beneficiary_name;
            v_pa.beneficiary_addr := pa.beneficiary_addr;
            v_pa.relation := pa.relation;
            PIPE ROW(v_pa);
        END LOOP; 
    END;
    
    /*
    ** Created by    : Marco Paolo Rebong
    ** Created date  : February 15, 2012
    ** Referenced by : (GICLS029 - Preliminary Loss Report)
    ** Description   : Retrieves the required documents on file of the claim
    */
    FUNCTION get_docs_on_file (
        p_claim_id          GICL_CLAIMS.claim_id%TYPE
    )
      RETURN docs_on_file_tab PIPELINED AS
        v_docs              docs_on_file_type;
        v_line_cd           GICL_REQD_DOCS.line_cd%TYPE;
        v_subline_cd        GICL_REQD_DOCS.subline_cd%TYPE;
        v_clm_doc_cd        GICL_REQD_DOCS.clm_doc_cd%TYPE;
        v_doc_cmpltd_dt     GICL_REQD_DOCS.doc_cmpltd_dt%TYPE;
    BEGIN
        SELECT DISTINCT line_cd,
               subline_cd
          INTO v_line_cd,
               v_subline_cd
          FROM GICL_CLAIMS
         WHERE claim_id = p_claim_id;
         
        FOR i IN (SELECT TO_NUMBER(a.clm_doc_cd) clm_doc_cd, a.line_cd,
                         a.subline_cd, a.clm_doc_desc
                    FROM GICL_CLM_DOCS a
                   WHERE a.priority_cd IS NOT NULL
                     AND a.line_cd =  v_line_cd
                     AND a.subline_cd = v_subline_cd
                   UNION
                  SELECT a.clm_doc_cd, a.line_cd,
                         a.subline_cd, b.clm_doc_desc
                    FROM GICL_REQD_DOCS A, GICL_CLM_DOCS B
                   WHERE a.doc_cmpltd_dt IS NOT NULL
                     AND a.line_cd = b.line_cd
                     AND a.subline_cd = b.subline_cd
                     AND a.clm_doc_cd = b.clm_doc_cd
                     AND b.line_cd =  v_line_cd
                     AND b.subline_cd = v_subline_cd
                     AND a.claim_id = p_claim_id)
        LOOP
            BEGIN
                SELECT doc_cmpltd_dt
                  INTO v_doc_cmpltd_dt
                  FROM GICL_REQD_DOCS
                 WHERE claim_id = p_claim_id
                   AND line_cd = i.line_cd
                   AND subline_cd = i.subline_cd
                   AND clm_doc_cd = i.clm_doc_cd;
            EXCEPTION
                WHEN OTHERS THEN
                    v_doc_cmpltd_dt := NULL;
            END;
            v_docs.line_cd := i.line_cd;
            v_docs.subline_cd := i.subline_cd;
            v_docs.clm_doc_cd := i.clm_doc_cd;
            v_docs.clm_doc_desc := i.clm_doc_desc;
            v_docs.doc_cmpltd_dt := v_doc_cmpltd_dt;
            PIPE ROW(v_docs);
        END LOOP;
    END;
    
    /*
    ** Created by    : Marco Paolo Rebong
    ** Created date  : February 15, 2012
    ** Referenced by : (GICLS029 - Preliminary Loss Report)
    ** Description   : Retrieves the premium payment of the claim
    */
    FUNCTION get_prem_payment (
        p_claim_id              GICL_CLAIMS.claim_id%TYPE
    )
      RETURN prem_payment_tab PIPELINED AS
        v_prem                  prem_payment_type;
        v_line_cd               GICL_CLAIMS.line_cd%TYPE;
        v_subline_cd            GICL_CLAIMS.subline_cd%TYPE;
        v_iss_cd                GICL_CLAIMS.iss_cd%TYPE;
        v_issue_yy              GICL_CLAIMS.issue_yy%TYPE;
        v_pol_seq_no            GICL_CLAIMS.pol_seq_no%TYPE;
        v_renew_no              GICL_CLAIMS.renew_no%TYPE;
        v_loss_date             GICL_CLAIMS.loss_date%TYPE;
        v_prem_amt              GIAC_DIRECT_PREM_COLLNS.premium_amt%TYPE;
        v_tran_date             GIAC_ACCTRANS.tran_date%TYPE;
        v_ref_no                VARCHAR2(30);
    BEGIN
        SELECT line_cd,
               subline_cd,
               pol_iss_cd,
               issue_yy,
               pol_seq_no,
               renew_no,
               loss_date
          INTO v_line_cd,
               v_subline_cd,
               v_iss_cd,
               v_issue_yy,
               v_pol_seq_no,
               v_renew_no,
               v_loss_date
          FROM GICL_CLAIMS
         WHERE claim_id = p_claim_id;
    
        FOR j IN (SELECT policy_id
                    FROM GIPI_POLBASIC a 
                   WHERE a.line_cd = v_line_cd
                     AND a.subline_cd =  v_subline_cd
                     AND a.iss_cd = v_iss_cd
                     AND a.issue_yy = v_issue_yy
                     AND a.pol_seq_no = v_pol_seq_no
                     AND a.renew_no = v_renew_no
                     AND a.eff_date <= v_loss_date)
        LOOP
            FOR i IN (SELECT c.gacc_tran_id, c.premium_amt, 
                             d.tran_class, d.tran_class_no, 
                             TO_DATE(d.tran_date) tran_date, d.jv_pref_suff -- Added by Jerome Bautista 08.20.2015 SR 18120
                        FROM GIPI_POLBASIC a, GIPI_INVOICE b, 
                             GIAC_DIRECT_PREM_COLLNS c, GIAC_ACCTRANS d
                       WHERE a.policy_id = b.policy_id
                         AND a.policy_id = j.policy_id
                         AND c.b140_iss_cd = b.iss_cd
                         AND c.b140_iss_cd = b.iss_cd
                         AND c.b140_prem_seq_no = b.prem_seq_no 
                         AND c.gacc_tran_id = d.tran_id
                         AND NOT EXISTS(SELECT e.gacc_tran_id
                                          FROM GIAC_REVERSALS e, GIAC_ACCTRANS f
                                         WHERE e.reversing_tran_id = f.tran_id
                                           AND f.tran_flag <> 'D'
                                           AND e.gacc_tran_id = d.tran_id)
                         AND d.tran_flag <> 'D'
                         AND a.pol_flag NOT IN ('4','5')
                       UNION
                      SELECT c.gacc_tran_id, c.premium_amt, 
                             d.tran_class, d.tran_class_no, 
                             TO_DATE(d.tran_date) tran_date, d.jv_pref_suff -- Added by Jerome Bautista 08.20.2015 SR 18120
                        FROM GIPI_POLBASIC a, GIPI_INVOICE b, 
                             GIAC_INWFACUL_PREM_COLLNS c, GIAC_ACCTRANS d
                       WHERE a.policy_id = b.policy_id
                         AND a.policy_id = j.policy_id
                         AND c.b140_iss_cd=b.iss_cd
                         AND c.b140_iss_cd=b.iss_cd
                         AND c.b140_prem_seq_no = b.prem_seq_no 
                         AND c.gacc_tran_id = d.tran_id
                         AND NOT EXISTS(SELECT e.gacc_tran_id
                                          FROM GIAC_REVERSALS e, GIAC_ACCTRANS f
                                         WHERE e.reversing_tran_id = f.tran_id
                                           AND f.tran_flag <> 'D'
                                           AND e.gacc_tran_id = d.tran_id)
                         AND d.tran_flag <> 'D'
                         AND a.pol_flag NOT IN ('4','5'))
            LOOP
                v_prem_amt := i.premium_amt;
                v_tran_date := i.tran_date;
                IF i.tran_class = 'COL' THEN
                    FOR c IN (
                        SELECT or_pref_suf||'-'||TO_CHAR(or_no) or_no 
                    FROM GIAC_ORDER_OF_PAYTS
                        WHERE gacc_tran_id = i.gacc_tran_id)
                    LOOP
                        v_ref_no := c.or_no;
                    END LOOP;
                ELSIF i.tran_class = 'DV' THEN
                    FOR r IN (
                        SELECT document_cd||'-'||branch_cd||'-'||TO_CHAR(doc_year)||'-'||TO_CHAR(doc_mm)
                               ||'-'||TO_CHAR(doc_seq_no) request_no
                          FROM GIAC_PAYT_REQUESTS a, GIAC_PAYT_REQUESTS_DTL b
                         WHERE a.ref_id = b.gprq_ref_id
                           AND b.tran_id = i.gacc_tran_id)
                    LOOP
                        v_ref_no := r.request_no;
                        FOR d IN (SELECT dv_pref||'-'||TO_CHAR(dv_no) dv_no
                                    FROM GIAC_DISB_VOUCHERS
                                   WHERE gacc_tran_id = i.gacc_tran_id)
                        LOOP
                            v_ref_no := d.dv_no;
                        END LOOP;
                    END LOOP;
                ELSIF i.tran_class = 'JV' THEN
                    v_ref_no := i.jv_pref_suff || '-' || i.tran_class_no;  --i.jv_pref_suff Added by Jerome Bautista 08.20.2015 SR 18120
                END IF;
                v_prem.premium_amt := v_prem_amt;
            v_prem.tran_date := v_tran_date;
            v_prem.ref_no := v_ref_no;
            PIPE ROW(v_prem);
            END LOOP;
        END LOOP;
    END;
    
    /*
    ** Created by    : Marco Paolo Rebong
    ** Created date  : February 15, 2012
    ** Referenced by : (GICLS029 - Preliminary Loss Report)
    ** Description   : Retrieves the distribution details of the insured item
    */
    FUNCTION get_treaties (
        p_claim_id          GICL_CLAIMS.claim_id%TYPE,
        p_line_cd           GICL_CLAIMS.line_cd%TYPE
    )
      RETURN distribution_dtl_tab PIPELINED AS
        v_treaties          distribution_dtl_type;
        v_ann_tsi_amt2      NUMBER(16,2);
        v_reserve_amt       NUMBER(16,2);
        v_ctr               NUMBER := 1;
    BEGIN
        FOR i IN (SELECT peril_cd, grouped_item_no, item_no, ann_tsi_amt
                    FROM GICL_ITEM_PERIL
                   WHERE claim_id = p_claim_id)
        LOOP
            v_treaties := NULL;
            v_ctr := 1;
            FOR tsi_ctr_rec IN (SELECT DISTINCT b.claim_id, a.share_type, a.share_cd, a.trty_name 
                                  FROM GICL_POLICY_DIST b, GIIS_DIST_SHARE a 
                                 WHERE b.share_cd = a.share_cd 
                                   AND b.line_cd = a.line_cd
                                   AND b.claim_id = p_claim_id
                                   AND b.peril_cd = i.peril_cd)
            LOOP
                IF v_ctr = 1 THEN
                    BEGIN
                        SELECT peril_name, peril_cd
                          INTO v_treaties.peril_name, v_treaties.peril_cd
                          FROM GIIS_PERIL
                         WHERE peril_cd = i.peril_cd
                           AND line_cd = p_line_cd;
                    EXCEPTION
                        WHEN OTHERS THEN
                            v_treaties.peril_name := NULL;
                    END;
                    BEGIN
                        SELECT NVL(loss_reserve, 0) + NVL(expense_reserve, 0) reserve_amt
                          INTO v_treaties.reserve_amt
                          FROM GICL_CLM_RES_HIST
                         WHERE peril_cd = i.peril_cd
                           AND item_no = i.item_no
                           AND grouped_item_no = i.grouped_item_no
                           AND NVL(dist_sw, 'N') = 'Y'
                           AND claim_id = p_claim_id;
                           v_treaties.reserve_amt := gicl_prelim_loss_report_pkg.default_currency(v_treaties.reserve_amt, i.item_no, i.grouped_item_no, p_claim_id);
                    EXCEPTION
                        WHEN OTHERS THEN
                            v_treaties.reserve_amt := NULL;
                    END;
                    v_treaties.ann_tsi_amt2 := gicl_prelim_loss_report_pkg.default_currency(i.ann_tsi_amt, i.item_no, i.grouped_item_no, p_claim_id);
                    v_ann_tsi_amt2 := v_treaties.ann_tsi_amt2;
                    v_reserve_amt := v_treaties.reserve_amt;
                ELSE
                    v_treaties.peril_name := NULL;
                    v_treaties.reserve_amt := NULL;
                    v_treaties.ann_tsi_amt2 := NULL;
                END IF;
                v_ctr := 2;
            
--                FOR pol_dist_rec IN (SELECT a.claim_id, a.share_cd grp_seq_no, a.shr_tsi_pct shr_pct,
--                                            b.trty_name
--                                       FROM GICL_POLICY_DIST a,
--                                            GIIS_DIST_SHARE b
--                                      WHERE a.peril_cd = i.peril_cd
--                                        AND a.item_no = i.item_no
--                                        AND a.grouped_item_no = i.grouped_item_no
--                                        AND a.claim_id = p_claim_id
--                                        AND a.share_cd = tsi_ctr_rec.share_cd
--                                        AND a.share_cd = b.share_cd)
--                LOOP
--                    v_treaties.trty_tsi := v_ann_tsi_amt2 * pol_dist_rec.shr_pct/100;
--                    v_treaties.trty_shr_tsi_pct := pol_dist_rec.shr_pct;
--                    v_treaties.share_cd := pol_dist_rec.grp_seq_no;
--                    v_treaties.tsi_trty := pol_dist_rec.trty_name;
--                END LOOP;
                v_treaties.tsi_trty := NULL;
                v_treaties.trty_tsi := NULL;
                v_treaties.trty_shr_tsi_pct := NULL;
                v_treaties.share_cd := NULL;
                FOR pol_dist_rec IN (SELECT a.claim_id, a.share_cd grp_seq_no, a.shr_tsi_pct shr_pct
                                       FROM GICL_POLICY_DIST a
                                      WHERE a.peril_cd = i.peril_cd
                                        AND a.item_no = i.item_no
                                        AND a.grouped_item_no = i.grouped_item_no
                                        AND a.claim_id = p_claim_id
                                        AND a.share_cd = tsi_ctr_rec.share_cd)
                LOOP
                    BEGIN
                        SELECT trty_name
                          INTO v_treaties.tsi_trty
                          FROM GIIS_DIST_SHARE
                         WHERE share_cd = pol_dist_rec.grp_seq_no
                           AND line_cd = p_line_cd;
                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                            v_treaties.tsi_trty := NULL;
                    END;
                    
                    --marco - 07.24.2014 - replaced line below
                    --v_treaties.trty_tsi := v_ann_tsi_amt2 * pol_dist_rec.shr_pct/100;
                    IF pol_dist_rec.grp_seq_no = 1 THEN
                        v_treaties.trty_tsi := v_ann_tsi_amt2 * pol_dist_rec.shr_pct/100;
                    ELSE
                        BEGIN
                           SELECT SUM(NVL(shr_ri_tsi_amt, 0))
                             INTO v_treaties.trty_tsi
                             FROM GICL_POLICY_DIST_RI
                            WHERE claim_id = p_claim_id
                              AND item_no = i.item_no
                              AND peril_cd =  i.peril_cd
                              AND share_cd = pol_dist_rec.grp_seq_no;
                           v_treaties.trty_tsi := GICL_PRELIM_LOSS_REPORT_PKG.default_currency(v_treaties.trty_tsi, i.item_no, i.grouped_item_no, p_claim_id);
                        EXCEPTION
                           WHEN OTHERS THEN
                              v_treaties.trty_tsi := 0;
                        END;
                    END IF;
                    
                    v_treaties.trty_shr_tsi_pct := pol_dist_rec.shr_pct;
                    v_treaties.share_cd := pol_dist_rec.grp_seq_no;
                END LOOP;
                
--                FOR clm_dist_rec IN (SELECT a.claim_id, a.clm_dist_no, a.grp_seq_no, a.shr_pct, a.peril_cd,
--                                            a.item_no, a.grouped_item_no, a.negate_tag,
--                                            b.trty_name
--                                       FROM GICL_RESERVE_DS a,
--                                            GIIS_DIST_SHARE b
--                                      WHERE a.peril_cd = i.peril_cd
--                                        AND a.item_no = i.item_no
--                                        AND a.claim_id = p_claim_id
--                                        AND a.grouped_item_no = i.grouped_item_no
--                                        AND NVL(a.negate_tag, 'N') <> 'Y'
--                                        AND a.grp_seq_no = tsi_ctr_rec.share_cd
--                                        AND a.grp_seq_no = b.share_cd)
--                LOOP
--                    v_treaties.trty_reserve := v_reserve_amt * clm_dist_rec.shr_pct/100;
--                    v_treaties.trty_shr_pct := clm_dist_rec.shr_pct;
--                    v_treaties.reserve_trty := clm_dist_rec.trty_name;
--                END LOOP;

                v_treaties.reserve_trty := NULL;
                v_treaties.trty_reserve := NULL;
                v_treaties.trty_shr_pct := NULL;
                FOR clm_dist_rec IN (SELECT a.claim_id, a.clm_dist_no, a.grp_seq_no, a.shr_pct, a.peril_cd,
                                            a.item_no, a.grouped_item_no, a.negate_tag
                                       FROM GICL_RESERVE_DS a
                                      WHERE a.peril_cd = i.peril_cd
                                        AND a.item_no = i.item_no
                                        AND a.claim_id = p_claim_id
                                        AND a.grouped_item_no = i.grouped_item_no
                                        AND NVL(a.negate_tag, 'N') <> 'Y'
                                        AND a.grp_seq_no = tsi_ctr_rec.share_cd)
                LOOP
                    BEGIN
                        SELECT trty_name
                          INTO v_treaties.reserve_trty
                          FROM GIIS_DIST_SHARE
                         WHERE share_cd = clm_dist_rec.grp_seq_no
                           AND line_cd = p_line_cd;
                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                            v_treaties.reserve_trty := NULL;
                    END;
                    
                    --marco - 07.24.2014 - replaced line below
                    --v_treaties.trty_reserve := v_reserve_amt * clm_dist_rec.shr_pct/100;
                    IF clm_dist_rec.grp_seq_no = 1 THEN
                        v_treaties.trty_reserve := v_reserve_amt * clm_dist_rec.shr_pct/100;
                    ELSE
                        BEGIN
                           SELECT SUM(ri_res_amt)
                             INTO v_treaties.trty_reserve
                             FROM GICL_RESERVE_RIDS_V1
                            WHERE claim_id = p_claim_id
                              AND grp_seq_no = clm_dist_rec.grp_seq_no
                              AND peril_cd = clm_dist_rec.peril_cd;
                           v_treaties.trty_reserve := GICL_PRELIM_LOSS_REPORT_PKG.default_currency(v_treaties.trty_reserve, clm_dist_rec.item_no, clm_dist_rec.grouped_item_no, p_claim_id);
                        EXCEPTION
                           WHEN OTHERS THEN
                              v_treaties.trty_reserve := 0;
                        END;
                    END IF;
                    
                    v_treaties.trty_shr_pct := clm_dist_rec.shr_pct;
--                    v_treaties.reserve_trty := clm_dist_rec.trty_name;
                END LOOP;
                
                PIPE ROW(v_treaties);
            END LOOP;

        END LOOP;
    END;
    
    /*
    ** Created by    : Marco Paolo Rebong
    ** Created date  : February 15, 2012
    ** Referenced by : (GICLS029 - Preliminary Loss Report)
    ** Description   : Converts the amount to the default currency
    */
    FUNCTION default_currency (
        p_ann_tsi_amt           GICL_ITEM_PERIL.ann_tsi_amt%TYPE,
        p_item_no               GICL_ITEM_PERIL.item_no%TYPE,
        p_grouped_item_no       GICL_ITEM_PERIL.grouped_item_no%TYPE,
        p_claim_id              GICL_ITEM_PERIL.claim_id%TYPE
    )
      RETURN NUMBER AS
        v_currency_cd           GIIS_CURRENCY.main_currency_cd%TYPE;
        v_currency_rt           GIIS_CURRENCY.currency_rt%TYPE;
        v_return_value          GICL_ITEM_PERIL.ann_tsi_amt%TYPE;
    BEGIN
        BEGIN
            SELECT DISTINCT(currency_cd)
              INTO v_currency_cd
              FROM GICL_CLM_RESERVE
             WHERE item_no = p_item_no
               AND grouped_item_no = NVL(p_grouped_item_no, grouped_item_no)
               AND claim_id = p_claim_id;
        EXCEPTION
            WHEN OTHERS THEN
                NULL;
        END;
        
        BEGIN
            SELECT currency_rt
              INTO v_currency_rt
              FROM GIIS_CURRENCY
             WHERE main_currency_cd = v_currency_cd;
        EXCEPTION
            WHEN OTHERS THEN
                NULL;
        END;
        v_return_value := p_ann_tsi_amt * v_currency_rt;
        RETURN v_return_value;
    END;
    
    /*
    ** Created by    : Marco Paolo Rebong
    ** Created date  : February 15, 2012
    ** Referenced by : (GICLS029 - Preliminary Loss Report)
    ** Description   : Retrieves the reinsurers of the distribution
    */
    FUNCTION get_reinsurance (
        p_claim_id          GICL_CLAIMS.claim_id%TYPE,
        p_share_cd          GICL_POLICY_DIST_RI.share_cd%TYPE,
        p_peril_cd          GICL_ITEM_PERIL.peril_cd%TYPE
    )
      RETURN reinsurance_tab PIPELINED AS
        v_ri                reinsurance_type;
     BEGIN
        FOR i IN (SELECT a.shr_ri_tsi_pct, a.shr_ri_tsi_amt, a.item_no, a.grouped_item_no, a.ri_cd,
                         b.ri_res_amt, b.item_no reserve_item_no, b.grp_seq_no,
                         c.ri_name
                    FROM GICL_POLICY_DIST_RI a,
                         GICL_RESERVE_RIDS_V1 b,
                         GIIS_REINSURER c
                   WHERE a.claim_id = p_claim_id
                     AND a.share_cd = p_share_cd
                     AND a.claim_id = b.claim_id
                     AND a.ri_cd = c.ri_cd
                     AND b.ri_cd = c.ri_cd
                     AND a.peril_cd = p_peril_cd
                     AND a.peril_cd = b.peril_cd
                     AND a.share_cd = b.grp_seq_no -- added by j.diago 04.15.2014
                   ORDER BY a.ri_cd)
        LOOP        
            v_ri.ri_name := i.ri_name;
            v_ri.shr_ri_tsi_pct := i.shr_ri_tsi_pct;
            v_ri.shr_ri_tsi_amt := gicl_prelim_loss_report_pkg.default_currency(i.shr_ri_tsi_amt, i.item_no, i.grouped_item_no, p_claim_id);
            v_ri.item_no := i.item_no;
            v_ri.grouped_item_no := i.grouped_item_no;
            v_ri.ri_cd := i.ri_cd;
            v_ri.ri_res_amt := gicl_prelim_loss_report_pkg.default_currency(i.ri_res_amt, i.reserve_item_no, i.grouped_item_no, p_claim_id);
            v_ri.reserve_item_no := i.reserve_item_no;
            v_ri.grp_seq_no := i.grp_seq_no;
            PIPE ROW(v_ri);
        END LOOP; 
     END;
     
    /*
    ** Created by    : Marco Paolo Rebong
    ** Created date  : February 16, 2012
    ** Referenced by : (GICLS034 - Final Loss Report)
    ** Description   : Retrieves the claim information for Final Loss Report
    */
     FUNCTION get_final_loss_info (
        p_claim_id      GICL_CLAIMS.claim_id%TYPE
    )
      RETURN final_loss_info_tab PIPELINED AS
        v_info          final_loss_info_type;
    BEGIN
        
        FOR a IN (SELECT *
                    FROM GICL_CLAIMS
                   WHERE claim_id = p_claim_id
                     AND EXISTS(SELECT 1
                                  FROM GICL_ADVICE
                                 WHERE claim_id = p_claim_id))
        LOOP
            BEGIN
                SELECT DISTINCT intm_name, TO_CHAR(intrmdry_intm_no) intm_no
                  INTO v_info.intm_name, v_info.intm_no
                  FROM GICL_BASIC_INTM_V1
                 WHERE claim_id = p_claim_id;
            EXCEPTION
                WHEN OTHERS THEN
                    v_info.intm_name := NULL;
                    v_info.intm_no := NULL;
            END;
            
            BEGIN
                SELECT TO_CHAR(issue_date, 'MM-DD-YYYY') issue_date,
                       TO_CHAR(incept_date, 'MM-DD-YYYY') incept_date
                  INTO v_info.issue_date, v_info.incept_date
                  FROM GIPI_POLBASIC
                 WHERE renew_no = a.renew_no
                   AND pol_seq_no = a.pol_seq_no
                   AND issue_yy = a.issue_yy
                   AND iss_cd = a.iss_cd
                   AND subline_cd = a.subline_cd
                   AND line_cd = a.line_cd
                   AND eff_date <= a.loss_date
                   AND endt_seq_no = 0;
            EXCEPTION
                WHEN OTHERS THEN
                    v_info.issue_date := NULL;
                    v_info.incept_date := NULL;
            END;
            
            BEGIN
                SELECT TO_CHAR(expiry_date, 'MM-DD-YYYY') exp_date
                  INTO v_info.expiry_date
                  FROM GIPI_POLBASIC
                 WHERE renew_no = a.renew_no
                   AND pol_seq_no = a.pol_seq_no
                   AND issue_yy = a.issue_yy
                   AND iss_cd = a.iss_cd
                   AND subline_cd = a.subline_cd
                   AND line_cd = a.line_cd
                   AND eff_date = (SELECT MAX(b.eff_date)
                                     FROM GIPI_POLBASIC b
                                    WHERE b.renew_no = a.renew_no
                                      AND b.pol_seq_no = a.pol_seq_no
                                      AND b.issue_yy = a.issue_yy
                                      AND b.iss_cd = a.iss_cd
                                      AND b.subline_cd = a.subline_cd
                                      AND b.line_cd = a.line_cd
                                      AND b.eff_date <= a.loss_date);
            EXCEPTION
                WHEN OTHERS THEN
                    v_info.expiry_date := NULL;
            END;
            
            BEGIN
                SELECT assd_name, bill_addr1 ||' '|| bill_addr2 ||' '|| bill_addr3 address
                  INTO v_info.assd_name, v_info.bill_address
                  FROM GIIS_ASSURED
                 WHERE assd_no = a.assd_no;
            EXCEPTION
                WHEN OTHERS THEN
                    v_info.assd_name := NULL;
                    v_info.bill_address := NULL;
            END;
            
            BEGIN
                SELECT loss_cat_des
                  INTO v_info.loss_cat_des
                  FROM GIIS_LOSS_CTGRY
                 WHERE loss_cat_cd = a.loss_cat_cd
                   AND line_cd = a.line_cd;
            EXCEPTION
                WHEN OTHERS THEN
                    v_info.loss_cat_des := NULL;
            END;
            
            BEGIN
                SELECT DISTINCT mortg_name
                  INTO v_info.mortg_name
                  FROM GICL_MORTGAGEE_V1
                 WHERE claim_id = p_claim_id;
            EXCEPTION
                WHEN OTHERS THEN
                    v_info.mortg_name := NULL;
            END;
            
            FOR i IN (SELECT advice_id,
                             line_cd, iss_cd, advice_year, advice_seq_no
                        FROM GICL_ADVICE
                       WHERE claim_id = p_claim_id
                         AND advice_flag = 'Y')
            LOOP
                v_info.advice_id := i.advice_id;
                v_info.advice_no := i.line_cd || '-' || i.iss_cd || '-' || LTRIM(TO_CHAR(i.advice_year,'0999')) || '-' || LTRIM(TO_CHAR(i.advice_seq_no,'099999'));
                EXIT;
            END LOOP;
                       
            v_info.line_cd := a.line_cd;
            v_info.subline_cd := a.subline_cd;
            v_info.iss_cd := a.iss_cd;
            v_info.issue_yy := a.issue_yy;
            v_info.pol_seq_no := a.pol_seq_no;
            v_info.renew_no := a.renew_no;
            v_info.clm_yy := a.clm_yy;
            v_info.clm_seq_no := a.clm_seq_no;
            v_info.loss_loc1 := a.loss_loc1;
            v_info.loss_date := TO_CHAR(a.loss_date, 'MM-DD-YYYY');
            v_info.clm_file_date := TO_CHAR(a.clm_file_date, 'MM-DD-YYYY');
            v_info.policy_no := a.line_cd || '-' || a.subline_cd || '-' || a.iss_cd || '-' ||
                                LTRIM(TO_CHAR(a.issue_yy, '09')) || '-' ||
                                LTRIM(TO_CHAR(a.pol_seq_no, '0999999')) || '-' ||
                                LTRIM(TO_CHAR(a.renew_no, '09'));
            v_info.claim_no := a.line_cd || '-' || a.subline_cd || '-' || a.iss_cd || '-' ||
                               LTRIM(TO_CHAR(a.clm_yy, '09')) || '-' ||
                               LTRIM(TO_CHAR(a.clm_seq_no, '0999999'));
        PIPE ROW(v_info);
        END LOOP;
    END;
    
    /*
    ** Created by    : Marco Paolo Rebong
    ** Created date  : February 16, 2012
    ** Referenced by : (GICLS034 - Final Loss Report)
    ** Description   : Retrieves the advice numbers for the claim
    */
    FUNCTION get_advice_no_lov (
        p_claim_id          GICL_CLAIMS.claim_id%TYPE
    )
      RETURN advice_no_tab PIPELINED AS
        v_adv               advice_no_type;
    BEGIN
        FOR i IN (SELECT advice_id,
                         line_cd || '-' || iss_cd || '-' || LTRIM(TO_CHAR(advice_year,'0999')) || '-' || LTRIM(TO_CHAR(advice_seq_no,'099999')) advice_no
                    FROM GICL_ADVICE
                   WHERE claim_id = p_claim_id
                     AND advice_flag = 'Y'
                   ORDER BY advice_id)
        LOOP
            v_adv.advice_id := i.advice_id;
            v_adv.advice_no := i.advice_no;
            PIPE ROW(v_adv);
        END LOOP;
    END;
    
    /*
    ** Created by    : Marco Paolo Rebong
    ** Created date  : February 16, 2012
    ** Referenced by : (GICLS034 - Final Loss Report)
    ** Description   : Retrieves the payee information for Final Loss Report
    */
    FUNCTION get_payee (
        p_claim_id          GICL_ADVICE.claim_id%TYPE,
        p_advice_id         GICL_ADVICE.advice_id%TYPE
    )
      RETURN payee_tab PIPELINED AS
        v_payee             payee_type;
    BEGIN
        FOR i IN (SELECT a.claim_id, a.item_no, b.advice_id, a.payee_class_cd, a.payee_cd, a.grouped_item_no,
                     SUM(NVL(a.paid_amt, 0)) paid_amt,
                     SUM(NVL(a.net_amt,0)) net_amt,
                     SUM(DECODE(c.tax_type,'W',NVL(c.tax_amt,0),0)) wh_tax,
                     SUM(DECODE(c.tax_type,'I',NVL(c.tax_amt,0),0)) evat
                FROM GICL_LOSS_EXP_TAX C,GICL_CLM_LOSS_EXP A,GICL_ADVICE B
               WHERE a.claim_id = p_claim_id
                 AND b.advice_id = p_advice_id
                 AND a.clm_loss_id = c.clm_loss_id(+)
                 AND a.claim_id = c.claim_id(+)
                 AND a.claim_id = b.claim_id
                 AND a.advice_id = b.advice_id
                 AND NVL(a.dist_sw, 'N') = 'Y'
                 AND b.advice_flag = 'Y'
               GROUP BY a.grouped_item_no, a.claim_id, a.item_no, b.advice_id, a.payee_class_cd, a.payee_cd
               ORDER BY payee_cd)
        LOOP
            BEGIN
                SELECT payee_last_name || ' ' || payee_first_name || ' ' || payee_middle_name
                  INTO v_payee.payee_name
                  FROM GIIS_PAYEES
                 WHERE payee_no = i.payee_cd
                   AND payee_class_cd = i.payee_class_cd;
            END;
            v_payee.claim_id := i.claim_id;
            v_payee.item_no := i.item_no;
            v_payee.advice_id := i.advice_id;
            v_payee.payee_class_cd := i.payee_class_cd;
            v_payee.payee_cd := i.payee_cd;
            v_payee.paid_amt := gicl_prelim_loss_report_pkg.default_currency(i.paid_amt, i.item_no, i.grouped_item_no, i.claim_id);
            v_payee.net_amt := gicl_prelim_loss_report_pkg.default_currency(i.net_amt, i.item_no, i.grouped_item_no, i.claim_id);
            v_payee.wh_tax := gicl_prelim_loss_report_pkg.default_currency(i.wh_tax, i.item_no, i.grouped_item_no, i.claim_id);
            v_payee.evat := gicl_prelim_loss_report_pkg.default_currency(i.evat, i.item_no, i.grouped_item_no, i.claim_id);
            PIPE ROW(v_payee);
        END LOOP;
    END;
    
    /*
    ** Created by    : Marco Paolo Rebong
    ** Created date  : February 20, 2012
    ** Referenced by : (GICLS034 - Final Loss Report)
    ** Description   : Retrieves reinsurers for Final Loss Report
    */
    FUNCTION get_final_peril_info (
        p_claim_id          GICL_ADVICE.claim_id%TYPE,
        p_line_cd           GICL_ADVICE.line_cd%TYPE,
        p_advice_id         GICL_ADVICE.advice_id%TYPE
    )
      RETURN final_peril_tab PIPELINED AS
        v_peril             final_peril_type;
        v_ctr               NUMBER := 1;
    BEGIN
        FOR i IN (SELECT a.*
                    FROM GICL_ITEM_PERIL a
                   WHERE a.claim_id = p_claim_id
                     AND a.line_cd = p_line_cd
                     AND EXISTS (SELECT *
                                   FROM GICL_CLM_LOSS_EXP b
                                  WHERE b.peril_cd = a.peril_cd 
                                    AND b.item_no = a.item_no
                                    AND b.claim_id = p_claim_id
                                    AND b.advice_id = p_advice_id))
        LOOP
            v_peril := NULL;
            v_ctr := 1;
            FOR tsi_ctr_rec IN (SELECT DISTINCT b.claim_id, a.share_type, a.share_cd, a.trty_name 
                                  FROM GICL_POLICY_DIST b, GIIS_DIST_SHARE a 
                                 WHERE b.share_cd     = a.share_cd 
                                   AND b.line_cd      = a.line_cd
                                   AND b.claim_id     = p_claim_id
                                   AND b.peril_cd = i.peril_cd
                                   AND b.shr_tsi_pct != 0) --marco - 07.29.2014 - added to exclude distribution with 0 share
            LOOP
                IF v_ctr = 1 THEN
                    v_peril.ann_tsi_amt2 := gicl_prelim_loss_report_pkg.default_currency(i.ann_tsi_amt, i.item_no, i.grouped_item_no, p_claim_id);
                    
                    BEGIN
                        SELECT peril_name, peril_cd
                          INTO v_peril.peril_name, v_peril.peril_cd
                          FROM GIIS_PERIL
                         WHERE peril_cd = i.peril_cd
                           AND line_cd = p_line_cd;
                    EXCEPTION
                        WHEN OTHERS THEN
                            v_peril.peril_name := NULL;
                    END;
                    
                    BEGIN
                        SELECT SUM(NVL(a.net_amt, 0)) net_amt
                          INTO v_peril.reserve_amt
                          FROM GICL_CLM_LOSS_EXP a,
                               GICL_ADVICE b
                         WHERE a.advice_id = b.advice_id 
                           AND a.claim_id = b.claim_id
                           AND b.advice_id = p_advice_id
                           AND a.peril_cd = i.peril_cd
                           AND a.item_no = i.item_no
                           AND a.grouped_item_no = i.grouped_item_no
                           AND a.claim_id = p_claim_id
                           AND NVL(a.dist_sw, 'N') = 'Y';
                        v_peril.reserve_amt := gicl_prelim_loss_report_pkg.default_currency(v_peril.reserve_amt, i.item_no, i.grouped_item_no, p_claim_id);
                    EXCEPTION
                        WHEN OTHERS THEN
                            v_peril.reserve_amt := NULL;
                    END;
                ELSE
                    v_peril.ann_tsi_amt2 := NULL;
                    v_peril.peril_name := NULL;
                    v_peril.reserve_amt := NULL;
                END IF;
                v_ctr := 2;
                
                v_peril.trty_tsi := NULL; --marco - 07.29.2014 - clear values upon iteration
                v_peril.trty_shr_tsi_pct := NULL;
                v_peril.share_cd := NULL;
                v_peril.tsi_trty := NULL;
                FOR pol_dist_rec IN (SELECT a.claim_id, a.share_cd grp_seq_no, a.shr_tsi_pct shr_pct,
                                            b.trty_name
                                       FROM GICL_POLICY_DIST a,
                                            GIIS_DIST_SHARE b
                                      WHERE a.peril_cd = i.peril_cd
                                        AND a.item_no = i.item_no
                                        AND a.grouped_item_no = i.grouped_item_no
                                        AND a.claim_id = p_claim_id
                                        AND a.share_cd = tsi_ctr_rec.share_cd
                                        AND a.share_cd = b.share_cd)
                LOOP
                    v_peril.trty_tsi := gicl_prelim_loss_report_pkg.default_currency(i.ann_tsi_amt, i.item_no, i.grouped_item_no, p_claim_id) * pol_dist_rec.shr_pct/100;
                    v_peril.trty_shr_tsi_pct := pol_dist_rec.shr_pct;
                    v_peril.share_cd := pol_dist_rec.grp_seq_no;
                    v_peril.tsi_trty := pol_dist_rec.trty_name;
                END LOOP;
                
                v_peril.trty_reserve := NULL; --marco - 07.29.2014 - clear values upon iteration
                v_peril.trty_shr_pct := NULL;
                v_peril.reserve_trty := NULL;
                FOR clm_dist_rec IN (SELECT a.claim_id, a.item_no, a.peril_cd, a.grp_seq_no, a.shr_loss_exp_pct, a.line_cd,
                                            SUM(NVL(a.shr_le_net_amt, 0)) net_amt_ds
                                       FROM GICL_LOSS_EXP_DS a
                                      WHERE a.peril_cd = i.peril_cd
                                        AND a.item_no = i.item_no
                                        AND a.grouped_item_no = i.grouped_item_no
                                        AND a.claim_id = p_claim_id
                                        AND grp_seq_no = tsi_ctr_rec.share_cd
                                        AND NVL(a.negate_tag, 'N') <> 'Y'
                                        AND EXISTS (SELECT 'X'
                                                      FROM GICL_CLM_LOSS_EXP b
                                                     WHERE b.clm_loss_id = a.clm_loss_id
                                                       AND b.claim_id = a.claim_id
                                                       AND b.advice_id = p_advice_id)
                                      GROUP BY a.claim_id, a.item_no, a.peril_cd, a.grp_seq_no, a.shr_loss_exp_pct, a.line_cd)
                LOOP
                    v_peril.trty_reserve := clm_dist_rec.net_amt_ds;
                    v_peril.trty_shr_pct := clm_dist_rec.shr_loss_exp_pct;
                    BEGIN
                        SELECT DISTINCT trty_name
                          INTO v_peril.reserve_trty
                          FROM GIIS_DIST_SHARE
                         WHERE share_cd = clm_dist_rec.grp_seq_no
                           AND line_cd = clm_dist_rec.line_cd;
                    END;
                END LOOP;
                PIPE ROW(v_peril);
            END LOOP;
        END LOOP;
    END;
    
    FUNCTION get_reserve_reinsurance (
        p_claim_id          GICL_RESERVE_RIDS_V1.claim_id%TYPE,
        p_share_cd          GIIS_DIST_SHARE.share_cd%TYPE,
        p_peril_cd          GICL_ITEM_PERIL.peril_cd%TYPE
    )
      RETURN reserve_ri_tab PIPELINED AS
        v_ri                reserve_ri_type;
        v_ri_name           GIIS_REINSURER.ri_name%TYPE;
    BEGIN
      FOR i IN(SELECT *
                 FROM GICL_RESERVE_RIDS_V1
                WHERE claim_id = p_claim_id
                  AND grp_seq_no = p_share_cd
                  AND peril_cd = p_peril_cd
                ORDER BY ri_cd)
      LOOP
        BEGIN
            SELECT ri_name
              INTO v_ri_name
              FROM GIIS_REINSURER
             WHERE ri_cd = i.ri_cd;
        END;
        v_ri.ri_name := v_ri_name;
        v_ri.shr_ri_pct := i.shr_ri_pct;
        v_ri.ri_res_amt := i.ri_res_amt;
        v_ri.ri_res_amt2 := gicl_prelim_loss_report_pkg.default_currency(i.ri_res_amt, i.item_no, NULL, p_claim_id);
        PIPE ROW(v_ri);
      END LOOP;
    END;
    
    FUNCTION get_final_res_ri (
        p_claim_id          GICL_NET_RIDS_V1.claim_id%TYPE,
        p_advice_id         GICL_ADVICE.advice_id%TYPE,
        p_share_cd          GIIS_DIST_SHARE.share_cd%TYPE,
        p_peril_cd          GICL_ITEM_PERIL.peril_cd%TYPE
    )
      RETURN reserve_ri_tab PIPELINED AS
        v_ri                reserve_ri_type;
        v_net_amt           GICL_NET_RIDS_V1.ri_net_amt%TYPE;
        v_ri_name           GIIS_REINSURER.ri_name%TYPE;
        v_net_amt_real      GICL_NET_RIDS_V1.ri_net_amt%TYPE;
    BEGIN
        FOR i IN(SELECT *
                   FROM GICL_NET_RIDS_V1
                  WHERE claim_id = p_claim_id
                    AND grp_seq_no = p_share_cd
                    AND peril_cd = p_peril_cd)
        LOOP
            BEGIN
                SELECT ri_name
                  INTO v_ri_name
                  FROM GIIS_REINSURER
                 WHERE ri_cd = i.ri_cd;
            END;
            BEGIN
                SELECT SUM(NVL(A.SHR_LE_RI_NET_AMT,0))
                  INTO v_net_amt_real
                  FROM GICL_LOSS_EXP_RIDS A,  
                       GICL_LOSS_EXP_DS B, 
                       GICL_CLM_LOSS_EXP C,
                       GICL_ADVICE D
                 WHERE a.grp_seq_no          = b.grp_seq_no 
                   AND a.clm_dist_no         = b.clm_dist_no 
                   AND a.clm_loss_id         = b.clm_loss_id 
                   AND a.claim_id            = b.claim_id
                   AND b.clm_loss_id         = c.clm_loss_id
                   AND b.claim_id            = c.claim_id
                   AND c.advice_id           = d.advice_id
                   AND c.claim_id            = d.claim_id  
                   AND NVL(b.negate_tag,'N') <> 'Y'
                   AND d.advice_id           = p_advice_id
                   AND a.ri_cd               = i.ri_cd
                   AND b.grp_seq_no          = i.grp_seq_no
                   AND c.peril_cd            = i.peril_cd
                   AND c.item_no             = i.item_no
                   AND c.claim_id            = p_claim_id;
            END;
            v_ri.shr_ri_pct := i.shr_ri_pct;
            v_ri.ri_name := v_ri_name;
            v_ri.ri_res_amt := i.ri_net_amt;
            v_ri.ri_res_amt2 := gicl_prelim_loss_report_pkg.default_currency(v_net_amt_real, i.item_no, NULL, p_claim_id);
            PIPE ROW(v_ri);
        END LOOP;
    END;
    
    FUNCTION get_agent_list(
        p_claim_id          GICL_CLAIMS.claim_id%TYPE
    )
      RETURN agent_list_tab PIPELINED AS
        v_agent             agent_list_type;
    BEGIN
        FOR i IN(SELECT DISTINCT intm_name agent, TO_CHAR(intrmdry_intm_no) intm_no
                   FROM GICL_BASIC_INTM_V1
                  WHERE claim_id = p_claim_id)
        LOOP
            v_agent.agent := i.agent;
            PIPE ROW(v_agent);
        END LOOP;
    END;
    
    FUNCTION get_mortgagee_list(
        p_claim_id          GICL_CLAIMS.claim_id%TYPE
    )
      RETURN mortgagee_list_tab PIPELINED AS
        v_mortgagee         mortgagee_list_type;
    BEGIN
        FOR i IN(SELECT DISTINCT mortg_name mortgagee
                   FROM GICL_MORTGAGEE_V1
                  WHERE claim_id = p_claim_id)
        LOOP
            v_mortgagee.mortgagee := i.mortgagee;
            PIPE ROW(v_mortgagee);
        END LOOP;
    END;
    
END GICL_PRELIM_LOSS_REPORT_PKG;
/


