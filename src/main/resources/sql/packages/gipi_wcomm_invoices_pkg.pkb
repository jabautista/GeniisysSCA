CREATE OR REPLACE PACKAGE BODY CPI.Gipi_Wcomm_Invoices_Pkg AS

    FUNCTION get_gipi_wcomm_invoices (
        p_par_id            GIPI_WCOMM_INVOICES.par_id%TYPE,
        p_item_grp            GIPI_WCOMM_INVOICES.item_grp%TYPE)
    RETURN gipi_wcomm_invoices_tab PIPELINED 
    IS
    
    v_wcomm            gipi_wcomm_invoices_type;
    
    BEGIN
        FOR i IN (
            SELECT a.intrmdry_intm_no, b.intm_name,      nvl(b.parent_intm_no, -1) parent_intm_no, nvl(c.intm_name, '') parent_intm_name,
                   a.share_percentage, a.takeup_seq_no,  a.item_grp,        a.par_id,
                   a.premium_amt,        a.commission_amt, a.wholding_tax,   a.commission_amt - a.wholding_tax net_commission  
              FROM GIPI_WCOMM_INVOICES a
                   ,GIIS_INTERMEDIARY b
                   ,GIIS_INTERMEDIARY c
             WHERE a.par_id = p_par_id
               AND a.item_grp = p_item_grp
               AND a.intrmdry_intm_no = b.intm_no
               AND b.parent_intm_no = c.intm_no (+))
        LOOP
            v_wcomm.intrmdry_intm_no        := i.intrmdry_intm_no;
            v_wcomm.intm_name                := i.intm_name;
            v_wcomm.parent_intm_no            := i.parent_intm_no;
            v_wcomm.parent_intm_name        := i.parent_intm_name;
            v_wcomm.share_percentage        := i.share_percentage;
            v_wcomm.takeup_seq_no            := i.takeup_seq_no;
            v_wcomm.item_grp                := i.item_grp;
            v_wcomm.par_id                    := i.par_id;
            v_wcomm.premium_amt                := i.premium_amt;
            v_wcomm.commission_amt            := i.commission_amt;
            v_wcomm.wholding_tax            := i.wholding_tax;
            v_wcomm.net_commission            := i.net_commission;
        PIPE ROW(v_wcomm);
        END LOOP;
        RETURN;
    END get_gipi_wcomm_invoices;
    
    /**
    * Modified by: Emman 04.27.2010
    *  Get comm invoice using par_id only
    */
    
    FUNCTION get_gipi_wcomm_invoices2 (
        p_par_id            GIPI_WCOMM_INVOICES.par_id%TYPE)
    RETURN gipi_wcomm_invoices_tab PIPELINED 
    IS
    
    v_wcomm            gipi_wcomm_invoices_type;
    
    BEGIN
        FOR i IN (
            SELECT a.intrmdry_intm_no, b.intm_name,      b.parent_intm_no, nvl(c.intm_name, '') parent_intm_name,
                   a.share_percentage, a.takeup_seq_no,  a.item_grp,        a.par_id,
                   a.premium_amt,        a.commission_amt, a.wholding_tax,   a.commission_amt - a.wholding_tax net_commission, 
				   b.lic_tag, b.special_rate --added by christian 08.25.2012
              FROM GIPI_WCOMM_INVOICES a
                   ,GIIS_INTERMEDIARY b
                   ,GIIS_INTERMEDIARY c
             WHERE a.par_id = p_par_id
               AND a.intrmdry_intm_no = b.intm_no
               AND b.parent_intm_no = c.intm_no (+))
        LOOP
            v_wcomm.intrmdry_intm_no        := i.intrmdry_intm_no;
            v_wcomm.intm_name                := i.intm_name;
            v_wcomm.parent_intm_no            := i.parent_intm_no;
            v_wcomm.parent_intm_name        := i.parent_intm_name;
            v_wcomm.share_percentage        := i.share_percentage;
            v_wcomm.takeup_seq_no            := i.takeup_seq_no;
            v_wcomm.item_grp                := i.item_grp;
            v_wcomm.par_id                    := i.par_id;
            v_wcomm.premium_amt                := i.premium_amt;
            v_wcomm.commission_amt            := i.commission_amt;
            v_wcomm.wholding_tax            := i.wholding_tax;
            v_wcomm.net_commission            := i.net_commission;
			v_wcomm.lic_tag            := i.lic_tag;   --added by christian 08.25.2012
			v_wcomm.special_rate            := i.special_rate; --added by christian 08.25.2012
			
			BEGIN
            SELECT LIC_TAG, SPECIAL_RATE
              INTO v_wcomm.PARENT_INTM_LIC_TAG,
                   v_wcomm.PARENT_INTM_SPECIAL_RATE
              FROM GIIS_INTERMEDIARY
             WHERE INTM_NO = i.parent_intm_no;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_wcomm.PARENT_INTM_LIC_TAG := '';
               v_wcomm.PARENT_INTM_SPECIAL_RATE := '';
         END;
        PIPE ROW(v_wcomm);
        END LOOP;
        RETURN;
    END get_gipi_wcomm_invoices2;
        
    PROCEDURE set_gipi_wcomm_invoices (
        p_intrmdry_intm_no        IN  GIPI_WCOMM_INVOICES.intrmdry_intm_no%TYPE,
        p_share_percentage        IN  GIPI_WCOMM_INVOICES.share_percentage%TYPE,
        p_takeup_seq_no            IN  GIPI_WCOMM_INVOICES.takeup_seq_no%TYPE,
        p_item_grp                IN  GIPI_WCOMM_INVOICES.item_grp%TYPE,
        p_par_id                IN  GIPI_WCOMM_INVOICES.par_id%TYPE,
        p_premium_amt            IN  GIPI_WCOMM_INVOICES.premium_amt%TYPE,
        p_commission_amt        IN  GIPI_WCOMM_INVOICES.commission_amt%TYPE,
        p_wholding_tax            IN  GIPI_WCOMM_INVOICES.wholding_tax%TYPE,
        p_parent_intm_no        IN GIPI_WCOMM_INVOICES.parent_intm_no%TYPE)
    IS
    BEGIN
        MERGE INTO GIPI_WCOMM_INVOICES
        USING DUAL ON (par_id   = p_par_id
                AND item_grp = p_item_grp
                AND takeup_seq_no = p_takeup_seq_no
                AND intrmdry_intm_no = p_intrmdry_intm_no)
        WHEN NOT MATCHED THEN
            INSERT ( intrmdry_intm_no,   share_percentage,   takeup_seq_no,    item_grp,
                        par_id,             premium_amt,         commission_amt,   wholding_tax,
                        parent_intm_no )
            VALUES ( p_intrmdry_intm_no, p_share_percentage, p_takeup_seq_no,  p_item_grp,
                        p_par_id,             p_premium_amt,         p_commission_amt, p_wholding_tax,
                        p_parent_intm_no )
        WHEN MATCHED THEN
            UPDATE SET  share_percentage = p_share_percentage,
                        premium_amt = p_premium_amt,
                        commission_amt = p_commission_amt,
                        wholding_tax = p_wholding_tax,
                        parent_intm_no = p_parent_intm_no;
    END set_gipi_wcomm_invoices; 
  

    PROCEDURE del_gipi_wcomm_invoices (
        p_par_id            GIPI_WCOMM_INVOICES.par_id%TYPE,
        p_item_grp            GIPI_WCOMM_INVOICES.item_grp%TYPE) IS
    BEGIN
        DELETE FROM GIPI_WCOMM_INVOICES
         WHERE par_id   = p_par_id
           AND item_grp = p_item_grp;
    END del_gipi_wcomm_invoices;                                       

    /*
    **  Modified by        : Mark JM
    **  Date Created     : 02.11.2010
    **  Reference By     : (GIPIS010 - Item Information)
    **  Description     : Delete record by supplying the par_id only
    */
    PROCEDURE del_gipi_wcomm_invoices_1 (p_par_id    GIPI_WCOMM_INVOICES.par_id%TYPE)
    IS
    BEGIN
        DELETE FROM GIPI_WCOMM_INVOICES
         WHERE par_id = p_par_id;
         
    END del_gipi_wcomm_invoices_1;
    
    /*
    ** Modified by : Emman 04.26.10
    ** Description: Delete record by supplying par_id, item_grp, takeup_seq_no, and intm no
    */
    
    PROCEDURE del_gipi_wcomm_invoices_2(
      p_par_id IN GIPI_WCOMM_INV_PERILS.par_id%TYPE,
      p_item_grp IN GIPI_WCOMM_INV_PERILS.item_grp%TYPE,
      p_takeup_seq_no IN GIPI_WCOMM_INV_PERILS.takeup_seq_no%TYPE,
      p_intrmdry_intm_no IN GIPI_WCOMM_INV_PERILS.intrmdry_intm_no%TYPE
    ) IS
    BEGIN
      DELETE FROM GIPI_WCOMM_INVOICES
       WHERE par_id = p_par_id
         AND item_grp = p_item_grp  
         AND takeup_seq_no = p_takeup_seq_no
         AND intrmdry_intm_no = p_intrmdry_intm_no;
    END;
    
    /*
    ** Module functions/procedures
    */
    
    FUNCTION GET_DEFAULT_TAX_RT(par_intrmdry_intm_no GIIS_INTERMEDIARY.INTM_NO%TYPE)
    RETURN GIIS_INTERMEDIARY.WTAX_RATE%TYPE IS
    var_tax_amt          GIIS_INTERMEDIARY.WTAX_RATE%TYPE;
    BEGIN
      BEGIN
        SELECT WTAX_RATE
        INTO VAR_TAX_AMT
        FROM GIIS_INTERMEDIARY
        WHERE PAR_INTRMDRY_INTM_NO = INTM_NO;
        
        RETURN var_tax_amt;
      EXCEPTION
          WHEN NO_DATA_FOUND THEN
           RETURN 0;
      END;
    END;
    
    FUNCTION check_peril_comm_rate (
       p_intrmdry_intm_no GIPI_WCOMM_INV_PERILS.intrmdry_intm_no%TYPE,
       p_par_id IN GIPI_WCOMM_INV_PERILS.par_id%TYPE,
       p_item_grp IN GIPI_WCOMM_INV_PERILS.item_grp%TYPE,
       p_takeup_seq_no IN GIPI_WCOMM_INV_PERILS.takeup_seq_no%TYPE,
       p_line_cd IN VARCHAR2,
       p_iss_cd IN VARCHAR2,
       p_nbt_intm_type IN GIIS_INTERMEDIARY.intm_type%TYPE --null muna to sa ngayon   
    ) RETURN VARCHAR2
    IS
    BEGIN
       DECLARE
          v_peril_name   giis_peril.peril_name%TYPE;
          v_dummy        NUMBER;
          v_sp_rt        VARCHAR2 (1);
          v_subline_cd   gipi_wpolbas.subline_cd%TYPE;
          v_peril_list   VARCHAR2 (200)                 := NULL;
          v_peril        giis_peril.peril_name%TYPE;
          v_missing_perils VARCHAR2(200);
       BEGIN
          v_missing_perils := NULL;
    
        BEGIN
          SELECT special_rate
            INTO v_sp_rt
            FROM giis_intermediary
           WHERE intm_no = p_intrmdry_intm_no;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                    v_sp_rt := 'N';
                END;
    
          SELECT subline_cd
            INTO v_subline_cd
            FROM gipi_wpolbas
           WHERE par_id = p_par_id;
    
          BEGIN
                FOR c1 IN  (SELECT peril_cd
                              FROM gipi_winvperl
                             WHERE par_id = p_par_id
                               AND item_grp = p_item_grp
                               AND takeup_seq_no = p_takeup_seq_no)
                LOOP
                   BEGIN
                      IF v_sp_rt = 'Y' THEN
                         BEGIN --3
                            SELECT rate
                              INTO v_dummy
                              FROM giis_intm_special_rate
                             WHERE intm_no = p_intrmdry_intm_no
                               AND line_cd = p_line_cd
                               AND iss_cd = p_iss_cd
                               AND peril_cd = c1.peril_cd
                               AND subline_cd = v_subline_cd;
                         EXCEPTION
                            WHEN NO_DATA_FOUND THEN
                               BEGIN --2
                                  SELECT comm_rate
                                    INTO v_dummy
                                    FROM giis_intmdry_type_rt
                                   WHERE intm_type = p_nbt_intm_type
                                     AND line_cd = p_line_cd
                                     AND iss_cd = p_iss_cd
                                     AND peril_cd = c1.peril_cd
                                     AND subline_cd = v_subline_cd;
                               EXCEPTION
                                  WHEN NO_DATA_FOUND THEN
                                     BEGIN --1
                                        SELECT peril_name
                                          INTO v_peril
                                          FROM giis_peril
                                         WHERE peril_cd = c1.peril_cd
                                           AND line_cd = p_line_cd;
    
                                        IF v_peril_list IS NOT NULL THEN
                                           v_peril_list :=
                                                    v_peril_list
                                                 || ', '
                                                 || v_peril;
                                        ELSE
                                           v_peril_list := v_peril;
                                        END IF;
                                     EXCEPTION
                                        WHEN NO_DATA_FOUND THEN
                                           NULL;
                                     END; --1
                               END; --2
                         END; --3
                      ELSE --v_sp_rt = 'Y' THEN
                         BEGIN --2
                            SELECT comm_rate
                              INTO v_dummy
                              FROM giis_intmdry_type_rt
                             WHERE intm_type = p_nbt_intm_type
                               AND line_cd = p_line_cd
                               AND iss_cd = p_iss_cd
                               AND peril_cd = c1.peril_cd
                               AND subline_cd = v_subline_cd;
                         EXCEPTION
                            WHEN NO_DATA_FOUND THEN
                               BEGIN --1
                                  SELECT peril_name
                                    INTO v_peril
                                    FROM giis_peril
                                   WHERE peril_cd = c1.peril_cd
                                     AND line_cd = p_line_cd;
    
                                  IF v_peril_list IS NOT NULL THEN
                                     v_peril_list :=
                                                    v_peril_list
                                                 || ', '
                                                 || v_peril;
                                  ELSE
                                     v_peril_list := v_peril;
                                  END IF;
                               EXCEPTION
                                  WHEN NO_DATA_FOUND THEN
                                     NULL;
                               END; --1
                         END; --2
                      END IF; --v_sp_rt = 'Y' THEN
                   END; --loop begin
                END LOOP;
    
                v_missing_perils := v_peril_list;
          END;
          
          RETURN v_missing_perils;
       END;
    END;

    PROCEDURE APPLY_BTN_WHEN_BUTTON_PRESSED(
       p_par_id IN GIPI_WCOMM_INV_PERILS.par_id%TYPE,
       p_item_grp IN GIPI_WCOMM_INV_PERILS.item_grp%TYPE,
       p_intrmdry_intm_no IN GIPI_WCOMM_INV_PERILS.intrmdry_intm_no%TYPE,
       p_intrmdry_intm_no_nbt IN GIPI_WCOMM_INV_PERILS.intrmdry_intm_no%TYPE,
       p_takeup_seq_no IN GIPI_WCOMM_INV_PERILS.takeup_seq_no%TYPE,
       p_share_percentage IN GIPI_WCOMM_INVOICES.share_percentage%TYPE,
       p_share_percentage_nbt IN GIPI_WCOMM_INVOICES.share_percentage%TYPE,
       p_prev_share_percentage IN GIPI_WCOMM_INVOICES.share_percentage%TYPE,
       p_line_cd IN VARCHAR2,
       p_iss_cd IN VARCHAR2,
       p_nbt_intm_type IN GIIS_INTERMEDIARY.intm_type%TYPE, --null muna to sa ngayon       
       p_record_status IN VARCHAR2,
       p_wcominvper_peril_cd IN GIPI_WCOMM_INV_PERILS.peril_cd%TYPE,
       p_wcominvper_commission_amt IN GIPI_WCOMM_INV_PERILS.commission_amt%TYPE,
       p_nbt_commission_amt IN GIPI_WCOMM_INV_PERILS.commission_amt%TYPE,
       p_wcominvper_premium_amt IN OUT GIPI_WCOMM_INV_PERILS.premium_amt%TYPE,
       p_wcominvper_commission_rt IN OUT GIPI_WCOMM_INV_PERILS.commission_rt%TYPE,
       p_wcominvper_wholding_tax IN OUT GIPI_WCOMM_INV_PERILS.wholding_tax%TYPE,
       p_apply_btn_enabled OUT VARCHAR2, --Y for Yes, N for No
       p_commission_rt_enabled OUT VARCHAR2,
       p_commission_amt_enabled OUT VARCHAR2,
       var_message OUT VARCHAR2,
       var_tax_amt OUT GIIS_INTERMEDIARY.WTAX_RATE%TYPE,
       var_share_percentage OUT GIPI_WCOMM_INVOICES.share_percentage%TYPE,
       var_function OUT VARCHAR2,
       var_switch_no OUT VARCHAR2,
       var_switch_name OUT VARCHAR2           
    ) IS
      var_missing_perils VARCHAR2(200);
      var_param_show_comm VARCHAR2(1);
      var_comm_update_tag VARCHAR2(1);
    BEGIN
    
      /** emman 03.29.01
          Procedure when button APPLY_BUTTON is pressed.
      **/
    
    
      /**
      ***  Get the default tax rate of each intermediary.
      **/
      var_function := '';
      var_message := 'SUCCESS';
      var_tax_amt := gipi_wcomm_invoices_pkg.get_default_tax_rt(p_intrmdry_intm_no);
      
      IF giacp.v ('CHECK_COMM_PERIL') = 'Y' THEN
          var_missing_perils := gipi_wcomm_invoices_pkg.check_peril_comm_rate(
            p_intrmdry_intm_no , p_par_id, p_item_grp,
            p_takeup_seq_no, p_line_cd, p_iss_cd, p_nbt_intm_type
            );
          IF var_missing_perils IS NOT NULL THEN
             var_message := 
                   'Please check intermediary commission rates for the following perils: '
                || var_missing_perils
                || '.';
          END IF;
       END IF;
       
       IF      p_intrmdry_intm_no IS NULL
           AND p_share_percentage IS NOT NULL THEN
          var_message := 'Intermediary No. is required.';      
          p_apply_btn_enabled := 'N';
       END IF;
    
       IF p_record_status = 'CHANGED' THEN
          IF NVL (p_share_percentage, 0) <>
                                           NVL (p_share_percentage_nbt, 0) THEN
             var_function := 'UPDATE_WCOMM_INV_PERILS';    
          END IF;
       END IF;
       IF p_record_status IN ('NEW', 'INSERT') THEN 
          IF p_intrmdry_intm_no IS NOT NULL THEN
             var_function := 'POPULATE_WCOMM_INV_PERILS';
             var_switch_no := 'N';
             var_switch_name := 'N';
          END IF;
       ELSIF p_record_status = 'CHANGED' THEN
          IF NVL (p_intrmdry_intm_no, 0) <> NVL (p_intrmdry_intm_no_nbt, 0) THEN
             var_function := 'POPULATE_WCOMM_INV_PERILS;DELETE_WCOMM_INV_PERILS';
             var_switch_no := 'N';
             var_switch_name := 'N';
          END IF;
      END IF;
    
      BEGIN
          SELECT param_value_v
            INTO var_param_show_comm
            FROM giac_parameters
           WHERE param_name = 'SHOW_COMM_AMT';
      EXCEPTION
          WHEN NO_DATA_FOUND THEN
               var_message := 'No data found on giac_parameters for parameter ''SHOW_COMM_AMT''';
      END;
    
      BEGIN
          SELECT comm_update_tag
            INTO var_comm_update_tag
            FROM giis_users
           WHERE user_id = NVL(giis_users_pkg.app_user, USER);--:cg$ctrl.cg$us;
      END;
    
      IF  var_param_show_comm = 'Y' AND var_comm_update_tag = 'N' THEN
           p_commission_rt_enabled := 'N';
           p_commission_amt_enabled := 'N';
       ELSIF  var_param_show_comm = 'N' AND var_comm_update_tag = 'N' THEN          
           p_commission_rt_enabled := 'N';
       ELSE
          p_commission_amt_enabled := 'Y';                          
       END IF;
    
    
       p_wcominvper_wholding_tax :=   ROUND (NVL(p_wcominvper_commission_amt, 0),2)
                                     * NVL (var_tax_amt, 0) / 100;
      
      var_function := var_function || ';COMPUTE_TOT_COM';
    END;

    /*PROCEDURE PACKAGE_COMMISSION(
       p_par_id IN GIPI_WCOMM_INV_PERILS.par_id%TYPE,
       p_item_grp IN GIPI_WCOMM_INV_PERILS.item_grp%TYPE,
       p_intrmdry_intm_no IN GIPI_WCOMM_INV_PERILS.intrmdry_intm_no%TYPE,
       p_iss_cd IN VARCHAR2,
       p_peril_cd IN OUT GIPI_WCOMM_INV_PERILS.peril_cd%TYPE,
       var_rate IN OUT GIPI_INVPERIL.ri_comm_rt%TYPE,
       p_share_percentage IN OUT GIPI_WCOMM_INVOICES.share_percentage%TYPE,
       p_wcominvper_premium_amt IN OUT GIPI_WCOMM_INV_PERILS.premium_amt%TYPE,
       p_wcominvper_commission_rt IN OUT GIPI_WCOMM_INV_PERILS.commission_rt%TYPE,
       p_wcominvper_commission_amt IN OUT GIPI_WCOMM_INV_PERILS.commission_amt%TYPE,
       p_nbt_commission_amt IN OUT GIPI_WCOMM_INV_PERILS.commission_amt%TYPE,
       p_wcominvper_wholding_tax IN OUT GIPI_WCOMM_INV_PERILS.wholding_tax%TYPE,
       var_message IN OUT VARCHAR2
    ) IS
       v_dummy   VARCHAR2(1);
    BEGIN
      var_message := '';
      FOR REC IN (SELECT DISTINCT a.pack_line_cd pack_line_cd,a.pack_subline_cd pack_subline_cd
                    FROM gipi_witem a, gipi_winvoice b
                   WHERE a.par_id = b.par_id
                     AND a.item_grp = b.item_grp
                     AND b.par_id = p_par_id) LOOP
    
            BEGIN
                SELECT 'x' 
                    INTO v_dummy
                    FROM GIPI_WITEM
                   WHERE pack_line_cd = rec.pack_line_cd
                     AND pack_subline_cd = rec.pack_subline_cd
                     AND ROWNUM = 1;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                  var_message := 'No data in giis_line_subline_coverages';
            END;
      END LOOP;
      populate_package_perils(p_par_id, p_item_grp, p_intrmdry_intm_no, p_iss_cd, p_peril_cd, var_rate, p_share_percentage, p_wcominvper_premium_amt, p_wcominvper_commission_rt, p_wcominvper_commission_amt, p_nbt_commission_amt, p_wcominvper_wholding_tax, var_message);
    
    END;*/
    
    PROCEDURE package_commission(p_par_id            IN     GIPI_PARLIST.par_id%TYPE,
                                   p_message               OUT VARCHAR2)
    IS
      /*
      **  Created by   :  Emman
      **  Gipis085 - PACKAGE COMMISSION, CHECK_COVERAGE, and POPULATE_PACKAGE_PERILS 
      */ 
      v_dummy       VARCHAR2(1);
    BEGIN
      p_message := 'POPULATE_PACKAGE_PERILS';
      
      FOR REC IN (SELECT DISTINCT a.pack_line_cd pack_line_cd,a.pack_subline_cd pack_subline_cd
                    FROM gipi_witem a, gipi_winvoice b
                   WHERE a.par_id = b.par_id
                     AND a.item_grp = b.item_grp
                     AND b.par_id = p_par_id) LOOP
    
            -- CHECK_COVERAGE
            BEGIN
              SELECT 'x' 
                INTO v_dummy
                FROM GIPI_WITEM
               WHERE pack_line_cd = rec.pack_line_cd
                 AND pack_subline_cd = rec.pack_subline_cd
                 AND ROWNUM = 1;
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                    p_message := 'No data in giis_line_subline_coverages';
               EXIT;
            END;
      END LOOP;
    END package_commission;
    
    PROCEDURE GET_PACKAGE_INTM_RATE (
          PIR_ITEM_NO  GIPI_WITMPERL.item_no%TYPE,
            PIR_line_cd  GIPI_WITEM.pack_line_cd%TYPE,
          PIR_peril_cd GIPI_WITMPERL.peril_cd%TYPE,
          p_intrmdry_intm_no IN GIPI_WCOMM_INV_PERILS.intrmdry_intm_no%TYPE,
          p_par_id IN GIPI_WCOMM_INV_PERILS.par_id%TYPE,
          p_item_grp IN GIPI_WCOMM_INV_PERILS.item_grp%TYPE,
          p_iss_cd IN VARCHAR2,
          var_iss_cd IN VARCHAR2,
          var_rate IN OUT GIPI_INVPERIL.ri_comm_rt%TYPE
          ) IS

      v_peril_name  giis_peril.peril_name%type;
      v_message     varchar2(200);
      v_sp_rt       varchar2(1);
      v_dummy       VARCHAR2(1);
      V_SUBLINE_CD  GIPI_WITEM.PACK_SUBLINE_CD%TYPE;
      var_nbt_intm_type            GIIS_INTERMEDIARY.intm_type%TYPE;
    
    BEGIN
    
     
     
          select special_rate
            into v_sp_rt
            from giis_intermediary
           where intm_no = p_intrmdry_intm_no;
    
    
          SELECT distinct PACK_SUBLINE_CD
          INTO   V_SUBLINE_CD
          FROM GIPI_WITEM 
          WHERE PAR_ID=p_par_id
          AND   ITEM_GRP = p_item_grp;   
    
    
    
       IF v_sp_rt = 'Y' THEN
    
         BEGIN
    
    
            SELECT rate
              INTO var_rate
              FROM giis_intm_special_rate
             WHERE intm_no   = p_intrmdry_intm_no
               AND line_cd   = PIR_line_cd                     --:b240.line_cd
               AND iss_cd    = p_iss_cd
               AND peril_cd  = PIR_peril_cd
               AND SUBLINE_CD= V_SUBLINE_CD;
    
          EXCEPTION
            WHEN NO_DATA_FOUND THEN 
              BEGIN 
              
                SELECT intm_type
                    INTO var_nbt_intm_type
                    FROM giis_intermediary 
                 WHERE intm_no = p_intrmdry_intm_no;
    
                SELECT comm_rate
                  INTO var_rate
                  FROM giis_intmdry_type_rt
                 WHERE intm_type = var_nbt_intm_type
                   AND line_cd      = PIR_line_cd                --:b240.line_cd
                   AND iss_cd       = var_iss_cd
                   AND peril_cd     = PIR_peril_cd
                   AND SUBLINE_CD   = V_SUBLINE_CD;
    
              EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                      BEGIN
    
                           begin
                              SELECT intm_comm_rt
                            INTO var_rate
                            FROM giis_peril
                           WHERE line_cd   = PIR_line_cd      --:b240.line_cd
                           AND peril_cd  = PIR_peril_cd;
                
                EXCEPTION
                                    WHEN NO_DATA_FOUND THEN
                        var_rate := 0;
                            END;
                         END;
                     END;
               END;
    
        ELSE
              BEGIN
                SELECT comm_rate
                  INTO var_rate
                  FROM giis_intmdry_type_rt
                 WHERE intm_type = var_nbt_intm_type
                   AND line_cd      = PIR_line_cd            --:b240.line_cd
                   AND iss_cd       = var_iss_cd
                   AND peril_cd     = PIR_peril_cd
                   AND SUBLINE_CD   = V_SUBLINE_CD;
                      EXCEPTION
                        WHEN NO_DATA_FOUND THEN
    
                               begin
    
                          BEGIN
                            SELECT intm_comm_rt
                          INTO var_rate
                          FROM giis_peril
                         WHERE line_cd   = PIR_line_cd         --:b240.line_cd
                               AND peril_cd  = PIR_peril_cd;
            
                    exception 
                        when no_data_found then
                        var_rate := 0;    
                                END;
                         END;
               END;
        END IF;
     END;
    
    /*PROCEDURE get_intmdry_rate(
      p_par_id IN GIPI_WCOMM_INV_PERILS.par_id%TYPE,
      p_nbt_ret_orig   IN VARCHAR2,
      p_par_type       IN VARCHAR2,
      p_intrmdry_intm_no IN GIPI_WCOMM_INV_PERILS.intrmdry_intm_no%TYPE,
      p_line_cd IN VARCHAR2,
      p_iss_cd IN VARCHAR2,
      p_nbt_intm_type IN GIIS_INTERMEDIARY.intm_type%TYPE,
      var_rate         IN  OUT GIPI_COMM_INV_PERIL.commission_rt%TYPE,
      var_peril_cd IN GIPI_WCOMM_INV_PERILS.peril_cd%TYPE
    )
    IS
    BEGIN
       DECLARE
          v_peril_name   giis_peril.peril_name%TYPE;
          v_line_name    giis_line.line_name%TYPE;
          v_message      VARCHAR2 (200);
          v_sp_rt        VARCHAR2 (1);
          v_subline_cd   gipi_wpolbas.subline_cd%TYPE;
          v_dummy        VARCHAR2 (1);
          v_policy         gipi_polbasic.policy_id%TYPE;
          v_iss             gipi_invoice.iss_cd%TYPE;
          v_prem         gipi_invoice.prem_seq_no%TYPE;
             v_goto         varchar2(1):='N';
             v_old_policy   gipi_wpolnrep.old_policy_id%TYPE;
             v_no_old       varchar2(1):='N';
             v_no_ri         varchar2(1):='N';
             v_line_cd      gipi_polbasic.line_cd%TYPE;
             v_sub_cd         gipi_polbasic.subline_cd%TYPE;
             v_iss2         gipi_polbasic.iss_cd%TYPE;    
             v_issue         gipi_polbasic.issue_yy%TYPE;
             v_pol             gipi_polbasic.pol_seq_no%TYPE;
             v_renew         gipi_polbasic.renew_no%TYPE;
          v_pol_flag            gipi_polbasic.pol_flag%type;       
    BEGIN
           
    --***added by dannel 07/10/2006***--
    /*retrieve original policy rates and set it as default 
    commision rates when b240.nt_ret_orig is checked/tagged*/
    /*TABLE CONNECTION
    1.gipi_wpolnrep/gipi_polnrep(get old_policy_ id) and gipi_parlist using par_id
    2.gipi_polbasic and  gipi_wpolnrep/gipi_polnrep using policy_id = old_policy_id
    3.gipi_polbasic and gipi_polbasic(select policy_id) using line_cd,subline_cd,iss_cd,issue_yy_pol_seq_no and renew_no
    4.gipi_polbasic and gipi_invoice using policy_id
    5.gipi_invoice and gipi_invperil(select ri_comm_rt) using iss_cd and prem_seq_no*/
    /*
      IF p_nbt_ret_orig ='Y'  THEN
           v_no_old := 'N';
            IF p_par_type='P' THEN--for par listing        
                  BEGIN
                          SELECT old_policy_id
                     INTO v_old_policy--get old policy id
                     FROM gipi_wpolnrep
               WHERE par_id = p_par_id;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                  v_no_old:='Y';--no old policy id         
            END;                             
             END IF;
            
             IF p_par_type='E' THEN-- for endorsements
                    BEGIN
                          SELECT old_policy_id--get old policy id
                     INTO v_old_policy
                     FROM gipi_polnrep
               WHERE par_id = p_par_id;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                   v_no_old:='Y';--no old policy id..get commission_rt from maintenance table         
            END;      
             END IF;
            
             FOR A IN    (SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no
                                   FROM gipi_polbasic
                               WHERE policy_id = v_old_policy)--old_policy_id  
         LOOP 
               v_line_cd    :=A.line_cd;
                 v_sub_cd    :=A.subline_cd;
                 v_iss2        :=A.iss_cd;
                 v_issue        :=A.issue_yy;
                 v_pol            :=A.pol_seq_no;
                 v_renew        :=A.renew_no;              
           EXIT;
         END LOOP;
    
         FOR B IN (SELECT POLICY_ID 
                     FROM GIPI_POLBASIC 
                            WHERE 1=1
                                  AND line_cd        =v_line_cd
                                  AND subline_cd=v_sub_cd
                                  AND iss_cd        =v_iss2
                                  AND issue_yy    =v_issue
                                  AND pol_seq_no=v_pol
                                  AND renew_no    =v_renew)
         LOOP
                  FOR C IN    (SELECT iss_cd,prem_seq_no
                                     FROM gipi_invoice
                                 WHERE policy_id = B.policy_id)
           LOOP
                   v_iss  := C.iss_cd;                      
                  v_prem := C.prem_seq_no;
                  EXIT;
             END LOOP;                
                  
               BEGIN
                       SELECT ri_comm_rt
                 INTO var_rate
                   FROM gipi_invperil
                  WHERE 1 = 1
                      AND iss_cd = v_iss
                      AND peril_cd = var_peril_cd
                      AND prem_seq_no = v_prem;
           EXCEPTION
               WHEN NO_DATA_FOUND THEN
               v_no_ri:='Y';--no record found.. get commission_rt from maintenance table
                 END; 
         END LOOP;                                             
      END IF;--dannel 07/10/2006
    --*******--
        
        
        
    --***added by dannel 07/04/2006***--
    /*default the commission rate based on  rates of policy 
      record when transaction being made is an endorsement(gipi_parlist.par_type='E')*/     
    /*TABLE CONNECTION
    1.gipi_parlist and gipi_wpolbas using par_id   
    2.gipi_wpolbas and gipi_polbasic using line_cd,subline_cd,iss_cd,issue_yy,pol_seq_no,renew_no 
    3.gipi_invoice and gipi_polbasic using policy_id
    4.gipi_comm_inv_peril(get commission_rt policy_id,iss_cd,prem_seq_no,peril_cd )
    */
    /*  IF (p_par_type ='E' and p_nbt_ret_orig ='N') THEN
              FOR  A IN ( SELECT line_cd,subline_cd,iss_cd,issue_yy,pol_seq_no,renew_no,endt_seq_no 
                                      FROM gipi_wpolbas 
                                    WHERE par_id=p_par_id)
                    
             LOOP
                 FOR B IN ( SELECT policy_id 
                                    FROM gipi_polbasic  
                                    WHERE line_cd            =A.line_cd
                                        AND subline_cd    =A.subline_cd
                                        AND iss_cd            =A.iss_cd
                                        AND issue_yy        =A.issue_yy
                                        AND pol_seq_no    =A.pol_seq_no
                                        AND renew_no        =A.renew_no)
                                      --    AND endt_seq_no    =0 )
                         
                  LOOP
                    v_policy := B.policy_id;
             FOR C IN    (SELECT iss_cd,prem_seq_no
                                      FROM gipi_invoice
                                     WHERE policy_id = B.policy_id)    
                  LOOP
                       v_iss  := C.iss_cd;                      
                      v_prem := C.prem_seq_no;
                      EXIT;
                  END LOOP;                   
                      
                BEGIN
                        SELECT commission_rt
                 INTO var_rate
                 FROM gipi_comm_inv_peril
                   WHERE intrmdry_intm_no = p_intrmdry_intm_no
                       AND iss_cd                  = v_iss
                       AND peril_cd              = var_peril_cd
                       AND prem_seq_no    = v_prem
                       AND policy_id             =v_policy;
             EXCEPTION
               WHEN NO_DATA_FOUND THEN
                 v_goto := 'Y';--no record found.. get commission_rt from maintenance table
             END;
             EXIT;
                 END LOOP;            
           EXIT;
             END LOOP;                 
      END IF;        --dannel 07/04/2006
                
      IF (p_par_type='P' AND p_nbt_ret_orig ='N') 
           OR v_goto='Y' OR v_no_ri='Y' OR v_no_ri='Y'  THEN ---****---    modified by dannel 07/11/2006               
         SELECT special_rate
           INTO v_sp_rt
           FROM giis_intermediary
          WHERE intm_no = p_intrmdry_intm_no;
    
         SELECT subline_cd
           INTO v_subline_cd
           FROM gipi_wpolbas
          WHERE par_id = p_par_id;

         IF v_sp_rt = 'Y' THEN            
            BEGIN
             SELECT rate
                INTO var_rate
                FROM giis_intm_special_rate
               WHERE intm_no = p_intrmdry_intm_no
                 AND line_cd = p_line_cd
                 AND iss_cd = p_iss_cd
                 AND peril_cd = var_peril_cd
                 AND subline_cd = v_subline_cd;         


            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                BEGIN                
                      SELECT comm_rate
                    INTO var_rate
                    FROM giis_intmdry_type_rt
                   WHERE intm_type = p_nbt_intm_type
                     AND line_cd = p_line_cd
                     AND iss_cd = p_iss_cd
                     AND peril_cd = var_peril_cd
                     AND subline_cd = v_subline_cd;                                  
                EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                    BEGIN
                      var_rate := 0;
                    END;
                END;
            END;            
         ELSE              
            BEGIN
              FOR A IN ( SELECT comm_rate
                           FROM giis_intmdry_type_rt
                          WHERE intm_type = p_nbt_intm_type
                            AND line_cd = p_line_cd
                            AND iss_cd = p_iss_cd
                            AND peril_cd = var_peril_cd
                            AND subline_cd = v_subline_cd)
              LOOP
                  var_rate := a.comm_rate;              
              END LOOP;
            END;            
         END IF;         
        END IF;
    END;    
    END;*/
    
    PROCEDURE get_intmdry_rate(p_par_id                GIPI_PARLIST.par_id%TYPE,
                                          p_b240_par_type            GIPI_PARLIST.par_type%TYPE,
                                        p_b240_line_cd            GIPI_PARLIST.line_cd%TYPE,
                                        p_b240_iss_cd            GIPI_PARLIST.iss_cd%TYPE,
                                        p_intm_no                GIPI_WCOMM_INVOICES.intrmdry_intm_no%TYPE,
                                             p_nbt_ret_orig            VARCHAR2,
                                        p_var_peril_cd            GIPI_WITMPERL.peril_cd%TYPE,
                                        p_nbt_intm_type            GIIS_INTERMEDIARY.intm_type%TYPE,
                                        p_global_cancel_tag        VARCHAR2,
                                        p_var_rate                OUT GIPI_WCOMM_INV_PERILS.commission_rt%TYPE)
    IS
    BEGIN
        DECLARE
              v_peril_name   giis_peril.peril_name%TYPE;
              v_line_name    giis_line.line_name%TYPE;
              v_message      VARCHAR2 (200);
              v_sp_rt        VARCHAR2 (1);
              v_subline_cd   gipi_wpolbas.subline_cd%TYPE;
              v_dummy        VARCHAR2 (1);
              v_policy             gipi_polbasic.policy_id%TYPE;
              v_iss                     gipi_invoice.iss_cd%TYPE;
              v_prem                 gipi_invoice.prem_seq_no%TYPE;
                   v_goto                 varchar2(1):='N';
                v_old_policy   gipi_wpolnrep.old_policy_id%TYPE;
                v_no_old       varchar2(1):='N';
                v_no_ri                 varchar2(1):='N';
                v_line_cd      gipi_polbasic.line_cd%TYPE;
                v_sub_cd             gipi_polbasic.subline_cd%TYPE;
                v_iss2                     gipi_polbasic.iss_cd%TYPE;    
                v_issue                 gipi_polbasic.issue_yy%TYPE;
                v_pol                     gipi_polbasic.pol_seq_no%TYPE;
                v_renew                 gipi_polbasic.renew_no%TYPE;
                v_pol_flag            gipi_polbasic.pol_flag%type;--vj 012309
               v_nbt_intm_type        GIIS_INTERMEDIARY.intm_type%TYPE;
           
        BEGIN       
        --***added by dannel 07/10/2006***--
        /*retrieve original policy rates and set it as default 
        commision rates when b240.nt_ret_orig is checked/tagged*/
        /*TABLE CONNECTION
        1.gipi_wpolnrep/gipi_polnrep(get old_policy_ id) and gipi_parlist using par_id
        2.gipi_polbasic and  gipi_wpolnrep/gipi_polnrep using policy_id = old_policy_id
        3.gipi_polbasic and gipi_polbasic(select policy_id) using line_cd,subline_cd,iss_cd,issue_yy_pol_seq_no and renew_no
        4.gipi_polbasic and gipi_invoice using policy_id
        5.gipi_invoice and gipi_invperil(select ri_comm_rt) using iss_cd and prem_seq_no*/
        
          IF p_nbt_ret_orig ='Y'  THEN
               v_no_old := 'N';
                IF p_b240_par_type='P' THEN--for par listing        
                      BEGIN
                              SELECT old_policy_id
                         INTO v_old_policy--get old policy id
                         FROM gipi_wpolnrep
                   WHERE par_id = p_par_id;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                      v_no_old:='Y';--no old policy id         
                END;                             
                 END IF;
                
                 IF p_b240_par_type='E' THEN-- for endorsements
                        BEGIN
                              SELECT old_policy_id--get old policy id
                         INTO v_old_policy
                         FROM gipi_polnrep
                   WHERE par_id = p_par_id;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                       v_no_old:='Y';--no old policy id..get commission_rt from maintenance table         
                END;      
                 END IF;
                
                 FOR A IN    (SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no
                                       FROM gipi_polbasic
                                   WHERE policy_id = v_old_policy)--old_policy_id  
             LOOP 
                   v_line_cd    :=A.line_cd;
                     v_sub_cd    :=A.subline_cd;
                     v_iss2        :=A.iss_cd;
                     v_issue    :=A.issue_yy;
                     v_pol        :=A.pol_seq_no;
                     v_renew    :=A.renew_no;              
               EXIT;
             END LOOP;
        
             FOR B IN (SELECT POLICY_ID 
                         FROM GIPI_POLBASIC 
                                WHERE 1=1
                                      AND line_cd        =v_line_cd
                                      AND subline_cd  =v_sub_cd
                                      AND iss_cd        =v_iss2
                                      AND issue_yy    =v_issue
                                      AND pol_seq_no  =v_pol
                                      AND renew_no    =v_renew)
             LOOP
                      FOR C IN    (SELECT iss_cd,prem_seq_no
                                         FROM gipi_invoice
                                     WHERE policy_id = B.policy_id)
               LOOP
                       v_iss  := C.iss_cd;                      
                      v_prem := C.prem_seq_no;
                      EXIT;
                 END LOOP;                
                      
                   --Apollo Cruz 10.23.2014 
                   BEGIN
                           --SELECT ri_comm_rt
                           SELECT commission_rt
                             INTO p_var_rate
                             --FROM gipi_invperil
                             FROM gipi_comm_inv_peril
                            WHERE iss_cd = v_iss
                              AND peril_cd = p_var_peril_cd
                              AND prem_seq_no = v_prem
                              AND intrmdry_intm_no = p_intm_no; --Apollo Cruz 11.17.2014
               EXCEPTION
                   WHEN NO_DATA_FOUND THEN
                   v_no_ri:='Y';--no record found.. get commission_rt from maintenance table
               END;
               
               EXIT; --Apollo Cruz - 11.19.2014 - added exit to retrieve rates of the original policy 
             END LOOP;                                            
          END IF;--dannel 07/10/2006
        --*******--
                    
        --***added by dannel 07/04/2006***--
        /*default the commission rate based on  rates of policy 
          record when transaction being made is an endorsement(gipi_parlist.par_type='E')*/     
        /*TABLE CONNECTION
        1.gipi_parlist and gipi_wpolbas using par_id   
        2.gipi_wpolbas and gipi_polbasic using line_cd,subline_cd,iss_cd,issue_yy,pol_seq_no,renew_no 
        3.gipi_invoice and gipi_polbasic using policy_id
        4.gipi_comm_inv_peril(get commission_rt policy_id,iss_cd,prem_seq_no,peril_cd )
        */
          IF (p_b240_par_type ='E' and p_nbt_ret_orig ='N') THEN
               -- modified for SOA enhancement
                  FOR  A IN (SELECT line_cd,subline_cd,iss_cd,issue_yy,pol_seq_no,renew_no,endt_seq_no,pol_flag,cancelled_endt_id 
                                          FROM gipi_wpolbas 
                                        WHERE par_id=p_par_id)
                        
                 LOOP
--                     modified by gab 11.09.2016 SR 5750
--                     FOR B IN ( SELECT policy_id 
--                                        FROM gipi_polbasic  
--                                        WHERE line_cd            =A.line_cd
--                                            AND subline_cd    =A.subline_cd
--                                            AND iss_cd            =A.iss_cd
--                                            AND issue_yy        =A.issue_yy
--                                            AND pol_seq_no    =A.pol_seq_no
--                                            AND renew_no        =A.renew_no)
--                                          --    AND endt_seq_no    =0 )
--                             
--                      LOOP
--                           -- for SOA enhancement
--                         IF a.pol_flag = 4 or p_global_cancel_tag = 'Y' THEN
--                                 v_policy := nvl(a.cancelled_endt_id,b.policy_id);
--                         ELSE
--                                 v_policy := B.policy_id;
--                         END IF;
--                             
--                       FOR C IN    (SELECT iss_cd,prem_seq_no
--                                                FROM gipi_invoice
--                                               WHERE policy_id = v_policy)    
--                         LOOP
--                              v_iss  := C.iss_cd;                      
--                             v_prem := C.prem_seq_no;
--                             EXIT;
--                         END LOOP;                   
--                          
--                       BEGIN
--                           SELECT commission_rt
--                            INTO p_var_rate
--                            FROM gipi_comm_inv_peril
--                              WHERE intrmdry_intm_no   = p_intm_no
--                                AND iss_cd              = v_iss
--                                AND peril_cd              = p_var_peril_cd
--                                AND prem_seq_no         = v_prem
--                                AND policy_id             = v_policy
--                                AND intrmdry_intm_no = p_intm_no; --Apollo Cruz 11.17.2014;
--                       EXCEPTION
--                         WHEN NO_DATA_FOUND THEN
--                           v_goto := 'Y';--no record found.. get commission_rt from maintenance table
--                       END;
--                       EXIT;
--                     END LOOP;            
--                  EXIT;
                    IF a.pol_flag = 4 or p_global_cancel_tag = 'Y' THEN
                        BEGIN
                            --edited by gab 01.16.2017 SR 5903
                           FOR co IN (SELECT c.commission_rt comm_rt
                             --INTO p_var_rate
                             FROM gipi_polbasic x, gipi_invoice b, gipi_comm_inv_peril c
                            WHERE b.policy_id = NVL(x.cancelled_endt_id, x.policy_id)
                              AND c.iss_cd = b.iss_cd
                              AND c.prem_seq_no = b.prem_seq_no
                              AND c.policy_id = NVL(x.cancelled_endt_id, x.policy_id)
                              AND x.line_cd = A.line_cd
                              AND x.subline_cd = A.subline_cd
                              AND x.iss_cd = A.iss_cd
                              AND x.issue_yy = A.issue_yy
                              AND x.pol_seq_no = A.pol_seq_no
                              AND x.renew_no = A.renew_no
                              AND c.intrmdry_intm_no = p_intm_no
                              AND c.peril_cd = p_var_peril_cd
                          ) LOOP
                           p_var_rate := co.comm_rt;
                         END LOOP;       
                       -- EXCEPTION
                       -- WHEN NO_DATA_FOUND THEN
                          IF p_var_rate IS NULL THEN   
                             v_goto := 'Y';--no record found.. get commission_rt from maintenance table
                          END IF;
                        END;
                        
                    ELSE
                        BEGIN
                        --edited by gab 01.16.2017 SR 5903
                        FOR co IN ( 
                           SELECT c.commission_rt  comm_rt
                             --INTO p_var_rate 
                             FROM gipi_polbasic x, gipi_invoice b, gipi_comm_inv_peril c
                            WHERE b.policy_id = x.policy_id
                              AND c.iss_cd = b.iss_cd
                              AND c.prem_seq_no = b.prem_seq_no
                              AND c.policy_id = x.policy_id
                              AND x.line_cd = A.line_cd
                              AND x.subline_cd = A.subline_cd
                              AND x.iss_cd = A.iss_cd
                              AND x.issue_yy = A.issue_yy
                              AND x.pol_seq_no = A.pol_seq_no
                              AND x.renew_no = A.renew_no
                              AND c.intrmdry_intm_no = p_intm_no
                              AND c.peril_cd = p_var_peril_cd
                          ) LOOP
                            p_var_rate := co.comm_rt;
                          END LOOP;      
                        --EXCEPTION
                        --WHEN NO_DATA_FOUND THEN
                           IF p_var_rate IS NULL THEN
                               v_goto := 'Y';--no record found.. get commission_rt from maintenance table
                           END IF;
                        END;
                    END IF;
                    EXIT;
--                    end gab SR 5750
                 END LOOP;                     
          END IF;        --dannel 07/04/2006
                    
          IF (p_b240_par_type='P' AND p_nbt_ret_orig ='N') 
               OR v_goto='Y' OR v_no_ri='Y' OR v_no_ri='Y'  THEN ---****---    modified by dannel 07/11/2006
               
             SELECT special_rate
               INTO v_sp_rt
               FROM giis_intermediary
              WHERE intm_no = p_intm_no;
        
             SELECT subline_cd
               INTO v_subline_cd
               FROM gipi_wpolbas
              WHERE par_id = p_par_id;
              -- added by d.alcantara, 11/13/2011, to retrieve intm_type in case p_nbt_intm_type is null
              IF p_nbt_intm_type IS NULL THEN
                SELECT intm_type INTO v_nbt_intm_type
                  FROM giis_intermediary
                 WHERE intm_no = p_intm_no;
              END IF;
             
             IF v_sp_rt = 'Y' THEN
                BEGIN
                  SELECT rate
                    INTO p_var_rate
                    FROM giis_intm_special_rate
                   WHERE intm_no = p_intm_no
                     AND line_cd = p_b240_line_cd
                     AND iss_cd = p_b240_iss_cd
                     AND peril_cd = p_var_peril_cd
                     AND subline_cd = v_subline_cd;
            
                EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                    BEGIN
                          SELECT comm_rate
                        INTO p_var_rate
                        FROM giis_intmdry_type_rt
                       WHERE intm_type = nvl(p_nbt_intm_type, v_nbt_intm_type)
                         AND line_cd = p_b240_line_cd
                         AND iss_cd = p_b240_iss_cd
                         AND peril_cd = p_var_peril_cd
                         AND subline_cd = v_subline_cd;
                    EXCEPTION
                      WHEN NO_DATA_FOUND THEN
                        BEGIN
                          p_var_rate := 0;
                        END;
                    END;
                END;
             ELSE
                 
                     IF p_b240_par_type='P' then
                    BEGIN
                      FOR A IN ( SELECT comm_rate
                                    FROM giis_intmdry_type_rt
                                  WHERE intm_type = nvl(p_nbt_intm_type, v_nbt_intm_type)
                                    AND line_cd = p_b240_line_cd
                                    AND iss_cd = p_b240_iss_cd
                                    AND peril_cd = p_var_peril_cd
                                    AND subline_cd = v_subline_cd)
                      LOOP
                          p_var_rate := a.comm_rate;              
                      END LOOP;
                    END;
                     ELSE
                         -- for SOA enhancement
                         FOR  A IN ( SELECT line_cd,subline_cd,iss_cd,issue_yy,pol_seq_no,renew_no,endt_seq_no,pol_flag,cancelled_endt_id 
                                          FROM gipi_wpolbas 
                                        WHERE par_id=p_par_id)
                        
                             LOOP
                                 
                                 FOR B IN ( SELECT policy_id 
                                        FROM gipi_polbasic  
                                        WHERE line_cd            =A.line_cd
                                            AND subline_cd    =A.subline_cd
                                            AND iss_cd            =A.iss_cd
                                            AND issue_yy        =A.issue_yy
                                            AND pol_seq_no    =A.pol_seq_no
                                            AND renew_no        =A.renew_no)
                                          --    AND endt_seq_no    =0 )
                             
                                  LOOP
                                  
                                      /*condition added by VJ 012309*/
                                     IF a.pol_flag = 4 or p_global_cancel_tag = 'Y' THEN
                                         v_policy := nvl(a.cancelled_endt_id,b.policy_id);
                                     ELSE
                                         v_policy := B.policy_id;
                                     END IF;                  
                        
                             FOR C IN    (SELECT iss_cd,prem_seq_no
                                                       FROM gipi_invoice
                                                     WHERE policy_id = v_policy)    
                                  LOOP
                                       v_iss  := C.iss_cd;                      
                                      v_prem := C.prem_seq_no;
                                      EXIT;
                                  END LOOP;
        
                                  DECLARE
                             v_var_rate NUMBER;
                                  BEGIN
                                        SELECT commission_rt
                                 INTO p_var_rate
                                 FROM gipi_comm_inv_peril
                                WHERE intrmdry_intm_no = p_intm_no
                                    AND iss_cd         = v_iss
                                    AND peril_cd         = p_var_peril_cd
                                    AND prem_seq_no    = v_prem
                                    AND policy_id        =v_policy;
                             EXCEPTION
                               WHEN NO_DATA_FOUND THEN
                             --aaron 042309 modified when no data found exception to avoid ora-01403 
                            --rad 04/22/2010 added back to fetch comm_rate when no data was found.
                            FOR x IN (SELECT comm_rate
                                      FROM giis_intmdry_type_rt
                                     WHERE intm_type = nvl(p_nbt_intm_type, v_nbt_intm_type)
                                       AND line_cd = p_b240_line_cd
                                       AND iss_cd = p_b240_iss_cd
                                       AND peril_cd = p_var_peril_cd
                                       AND subline_cd = v_subline_cd)
                            LOOP
                                 v_var_rate := x.comm_rate;
                            END LOOP;                 
                                  p_var_rate := NVL(v_var_rate,0);
                                 v_goto := 'Y';--no record found.. get commission_rt from maintenance table
                             END;
                             EXIT;
                                 END LOOP;            
                           EXIT;
                             END LOOP;
             END IF;
            END IF;
          END IF;
        END;
    END get_intmdry_rate;
    
    /*PROCEDURE populate_wcomm_inv_perils(
          p_par_id IN GIPI_WCOMM_INV_PERILS.par_id%TYPE,
          p_item_grp IN OUT GIPI_WCOMM_INV_PERILS.item_grp%TYPE,
          p_takeup_seq_no IN GIPI_WCOMM_INV_PERILS.takeup_seq_no%TYPE,
          p_line_cd IN VARCHAR2,
          p_intrmdry_intm_no IN GIPI_WCOMM_INV_PERILS.intrmdry_intm_no%TYPE,
          p_nbt_intm_type IN GIIS_INTERMEDIARY.intm_type%TYPE,
          p_nbt_ret_orig   IN VARCHAR2,  
          var_peril_cd IN OUT GIPI_WCOMM_INV_PERILS.peril_cd%TYPE,
          --p_wcominvper_nbt_peril_cd IN OUT GIPI_WCOMM_INV_PERILS.peril_cd%TYPE,
          p_share_percentage IN OUT GIPI_WCOMM_INVOICES.share_percentage%TYPE,
          p_prev_share_percentage IN OUT GIPI_WCOMM_INVOICES.share_percentage%TYPE,
          p_wcominvper_premium_amt IN OUT GIPI_WCOMM_INV_PERILS.premium_amt%TYPE,
          p_wcominvper_commission_rt IN OUT GIPI_WCOMM_INV_PERILS.commission_rt%TYPE,
          p_wcominvper_commission_amt IN OUT GIPI_WCOMM_INV_PERILS.commission_amt%TYPE,
          p_nbt_commission_amt IN OUT GIPI_WCOMM_INV_PERILS.commission_amt%TYPE,
          p_wcominvper_wholding_tax IN OUT GIPI_WCOMM_INV_PERILS.wholding_tax%TYPE,
          --var_iss_cd IN VARCHAR2,
          p_iss_cd IN OUT VARCHAR2,
          var_message OUT VARCHAR2,
          var_rate IN OUT GIPI_INVPERIL.ri_comm_rt%TYPE
        )
        IS
        BEGIN
           DECLARE
              v_peril_name             giis_peril.peril_name%TYPE;
              v_total_commission       gipi_wcomm_invoices.commission_amt%TYPE;
              v_total_wholding_tax     gipi_wcomm_invoices.wholding_tax%TYPE;
              v_total_premium_amt      gipi_wcomm_invoices.premium_amt%TYPE;
              v_total_net_commission   gipi_wcomm_invoices.commission_amt%TYPE;
              v_dummy                  VARCHAR2 (1);
              v_other_prem             NUMBER;
              v_par_type               GIPI_PARLIST.par_type%TYPE;
              v_rate                   GIPI_INVPERIL.ri_comm_rt%TYPE;
              var_iss_cd               VARCHAR2 (200);
              var_nbt_intm_type            GIIS_INTERMEDIARY.intm_type%TYPE;
           BEGIN
              var_message := 'SUCCESS';
              v_rate := var_rate;
         
              BEGIN
                 SELECT 'x'
                   INTO v_dummy
                   FROM giis_line_subline_coverages
                  WHERE line_cd = p_line_cd AND ROWNUM = 1;
                 
                 GIPI_WCOMM_INVOICES_PKG.package_commission(p_par_id, p_item_grp, p_intrmdry_intm_no, p_iss_cd, var_peril_cd, var_rate, p_share_percentage, p_wcominvper_premium_amt, p_wcominvper_commission_rt, p_wcominvper_commission_amt, p_nbt_commission_amt, p_wcominvper_wholding_tax, var_message);
                 
              EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                    FOR c1_rec IN  (SELECT peril_cd, prem_amt
                                      FROM gipi_winvperl
                                     WHERE par_id = p_par_id
                                       AND item_grp = p_item_grp
                                       AND takeup_seq_no = p_takeup_seq_no
                                       AND peril_cd = var_peril_cd)
                    LOOP
                       BEGIN
                          BEGIN
                             SELECT param_value_v
                               INTO var_iss_cd
                               FROM giis_parameters
                              WHERE param_name = 'HO';
                          EXCEPTION
                             WHEN NO_DATA_FOUND THEN
                                var_message := 'Parameter HO does not exist in giis parameters.';
                                RETURN;
                          END;
                          
                          BEGIN
                             SELECT par_type
                              INTO v_par_type
                              FROM gipi_parlist
                              WHERE par_id = p_par_id;
                          EXCEPTION
                             WHEN NO_DATA_FOUND THEN
                                v_par_type := '';
                          END;
                          
                          SELECT intm_type
                              INTO var_nbt_intm_type
                              FROM giis_intermediary 
                             WHERE intm_no = p_intrmdry_intm_no;
        
                          get_intmdry_rate(p_par_id, p_nbt_ret_orig, v_par_type, p_intrmdry_intm_no, p_line_cd, p_iss_cd, var_nbt_intm_type, v_rate, var_peril_cd);
        
                          IF (v_par_type ='E' and p_nbt_ret_orig ='N') THEN
                              v_rate := v_rate;
                          ELSE
                              v_rate := v_rate + GET_ADJUST_INTRMDRY_RATE(p_intrmdry_intm_no, p_par_id, var_peril_cd);
                          END IF;
                          
                          --%%%%---
                          BEGIN
                             IF nvl(v_rate,0) IS NOT NULL THEN--modified by VJ 031307
                                BEGIN
                                   SELECT peril_name
                                     INTO v_peril_name
                                     FROM giis_peril
                                    WHERE peril_cd = c1_rec.peril_cd
                                      AND line_cd = p_line_cd;    
                                      
                                   --p_wcominvper_nbt_peril_cd := v_peril_name;                       
        
                                   /*If-Else removed
                                       emman 04.16.10
                                       directly compute premium amt
                                   */
                                   
                                   /*IF NVL (p_share_percentage, 0) =
                                                          NVL(p_prev_share_percentage,0)  AND NVL(p_share_percentage,0) <> 100 THEN
                                      --meaning it is the last share
                                      BEGIN
                                         SELECT SUM (premium_amt)
                                           INTO v_other_prem
                                           FROM gipi_wcomm_inv_perils
                                          WHERE par_id = p_par_id
                                            AND item_grp = p_item_grp
                                            AND takeup_seq_no = p_takeup_seq_no
                                            AND peril_cd = c1_rec.peril_cd;
                                      EXCEPTION
                                         WHEN OTHERS THEN
                                            v_other_prem := 0;
                                      END;
        
                                      p_wcominvper_premium_amt :=
                                                        c1_rec.prem_amt
                                                      - v_other_prem;
                                   ELSE*/
                                   /*p_wcominvper_premium_amt :=
                                              c1_rec.prem_amt
                                            * NVL (p_share_percentage, 0)
                                            / 100;
                                   /*END IF;*/ --NVL (p_share_percentage, 0) = p_prev_share_percentage
        
                                   -- :wcominvper.wholding_tax      := variables.wholding_tax * NVL(p_share_percentage,0)/100;
                                   /*p_wcominvper_commission_rt := nvl(v_rate,0);--vj 031307                                   
                                   var_rate := v_rate;
                                   v_total_commission :=
                                           NVL (v_total_commission, 0)
                                         + NVL (p_wcominvper_commission_amt, 0);
                                   v_total_wholding_tax :=
                                           NVL (v_total_wholding_tax, 0)
                                         + NVL (p_wcominvper_wholding_tax, 0);
                                   v_total_premium_amt :=   NVL (
                                                               v_total_premium_amt,
                                                               0)
                                                          + NVL (
                                                               p_wcominvper_premium_amt,
                                                               0);
                                   v_total_net_commission :=
                                           NVL (v_total_net_commission, 0)
                                         + NVL (p_nbt_commission_amt, 0);
                                EXCEPTION
                                   WHEN NO_DATA_FOUND THEN
                                      NULL;
                                END;
                             END IF;
                          END;
                       END;
                    END LOOP;                    
              END;
           END;        
        END;*/
        
        PROCEDURE populate_wcomm_inv_perils(p_par_id                    IN     GIPI_PARLIST.par_id%TYPE,
                                               p_line_cd                    IN       GIPI_PARLIST.line_cd%TYPE,
                                             p_item_grp                    IN       GIPI_WCOMM_INVOICES.item_grp%TYPE,
                                             p_var_iss_cd               OUT GIPI_POLBASIC.iss_cd%TYPE,
                                             p_message                       OUT VARCHAR2)
        IS
        BEGIN
           DECLARE
              v_peril_name             giis_peril.peril_name%TYPE;
              v_total_commission       gipi_wcomm_invoices.commission_amt%TYPE;
              v_total_wholding_tax     gipi_wcomm_invoices.wholding_tax%TYPE;
              v_total_premium_amt      gipi_wcomm_invoices.premium_amt%TYPE;
              v_total_net_commission   gipi_wcomm_invoices.commission_amt%TYPE;
              v_dummy                  VARCHAR2 (1);
              v_other_prem             NUMBER;
              v_subline_cd                         GIIS_SUBLINE.subline_cd%TYPE;
              v_sliding_comm           VARCHAR2(1);
              v_rate                    GIPI_WCOMM_INV_PERILS.commission_rt%TYPE;
              v_prem_rt      GIPI_WITMPERL.prem_rt%TYPE;
              v_default_rt   GIIS_PERIL.default_rate%TYPE;
           BEGIN
               BEGIN
                 SELECT subline_cd
                   INTO v_subline_cd
                   FROM gipi_wpolbas
                  WHERE par_id = p_par_id;
               END;
               
               BEGIN
                    SELECT param_value_v
                      INTO p_var_iss_cd
                      FROM giis_parameters
                     WHERE param_name = 'HO';
               EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                      p_var_iss_cd := '';
               END;  
               
               BEGIN
                 SELECT 'x'
                   INTO v_dummy
                   FROM giis_line_subline_coverages
                  WHERE line_cd = p_line_cd AND ROWNUM = 1;
                 
                 GIPI_WCOMM_INVOICES_PKG.package_commission(p_par_id, p_message);
                 
                 /*IF p_message = 'POPULATE_PACKAGE_PERILS' THEN
                     RETURN;
                 END IF;*/
                 
               EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                     p_message := 'POPULATE_WCOMM_INV_PERILS';
                  END;
            END;
        END populate_wcomm_inv_perils;
        
        /*PROCEDURE populate_package_perils (
           p_par_id IN GIPI_WCOMM_INV_PERILS.par_id%TYPE,
           p_item_grp IN GIPI_WCOMM_INV_PERILS.item_grp%TYPE,
           p_intrmdry_intm_no IN GIPI_WCOMM_INV_PERILS.intrmdry_intm_no%TYPE,
           p_iss_cd IN VARCHAR2,
           p_peril_cd IN OUT GIPI_WCOMM_INV_PERILS.peril_cd%TYPE,
           var_rate IN OUT GIPI_INVPERIL.ri_comm_rt%TYPE,
           p_share_percentage IN OUT GIPI_WCOMM_INVOICES.share_percentage%TYPE,
           p_wcominvper_premium_amt IN OUT GIPI_WCOMM_INV_PERILS.premium_amt%TYPE,
           p_wcominvper_commission_rt IN OUT GIPI_WCOMM_INV_PERILS.commission_rt%TYPE,
           p_wcominvper_commission_amt IN OUT GIPI_WCOMM_INV_PERILS.commission_amt%TYPE,
           p_nbt_commission_amt IN OUT GIPI_WCOMM_INV_PERILS.commission_amt%TYPE,
           p_wcominvper_wholding_tax IN OUT GIPI_WCOMM_INV_PERILS.wholding_tax%TYPE,
           var_message OUT VARCHAR2
        ) IS
            v_peril_name           giis_peril.peril_name%type;
            v_total_commission     gipi_wcomm_invoices.commission_amt%type;
            v_total_wholding_tax   gipi_wcomm_invoices.wholding_tax%type;
            v_total_premium_amt    gipi_wcomm_invoices.premium_amt%type;
            v_total_net_commission gipi_wcomm_invoices.commission_amt%type;
            v_dummy                VARCHAR2(1);
            var_iss_cd               VARCHAR2 (200);
        BEGIN
            var_message := ''; 
            FOR rec IN (SELECT a.item_no item_no, b.pack_line_cd pack_line_cd, a.peril_cd peril_cd, a.prem_amt prem_amt
                             FROM gipi_witmperl a, gipi_witem b
                           WHERE a.par_id   = b.par_id
                             AND a.item_no  = b.item_no
                             AND a.par_id   = p_par_id 
                             AND b.item_grp = p_item_grp )
            LOOP
                BEGIN          
                    BEGIN
                      SELECT param_value_v
                        INTO var_iss_cd
                        FROM giis_parameters
                       WHERE param_name = 'HO';
                    EXCEPTION                              
                      WHEN NO_DATA_FOUND THEN
                        var_message := 'Parameter HO does not exist in giis parameters.';
                    END;
        
                  GET_PACKAGE_INTM_RATE(rec.item_no, rec.pack_line_cd, rec.peril_cd, p_intrmdry_intm_no, p_par_id, p_item_grp, p_iss_cd, var_iss_cd, var_rate);
        
                    IF var_rate IS NOT NULL THEN
                       BEGIN
                           SELECT peril_name
                             INTO v_peril_name
                             FROM giis_peril
                            WHERE peril_cd = rec.peril_cd
                              AND line_cd  = rec.pack_line_cd;  
                             
                           p_peril_cd          := rec.peril_cd;
                           p_wcominvper_commission_rt       := rec.prem_amt * NVL(p_share_percentage,0)/100;
                        -- :wcominvper.wholding_tax      := variables.wholding_tax * NVL(p_share_percentage,0)/100;
                           p_wcominvper_commission_rt     := var_rate;
                           v_total_commission            := NVL(v_total_commission,0) + NVL(p_wcominvper_commission_amt,0);              
                           v_total_wholding_tax          := NVL(v_total_wholding_tax,0) + NVL(p_wcominvper_wholding_tax,0);                
                           v_total_premium_amt           := NVL(v_total_premium_amt,0) + NVL(p_wcominvper_commission_rt,0);                
                           v_total_net_commission        := NVL(v_total_net_commission,0) + NVL(p_nbt_commission_amt,0); 
                       EXCEPTION
                            WHEN NO_DATA_FOUND THEN NULL;
                       END;
                    END IF;  
              END;
            end loop;            
        END;*/
        
        PROCEDURE populate_package_perils (p_par_id                    GIPI_PARLIST.par_id%TYPE,
                                     p_item_grp                GIPI_WCOMM_INVOICES.item_grp%TYPE,
                                   pack_witmperl_list        OUT GIPI_WCOMM_INVOICES_PKG.pack_witmperl_cur)
        IS
            v_peril_name           giis_peril.peril_name%type;
            v_total_commission     gipi_wcomm_invoices.commission_amt%type;
            v_total_wholding_tax   gipi_wcomm_invoices.wholding_tax%type;
            v_total_premium_amt    gipi_wcomm_invoices.premium_amt%type;
            v_total_net_commission gipi_wcomm_invoices.commission_amt%type;
            v_dummy                VARCHAR2(1);
        
        BEGIN
            OPEN pack_witmperl_list FOR
            SELECT a.item_no item_no, b.pack_line_cd pack_line_cd, a.peril_cd peril_cd, a.prem_amt prem_amt, c.peril_name
                     FROM gipi_witmperl a, gipi_witem b, giis_peril c
                   WHERE a.par_id   = b.par_id
                     AND a.item_no  = b.item_no
                     AND a.par_id   = p_par_id 
                     AND b.item_grp = p_item_grp
                     AND c.peril_cd = a.peril_cd
                     AND c.line_cd  = b.pack_line_cd;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                 NULL;
        END populate_package_perils;
        
        FUNCTION GET_ADJUST_INTRMDRY_RATE(p_intrmdry_intm_no IN NUMBER,
                                  p_par_id IN NUMBER,
                                  p_peril_cd IN VARCHAR2) RETURN NUMBER IS
          v_co_intm_type    giis_intermediary.co_intm_type%TYPE;
          v_parent_intm_no  giis_intermediary.parent_intm_no%TYPE;
          v_comm_rate       giis_spl_override_rt.comm_rate%TYPE := 0;
          v_line_cd         gipi_wpolbas.line_cd%TYPE;
          v_subline_cd      gipi_wpolbas.subline_cd%TYPE;
          v_iss_cd          gipi_wpolbas.iss_cd%TYPE;
        BEGIN
          FOR c1 IN (SELECT 1
                       FROM giis_intermediary
                      WHERE intm_no = p_intrmdry_intm_no
                              AND lic_tag = 'N'
                              AND special_rate = 'Y') --Apollo Cruz 10.22.2014                              
          LOOP
            BEGIN
              SELECT line_cd, subline_cd, iss_cd
                INTO v_line_cd, v_subline_cd, v_iss_cd
                FROM gipi_wpolbas
               WHERE par_id = p_par_id;
            END;    
            FOR gip_trg IN (SELECT 1
                              FROM giis_intm_special_rate
                             WHERE intm_no = p_intrmdry_intm_no
                               AND line_cd = v_line_cd
                               AND iss_cd = v_iss_cd
                               AND peril_cd = p_peril_cd
                               AND subline_cd = v_subline_cd
                               AND override_tag = 'Y') 
            LOOP
            BEGIN
                  -- grace 02.02.2007
                  -- change the select-into to for-loop to prevent ORA-01403 error
                  FOR A IN ( SELECT a.co_intm_type typ, b.parent_intm_no
                               FROM giis_intermediary a,
                                  giis_intermediary b
                            WHERE a.intm_no = b.parent_intm_no            
                              AND b.intm_no = p_intrmdry_intm_no)
                LOOP
                    v_co_intm_type := a.typ;
                    v_parent_intm_no := a.parent_intm_no;
                END LOOP;                  
                              
                END;
                BEGIN
                  SELECT a.comm_rate
                    INTO v_comm_rate
                  FROM giis_spl_override_rt a
                 WHERE intm_no = v_parent_intm_no
                   AND line_cd = v_line_cd
                   AND iss_cd = v_iss_cd
                   AND peril_cd = p_peril_cd
                   AND subline_cd = v_subline_cd;
                EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                    v_comm_rate := 0;        
              END;
            END LOOP;    
          END LOOP; 
          RETURN(v_comm_rate); 
        END;
        
    PROCEDURE INTM_NO_WHEN_VALIDATE_ITEM (
         p_par_id                              IN GIPI_WCOMM_INV_PERILS.par_id%TYPE,
         p_intm_no                              IN GIPI_WCOMM_INV_PERILS.intrmdry_intm_no%TYPE,
         p_line_cd                              IN VARCHAR2,
         p_lov_tag                              IN VARCHAR2,
         p_global_cancel_tag                 IN VARCHAR2,
         var_message                          OUT VARCHAR2
         )
    IS
    BEGIN
            var_message := 'SUCCESS';
            
            DECLARE /*vj 011909*/
                v_pol_flag     gipi_wpolbas.pol_flag%type;
                v_par_type    gipi_parlist.par_type%type;
                v_ctr1      NUMBER;
                v_ctr2      NUMBER;
            BEGIN
            
            /* rad 04/22/2010: added to disallow manual input of non-active INTM no. */
            SELECT count(intm_no)
              INTO v_ctr1
              FROM giis_intermediary
             WHERE intm_no = p_intm_no
               AND active_tag = 'A';
        
            SELECT count(intm_no)
              INTO v_ctr2
              FROM giis_intermediary
             WHERE intm_no = p_intm_no;
               
             IF v_ctr1 = 0 and v_ctr2 <> 0 THEN
                 var_message := 'INTM_NOT_ACTIVE';
                RETURN;
             END IF;
             /* rad 04/22/2010 end of mod */
        
                BEGIN
                    SELECT par_type
                        INTO v_par_type
                      FROM gipi_parlist
                      WHERE par_id = p_par_id;
                END;
                BEGIN
                    SELECT pol_flag
                      INTO v_pol_flag
                      FROM GIPI_WPOLBAS
                      WHERE PAR_ID = p_par_id;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        v_pol_flag := 1;
                END;
                IF v_par_type = 'E' and (NVL(p_global_cancel_tag, 'N') = 'Y' or v_pol_flag = 4) THEN
                    --IF p_var_intm_no <> p_intm_no THEN
                        var_message := 'CANCELLATION_ENDT';
                        --p_intm_no := p_var_intm_no;
                    --END IF;
                END IF;
            END;
    
            DECLARE
                CHK                  BOOLEAN := FALSE;
                ALERT_BUTTON         NUMBER;
                isscd                GIIS_INTERMEDIARY.iss_cd%TYPE;
                PARAMV               GIAC_PARAMETERS.PARAM_VALUE_V%TYPE;
                iname                giis_issource.iss_name%TYPE;
                MERON                BOOLEAN := FALSE;
                v_par_type               GIPI_PARLIST.par_type%TYPE;
                v_assd_no               GIPI_PARLIST.assd_no%TYPE;
                v_iss_cd               GIPI_PARLIST.iss_cd%TYPE;
                v_intm_no               GIIS_INTERMEDIARY.intm_no%TYPE;        
                v_dummy                   VARCHAR2(1);    
            BEGIN                
                FOR RV IN (SELECT INTM_NO
                      FROM giis_intermediary
                      WHERE INTM_NO = p_intm_no)
                   LOOP
                       v_INTM_NO := RV.INTM_NO;
                     EXIT;
                    END LOOP;
                 
                IF v_INTM_NO IS NULL AND P_INTM_NO IS NOT NULL THEN
                   var_message := 'INTM_NOT_EXIST_MASTER';
                   RETURN;
                END IF;
                
                BEGIN
                SELECT 'a'
                    INTO v_dummy  
                    FROM (SELECT intm_no
                              FROM giis_intermediary
                             WHERE (/*((*/intm_no IN ( SELECT a.intrmdry_intm_no 
                                                      FROM gipi_comm_invoice a, gipi_wpolbas b, gipi_polbasic c 
                                                     WHERE b.par_id     = p_par_id 
                                                       AND b.line_cd    = c.line_cd 
                                                       AND b.subline_cd = c.subline_cd 
                                                       AND b.iss_cd     = nvl(c.iss_cd,c.iss_cd)
                                                       AND b.issue_yy   = c.issue_yy 
                                                       AND b.pol_seq_no = c.pol_seq_no 
                                                       AND b.renew_no   = c.renew_no 
                                                       AND c.policy_id  = a.policy_id)
                                                          AND active_tag = 'A')      
                       UNION ALL
                          SELECT intm_no
                            FROM giis_intermediary        
                           WHERE intm_no = p_intm_no
                             AND active_tag = 'A')
                    WHERE ROWNUM=1;  
                    --ging--      
                    EXCEPTION
                        WHEN no_data_found THEN
                          IF p_intm_no IS NOT NULL THEN
                            var_message := 'INTM_NOT_EXIST';    
                            RETURN;                 
                            --msg_alert('Intermediary No. does not exist.','W',FALSE);                           
                          END IF; 
                        WHEN too_many_rows THEN
                          NULL;
                END;
         
                BEGIN
                 SELECT par_type, assd_no, iss_cd
                    INTO v_par_type, v_assd_no, v_iss_cd
                    FROM gipi_parlist
                    WHERE par_id = p_par_id;
                 EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                   v_par_type := '';
                END;
                  IF P_INTM_NO IS NOT NULL THEN
                       FOR C IN (SELECT intm_no intrmdry_intm_no
                                                 FROM giis_intermediary 
                                                WHERE intm_no IN ( SELECT intm_no
                                                         FROM giis_assured_intm A
                                                        WHERE A.assd_no = v_assd_no
                                                         AND p_line_cd = line_cd)
                                                                   ORDER BY intm_no)
                       LOOP
                             IF C.intrmdry_intm_no = p_intm_no THEN
                                    MERON := TRUE;
                             END IF;
                        END LOOP;
                       
                         IF NOT MERON AND 
                               p_lov_tag = 'FILTERED' AND 
                                v_par_type = 'P'  THEN
                                var_message := 'INTNO_NOT_IN_LOV';
                                RETURN;
                         END IF;
                    END IF;
                    
                    SELECT PARAM_VALUE_V 
                        INTO PARAMV
                        FROM GIAC_PARAMETERS
                     WHERE PARAM_NAME = 'CHECK_ISS_CD';
        
                  IF UPPER(PARAMV) = 'Y' AND 
                       p_intm_no IS NOT NULL THEN
                         FOR CUR IN (SELECT ISS_CD ICODE
                                                   FROM GIIS_INTERMEDIARY 
                                                  WHERE INTM_NO = p_intm_no)
                         LOOP
                              isscd := CUR.ICODE; 
                             IF v_iss_cd = CUR.ICODE THEN
                                    CHK := TRUE;
                             END IF;
                         END LOOP;
                         IF CHK = FALSE THEN
                                SELECT iss_name 
                                  INTO iname 
                                    FROM giis_issource
                                 WHERE iss_cd = isscd;
                                var_message := 'The issuing source of this intermediary is '||
                                    iname||'. Do you want to continue?'; 
                                RETURN;
                         END IF;
                  END IF;
            END;
            
            DECLARE
                   var       VARCHAR2(20);
                   v_iss_cd               GIPI_PARLIST.iss_cd%TYPE;
            BEGIN  
                FOR param IN (SELECT param_value_v
                                FROM giis_parameters
                               WHERE param_name = 'DEFAULT_CRED_BRANCH')
                LOOP 
                    var := param.param_value_v;
                    EXIT;
                END LOOP;
                
                SELECT param_value_v
                  INTO v_iss_cd
                  FROM giis_parameters
                  WHERE param_name = 'HO';
                
                IF var = 'AGENT' THEN
                   IF P_INTM_NO IS NOT NULL THEN
                               UPDATE gipi_wpolbas
                                 SET cred_branch = v_iss_cd
                                WHERE par_id = p_par_id; 
                   END IF;         
               END IF;
          END;
    END INTM_NO_WHEN_VALIDATE_ITEM;
        
        PROCEDURE GET_PAR_TYPE_AND_ENDTTAX (
         p_par_id                              IN GIPI_WCOMM_INV_PERILS.par_id%TYPE,
         p_par_type                             OUT GIPI_PARLIST.par_type%TYPE,
         p_endt_tax                             OUT GIPI_WENDTTEXT.endt_tax%TYPE
         ) IS
         BEGIN
               FOR tp IN (
                 SELECT par_type
                     FROM gipi_parlist
                    WHERE par_id = p_par_id)
                 LOOP 
                   p_par_type := tp.par_type;
                 END LOOP;
              
              FOR endttax IN (
                 SELECT endt_tax    
                      FROM gipi_wendttext
                     WHERE par_id = p_par_id)
                 LOOP
                   p_endt_tax := endttax.endt_tax;
                 END LOOP;
        END;
    
    /*
    **  Created by   :  Emman
    **  Date Created :  12.10.2010
    **  Reference By : (GIPIS085 - Commission Invoice)
    **  Description  : Executes the WHEN-NEW-FORM-INSTANCE trigger of GIPIS085, and loads the banc_type list
    */
    PROCEDURE gipis085_new_form_instance(p_par_id                IN  GIPI_PARLIST.par_id%TYPE,
                                      p_global_cancel_tag        OUT  VARCHAR2,
									  p_is_package				 IN  VARCHAR2,
                                        p_bancassurance_rec      OUT VARCHAR2,
                                      p_cancellation_type        OUT VARCHAR2,
                                        p_banca_btn_enabled      OUT VARCHAR2,
                                      p_banca_check_enabled      OUT VARCHAR2,
                                      p_var_banc_rate_sw         OUT VARCHAR2,
                                      p_var_override_whtax       OUT    GIIS_PARAMETERS.param_value_v%TYPE,
                                        p_var_v_comm_update_tag  OUT    GIIS_USERS.comm_update_tag%TYPE,
                                      p_var_v_param_show_comm    OUT    GIAC_PARAMETERS.param_value_v%TYPE,
                                      p_var_endt_yy              OUT GIPI_WPOLBAS.endt_yy%TYPE,
                                      p_var_param_req_def_intm   OUT VARCHAR2,
                                      p_v_ora2010_sw             OUT VARCHAR2,
                                      p_v_validate_banca         OUT VARCHAR2,
                                      p_v_par_type               OUT GIPI_PARLIST.par_type%TYPE,
                                      p_v_endt_tax               OUT GIPI_WENDTTEXT.endt_tax%TYPE,
                                      p_v_pol_flag               OUT GIPI_WPOLBAS.pol_flag%TYPE,
                                      p_v_gipi_wpolnrep_exist    OUT VARCHAR2,
                                      p_v_lov_tag                OUT VARCHAR2,
                                      p_v_wcominv_intm_no_lov    OUT VARCHAR2,
                                      p_v_allow_apply_sl_comm    OUT VARCHAR2,
                                      p_gipis085_b240            OUT GIPI_WCOMM_INVOICES_PKG.gipis085_b240_cur,
                                      p_wcomm_invoices           OUT GIPI_WCOMM_INVOICES_PKG.gipi_wcomm_invoices_cur,
                                      p_winvoice                 OUT GIPI_WINVOICE_PKG.gipi_winvoice_cur,
                                      p_wcomm_inv_perils         OUT GIPI_WCOMM_INV_PERILS_PKG.gipi_wcomm_inv_perils_cur,
                                      p_banc_type                OUT GIIS_BANC_TYPE_PKG.giis_banc_type_cur,
                                      p_banc_type_dtl_list       OUT GIIS_BANC_TYPE_DTL_PKG.giis_banc_type_dtl_cur,
                                      p_item_grp_list            OUT GIPI_WCOMM_INVOICES_PKG.winvoice_item_grp_cur,
                                      p_intm_no                  OUT gipi_wcomm_invoices.intrmdry_intm_no%TYPE, 
                                      p_dsp_intm_name            OUT VARCHAR2,
                                      p_parent_intm_no           OUT gipi_wcomm_invoices.parent_intm_no%TYPE,
                                      p_parent_intm_name         OUT VARCHAR2,
                                      p_msg_alert                OUT VARCHAR2,
                                      p_coinsurer_sw             OUT VARCHAR2, --Apollo Cruz 10.10.2014
                                      p_dflt_intm_no             OUT giis_assured_intm.intm_no%TYPE, --benjo 09.07.2016 SR-5604
                                      p_req_dflt_intm_per_assd   OUT VARCHAR2, --benjo 09.07.2016 SR-5604
                                      p_allow_upd_intm_per_assd  OUT VARCHAR2) --benjo 09.07.2016 SR-5604
    IS
        v_banc_type_cd                          GIPI_WPOLBAS.banc_type_cd%TYPE;
        v_gipis085_b240_cnt                        NUMBER(1) := 1;
        v_wcomm_invoices_cnt                  NUMBER(1) := 1;
        v_winvoice_cnt                          NUMBER(1) := 1;
        v_wcomm_inv_perils_cnt                  NUMBER(1) := 1;
        v_b240_assd_no                          GIPI_PARLIST.assd_no%TYPE;
        v_b240_line_cd                          GIPI_PARLIST.line_cd%TYPE;
        v_b240_par_type                          GIPI_PARLIST.par_type%TYPE;
        v_wcominv_intm_no                      GIPI_WCOMM_INVOICES.intrmdry_intm_no%TYPE := NULL;
    BEGIN
        p_v_lov_tag := 'UNFILTERED';
        p_msg_alert := 'SUCCESS';
        p_v_wcominv_intm_no_lov := 'cgfk$wcominvDspIntmName5';
        -- The main records
        -- B240 (GIPI_PARLIST
        
        --Added by Apollo Cruz 12.15.2014
        BEGIN
           SELECT 'Y'
             INTO p_global_cancel_tag
             FROM gipi_wpolbas
            WHERE par_id = p_par_id
              AND cancelled_endt_id IS NOT NULL;
        EXCEPTION WHEN NO_DATA_FOUND THEN
           p_global_cancel_tag := 'N';          
        END;
        
        BEGIN
			IF NVL(p_is_package, 'N') = 'N' THEN
	            OPEN p_gipis085_b240 FOR
	                SELECT a.par_id, a.line_cd, a.iss_cd, a.par_yy,
	                       a.par_seq_no, a.quote_seq_no, d.line_cd||' - '||d.iss_cd||' - '||to_char(d.par_yy,'09')||' - '||to_char(d.par_seq_no,'099999')||' - '||to_char(d.quote_seq_no,'09') dsp_pack_par_no,
	                       a.line_cd || ' - ' || a.iss_cd || ' - ' || to_char(a.par_yy,'09') || ' - ' || to_char(a.par_seq_no,'099999') || ' - ' || to_char(a.quote_seq_no,'09') drv_par_seq_no,
	                       b.pol_flag, a.assd_no, ESCAPE_VALUE(c.assd_name) dsp_assd_name, a.par_status,
	                       b.endt_yy nb_endt_yy, a.par_type, a.pack_par_id, b.subline_cd
	                  FROM GIPI_PARLIST a, GIPI_WPOLBAS b, GIIS_ASSURED c, GIPI_PACK_PARLIST d
	                 WHERE a.par_id = p_par_id
	                   AND b.par_id (+) = a.par_id
	                   AND c.assd_no (+) = a.assd_no
	                   AND d.pack_par_id (+) = a.pack_par_id;
			ELSE
				OPEN p_gipis085_b240 FOR
	                SELECT a.par_id, a.line_cd, a.iss_cd, a.par_yy,
	                       a.par_seq_no, a.quote_seq_no, d.line_cd||' - '||d.iss_cd||' - '||to_char(d.par_yy,'09')||' - '||to_char(d.par_seq_no,'099999')||' - '||to_char(d.quote_seq_no,'09') dsp_pack_par_no,
	                       a.line_cd || ' - ' || a.iss_cd || ' - ' || to_char(a.par_yy,'09') || ' - ' || to_char(a.par_seq_no,'099999') || ' - ' || to_char(a.quote_seq_no,'09') drv_par_seq_no,
	                       b.pol_flag, a.assd_no, ESCAPE_VALUE(c.assd_name) dsp_assd_name, a.par_status,
	                       b.endt_yy nb_endt_yy, a.par_type, a.pack_par_id, b.subline_cd
	                  FROM GIPI_PARLIST a, GIPI_WPOLBAS b, GIIS_ASSURED c, GIPI_PACK_PARLIST d
	                 WHERE a.pack_par_id = p_par_id
	                   AND b.par_id (+) = a.par_id
	                   AND c.assd_no (+) = a.assd_no
	                   AND d.pack_par_id (+) = a.pack_par_id
					   AND a.par_status NOT IN (98,99);
			END IF;
        EXCEPTION
             WHEN NO_DATA_FOUND THEN
                 v_gipis085_b240_cnt := 0;
        END;
        
        -- GIPI_WCOMM_INVOICES
        BEGIN
			IF NVL(p_is_package, 'N') = 'N' THEN
	            OPEN p_wcomm_invoices FOR
	                 SELECT * 
	                     FROM TABLE(GIPI_WCOMM_INVOICES_PKG.get_gipi_wcomm_invoices2(p_par_id))
	               ORDER BY item_grp, intrmdry_intm_no;
			ELSE
				OPEN p_wcomm_invoices FOR
	                 SELECT * 
	                     FROM TABLE(GIPI_WCOMM_INVOICES_PKG.get_pack_gipi_wcomm_invoices(p_par_id))
	               ORDER BY item_grp, intrmdry_intm_no;
			END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                 v_wcomm_invoices_cnt := 0;
        END;
        
        -- GIPI_WINVOICES
        BEGIN
			IF NVL(p_is_package, 'N') = 'N' THEN
	            OPEN p_winvoice FOR
	                 SELECT * 
	                   FROM TABLE(Gipi_Winvoice_Pkg.get_gipi_winvoice2(p_par_id));
			ELSE
				OPEN p_winvoice FOR
	                 SELECT * 
	                   FROM TABLE(Gipi_Winvoice_Pkg.get_pack_gipi_winvoice(p_par_id));
			END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                 v_winvoice_cnt := 0;
        END;
        
        -- for the display of item grp and takeup seq no
        BEGIN
			 IF NVL(p_is_package, 'N') = 'N' THEN
		         OPEN p_item_grp_list FOR
		            SELECT DISTINCT item_grp 
		              FROM TABLE(Gipi_Winvoice_Pkg.get_gipi_winvoice2(p_par_id))
		          ORDER BY item_grp;
			 ELSE
			 	 OPEN p_item_grp_list FOR
		            SELECT DISTINCT item_grp 
		              FROM TABLE(Gipi_Winvoice_Pkg.get_pack_gipi_winvoice(p_par_id))
		          ORDER BY item_grp;
			 END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                 NULL;
        END;
        
        -- GIPI_WCOMM_INV_PERILS
        BEGIN
			IF NVL(p_is_package, 'N') = 'N' THEN
	            OPEN p_wcomm_inv_perils FOR
	                 SELECT * 
	                     FROM TABLE(GIPI_WCOMM_INV_PERILS_PKG.get_gipi_wcomm_inv_perils2(p_par_id));
			ELSE
				OPEN p_wcomm_inv_perils FOR
	                 SELECT * 
	                     FROM TABLE(GIPI_WCOMM_INV_PERILS_PKG.get_pack_gipi_wcomm_inv_perils(p_par_id));
			END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                 v_wcomm_inv_perils_cnt := 0;
        END;
        
        -- basic item field values
        IF v_wcomm_invoices_cnt > 0 THEN
		   IF NVL(p_is_package, 'N') = 'N' THEN
	           FOR i IN (SELECT intrmdry_intm_no
	                         FROM TABLE(GIPI_WCOMM_INVOICES_PKG.get_gipi_wcomm_invoices2(p_par_id))
	                      WHERE ROWNUM = 1)
	           LOOP
	                  v_wcominv_intm_no := i.intrmdry_intm_no;
	           END LOOP;
		   ELSE
		   	   FOR i IN (SELECT intrmdry_intm_no
	                         FROM TABLE(GIPI_WCOMM_INVOICES_PKG.get_pack_gipi_wcomm_invoices(p_par_id))
	                      WHERE ROWNUM = 1)
	           LOOP
	                  v_wcominv_intm_no := i.intrmdry_intm_no;
	           END LOOP;
		   END IF;
           
		   IF NVL(p_is_package, 'N') = 'N' THEN
	           FOR i IN (SELECT line_cd, assd_no, par_type
	                              FROM GIPI_PARLIST
	                      WHERE par_id = p_par_id)
	           LOOP
	               v_b240_line_cd  := i.line_cd;
	               v_b240_assd_no  := i.assd_no;
	               v_b240_par_type := i.par_type;
	           END LOOP;
		   ELSE
		   	   FOR i IN (SELECT line_cd, assd_no, par_type
	                              FROM GIPI_PACK_PARLIST /*GIPI_PARLIST*/ --benjo 09.07.2016 SR-5604
	                      WHERE pack_par_id = p_par_id)
	           LOOP
	               v_b240_line_cd  := i.line_cd;
	               v_b240_assd_no  := i.assd_no;
	               v_b240_par_type := i.par_type;
	           END LOOP;
		   END IF;
        END IF;
        
        BEGIN
			IF NVL(p_is_package, 'N') = 'N' THEN
	            SELECT nvl(endt_yy,0)
	              INTO p_var_endt_yy
	                FROM gipi_wpolbas
	            WHERE par_id = p_par_id;
			ELSE
				SELECT nvl(endt_yy,0)
	              INTO p_var_endt_yy
	                FROM gipi_wpolbas
	            WHERE pack_par_id = p_par_id;
			END IF;        
        EXCEPTION
            WHEN OTHERS THEN
                NULL;
        END;
		
		-- get pol_flag
        BEGIN
			IF NVL(p_is_package, 'N') = 'N' THEN
	            SELECT pol_flag
	                INTO p_v_pol_flag
	                FROM GIPI_WPOLBAS
	              WHERE par_id = p_par_id;
			ELSE
				SELECT pol_flag
	                INTO p_v_pol_flag
	                FROM GIPI_WPOLBAS
	              WHERE par_id IN (SELECT DISTINCT par_id
				 	   			   	  FROM gipi_parlist b240
									 WHERE b240.pack_par_id = p_par_id)
				    AND ROWNUM = 1;
			END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                p_v_pol_flag := 1;
        END;
        
        /* GET_DEFAULT_ASSURED_INTM */
        
        DECLARE        
            DUMMY  NUMBER;
            DUMMY2 GIIS_ASSURED_INTM.INTM_NO%TYPE;
            CTR NUMBER:=0;
            v_pol_flag    GIPI_WPOLBAS.pol_flag%TYPE;
        BEGIN
             IF v_b240_par_type = 'P' THEN
			 	BEGIN
				 	IF NVL(p_is_package, 'N') = 'N' THEN
		                   SELECT DISTINCT 1
		                    INTO DUMMY 
		                    FROM gipi_wcomm_invoices
		                   WHERE par_id = p_par_id;
					ELSE
						SELECT DISTINCT 1
		                    INTO DUMMY 
		                    FROM gipi_wcomm_invoices
		                   WHERE par_id IN (SELECT DISTINCT par_id
						 	   			   	  FROM gipi_parlist b240
											 WHERE b240.pack_par_id = p_par_id);
					END IF;
         
                BEGIN
                  SELECT INTM_NO 
                    INTO DUMMY2
                    FROM giis_assured_intm
                   WHERE assd_no = v_b240_assd_no
                     AND line_cd = v_b240_line_cd;
        
                  FOR V1 IN (SELECT INTM_NO 
                               FROM giis_assured_intm
                              WHERE assd_no = v_b240_assd_no
                                AND line_cd =  v_b240_line_cd) 
                  LOOP
                    IF v_wcominv_intm_no IS NOT NULL AND V1.INTM_NO = v_wcominv_intm_no THEN
                        p_v_lov_tag := 'FILTERED';
                        p_v_wcominv_intm_no_lov := 'cgfk$wcominvDspIntmName';
                    ELSIF v_wcominv_intm_no IS NOT NULL AND V1.INTM_NO!=v_wcominv_intm_no THEN
                        p_v_lov_tag := 'UNFILTERED';  
                        p_v_wcominv_intm_no_lov := 'cgfk$wcominvDspIntmName5';   
                    END IF;
                  END LOOP;
           
                EXCEPTION
                  WHEN NO_DATA_FOUND THEN 
                         p_v_lov_tag := 'UNFILTERED';
                      p_v_wcominv_intm_no_lov := 'cgfk$wcominvDspIntmName5';          
                  WHEN TOO_MANY_ROWS THEN
                    p_v_lov_tag := 'FILTERED';
                    p_v_wcominv_intm_no_lov := 'cgfk$wcominvDspIntmName';
                END;  
                
                --Added by Apollo Cruz 11.13.2014
                IF NVL(p_is_package, 'N') = 'N' THEN
                   GIPIS085_DEFAULT_INTRMDRY(p_par_id, p_intm_no, p_dsp_intm_name, p_parent_intm_no);
				    ELSE
					    GIPIS085_PACK_DEFAULT_INTRMDRY(p_par_id, p_intm_no, p_dsp_intm_name, p_parent_intm_no);
					 END IF; 
         
              EXCEPTION    
                WHEN no_data_found THEN
                  IF p_v_pol_flag = '2' THEN
				  	 IF NVL(p_is_package, 'N') = 'N' THEN
	                     FOR intm IN (SELECT a.intrmdry_intm_no 
	                                    FROM gipi_comm_invoice a, gipi_polbasic b, gipi_wpolnrep c
	                                   WHERE c.par_id    = p_par_id
	                                     AND b.policy_id = c.old_policy_id
	                                     AND b.policy_id = a.policy_id)
	                     LOOP
	                       CTR:=CTR+1;
	                     END LOOP;
					 ELSE
					 	 FOR intm IN (SELECT a.intrmdry_intm_no 
	                                    FROM gipi_comm_invoice a, gipi_polbasic b, gipi_wpolnrep c
	                                   WHERE c.par_id    IN (SELECT DISTINCT par_id
										 	   			   	   FROM gipi_parlist b240
															  WHERE b240.pack_par_id = p_par_id)
	                                     AND b.policy_id = c.old_policy_id
	                                     AND b.policy_id = a.policy_id)
	                     LOOP
	                       CTR:=CTR+1;
	                     END LOOP;
					 END IF;                
                  ELSE
                     FOR V1 IN(SELECT INTM_NO
                                 FROM GIIS_ASSURED_INTM
                                WHERE ASSD_NO=v_b240_assd_no
                                  AND LINE_cD=v_b240_line_cd)
                     LOOP
                       CTR:=CTR+1;
                     END LOOP;
                  END IF;
                  IF CTR>1 THEN 
                     p_v_lov_tag := 'FILTERED';
                     p_v_wcominv_intm_no_lov := 'cgfk$wcominvDspIntmName';                                 
                  ELSIF CTR=1 THEN
                        --DEFAULT_INTRMDRY;
						IF NVL(p_is_package, 'N') = 'N' THEN
                           GIPIS085_DEFAULT_INTRMDRY(p_par_id, p_intm_no, p_dsp_intm_name, p_parent_intm_no);
						ELSE
						   GIPIS085_PACK_DEFAULT_INTRMDRY(p_par_id, p_intm_no, p_dsp_intm_name, p_parent_intm_no);
						END IF;
                        
                       -- get parent_intm_name
                        p_parent_intm_name := NULL;
                        
                        IF p_parent_intm_no IS NULL THEN
                           p_parent_intm_no := p_intm_no;
                        END IF;
                                            
                        FOR intm IN (SELECT intm_name
                                       FROM giis_intermediary
                                      WHERE intm_no = p_parent_intm_no)
                        LOOP
                            p_parent_intm_name := intm.intm_name;
                        END LOOP;
                        
                        IF p_parent_intm_name IS NULL THEN
                           p_parent_intm_name := p_dsp_intm_name;
                        END IF;
                  ELSIF CTR = 0 THEN           
                        p_var_param_req_def_intm := giac_parameters_pkg.v('REQ_DEF_INTM');
                        IF p_var_param_req_def_intm = 'Y' THEN
                               --p_msg_alert := 'There is no default intermediary for this assured.';
                            p_msg_alert := 'NO_DEFAULT_INTM';                             
                            p_v_lov_tag := 'UNFILTERED';
                            RETURN;                                                   
                        ELSE
                           p_v_lov_tag := 'UNFILTERED';
                          p_v_wcominv_intm_no_lov := 'cgfk$wcominvDspIntmName5';
                         END IF;
                      END IF;    
                WHEN too_many_rows then
                  FOR V1 IN (SELECT INTM_NO 
                               FROM giis_assured_intm
                              WHERE assd_no = v_b240_assd_no
                                AND line_cd = v_b240_line_cd) 
                  LOOP
                     IF v_wcominv_intm_no IS NOT NULL AND V1.INTM_NO=v_wcominv_intm_no THEN
                          p_v_lov_tag := 'FILTERED';
                          p_v_wcominv_intm_no_lov := 'cgfk$wcominvDspIntmName';
                     ELSIF v_wcominv_intm_no IS NOT NULL AND DUMMY2!=v_wcominv_intm_no THEN
                        p_v_lov_tag := 'UNFILTERED';
                        p_v_wcominv_intm_no_lov := 'cgfk$wcominvDspIntmName5';          
                     END IF;            
                  END LOOP;      
              END;
           ELSE   
              BEGIN
			  	IF NVL(p_is_package, 'N') = 'N' THEN
	                  SELECT DISTINCT 1
	                    INTO DUMMY 
	                    FROM gipi_wcomm_invoices
	                   WHERE par_id = p_par_id;
				ELSE
				  	  SELECT DISTINCT 1
	                    INTO DUMMY 
	                    FROM gipi_wcomm_invoices
	                   WHERE par_id IN (SELECT DISTINCT par_id
						 	   			   	  FROM gipi_parlist b240
											 WHERE b240.pack_par_id = p_par_id);
				END IF;
				  
				IF NVL(p_is_package, 'N') = 'N' THEN
	                BEGIN
	                  select a.intrmdry_intm_no
	                    into dummy2 
	                   from gipi_comm_invoice a, 
	                        gipi_wpolbas b, gipi_polbasic c                             
	                  Where b.par_id = p_par_id 
	                    and b.line_cd = c.line_cd 
	                    and b.subline_cd = c.subline_cd 
	                    and b.iss_cd = c.iss_cd 
	                    and b.issue_yy = c.issue_yy 
	                    and b.pol_seq_no = c.pol_seq_no
	                    and b.renew_no=c.renew_no 
	                    and c.policy_id = a.policy_id;
	        
	                  FOR V1 IN (select a.intrmdry_intm_no 
	                               from gipi_comm_invoice a, 
	                                    gipi_wpolbas b, gipi_polbasic c                             
	                              Where b.par_id = p_par_id 
	                                and b.line_cd = c.line_cd 
	                                and b.subline_cd = c.subline_cd 
	                                and b.iss_cd = c.iss_cd 
	                                and b.issue_yy = c.issue_yy 
	                                and b.pol_seq_no = c.pol_seq_no
	                                and b.renew_no=c.renew_no 
	                                and c.policy_id = a.policy_id) 
	                  LOOP
	                     IF v_wcominv_intm_no IS NOT NULL AND V1.INTRMDRY_INTM_NO=v_wcominv_intm_no THEN
	                          p_v_lov_tag := 'FILTERED';
	                          p_v_wcominv_intm_no_lov := 'cgfk$wcominvDspIntmName3';
	                     ELSIF v_wcominv_intm_no IS NOT NULL AND V1.INTRMDRY_INTM_NO!=v_wcominv_intm_no THEN
	                        p_v_lov_tag := 'UNFILTERED';
	                        p_v_wcominv_intm_no_lov := 'cgfk$wcominvDspIntmName5';          
	                     END IF;            
	                  END LOOP;      
	                EXCEPTION
	                    WHEN NO_DATA_FOUND THEN
	                          p_v_lov_tag := 'UNFILTERED';
	                           p_v_wcominv_intm_no_lov := 'cgfk$wcominvDspIntmName5';              
	                  WHEN TOO_MANY_ROWS THEN
	                       p_v_lov_tag := 'FILTERED';
	                       p_v_wcominv_intm_no_lov := 'cgfk$wcominvDspIntmName3';
	                END;
				ELSE
					BEGIN
	                  select a.intrmdry_intm_no
	                    into dummy2 
	                   from gipi_comm_invoice a, 
	                        gipi_wpolbas b, gipi_polbasic c                             
	                  Where b.par_id IN (SELECT DISTINCT par_id
					 	   			   	   FROM gipi_parlist b240
										  WHERE b240.pack_par_id = p_par_id)
	                    and b.line_cd = c.line_cd 
	                    and b.subline_cd = c.subline_cd 
	                    and b.iss_cd = c.iss_cd 
	                    and b.issue_yy = c.issue_yy 
	                    and b.pol_seq_no = c.pol_seq_no
	                    and b.renew_no=c.renew_no 
	                    and c.policy_id = a.policy_id;
	        
	                  FOR V1 IN (select a.intrmdry_intm_no 
	                               from gipi_comm_invoice a, 
	                                    gipi_wpolbas b, gipi_polbasic c                             
	                              Where b.par_id IN (SELECT DISTINCT par_id
						 	   			   	  	 	   FROM gipi_parlist b240
											 		  WHERE b240.pack_par_id = p_par_id)
	                                and b.line_cd = c.line_cd 
	                                and b.subline_cd = c.subline_cd 
	                                and b.iss_cd = c.iss_cd 
	                                and b.issue_yy = c.issue_yy 
	                                and b.pol_seq_no = c.pol_seq_no
	                                and b.renew_no=c.renew_no 
	                                and c.policy_id = a.policy_id) 
	                  LOOP
	                     IF v_wcominv_intm_no IS NOT NULL AND V1.INTRMDRY_INTM_NO=v_wcominv_intm_no THEN
	                          p_v_lov_tag := 'FILTERED';
	                          p_v_wcominv_intm_no_lov := 'cgfk$wcominvDspIntmName3';
	                     ELSIF v_wcominv_intm_no IS NOT NULL AND V1.INTRMDRY_INTM_NO!=v_wcominv_intm_no THEN
	                        p_v_lov_tag := 'UNFILTERED';
	                        p_v_wcominv_intm_no_lov := 'cgfk$wcominvDspIntmName5';          
	                     END IF;            
	                  END LOOP;      
	                EXCEPTION
	                    WHEN NO_DATA_FOUND THEN
	                          p_v_lov_tag := 'UNFILTERED';
	                           p_v_wcominv_intm_no_lov := 'cgfk$wcominvDspIntmName5';              
	                  WHEN TOO_MANY_ROWS THEN
	                       p_v_lov_tag := 'FILTERED';
	                       p_v_wcominv_intm_no_lov := 'cgfk$wcominvDspIntmName3';
	                END;
				END IF;
            
            --Added by Apollo Cruz 11.13.2014
                IF NVL(p_is_package, 'N') = 'N' THEN
                   GIPIS085_DEFAULT_INTRMDRY(p_par_id, p_intm_no, p_dsp_intm_name, p_parent_intm_no);
				    ELSE
					    GIPIS085_PACK_DEFAULT_INTRMDRY(p_par_id, p_intm_no, p_dsp_intm_name, p_parent_intm_no);
					 END IF; 
            
              EXCEPTION  
                WHEN no_data_found THEN
					 IF NVL(p_is_package, 'N') = 'N' THEN
	                     FOR V1 IN(select distinct a.intrmdry_intm_no 
	                                 from gipi_comm_invoice a, 
	                                      gipi_wpolbas b, 
	                                      gipi_polbasic c                             
	                                Where b.par_id = p_par_id 
	                                  and b.line_cd = c.line_cd 
	                                  and b.subline_cd = c.subline_cd 
	                                  and b.iss_cd = c.iss_cd 
	                                  and b.issue_yy = c.issue_yy 
	                                  and b.pol_seq_no = c.pol_seq_no
	                                  and b.renew_no=c.renew_no 
	                                  and c.policy_id = a.policy_id
	                                  and a.policy_id = nvl(b.cancelled_endt_id,c.policy_id))
	                     LOOP
	                       CTR:=CTR+1;
	                     END LOOP;
					 ELSE
					 	 FOR V1 IN(select distinct a.intrmdry_intm_no 
	                                 from gipi_comm_invoice a, 
	                                      gipi_wpolbas b, 
	                                      gipi_polbasic c                             
	                                Where b.par_id IN (SELECT DISTINCT par_id
						 	   			   	  	 	     FROM gipi_parlist b240
											 		    WHERE b240.pack_par_id = p_par_id)
	                                  and b.line_cd = c.line_cd 
	                                  and b.subline_cd = c.subline_cd 
	                                  and b.iss_cd = c.iss_cd 
	                                  and b.issue_yy = c.issue_yy 
	                                  and b.pol_seq_no = c.pol_seq_no
	                                  and b.renew_no=c.renew_no 
	                                  and c.policy_id = a.policy_id
	                                  and a.policy_id = nvl(b.cancelled_endt_id,c.policy_id))
	                     LOOP
	                       CTR:=CTR+1;
	                     END LOOP;
					 END IF;
					 
                     IF CTR>1 THEN 
                        p_v_lov_tag := 'FILTERED';
                        p_v_wcominv_intm_no_lov := 'cgfk$wcominvDspIntmName3';
                     ELSIF CTR=1 THEN 
                         --  DEFAULT_INTRMDRY;
                        IF NVL(p_is_package, 'N') = 'N' THEN
                            GIPIS085_DEFAULT_INTRMDRY(p_par_id, p_intm_no, p_dsp_intm_name, p_parent_intm_no);
						ELSE
							GIPIS085_PACK_DEFAULT_INTRMDRY(p_par_id, p_intm_no, p_dsp_intm_name, p_parent_intm_no);
						END IF;
                        
                        -- get parent_intm_name
                        p_parent_intm_name := NULL;
                        
                        IF p_parent_intm_no IS NULL THEN
                           p_parent_intm_no := p_intm_no;
                        END IF;
                                            
                        FOR intm IN (SELECT intm_name
                                       FROM giis_intermediary
                                      WHERE intm_no = p_parent_intm_no)
                        LOOP
                            p_parent_intm_name := intm.intm_name;
                        END LOOP;
                        
                        IF p_parent_intm_name IS NULL THEN
                           p_parent_intm_name := p_dsp_intm_name;
                        END IF;                    
                        
                     ELSIF CTR = 0 THEN
                          p_var_param_req_def_intm := giac_parameters_pkg.v('REQ_DEF_INTM');  
                           IF p_var_param_req_def_intm = 'Y' THEN 
                                  --p_msg_alert := 'There is no default intermediary for this assured.';
                             p_msg_alert := 'NO_DEFAULT_INTM';                                                                                                   
                                p_v_lov_tag := 'UNFILTERED';                                                   
                           ELSE
                           p_v_lov_tag := 'UNFILTERED';
                             p_v_wcominv_intm_no_lov := 'cgfk$wcominvDspIntmName5';      
                           END IF;
                     END IF;          
                   when too_many_rows then
				   	 IF NVL(p_is_package, 'N') = 'N' THEN
	                     FOR V1 IN (select a.intrmdry_intm_no 
	                                  from gipi_comm_invoice a, 
	                                       gipi_wpolbas b, gipi_polbasic c                             
	                                 Where b.par_id = p_par_id 
	                                   and b.line_cd = c.line_cd 
	                                   and b.subline_cd = c.subline_cd 
	                                   and b.iss_cd = c.iss_cd 
	                                   and b.issue_yy = c.issue_yy 
	                                   and b.pol_seq_no = c.pol_seq_no
	                                   and b.renew_no=c.renew_no 
	                                   and c.policy_id = a.policy_id) 
	                     LOOP
	                        IF v_wcominv_intm_no IS NOT NULL AND V1.INTRMDRY_INTM_NO=v_wcominv_intm_no THEN
	                             p_v_lov_tag := 'FILTERED';
	                                p_v_wcominv_intm_no_lov := 'cgfk$wcominvDspIntmName3';
	                        ELSIF v_wcominv_intm_no IS NOT NULL AND DUMMY2!=v_wcominv_intm_no THEN
	                           p_v_lov_tag := 'UNFILTERED';
	                             p_v_wcominv_intm_no_lov := 'cgfk$wcominvDspIntmName5';   
	                        END IF;            
	                     END LOOP;
					  ELSE
					  	 FOR V1 IN (select a.intrmdry_intm_no 
	                                  from gipi_comm_invoice a, 
	                                       gipi_wpolbas b, gipi_polbasic c                             
	                                 Where b.par_id IN (SELECT DISTINCT par_id
						 	   			   	  	 	      FROM gipi_parlist b240
											 		     WHERE b240.pack_par_id = p_par_id)
	                                   and b.line_cd = c.line_cd 
	                                   and b.subline_cd = c.subline_cd 
	                                   and b.iss_cd = c.iss_cd 
	                                   and b.issue_yy = c.issue_yy 
	                                   and b.pol_seq_no = c.pol_seq_no
	                                   and b.renew_no=c.renew_no 
	                                   and c.policy_id = a.policy_id) 
	                     LOOP
	                        IF v_wcominv_intm_no IS NOT NULL AND V1.INTRMDRY_INTM_NO=v_wcominv_intm_no THEN
	                             p_v_lov_tag := 'FILTERED';
	                                p_v_wcominv_intm_no_lov := 'cgfk$wcominvDspIntmName3';
	                        ELSIF v_wcominv_intm_no IS NOT NULL AND DUMMY2!=v_wcominv_intm_no THEN
	                           p_v_lov_tag := 'UNFILTERED';
	                             p_v_wcominv_intm_no_lov := 'cgfk$wcominvDspIntmName5';   
	                        END IF;            
	                     END LOOP;
					  END IF;  
               END;
           END IF;
           
           p_dsp_intm_name := ESCAPE_VALUE(p_dsp_intm_name);
           p_parent_intm_name := ESCAPE_VALUE(p_parent_intm_name);
        END;

        /* benjo 09.07.2016 SR-5604 */
        BEGIN
           SELECT intm_no
             INTO p_dflt_intm_no
             FROM giis_assured_intm
            WHERE assd_no = v_b240_assd_no AND line_cd = v_b240_line_cd;
        EXCEPTION
           WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
           THEN
              p_dflt_intm_no := NULL;
        END;
           
        /* End of GET_DEFAULT_ASSURED_INTM */
        
        BEGIN
             p_v_ora2010_sw := giis_parameters_pkg.v('ORA2010_SW');
			 IF NVL(p_is_package, 'N') = 'N' THEN
			 	p_v_validate_banca := BANCASSURANCE.validate_bancassurance(p_par_id);
			 ELSE
			 	p_v_validate_banca := BANCASSURANCE.validate_pack_bancassurance(p_par_id);
			 END IF;
        EXCEPTION
             WHEN NO_DATA_FOUND THEN
                   NULL;
        END;
        
        BEGIN
			IF NVL(p_is_package, 'N') = 'N' THEN
	            SELECT banc_type_cd
	              INTO v_banc_type_cd 
	              FROM GIPI_WPOLBAS 
	             WHERE par_id = p_par_id;
			END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                 NULL;
        END;
    
        BEGIN
             IF p_v_ora2010_sw = 'Y' AND p_v_validate_banca = 'Y' THEN
                IF v_wcominv_intm_no IS NULL THEN
                   --p_message := 'This is a bancassurance record. Please check the list of intermediaries.');
                   p_bancassurance_rec := 'Y';
                    /*IF ALERT_BUTTON = alert_button1    THEN                             
                       animate_popup('BANC_WINDOW', 'Bancassurance', 'BANC_CANVAS', 'BANCA','show');   
                    END IF*/
                END IF;
                
            ELSE
                --set_item_property('BANCA_B.banca_but',visible, property_FALSE);
                p_banca_btn_enabled := 'N';    
            END IF;
        END; --end
        
        p_var_banc_rate_sw := 'N';
        BEGIN --for new bancassurance checkbox and button
             IF p_v_ora2010_sw = 'Y' THEN
                  --set_item_property('WCOMINV.banca_check',visible, property_true);
                 --set_item_property('BANCA_B.banca_but',visible, property_true);
                  p_banca_check_enabled := 'Y';
                  p_banca_btn_enabled := 'Y';
             ELSE
                     --set_item_property('WCOMINV.banca_check',visible, property_FALSE);
                 --set_item_property('BANCA_B.banca_but',visible, property_FALSE);
                 p_banca_check_enabled := 'N';
                 p_banca_btn_enabled := 'N';
             END IF;
        END;
        
        -- get par_type and endt_tax
		IF NVL(p_is_package, 'N') = 'N' THEN
	        FOR tp IN (
	          SELECT par_type
	              FROM gipi_parlist
	             WHERE par_id = p_par_id)
	          LOOP 
	            p_v_par_type := tp.par_type;
	        END LOOP;
		ELSE
			FOR tp IN (
	          SELECT par_type
	              FROM gipi_parlist
	             WHERE pack_par_id = p_par_id)
	          LOOP 
	            p_v_par_type := tp.par_type;
	        END LOOP;
		END IF;
		
		IF NVL(p_is_package, 'N') = 'N' THEN
	        FOR endttax IN (
	            SELECT endt_tax    
	              FROM gipi_wendttext
	             WHERE par_id = p_par_id)
	        LOOP
	           p_v_endt_tax := endttax.endt_tax;
	        END LOOP;
		ELSE
			FOR endttax IN (
	            SELECT endt_tax    
	              FROM gipi_wendttext
	             WHERE par_id IN (SELECT DISTINCT par_id
	   			   	  	 	        FROM gipi_parlist b240
				 		     	   WHERE b240.pack_par_id = p_par_id))
	        LOOP
	           p_v_endt_tax := endttax.endt_tax;
	        END LOOP;
		END IF;
        
        DECLARE
                v_partype    GIPI_parlist.par_type%type;
                v_pol_flag    gipi_wpolbas.pol_flag%type;
        BEGIN
			IF NVL(p_is_package, 'N') = 'N' THEN
	            BEGIN
	                SELECT par_type
	                  INTO v_partype
	                  FROM gipi_parlist
	                 WHERE par_id = p_par_id;
	            END;
	            BEGIN
	                SELECT pol_flag
	                  INTO v_pol_flag
	                  FROM gipi_wpolbas
	                 WHERE par_id = p_par_id;
	            END;
			ELSE
				BEGIN
	                SELECT par_type
	                  INTO v_partype
	                  FROM gipi_parlist
	                 WHERE pack_par_id = p_par_id
					   AND ROWNUM = 1;
	            END;
	            BEGIN
	                SELECT pol_flag
	                  INTO v_pol_flag
	                  FROM gipi_pack_wpolbas -- replace by steven from: gipi_wpolbas  to: gipi_pack_wpolbas
	                 WHERE pack_par_id = p_par_id;
					   --AND ROWNUM = 1;
	            END;
			END IF;
			
            IF v_partype = 'E' THEN
                IF v_pol_flag = 4 or nvl(p_global_cancel_tag, 'N') = 'Y' THEN
                    /*-- mark jm 01.05.09 to allow updates based on enabled property starts here */    
                    --msg_alert('This is a cancellation type of endorsement, update/s of any details will not be allowed.', 'W', FALSE);
                    p_cancellation_type := 'Y';
                END IF;
            END IF;
            
			IF NVL(p_is_package, 'N') = 'N' THEN
	            OPEN p_banc_type FOR
	              SELECT banc_type_cd, banc_type_desc, rate, user_id, last_update
	                FROM GIIS_BANC_TYPE
	               WHERE banc_type_cd = NVL(v_banc_type_cd, '');
	               
	            OPEN p_banc_type_dtl_list FOR
	              SELECT a.item_no, a.intm_no, b.intm_name, a.intm_type, a.fixed_tag, a.banc_type_cd, c.intm_desc intm_type_desc, a.share_percentage,
	                          d.intm_no parent_intm_no, d.intm_name parent_intm_name
	                  FROM GIIS_BANC_TYPE_DTL a, GIIS_INTERMEDIARY b, GIIS_INTM_TYPE c, GIIS_INTERMEDIARY d
	               WHERE a.banc_type_cd = NVL(v_banc_type_cd, '')
	                 AND a.intm_no = b.intm_no (+) --apollo cruz 09.09.2014 added (+) to show records with no intermediary
	                 AND a.intm_type = c.intm_type
	                 AND b.parent_intm_no = d.intm_no (+)
	            ORDER BY a.intm_no;
			ELSE
				OPEN p_banc_type FOR
	              SELECT banc_type_cd, banc_type_desc, rate, user_id, last_update
	                FROM GIIS_BANC_TYPE
	               WHERE banc_type_cd IN (SELECT DISTINCT NVL(banc_type_cd, '') 
							              FROM GIPI_WPOLBAS 
							             WHERE par_id IN (SELECT DISTINCT par_id
							   			   	  	 	        FROM gipi_parlist b240
										 		     	   WHERE b240.pack_par_id = p_par_id));
	               
	            OPEN p_banc_type_dtl_list FOR
	              SELECT a.item_no, a.intm_no, b.intm_name, a.intm_type, a.fixed_tag, a.banc_type_cd, c.intm_desc intm_type_desc, a.share_percentage,
	                          d.intm_no parent_intm_no, d.intm_name parent_intm_name
	                  FROM GIIS_BANC_TYPE_DTL a, GIIS_INTERMEDIARY b, GIIS_INTM_TYPE c, GIIS_INTERMEDIARY d
	               WHERE a.banc_type_cd IN (SELECT NVL(banc_type_cd, '') 
								              FROM GIPI_WPOLBAS 
								             WHERE par_id IN (SELECT DISTINCT par_id
								   			   	  	 	        FROM gipi_parlist b240
											 		     	   WHERE b240.pack_par_id = p_par_id))
	                 AND a.intm_no = b.intm_no
	                 AND a.intm_type = c.intm_type
	                 AND b.parent_intm_no = d.intm_no (+)
	            ORDER BY a.intm_no;
			END IF;
            
            -- other variables
            p_v_gipi_wpolnrep_exist := 'N';
			
			IF NVL(p_is_package, 'N') = 'N' THEN
	            FOR a IN (SELECT 1 
	                        FROM GIPI_WPOLNREP
	                       WHERE par_id = p_par_id)
	            LOOP
	              p_v_gipi_wpolnrep_exist := 'Y';
	            END LOOP;
			ELSE
				FOR a IN (SELECT 1 
	                        FROM GIPI_WPOLNREP
	                       WHERE par_id IN (SELECT DISTINCT par_id
	   			   	  	 	                  FROM gipi_parlist b240
				 		     	       		 WHERE b240.pack_par_id = p_par_id))
	            LOOP
	              p_v_gipi_wpolnrep_exist := 'Y';
	            END LOOP;
			END IF;
            
            -- other variables (for enhancement)
            BEGIN
                SELECT GIIS_PARAMETERS_PKG.v('OVERRIDE_COMM_WHTAX')
                  INTO p_var_override_whtax
                  FROM DUAL;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                     NULL;
            END;
              
            BEGIN
                SELECT comm_update_tag
                  INTO p_var_v_comm_update_tag   
                  FROM giis_users
                   WHERE USER_ID = NVL(giis_users_pkg.app_user, USER);
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                     NULL;
            END;
             
             FOR i IN (SELECT PARAM_VALUE_V
                         FROM giac_parameters
                        WHERE param_name = 'SHOW_COMM_AMT')
             LOOP
                p_var_v_param_show_comm := i.param_value_v;
             END LOOP;
              
             BEGIN
                   SELECT Giisp.v('ALLOW_APPLY_SLIDING_COMM')
                    INTO p_v_allow_apply_sl_comm
                    FROM DUAL;
             EXCEPTION
                WHEN NO_DATA_FOUND THEN
                     NULL;
             END;
        END;
        
        --Apollo Cruz 10.10.2014
        BEGIN
           SELECT 'Y'
             INTO p_coinsurer_sw
             FROM gipi_main_co_ins
            WHERE par_id = p_par_id; 
        EXCEPTION WHEN NO_DATA_FOUND THEN
           p_coinsurer_sw := 'N';    
        END;
        
        /* benjo 09.07.2016 SR-5604 */
        BEGIN
            SELECT NVL(giisp.v('REQUIRE_DEFAULT_INTM_PER_ASSURED'),'N'),
                   NVL(giisp.v('ALLOW_UPDATE_DEF_INTM_PER_ASSURED'),'N')
              INTO p_req_dflt_intm_per_assd,
                   p_allow_upd_intm_per_assd
              FROM DUAL;
        EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;
        END;
        
    END gipis085_new_form_instance;
    
    PROCEDURE validate_gipis085_intm_no(p_par_id                        IN       GIPI_WCOMM_INVOICES.par_id%TYPE,
                                          p_intm_no                    IN     GIPI_WCOMM_INVOICES.intrmdry_intm_no%TYPE,
                                          p_nbt_intm_type                IN OUT GIIS_INTERMEDIARY.intm_type%TYPE,
                                          p_assd_no                    IN        GIPI_PARLIST.assd_no%TYPE,
                                        p_line_cd                    IN       GIPI_PARLIST.line_cd%TYPE,
                                        p_par_type                    IN       GIPI_PARLIST.par_type%TYPE,
                                        p_drv_par_seq_no            IN       VARCHAR2,
                                        p_v_lov_tag                    IN OUT VARCHAR2,
                                        p_iss_name                       OUT GIIS_ISSOURCE.iss_name%TYPE,
                                        p_msg_alert                       OUT VARCHAR2)
    IS
        /*
        **  Created by   :  Emman
        **  Date Created :  01.12.2011
        **  Reference By : (Gipis085 - Invoice Commission)
          **  Description  : Executes the WHEN-VALIDATE-ITEM trigger of WCOMINV.INTRMDRY_INTM_NO in GIPIS085
        **                   This is going to replace the INTM_NO_WHEN_VALIDATE_ITEM procedure in GIPI_WCOMM_INVOICES_PKG
          */
        v_var_iss_cd       GIIS_INTERMEDIARY.iss_cd%TYPE;
        v_pol_flag         gipi_wpolbas.pol_flag%TYPE;
    BEGIN
        p_msg_alert := 'SUCCESS';
        
        BEGIN
           SELECT pol_flag
             INTO v_pol_flag
             FROM gipi_wpolbas
            WHERE par_id = p_par_id;
        END;
        
        BEGIN
        DECLARE
          var_co_intm_type     giis_intermediary.co_intm_type%TYPE;
        BEGIN
          BEGIN
            -- modified 7/31/99 by rma
            SELECT intm_type, iss_cd  
              INTO var_co_intm_type, v_var_iss_cd  
              FROM giis_intermediary 
             WHERE intm_no = p_intm_no;
          EXCEPTION 
              WHEN no_data_found THEN
                NULL;
          END;
    
          IF (p_nbt_intm_type  <> var_co_intm_type) OR
               (p_nbt_intm_type IS NULL) THEN
               p_nbt_intm_type  := var_co_intm_type ;  
          END IF;
        END;
      END;
    
        DECLARE
            CHK                  BOOLEAN := FALSE;
            ALERT_BUTTON         NUMBER;
            isscd                GIIS_INTERMEDIARY.iss_cd%TYPE;
            PARAMV               GIAC_PARAMETERS.PARAM_VALUE_V%TYPE;
            MERON                BOOLEAN := FALSE;
        BEGIN
            --(1)checks if value entered is included in LOV
              IF p_intm_no IS NOT NULL THEN
                   FOR C IN (SELECT intm_no intrmdry_intm_no
                                             FROM giis_intermediary 
                                            WHERE intm_no IN ( SELECT intm_no
                                                     FROM giis_assured_intm A
                                                    WHERE A.assd_no = p_assd_no
                                                           AND p_line_cd = line_cd)
                                                               ORDER BY intm_no)
                 LOOP
                         IF C.intrmdry_intm_no = p_intm_no THEN
                                MERON := TRUE;
                         END IF;
                      END LOOP;
                     IF NOT MERON AND p_v_lov_tag = 'FILTERED' AND p_par_type = 'P' AND v_pol_flag <> 2 THEN --modified by Apollo Cruz 11.17.2014 - added pol_flag    
                        p_msg_alert := 'INTNO_NOT_IN_LOV';
                     END IF;
                END IF;
                SELECT PARAM_VALUE_V 
                    INTO PARAMV
                    FROM GIAC_PARAMETERS
                 WHERE PARAM_NAME = 'CHECK_ISS_CD';
    
              IF UPPER(PARAMV) = 'Y' AND 
                   p_intm_no IS NOT NULL THEN
                     FOR CUR IN (SELECT ISS_CD ICODE
                                               FROM GIIS_INTERMEDIARY 
                                              WHERE INTM_NO = p_intm_no)
                     LOOP
                          isscd := CUR.ICODE; 
                         IF SUBSTR(p_drv_par_seq_no,6,2) = CUR.ICODE THEN
                                CHK := TRUE;
                         END IF;
                     END LOOP;
                     IF CHK = FALSE THEN
                            SELECT iss_name 
                              INTO p_iss_name 
                                FROM giis_issource
                             WHERE iss_cd = isscd;
                              /*p_msg_alert := 'The issuing source of this intermediary is '||iname||'. Do you want to continue?'; 
                                ALERT_BUTTON := SHOW_ALERT('ISS_CD_NOT_MATCH');
                                IF ALERT_BUTTON = alert_button2    THEN
                                     p_intm_no := NULL;
                                     :WCOMINV.DSP_INTM_NAME := NULL;
                                     :WCOMINV.DSP_PARENT_INTM_NO := NULL;
                                     :WCOMINV.DSP_PARENT_INTM_NAME := NULL;
                                     p_v_lov_tag := 'FILTERED';
                                END IF;*/    
                             p_msg_alert := 'ISS_CD_NOT_MATCH'; 
                     END IF;
              END IF;
        END;
        -- grace 01-27-2003
        -- to populate crediting branch
        DECLARE
            var       VARCHAR2(20);
        BEGIN  
            FOR param IN (SELECT param_value_v
                            FROM giis_parameters
                           WHERE param_name = 'DEFAULT_CRED_BRANCH')
            LOOP 
                var := param.param_value_v;
                EXIT;
            END LOOP;
            IF var = 'AGENT' THEN
               IF p_intm_no IS NOT NULL THEN
                           UPDATE gipi_wpolbas
                             SET cred_branch = v_var_iss_cd
                            WHERE par_id = p_par_id; 
               END IF;         
          END IF;
        END;
    END validate_gipis085_intm_no;
    
    PROCEDURE populate_wcomm_inv_perils2(p_par_id                IN        GIPI_PARLIST.par_id%TYPE,
                                           p_item_grp                IN       GIPI_WCOMM_INVOICES.item_grp%TYPE,
                                           p_takeup_seq_no        IN       GIPI_WCOMM_INVOICES.takeup_seq_no%TYPE,
                                         p_line_cd                IN       GIPI_PARLIST.line_cd%TYPE,
                                           p_gipi_winvperl_list       OUT GIPI_WCOMM_INVOICES_PKG.gipi_winvperl_cur)
    IS
    BEGIN
         BEGIN
            OPEN p_gipi_winvperl_list FOR
                  SELECT a.peril_cd, a.prem_amt, b.peril_name
                   FROM gipi_winvperl a, giis_peril b
                  WHERE a.par_id = p_par_id
                    AND a.item_grp = p_item_grp
                    AND a.takeup_seq_no = p_takeup_seq_no
                    AND a.peril_cd = b.peril_cd (+)
                    AND b.line_cd = p_line_cd;
         EXCEPTION
             WHEN NO_DATA_FOUND THEN
                 NULL;
         END;
    END populate_wcomm_inv_perils2;
    
    PROCEDURE POPULATE_GIPI_WCOMM_INV_DTL(p_par_id                    GIPI_WCOMM_INVOICES.par_id%TYPE,
                                            p_item_grp                GIPI_WCOMM_INVOICES.item_grp%TYPE,
                                          p_takeup_seq_no            GIPI_WCOMM_INVOICES.takeup_seq_no%TYPE,
                                          p_intm_no                    GIPI_WCOMM_INVOICES.intrmdry_intm_no%TYPE)
    IS
      v_premium_amt           gipi_wcomm_inv_perils.premium_amt%type := 0;  
      v_commission_amt        gipi_wcomm_inv_perils.commission_amt%type := 0;
      v_wholding_tax          gipi_wcomm_inv_perils.wholding_tax%type := 0;
      v_total_premium_amt     gipi_comm_inv_dtl.premium_amt%type := 0;  
      v_total_commission_amt  gipi_comm_inv_dtl.commission_amt%type := 0;
      v_total_wholding_tax    gipi_comm_inv_dtl.wholding_tax%type := 0;
      v_var_tax_amt              gipi_wcomm_inv_perils.wholding_tax%TYPE := 0;
    BEGIN
        BEGIN
          SELECT wtax_rate
            INTO v_var_tax_amt 
            FROM giis_intermediary 
           WHERE intm_no = p_intm_no;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
                 v_var_tax_amt := 0;
        END;
        
        FOR c1 IN (SELECT takeup_seq_no, item_grp, par_id, intrmdry_intm_no, parent_intm_no, share_percentage
                     FROM gipi_wcomm_invoices
                    WHERE 1=1              
                      AND item_grp = p_item_grp
                      AND par_id = p_par_id
                      AND takeup_seq_no = p_takeup_seq_no
					  AND intrmdry_intm_no = P_INTM_NO
					  )
        LOOP
          v_total_premium_amt := 0;
          v_total_commission_amt := 0;
          v_total_wholding_tax := 0;
          FOR c2 IN (SELECT peril_cd, premium_amt, commission_amt, wholding_tax
                       FROM gipi_wcomm_inv_perils
                       WHERE item_grp = c1.item_grp 
                         AND par_id = c1.par_id 
                         AND takeup_seq_no = c1.takeup_seq_no
                         AND intrmdry_intm_no = c1.intrmdry_intm_no)
          LOOP
            v_premium_amt    := NVL(c2.premium_amt,0);    
               IF c2.commission_amt = 0 THEN --issa02.18.2008 added condition to solve prf SEICI 1373 and 1560
                   v_commission_amt := 0; --if comm_amt of child = 0, parent's comm should also be 0
               ELSE
                   v_commission_amt := (nvl(c2.commission_amt,0)-(NVL(c2.premium_amt,0) * (GET_ADJUST_INTRMDRY_RATE(c1.intrmdry_intm_no, c1.par_id,c2.peril_cd)/100)));
               END IF; --end i--
              v_wholding_tax := ROUND (NVL (v_commission_amt, 0),2) * NVL (v_var_tax_amt, 0) / 100;      
               v_total_premium_amt := NVL(v_total_premium_amt,0) + v_premium_amt;
               v_total_commission_amt := NVL(v_total_commission_amt,0) + v_commission_amt;
               v_total_wholding_tax := NVL(v_total_wholding_tax,0) + v_wholding_tax;       
          END LOOP;                 
          FOR c3 IN (SELECT 1 
                       FROM giis_intermediary
                      WHERE intm_no = p_intm_no
                          AND lic_tag = 'N'
                              AND intm_no <> parent_intm_no)
          LOOP
            GIPI_WCOMM_INVOICES_PKG.DEL_INS_GIPI_WCOMM_INV_DTL(c1.item_grp, c1.par_id, c1.intrmdry_intm_no, c1.parent_intm_no, c1.share_percentage, v_total_premium_amt,v_total_commission_amt, v_total_wholding_tax, c1.takeup_seq_no); -- glyza 09.04.08 add parameter takeup_seq_no
          END LOOP;  
        END LOOP;        
        
        -- andrew - 05.16.2011 - to update the par_status to 6
        UPDATE gipi_parlist
           SET par_status = 6
         WHERE par_id = p_par_id;
                       
    END POPULATE_GIPI_WCOMM_INV_DTL;
    
    PROCEDURE DEL_INS_GIPI_WCOMM_INV_DTL(p_item_grp          gipi_wcomm_inv_dtl.item_grp%type, 
                                         p_par_id            gipi_wcomm_inv_dtl.par_id%type,
                                         p_intrmdry_intm_no  gipi_wcomm_inv_dtl.intrmdry_intm_no%type, 
                                         p_parent_intm_no    gipi_wcomm_inv_dtl.parent_intm_no%type,
                                         p_share_percentage  gipi_wcomm_inv_dtl.share_percentage%type,
                                         p_premium_amt       gipi_wcomm_inv_dtl.premium_amt%type,
                                         p_commission_amt    gipi_wcomm_inv_dtl.commission_amt%type,
                                         p_wholding_tax      gipi_wcomm_inv_dtl.wholding_tax%type,
                                         p_takeup_seq_no     gipi_wcomm_inv_dtl.takeup_seq_no%type)
    IS
    BEGIN
      GIPI_WCOMM_INV_DTL_PKG.del_gipi_wcomm_inv_dtl2(p_par_id, p_item_grp, p_intrmdry_intm_no, p_takeup_seq_no);
                        
      INSERT INTO gipi_wcomm_inv_dtl(item_grp, par_id, intrmdry_intm_no, 
                                     share_percentage, premium_amt, commission_amt, 
                                     wholding_tax, parent_intm_no, takeup_seq_no)
                              VALUES(p_item_grp, p_par_id, p_intrmdry_intm_no, 
                                     p_share_percentage, p_premium_amt, p_commission_amt, 
                                     p_wholding_tax, p_parent_intm_no, p_takeup_seq_no);
    END DEL_INS_GIPI_WCOMM_INV_DTL;
    
    /*
    **  Created by        : Veronica V. Raymundo
    **  Date Created     : 05.04.2011
    **  Reference By     : (GIPIS154 - Lead Policy Information)
    **  Description     : Gets premium_amt, commission_amt, share_percentage
    **                    and wholdin_tax from GIPI_WCOMM_INV table
    */

    PROCEDURE get_gipi_wcomm_inv_amt_columns
    (p_par_id       IN      GIPI_WCOMM_INVOICES.par_id%TYPE,
     p_item_grp     IN      GIPI_WCOMM_INVOICES.item_grp%TYPE,
     p_intm_no      IN      GIPI_WCOMM_INVOICES.intrmdry_intm_no%TYPE,
     p_prem_amt     OUT     GIPI_WCOMM_INVOICES.premium_amt%TYPE,
     p_comm_amt     OUT     GIPI_WCOMM_INVOICES.commission_amt%TYPE,
     p_share_pct    OUT     GIPI_WCOMM_INVOICES.share_percentage%TYPE,
     p_wholding_tax OUT     GIPI_WCOMM_INVOICES.wholding_tax%TYPE,
     p_net_comm     OUT     NUMBER)
     
     IS
     
    BEGIN
        FOR i IN (SELECT intrmdry_intm_no, share_percentage, 
                         premium_amt, commission_amt,
                         wholding_tax
                    FROM GIPI_WCOMM_INVOICES
                    WHERE par_id         = p_par_id
                    AND item_grp         = p_item_grp
                    AND intrmdry_intm_no = p_intm_no)
        LOOP
            p_prem_amt      := i.premium_amt;
            p_comm_amt      := i.commission_amt;
            p_share_pct     := i.share_percentage;
            p_wholding_tax  := i.wholding_tax;
            p_net_comm      := NVL(i.commission_amt,0) - NVL(i.wholding_tax,0);
            
            RETURN;
        END LOOP;
    END;
	
	
	/*
    **  Created by   :  Emman
    **  Date Created :  06.29.2011
    **  Reference By : (Gipis085 - Invoice Commission)
    **  Description  : Gets gipi_wcomm_invoices records based on pack_par_id, used for package
    */
	FUNCTION get_pack_gipi_wcomm_invoices (
        p_pack_par_id            GIPI_PARLIST.pack_par_id%TYPE)
    RETURN gipi_wcomm_invoices_tab PIPELINED 
    IS
    
    v_wcomm            gipi_wcomm_invoices_type;
    
    BEGIN
        FOR i IN (
            SELECT a.intrmdry_intm_no, b.intm_name,      b.parent_intm_no, nvl(c.intm_name, '') parent_intm_name,
                   a.share_percentage, a.takeup_seq_no,  a.item_grp,        a.par_id,
                   a.premium_amt,        a.commission_amt, a.wholding_tax,   a.commission_amt - a.wholding_tax net_commission  
              FROM GIPI_WCOMM_INVOICES a
                   ,GIIS_INTERMEDIARY b
                   ,GIIS_INTERMEDIARY c
             WHERE a.par_id IN (SELECT DISTINCT par_id
			 	   			   	  FROM gipi_parlist b240
								 WHERE b240.pack_par_id = p_pack_par_id)
               AND a.intrmdry_intm_no = b.intm_no
               AND b.parent_intm_no = c.intm_no (+))
        LOOP
            v_wcomm.intrmdry_intm_no        := i.intrmdry_intm_no;
            v_wcomm.intm_name                := i.intm_name;
            v_wcomm.parent_intm_no            := i.parent_intm_no;
            v_wcomm.parent_intm_name        := i.parent_intm_name;
            v_wcomm.share_percentage        := i.share_percentage;
            v_wcomm.takeup_seq_no            := i.takeup_seq_no;
            v_wcomm.item_grp                := i.item_grp;
            v_wcomm.par_id                    := i.par_id;
            v_wcomm.premium_amt                := i.premium_amt;
            v_wcomm.commission_amt            := i.commission_amt;
            v_wcomm.wholding_tax            := i.wholding_tax;
            v_wcomm.net_commission            := i.net_commission;
			BEGIN
            SELECT LIC_TAG, SPECIAL_RATE
              INTO v_wcomm.PARENT_INTM_LIC_TAG,
                   v_wcomm.PARENT_INTM_SPECIAL_RATE
              FROM GIIS_INTERMEDIARY
             WHERE INTM_NO = i.parent_intm_no;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_wcomm.PARENT_INTM_LIC_TAG := '';
               v_wcomm.PARENT_INTM_SPECIAL_RATE := '';
		   end;
        PIPE ROW(v_wcomm);
        END LOOP;
        RETURN;
    END get_pack_gipi_wcomm_invoices;
	
	FUNCTION get_pack_initial_vars(p_pack_par_id             IN  GIPI_PARLIST.pack_par_id%TYPE)
	RETURN gipis085_pack_var_tab PIPELINED
	IS
	  v_var						 gipis085_pack_var_type;
	  CTR						 NUMBER := 0;
	  v_param_req_def_intm		 GIAC_PARAMETERS.param_value_v%TYPE;
      v_intm_no                  giis_assured_intm.intm_no%TYPE; --benjo 09.14.2016 SR-5604
	BEGIN
         /* benjo 09.14.2016 SR-5604 */
         FOR gpp IN (SELECT assd_no, line_cd
                       FROM gipi_pack_parlist
                      WHERE pack_par_id = p_pack_par_id)
         LOOP
             FOR i IN (SELECT a.pack_par_id, a.par_id,
                               BANCASSURANCE.validate_bancassurance(a.par_id) validate_banca,
                               NVL(b.pol_flag, 1) pol_flag,
                               b.line_cd, b.subline_cd, a.assd_no, a.par_type
                         FROM GIPI_PARLIST a,  GIPI_WPOLBAS b
                        WHERE a.pack_par_id =  p_pack_par_id
                          AND b.par_id 		=  a.par_id)
             LOOP
                 v_var.pack_par_id			   			:= i.pack_par_id;
                 v_var.par_id							:= i.par_id;
                 v_var.v_validate_banca		  			:= i.validate_banca;
                 v_var.v_pol_flag						:= i.pol_flag;
                 v_var.line_cd							:= i.line_cd;
                 v_var.subline_cd						:= i.subline_cd;
                 v_var.assd_no							:= i.assd_no;
                 v_var.par_type							:= i.par_type;
    			 
                 IF i.pol_flag = '2' THEN
                     FOR intm IN (SELECT a.intrmdry_intm_no 
                                    FROM gipi_comm_invoice a, gipi_polbasic b, gipi_wpolnrep c
                                   WHERE c.par_id    IN (SELECT DISTINCT par_id
                                                           FROM gipi_parlist b240
                                                          WHERE b240.pack_par_id = p_pack_par_id)
                                                            AND b.policy_id = c.old_policy_id
                                                            AND b.policy_id = a.policy_id)
                     LOOP
                       CTR:=CTR+1;
                     END LOOP;
                 ELSE
                     /* benjo 09.14.2016 SR-5604 */
                     FOR V1 IN(SELECT INTM_NO
                                 FROM GIIS_ASSURED_INTM
                                WHERE ASSD_NO=gpp.assd_no
                                  AND LINE_cD=gpp.line_cd)
                     LOOP
                       CTR:=CTR+1;
                     END LOOP;
                 END IF;
    			 
                 IF CTR>1 THEN 
                        v_var.v_lov_tag := 'FILTERED';
                        v_var.v_wcominv_intm_no_lov := 'cgfk$wcominvDspIntmName';                                 
                 ELSIF CTR=1 THEN
                        --DEFAULT_INTRMDRY;
                        /*GIPIS085_PACK_DEFAULT_INTRMDRY(i.par_id, v_var.intm_no, v_var.intm_name, v_var.parent_intm_no); 
                        FOR c1 IN (SELECT b.intrmdry_intm_no, c.intm_name, c.parent_intm_no
                                     FROM gipi_wcomm_invoices b,
                                          gipi_parlist a,
                                          giis_intermediary c
                                   WHERE b.par_id = a.par_id
                                     AND intrmdry_intm_no IS NOT NULL
                                     AND c.intm_no (+) = b.intrmdry_intm_no
                                     AND pack_par_id = p_pack_par_id)
                        LOOP	 	 
                             v_var.intm_no          := c1.intrmdry_intm_no;
                             v_var.intm_name        := c1.intm_name;
                             v_var.parent_intm_no   := c1.parent_intm_no;
                        END LOOP;				
    							                    
                        -- get parent_intm_name
                        v_var.parent_intm_name := NULL;
    			                    
                        IF v_var.parent_intm_no IS NULL THEN
                           v_var.parent_intm_no := v_var.intm_no;
                        END IF;
    			                                        
                        FOR intm IN (SELECT intm_name
                                       FROM giis_intermediary
                                      WHERE intm_no = v_var.parent_intm_no)
                        LOOP
                            v_var.parent_intm_name := intm.intm_name;
                        END LOOP;
    	                    
                        IF v_var.parent_intm_name IS NULL THEN
                           v_var.parent_intm_name := v_var.intm_name;
                        END IF;*/
                        -- removed - default intermediary code added below (emman 08.23.2011)
                        NULL;
                 ELSIF CTR = 0 THEN           
                        v_param_req_def_intm := giac_parameters_pkg.v('REQ_DEF_INTM');
                        IF v_param_req_def_intm = 'Y' THEN
                           v_var.v_msg_alert := 'NO_DEFAULT_INTM';                             
                           v_var.v_lov_tag := 'UNFILTERED';
                           RETURN;
                        ELSE
                            v_var.v_lov_tag := 'UNFILTERED';
                            v_var.v_wcominv_intm_no_lov := 'cgfk$wcominvDspIntmName5';
                        END IF;
                 END IF;
                 
                /* benjo 09.14.2016 SR-5604 */
                IF i.pol_flag = '2' OR i.par_type = 'E' THEN
                    gipis085_default_intrmdry(i.par_id, v_var.intm_no, v_var.intm_name, v_var.parent_intm_no);
                END IF;
                
                FOR c1 IN (SELECT b.intrmdry_intm_no, c.intm_name, c.parent_intm_no
                             FROM gipi_wcomm_invoices b,
                                  gipi_parlist a,
                                  giis_intermediary c
                           WHERE b.par_id = a.par_id
                             AND intrmdry_intm_no IS NOT NULL
                             AND c.intm_no (+) = b.intrmdry_intm_no
                             AND pack_par_id = p_pack_par_id)
                LOOP	 	 
                     v_var.intm_no          := c1.intrmdry_intm_no;
                     v_var.intm_name        := c1.intm_name;
                     v_var.parent_intm_no   := c1.parent_intm_no;
                     
                    /* benjo 09.14.2016 SR-5604 */
                    BEGIN
                       SELECT intm_no
                         INTO v_intm_no
                         FROM giis_assured_intm
                        WHERE assd_no = gpp.assd_no AND line_cd = gpp.line_cd;

                       IF v_intm_no = c1.intrmdry_intm_no
                       THEN
                          v_var.v_lov_tag := 'FILTERED';
                          v_var.v_wcominv_intm_no_lov := 'cgfk$wcominvDspIntmName';
                       ELSE
                          v_var.v_lov_tag := 'UNFILTERED';
                          v_var.v_wcominv_intm_no_lov := 'cgfk$wcominvDspIntmName5';
                       END IF;
                    EXCEPTION
                       WHEN NO_DATA_FOUND
                       THEN
                          v_var.v_lov_tag := 'UNFILTERED';
                          v_var.v_wcominv_intm_no_lov := 'cgfk$wcominvDspIntmName5';
                       WHEN TOO_MANY_ROWS
                       THEN
                          v_var.v_lov_tag := 'FILTERED';
                          v_var.v_wcominv_intm_no_lov := 'cgfk$wcominvDspIntmName';
                    END;
                END LOOP;				
    							                    
                -- get parent_intm_name
                v_var.parent_intm_name := NULL;
    			                    
                IF v_var.parent_intm_no IS NULL THEN
                   v_var.parent_intm_no := v_var.intm_no;
                END IF;
    			                                        
                FOR intm IN (SELECT intm_name
                               FROM giis_intermediary
                              WHERE intm_no = v_var.parent_intm_no)
                LOOP
                    v_var.parent_intm_name := intm.intm_name;
                END LOOP;
    	                    
                IF v_var.parent_intm_name IS NULL THEN
                   v_var.parent_intm_name := v_var.intm_name;
                END IF;
    			 
                 v_var.intm_name		:= ESCAPE_VALUE(v_var.intm_name);
                 v_var.parent_intm_name := ESCAPE_VALUE(v_var.parent_intm_name);
    			 
                 PIPE ROW(v_var);
             END LOOP;
         END LOOP;
	END get_pack_initial_vars;
    
    /*
    **  Created by   :  Emman
    **  Date Created :  09.09.2011
    **  Reference By : (GIPIS160 - Endt Bond Invoice Commission)
    **  Description  : Executes the WHEN-NEW-FORM-INSTANCE trigger of GIPIS160, and loads the banc_type list
    */
    PROCEDURE gipis160_new_form_instance(p_par_id                IN     GIPI_PARLIST.par_id%TYPE,
                                         p_v_wcominv_intm_no_lov    OUT VARCHAR2,
                                         p_v_lov_tag                OUT VARCHAR2,
                                         p_v_pol_flag               OUT GIPI_WPOLBAS.pol_flag%TYPE,
                                         p_intm_no                  OUT gipi_wcomm_invoices.intrmdry_intm_no%TYPE, 
                                         p_dsp_intm_name            OUT VARCHAR2,
                                         p_parent_intm_no           OUT gipi_wcomm_invoices.parent_intm_no%TYPE,
                                         p_parent_intm_name         OUT VARCHAR2,
                                         p_var_param_req_def_intm   OUT VARCHAR2,
                                         p_var_override_whtax       OUT    GIIS_PARAMETERS.param_value_v%TYPE,
                                         p_v_ora2010_sw             OUT VARCHAR2,
                                         p_v_validate_banca         OUT VARCHAR2,
                                         p_v_allow_apply_sl_comm    OUT VARCHAR2,
                                         p_gipis160_b240            OUT GIPI_WCOMM_INVOICES_PKG.gipis085_b240_cur,
                                         p_gipis160_b450            OUT GIPI_WINVOICE_PKG.gipi_winvoice_cur,
                                         p_wcomm_inv_perils         OUT GIPI_WCOMM_INV_PERILS_PKG.gipi_wcomm_inv_perils_cur,
                                         p_banc_type                OUT GIIS_BANC_TYPE_PKG.giis_banc_type_cur,
                                         p_banc_type_dtl_list       OUT GIIS_BANC_TYPE_DTL_PKG.giis_banc_type_dtl_cur,
                                         p_var_banc_rate_sw         OUT VARCHAR2,
                                         p_v_gipi_wpolnrep_exist    OUT VARCHAR2,
                                         p_wcominv_intm_no          OUT GIPI_WCOMM_INVOICES.intrmdry_intm_no%TYPE, --belle 06.04.12
                                         p_dflt_intm_no             OUT giis_assured_intm.intm_no%TYPE, --benjo 09.07.2016 SR-5604
                                         p_req_dflt_intm_per_assd   OUT VARCHAR2, --benjo 09.07.2016 SR-5604
                                         p_allow_upd_intm_per_assd  OUT VARCHAR2 --benjo 09.07.2016 SR-5604
                                        )
    IS
        v_b240_assd_no                          GIPI_PARLIST.assd_no%TYPE;
        v_b240_line_cd                          GIPI_PARLIST.line_cd%TYPE;
        v_b240_par_type                         GIPI_PARLIST.par_type%TYPE;
        --v_wcominv_intm_no                       GIPI_WCOMM_INVOICES.intrmdry_intm_no%TYPE := NULL; belle 06.04.12 change to parameter out
        v_banc_type_cd                          GIPI_WPOLBAS.banc_type_cd%TYPE;
    BEGIN
        -- B240 block (GIPI_PARLIST)
        BEGIN
            OPEN p_gipis160_b240 FOR
                SELECT a.par_id, a.line_cd, a.iss_cd, a.par_yy,
                       a.par_seq_no, a.quote_seq_no, d.line_cd||' - '||d.iss_cd||' - '||to_char(d.par_yy,'09')||' - '||to_char(d.par_seq_no,'099999')||' - '||to_char(d.quote_seq_no,'09') dsp_pack_par_no,
                       a.line_cd || ' - ' || a.iss_cd || ' - ' || to_char(a.par_yy,'09') || ' - ' || to_char(a.par_seq_no,'099999') || ' - ' || to_char(a.quote_seq_no,'09') drv_par_seq_no,
                       b.pol_flag, a.assd_no, ESCAPE_VALUE(c.assd_name) dsp_assd_name, a.par_status,
                       b.endt_yy nb_endt_yy, a.par_type, a.pack_par_id, b.subline_cd
                  FROM GIPI_PARLIST a, GIPI_WPOLBAS b, GIIS_ASSURED c, GIPI_PACK_PARLIST d
                 WHERE a.par_id = p_par_id
                   AND b.par_id (+) = a.par_id
                   AND c.assd_no (+) = a.assd_no
                   AND d.pack_par_id (+) = a.pack_par_id;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN NULL;
        END;
        
        -- B450 block (GIPI_WINVOICE)
        BEGIN
            OPEN p_gipis160_b450 FOR
                 SELECT * 
                   FROM TABLE(Gipi_Winvoice_Pkg.get_gipi_winvoice2(p_par_id));
        EXCEPTION
            WHEN NO_DATA_FOUND THEN NULL;
        END;
        
        -- WCOMINVPER (GIPI_WCOMM_INV_PERILS)
        BEGIN
            OPEN p_wcomm_inv_perils FOR
                 SELECT * 
                     FROM TABLE(GIPI_WCOMM_INV_PERILS_PKG.get_gipi_wcomm_inv_perils2(p_par_id));
        EXCEPTION
            WHEN NO_DATA_FOUND THEN NULL;
        END;
        
        BEGIN			
            SELECT banc_type_cd
              INTO v_banc_type_cd 
              FROM GIPI_WPOLBAS 
             WHERE par_id = p_par_id;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                 NULL;
        END;
        
        -- banca
        p_var_banc_rate_sw := 'N';
        
        BEGIN
            OPEN p_banc_type FOR
	              SELECT banc_type_cd, banc_type_desc, rate, user_id, last_update
	                FROM GIIS_BANC_TYPE
	               WHERE banc_type_cd = NVL(v_banc_type_cd, '');
	               
	            OPEN p_banc_type_dtl_list FOR
	              SELECT a.item_no, a.intm_no, b.intm_name, a.intm_type, a.fixed_tag, a.banc_type_cd, c.intm_desc intm_type_desc, a.share_percentage,
	                          d.intm_no parent_intm_no, d.intm_name parent_intm_name
	                  FROM GIIS_BANC_TYPE_DTL a, GIIS_INTERMEDIARY b, GIIS_INTM_TYPE c, GIIS_INTERMEDIARY d
	               WHERE a.banc_type_cd = NVL(v_banc_type_cd, '')
	                 AND a.intm_no = b.intm_no (+) --apollo cruz 10.27.2014 added (+) to show records with no intermediary
	                 AND a.intm_type = c.intm_type
	                 AND b.parent_intm_no = d.intm_no (+)
	            ORDER BY a.intm_no;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN NULL;
        END;
        
        -- Basic Values
        
        p_v_lov_tag             := 'UNFILTERED';
        p_v_wcominv_intm_no_lov := 'cgfk$wcominvDspIntmName5';
        
        FOR i IN (SELECT line_cd, assd_no, par_type
                    FROM GIPI_PARLIST
                   WHERE par_id = p_par_id)
        LOOP
            v_b240_line_cd  := i.line_cd;
            v_b240_assd_no  := i.assd_no;
            v_b240_par_type := i.par_type;
        END LOOP;
        
        FOR i IN (SELECT intrmdry_intm_no
                    FROM TABLE(GIPI_WCOMM_INVOICES_PKG.get_gipi_wcomm_invoices2(p_par_id))
                   WHERE ROWNUM = 1)
        LOOP
            --v_wcominv_intm_no := i.intrmdry_intm_no; belle 06.04.12
             p_wcominv_intm_no := i.intrmdry_intm_no; 
        END LOOP;
        
        
        BEGIN
            SELECT pol_flag
              INTO p_v_pol_flag
              FROM GIPI_WPOLBAS
             WHERE par_id = p_par_id;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                p_v_pol_flag := 1;
        END;
        
        -- Other variables
        BEGIN
            SELECT GIIS_PARAMETERS_PKG.v('OVERRIDE_COMM_WHTAX')
              INTO p_var_override_whtax
              FROM DUAL;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                 NULL;
        END;
        
        BEGIN
             p_v_ora2010_sw := giis_parameters_pkg.v('ORA2010_SW');
			 p_v_validate_banca := BANCASSURANCE.validate_bancassurance(p_par_id);
        EXCEPTION
             WHEN NO_DATA_FOUND THEN
                   NULL;
        END;
        
        BEGIN
              SELECT Giisp.v('ALLOW_APPLY_SLIDING_COMM')
                INTO p_v_allow_apply_sl_comm
                FROM DUAL;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                 NULL;
        END;
        
        p_v_gipi_wpolnrep_exist := 'N';

        FOR a IN (SELECT 1 
                    FROM GIPI_WPOLNREP
                   WHERE par_id = p_par_id)
        LOOP
          p_v_gipi_wpolnrep_exist := 'Y';
        END LOOP;
        
        /* GET_DEFAULT_ASSURED_INTM */
        
        DECLARE        
            DUMMY  NUMBER;
            DUMMY2 GIIS_ASSURED_INTM.INTM_NO%TYPE;
            CTR NUMBER:=0;
            v_pol_flag    GIPI_WPOLBAS.pol_flag%TYPE;
        BEGIN
             IF v_b240_par_type = 'P' THEN
			 	BEGIN
				 	SELECT DISTINCT 1
		              INTO DUMMY 
		              FROM gipi_wcomm_invoices
		             WHERE par_id = p_par_id;
         
                BEGIN
                  SELECT INTM_NO 
                    INTO DUMMY2
                    FROM giis_assured_intm
                   WHERE assd_no = v_b240_assd_no
                     AND line_cd = v_b240_line_cd;
        
                  FOR V1 IN (SELECT INTM_NO 
                               FROM giis_assured_intm
                              WHERE assd_no = v_b240_assd_no
                                AND line_cd =  v_b240_line_cd) 
                  LOOP
                    --IF v_wcominv_intm_no IS NOT NULL AND V1.INTM_NO = v_wcominv_intm_no THEN belle 06.04.12 replaced by cides below
                    IF p_wcominv_intm_no IS NOT NULL AND V1.INTM_NO = p_wcominv_intm_no THEN
                        p_v_lov_tag := 'FILTERED';
                        p_v_wcominv_intm_no_lov := 'cgfk$wcominvDspIntmName';
                    --ELSIF v_wcominv_intm_no IS NOT NULL AND V1.INTM_NO!=v_wcominv_intm_no THEN belle 06.04.12
                    ELSIF p_wcominv_intm_no IS NOT NULL AND V1.INTM_NO!= p_wcominv_intm_no THEN
                        p_v_lov_tag := 'UNFILTERED';  
                        p_v_wcominv_intm_no_lov := 'cgfk$wcominvDspIntmName5';   
                    END IF;
                  END LOOP;
           
                EXCEPTION
                  WHEN NO_DATA_FOUND THEN 
                      p_v_lov_tag := 'UNFILTERED';
                      p_v_wcominv_intm_no_lov := 'cgfk$wcominvDspIntmName5';          
                  WHEN TOO_MANY_ROWS THEN
                      p_v_lov_tag := 'FILTERED';
                      p_v_wcominv_intm_no_lov := 'cgfk$wcominvDspIntmName';
                END;
                
              GIPIS085_DEFAULT_INTRMDRY(p_par_id, p_intm_no, p_dsp_intm_name, p_parent_intm_no);     
         
              EXCEPTION    
                WHEN no_data_found THEN
                  IF p_v_pol_flag = '2' THEN
				  	 FOR intm IN (SELECT a.intrmdry_intm_no 
                                    FROM gipi_comm_invoice a, gipi_polbasic b, gipi_wpolnrep c
                                   WHERE c.par_id    = p_par_id
                                     AND b.policy_id = c.old_policy_id
                                     AND b.policy_id = a.policy_id)
                     LOOP
                       CTR:=CTR+1;
                     END LOOP;             
                  ELSE
                     FOR V1 IN(SELECT INTM_NO
                                 FROM GIIS_ASSURED_INTM
                                WHERE ASSD_NO=v_b240_assd_no
                                  AND LINE_cD=v_b240_line_cd)
                     LOOP
                       CTR:=CTR+1;
                     END LOOP;
                  END IF;
                  IF CTR>1 THEN 
                     p_v_lov_tag := 'FILTERED';
                     p_v_wcominv_intm_no_lov := 'cgfk$wcominvDspIntmName';                                 
                  ELSIF CTR=1 THEN
                        --DEFAULT_INTRMDRY;
						GIPIS085_DEFAULT_INTRMDRY(p_par_id, p_intm_no, p_dsp_intm_name, p_parent_intm_no);
                        
                       -- get parent_intm_name
                        p_parent_intm_name := NULL;
                        
                        IF p_parent_intm_no IS NULL THEN
                           p_parent_intm_no := p_intm_no;
                        END IF;
                                            
                        FOR intm IN (SELECT intm_name
                                       FROM giis_intermediary
                                      WHERE intm_no = p_parent_intm_no)
                        LOOP
                            p_parent_intm_name := intm.intm_name;
                        END LOOP;
                        
                        IF p_parent_intm_name IS NULL THEN
                           p_parent_intm_name := p_dsp_intm_name;
                        END IF;
                  ELSIF CTR = 0 THEN           
                        p_var_param_req_def_intm := giac_parameters_pkg.v('REQ_DEF_INTM');
                        IF p_var_param_req_def_intm = 'Y' THEN
                            --p_msg_alert := 'NO_DEFAULT_INTM';                             
                            p_v_lov_tag := 'UNFILTERED';
                            RETURN;                                                   
                        ELSE
                           p_v_lov_tag := 'UNFILTERED';
                           p_v_wcominv_intm_no_lov := 'cgfk$wcominvDspIntmName5';
                         END IF;
                      END IF;    
                WHEN too_many_rows then
                  FOR V1 IN (SELECT INTM_NO 
                               FROM giis_assured_intm
                              WHERE assd_no = v_b240_assd_no
                                AND line_cd = v_b240_line_cd) 
                  LOOP
                     --IF v_wcominv_intm_no IS NOT NULL AND V1.INTM_NO=v_wcominv_intm_no THEN belle 06.04.12
                     IF p_wcominv_intm_no IS NOT NULL AND V1.INTM_NO= p_wcominv_intm_no THEN
                          p_v_lov_tag := 'FILTERED';
                          p_v_wcominv_intm_no_lov := 'cgfk$wcominvDspIntmName';
                     --ELSIF v_wcominv_intm_no IS NOT NULL AND DUMMY2!=v_wcominv_intm_no THEN belle 06.04.12
                     ELSIF p_wcominv_intm_no IS NOT NULL AND DUMMY2!= p_wcominv_intm_no THEN
                        p_v_lov_tag := 'UNFILTERED';
                        p_v_wcominv_intm_no_lov := 'cgfk$wcominvDspIntmName5';          
                     END IF;            
                  END LOOP;      
              END;
           ELSE   
              BEGIN
			  	SELECT DISTINCT 1
                  INTO DUMMY 
                  FROM gipi_wcomm_invoices
                 WHERE par_id = p_par_id;
				  
				BEGIN
                  select a.intrmdry_intm_no
                    into dummy2 
                   from gipi_comm_invoice a, 
                        gipi_wpolbas b, gipi_polbasic c                             
                  Where b.par_id = p_par_id 
                    and b.line_cd = c.line_cd 
                    and b.subline_cd = c.subline_cd 
                    and b.iss_cd = c.iss_cd 
                    and b.issue_yy = c.issue_yy 
                    and b.pol_seq_no = c.pol_seq_no
                    and b.renew_no=c.renew_no 
                    and c.policy_id = a.policy_id;
	        
                  FOR V1 IN (select a.intrmdry_intm_no 
                               from gipi_comm_invoice a, 
                                    gipi_wpolbas b, gipi_polbasic c                             
                              Where b.par_id = p_par_id 
                                and b.line_cd = c.line_cd 
                                and b.subline_cd = c.subline_cd 
                                and b.iss_cd = c.iss_cd 
                                and b.issue_yy = c.issue_yy 
                                and b.pol_seq_no = c.pol_seq_no
                                and b.renew_no=c.renew_no 
                                and c.policy_id = a.policy_id) 
                  LOOP
                     --IF v_wcominv_intm_no IS NOT NULL AND V1.INTRMDRY_INTM_NO=v_wcominv_intm_no THEN  --belle 06.04.12
                     IF p_wcominv_intm_no IS NOT NULL AND V1.INTRMDRY_INTM_NO= p_wcominv_intm_no THEN  
                          p_v_lov_tag := 'FILTERED';
                          p_v_wcominv_intm_no_lov := 'cgfk$wcominvDspIntmName3';
                     --ELSIF v_wcominv_intm_no IS NOT NULL AND V1.INTRMDRY_INTM_NO!=v_wcominv_intm_no THEN --belle 06.04.12
                     ELSIF p_wcominv_intm_no IS NOT NULL AND V1.INTRMDRY_INTM_NO!= p_wcominv_intm_no THEN
                        p_v_lov_tag := 'UNFILTERED';
                        p_v_wcominv_intm_no_lov := 'cgfk$wcominvDspIntmName5';          
                     END IF;            
                  END LOOP;      
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                       p_v_lov_tag := 'UNFILTERED';
                       p_v_wcominv_intm_no_lov := 'cgfk$wcominvDspIntmName5';              
                  WHEN TOO_MANY_ROWS THEN
                       p_v_lov_tag := 'FILTERED';
                       p_v_wcominv_intm_no_lov := 'cgfk$wcominvDspIntmName3';
                END;
                
              GIPIS085_DEFAULT_INTRMDRY(p_par_id, p_intm_no, p_dsp_intm_name, p_parent_intm_no);  
                
              EXCEPTION  
                WHEN no_data_found THEN
					 FOR V1 IN(select distinct a.intrmdry_intm_no 
                                 from gipi_comm_invoice a, 
                                      gipi_wpolbas b, 
                                      gipi_polbasic c                             
                                Where b.par_id = p_par_id 
                                  and b.line_cd = c.line_cd 
                                  and b.subline_cd = c.subline_cd 
                                  and b.iss_cd = c.iss_cd 
                                  and b.issue_yy = c.issue_yy 
                                  and b.pol_seq_no = c.pol_seq_no
                                  and b.renew_no=c.renew_no 
                                  and c.policy_id = a.policy_id
                                  and a.policy_id = nvl(b.cancelled_endt_id,c.policy_id))
                     LOOP
                       CTR:=CTR+1;
                     END LOOP;
					 
                     IF CTR>1 THEN 
                        p_v_lov_tag := 'FILTERED';
                        p_v_wcominv_intm_no_lov := 'cgfk$wcominvDspIntmName3';
                     ELSIF CTR=1 THEN 
                        --  DEFAULT_INTRMDRY;
                        GIPIS085_DEFAULT_INTRMDRY(p_par_id, p_intm_no, p_dsp_intm_name, p_parent_intm_no);
                        
                        -- get parent_intm_name
                        p_parent_intm_name := NULL;
                        
                        IF p_parent_intm_no IS NULL THEN
                           p_parent_intm_no := p_intm_no;
                        END IF;
                                            
                        FOR intm IN (SELECT intm_name
                                       FROM giis_intermediary
                                      WHERE intm_no = p_parent_intm_no)
                        LOOP
                            p_parent_intm_name := intm.intm_name;
                        END LOOP;
                        
                        IF p_parent_intm_name IS NULL THEN
                           p_parent_intm_name := p_dsp_intm_name;
                        END IF;                    
                        
                     ELSIF CTR = 0 THEN
                          p_var_param_req_def_intm := giac_parameters_pkg.v('REQ_DEF_INTM');  
                           IF p_var_param_req_def_intm = 'Y' THEN 
                                  --p_msg_alert := 'There is no default intermediary for this assured.';
                                --p_msg_alert := 'NO_DEFAULT_INTM';                                                                                                   
                                p_v_lov_tag := 'UNFILTERED';                                                   
                           ELSE
                           p_v_lov_tag := 'UNFILTERED';
                             p_v_wcominv_intm_no_lov := 'cgfk$wcominvDspIntmName5';      
                           END IF;
                     END IF;          
                   when too_many_rows then
				   	 FOR V1 IN (select a.intrmdry_intm_no 
	                                  from gipi_comm_invoice a, 
                                       gipi_wpolbas b, gipi_polbasic c                             
                                 Where b.par_id = p_par_id 
                                   and b.line_cd = c.line_cd 
                                   and b.subline_cd = c.subline_cd 
                                   and b.iss_cd = c.iss_cd 
                                   and b.issue_yy = c.issue_yy 
                                   and b.pol_seq_no = c.pol_seq_no
                                   and b.renew_no=c.renew_no 
                                   and c.policy_id = a.policy_id) 
                     LOOP
                        --IF v_wcominv_intm_no IS NOT NULL AND V1.INTRMDRY_INTM_NO=v_wcominv_intm_no THEN --belle 06.04.12
                        IF p_wcominv_intm_no IS NOT NULL AND V1.INTRMDRY_INTM_NO= p_wcominv_intm_no THEN
                             p_v_lov_tag := 'FILTERED';
                                p_v_wcominv_intm_no_lov := 'cgfk$wcominvDspIntmName3';
                        --ELSIF v_wcominv_intm_no IS NOT NULL AND DUMMY2!=v_wcominv_intm_no THEN --belle 06.04.12
                        ELSIF p_wcominv_intm_no IS NOT NULL AND DUMMY2!= p_wcominv_intm_no THEN
                           p_v_lov_tag := 'UNFILTERED';
                             p_v_wcominv_intm_no_lov := 'cgfk$wcominvDspIntmName5';   
                        END IF;            
                     END LOOP;
               END;
           END IF;
           
           p_dsp_intm_name := ESCAPE_VALUE(p_dsp_intm_name);
           p_parent_intm_name := ESCAPE_VALUE(p_parent_intm_name);
        END;
        
        /* End of GET_DEFAULT_ASSURED_INTM */
        
        /* benjo 09.07.2016 SR-5604 */
        BEGIN
           SELECT intm_no
             INTO p_dflt_intm_no
             FROM giis_assured_intm
            WHERE assd_no = v_b240_assd_no AND line_cd = v_b240_line_cd;
        EXCEPTION
           WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
           THEN
              p_dflt_intm_no := NULL;
        END;
        
        BEGIN
            SELECT NVL(giisp.v('REQUIRE_DEFAULT_INTM_PER_ASSURED'),'N'),
                   NVL(giisp.v('ALLOW_UPDATE_DEF_INTM_PER_ASSURED'),'N')
              INTO p_req_dflt_intm_per_assd,
                   p_allow_upd_intm_per_assd
              FROM DUAL;
        EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;
        END;
        /* end SR-5604 */
    END gipis160_new_form_instance;
    
    /*
    **  Created by   :  Emman
    **  Date Created :  09.12.2011
    **  Reference By : (GIPIS160 - Endt Bond Invoice Commission)
    **  Description  : Gets GIPI_WCOMM_INVOICES records based on par_id, item_grp, and takeup_seq_no
    */
    FUNCTION get_gipi_wcomm_invoices3 (
        p_par_id            GIPI_WCOMM_INVOICES.par_id%TYPE,
        p_item_grp          GIPI_WCOMM_INVOICES.item_grp%TYPE,
        p_takeup_seq_no     GIPI_WCOMM_INVOICES.takeup_seq_no%TYPE)
    RETURN gipi_wcomm_invoices_tab PIPELINED 
    IS
    
    v_wcomm            gipi_wcomm_invoices_type;
    
    BEGIN
        FOR i IN (
            SELECT a.intrmdry_intm_no, b.intm_name,      b.parent_intm_no, nvl(c.intm_name, '') parent_intm_name,
                   a.share_percentage, a.takeup_seq_no,  a.item_grp,        a.par_id,
                   a.premium_amt,        a.commission_amt, a.wholding_tax,   a.commission_amt - a.wholding_tax net_commission  
              FROM GIPI_WCOMM_INVOICES a
                   ,GIIS_INTERMEDIARY b
                   ,GIIS_INTERMEDIARY c
             WHERE a.par_id = p_par_id
               AND a.item_grp = p_item_grp
               AND a.takeup_seq_no = p_takeup_seq_no
               AND a.intrmdry_intm_no = b.intm_no
               AND b.parent_intm_no = c.intm_no (+))
        LOOP
            v_wcomm.intrmdry_intm_no        := i.intrmdry_intm_no;
            v_wcomm.intm_name                := i.intm_name;
            v_wcomm.parent_intm_no            := i.parent_intm_no;
            v_wcomm.parent_intm_name        := i.parent_intm_name;
            v_wcomm.share_percentage        := i.share_percentage;
            v_wcomm.takeup_seq_no            := i.takeup_seq_no;
            v_wcomm.item_grp                := i.item_grp;
            v_wcomm.par_id                    := i.par_id;
            v_wcomm.premium_amt                := i.premium_amt;
            v_wcomm.commission_amt            := i.commission_amt;
            v_wcomm.wholding_tax            := i.wholding_tax;
            v_wcomm.net_commission            := i.net_commission;
        PIPE ROW(v_wcomm);
        END LOOP;
        RETURN;
    END get_gipi_wcomm_invoices3;
    
   /*
   **  Added by      : Steven Ramirez
   **  Date Created  : 10.18.2013
   **  Reference By  : GIPIS095
   **  Description   : Delete record by supplying the par_id,item_no only
   */
   PROCEDURE del_gipi_wcomm_inv_dtl (p_par_id   gipi_wcomm_inv_dtl.par_id%TYPE,
                                     p_item_grp gipi_witem.item_grp%TYPE)
   IS
   BEGIN
       DELETE FROM gipi_wcomm_inv_dtl
             WHERE par_id = p_par_id
             AND item_grp = p_item_grp;
    END ;

   /*
       Apollo Cruz 09.29.2014
       recompute the amounts in GIPIS085 tables
       to avoid discrepancy
    */   
   PROCEDURE recompute_gipis085_amounts(
      p_par_id VARCHAR2
   )
   IS
      v_tot_share_pct   NUMBER;
      v_prem_amt        NUMBER;
      v_tot_prem_amt    NUMBER;
      v_tot_comm_amt    NUMBER; --added by robert SR 21760 03.16.16
   BEGIN
      FOR itmperl IN (SELECT a.item_grp, b.peril_cd, SUM(b.prem_amt) prem_amt
                     FROM gipi_witem a, gipi_witmperl b
                    WHERE a.par_id = p_par_id
                      AND a.par_id = b.par_id
                      AND a.item_no = b.item_no
                 GROUP BY a.par_id, a.item_grp, b.peril_cd)
      LOOP
         v_tot_share_pct := 0;
         v_tot_prem_amt := 0;

         FOR wcomminv IN (SELECT   intrmdry_intm_no, share_percentage
                            FROM gipi_wcomm_invoices
                           WHERE par_id = p_par_id
                             AND item_grp = itmperl.item_grp
                        ORDER BY intrmdry_intm_no)
         LOOP
            v_tot_share_pct := v_tot_share_pct + wcomminv.share_percentage;
            v_prem_amt := ROUND ((itmperl.prem_amt * wcomminv.share_percentage / 100), 2);
            v_tot_prem_amt := v_tot_prem_amt + v_prem_amt;
            
            IF v_tot_share_pct = 100 THEN
         
               IF itmperl.prem_amt <> v_tot_prem_amt THEN
                  v_prem_amt := v_prem_amt + (itmperl.prem_amt - v_tot_prem_amt);
               END IF;   
         
               v_tot_share_pct := 0;
               v_tot_prem_amt := 0;
            END IF;
            
            UPDATE gipi_wcomm_inv_perils
               SET premium_amt = v_prem_amt,
                   commission_amt = v_prem_amt * commission_rt / 100
             WHERE par_id = p_par_id
               AND item_grp = itmperl.item_grp
               AND intrmdry_intm_no = wcomminv.intrmdry_intm_no
               AND peril_cd = itmperl.peril_cd; 
            
         END LOOP wcomminv;
      END LOOP itmperl;
      
      FOR wcomminv IN (SELECT item_grp, intrmdry_intm_no, share_percentage
                         FROM gipi_wcomm_invoices
                        WHERE par_id = p_par_id)
      LOOP                          
         SELECT SUM(premium_amt), SUM(commission_amt) --added comm by robert SR 21760 03.16.16
           INTO v_prem_amt, v_tot_comm_amt --added comm by robert SR 21760 03.16.16
           FROM gipi_wcomm_inv_perils
          WHERE par_id = p_par_id 
            AND item_grp = wcomminv.item_grp
            AND intrmdry_intm_no = wcomminv.intrmdry_intm_no;
            
         UPDATE gipi_wcomm_invoices
            SET premium_amt = v_prem_amt,
                commission_amt = v_tot_comm_amt --added by robert SR 21760 03.16.16
          WHERE par_id = p_par_id
            AND item_grp = wcomminv.item_grp
            AND intrmdry_intm_no = wcomminv.intrmdry_intm_no;          
            
      END LOOP wcomminv;
      
   END recompute_gipis085_amounts;
   
   PROCEDURE del_comm_invoice_related_recs(
      p_par_id   gipi_wcomm_invoices.par_id%TYPE
   )
   IS
   BEGIN
      
      DELETE gipi_wcomm_inv_perils
       WHERE par_id = p_par_id;
   
      DELETE gipi_wcomm_invoices
       WHERE par_id = p_par_id;
 
      DELETE gipi_wcomm_inv_dtl
       WHERE par_id = p_par_id;
    
   END del_comm_invoice_related_recs;
   
   PROCEDURE apply_sliding_commission (
      p_sliding_comm   IN OUT   VARCHAR2,
      p_rate           IN OUT   gipi_wcomm_inv_perils.commission_rt%TYPE,
      p_line_cd                 giis_line.line_cd%TYPE,
      p_subline_cd              giis_subline.subline_cd%TYPE,
      p_par_id                  gipi_witmperl.par_id%TYPE,
      p_peril_cd                gipi_witmperl.peril_cd%TYPE,
      p_item_grp                gipi_witem.item_grp%TYPE
   )
   IS
      v_prem_rt      gipi_witmperl.prem_rt%TYPE;
      v_default_rt   giis_peril.default_rate%TYPE;
   BEGIN
      SELECT AVG (NVL (a.default_rate, 0)), AVG (NVL (b.prem_rt, 0))
        INTO v_default_rt, v_prem_rt
        FROM giis_peril a, gipi_witmperl b, gipi_witem c
       WHERE a.peril_cd = b.peril_cd
         AND a.line_cd = b.line_cd
         AND a.line_cd = p_line_cd
         AND a.peril_cd = p_peril_cd
         AND b.par_id = p_par_id
         AND b.par_id = c.par_id
         AND b.item_no = c.item_no
         AND c.item_grp = NVL(p_item_grp, 1);

      p_sliding_comm := 'Y';

      IF v_default_rt <> v_prem_rt
      THEN
         FOR com IN (SELECT NVL (a.hi_prem_lim, 0) prem_rt_high,
                            NVL (a.lo_prem_lim, 0) prem_rt_low,
                            NVL (a.slid_comm_rt, 0) comm_rate
                       FROM giis_slid_comm a
                      WHERE a.line_cd = p_line_cd
                        AND a.subline_cd = p_subline_cd
                        AND a.peril_cd = p_peril_cd
                        AND hi_prem_lim >= v_prem_rt
                        AND lo_prem_lim <= v_prem_rt)
         LOOP
            p_rate := com.comm_rate;
            p_sliding_comm := 'N';
         END LOOP;
      END IF;
   END apply_sliding_commission;
 
END GIPI_WCOMM_INVOICES_PKG;
/


