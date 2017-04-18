CREATE OR REPLACE PACKAGE BODY CPI.gicl_accident_dtl_pkg
AS

/*
**  Created by   :  Belle Bebing
**  Date Created :  11.28.2011
**  Reference By : (GICLS017 Claims Accident Item Information)
**  Description  : Retrieves Accident Item Info
*/
FUNCTION get_accident_dtl_item(p_claim_id       GICL_CLAIMS.claim_id%TYPE)
RETURN gicl_accident_dtl_tab PIPELINED
IS
    vitem           gicl_accident_dtl_type; 
    
    BEGIN
        FOR i IN ( SELECT *
                     FROM gicl_accident_dtl
                    WHERE claim_id = p_claim_id)
        LOOP
            vitem.claim_id              := i.claim_id;
            vitem.item_no               := i.item_no;
            vitem.item_title            := i.item_title;
            vitem.grouped_item_no       := i.grouped_item_no;  
            vitem.grouped_item_title    := i.grouped_item_title;
            vitem.currency_cd           := i.currency_cd;
            vitem.currency_rate         := i.currency_rate;
            vitem.position_cd           := i.position_cd;
            vitem.monthly_salary        := i.monthly_salary;
            vitem.control_cd            := i.control_cd;
            vitem.level_cd              := i.level_cd;
            vitem.salary_grade          := i.salary_grade;
            vitem.date_of_birth         := i.date_of_birth;
            vitem.age                   := i.age;
            vitem.amount_coverage       := i.amount_coverage;
            
            FOR s IN (SELECT rv_meaning
                        FROM cg_ref_codes
                       WHERE rv_low_value = i.civil_status
                         AND rv_domain = 'CIVIL STATUS')
            LOOP
                vitem.dsp_civil_stat := s.rv_meaning;
            END LOOP;

            IF i.sex IS NOT NULL THEN
                FOR d IN (SELECT decode(i.sex, 'M', 'Male', 'Female') Gender
                            FROM DUAL) 
                LOOP
                 vitem.dsp_sex := d.gender;
                END LOOP;
            END IF;
      
            FOR c IN (SELECT CURRENCY_DESC 
                        FROM GIIS_CURRENCY
                       WHERE MAIN_CURRENCY_CD = i.currency_cd) 
            LOOP
              vitem.dsp_currency := c.currency_desc;
            END LOOP;

            FOR p IN (SELECT POSITION
                        FROM GIIS_POSITION
                       WHERE POSITION_CD = i.position_cd) 
            LOOP
              vitem.dsp_position := p.position;
            END LOOP;
               
            FOR j IN (SELECT control_type_desc
                        FROM giis_control_type
                       WHERE control_type_cd = i.control_type_cd)
            LOOP
                vitem.dsp_control_type := j.control_type_desc;
            END LOOP;
            
            BEGIN
                SELECT item_desc, item_desc2
                  INTO vitem.item_desc, vitem.item_desc2
                  FROM gicl_clm_item
                 WHERE 1 = 1
                   AND claim_id = p_claim_id
                   AND item_no = vitem.item_no
                   AND grouped_item_no = NVL(vitem.grouped_item_no, 0);
            EXCEPTION
                WHEN NO_DATA_FOUND
                THEN
                   vitem.item_desc := NULL;
                   vitem.item_desc2 := NULL;
            END;
            
            SELECT gicl_item_peril_pkg.get_gicl_item_peril_exist (vitem.item_no,
                                                                  vitem.claim_id)
              INTO vitem.gicl_item_peril_exist
              FROM DUAL;

            SELECT gicl_mortgagee_pkg.get_gicl_mortgagee_exist (vitem.item_no,
                                                                vitem.claim_id)
              INTO vitem.gicl_mortgagee_exist
              FROM DUAL;

            gicl_item_peril_pkg.validate_peril_reserve(vitem.item_no,
                                                       vitem.claim_id,
                                                       vitem.grouped_item_no,
                                                       vitem.gicl_item_peril_msg);    
            
             PIPE ROW(vitem);
        END LOOP;
        
    END get_accident_dtl_item;

/*
**  Created by   :  Belle Bebing
**  Date Created :  12.07.2011
**  Reference By : (GICLS017- Claims Personal Accident Item Information)
**  Description  : check item_no if exist
*/       
FUNCTION check_accident_item_no (
    p_claim_id    gicl_accident_dtl.claim_id%TYPE,
    p_item_no     gicl_accident_dtl.item_no%TYPE,
    p_start_row   VARCHAR2,
    p_end_row     VARCHAR2
    )
    RETURN VARCHAR2
IS
    v_exist   VARCHAR2 (1);
   BEGIN
      BEGIN
         SELECT 'Y'
           INTO v_exist
           FROM (SELECT ROWNUM rownum_, a.item_no item_no
                   FROM (SELECT item_no
                           FROM TABLE
                                   (gicl_accident_dtl_pkg.get_accident_dtl_item
                                                                   (p_claim_id)
                                   )) a)
          WHERE rownum_ NOT BETWEEN p_start_row AND p_end_row
            AND item_no = p_item_no;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_exist := 'N';
      END;

      RETURN v_exist;
   END;
   
   
FUNCTION extract_beneficiary_info_ngrp(
    p_beneficiary_no          gipi_beneficiary.beneficiary_no%TYPE,
    p_line_cd                 gipi_polbasic.line_cd%TYPE,
    p_subline_cd              gipi_polbasic.subline_cd%TYPE,
    p_pol_iss_cd              gipi_polbasic.iss_cd%TYPE,
    p_issue_yy                gipi_polbasic.issue_yy%TYPE,
    p_pol_seq_no              gipi_polbasic.pol_seq_no%TYPE,
    p_renew_no                gipi_polbasic.renew_no%TYPE,
    p_pol_eff_date            gipi_polbasic.eff_date%TYPE,
    p_expiry_date             gipi_polbasic.expiry_date%TYPE,
    p_loss_date               gipi_polbasic.expiry_date%TYPE,
    p_item_no                 gipi_item.item_no%TYPE
  ) 
    RETURN beneficiary_dtl_tab PIPELINED
IS
    v_ben                 beneficiary_dtl_type;
    v_endt_seq_no         gipi_polbasic.endt_seq_no%TYPE;
    previous_item_no      gipi_item.item_no%TYPE := -1;
    v_beneficiary_no      gipi_beneficiary.beneficiary_no%TYPE;
    v_beneficiary_name    gipi_beneficiary.beneficiary_name%TYPE;
    v_beneficiary_addr    gipi_beneficiary.beneficiary_addr%TYPE;
    v_position_cd         gipi_beneficiary.position_cd%TYPE;
    v_position            giis_position.position%TYPE;
    v_date_of_birth       VARCHAR2(20);--gipi_beneficiary.date_of_birth%TYPE; replaced by: Nica 04.26.2013
    v_age                 gipi_beneficiary.age%TYPE;
    v_civil_status        gipi_beneficiary.civil_status%TYPE;
    v_sex                 gipi_beneficiary.sex%TYPE;
    v_relation            gipi_beneficiary.relation%TYPE;

    BEGIN
      FOR get_info IN( 
        SELECT c.endt_seq_no endt_seq_no, 
               f.beneficiary_name beneficiary_name,
               f.beneficiary_addr beneficiary_addr,
               f.position_cd position_cd,
               --f.date_of_birth date_of_birth,
			   TO_CHAR(f.date_of_birth, 'MM-DD-YYYY') date_of_birth,
               f.civil_status civil_status,
               f.age age,
               f.sex sex,
               f.relation relation
          FROM gipi_polbasic c,
               gipi_beneficiary f,
               gipi_item g 
         WHERE c.policy_id          = g.policy_id
           AND g.policy_id          = f.policy_id
           AND g.item_no            = f.item_no
           AND c.renew_no           = p_renew_no
           AND c.pol_seq_no         = p_pol_seq_no
           AND c.issue_yy           = p_issue_yy
           AND c.iss_cd             = p_pol_iss_cd
           AND c.subline_cd         = p_subline_cd
           AND c.line_cd            = p_line_cd
           --AND c.pol_flag           NOT IN ('4','5')
           AND c.pol_flag           NOT IN ('5')    --kenneth SR4855 100715
           AND trunc(DECODE(TRUNC(NVL(g.from_date,c.eff_date)),TRUNC(c.incept_date), NVL(g.from_date,p_pol_eff_date), NVL(g.from_date,c.eff_date) ))
               <= TRUNC(p_loss_date)
           AND TRUNC(DECODE(NVL(g.to_date,NVL(c.endt_expiry_date, c.expiry_date)),
               c.expiry_date,NVL(g.to_date,p_expiry_date),NVL(g.to_date,c.endt_expiry_date)))  
               >= TRUNC(p_loss_date)
           AND f.beneficiary_no     = p_beneficiary_no
           AND f.item_no            = p_item_no
         ORDER BY c.eff_date)
      LOOP
        v_beneficiary_no              := p_beneficiary_no;
        v_beneficiary_name            := NVL(get_info.beneficiary_name,v_beneficiary_name);
        v_beneficiary_addr            := NVL(get_info.beneficiary_addr,v_beneficiary_addr);
        v_position_cd                 := NVL(get_info.position_cd,v_position_cd);
        v_date_of_birth               := NVL(get_info.date_of_birth,v_date_of_birth);
        v_age                         := NVL(get_info.age,v_age);
        v_civil_status                := NVL(get_info.civil_status,v_civil_status);
        v_sex                         := NVL(get_info.sex,v_sex);
        v_relation                    := NVL(get_info.relation,v_relation);
        v_endt_seq_no                 := get_info.endt_seq_no;
      END LOOP;
      
      FOR get_info2 IN( 
        SELECT c.endt_seq_no endt_seq_no, 
               f.beneficiary_name beneficiary_name,
               f.beneficiary_addr beneficiary_addr,
               f.position_cd position_cd,
               f.date_of_birth date_of_birth,
               f.civil_status civil_status,
               f.age age,
               f.sex sex,
               f.relation relation          
          FROM gipi_polbasic c,
               gipi_beneficiary f,
               gipi_item g
         WHERE c.policy_id          = g.policy_id
           AND g.policy_id          = f.policy_id
           AND g.item_no            = f.item_no
           AND c.renew_no           = p_renew_no
           AND c.pol_seq_no         = p_pol_seq_no
           AND c.issue_yy           = p_issue_yy
           AND c.iss_cd             = p_pol_iss_cd
           AND c.subline_cd         = p_subline_cd
           AND c.line_cd            = p_line_cd
           --AND c.pol_flag           NOT IN ('4','5')
           AND c.pol_flag           NOT IN ('5')    --kenneth SR4855 100715
           AND trunc(DECODE(TRUNC(NVL(g.from_date,c.eff_date)),TRUNC(c.incept_date), NVL(g.from_date,p_pol_eff_date), NVL(g.from_date,c.eff_date) ))
               <= TRUNC(p_loss_date)
           AND TRUNC(DECODE(NVL(g.to_date,NVL(c.endt_expiry_date, c.expiry_date)),
               c.expiry_date,NVL(g.to_date,p_expiry_date),NVL(g.to_date,c.endt_expiry_date)))  
               >= TRUNC(p_loss_date)
           AND f.beneficiary_no     = p_beneficiary_no
           AND f.item_no            = p_item_no
           AND nvl(c.back_stat, 2)  = 2
           AND c.endt_seq_no        > v_endt_seq_no
         ORDER BY c.endt_seq_no)
      LOOP
        v_beneficiary_no         := p_beneficiary_no;
        v_beneficiary_name       := NVL(get_info2.beneficiary_name,v_beneficiary_name);
        v_beneficiary_addr       := NVL(get_info2.beneficiary_addr,v_beneficiary_addr);
        v_position_cd            := NVL(get_info2.position_cd,v_position_cd);
        v_date_of_birth          := NVL(get_info2.date_of_birth,v_date_of_birth);
        v_age                    := NVL(get_info2.age,v_age);
        v_civil_status           := NVL(get_info2.civil_status,v_civil_status);
        v_sex                    := NVL(get_info2.sex,v_sex);
        v_relation               := NVL(get_info2.relation,v_relation);
        v_endt_seq_no            := get_info2.endt_seq_no;
      END LOOP;
          
          v_ben.item_no          := p_item_no;
          v_ben.grouped_item_no  := 0;
          v_ben.beneficiary_no   := p_beneficiary_no; 
          v_ben.beneficiary_name := v_beneficiary_name;--ailene 06/16/08
          v_ben.beneficiary_addr := v_beneficiary_addr;
          v_ben.position_cd      := v_position_cd;
          v_ben.date_of_birth    := v_date_of_birth;
          v_ben.civil_status     := v_civil_status;
          v_ben.age              := v_age;
          v_ben.sex              := v_sex;
          v_ben.relation         := v_relation;

       -- get positon
       SELECT position
         INTO v_ben.dsp_ben_position
         FROM giis_position
        WHERE position_cd = v_position_cd;
       EXCEPTION
         WHEN NO_DATA_FOUND THEN
            v_ben.dsp_ben_position := NULL;

      --Herbert 112301
      FOR s IN (
        SELECT rv_meaning
          FROM cg_ref_codes
         WHERE rv_low_value =v_civil_status
           AND rv_domain = 'CIVIL STATUS') 
      LOOP
        v_ben.dsp_civil_stat := s.rv_meaning;
      END LOOP;
      
      IF v_sex = 'M' THEN 
        v_ben.dsp_sex := 'Male';
      ELSE 
         v_ben.dsp_sex := 'Female';
      END IF;
      
      PIPE ROW(v_ben);
    END;
        
FUNCTION extract_beneficiary_info_grp(
    p_beneficiary_no          gipi_beneficiary.beneficiary_no%TYPE,
    p_grouped_item_no         gicl_beneficiary_dtl.grouped_item_no%TYPE, 
    p_line_cd                 gipi_polbasic.line_cd%TYPE,
    p_subline_cd              gipi_polbasic.subline_cd%TYPE,
    p_pol_iss_cd              gipi_polbasic.iss_cd%TYPE,
    p_issue_yy                gipi_polbasic.issue_yy%TYPE,
    p_pol_seq_no              gipi_polbasic.pol_seq_no%TYPE,
    p_renew_no                gipi_polbasic.renew_no%TYPE,
    p_pol_eff_date            gipi_polbasic.eff_date%TYPE,
    p_expiry_date             gipi_polbasic.expiry_date%TYPE,
    p_loss_date               gipi_polbasic.expiry_date%TYPE,
    p_item_no                 gipi_item.item_no%TYPE
  ) 
    RETURN beneficiary_dtl_tab PIPELINED
IS
    v_ben                 beneficiary_dtl_type;                
    v_endt_seq_no         gipi_polbasic.endt_seq_no%TYPE;
    previous_item_no      gipi_item.item_no%TYPE := -1;
    v_beneficiary_no      gipi_beneficiary.beneficiary_no%TYPE;
    v_beneficiary_name    gipi_beneficiary.beneficiary_name%TYPE;
    v_beneficiary_addr    gipi_beneficiary.beneficiary_addr%TYPE;
    v_position_cd         gipi_beneficiary.position_cd%TYPE;
    v_position            giis_position.position%TYPE;
    v_date_of_birth       VARCHAR2(20); --gipi_beneficiary.date_of_birth%TYPE; replaced by: Nica 04.26.2012
    v_age                 gipi_beneficiary.age%TYPE;
    v_civil_status        gipi_beneficiary.civil_status%TYPE;
    v_sex                 gipi_beneficiary.sex%TYPE;
    v_relation            gipi_beneficiary.relation%TYPE;
    
    BEGIN
      FOR get_info IN( 
        SELECT c.endt_seq_no endt_seq_no, 
               f.beneficiary_name beneficiary_name,
               f.beneficiary_addr beneficiary_addr,
               --f.date_of_birth date_of_birth, replaced by: Nica 04.26.2013
			   TO_CHAR(f.date_of_birth, 'MM-DD-YYYY')date_of_birth,
               f.civil_status civil_status,
               f.age age,
               f.sex sex,
               f.relation relation
          FROM gipi_polbasic c,
               gipi_grp_items_beneficiary f,
               gipi_item g
         WHERE c.policy_id          = g.policy_id
           AND g.policy_id          = f.policy_id
           AND g.item_no            = f.item_no
           AND c.renew_no           = p_renew_no
           AND c.pol_seq_no         = p_pol_seq_no
           AND c.issue_yy           = p_issue_yy
           AND c.iss_cd             = p_pol_iss_cd
           AND c.subline_cd         = p_subline_cd
           AND c.line_cd            = p_line_cd
           --AND c.pol_flag           NOT IN ('4','5')  --kenneth SR4855 100715
           AND c.pol_flag           NOT IN ('5')
           AND trunc(DECODE(TRUNC(NVL(g.from_date,c.eff_date)),TRUNC(c.incept_date), NVL(g.from_date,p_pol_eff_date), NVL(g.from_date,c.eff_date) ))
               <= TRUNC(p_loss_date)
           AND TRUNC(DECODE(NVL(g.to_date,NVL(c.endt_expiry_date, c.expiry_date)),
               c.expiry_date,NVL(g.to_date,p_expiry_date),NVL(g.to_date,c.endt_expiry_date)))  
               >= TRUNC(p_loss_date)
           AND f.beneficiary_no     = p_beneficiary_no
           AND f.grouped_item_no    = p_grouped_item_no
           AND f.item_no            = p_item_no
         ORDER BY c.eff_date)
      LOOP
        v_beneficiary_no         := p_beneficiary_no;
        v_beneficiary_name       := NVL(get_info.beneficiary_name,v_beneficiary_name);
        v_beneficiary_addr       := NVL(get_info.beneficiary_addr,v_beneficiary_addr);
        v_date_of_birth          := NVL(get_info.date_of_birth,v_date_of_birth);
        v_age                    := NVL(get_info.age,v_age);
        v_civil_status           := NVL(get_info.civil_status,v_civil_status);
        v_sex                    := NVL(get_info.sex,v_sex);
        v_relation               := NVL(get_info.relation,v_relation);
        v_endt_seq_no            := get_info.endt_seq_no;
      END LOOP;
      
      FOR get_info2 IN( 
        SELECT c.endt_seq_no endt_seq_no, 
               f.beneficiary_name beneficiary_name,
               f.beneficiary_addr beneficiary_addr,
               f.date_of_birth date_of_birth,
               f.civil_status civil_status,
               f.age age,
               f.sex sex,
               f.relation relation
          FROM gipi_polbasic c,
               gipi_grp_items_beneficiary f,
               gipi_item g
         WHERE c.policy_id          = g.policy_id
           AND g.policy_id          = f.policy_id
           AND g.item_no            = f.item_no
           AND c.renew_no           = p_renew_no
           AND c.pol_seq_no         = p_pol_seq_no
           AND c.issue_yy           = p_issue_yy
           AND c.iss_cd             = p_pol_iss_cd
           AND c.subline_cd         = p_subline_cd
           AND c.line_cd            = p_line_cd
           --AND c.pol_flag           NOT IN ('4','5')  --kenneth SR4855 100715
           AND c.pol_flag           NOT IN ('5')
           AND trunc(DECODE(TRUNC(NVL(g.from_date,c.eff_date)),TRUNC(c.incept_date), NVL(g.from_date,p_pol_eff_date), NVL(g.from_date,c.eff_date) ))
               <= TRUNC(p_loss_date)
           AND TRUNC(DECODE(NVL(g.to_date,NVL(c.endt_expiry_date, c.expiry_date)),
               c.expiry_date,NVL(g.to_date,p_expiry_date),NVL(g.to_date,c.endt_expiry_date)))  
               >= TRUNC(p_loss_date)
           AND f.beneficiary_no     = p_beneficiary_no
           AND f.grouped_item_no    = p_grouped_item_no
           AND f.item_no            = p_item_no
           AND nvl(c.back_stat, 5)  = 2
           AND c.endt_seq_no        > v_endt_seq_no
         ORDER BY c.endt_seq_no)
      LOOP
        v_beneficiary_no         := p_beneficiary_no;
        v_beneficiary_name       := NVL(get_info2.beneficiary_name,v_beneficiary_name);
        v_beneficiary_addr       := NVL(get_info2.beneficiary_addr,v_beneficiary_addr);
        v_date_of_birth          := NVL(get_info2.date_of_birth,v_date_of_birth);
        v_age                    := NVL(get_info2.age,v_age);
        v_civil_status           := NVL(get_info2.civil_status,v_civil_status);
        v_sex                    := NVL(get_info2.sex,v_sex);
        v_relation               := NVL(get_info2.relation,v_relation);
        v_endt_seq_no            := get_info2.endt_seq_no;
      END LOOP;
      
      v_ben.item_no          := p_item_no;
      v_ben.grouped_item_no  := p_grouped_item_no;
      v_ben.beneficiary_no   := p_beneficiary_no;
      v_ben.beneficiary_name := v_beneficiary_name; -- ailene 06/16/08
      v_ben.beneficiary_addr := v_beneficiary_addr;
      v_ben.position_cd      := NULL;
      v_ben.date_of_birth    := v_date_of_birth;
      v_ben.civil_status     := v_civil_status;
      v_ben.age              := v_age;
      v_ben.sex              := v_sex;
      v_ben.relation         := v_relation;
      v_ben.dsp_ben_position := NULL;

      --Herbert 112301
      FOR s IN (
        SELECT rv_meaning
          FROM cg_ref_codes
         WHERE rv_low_value = v_ben.civil_status
           AND rv_domain = 'CIVIL STATUS') 
      LOOP
        v_ben.dsp_civil_stat := s.rv_meaning;
      END LOOP;
      
      IF v_sex = 'M' THEN 
         v_ben.dsp_sex := 'Male';
      ELSE 
         v_ben.dsp_sex := 'Female';
      END IF;
      
     PIPE ROW (v_ben);
    END;
    
PROCEDURE get_latest_beneficiary_ngrp (
    p_line_cd                 gipi_polbasic.line_cd%TYPE,
    p_subline_cd              gipi_polbasic.subline_cd%TYPE,
    p_pol_iss_cd              gipi_polbasic.iss_cd%TYPE,
    p_issue_yy                gipi_polbasic.issue_yy%TYPE,
    p_pol_seq_no              gipi_polbasic.pol_seq_no%TYPE,
    p_renew_no                gipi_polbasic.renew_no%TYPE,
    p_pol_eff_date            gipi_polbasic.eff_date%TYPE,
    p_expiry_date             gipi_polbasic.expiry_date%TYPE,
    p_loss_date               gipi_polbasic.expiry_date%TYPE,
    p_item_no                 gipi_item.item_no%TYPE,
    v_beneficiary_no    OUT   gipi_beneficiary.beneficiary_no%TYPE,
    v_ben_cnt           OUT   NUMBER
   )
   IS
   BEGIN
      v_beneficiary_no     :=0;
      v_ben_cnt            :=0;
      FOR grp_ben IN(
        SELECT DISTINCT f.beneficiary_no beneficiary_no
          FROM gipi_polbasic c,
               gipi_beneficiary f,
               gipi_item g
         WHERE c.policy_id          = g.policy_id
           AND g.policy_id          = f.policy_id
           AND g.item_no            = f.item_no
           AND c.renew_no           = p_renew_no
           AND c.pol_seq_no         = p_pol_seq_no
           AND c.issue_yy           = p_issue_yy
           AND c.iss_cd             = p_pol_iss_cd
           AND c.subline_cd         = p_subline_cd
           AND c.line_cd            = p_line_cd
           AND trunc(DECODE(TRUNC(NVL(g.from_date,c.eff_date)),TRUNC(c.incept_date), NVL(g.from_date,p_pol_eff_date), NVL(g.from_date,c.eff_date) ))
               <= TRUNC(p_loss_date)
           AND TRUNC(DECODE(NVL(g.to_date,NVL(c.endt_expiry_date, c.expiry_date)),
               c.expiry_date,NVL(g.to_date,p_expiry_date),NVL(g.to_date,c.endt_expiry_date)))  
               >= TRUNC(p_loss_date)
           --AND c.pol_flag          NOT IN ('4','5')   --kenneth SR4855 100715
           AND c.pol_flag          NOT IN ('5')
           AND f.item_no           = p_item_no)
      LOOP 
       v_beneficiary_no    := grp_ben.beneficiary_no;
        v_ben_cnt          := v_ben_cnt + 1;   
        IF v_ben_cnt > 1 THEN
           EXIT;
        END IF;
      END LOOP;
      
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
        v_beneficiary_no := 0;-- exception added by april
   END;

PROCEDURE get_latest_beneficiary_grp( 
    p_line_cd                 gipi_polbasic.line_cd%TYPE,
    p_subline_cd              gipi_polbasic.subline_cd%TYPE,
    p_pol_iss_cd              gipi_polbasic.iss_cd%TYPE,
    p_issue_yy                gipi_polbasic.issue_yy%TYPE,
    p_pol_seq_no              gipi_polbasic.pol_seq_no%TYPE,
    p_renew_no                gipi_polbasic.renew_no%TYPE,
    p_pol_eff_date            gipi_polbasic.eff_date%TYPE,
    p_expiry_date             gipi_polbasic.expiry_date%TYPE,
    p_loss_date               gipi_polbasic.expiry_date%TYPE,
    p_item_no                 gipi_item.item_no%TYPE,
    p_grouped_item_no         gicl_beneficiary_dtl.grouped_item_no%TYPE,
    v_beneficiary_no    OUT   gipi_beneficiary.beneficiary_no%TYPE,
    v_ben_cnt           OUT   NUMBER)
    
    IS
    BEGIN
        v_beneficiary_no     :=0;
        v_ben_cnt            :=0;
      FOR grp_ben IN(
        SELECT DISTINCT f.beneficiary_no beneficiary_no
          FROM gipi_polbasic c,
               gipi_grp_items_beneficiary f,
               gipi_item g
         WHERE c.policy_id         = g.policy_id
           AND g.policy_id         = f.policy_id
           AND g.item_no           = f.item_no
           AND c.renew_no          = p_renew_no
           AND c.pol_seq_no        = p_pol_seq_no
           AND c.issue_yy          = p_issue_yy
           AND c.iss_cd            = p_pol_iss_cd
           AND c.subline_cd        = p_subline_cd
           AND c.line_cd           = p_line_cd
           AND trunc(DECODE(TRUNC(NVL(g.from_date,c.eff_date)),TRUNC(c.incept_date), NVL(g.from_date,p_pol_eff_date), NVL(g.from_date,c.eff_date) ))
               <= TRUNC(p_loss_date)
           AND TRUNC(DECODE(NVL(g.to_date,NVL(c.endt_expiry_date, c.expiry_date)),
               c.expiry_date,NVL(g.to_date,p_expiry_date),NVL(g.to_date,c.endt_expiry_date)))  
               >= TRUNC(p_loss_date)
           --AND c.pol_flag          NOT IN ('4','5')   --kenneth SR4855 100715
           AND c.pol_flag          NOT IN ('5')
           AND f.grouped_item_no   = p_grouped_item_no
           AND f.item_no           = p_item_no)
      LOOP 
        v_beneficiary_no     :=grp_ben.beneficiary_no;
        v_ben_cnt            :=v_ben_cnt + 1;   
        IF v_ben_cnt > 1 THEN
           EXIT;
        END IF;
      END LOOP;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
         v_beneficiary_no := 0;-- exception added by april
    END;

FUNCTION EXTRACT_LATEST_AHDATA_1GRP(
    p_grp_cnt        gipi_grouped_items.grouped_item_no%TYPE,
    p_line_cd        gipi_polbasic.line_cd%TYPE,
    p_subline_cd     gipi_polbasic.subline_cd%TYPE,
    p_pol_iss_cd     gipi_polbasic.iss_cd%TYPE,
    p_issue_yy       gipi_polbasic.issue_yy%TYPE,
    p_pol_seq_no     gipi_polbasic.pol_seq_no%TYPE,
    p_renew_no       gipi_polbasic.renew_no%TYPE,
    p_pol_eff_date   gipi_polbasic.eff_date%TYPE,
    p_expiry_date    gipi_polbasic.expiry_date%TYPE,
    p_loss_date      gipi_polbasic.expiry_date%TYPE,
    p_item_no        gipi_item.item_no%TYPE,
    p_iss_cd         gipi_polbasic.iss_cd%TYPE
    ) 
      RETURN gicl_accident_dtl_tab PIPELINED
IS
    vitem                            gicl_accident_dtl_type;
    v_item_desc                      gicl_clm_item.item_desc%TYPE;
    v_item_desc2                     gicl_clm_item.item_desc2%TYPE;  
    previous_item_no                 gipi_item.item_no%TYPE := -1;
    v_item_no                        gipi_item.item_no%TYPE;
    v_item_title                     gipi_item.item_title%TYPE;
    v_grouped_item_no                gipi_grouped_items.grouped_item_no%TYPE;
    v_grouped_item_title             gipi_grouped_items.grouped_item_title%TYPE;
    v_currency_cd                    gipi_item.currency_cd%TYPE;
    v_currency_rt                    gipi_item.currency_rt%TYPE;
    v_currency_desc                  giis_currency.currency_desc%TYPE;
    v_position_cd                    gipi_accident_item.position_cd%TYPE;
    v_position                       giis_position.position%TYPE;
    v_level_cd                       gipi_accident_item.level_cd%TYPE;
    v_monthly_salary                 gipi_accident_item.monthly_salary%TYPE;
    v_salary_grade                   gipi_accident_item.salary_grade%TYPE;
    v_amount_coverage                gipi_grouped_items.amount_coverage%TYPE;
    v_date_of_birth                  gipi_accident_item.date_of_birth%TYPE;
    v_age                            gipi_accident_item.age%TYPE;
    v_civil_status                   gipi_accident_item.civil_status%TYPE;
    v_sex                            gipi_accident_item.sex%TYPE;
    v_endt_seq_no                     gipi_polbasic.endt_seq_no%TYPE;
    v_control_type_cd                gipi_grouped_items.control_type_cd%TYPE;
    v_control_cd                     gipi_grouped_items.control_cd%TYPE;

  BEGIN

      IF p_grp_cnt = 0 THEN
        FOR get_item_dtl IN(
            SELECT b.item_desc,b.item_desc2,c.endt_seq_no endt_seq_no, b.item_title item_title,
                   b.currency_cd currency_cd,
                   b.currency_rt currency_rt,
                   a.position_cd position_cd,
                   a.level_cd level_cd,
                   a.monthly_salary monthly_salary,
                   a.salary_grade salary_grade,
                   a.date_of_birth date_of_birth,
                   a.age age,
                   a.civil_status civil_status,
                   a.sex sex
             FROM gipi_polbasic c,
                  gipi_item b,
                  gipi_accident_item a    
            WHERE c.policy_id     = b.policy_id
              AND b.policy_id     = a.policy_id(+)
              AND b.item_no       = a.item_no(+)
              AND c.renew_no      = p_renew_no
              AND c.pol_seq_no    = p_pol_seq_no
              AND c.issue_yy      = p_issue_yy
              AND c.iss_cd        = p_pol_iss_cd
              AND c.subline_cd    = p_subline_cd
              AND c.line_cd       = p_line_cd
              --AND c.pol_flag      NOT IN ('4','5') --kenneth SR4855 100715
              AND c.pol_flag      NOT IN ('5')
              AND b.item_no       = p_item_no
              AND trunc(DECODE(TRUNC(NVL(b.from_date,c.eff_date)),
                                               TRUNC(NVL(b.from_date,c.incept_date)), 
                                               TRUNC(NVL(b.from_date,p_pol_eff_date)), 
                                               TRUNC(NVL(b.from_date,c.eff_date)) ))
                                     <= TRUNC(p_loss_date)
              AND TRUNC(DECODE(TRUNC(NVL(b.to_date,NVL(c.endt_expiry_date, c.expiry_date))),
                                     TRUNC(NVL(b.to_date,c.expiry_date)),
                                     TRUNC(NVL(b.to_date,p_expiry_date)),
                                     TRUNC(NVL(b.to_date,c.endt_expiry_date)) ))  
                                     >= TRUNC(p_loss_date)
         ORDER BY c.eff_date) 
         
         LOOP 
           v_item_desc                   := NVL(get_item_dtl.item_desc,v_item_desc);
           v_item_desc2                  := NVL(get_item_dtl.item_desc2,v_item_desc2);
           v_endt_seq_no                 := get_item_dtl.endt_seq_no;
           v_item_title                  := NVL(get_item_dtl.item_title,v_item_title);
           v_grouped_item_no             := 0;
           v_currency_cd                 := NVL(get_item_dtl.currency_cd,v_currency_cd);
           v_currency_rt                 := NVL(get_item_dtl.currency_rt,v_currency_rt);
           v_position_cd                 := NVL(get_item_dtl.position_cd,v_position_cd);
           v_level_cd                    := NVL(get_item_dtl.level_cd,v_level_cd);
           v_monthly_salary              := NVL(get_item_dtl.monthly_salary,v_monthly_salary);
           v_salary_grade                := NVL(get_item_dtl.salary_grade,v_salary_grade);
           v_date_of_birth               := NVL(get_item_dtl.date_of_birth,v_date_of_birth);
           v_age                         := NVL(get_item_dtl.age,v_age);
           v_civil_status                := NVL(get_item_dtl.civil_status,v_civil_status);
           v_sex                         := NVL(get_item_dtl.sex,v_sex);
         END LOOP;
         
         FOR get_item_dtl2 IN(
           SELECT b.item_desc,b.item_desc2,b.item_title item_title,
                  b.currency_cd currency_cd,
                  b.currency_rt currency_rt,
                  a.position_cd position_cd,
                  a.level_cd level_cd,
                  a.monthly_salary monthly_salary,
                  a.salary_grade salary_grade,
                  a.date_of_birth date_of_birth,
                  a.age age,
                  a.civil_status civil_status,
                  a.sex sex
            FROM gipi_polbasic c,
                 gipi_item b,
                 gipi_accident_item a    
           WHERE c.policy_id = b.policy_id
             AND b.policy_id     = a.policy_id(+)
             AND b.item_no       = a.item_no(+)
             AND c.renew_no      = p_renew_no
             AND c.pol_seq_no    = p_pol_seq_no
             AND c.issue_yy      = p_issue_yy
             AND c.iss_cd        = p_pol_iss_cd
             AND c.subline_cd    = p_subline_cd
             AND c.line_cd       = p_line_cd
             --AND c.pol_flag      NOT IN ('4','5') --kenneth SR4855 100715
              AND c.pol_flag      NOT IN ('5')
             AND b.item_no       = p_item_no
             AND trunc(DECODE(TRUNC(NVL(b.from_date,c.eff_date)),
                                               TRUNC(NVL(b.from_date,c.incept_date)), 
                                               TRUNC(NVL(b.from_date,p_pol_eff_date)), 
                                               TRUNC(NVL(b.from_date,c.eff_date)) ))
                                           <= TRUNC(p_loss_date)
             AND TRUNC(DECODE(TRUNC(NVL(b.to_date,NVL(c.endt_expiry_date, c.expiry_date))),
                                             TRUNC(NVL(b.to_date,c.expiry_date)),
                                             TRUNC(NVL(b.to_date,p_expiry_date)),
                                             TRUNC(NVL(b.to_date,c.endt_expiry_date)) ))  
                                             >= TRUNC(p_loss_date)
             AND nvl(c.back_stat,5) = 2
             AND c.endt_seq_no > v_endt_seq_no
        ORDER BY c.endt_seq_no) 
         LOOP   
           v_item_desc                   := NVL(get_item_dtl2.item_desc,v_item_desc);
           v_item_desc2                  := NVL(get_item_dtl2.item_desc2,v_item_desc2);
           v_item_title                  := NVL(get_item_dtl2.item_title,v_item_title);
           v_grouped_item_no             := 0;
           v_currency_cd                 := NVL(get_item_dtl2.currency_cd,v_currency_cd);
           v_currency_rt                 := NVL(get_item_dtl2.currency_rt,v_currency_rt);
           v_position_cd                 := NVL(get_item_dtl2.position_cd,v_position_cd);
           v_level_cd                    := NVL(get_item_dtl2.level_cd,v_level_cd);
           v_monthly_salary              := NVL(get_item_dtl2.monthly_salary,v_monthly_salary);
           v_salary_grade                := NVL(get_item_dtl2.salary_grade,v_salary_grade);
           v_date_of_birth               := NVL(get_item_dtl2.date_of_birth,v_date_of_birth);
           v_age                         := NVL(get_item_dtl2.age,v_age);
           v_civil_status                := NVL(get_item_dtl2.civil_status,v_civil_status);
           v_sex                         := NVL(get_item_dtl2.sex,v_sex);
         END LOOP;
      ELSE    
        FOR get_item_dtl IN ( 
            SELECT b.item_desc,b.item_desc2,c.endt_seq_no endt_seq_no, b.item_title item_title,
                   e.grouped_item_title grouped_item_title,
                   b.currency_cd currency_cd,
                   b.currency_rt currency_rt,
                   e.position_cd position_cd,
                   a.level_cd level_cd,
                   e.salary monthly_salary,
                   e.salary_grade salary_grade,
                   e.amount_coverage amount_coverage,
                   e.date_of_birth date_of_birth,
                   e.age age,
                   e.civil_status civil_status,
                   e.sex sex,
                  /*added by gmi*/
                   e.control_type_cd control_type_cd,
                   e.control_cd control_cd
                  /* -- */
             FROM gipi_polbasic c,
                  gipi_grouped_items e,
                  gipi_item b,
                  gipi_accident_item a
            WHERE c.policy_id          = b.policy_id
              AND b.policy_id          = a.policy_id(+)
              AND b.item_no            = a.item_no(+)
              AND b.policy_id          = e.policy_id (+)
              AND b.item_no            = e.item_no (+)
              AND c.renew_no           = p_renew_no
              AND c.pol_seq_no         = p_pol_seq_no
              AND c.issue_yy           = p_issue_yy
              AND c.iss_cd             = p_pol_iss_cd
              AND c.subline_cd         = p_subline_cd
              AND c.line_cd            = p_line_cd
              AND trunc(DECODE(TRUNC(NVL(e.from_date,NVL(b.from_date,c.eff_date))),
                                             TRUNC(NVL(e.from_date,NVL(b.from_date,c.incept_date))), 
                                             TRUNC(NVL(e.from_date,NVL(b.from_date,p_pol_eff_date))), 
                                             TRUNC(NVL(e.from_date,NVL(b.from_date,c.eff_date))) ))
                                            <= TRUNC(p_loss_date)
              AND TRUNC(DECODE(TRUNC(NVL(e.to_date,NVL(b.to_date,NVL(c.endt_expiry_date, c.expiry_date)))),
                                            TRUNC(NVL(e.to_date,NVL(b.to_date,c.expiry_date))),
                                            TRUNC(NVL(e.to_date,NVL(b.to_date,p_expiry_date))),
                                            TRUNC(NVL(e.to_date,NVL(b.to_date,c.endt_expiry_date))) ))  
                                            >= TRUNC(p_loss_date)
              --AND c.pol_flag      NOT IN ('4','5') --kenneth SR4855 100715
              AND c.pol_flag      NOT IN ('5')
              AND e.grouped_item_no (+)= p_grp_cnt
              AND b.item_no            = p_item_no       
         ORDER BY c.eff_date) 
         
         LOOP
           v_item_desc                   := NVL(get_item_dtl.item_desc,v_item_desc);
           v_item_desc2                  := NVL(get_item_dtl.item_desc2,v_item_desc2);
           v_item_title                  := NVL(get_item_dtl.item_title,v_item_title);
           v_currency_cd                 := NVL(get_item_dtl.currency_cd,v_currency_cd);
           v_currency_rt                 := NVL(get_item_dtl.currency_rt,v_currency_rt);
           v_position_cd                 := NVL(get_item_dtl.position_cd,v_position_cd);
           v_level_cd                    := NVL(get_item_dtl.level_cd,v_level_cd);
           v_monthly_salary              := NVL(get_item_dtl.monthly_salary,v_monthly_salary);
           v_salary_grade                := NVL(get_item_dtl.salary_grade,v_salary_grade);
           v_date_of_birth               := NVL(get_item_dtl.date_of_birth,v_date_of_birth);
           v_age                         := NVL(get_item_dtl.age,v_age);
           v_civil_status                := NVL(get_item_dtl.civil_status,v_civil_status);
           v_sex                         := NVL(get_item_dtl.sex,v_sex);
           v_amount_coverage             := NVL(get_item_dtl.amount_coverage,v_amount_coverage); 
           v_grouped_item_title          := NVL(get_item_dtl.grouped_item_title,v_grouped_item_title);
           v_endt_seq_no                 := get_item_dtl.endt_seq_no;
           /* added by gmi */
           v_control_type_cd             := NVL(get_item_dtl.control_type_cd,v_control_type_cd);
           v_control_cd                  := NVL(get_item_dtl.control_cd,v_control_cd);
           /* -- */
         END LOOP;
         
         FOR get_item_dtl2 IN ( 
           SELECT b.item_desc,b.item_desc2,b.item_title item_title,
                  e.grouped_item_title grouped_item_title,
                  b.currency_cd currency_cd,
                  b.currency_rt currency_rt,
                  e.position_cd position_cd,
                  a.level_cd level_cd,
                  e.salary monthly_salary,
                  e.salary_grade salary_grade,
                  e.amount_coverage amount_coverage,
                  e.date_of_birth date_of_birth,
                  e.age age,
                  e.civil_status civil_status,
                  e.sex sex,
                  /*added by gmi*/
                  e.control_type_cd control_type_cd,
                  e.control_cd control_cd
                  /* -- */
            FROM gipi_polbasic c,
                 gipi_grouped_items e,
                 gipi_item b,
                 gipi_accident_item a
           WHERE c.policy_id          = b.policy_id
            AND b.policy_id          = a.policy_id(+)
            AND b.item_no            = a.item_no(+)
            AND b.policy_id          = e.policy_id (+)
            AND b.item_no            = e.item_no (+)
            AND c.renew_no           = p_renew_no
            AND c.pol_seq_no         = p_pol_seq_no
            AND c.issue_yy           = p_issue_yy
            AND c.iss_cd             = p_pol_iss_cd
            AND c.subline_cd         = p_subline_cd
            AND c.line_cd            = p_line_cd
            AND trunc(DECODE(TRUNC(NVL(e.from_date,NVL(b.from_date,c.eff_date))),
                                         TRUNC(NVL(e.from_date,NVL(b.from_date,c.incept_date))), 
                                         TRUNC(NVL(e.from_date,NVL(b.from_date,p_pol_eff_date))), 
                                         TRUNC(NVL(e.from_date,NVL(b.from_date,c.eff_date))) ))
                                     <= TRUNC(p_loss_date)
            AND TRUNC(DECODE(TRUNC(NVL(e.from_date,NVL(b.to_date,NVL(c.endt_expiry_date, c.expiry_date)))),
                                     TRUNC(NVL(e.from_date,NVL(b.to_date,c.expiry_date))),
                                     TRUNC(NVL(e.from_date,NVL(b.to_date,p_expiry_date))),
                                     TRUNC(NVL(e.from_date,NVL(b.to_date,c.endt_expiry_date))) ))  
                                     >= TRUNC(p_loss_date)
            --AND c.pol_flag      NOT IN ('4','5') --kenneth SR4855 100715
              AND c.pol_flag      NOT IN ('5')
            AND e.grouped_item_no (+)= p_grp_cnt
            AND b.item_no            = p_item_no
            AND NVL(c.back_stat,5) = 2
            AND c.endt_seq_no > v_endt_seq_no       
       ORDER BY c.endt_seq_no) 
         
        LOOP
           v_item_desc                   := NVL(get_item_dtl2.item_desc,v_item_desc);
           v_item_desc2                  := NVL(get_item_dtl2.item_desc2,v_item_desc2);
           v_item_title                  := NVL(get_item_dtl2.item_title,v_item_title);
           v_currency_cd                 := NVL(get_item_dtl2.currency_cd,v_currency_cd);
           v_currency_rt                 := NVL(get_item_dtl2.currency_rt,v_currency_rt);
           v_position_cd                 := NVL(get_item_dtl2.position_cd,v_position_cd);
           v_level_cd                    := NVL(get_item_dtl2.level_cd,v_level_cd);
           v_monthly_salary              := NVL(get_item_dtl2.monthly_salary,v_monthly_salary);
           v_salary_grade                := NVL(get_item_dtl2.salary_grade,v_salary_grade);
           v_date_of_birth               := NVL(get_item_dtl2.date_of_birth,v_date_of_birth);
           v_age                         := NVL(get_item_dtl2.age,v_age);
           v_civil_status                := NVL(get_item_dtl2.civil_status,v_civil_status);
           v_sex                         := NVL(get_item_dtl2.sex,v_sex);
           v_amount_coverage             := NVL(get_item_dtl2.amount_coverage,v_amount_coverage); 
           v_grouped_item_title          := NVL(get_item_dtl2.grouped_item_title,v_grouped_item_title);
           /* added by gmi */
           v_control_type_cd             := NVL(get_item_dtl2.control_type_cd,v_control_type_cd);
           v_control_cd                  := NVL(get_item_dtl2.control_cd,v_control_cd);
           /* -- */
        END LOOP;
      END IF;
      
      vitem.item_title         := v_item_title;
      vitem.item_desc          := v_item_desc; 
      vitem.item_desc2         := v_item_desc2;
      vitem.item_no            := p_item_no;
      vitem.grouped_item_no    := p_grp_cnt; 
      vitem.grouped_item_title := v_grouped_item_title;
      vitem.currency_cd        := v_currency_cd;
      vitem.currency_rate      := v_currency_rt;
      vitem.position_cd        := v_position_cd;
      vitem.level_cd           := v_level_cd;
      vitem.monthly_salary     := v_monthly_salary;
      vitem.salary_grade       := v_salary_grade;
      vitem.amount_coverage    := v_amount_coverage;
      vitem.date_of_birth      := v_date_of_birth;
      vitem.age                := v_age;
      vitem.civil_status       := v_civil_status;
      vitem.sex                := v_sex;
      vitem.control_type_cd    := v_control_type_cd;
      vitem.control_cd         := v_control_cd;
      
      BEGIN
        SELECT control_type_desc 
          INTO vitem.dsp_control_type
          FROM giis_control_type
         WHERE control_type_cd = v_control_type_cd;
      EXCEPTION
        WHEN OTHERS THEN
          v_currency_desc := NULL;
      END;  
      BEGIN
        SELECT currency_desc 
          INTO vitem.dsp_currency
          FROM giis_currency
         WHERE main_currency_cd = v_currency_cd;
      EXCEPTION
        WHEN OTHERS THEN
          v_currency_desc := NULL;
      END;
      BEGIN
        SELECT position
          INTO vitem.dsp_position
          FROM giis_position
         WHERE position_cd = v_position_cd;
      EXCEPTION
        WHEN OTHERS THEN
          v_position := NULL;
      END; 
      FOR s IN (
        SELECT rv_meaning
          FROM cg_ref_codes
         WHERE rv_low_value = v_civil_status
           AND rv_domain = 'CIVIL STATUS') 
      LOOP
        vitem.dsp_civil_stat := s.rv_meaning;
      END LOOP;

     IF v_sex =  'M' THEN
        vitem.dsp_sex := 'Male';
     ELSIF v_sex =  'F' THEN
        vitem.dsp_sex := 'Female';
     END IF;
     
     PIPE ROW (vitem);
  END;
  
FUNCTION cnt_beneficiary (
    p_line_cd                 gipi_polbasic.line_cd%TYPE,
    p_subline_cd              gipi_polbasic.subline_cd%TYPE,
    p_pol_iss_cd              gipi_polbasic.iss_cd%TYPE,
    p_issue_yy                gipi_polbasic.issue_yy%TYPE,
    p_pol_seq_no              gipi_polbasic.pol_seq_no%TYPE,
    p_renew_no                gipi_polbasic.renew_no%TYPE,
    p_pol_eff_date            gipi_polbasic.eff_date%TYPE,
    p_expiry_date             gipi_polbasic.expiry_date%TYPE,
    p_loss_date               gipi_polbasic.expiry_date%TYPE,
    p_item_no                 gipi_item.item_no%TYPE,
    p_claim_id                gicl_accident_dtl.claim_id%TYPE,
    p_grouped_item_no         GICL_ACCIDENT_DTL.GROUPED_ITEM_NO%TYPE
    )
    RETURN VARCHAR2
IS
    variables_v_cnt_ben NUMBER :=0;
    BEGIN
        FOR i IN (SELECT DISTINCT e.beneficiary_no beneficiary_no, e.beneficiary_name beneficiary_name 
                    FROM gicl_claims d, gipi_polbasic c, gipi_item b, gipi_accident_item a, gipi_beneficiary e 
                   WHERE c.policy_id = b.policy_id 
                    AND b.policy_id = a.policy_id 
                    AND b.item_no = a.item_no 
                    AND b.policy_id = e.policy_id 
                    AND b.item_no = e.item_no 
                    AND c.renew_no = p_renew_no 
                    AND c.pol_seq_no = p_pol_seq_no 
                    AND c.issue_yy = p_issue_yy 
                    AND c.iss_cd = p_pol_iss_cd 
                    AND c.subline_cd = p_subline_cd 
                    AND c.line_cd = p_line_cd 
                    AND TRUNC(c.eff_date) <= p_loss_date 
                    AND c.pol_flag not in ('4','5')
                    AND b.item_no = p_item_no 
                    AND d.claim_id = p_claim_id 
                   UNION
                   SELECT DISTINCT f.beneficiary_no beneficiary_no, f.beneficiary_name beneficiary_name 
                     FROM gicl_claims d, gipi_polbasic c, gipi_grouped_items e, gipi_grp_items_beneficiary f, gipi_item b, gipi_accident_item a 
                    WHERE c.policy_id = b.policy_id 
                      AND b.policy_id = e.policy_id 
                      AND b.item_no = e.item_no 
                      AND e.policy_id = f.policy_id 
                      AND e.item_no = f.item_no 
                      AND e.grouped_item_no = f.grouped_item_no 
                      AND c.renew_no = p_renew_no 
                      AND c.pol_seq_no = p_pol_seq_no 
                      AND c.issue_yy = p_issue_yy 
                      AND c.iss_cd = p_pol_iss_cd 
                      AND c.subline_cd = p_subline_cd    
                      AND c.line_cd = p_line_cd 
                      AND TRUNC(c.eff_date) <= p_loss_date 
                      AND c.pol_flag not in ('4','5') 
                      AND e.grouped_item_no = p_grouped_item_no 
                      AND b.item_no = p_item_no 
                      AND d.claim_id = p_claim_id 
                      AND f.beneficiary_no not in (SELECT beneficiary_no 
                                                     FROM gicl_beneficiary_dtl 
                                                    WHERE claim_id = p_claim_id 
                                                      AND item_no = p_item_no 
                                                      AND grouped_item_no = p_grouped_item_no)) 
         LOOP
             variables_v_cnt_ben := variables_v_cnt_ben + 1;
         END LOOP;
         
         RETURN variables_v_cnt_ben;
    END;
    
PROCEDURE check_del_sw(
    p_line_cd                 gipi_polbasic.line_cd%TYPE,
    p_subline_cd              gipi_polbasic.subline_cd%TYPE,
    p_pol_iss_cd              gipi_polbasic.iss_cd%TYPE,
    p_issue_yy                gipi_polbasic.issue_yy%TYPE,
    p_pol_seq_no              gipi_polbasic.pol_seq_no%TYPE,
    p_renew_no                gipi_polbasic.renew_no%TYPE,
    p_pol_eff_date            gipi_polbasic.eff_date%TYPE,
    p_expiry_date             gipi_polbasic.expiry_date%TYPE,
    p_loss_date               gipi_polbasic.expiry_date%TYPE,
    p_item_no                 gipi_item.item_no%TYPE,
    p_claim_id                gicl_accident_dtl.claim_id%TYPE,
    p_grouped_item_no         gicl_accident_dtl.GROUPED_ITEM_NO%TYPE,
    p_iss_cd                  gipi_polbasic.iss_cd%TYPE,  
    c017                OUT   gicl_accident_dtl_cur,
    c017b               OUT   beneficiary_dtl_cur
    )
IS                            
    v_del_sw                VARCHAR2(1);
    variables_v_cnt_ben     NUMBER;
    v_endt_seq_no           NUMBER := 0;
    v_beneficiary_no        NUMBER ;
    v_ben_cnt               NUMBER ;
     
    BEGIN
        FOR get_max IN (
           SELECT a.endt_seq_no, c.delete_sw
             FROM gipi_polbasic a, gipi_grouped_items c 
            WHERE a.policy_id       = c.policy_id
              AND a.line_cd         = p_line_cd
              AND a.subline_cd      = p_subline_cd
              AND a.iss_cd          = p_pol_iss_cd
              AND a.issue_yy        = p_issue_yy
              AND a.pol_seq_no      = p_pol_seq_no
              AND a.renew_no        = p_renew_no
              AND a.pol_flag        NOT IN ('4','5')
              AND c.grouped_item_no = p_grouped_item_no
              AND c.item_no         = p_item_no
              AND trunc(DECODE(TRUNC(NVL(c.from_date,a.eff_date)),
                                               TRUNC(NVL(c.from_date,a.incept_date)), 
                                               TRUNC(NVL(c.from_date,p_pol_eff_date)), 
                                               TRUNC(NVL(c.from_date,a.eff_date)) )) 
                                           <= TRUNC(p_loss_date)
                      AND TRUNC(DECODE(TRUNC(NVL(c.to_date,NVL(a.endt_expiry_date, a.expiry_date))),
                                              TRUNC(NVL(c.to_date,a.expiry_date)),
                                              TRUNC(NVL(c.to_date,p_expiry_date)),
                                              TRUNC(NVL(c.to_date,a.endt_expiry_date)) ))  
                                              >= TRUNC(p_loss_date)
           ORDER BY a.eff_date desc)
         LOOP
           v_del_sw := get_max.delete_sw;
           FOR get_del_sw IN (
             SELECT c.delete_sw
               FROM gipi_polbasic a, gipi_grouped_items c 
              WHERE a.policy_id       = c.policy_id
                AND a.line_cd         = p_line_cd
                AND a.subline_cd      = p_subline_cd
                AND a.iss_cd          = p_pol_iss_cd
                AND a.issue_yy        = p_issue_yy
                AND a.pol_seq_no      = p_pol_seq_no
                AND a.renew_no        = p_renew_no
                AND c.grouped_item_no = p_grouped_item_no
                AND c.item_no         = p_item_no
                AND trunc(DECODE(TRUNC(NVL(c.from_date,a.eff_date)),
                                                 TRUNC(NVL(c.from_date,a.incept_date)), 
                                                 TRUNC(NVL(c.from_date,p_pol_eff_date)), 
                                                 TRUNC(NVL(c.from_date,a.eff_date)) )) 
                                             <= TRUNC(p_loss_date)
                        AND TRUNC(DECODE(TRUNC(NVL(c.to_date,NVL(a.endt_expiry_date, a.expiry_date))),
                                               TRUNC(NVL(c.to_date,a.expiry_date)),
                                               TRUNC(NVL(c.to_date,p_expiry_date)),
                                               TRUNC(NVL(c.to_date,a.endt_expiry_date)) ))  
                                                >= TRUNC(p_loss_date)
                AND nvl(a.back_stat,5) = 2
                AND a.endt_seq_no > v_endt_seq_no
              ORDER BY a.endt_seq_no desc)
           LOOP
             v_del_sw := get_del_sw.delete_sw;
             EXIT;
           END LOOP;
           EXIT;
         END LOOP; 
         
         --cnt_beneficiary; --ailene 061808 to count the number of beneficiary for the grouped item/item no.
         variables_v_cnt_ben := GICL_ACCIDENT_DTL_PKG.cnt_beneficiary(p_line_cd,                 
                                                                      p_subline_cd,              
                                                                      p_pol_iss_cd,              
                                                                      p_issue_yy,                
                                                                      p_pol_seq_no,              
                                                                      p_renew_no,                
                                                                      p_pol_eff_date,            
                                                                      p_expiry_date,             
                                                                      p_loss_date,               
                                                                      p_item_no,                 
                                                                      p_claim_id,
                                                                      p_grouped_item_no);
                                                                      
         IF (v_del_sw = 'N' OR v_del_sw IS NULL) THEN 
         --extract_latest_ahdata_1grp(p_grouped_item_no);
            OPEN c017 FOR
                SELECT *
                  FROM TABLE(gicl_accident_dtl_pkg.extract_latest_ahdata_1grp(p_grouped_item_no,
                                                                              p_line_cd,        
                                                                              p_subline_cd,     
                                                                              p_pol_iss_cd,     
                                                                              p_issue_yy,       
                                                                              p_pol_seq_no,     
                                                                              p_renew_no,       
                                                                              p_pol_eff_date,   
                                                                              p_expiry_date,    
                                                                              p_loss_date,      
                                                                              p_item_no,        
                                                                              p_iss_cd
                                                                              ));
         --added by ailene 061808 
         /****to fetch the beneficiary information if the beneficiary 
             count is equal to 1  ****/
           IF variables_v_cnt_ben = 1 THEN
              v_beneficiary_no :=0;
              v_ben_cnt        :=0;
                  GICL_ACCIDENT_DTL_PKG.get_latest_beneficiary_grp(p_line_cd,          
                                                                   p_subline_cd,       
                                                                   p_pol_iss_cd,       
                                                                   p_issue_yy,         
                                                                   p_pol_seq_no,       
                                                                   p_renew_no,         
                                                                   p_pol_eff_date,     
                                                                   p_expiry_date,      
                                                                   p_loss_date,        
                                                                   p_item_no,          
                                                                   p_grouped_item_no,
                                                                   v_beneficiary_no,
                                                                   v_ben_cnt);  
                IF v_ben_cnt = 1 THEN
                    OPEN c017b FOR
                        SELECT *
                          FROM TABLE (GICL_ACCIDENT_DTL_PKG.extract_beneficiary_info_grp(v_beneficiary_no,          
                                                                                        p_grouped_item_no,         
                                                                                        p_line_cd,                 
                                                                                        p_subline_cd,              
                                                                                        p_pol_iss_cd,              
                                                                                        p_issue_yy,                
                                                                                        p_pol_seq_no,              
                                                                                        p_renew_no,                
                                                                                        p_pol_eff_date,            
                                                                                        p_expiry_date,             
                                                                                        p_loss_date,               
                                                                                        p_item_no    ));
                ELSE 
                    OPEN c017b FOR
                        SELECT null claim_id, null item_no, null grouped_item_no, 
                           null beneficiary_no, null beneficiary_name,null beneficiary_addr, 
                           null position_cd, null position, null date_of_birth, null age, null civil_status, 
                           null sex, null relation, null dsp_civil_stat, null dsp_ben_position, null dsp_sex
                      FROM DUAL;   
                END IF;   
           END IF;

        ELSE
            OPEN c017 FOR
             SELECT null claim_id, null item_no, null item_title, null grouped_item_no, null grouped_item_title,     
                    null currency_cd, null dsp_currency ,null currency_rate, null position_cd, null dsp_position,           
                    null monthly_salary, null dsp_control_type, null control_cd, null control_type_cd, null item_desc,              
                    null item_desc2, null level_cd, null salary_grade, null date_of_birth, null civil_status, null dsp_civil_stat,         
                    null sex, null dsp_sex, null age, null amount_coverage, null gicl_item_peril_exist, null gicl_mortgagee_exist,   
                    null gicl_item_peril_msg
               FROM dual;
         END IF;  
             
    EXCEPTION
       WHEN OTHERS THEN
          NULL;
    END;
    
PROCEDURE check_grp_item_no (
    p_line_cd                 gipi_polbasic.line_cd%TYPE,
    p_subline_cd              gipi_polbasic.subline_cd%TYPE,
    p_pol_iss_cd              gipi_polbasic.iss_cd%TYPE,
    p_issue_yy                gipi_polbasic.issue_yy%TYPE,
    p_pol_seq_no              gipi_polbasic.pol_seq_no%TYPE,
    p_renew_no                gipi_polbasic.renew_no%TYPE,
    p_pol_eff_date            gipi_polbasic.eff_date%TYPE,
    p_expiry_date             gipi_polbasic.expiry_date%TYPE,
    p_loss_date               gipi_polbasic.expiry_date%TYPE,
    p_item_no                 gipi_item.item_no%TYPE,
    p_grouped_item_no         gicl_accident_dtl.grouped_item_no%TYPE,
    p_claim_id                gicl_accident_dtl.claim_id%TYPE,
    p_exist             OUT   VARCHAR2,
    p_valid             OUT   VARCHAR2
    ) 
IS
    BEGIN
       
        BEGIN
            p_exist := 'N';
            FOR gpa_exists IN (SELECT '1'
                                 FROM gipi_polbasic c,
                                      gipi_grouped_items e,
                                      gipi_item b --,gipi_accident_item a
                                WHERE c.policy_id     = b.policy_id
                                  AND b.item_no       = p_item_no
                                  AND b.policy_id     = e.policy_id 
                                  AND b.item_no       = e.item_no 
                                  AND c.renew_no      = p_renew_no
                                  AND c.pol_seq_no    = p_pol_seq_no
                                  AND c.issue_yy      = p_issue_yy
                                  AND c.iss_cd        = p_pol_iss_cd
                                  AND c.subline_cd    = p_subline_cd
                                  AND c.line_cd       = p_line_cd                  
                                  AND trunc(DECODE(TRUNC(NVL(e.from_date,NVL(b.from_date,c.eff_date))),
                                                                 TRUNC(NVL(e.from_date,NVL(b.from_date,c.incept_date))),
                                                                                     TRUNC(NVL(e.from_date,NVL(b.from_date,p_pol_eff_date))), 
                                                                   TRUNC(NVL(e.from_date,NVL(b.from_date,c.eff_date))) )) 
                                                                   <= TRUNC(p_loss_date)
                                  AND TRUNC(DECODE(TRUNC(NVL(e.to_date,NVL(b.to_date,NVL(c.endt_expiry_date,c.expiry_date)))), 
                                                                     TRUNC(NVL(e.to_date,NVL(b.to_date,c.expiry_date))),
                                                                 TRUNC(NVL(e.to_date,NVL(b.to_date,p_expiry_date))),
                                                                     TRUNC(NVL(e.to_date,NVL(b.to_date,c.endt_expiry_date))) )) 
                                                                     >=TRUNC(p_loss_date)
                                  --AND c.pol_flag      NOT IN ('4','5'))   --kenneth SR4855 100715
                                  AND c.pol_flag      NOT IN ('5'))
            LOOP
                p_exist := 'Y';
                EXIT;
            END LOOP;
        EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            p_exist := 'N';
        END;
    
        
        IF p_exist = 'Y' THEN
            BEGIN
                p_valid := '0';
                FOR cnt IN (SELECT DISTINCT 
                              --a.no_of_persons no_of_persons,
                              b.item_no item_no ,
                              e.grouped_item_no grouped_item_no
                         FROM --gicl_claims d, commented by gmi 05/15/06
                              gipi_polbasic c,
                              gipi_grouped_items e,
                              gipi_item b --,gipi_accident_item a
                        WHERE c.policy_id     = b.policy_id
                        --   AND b.policy_id     = a.policy_id
                        --   AND b.item_no       = a.item_no
                        --   AND a.item_no       = :c017.item_no
                          AND b.item_no       = p_item_no
                          AND b.policy_id     = e.policy_id (+)
                          AND b.item_no       = e.item_no (+)
                          AND c.renew_no      = p_renew_no
                          AND c.pol_seq_no    = p_pol_seq_no
                          AND c.issue_yy      = p_issue_yy
                          AND c.iss_cd        = p_pol_iss_cd
                          AND c.subline_cd    = p_subline_cd
                          AND c.line_cd       = p_line_cd                  
    --                    AND c.expiry_date    >= :control.loss_date                  
                                    /* modified by gmi */
                                    /* added checking of dates from group item level*/
                          AND trunc(DECODE(TRUNC(NVL(e.from_date,NVL(b.from_date,c.eff_date))),
                                                     TRUNC(NVL(e.from_date,NVL(b.from_date,c.incept_date))),
                                                                         TRUNC(NVL(e.from_date,NVL(b.from_date,p_pol_eff_date))), 
                                                       TRUNC(NVL(e.from_date,NVL(b.from_date,c.eff_date))) )) 
                                                       <= TRUNC(p_loss_date)
                          AND TRUNC(DECODE(TRUNC(NVL(e.to_date,NVL(b.to_date,NVL(c.endt_expiry_date,c.expiry_date)))), 
                                                         TRUNC(NVL(e.to_date,NVL(b.to_date,c.expiry_date))),
                                                     TRUNC(NVL(e.to_date,NVL(b.to_date,p_expiry_date))),
                                                         TRUNC(NVL(e.to_date,NVL(b.to_date,c.endt_expiry_date))) )) 
                                                         >=TRUNC(p_loss_date)
                          --AND c.pol_flag      NOT IN ('4','5')    --kenneth SR4855 100715
                          AND c.pol_flag      NOT IN ('5')
                          AND e.grouped_item_no = p_grouped_item_no)
            
                LOOP
                    p_valid := '1';  
                    EXIT;
                END LOOP;
            EXCEPTION
             WHEN NO_DATA_FOUND
             THEN
                p_valid := '0';
            END;
        
        END IF;
    END; 
  
/*
**  Created by   :  Belle Bebing
**  Date Created :  12.08.2011
**  Reference By : (GICLS017- Claims Persanal Accident Item Information)
**  Description  : Validates item_no
*/
PROCEDURE validate_gicl_accident_item_no (
      p_line_cd                 gipi_polbasic.line_cd%TYPE,
      p_subline_cd              gipi_polbasic.subline_cd%TYPE,
      p_pol_iss_cd              gipi_polbasic.iss_cd%TYPE,
      p_issue_yy                gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no              gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no                gipi_polbasic.renew_no%TYPE,
      p_pol_eff_date            gipi_polbasic.eff_date%TYPE,
      p_expiry_date             gipi_polbasic.expiry_date%TYPE,
      p_loss_date               gipi_polbasic.expiry_date%TYPE,
      p_item_no                 gipi_item.item_no%TYPE,
      p_grouped_item_no         gicl_accident_dtl.grouped_item_no%TYPE,
      p_claim_id                gicl_accident_dtl.claim_id%TYPE,
      p_iss_cd                  gipi_polbasic.iss_cd%TYPE,
      p_from                    VARCHAR2,
      p_to                      VARCHAR2,
      c017             OUT      gicl_accident_dtl_cur,
      c017b            OUT      beneficiary_dtl_cur,
      p_item_exist     OUT      NUMBER,
      p_override_fl    OUT      VARCHAR2,
      p_tloss_fl       OUT      VARCHAR2,
      p_item_exist2    OUT      VARCHAR2,
      p_exist          OUT      VARCHAR2,  
      p_valid          OUT      VARCHAR2,
      v_ben_cnt        OUT      NUMBER      
)
   IS
    v_ctr               NUMBER:=0;
    v_grp_item_no       NUMBER:=0;
    v_beneficiary_no    gipi_beneficiary.beneficiary_no%TYPE; 
    v_ben_cnt2          NUMBER;      
   BEGIN
       OPEN c017 FOR
         SELECT *
           FROM TABLE
                   (gicl_accident_dtl_pkg.extract_latest_ahdata_1grp
                                                              (p_grouped_item_no, 
                                                               p_line_cd,
                                                               p_subline_cd,
                                                               p_pol_iss_cd,
                                                               p_issue_yy,
                                                               p_pol_seq_no,
                                                               p_renew_no,
                                                               p_pol_eff_date,
                                                               p_expiry_date,
                                                               p_loss_date,
                                                               p_item_no,
                                                               p_iss_cd
                                                               ) ); 
                                                                                                                                           
       IF p_grouped_item_no = 0 THEN
        -- GICL_ACCIDENT_DTL_PKG.get_latest_beneficiary_ngrp
          v_beneficiary_no :=0;
          v_ben_cnt   :=0;
          GICL_ACCIDENT_DTL_PKG.get_latest_beneficiary_ngrp(p_line_cd,               
                                                            p_subline_cd,            
                                                            p_pol_iss_cd,            
                                                            p_issue_yy,              
                                                            p_pol_seq_no,            
                                                            p_renew_no,              
                                                            p_pol_eff_date,          
                                                            p_expiry_date,           
                                                            p_loss_date,             
                                                            p_item_no,
                                                            v_beneficiary_no,
                                                            v_ben_cnt); 
            IF v_ben_cnt = 1 tHEN
                OPEN c017b FOR
                    SELECT *
                      FROM TABLE(GICL_ACCIDENT_DTL_PKG.extract_beneficiary_info_ngrp(v_beneficiary_no,          
                                                                                     p_line_cd,                 
                                                                                     p_subline_cd,              
                                                                                     p_pol_iss_cd,              
                                                                                     p_issue_yy,                
                                                                                     p_pol_seq_no,              
                                                                                     p_renew_no,   
                                                                                     p_pol_eff_date,            
                                                                                     p_expiry_date,             
                                                                                     p_loss_date,               
                                                                                     p_item_no  ) );             
            ELSE 
                OPEN c017b FOR
                    SELECT null claim_id, null item_no, null grouped_item_no, 
                       null beneficiary_no, null beneficiary_name,null beneficiary_addr, 
                       null position_cd, null position, null date_of_birth, null age, null civil_status, 
                       null sex, null relation, null dsp_civil_stat, null dsp_ben_position, null dsp_sex
                  FROM DUAL;                                                                         
                                    
            END IF;
       ELSE 
         --GICL_ACCIDENT_DTL_PKG.get_latest_beneficiary_grp    
          v_beneficiary_no :=0;
          v_ben_cnt   :=0;
          GICL_ACCIDENT_DTL_PKG.get_latest_beneficiary_grp(p_line_cd,          
                                                           p_subline_cd,       
                                                           p_pol_iss_cd,       
                                                           p_issue_yy,         
                                                           p_pol_seq_no,       
                                                           p_renew_no,         
                                                           p_pol_eff_date,     
                                                           p_expiry_date,      
                                                           p_loss_date,        
                                                           p_item_no,          
                                                           p_grouped_item_no,
                                                           v_beneficiary_no,
                                                           v_ben_cnt);  
            IF v_ben_cnt = 1 THEN
                OPEN c017b FOR
                    SELECT *
                      FROM TABLE (GICL_ACCIDENT_DTL_PKG.extract_beneficiary_info_grp(v_beneficiary_no,          
                                                                                    p_grouped_item_no,         
                                                                                    p_line_cd,                 
                                                                                    p_subline_cd,              
                                                                                    p_pol_iss_cd,              
                                                                                    p_issue_yy,                
                                                                                    p_pol_seq_no,              
                                                                                    p_renew_no,                
                                                                                    p_pol_eff_date,            
                                                                                    p_expiry_date,             
                                                                                    p_loss_date,               
                                                                                    p_item_no    ));
            ELSE 
                OPEN c017b FOR
                    SELECT null claim_id, null item_no, null grouped_item_no, 
                       null beneficiary_no, null beneficiary_name,null beneficiary_addr, 
                       null position_cd, null position, null date_of_birth, null age, null civil_status, 
                       null sex, null relation, null dsp_civil_stat, null dsp_ben_position, null dsp_sex
                  FROM DUAL;   
              END IF;                                         
                                                                                    
       END IF;   
   
   
      SELECT gicl_accident_dtl_pkg.check_accident_item_no (p_claim_id,
                                                           p_item_no,
                                                           p_from,
                                                           p_to
                                                          )
        INTO p_item_exist2
        FROM DUAL;

      SELECT giac_validate_user_fn (giis_users_pkg.app_user, 'TL', 'GICLS017')
        INTO p_override_fl
        FROM DUAL;

      SELECT gicl_accident_dtl_pkg.check_existing_item (p_line_cd,
                                                p_subline_cd,
                                                p_pol_iss_cd,
                                                p_issue_yy,
                                                p_pol_seq_no,
                                                p_renew_no,
                                                p_pol_eff_date,
                                                p_expiry_date,
                                                p_loss_date,
                                                p_item_no
                                               )
        INTO p_item_exist
        FROM DUAL;

      SELECT check_total_loss_settlement2 (0,
                                           NULL,
                                           p_item_no,
                                           p_line_cd,
                                           p_subline_cd,
                                           p_pol_iss_cd,
                                           p_issue_yy,
                                           p_pol_seq_no,
                                           p_renew_no,
                                           p_loss_date,
                                           p_pol_eff_date,
                                           p_expiry_date
                                          )
        INTO p_tloss_fl
        FROM DUAL;
        
        GICL_ACCIDENT_DTL_PKG.check_grp_item_no(p_line_cd,          
                                                p_subline_cd,       
                                                p_pol_iss_cd,       
                                                p_issue_yy,         
                                                p_pol_seq_no,       
                                                p_renew_no,         
                                                p_pol_eff_date,     
                                                p_expiry_date,      
                                                p_loss_date,        
                                                p_item_no,          
                                                p_grouped_item_no,  
                                                p_claim_id,         
                                                p_exist,            
                                                p_valid            
                                                );  
                                                
        /*GICL_ACCIDENT_DTL_PKG.check_DEL_SW (p_line_cd,          
                                            p_subline_cd,       
                                            p_pol_iss_cd,       
                                            p_issue_yy,         
                                            p_pol_seq_no,       
                                            p_renew_no,         
                                            p_pol_eff_date,     
                                            p_expiry_date,      
                                            p_loss_date,        
                                            p_item_no,          
                                            p_claim_id,         
                                            p_grouped_item_no,  
                                            p_iss_cd,              
                                            c017,
                                            c017b );*/  --belle 02.08.2012 comment out ko muna hindi na ata need :) ,
   END;
   
PROCEDURE set_gicl_accident_dtl (
    p_claim_id         gicl_aviation_dtl.claim_id%TYPE,
    p_item_no          gicl_accident_dtl.item_no%TYPE,
    p_item_title       gicl_accident_dtl.item_title%TYPE,
    p_currency_cd      gicl_accident_dtl.currency_cd%TYPE,
    p_currency_rate    gicl_accident_dtl.currency_rate%TYPE,
    p_loss_date        gicl_accident_dtl.loss_date%TYPE, 
    p_date_of_birth    gicl_accident_dtl.date_of_birth%TYPE, 
    p_age              gicl_accident_dtl.age%TYPE, 
    p_civil_status     gicl_accident_dtl.civil_status%TYPE, 
    p_position_cd      gicl_accident_dtl.position_cd%TYPE, 
    p_monthly_salary   gicl_accident_dtl.monthly_salary%TYPE, 
    p_salary_grade     gicl_accident_dtl.salary_grade%TYPE, 
    p_sex              gicl_accident_dtl.sex%TYPE, 
    p_grouped_item_no  gicl_accident_dtl.grouped_item_no%TYPE, 
    p_grouped_item_title  gicl_accident_dtl.grouped_item_title%TYPE, 
    p_amount_coverage  gicl_accident_dtl.amount_coverage%TYPE, 
    p_line_cd          gicl_accident_dtl.line_cd%TYPE, 
    p_subline_cd       gicl_accident_dtl.subline_cd%TYPE,
    p_control_cd       gicl_accident_dtl.control_cd%TYPE,
    p_control_type_cd  gicl_accident_dtl.control_type_cd%TYPE
   )
   IS
   	v_loss_date   gicl_accident_dtl.loss_date%TYPE; 
   BEGIN   
     /* Modified by : Joms Diago
     ** Date Modified : 04112013
     ** Description : To follow GICLS017 when saving loss date. Please refer
     ** to GICLS017 C017 block; WHEN-NEW-RECORD-INSTANCE trigger.
     */
     IF p_loss_date IS NULL
     THEN
        SELECT dsp_loss_date
          INTO v_loss_date
          FROM gicl_claims
         WHERE claim_id = p_claim_id;
     ELSE
        v_loss_date := p_loss_date;
     END IF;
     
   	   
     MERGE INTO gicl_accident_dtl
     USING DUAL
     ON (claim_id = p_claim_id AND item_no = p_item_no and grouped_item_no = p_grouped_item_no)
     WHEN NOT MATCHED THEN
        INSERT (claim_id, item_no,item_title, currency_cd, currency_rate, loss_date,
                date_of_birth, age, civil_status, position_cd, monthly_salary, salary_grade,
                sex, grouped_item_no, grouped_item_title, amount_coverage, line_cd, subline_cd,
                control_cd, control_type_cd)
                values(
                p_claim_id, p_item_no, p_item_title, p_currency_cd, p_currency_rate, v_loss_date,
                p_date_of_birth, p_age, p_civil_status, p_position_cd, p_monthly_salary, p_salary_grade,
                p_sex, p_grouped_item_no, p_grouped_item_title, p_amount_coverage, p_line_cd, p_subline_cd,
                p_control_cd, p_control_type_cd)
      WHEN MATCHED THEN 
      UPDATE SET
          item_title    = p_item_title, 
          currency_cd   = p_currency_cd, 
          currency_rate = p_currency_rate,
          loss_date     = v_loss_date,
          date_of_birth = p_date_of_birth,
          age           = p_age, 
          civil_status  = p_civil_status, 
          position_cd   = p_position_cd, 
          monthly_salary= p_monthly_salary, 
          salary_grade  = p_salary_grade,
          sex           = p_sex, 
          grouped_item_title = grouped_item_title, 
          amount_coverage = p_amount_coverage, 
          line_cd       = p_line_cd, 
          subline_cd    = p_subline_cd,
          control_cd    = p_control_cd,
          control_type_cd = p_control_type_cd; 
   END;  

PROCEDURE del_gicl_accident_dtl (
    p_claim_id          gicl_accident_dtl.claim_id%TYPE,
    p_item_no           gicl_accident_dtl.item_no%TYPE,
    p_grouped_item_no   gicl_accident_dtl.grouped_item_no%TYPE
   )
   IS
   BEGIN
      DELETE FROM gicl_accident_dtl
            WHERE claim_id = p_claim_id 
              AND item_no  = p_item_no 
              AND grouped_item_no = p_grouped_item_no;
   END;  
   
FUNCTION get_claim_ben_no(
    p_claim_id                gicl_accident_dtl.claim_id%TYPE,
    p_line_cd                 gipi_polbasic.line_cd%TYPE,
    p_subline_cd              gipi_polbasic.subline_cd%TYPE,
    p_pol_iss_cd              gipi_polbasic.iss_cd%TYPE,
    p_issue_yy                gipi_polbasic.issue_yy%TYPE,
    p_pol_seq_no              gipi_polbasic.pol_seq_no%TYPE,
    p_renew_no                gipi_polbasic.renew_no%TYPE,
    p_loss_date               gipi_polbasic.expiry_date%TYPE,
    p_item_no                 gipi_item.item_no%TYPE,
    p_grouped_item_no         gicl_accident_dtl.grouped_item_no%TYPE,
    p_find_text               VARCHAR2 
  ) 
    RETURN beneficiary_dtl_tab PIPELINED
IS
    ben         beneficiary_dtl_type;
    BEGIN
        FOR i IN (SELECT DISTINCT e.beneficiary_no beneficiary_no, e.beneficiary_name beneficiary_name, e.beneficiary_addr, e.relation, e.civil_status, TO_CHAR(e.date_of_birth, 'mm-dd-yyyy')date_of_birth, e.age, e.sex, e.position_cd
                    FROM gicl_claims d, gipi_polbasic c, gipi_item b, gipi_accident_item a, gipi_beneficiary e 
                   WHERE c.policy_id = b.policy_id 
                     AND b.policy_id = a.policy_id 
                     AND b.item_no = a.item_no  
                     AND b.policy_id = e.policy_id 
                     AND b.item_no = e.item_no 
                     AND c.renew_no = p_renew_no 
                     AND c.pol_seq_no = p_pol_seq_no 
                     AND c.issue_yy = p_issue_yy 
                     AND c.iss_cd = p_pol_iss_cd 
                     AND c.subline_cd = p_subline_cd 
                     AND c.line_cd = p_line_cd 
                     AND TRUNC(c.eff_date) <= p_loss_date 
                     AND c.pol_flag not in ('4','5') 
                     AND b.item_no = p_item_no 
                     AND d.claim_id = p_claim_id
                     AND (UPPER(e.beneficiary_no) LIKE UPPER(nvl(p_find_text, e.beneficiary_no)) OR UPPER(e.beneficiary_name) LIKE UPPER(nvl(p_find_text, e.beneficiary_name)))
                   UNION 
                  SELECT DISTINCT f.beneficiary_no beneficiary_no, f.beneficiary_name beneficiary_name ,f.beneficiary_addr, f.relation, f.civil_status, TO_CHAR(f.date_of_birth, 'mm-dd-yyyy')date_of_birth, f.age, f.sex, e.position_cd
                    FROM gicl_claims d, gipi_polbasic c, gipi_grouped_items e, gipi_grp_items_beneficiary f, gipi_item b, gipi_accident_item a 
                   WHERE c.policy_id = b.policy_id 
                     AND b.policy_id = e.policy_id 
                     AND b.item_no = e.item_no 
                     AND e.policy_id = f.policy_id 
                     AND e.item_no = f.item_no 
                     AND e.grouped_item_no = f.grouped_item_no 
                     AND c.renew_no = p_renew_no 
                     AND c.pol_seq_no = p_pol_seq_no 
                     AND c.issue_yy = p_issue_yy 
                     AND c.iss_cd = p_pol_iss_cd 
                     AND c.subline_cd = p_subline_cd 
                     AND c.line_cd = p_line_cd 
                     AND TRUNC(c.eff_date) <= p_loss_date 
                     AND c.pol_flag NOT IN ('4','5') 
                     AND e.grouped_item_no = p_grouped_item_no 
                     AND b.item_no = p_item_no 
                     AND d.claim_id = p_claim_id 
                     AND f.beneficiary_no NOT IN (SELECT beneficiary_no 
                                                    FROM gicl_beneficiary_dtl 
                                                   WHERE claim_id = p_claim_id 
                                                     AND item_no = p_item_no 
                                                     AND grouped_item_no = p_grouped_item_no)
                     AND (UPPER(f.beneficiary_no) LIKE UPPER(nvl(p_find_text, f.beneficiary_no)) OR UPPER(f.beneficiary_name) LIKE UPPER(nvl(p_find_text, f.beneficiary_name))) )
        LOOP
            ben.claim_id            := p_claim_id;
            ben.item_no             := p_item_no;
            ben.grouped_item_no     := p_grouped_item_no;
            ben.beneficiary_no      := i.beneficiary_no;
            ben.beneficiary_name    := i.beneficiary_name;
            ben.beneficiary_addr    := i.beneficiary_addr;
            ben.position_cd         := i.position_cd;
            ben.relation            := i.relation;
            ben.civil_status        := i.civil_status;
            ben.date_of_birth       := i.date_of_birth;
            ben.age                 := i.age;
            ben.sex                 := i.sex;
           
            IF i.position_cd = '' THEN
                 ben.dsp_ben_position := '';
            ELSE
                BEGIN
                    SELECT position
                      INTO ben.dsp_ben_position
                      FROM GIIS_POSITION
                     WHERE position_cd = i.position_cd;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        ben.dsp_ben_position := NULL;
                END; 
            END IF;
            
            IF i.civil_status = '' THEN
                ben.dsp_civil_stat := '';
            ELSE
                BEGIN
                    SELECT rv_meaning
                      INTO ben.dsp_civil_stat
                      FROM cg_ref_codes
                     WHERE rv_low_value = i.civil_status
                       AND rv_domain = 'CIVIL STATUS';
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        ben.dsp_civil_stat := NULL;
                END;   
            END IF;                  
               
            BEGIN
                SELECT DECODE(i.sex, 'M', 'Male', 'F', 'Female', '') Gender
                  INTO ben.dsp_sex
                  FROM DUAL;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    ben.dsp_sex := NULL;
            END;
                   
            PIPE ROW(ben);
        END LOOP;   
        
        RETURN;                                      
    END;    

FUNCTION get_beneficiary_info(
    p_claim_id              gicl_beneficiary_dtl.claim_id%TYPE,
    p_item_no               gicl_beneficiary_dtl.item_no%TYPE,
    p_grouped_item_no       gicl_beneficiary_dtl.grouped_item_no%TYPE
  )
    RETURN beneficiary_dtl_tab PIPELINED
 IS
    ben         beneficiary_dtl_type;
    
    BEGIN
        FOR i IN (SELECT *
                    FROM gicl_beneficiary_dtl
                   WHERE claim_id = p_claim_id
                     AND item_no  = p_item_no
                     AND grouped_item_no = p_grouped_item_no)
        LOOP 
            ben.claim_id            := i.claim_id;
            ben.item_no             := i.item_no;
            ben.grouped_item_no     := i.grouped_item_no;
            ben.beneficiary_no      := i.beneficiary_no;
            ben.beneficiary_name    := i.beneficiary_name;
            ben.beneficiary_addr    := i.beneficiary_addr;
            ben.relation            := i.relation;
            ben.date_of_birth       := i.date_of_birth;
            ben.age                 := i.age;
            ben.sex                 := i.sex;
            ben.civil_status        := i.civil_status;
            ben.position_cd         := i.position_cd;
            
            IF i.position_cd = '' THEN
                 ben.dsp_ben_position := '';
            ELSE
                BEGIN
                     SELECT position
                       INTO ben.dsp_ben_position
                       FROM GIIS_POSITION
                      WHERE position_cd = i.position_cd;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        ben.dsp_ben_position := NULL;
                END; 
            END IF;
            
            IF i.civil_status = '' THEN
                ben.dsp_civil_stat := '';
            ELSE
                BEGIN
                    SELECT rv_meaning
                      INTO ben.dsp_civil_stat
                      FROM cg_ref_codes
                     WHERE rv_low_value = i.civil_status
                       AND rv_domain = 'CIVIL STATUS';
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        ben.dsp_civil_stat := NULL;
                END;   
            END IF;    
            
            BEGIN
                SELECT DECODE(i.sex, 'M', 'Male', 'F', 'Female', '') Gender
                  INTO ben.dsp_sex
                  FROM DUAL;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    ben.dsp_sex := NULL;
            END;
            
            PIPE ROW(ben);
        END LOOP;           
         
    END; 
    
PROCEDURE set_gicl_beneficiary_dtl (
    p_claim_id                gicl_beneficiary_dtl.claim_id%TYPE,
    p_item_no                 gicl_beneficiary_dtl.item_no%TYPE,
    p_grouped_item_no         gicl_beneficiary_dtl.grouped_item_no%TYPE,
    p_beneficiary_no          gicl_beneficiary_dtl.beneficiary_no%TYPE,
    p_beneficiary_name        gicl_beneficiary_dtl.beneficiary_name%TYPE,
    p_beneficiary_addr        gicl_beneficiary_dtl.beneficiary_addr%TYPE,     
    p_relation                gicl_beneficiary_dtl.relation%TYPE,
    p_date_of_birth           VARCHAR2, --gicl_beneficiary_dtl.date_of_birth%TYPE,
    p_age                     gicl_beneficiary_dtl.age%TYPE,
    p_civil_status            gicl_beneficiary_dtl.civil_status%TYPE,
    p_position_cd             gicl_beneficiary_dtl.position_cd%TYPE,
    p_sex                     gicl_beneficiary_dtl.sex%TYPE   
   )
   IS
   BEGIN      
     MERGE INTO gicl_beneficiary_dtl
     USING DUAL
     ON (claim_id = p_claim_id AND item_no = p_item_no and grouped_item_no = p_grouped_item_no and beneficiary_no = p_beneficiary_no)
     WHEN NOT MATCHED THEN
        INSERT (claim_id, item_no, grouped_item_no, beneficiary_no, beneficiary_name, beneficiary_addr,
                relation, date_of_birth, age, civil_status, position_cd, sex)
                values(
                p_claim_id, p_item_no, p_grouped_item_no, p_beneficiary_no, p_beneficiary_name, p_beneficiary_addr,
                p_relation, TO_DATE(p_date_of_birth, 'mm-dd-yyyy'), p_age, p_civil_status, p_position_cd, p_sex)
      WHEN MATCHED THEN 
      UPDATE SET
          beneficiary_name  = p_beneficiary_name,
          beneficiary_addr  = p_beneficiary_addr,
          relation          = p_relation,
          date_of_birth     = TO_DATE(p_date_of_birth, 'mm-dd-yyyy'),
          age               = p_age,
          civil_status      = p_civil_status,
          position_cd       = p_position_cd,
          sex               = p_sex;        
          
   END;     

PROCEDURE del_gicl_beneficiary_dtl (
    p_claim_id          gicl_accident_dtl.claim_id%TYPE,
    p_item_no           gicl_accident_dtl.item_no%TYPE,
    p_grouped_item_no   gicl_accident_dtl.grouped_item_no%TYPE,
    p_beneficiary_no    gicl_beneficiary_dtl.beneficiary_no%TYPE
   )
   IS
   BEGIN
      DELETE FROM gicl_beneficiary_dtl
            WHERE claim_id = p_claim_id 
              AND item_no  = p_item_no 
              AND grouped_item_no = p_grouped_item_no
              AND beneficiary_no = p_beneficiary_no; 
   END;   
   
PROCEDURE del_gicl_item_beneficiary (
    p_claim_id          gicl_accident_dtl.claim_id%TYPE,
    p_item_no           gicl_accident_dtl.item_no%TYPE,
    p_grouped_item_no   gicl_accident_dtl.grouped_item_no%TYPE
    )
   IS
   BEGIN
      DELETE FROM gicl_beneficiary_dtl
            WHERE claim_id = p_claim_id 
              AND item_no  = p_item_no 
              AND grouped_item_no = p_grouped_item_no;
   END;  
   
   /** 
   	modified where clause, - irwin. 7.9.2012
   */
FUNCTION get_avail_perils(
    p_claim_id                gicl_accident_dtl.claim_id%TYPE,
    p_item_no                 gipi_item.item_no%TYPE,
    p_grouped_item_no         gicl_accident_dtl.grouped_item_no%TYPE
  ) 
    RETURN availments_dtl_tab PIPELINED
IS
    avail         availments_dtl_type;
    v_sum_units   NUMBER := 0;
	v_tsi_amt     NUMBER := 0;
    BEGIN
        FOR i IN (SELECT * FROM(SELECT c.aggregate_sw,NVL(c.BASE_AMT,0) base_amt,c.grouped_item_no, x.claim_id,c.item_no,C.PERIL_CD, 
                         NVL(c.no_of_days,0) no_of_days, c.ann_tsi_amt, a.line_cd, a.issue_yy, a.renew_no, a.subline_cd, a.pol_seq_no, a.iss_cd 
                    FROM GIPI_ITMPERIL_GROUPED C,gipi_grouped_items b, gipi_polbasic a, GICL_CLAIMS x 
                   WHERE a.LINE_CD = x.line_cd 
                     AND a.SUBLINE_CD = x.subline_cd 
                     AND a.ISSUE_YY = x.issue_yy 
                     AND a.POL_SEQ_NO = x.pol_seq_no 
                     AND a.RENEW_NO = x.renew_no 
                     AND a.ISS_CD = x.POL_ISS_CD 
                     AND a.policy_id = b.policy_id 
                     AND C.GROUPED_ITEM_NO = B.GROUPED_ITEM_NO 
                     AND C.ITEM_NO = B.ITEM_NO 
                     AND C.POLICY_ID = B.POLICY_ID 
                     --AND x.CLAIM_ID = P_CLAIM_ID
                    -- AND C.ITEM_NO  = P_ITEM_NO
                    -- AND C.GROUPED_ITEM_NO = P_GROUPED_ITEM_NO 
                   UNION 
                  SELECT c.aggregate_sw,NVL(c.BASE_AMT,0) base_amt,0 grouped_item_no,x.claim_id,c.item_no,C.PERIL_CD, 
                         NVL(c.no_of_days,0)no_of_days, c.ann_tsi_amt, a.line_cd, a.issue_yy, a.renew_no, a.subline_cd, a.pol_seq_no, a.iss_cd 
                    FROM GIPI_ITMPERIL C,gipi_item b, gipi_polbasic a, gicl_claims x 
                   WHERE a.LINE_CD = x.line_cd 
                     AND a.SUBLINE_CD = x.subline_cd 
                     AND a.ISSUE_YY = x.issue_yy 
                     AND a.POL_SEQ_NO = x.pol_seq_no 
                     AND a.RENEW_NO = x.renew_no 
                     AND a.ISS_CD = x.POL_ISS_CD 
                     AND a.policy_id = b.policy_id 
                     AND C.ITEM_NO = B.ITEM_NO 
                     AND C.POLICY_ID = B.POLICY_ID
                   --  AND x.CLAIM_ID = P_CLAIM_ID
                     --AND C.ITEM_NO  = P_ITEM_NO
                    ) where claim_id = p_claim_id and grouped_item_no = P_GROUPED_ITEM_NO and item_no = p_item_no)
        LOOP
            avail.claim_id            := i.claim_id;
            avail.item_no             := i.item_no;
            avail.grouped_item_no     := i.grouped_item_no;
            avail.peril_cd            := i.peril_cd;
            avail.aggregate_sw        := i.aggregate_sw;
            avail.base_amt            := i.base_amt;
            avail.no_of_days          := i.no_of_days;
            avail.ann_tsi_amt         := i.ann_tsi_amt;
            
            BEGIN
                SELECT peril_name
                  INTO avail.dsp_peril_name
                  FROM GIIS_PERIL
                 WHERE peril_cd = i.peril_cd
                   AND line_cd  = i.line_cd;
            END;

           /* added by gmi */
            v_tsi_amt := GICL_ITEM_PERIL_PKG.populate_allow_tsi_amt_PA(i.aggregate_sw,
                                                                       i.base_amt,
                                                                       i.no_of_days,
                                                                       i.peril_cd,
                                                                       i.item_no,
                                                                       i.grouped_item_no,
                                                                       i.ann_tsi_amt,
                                                                       i.line_cd,
                                                                       i.subline_cd,
                                                                       i.iss_cd,
                                                                       i.issue_yy,
                                                                       i.pol_seq_no,
                                                                       i.renew_no);
            IF nvl(i.no_of_days,0) != 0 THEN
                avail.dsp_allow	:= TO_CHAR(i.base_amt,'99,999,999,999.99')||' / '||TO_CHAR(i.no_of_days);
            ELSE		  
                avail.dsp_allow	:= TO_CHAR(v_tsi_amt,'99,999,999,999.99');
            END IF;			
           /*--*/

           PIPE ROW(avail);
        END LOOP;   
        RETURN;                                      
    END;            

FUNCTION get_avail_claim_list(
    p_claim_id                gicl_accident_dtl.claim_id%TYPE,
    p_item_no                 gipi_item.item_no%TYPE,
    p_grouped_item_no         gicl_accident_dtl.grouped_item_no%TYPE,
    p_no_of_days              gipi_itmperil_grouped.no_of_days%TYPE 
  ) 
    RETURN availments_dtl_tab PIPELINED
IS
    avail         availments_dtl_type;

    BEGIN
        FOR i IN (SELECT a.loss_date, a.clm_stat_cd, b.loss_reserve, 
                         SUM(c.paid_amt) paid_amt, SUM(d.no_of_units) no_of_units
                    FROM gicl_claims a, gicl_clm_reserve b, gicl_clm_loss_exp c, gicl_loss_exp_dtl d 
                   WHERE a.claim_id = b.claim_id 
                     AND b.claim_id = c.claim_id 
                     AND b.item_no = c.item_no 
                     AND b.peril_cd = c.peril_cd 
                     AND c.CLAIM_ID = d.claim_id 
                     AND c.CLM_LOSS_ID = d.clm_loss_id 
                     AND NVL(c.CANCEL_SW,'N') = 'N' 
                     AND NVL(c.DIST_SW,'N') = 'Y' 
                     AND a.claim_id = P_CLAIM_ID
                     AND b.item_no  = P_ITEM_NO
                     AND b.grouped_item_no = P_GROUPED_ITEM_NO
                   GROUP BY a.loss_date, a.clm_stat_cd, b.loss_reserve)
        LOOP
            avail.dsp_loss_date       := i.loss_date;
            avail.loss_reserve        := i.loss_reserve;
            avail.paid_amt            := i.paid_amt;
            
            BEGIN
                SELECT get_claim_number (p_claim_id)
                  INTO avail.dsp_claim_no         
                  FROM dual ;  
            END;     

            BEGIN
                SELECT clm_stat_desc
                  INTO avail.dsp_claim_stat    
                  FROM GIIS_CLM_STAT   
                 WHERE clm_stat_cd = i.clm_stat_cd;
            END;     

            BEGIN
                IF NVL(p_no_of_days,0) > 0 THEN
                    avail.dsp_no_of_days := i.no_of_units;
                ELSE
                    avail.dsp_no_of_days := 0;
                END IF;    
            END;    

           PIPE ROW(avail);
        END LOOP;   
        RETURN;                                      
    END;
    
   FUNCTION get_accident_dtl_gicls260( -- bonok :: 05.16.2013 :: for GICLS260
      p_claim_id       gicl_claims.claim_id%TYPE
   ) RETURN gicl_accident_gicls260_tab PIPELINED IS
      vitem            gicl_accident_gicls260_type; 
   BEGIN
      FOR i IN ( SELECT *
                   FROM gicl_accident_dtl
                  WHERE claim_id = p_claim_id)
      LOOP
         vitem.claim_id              := i.claim_id;
         vitem.item_no               := i.item_no;
         vitem.item_title            := i.item_title;
         vitem.grouped_item_no       := i.grouped_item_no;  
         vitem.grouped_item_title    := i.grouped_item_title;
         vitem.currency_cd           := i.currency_cd;
         vitem.currency_rate         := i.currency_rate;
         vitem.position_cd           := i.position_cd;
         vitem.monthly_salary        := i.monthly_salary;
         vitem.control_cd            := i.control_cd;
         vitem.level_cd              := i.level_cd;
         vitem.salary_grade          := i.salary_grade;
         vitem.date_of_birth         := i.date_of_birth;
         vitem.age                   := i.age;
         vitem.amount_coverage       := i.amount_coverage;
         vitem.loss_date             := TO_CHAR(i.loss_date, 'MM-DD-YYYY HH:MI AM'); --i.loss_date; : shan 04.15.2014
            
         FOR s IN (SELECT rv_meaning
                     FROM cg_ref_codes
                    WHERE rv_low_value = i.civil_status
                      AND rv_domain = 'CIVIL STATUS')
         LOOP
            vitem.dsp_civil_stat := s.rv_meaning;
         END LOOP;

         IF i.sex IS NOT NULL THEN
            FOR d IN (SELECT DECODE(i.sex, 'M', 'Male', 'Female') gender
                        FROM DUAL) 
            LOOP
               vitem.dsp_sex := d.gender;
               END LOOP;
         END IF;
      
         FOR c IN (SELECT currency_desc 
                     FROM giis_currency
                    WHERE main_currency_cd = i.currency_cd) 
         LOOP
            vitem.dsp_currency := c.currency_desc;
         END LOOP;

         FOR p IN (SELECT position
                     FROM giis_position
                    WHERE position_cd = i.position_cd) 
         LOOP
            vitem.dsp_position := p.position;
         END LOOP;
               
         FOR j IN (SELECT control_type_desc
                     FROM giis_control_type
                    WHERE control_type_cd = i.control_type_cd)
         LOOP
            vitem.dsp_control_type := j.control_type_desc;
         END LOOP;
            
         SELECT gicl_item_peril_pkg.get_gicl_item_peril_exist(vitem.item_no, vitem.claim_id)
           INTO vitem.gicl_item_peril_exist
           FROM DUAL;

         SELECT gicl_mortgagee_pkg.get_gicl_mortgagee_exist (vitem.item_no, vitem.claim_id)
           INTO vitem.gicl_mortgagee_exist
           FROM DUAL;

         gicl_item_peril_pkg.validate_peril_reserve(vitem.item_no, vitem.claim_id, vitem.grouped_item_no, vitem.gicl_item_peril_msg);    

         FOR ben IN (SELECT beneficiary_no, beneficiary_name, beneficiary_addr, position_cd, 
                            civil_status, sex, relation, date_of_birth, age
                       FROM gicl_beneficiary_dtl
                      WHERE claim_id = i.claim_id
                        AND item_no = i.item_no
                        AND grouped_item_no = i.grouped_item_no)
         LOOP
            vitem.beneficiary_no := ben.beneficiary_no;
            vitem.beneficiary_name := ben.beneficiary_name;
            vitem.beneficiary_addr := ben.beneficiary_addr;
            vitem.ben_position_cd := ben.position_cd;
            vitem.ben_civil_status := ben.civil_status;
            vitem.ben_sex := ben.sex;
            vitem.ben_relation := ben.relation;
            vitem.ben_date_of_birth := ben.date_of_birth;
            vitem.ben_age := ben.age;
         
            FOR pos IN (SELECT position
                          FROM giis_position
                         WHERE position_cd = ben.position_cd)
            LOOP
               vitem.ben_position := NVL(pos.position,'-');
               EXIT;
            END LOOP;
            
            FOR a IN (SELECT rv_meaning
	                    FROM cg_ref_codes
	                   WHERE rv_low_value = ben.civil_status
	                     AND rv_domain = 'CIVIL STATUS') 
            LOOP
               vitem.ben_civil_status := a.rv_meaning;
            END LOOP;
         END LOOP;       
            
         PIPE ROW(vitem);
      END LOOP;
        
    END get_accident_dtl_gicls260;
    
    --kenneth SR4855 100715
    FUNCTION get_item_no_list_PA (
      p_line_cd        gipi_polbasic.line_cd%TYPE,
      p_subline_cd     gipi_polbasic.subline_cd%TYPE,
      p_pol_iss_cd     gipi_polbasic.iss_cd%TYPE,
      p_issue_yy       gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no     gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no       gipi_polbasic.renew_no%TYPE,
      p_loss_date      gipi_polbasic.expiry_date%TYPE,
      p_pol_eff_date   gipi_polbasic.eff_date%TYPE,
      p_expiry_date    gipi_polbasic.expiry_date%TYPE,
      p_claim_id       gicl_claims.claim_id%TYPE
   )
      RETURN gipi_item_tab PIPELINED
   IS
      v_list   gipi_item_type;
   BEGIN
      FOR i IN
         (SELECT DISTINCT b.item_no,
                          get_latest_item_title2 (p_line_cd,
                                                 p_subline_cd,
                                                 p_pol_iss_cd,
                                                 p_issue_yy,
                                                 p_pol_seq_no,
                                                 p_renew_no,
                                                 b.item_no,
                                                 p_loss_date,
                                                 p_pol_eff_date,
                                                 p_expiry_date
                                                ) item_title
                     FROM gipi_polbasic a, gipi_item b
                    WHERE 1 = 1
                      AND a.line_cd = p_line_cd
                      AND a.subline_cd = p_subline_cd
                      AND a.iss_cd = p_pol_iss_cd
                      AND a.issue_yy = p_issue_yy
                      AND a.pol_seq_no = p_pol_seq_no
                      AND a.renew_no = p_renew_no
                      AND a.pol_flag IN ('1', '2', '3', '4', 'X')
                      AND a.spld_date is null
                      AND trunc(decode(trunc(nvl(b.from_date,eff_date)),trunc(a.incept_date), nvl(b.from_date,p_pol_eff_date), nvl(b.from_date,a.eff_date ))) <= p_loss_date 
                      AND trunc(decode(nvl(b.to_date,nvl(a.endt_expiry_date, a.expiry_date)), a.expiry_date,nvl(b.to_date,p_expiry_date), nvl(b.to_date,a.endt_expiry_date))) >= p_loss_date 
                      AND a.policy_id = b.policy_id
                      AND item_no not in (SELECT item_no
                                            FROM gicl_accident_dtl
                                           WHERE claim_id = p_claim_id))
      LOOP
         v_list.item_no    := i.item_no;
         v_list.item_title := i.item_title;
         PIPE ROW (v_list);
      END LOOP;
   END;
   
   --kenneth SR4855 100715
   FUNCTION check_existing_item (
      p_line_cd        gipi_polbasic.line_cd%TYPE,
      p_subline_cd     gipi_polbasic.subline_cd%TYPE,
      p_pol_iss_cd     gipi_polbasic.iss_cd%TYPE,
      p_issue_yy       gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no     gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no       gipi_polbasic.renew_no%TYPE,
      p_pol_eff_date   gipi_polbasic.eff_date%TYPE,
      p_expiry_date    gipi_polbasic.expiry_date%TYPE,
      p_loss_date      gipi_polbasic.expiry_date%TYPE,
      p_item_no        gipi_item.item_no%TYPE
   )
      RETURN NUMBER
   IS
      v_exist   NUMBER := 0;
   BEGIN
      FOR h IN
         (SELECT c.item_no
            FROM gipi_item c, gipi_polbasic b
           WHERE                   --:control.claim_id = :global.claim_id AND
                 p_line_cd = b.line_cd
             AND p_subline_cd = b.subline_cd
             AND p_pol_iss_cd = b.iss_cd
             AND p_issue_yy = b.issue_yy
             AND p_pol_seq_no = b.pol_seq_no
             AND p_renew_no = b.renew_no
             AND b.policy_id = c.policy_id
             AND b.pol_flag IN ('1', '2', '3', '4', 'X')
             AND TRUNC (DECODE (TRUNC (b.eff_date),
                                TRUNC (b.incept_date), p_pol_eff_date,
                                b.eff_date
                               )
                       ) <= p_loss_date
             --AND TRUNC(b.eff_date) <= :control.loss_date
             AND TRUNC (DECODE (NVL (b.endt_expiry_date, b.expiry_date),
                                b.expiry_date, p_expiry_date,
                                b.endt_expiry_date
                               )
                       ) >= p_loss_date
             AND c.item_no = p_item_no)
      LOOP
         v_exist := 1;
      END LOOP;

      RETURN v_exist;
   END;
END gicl_accident_dtl_pkg;
/


