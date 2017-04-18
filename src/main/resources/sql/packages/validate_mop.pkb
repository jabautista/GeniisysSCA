CREATE OR REPLACE PACKAGE BODY CPI.validate_mop

AS

    PROCEDURE get_open_pol_dtl(v_par_id IN NUMBER) IS
        v_line_cd       gipi_polbasic.line_cd%type;
        v_subline_cd    gipi_polbasic.subline_cd%type;
        v_iss_cd        gipi_polbasic.iss_cd%type;
        v_issue_yy      gipi_polbasic.issue_yy%type;
        v_pol_seq_no    gipi_polbasic.pol_seq_no%type;
        v_renew_no      gipi_polbasic.renew_no%type;
        v_par_type   gipi_parlist.par_type%type;
        
        v_incept_date2      gipi_polbasic.incept_date%type;
        v_expiry_date2      gipi_polbasic.expiry_date%type;
        v_eff_date            gipi_polbasic.eff_date%TYPE;
        v_policy_id         gipi_polbasic.policy_id%TYPE;
    BEGIN

      --Modified by: Aaron
      --Remarks:  Modified procedure for posting of endts

        FOR x IN (
            SELECT par_type
              FROM gipi_parlist
             WHERE par_id = v_par_id)
        LOOP
            v_par_type := x.par_type;
        END LOOP;


        IF v_par_type != 'E' THEN
            FOR I IN(
                SELECT a.line_cd, a.op_subline_cd, a.op_iss_cd, op_issue_yy, a.op_pol_seqno, a.op_renew_no
            FROM GIPI_WOPEN_POLICY a
                WHERE a.par_id = v_par_id)
            LOOP

            v_line_cd       := i.line_cd;
            v_subline_cd    := i.op_subline_cd;
            v_iss_cd        := i.op_iss_cd;
            v_issue_yy      := i.op_issue_yy;
            v_pol_seq_no    := i.op_pol_seqno;
            v_renew_no      := i.op_renew_no;

            END LOOP;
        ELSE
            FOR j IN (SELECT a.tsi_amt, a.incept_date, a.expiry_date, a.line_cd, a.subline_cd, a.iss_cd, a.issue_yy, a.pol_seq_no, a.renew_no, b.policy_id
                   FROM gipi_wpolbas a, gipi_polbasic b
               WHERE a.par_id = v_par_id
                   AND a.line_cd = b.line_cd
                AND a.subline_cd = b.subline_cd
                AND a.iss_cd = b.iss_cd
                AND a.issue_yy = b.issue_yy
                AND a.pol_seq_no = b.pol_seq_no
                AND a.renew_no = b.renew_no
                AND b.endt_seq_no = 0)
            LOOP
                FOR k IN (SELECT a.line_cd, a.op_subline_cd, a.op_iss_cd, op_issue_yy, a.op_pol_seqno, a.op_renew_no
                           FROM gipi_open_policy a
                    WHERE policy_id = j.policy_id)
                LOOP
                    v_line_cd       := k.line_cd;
                    v_subline_cd    := k.op_subline_cd;
                    v_iss_cd        := k.op_iss_cd;
                    v_issue_yy      := k.op_issue_yy;
                    v_pol_seq_no    := k.op_pol_seqno;
                    v_renew_no      := k.op_renew_no;
                END LOOP;
             END LOOP;
       END IF;

        SELECT incept_date, expiry_date
          INTO v_incept_rn ,v_expiry_rn
          FROM GIPI_WPOLBAS
         WHERE par_id = v_par_id;

        v_limit_liab := 0;

        FOR X  IN (
           SELECT limit_liability, a.eff_date, a.endt_seq_no,
                   b.currency_rt, a.endt_type, a.back_stat   --added by steven 10.15.2012
           --INTO v_incept_date, v_expiry_date, v_limit_liab
             FROM GIPI_POLBASIC a, GIPI_OPEN_LIAB b
            WHERE a.policy_id = b.policy_id
             AND a.line_cd = v_line_cd
             AND a.subline_cd = v_subline_cd
             AND a.iss_cd = v_iss_cd
             AND a.issue_yy = v_issue_yy
             AND a.pol_seq_no = v_pol_seq_no
             AND a.renew_no = v_renew_no
             AND a.pol_flag not in ('4','5')
            ORDER BY endt_seq_no ,incept_date )
        LOOP
            IF NVL(x.endt_type, 'X') = 'N' OR NVL(x.back_stat,5) = 2 THEN                
                IF  v_incept_rn >= x.eff_date and  v_expiry_rn >= x.eff_date  THEN
                    v_limit_liab  :=  NVL(v_limit_liab,0) + (nvl(x.limit_liability,0) * nvl(x.currency_rt,1)); -- added by steven 10.15.2012
                END IF; 
            ELSE 
                v_limit_liab := nvl(v_limit_liab, 0) + (nvl(x.limit_liability,0) * nvl(x.currency_rt,1)); 
            END IF;
            /*IF  v_incept_rn >= x.eff_date and  v_expiry_rn >= x.eff_date  THEN
                v_limit_liab  :=  NVL(v_limit_liab,0) + (nvl(x.limit_liability,0) * nvl(x.currency_rt,1)); -- added by steven 10.15.2012
            END IF;*/
        END LOOP;
        
        --added by d.alcantara, 03-08-2012, based on procedure GIPI_POLBASIC_PKG.get_ref_pol_no
        FOR A1 IN (  SELECT incept_date,expiry_date,assd_no,eff_date, policy_id, ref_pol_no
                      FROM gipi_polbasic
                     WHERE line_cd    = v_line_cd
                       AND subline_cd = v_subline_cd
                       AND iss_cd     = v_iss_cd
                       AND issue_yy   = v_issue_yy
                       AND pol_seq_no = v_pol_seq_no
                       AND renew_no   = v_renew_no
                     ORDER BY TRUNC(eff_date) DESC)
        LOOP
            v_expiry_date2              := a1.expiry_date;
            v_incept_date2              := a1.incept_date;
            v_eff_date                  := a1.eff_date;
            v_policy_id                 := a1.policy_id;
            FOR z1 IN (SELECT endt_seq_no, expiry_date, incept_date, policy_id
                         FROM GIPI_POLBASIC b2501
                        WHERE b2501.line_cd      = v_line_cd
                            AND b2501.subline_cd = v_subline_cd
                            AND b2501.iss_cd     = v_iss_cd
                            AND b2501.issue_yy   = v_issue_yy
                            AND b2501.pol_seq_no = v_pol_seq_no
                            AND b2501.renew_no   = v_renew_no
                            AND b2501.pol_flag   IN ('1','2','3')
                            AND NVL(b2501.back_stat,5) = 2
                            AND b2501.pack_policy_id IS NULL
                            AND (
                                    b2501.endt_seq_no = 0 OR
                                    (b2501.endt_seq_no > 0 AND
                                    TRUNC(b2501.endt_expiry_date) >= TRUNC(b2501.expiry_date))
                                    )
                        ORDER BY endt_seq_no DESC )
            LOOP
                FOR z1a IN (SELECT endt_seq_no, eff_date, expiry_date, incept_date, policy_id
                                            FROM GIPI_POLBASIC b2501
                                         WHERE b2501.line_cd    = v_line_cd
                                             AND b2501.subline_cd = v_subline_cd
                                             AND b2501.iss_cd     = v_iss_cd
                                             AND b2501.issue_yy   = v_issue_yy
                                             AND b2501.pol_seq_no = v_pol_seq_no
                                             AND b2501.renew_no   = v_renew_no
                                             AND b2501.pol_flag   IN ('1','2','3')
                                             AND b2501.pack_policy_id IS NULL
                                             AND (
                                                        b2501.endt_seq_no = 0 OR
                                                        (b2501.endt_seq_no > 0 AND
                                                        TRUNC(b2501.endt_expiry_date) >= TRUNC(b2501.expiry_date))
                                                        )
                                            ORDER BY endt_seq_no DESC )
                LOOP
                    IF z1.endt_seq_no = z1a.endt_seq_no THEN
                        v_expiry_date2       := z1.expiry_date;
                        v_incept_date2       := z1.incept_date;
                        v_policy_id := z1.policy_id;
                    ELSE
                        IF z1a.eff_date > v_eff_date THEN
                            v_eff_date                 := z1a.eff_date;
                            v_expiry_date2              := z1a.expiry_date;
                            v_incept_date2              := z1a.incept_date;
                            v_policy_id := z1a.policy_id;
                        ELSE
                            v_expiry_date  := z1.expiry_date;
                            v_incept_date  := z1.incept_date;
                        END IF;
                    END IF;                       
                                        
                    EXIT;
                END LOOP;  
                EXIT;
            END LOOP;
            v_expiry_date := v_expiry_date2;
            v_incept_date := v_incept_date2;
            EXIT;
        END LOOP;
        --DBMS_OUTPUT.PUT_LINE(v_incept_date||' :: '||v_expiry_date||' :: '||v_limit_liab);
        -- end add by d.alcantara, 03-08-2012
    END get_open_pol_dtl;

    
    FUNCTION validate_risknote_dtl(v_par_id GIPI_PARLIST.PAR_ID%TYPE)
        RETURN NUMBER IS
        v_etd_rn            GIPI_WCARGO.ETD%TYPE;
        v_eta_rn            GIPI_WCARGO.ETA%TYPE;
        v_total_tsi         GIPI_WITEM.TSI_AMT%TYPE;
        v_valid_date        NUMBER := NULL;
        v_valid_dtl         NUMBER := NULL;
        v_check             NUMBER := NULL;
        v_valid_tsi         NUMBER := NULL;
        v_validate_mop      NUMBER := NULL;
     BEGIN

        get_open_pol_dtl(v_par_id);
        -- ADDED BY MarkS 4.21.2016 for SR-22084
        SELECT NVL(param_value_n,1)
        INTO v_validate_mop
        FROM cpi.giis_parameters
        WHERE param_name = 'VALIDATE_MOP';
        --END SR-22084
        IF v_incept_rn >= v_incept_date AND v_expiry_rn <= v_expiry_date THEN
            v_valid_date := 1;
        ELSE
            v_valid_date := 2;
        END IF;

        BEGIN
            v_valid_dtl := 3;
            FOR J IN (SELECT etd , eta,item_no
                        FROM GIPI_WCARGO
                       WHERE par_id = v_par_id)
            LOOP
                v_etd_rn := J.etd;
                v_eta_rn := J.eta;
                
                IF v_etd_rn IS NOT NULL THEN
                    dbms_output.put_line('etd is valid '||j.item_no);
                    --IF  (v_etd_rn BETWEEN TRUNC(v_incept_rn) AND TRUNC(v_expiry_rn)) THEN
                    --joanne 03.06.14, replace code above etd should be consider effectivity of the MOP policy
                    --EDITED BY MarkS 04.21.2016 added condition to check parameter validate_mop to compare etd with mop policy or rn SR-22084 
                    IF v_validate_mop = 1 THEN
                        IF  (v_etd_rn BETWEEN TRUNC(v_incept_rn) AND TRUNC(v_expiry_rn)) THEN
                            dbms_output.put_line('etd is valid '||j.item_no);
                            v_valid_dtl := 1;
                        ELSE
                            v_valid_dtl := 3;
                            EXIT;
                        END IF;
                    ELSE 
                        IF  (v_etd_rn BETWEEN TRUNC(v_incept_date) AND TRUNC(v_expiry_date)) THEN
                            dbms_output.put_line('etd is valid '||j.item_no);
                            v_valid_dtl := 1;
                        ELSE
                            v_valid_dtl := 3;
                            EXIT;
                        END IF;
                    END IF;
                    -- end SR-22084
                ELSE
                    v_valid_dtl := 1;
                END IF;
 
                IF v_eta_rn IS NOT NULL THEN
                    dbms_output.put_line(' eta is valid '||j.item_no);
                    --IF  (v_eta_rn BETWEEN TRUNC(v_incept_rn) AND TRUNC(v_expiry_rn)) THEN
                    --joanne 03.06.14, replace code above eta should be consider effectivity of the MOP policy
                    --EDITED BY MarkS 04.21.2016 added condition to check parameter validate_mop to compare etd with mop policy or rn SR-22084
                    IF v_validate_mop = 1 THEN
                        IF  (v_eta_rn BETWEEN TRUNC(v_incept_rn) AND TRUNC(v_expiry_rn)) THEN
                            dbms_output.put_line(' eta is valid '||j.item_no);
                            v_valid_dtl := 1;
                        ELSE
                            v_valid_dtl := 3;
                        END IF;
                    ELSE
                        IF  (v_eta_rn BETWEEN TRUNC(v_incept_date) AND TRUNC(v_expiry_date)) THEN
                            dbms_output.put_line(' eta is valid '||j.item_no);
                            v_valid_dtl := 1;
                        ELSE
                            v_valid_dtl := 3;
                        END IF;
                    END IF;
                    -- end SR-22084
                ELSE
                    v_valid_dtl := 1;
                END IF;

                /*     IF v_etd_rn IS NOT NULL OR v_eta_rn IS NOT NULL THEN
                 dbms_output.put_line('etd/eta is not null');
                   IF  (v_etd_rn BETWEEN TRUNC(v_incept_rn) AND TRUNC(v_expiry_rn)) THEN
                   dbms_output.put_line('etd/eta is valid '||j.item_no);
                     v_valid_dtl := 1;
                   END IF;
                   IF (v_eta_rn BETWEEN TRUNC(v_incept_rn) AND TRUNC(v_expiry_rn)) THEN
                   dbms_output.put_line('etd/eta is valid '||j.item_no);
                     v_valid_dtl := 1;
                   END IF;
                   ELSE
                   dbms_output.put_line('etd/eta is not valid '||j.item_no);
                     v_valid_dtl := 3;
                     EXIT;
                   END IF;
                 ELSE
                   v_valid_dtl := 1;
                 END IF;*/
            END LOOP;
        END;

        /*
        IF v_valid_dtl IS NULL  THEN
        v_valid_dtl := 3;
        END IF;
        */
        v_valid_tsi := 1;
        FOR K IN (SELECT (NVL(ann_tsi_amt,0)) total_tsi ,
                        currency_rt  -- added by steven 10.15.2012
                --SUM(tsi_amt) total_tsi
                FROM GIPI_WITEM
           WHERE par_id = v_par_id)
        LOOP
            v_total_tsi := NVL(K.total_tsi,0) * NVL(K.currency_rt,1); -- added by steven 10.15.2012
            IF v_total_tsi <= v_limit_liab THEN
                v_valid_tsi := 1;
            ELSE
                v_valid_tsi := 4;
            END IF;
        END LOOP;

        IF v_valid_date = 2 THEN
            RETURN(2);
        ELSIF v_valid_dtl = 3 THEN
            RETURN(3);
        ELSIF v_valid_tsi = 4 THEN
            RETURN(4);
        ELSE
            RETURN(1);
        END IF;
    END validate_risknote_dtl;

    
    FUNCTION get_latest_intm(v_par_id  GIPI_WPOLBAS.par_id%TYPE)
    RETURN NUMBER IS
        v_line_cd       gipi_polbasic.line_cd%type;
        v_subline_cd    gipi_polbasic.subline_cd%type;
        v_iss_cd        gipi_polbasic.iss_cd%type;
        v_issue_yy      gipi_polbasic.issue_yy%type;
        v_pol_seq_no    gipi_polbasic.pol_seq_no%type;
        v_renew_no      gipi_polbasic.renew_no%type;
        v_par_type      gipi_parlist.par_type%type;
        v_intm_no       GIPI_COMM_INVOICE.intrmdry_intm_no%TYPE;
      
    BEGIN

        FOR x IN (SELECT par_type
                 FROM gipi_parlist
        WHERE par_id = v_par_id)
        LOOP
            v_par_type := x.par_type;
        END LOOP;

        IF v_par_type != 'E' THEN
            FOR I IN(
             SELECT a.line_cd, a.op_subline_cd, a.op_iss_cd, op_issue_yy, a.op_pol_seqno, a.op_renew_no
            FROM GIPI_WOPEN_POLICY a
              WHERE a.par_id = v_par_id)
            LOOP
                v_line_cd       := i.line_cd;
                v_subline_cd    := i.op_subline_cd;
                v_iss_cd        := i.op_iss_cd;
                v_issue_yy      := i.op_issue_yy;
                v_pol_seq_no    := i.op_pol_seqno;
                v_renew_no      := i.op_renew_no;
            END LOOP;
        ELSE
            FOR j IN (SELECT b.policy_id
                   FROM gipi_wpolbas a, gipi_polbasic b
               WHERE a.par_id = v_par_id
                    AND a.line_cd = b.line_cd
                    AND a.subline_cd = b.subline_cd
                    AND a.iss_cd = b.iss_cd
                    AND a.issue_yy = b.issue_yy
                    AND a.pol_seq_no = b.pol_seq_no
                    AND a.renew_no = b.renew_no
                    AND b.endt_seq_no = 0)
            LOOP
                FOR k IN (
                    SELECT a.line_cd, a.op_subline_cd, a.op_iss_cd, op_issue_yy, a.op_pol_seqno, a.op_renew_no
                           FROM gipi_open_policy a
                    WHERE policy_id = j.policy_id)
                LOOP
                    v_line_cd       := k.line_cd;
                    v_subline_cd    := k.op_subline_cd;
                    v_iss_cd        := k.op_iss_cd;
                    v_issue_yy      := k.op_issue_yy;
                    v_pol_seq_no    := k.op_pol_seqno;
                    v_renew_no      := k.op_renew_no;
                END LOOP;
            END LOOP;
        END IF;


        FOR X IN(
           SELECT policy_id
            FROM gipi_polbasic
           WHERE line_cd = v_line_cd
             AND subline_cd = v_subline_cd
             AND iss_cd = v_iss_cd
             AND issue_yy = v_issue_yy
             AND pol_seq_no = v_pol_seq_no
             AND renew_no = v_renew_no
        ORDER BY eff_date DESC, endt_seq_no DESC)
        LOOP

            FOR I IN(
               SELECT intrmdry_intm_no
                 FROM gipi_comm_invoice
                WHERE policy_id = x.policy_id
                ORDER BY prem_seq_no DESC)
            LOOP
                v_intm_no := i.intrmdry_intm_no;
                EXIT;
            END LOOP;
            EXIT;
            
        END LOOP;

        RETURN(v_intm_no);

    END get_latest_intm;
 
END VALIDATE_MOP;
/
