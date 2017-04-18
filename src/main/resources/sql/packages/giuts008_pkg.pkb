CREATE OR REPLACE PACKAGE BODY CPI.GIUTS008_PKG
AS

PROCEDURE check_endt
(p_line_cd          IN   GIPI_POLBASIC.line_cd%TYPE,
 p_subline_cd       IN   GIPI_POLBASIC.subline_cd%TYPE,
 p_iss_cd           IN   GIPI_POLBASIC.iss_cd%TYPE,
 p_issue_yy         IN   GIPI_POLBASIC.issue_yy%TYPE,
 p_pol_seq_no       IN   GIPI_POLBASIC.pol_seq_no%TYPE,
 p_renew_no         IN   GIPI_POLBASIC.renew_no%TYPE,
 p_nbt_endt_iss_cd  IN   GIPI_POLBASIC.endt_iss_cd%TYPE,
 p_nbt_endt_yy      IN   GIPI_POLBASIC.endt_yy%TYPE,
 p_nbt_endt_seq_no  IN   GIPI_POLBASIC.endt_seq_no%TYPE) IS
 
 v_user_id               GIPI_WPOLBAS.user_id%TYPE;
 v_exist                 VARCHAR2(1) := 'N';
 v_spld                  VARCHAR2(1) := 'N';
 v_spld1                 VARCHAR2(1) := 'N';
 v_spld2                 VARCHAR2(1) := 'N';
 v_message               VARCHAR2(500);
 
    BEGIN
         FOR tag IN (SELECT spld_flag
                      FROM gipi_polbasic
                     WHERE line_cd     =  p_line_cd
                       AND subline_cd  =  p_subline_cd
                       AND iss_cd      =  p_iss_cd
                       AND issue_yy    =  p_issue_yy
                       AND pol_seq_no  =  p_pol_seq_no
                       AND renew_no    =  p_renew_no
                       AND endt_iss_cd =  p_nbt_endt_iss_cd
                       AND endt_yy     =  p_nbt_endt_yy
                       AND endt_seq_no =  p_nbt_endt_seq_no)
          LOOP
            IF tag.spld_flag = 2 THEN
               v_spld := 'Y';
               EXIT;
            END IF;
          END LOOP; 
                      
          FOR spld IN (SELECT spld_flag
                         FROM gipi_polbasic
                        WHERE line_cd     =  p_line_cd
                          AND subline_cd  =  p_subline_cd
                          AND iss_cd      =  p_iss_cd
                          AND issue_yy    =  p_issue_yy
                          AND pol_seq_no  =  p_pol_seq_no
                          AND renew_no    =  p_renew_no
                          AND endt_seq_no = 0)
          LOOP
            IF spld.spld_flag = 2 THEN
               v_spld1 := 'Y';
               EXIT;
            END IF;
          END LOOP;
                      
          IF v_spld1 = 'Y' THEN
             v_message      :=      'Policy has been tagged for spoilage. '||
                       'Please do the necessary action before copying to a new par.';
              RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#I#'||v_message);
          ELSIF v_spld2 = 'Y' THEN
             v_message      :=      'Endorsement has been spoiled. Cannot copy to a new par. ';
             RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#I#'||v_message);
          ELSIF v_spld = 'Y' THEN
             v_message      :=      'Endorsement has been tagged for spoilage. '||
                       'Please do the necessary action before copying to a new par.';
             RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#I#'||v_message);
          END IF;
                      
          FOR endt IN (SELECT user_id
                         FROM gipi_wpolbas
                        WHERE line_cd     =  p_line_cd
                          AND subline_cd  =  p_subline_cd
                          AND iss_cd      =  p_iss_cd
                          AND issue_yy    =  p_issue_yy
                          AND NVL(pol_seq_no, 999999)  = NVL (p_pol_seq_no, 999999)
                          AND renew_no    =  p_renew_no)
          LOOP
            v_exist    := 'Y';
            v_user_id  := endt.user_id;
          END LOOP;
                      
          IF v_exist = 'Y' THEN
             IF v_user_id IS NOT NULL THEN
                   v_message       := 'Policy is currently being endorsed by ' || v_user_id || ', cannot create another par for '||
                          'endorsement on the same policy at the same time.';
                   RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#'||v_message);                                                    
             ELSE
                  v_message        := 'Policy is currently being endorsed, cannot create another par for endorsement '||
                          'on the same policy at the same time.';
                  RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#'||v_message);
             END IF;
          END IF;
                      
    END;


PROCEDURE check_policy
(p_line_cd          IN   GIPI_POLBASIC.line_cd%TYPE,
 p_subline_cd       IN   GIPI_POLBASIC.subline_cd%TYPE,
 p_iss_cd           IN   GIPI_POLBASIC.iss_cd%TYPE,
 p_issue_yy         IN   GIPI_POLBASIC.issue_yy%TYPE,
 p_pol_seq_no       IN   GIPI_POLBASIC.pol_seq_no%TYPE,
 p_renew_no         IN   GIPI_POLBASIC.renew_no%TYPE) IS
 
v_user_id     gipi_wpolbas.user_id%TYPE;
v_exist       VARCHAR2(1) := 'N';
v_spld        VARCHAR2(1) := 'N';
v_spld1       VARCHAR2(1) := 'N';
v_spld2       VARCHAR2(1) := 'N';
v_message     VARCHAR2(500);

BEGIN
     FOR tag IN (SELECT spld_flag
                   FROM GIPI_POLBASIC
                  WHERE line_cd     =  p_line_cd
                    AND subline_cd  =  p_subline_cd
                    AND iss_cd      =  p_iss_cd
                    AND issue_yy    =  p_issue_yy
                    AND pol_seq_no  =  p_pol_seq_no
                    AND renew_no    =  p_renew_no)
              LOOP
                IF tag.spld_flag = 2 THEN
                   v_spld := 'Y';
                   EXIT;
                END IF;
              END LOOP;
                      
        IF v_spld2 = 'Y' THEN
             v_message  := 'Policy has been spoiled. Cannot copy to a new par. ';
             RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#I#'||v_message);     
                     
        ELSIF v_spld = 'Y' THEN
             v_message  := 'Policy has been tagged for spoilage. '||
                       'Please do the necessary action before copying to a new par.';
             RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#I#'||v_message);    
        END IF;
                
END;
       
PROCEDURE copy_accident_item(p_policy_id   IN  GIPI_POLBASIC.policy_id%TYPE,
                             p_par_id      IN  GIPI_PARLIST.par_id%TYPE) IS
                             
   CURSOR accident_item_cur IS
   SELECT item_no,date_of_birth,age,civil_status,position_cd,
          monthly_salary,salary_grade,no_of_persons,destination,
          height,weight,sex,ac_class_cd,
          level_cd,parent_level_cd  
     FROM GIPI_ACCIDENT_ITEM
    WHERE policy_id = p_policy_id;

  v_item_no                        GIPI_ACCIDENT_ITEM.item_no%TYPE;
  v_date_of_birth                GIPI_ACCIDENT_ITEM.date_of_birth%TYPE;
  v_age                            GIPI_ACCIDENT_ITEM.age%TYPE;
  v_civil_status                GIPI_ACCIDENT_ITEM.civil_status%TYPE;
  v_position_cd                    GIPI_ACCIDENT_ITEM.position_cd%TYPE;
  v_monthly_salary                GIPI_ACCIDENT_ITEM.monthly_salary%TYPE;
  v_salary_grade                GIPI_ACCIDENT_ITEM.salary_grade%TYPE;
  v_no_of_persons                GIPI_ACCIDENT_ITEM.no_of_persons%TYPE;
  v_destination                    GIPI_ACCIDENT_ITEM.destination%TYPE;
  v_height                      GIPI_ACCIDENT_ITEM.height%TYPE;
  v_weight                      GIPI_ACCIDENT_ITEM.weight%TYPE;
  v_sex                         GIPI_ACCIDENT_ITEM.sex%TYPE;                       
  v_ac_class_cd                 GIPI_ACCIDENT_ITEM.ac_class_cd%TYPE;
  v_level_cd                    GIPI_ACCIDENT_ITEM.level_cd%TYPE;
  v_parent_level_cd             GIPI_ACCIDENT_ITEM.parent_level_cd%TYPE;

BEGIN 
  OPEN accident_item_cur;
  LOOP
    FETCH accident_item_cur
     INTO v_item_no,v_date_of_birth,v_age,v_civil_status,v_position_cd,
          v_monthly_salary,v_salary_grade,v_no_of_persons,v_destination,
          v_height,v_weight,v_sex,v_ac_class_cd,
          v_level_cd,v_parent_level_cd;
     EXIT WHEN accident_item_cur%NOTFOUND;
   INSERT INTO GIPI_WACCIDENT_ITEM
          (par_id, item_no,date_of_birth,age,civil_status,position_cd,
           monthly_salary,salary_grade,no_of_persons,destination,
           height,weight,sex,ac_class_cd,level_cd,parent_level_cd) 
   VALUES (p_par_id,v_item_no,v_date_of_birth,v_age,v_civil_status,v_position_cd,
           v_monthly_salary,v_salary_grade,v_no_of_persons,v_destination,
           v_height,v_weight,v_sex,v_ac_class_cd,
           v_level_cd,v_parent_level_cd);
  END LOOP;
  CLOSE accident_item_cur;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN 
      NULL;
END;


PROCEDURE copy_accident_item_pack (p_policy_id  IN  gipi_polbasic.policy_id%TYPE,
                                   p_item_no    IN  gipi_item.item_no%type,
                                   p_par_id     IN  number) IS
   CURSOR accident_item_cur IS
   SELECT item_no,date_of_birth,age,civil_status,position_cd,
          monthly_salary,salary_grade,no_of_persons,destination,
          height,weight,sex,ac_class_cd,
          level_cd,parent_level_cd  
     FROM gipi_accident_item
    WHERE policy_id = p_policy_id
      AND item_no = p_item_no;

  v_item_no                     gipi_accident_item.item_no%TYPE;
  v_date_of_birth               gipi_accident_item.date_of_birth%TYPE;
  v_age                         gipi_accident_item.age%TYPE;
  v_civil_status                gipi_accident_item.civil_status%TYPE;
  v_position_cd                 gipi_accident_item.position_cd%TYPE;
  v_monthly_salary              gipi_accident_item.monthly_salary%TYPE;
  v_salary_grade                gipi_accident_item.salary_grade%TYPE;
  v_no_of_persons               gipi_accident_item.no_of_persons%TYPE;
  v_destination                 gipi_accident_item.destination%TYPE;
  v_height                      gipi_accident_item.height%TYPE;
  v_weight                      gipi_accident_item.weight%TYPE;
  v_sex                         gipi_accident_item.sex%TYPE;                       
  v_ac_class_cd                 gipi_accident_item.ac_class_cd%TYPE;
  v_level_cd                    gipi_accident_item.level_cd%TYPE;
  v_parent_level_cd             gipi_accident_item.parent_level_cd%TYPE;

BEGIN
  OPEN accident_item_cur;
  LOOP
    FETCH accident_item_cur
     INTO v_item_no,v_date_of_birth,v_age,v_civil_status,v_position_cd,
          v_monthly_salary,v_salary_grade,v_no_of_persons,v_destination,
          v_height,v_weight,v_sex,v_ac_class_cd,
          v_level_cd,v_parent_level_cd;
     EXIT WHEN accident_item_cur%NOTFOUND;
   INSERT INTO gipi_waccident_item
              (par_id, item_no,date_of_birth,age,civil_status,position_cd,
               monthly_salary,salary_grade,no_of_persons,destination,
               height,weight,sex,ac_class_cd,level_cd,parent_level_cd) 
       VALUES (p_par_id,v_item_no,v_date_of_birth,v_age,v_civil_status,v_position_cd,
               v_monthly_salary,v_salary_grade,v_no_of_persons,v_destination,
               v_height,v_weight,v_sex,v_ac_class_cd,
               v_level_cd,v_parent_level_cd);
  END LOOP;
  CLOSE accident_item_cur;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN 
      NULL;
END;



PROCEDURE copy_item  
(p_policy_id IN gipi_polbasic.policy_id%type,
 p_line_cd          IN   GIPI_POLBASIC.line_cd%TYPE,
 p_subline_cd       IN   GIPI_POLBASIC.subline_cd%TYPE,
 p_iss_cd           IN   GIPI_POLBASIC.iss_cd%TYPE,
 p_issue_yy         IN   GIPI_POLBASIC.issue_yy%TYPE,
 p_pol_seq_no       IN   GIPI_POLBASIC.pol_seq_no%TYPE,
 p_renew_no         IN   GIPI_POLBASIC.renew_no%TYPE,
 p_par_type         IN   GIPI_PARLIST.par_type%TYPE,
 p_par_id           IN   GIPI_PARLIST.par_id%TYPE) IS
 
   CURSOR item_cur IS
   SELECT item_grp,item_no,item_title,item_desc,item_desc2,tsi_amt,prem_amt,
          ann_tsi_amt,ann_prem_amt,rec_flag,currency_cd,currency_rt,group_cd,
          from_date,to_date,pack_line_cd,pack_subline_cd,discount_sw,other_info,
          coverage_cd,surcharge_sw, region_cd, changed_tag, pack_ben_cd, payt_terms,
          risk_no, risk_item_no
     FROM GIPI_ITEM
    WHERE policy_id = p_policy_id;

  v_item_grp                GIPI_ITEM.item_grp%TYPE;
  v_item_no                 GIPI_ITEM.item_no%TYPE;
  v_item_title              GIPI_ITEM.item_title%TYPE;
  v_item_desc               GIPI_ITEM.item_desc%TYPE;
  v_item_desc2              GIPI_ITEM.item_desc%TYPE;
  v_tsi_amt                 GIPI_ITEM.tsi_amt%TYPE;
  v_prem_amt                GIPI_ITEM.prem_amt%TYPE;
  v_ann_tsi_amt             GIPI_ITEM.ann_tsi_amt%TYPE;
  v_ann_prem_amt            GIPI_ITEM.ann_prem_amt%TYPE;
  v_rec_flag                GIPI_ITEM.rec_flag%TYPE;
  v_currency_cd             GIPI_ITEM.currency_cd%TYPE;
  v_currency_rt             GIPI_ITEM.currency_rt%TYPE;
  v_group_cd                GIPI_ITEM.group_cd%TYPE;
  v_from_date               GIPI_ITEM.from_date%TYPE;
  v_to_date                 GIPI_ITEM.to_date%TYPE;
  v_pack_line_cd            GIPI_ITEM.pack_line_cd%TYPE;
  v_pack_subline_cd         GIPI_ITEM.pack_subline_cd%TYPE;
  v_discount_sw             GIPI_ITEM.discount_sw%TYPE;
  v_other_info              GIPI_ITEM.other_info%TYPE;
  v_coverage_cd             GIPI_ITEM.coverage_cd%TYPE;
  v_surcharge_sw            GIPI_ITEM.surcharge_sw%TYPE;
  v_region_cd                  GIPI_ITEM.region_cd%TYPE;
  v_changed_tag             GIPI_ITEM.changed_tag%TYPE;
  v_pack_ben_cd             GIPI_ITEM.pack_ben_cd%TYPE;
  v_payt_terms              GIPI_ITEM.payt_terms%TYPE;
  v_risk_no                 GIPI_ITEM.risk_no%TYPE;
  v_risk_item_no            GIPI_ITEM.risk_item_no%TYPE;
  v_exist                   VARCHAR2(1) := 'N'; -- added by jdiago 07.28.2014
  
BEGIN
  OPEN item_cur;
  LOOP
    FETCH item_cur
     INTO v_item_grp,v_item_no,v_item_title,v_item_desc,v_item_desc2,
          v_tsi_amt,v_prem_amt,v_ann_tsi_amt,v_ann_prem_amt,v_rec_flag,
          v_currency_cd,v_currency_rt,v_group_cd,v_from_date,v_to_date,
          v_pack_line_cd,v_pack_subline_cd,v_discount_sw,v_other_info,
          v_coverage_cd,v_surcharge_sw, v_region_cd, v_changed_tag,
          v_pack_ben_cd, v_payt_terms, v_risk_no, v_risk_item_no;
     EXIT WHEN item_cur%NOTFOUND;
     IF p_par_type = 'E' THEN  
        v_tsi_amt   := 0;
        v_prem_amt  := 0;
        FOR A1 IN (SELECT  b480.ann_tsi_amt tsi,b480.ann_prem_amt prem
                     FROM  GIPI_POLBASIC b250, GIPI_ITEM b480
                    WHERE  b250.policy_id   = b480.policy_id
                      AND  b480.item_no     = v_item_no
                      AND  b250.line_cd     = p_line_cd
                      AND  b250.subline_cd  = p_subline_cd
                      AND  b250.iss_cd      = p_iss_cd
                      AND  b250.issue_yy    = p_issue_yy
                      AND  b250.pol_seq_no  = p_pol_seq_no
                      AND  b250.renew_no    = p_renew_no
                      AND  b250.pol_flag   IN ('1','2','3')                       
                   ORDER BY b250.eff_date DESC, b250.endt_seq_no  DESC )
        LOOP
          v_ann_tsi_amt   := A1.tsi;
          v_ann_prem_amt  := A1.prem;
          EXIT;
       END LOOP;        
     END IF;
     --added checking of referential constraint from table gipi_wpack_line_subline 07.28.2014
     FOR gwls IN (SELECT 1
                    FROM gipi_wpack_line_subline
                   WHERE par_id = p_par_id
                     AND pack_line_cd = v_pack_line_cd
                     AND pack_subline_cd = v_pack_subline_cd)
     LOOP
        v_exist := 'Y';
     END LOOP;
         
     IF v_exist = 'N' THEN
        cpi.giuts008_pkg.copy_pack_line_subline(p_policy_id, p_par_id);
     END IF;
         
     INSERT INTO GIPI_WITEM
                (par_id,item_grp,item_no,item_title,item_desc,item_desc2,tsi_amt,
                 prem_amt,ann_tsi_amt,ann_prem_amt,rec_flag,currency_cd,currency_rt,
                 group_cd,from_date,to_date,pack_line_cd,pack_subline_cd,discount_sw,
                 other_info,coverage_cd,surcharge_sw,region_cd,changed_tag,
                 pack_ben_cd, payt_terms, risk_no, risk_item_no )
         VALUES (p_par_id,v_item_grp,v_item_no,v_item_title,v_item_desc,v_item_desc2,v_tsi_amt,
                 v_prem_amt,v_ann_tsi_amt,v_ann_prem_amt,v_rec_flag,v_currency_cd,v_currency_rt,
                 v_group_cd,v_from_date,v_to_date,v_pack_line_cd,v_pack_subline_cd,v_discount_sw,
                 v_other_info,v_coverage_cd,v_surcharge_sw,v_region_cd, v_changed_tag,
                 v_pack_ben_cd, v_payt_terms, v_risk_no, v_risk_item_no);
  END LOOP;
  CLOSE item_cur;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN 
      NULL;
END;


PROCEDURE copy_polbas_discount (p_policy_id IN  GIPI_PERIL_DISCOUNT.policy_id%TYPE,
                                p_par_id    IN  GIPI_PARLIST.par_id%TYPE) IS
   CURSOR disc_cur IS
   SELECT line_cd, disc_rt,disc_amt,net_gross_tag,
          subline_cd,orig_prem_amt,net_prem_amt,sequence,
          remarks,last_update,surcharge_rt,surcharge_amt
     FROM GIPI_POLBASIC_DISCOUNT
    WHERE policy_id = p_policy_id;

  v_line_cd          GIPI_PERIL_DISCOUNT.line_cd%TYPE;
  v_disc_rt          GIPI_PERIL_DISCOUNT.disc_rt%TYPE;
  v_disc_amt         GIPI_PERIL_DISCOUNT.disc_amt%TYPE;
  v_net_gross_tag    GIPI_PERIL_DISCOUNT.net_gross_tag%TYPE;
  v_subline_cd       GIPI_PERIL_DISCOUNT.subline_cd%TYPE;
  v_orig_prem_amt    GIPI_POLBASIC_DISCOUNT.orig_prem_amt%TYPE;
  v_net_prem_amt     GIPI_PERIL_DISCOUNT.net_prem_amt%TYPE;
  v_sequence         GIPI_PERIL_DISCOUNT.sequence%TYPE;
  v_remarks          GIPI_PERIL_DISCOUNT.remarks%TYPE;
  v_last_update      GIPI_PERIL_DISCOUNT.last_update%TYPE;
  v_surcharge_rt     GIPI_PERIL_DISCOUNT.surcharge_rt%TYPE;
  v_surcharge_amt    GIPI_PERIL_DISCOUNT.surcharge_amt%TYPE;  
      
BEGIN
  OPEN disc_cur;
  LOOP
    FETCH disc_cur
     INTO v_line_cd,v_disc_rt,v_disc_amt,v_net_gross_tag,
          v_subline_cd,v_orig_prem_amt,v_net_prem_amt,v_sequence,
          v_remarks,v_last_update,v_surcharge_rt,v_surcharge_amt;
     EXIT WHEN disc_cur%NOTFOUND;
    INSERT INTO GIPI_WPOLBAS_DISCOUNT
               (par_id,line_cd,disc_rt,
                disc_amt,net_gross_tag,
                subline_cd,orig_prem_amt,net_prem_amt,
                sequence,remarks,last_update,
                surcharge_rt,surcharge_amt)
        VALUES (p_par_id,v_line_cd,v_disc_rt,
                v_disc_amt,v_net_gross_tag,
                v_subline_cd, v_orig_prem_amt,v_net_prem_amt,
                v_sequence,v_remarks,v_last_update,
                v_surcharge_rt,v_surcharge_amt);
  END LOOP;
  CLOSE disc_cur;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      NULL;
END;

       
PROCEDURE copy_itemds (p_policy_id IN giuw_pol_dist.policy_id%TYPE,
                       p_dist_no    IN number) IS
   CURSOR itemds_cur IS
   SELECT dist_seq_no,item_no,tsi_amt,prem_amt,ann_tsi_amt
     FROM giuw_itemds
    WHERE dist_no = (SELECT dist_no
                       FROM giuw_pol_dist
                      WHERE policy_id = p_policy_id);

  v_dist_seq_no                giuw_itemds.dist_seq_no%TYPE;
  v_item_no                        giuw_itemds.item_no%TYPE;
  v_tsi_amt                        giuw_itemds.tsi_amt%TYPE;
  v_prem_amt                    giuw_itemds.prem_amt%TYPE;
  v_ann_tsi_amt                giuw_itemds.ann_tsi_amt%TYPE;
  v_message                 VARCHAR2(500);

BEGIN  
  v_message     :=      'Copy item distribution info ...';
  OPEN itemds_cur;
  LOOP
    FETCH itemds_cur
     INTO v_dist_seq_no,v_item_no,v_tsi_amt,v_prem_amt,
          v_ann_tsi_amt;  
     EXIT WHEN itemds_cur%NOTFOUND;
    INSERT INTO giuw_witemds
           (dist_no,dist_seq_no,item_no,tsi_amt,prem_amt,
            ann_tsi_amt) 
    VALUES (p_dist_no,v_dist_seq_no,v_item_no,v_tsi_amt,v_prem_amt,
            v_ann_tsi_amt);
  END LOOP;
  CLOSE itemds_cur;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      NULL;
END;

PROCEDURE copy_itemds_dtl (p_policy_id IN giuw_pol_dist.policy_id%TYPE,
                           p_dist_no    IN  number) IS
   CURSOR itemds_dtl_cur IS
   SELECT dist_seq_no,item_no,line_cd,share_cd,dist_spct,
          dist_spct1,  
          dist_tsi,dist_prem,ann_dist_spct,ann_dist_tsi,dist_grp
     FROM giuw_itemds_dtl
    WHERE dist_no = (SELECT dist_no
                       FROM giuw_pol_dist
                      WHERE policy_id = p_policy_id)
      AND item_no = (SELECT item_no
                       FROM giuw_witemds
                      WHERE dist_no = (SELECT dist_no
                                         FROM giuw_pol_dist
                                        WHERE policy_id = p_policy_id));

  v_dist_seq_no                giuw_itemds_dtl.dist_seq_no%TYPE;
  v_item_no                        giuw_itemds_dtl.item_no%TYPE;
  v_line_cd                        giuw_itemds_dtl.line_cd%TYPE;
  v_share_cd                    giuw_itemds_dtl.share_cd%TYPE;
  v_dist_spct                    giuw_itemds_dtl.dist_spct%TYPE;
  v_dist_spct1                giuw_itemds_dtl.dist_spct1%TYPE;
  v_dist_tsi                    giuw_itemds_dtl.dist_tsi%TYPE;
  v_dist_prem                    giuw_itemds_dtl.dist_prem%TYPE;
  v_ann_dist_spct            giuw_itemds_dtl.ann_dist_spct%TYPE;
  v_ann_dist_tsi            giuw_itemds_dtl.ann_dist_tsi%TYPE;
  v_dist_grp                    giuw_itemds_dtl.dist_grp%TYPE;
  v_message                 varchar2(500);

BEGIN
  v_message         :=  'Copy item distribution details info ...';
  OPEN itemds_dtl_cur;
  LOOP
    FETCH itemds_dtl_cur
     INTO v_dist_seq_no,v_item_no,v_line_cd,v_share_cd,v_dist_spct,v_dist_spct1,
          v_dist_tsi,v_dist_prem,v_ann_dist_spct,v_ann_dist_tsi,v_dist_grp;
     EXIT WHEN itemds_dtl_cur%NOTFOUND;
    INSERT INTO giuw_witemds_dtl
           (dist_no,dist_seq_no,item_no,line_cd,share_cd,dist_spct,dist_spct1,
            dist_tsi,dist_prem,ann_dist_spct,ann_dist_tsi,dist_grp)
    VALUES (p_dist_no,v_dist_seq_no,v_item_no,v_line_cd,v_share_cd,v_dist_spct,v_dist_spct1,
            v_dist_tsi,v_dist_prem,v_ann_dist_spct,v_ann_dist_tsi,v_dist_grp);
  END LOOP;
  CLOSE itemds_dtl_cur;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      NULL;
END;

PROCEDURE copy_itemperilds (p_policy_id IN giuw_pol_dist.policy_id%TYPE,
                            p_dist_no   IN number) IS
   CURSOR itemperilds_cur IS
   SELECT dist_seq_no,item_no,peril_cd,line_cd,tsi_amt,prem_amt,ann_tsi_amt
     FROM giuw_itemperilds
    WHERE dist_no = (SELECT dist_no
                       FROM giuw_pol_dist
                      WHERE policy_id = p_policy_id);

  v_dist_seq_no                giuw_itemperilds.dist_seq_no%TYPE;
  v_item_no                        giuw_itemperilds.item_no%TYPE;
  v_peril_cd                    giuw_itemperilds.peril_cd%TYPE;
  v_line_cd                        giuw_itemperilds.line_cd%TYPE;
  v_tsi_amt                        giuw_itemperilds.tsi_amt%TYPE;
  v_prem_amt                    giuw_itemperilds.prem_amt%TYPE;
  v_ann_tsi_amt                giuw_itemperilds.ann_tsi_amt%TYPE;
  v_message             varchar2(500);

BEGIN
  v_message             :=      'Copy item-peril distribution info ...';
  OPEN itemperilds_cur;
  LOOP
    FETCH itemperilds_cur
     INTO v_dist_seq_no,v_item_no,v_peril_cd,
          v_line_cd,v_tsi_amt,v_prem_amt,v_ann_tsi_amt;
     EXIT WHEN itemperilds_cur%NOTFOUND;
   INSERT INTO giuw_witemperilds
                   (dist_no,dist_seq_no,item_no,peril_cd,
                    line_cd,tsi_amt,prem_amt,ann_tsi_amt)
         VALUES (p_dist_no,v_dist_seq_no,v_item_no,v_peril_cd,
                    v_line_cd,v_tsi_amt,v_prem_amt,v_ann_tsi_amt);
  END LOOP;
  CLOSE itemperilds_cur;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      NULL;
END;

FUNCTION get_dist_no
    RETURN number
    IS
        v_dist_no   number;
    BEGIN
    SELECT pol_dist_dist_no_s.nextval
      INTO v_dist_no
      FROM sys.dual;
    EXCEPTION
      WHEN OTHERS THEN
       null;
     RETURN v_dist_no;
  END;
  
PROCEDURE copy_itemperilds_dtl (p_policy_id IN giuw_pol_dist.policy_id%TYPE,
                                p_dist_no   IN number) IS
   CURSOR itemperilds_dtl_cur IS
   SELECT dist_seq_no,item_no,line_cd,peril_cd,share_cd,dist_spct,
          dist_spct1,  
          dist_tsi,dist_prem,ann_dist_spct,ann_dist_tsi,dist_grp
     FROM giuw_itemperilds_dtl
    WHERE dist_no = (SELECT dist_no
                       FROM giuw_pol_dist
                      WHERE policy_id = p_policy_id)
      AND item_no = (SELECT item_no
                       FROM giuw_witemperilds
                      WHERE dist_no = (SELECT dist_no
                                         FROM giuw_pol_dist
                                        WHERE policy_id = p_policy_id))
      AND peril_cd = (SELECT peril_cd
                        FROM giuw_witemperilds
                       WHERE dist_no = (SELECT dist_no
                                          FROM giuw_pol_dist
                                         WHERE policy_id = p_policy_id));

  v_dist_seq_no                giuw_itemperilds_dtl.dist_seq_no%TYPE;
  v_item_no                        giuw_itemperilds_dtl.item_no%TYPE;
  v_line_cd                        giuw_itemperilds_dtl.line_cd%TYPE;
  v_peril_cd                    giuw_itemperilds_dtl.peril_cd%TYPE;
  v_share_cd                    giuw_itemperilds_dtl.share_cd%TYPE;
  v_dist_spct                    giuw_itemperilds_dtl.dist_spct%TYPE;
  v_dist_spct1                giuw_itemperilds_dtl.dist_spct1%TYPE;
  v_dist_tsi                    giuw_itemperilds_dtl.dist_tsi%TYPE;
  v_dist_prem                    giuw_itemperilds_dtl.dist_prem%TYPE;
  v_ann_dist_spct            giuw_itemperilds_dtl.ann_dist_spct%TYPE;
  v_ann_dist_tsi            giuw_itemperilds_dtl.ann_dist_tsi%TYPE;
  v_dist_grp                    giuw_itemperilds_dtl.dist_grp%TYPE;
  v_message                     varchar2(500);

BEGIN
  v_message         :=      'Copy item-peril distribution details info ...';
  OPEN itemperilds_dtl_cur;
  LOOP
    FETCH itemperilds_dtl_cur
     INTO v_dist_seq_no,v_item_no,v_line_cd,v_peril_cd,v_share_cd,v_dist_spct,v_dist_spct1,
          v_dist_tsi,v_dist_prem,v_ann_dist_spct,v_ann_dist_tsi,v_dist_grp;
     EXIT WHEN itemperilds_dtl_cur%NOTFOUND;
   INSERT INTO giuw_witemperilds_dtl
              (dist_no,dist_seq_no,item_no,line_cd,peril_cd,share_cd,dist_spct,dist_spct1,
               dist_tsi,dist_prem,ann_dist_spct,ann_dist_tsi,dist_grp)
       VALUES (p_dist_no,v_dist_seq_no,v_item_no,v_line_cd,v_peril_cd,v_share_cd,v_dist_spct,v_dist_spct1,
               v_dist_tsi,v_dist_prem,v_ann_dist_spct,v_ann_dist_tsi,v_dist_grp);
  END LOOP;
  CLOSE itemperilds_dtl_cur;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      NULL;
END;


PROCEDURE copy_item_discount  (p_policy_id   IN  GIPI_PERIL_DISCOUNT.policy_id%TYPE,
                               p_par_id      IN  GIPI_PARLIST.par_id%TYPE) IS
   CURSOR disc_cur IS
   SELECT line_cd,item_no,disc_rt,disc_amt,net_gross_tag,
          subline_cd,orig_prem_amt,net_prem_amt,
          sequence,remarks,last_update,surcharge_rt,surcharge_amt
     FROM GIPI_ITEM_DISCOUNT
    WHERE policy_id = p_policy_id;

  v_line_cd                      GIPI_PERIL_DISCOUNT.line_cd%TYPE;
  v_item_no                      GIPI_PERIL_DISCOUNT.item_no%TYPE;
  v_disc_rt                      GIPI_PERIL_DISCOUNT.disc_rt%TYPE;
  v_disc_amt                     GIPI_PERIL_DISCOUNT.disc_amt%TYPE;
  v_net_gross_tag                GIPI_PERIL_DISCOUNT.net_gross_tag%TYPE;
  v_subline_cd                   GIPI_PERIL_DISCOUNT.subline_cd%TYPE;
  v_orig_prem_amt                GIPI_POLBASIC_DISCOUNT.orig_prem_amt%TYPE;
  v_net_prem_amt                 GIPI_PERIL_DISCOUNT.net_prem_amt%TYPE;
  v_sequence                     GIPI_PERIL_DISCOUNT.sequence%TYPE;
  v_remarks                      GIPI_PERIL_DISCOUNT.remarks%TYPE;
  v_last_update                  GIPI_PERIL_DISCOUNT.last_update%TYPE;
  v_surcharge_rt                 GIPI_PERIL_DISCOUNT.surcharge_rt%TYPE;
  v_surcharge_amt                GIPI_PERIL_DISCOUNT.surcharge_amt%TYPE;
  v_message                      VARCHAR2(500);
  
BEGIN
  v_message         :=         'Copying discount peril ...';
  OPEN disc_cur;
  LOOP
    FETCH disc_cur
     INTO v_line_cd,v_item_no,v_disc_rt,v_disc_amt,v_net_gross_tag,
          v_subline_cd,v_orig_prem_amt,v_net_prem_amt,
          v_sequence,v_remarks,v_last_update,v_surcharge_rt,v_surcharge_amt;
     EXIT WHEN disc_cur%NOTFOUND;
    INSERT INTO GIPI_WITEM_DISCOUNT
               (par_id,line_cd,item_no,disc_rt,disc_amt,net_gross_tag,
                subline_cd,orig_prem_amt,net_prem_amt,
                sequence,remarks,last_update,surcharge_rt,surcharge_amt)
        VALUES (p_par_id,v_line_cd,v_item_no,v_disc_rt,v_disc_amt,v_net_gross_tag,
                v_subline_cd, v_orig_prem_amt,v_net_prem_amt,
                v_sequence,v_remarks,v_last_update,v_surcharge_rt,v_surcharge_amt);
  END LOOP;
  CLOSE disc_cur;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      NULL;
END;

 
FUNCTION get_par_id
    RETURN number
    IS
        v_par_id    number;
    BEGIN
    SELECT parlist_par_id_s.nextval
      INTO v_par_id
      FROM DUAL;            
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        null;
      RETURN v_par_id;
    END;
    


PROCEDURE copy_item_pack (p_policy_id       IN gipi_polbasic.policy_id%type,
                          p_item_no         IN gipi_item.item_no%TYPE,
                          p_line_cd         IN varchar2,
                          p_subline_cd      IN varchar2,
                          p_iss_cd          IN varchar2,
                          p_issue_yy        IN number,
                          p_pol_seq_no      IN number,
                          p_renew_no        IN number,
                          p_par_id          IN number) IS
   CURSOR item_cur IS
   SELECT item_grp,item_no,item_title,item_desc,item_desc2,tsi_amt,prem_amt,
          ann_tsi_amt,ann_prem_amt,rec_flag,currency_cd,currency_rt,group_cd,
          from_date,to_date,pack_line_cd,pack_subline_cd,discount_sw,other_info,
          coverage_cd,surcharge_sw, region_cd, changed_tag
     FROM gipi_item
    WHERE policy_id = p_policy_id
      AND item_no = p_item_no;

  v_item_grp                gipi_item.item_grp%TYPE;
  v_item_no                 gipi_item.item_no%TYPE;
  v_item_title              gipi_item.item_title%TYPE;
  v_item_desc               gipi_item.item_desc%TYPE;
  v_item_desc2              gipi_item.item_desc%TYPE;
  v_tsi_amt                 gipi_item.tsi_amt%TYPE;
  v_prem_amt                gipi_item.prem_amt%TYPE;
  v_ann_tsi_amt             gipi_item.ann_tsi_amt%TYPE;
  v_ann_prem_amt            gipi_item.ann_prem_amt%TYPE;
  v_rec_flag                gipi_item.rec_flag%TYPE;
  v_currency_cd             gipi_item.currency_cd%TYPE;
  v_currency_rt             gipi_item.currency_rt%TYPE;
  v_group_cd                gipi_item.group_cd%TYPE;
  v_from_date               gipi_item.from_date%TYPE;
  v_to_date                 gipi_item.to_date%TYPE;
  v_pack_line_cd            gipi_item.pack_line_cd%TYPE;
  v_pack_subline_cd         gipi_item.pack_subline_cd%TYPE;
  v_discount_sw             gipi_item.discount_sw%TYPE;
  v_other_info              gipi_item.other_info%TYPE;
  v_coverage_cd             gipi_item.coverage_cd%TYPE;
  v_surcharge_sw            gipi_item.surcharge_sw%TYPE;
  v_region_cd                    gipi_item.region_cd%TYPE;
  v_changed_tag                gipi_item.changed_tag%TYPE;
  v_message                 varchar2(500);
  
BEGIN
  v_message         :=      'Copying item info ...';
  OPEN item_cur;
  LOOP
    FETCH item_cur
     INTO v_item_grp,v_item_no,v_item_title,v_item_desc,v_item_desc2,v_tsi_amt,
          v_prem_amt,v_ann_tsi_amt,v_ann_prem_amt,v_rec_flag,v_currency_cd,
          v_currency_rt,v_group_cd,v_from_date,v_to_date,v_pack_line_cd,
          v_pack_subline_cd,v_discount_sw,v_other_info,v_coverage_cd,v_surcharge_sw,
          v_region_cd, v_changed_tag;
     EXIT WHEN item_cur%NOTFOUND;
    IF GIUTS008_PKG.get_par_type(p_policy_id) = 'E' THEN  
        v_tsi_amt   := 0;
        v_prem_amt  := 0;
        FOR A1 IN (SELECT  b480.ann_tsi_amt tsi,b480.ann_prem_amt prem
                     FROM  gipi_polbasic b250, gipi_item b480
                    WHERE  b250.policy_id   = b480.policy_id
                      AND  b480.item_no     = v_item_no
                      AND  b250.line_cd     = p_line_cd
                      AND  b250.subline_cd  = p_subline_cd
                      AND  b250.iss_cd      = p_iss_cd
                      AND  b250.issue_yy    = p_issue_yy
                      AND  b250.pol_seq_no  = p_pol_seq_no
                      AND  b250.renew_no    = p_renew_no
                      AND  b250.pol_flag   IN ('1','2','3')                       
                   ORDER BY b250.eff_date DESC, b250.endt_seq_no  DESC )
        LOOP
          v_ann_tsi_amt   := A1.tsi;
          v_ann_prem_amt  := A1.prem;
          EXIT;
        END LOOP;        
    END IF;
     INSERT INTO gipi_witem
                (par_id,item_no,item_grp,item_title,item_desc,item_desc2,tsi_amt,
                 prem_amt,ann_tsi_amt,ann_prem_amt,rec_flag,currency_cd,
                 currency_rt,group_cd,from_date,to_date,pack_line_cd,
                 pack_subline_cd,discount_sw,other_info,coverage_cd,surcharge_sw,
                 region_cd,changed_tag)
         VALUES (p_par_id,v_item_no,v_item_grp,v_item_title,v_item_desc,v_item_desc2,v_tsi_amt,
                 v_prem_amt,v_ann_tsi_amt,v_ann_prem_amt,v_rec_flag,v_currency_cd,
                 v_currency_rt,v_group_cd,v_from_date,v_to_date,v_pack_line_cd,
                 v_pack_subline_cd,v_discount_sw,v_other_info,v_coverage_cd,v_surcharge_sw,
                 v_region_cd, v_changed_tag);
  END LOOP;
  CLOSE item_cur;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN 
      NULL;
END;


FUNCTION get_par_type(p_policy_id           number)
 RETURN varchar2
 IS
    v_par_type  varchar2(100);
 BEGIN
    FOR par in
      (SELECT b.par_type type
         FROM gipi_polbasic a, gipi_parlist b
        WHERE a.policy_id = p_policy_id
          AND a.par_id    = b.par_id) LOOP
       v_par_type := par.type;
      EXIT;
  END LOOP; 
    RETURN v_par_type;
 END;
 
 
PROCEDURE copy_item_ves (p1_policy_id IN gipi_item_ves.policy_id%TYPE,
                         p_par_id       IN number) IS
   CURSOR item_ves_cur IS
   SELECT item_no,vessel_cd,geog_limit,rec_flag,deduct_text,dry_date,dry_place
     FROM gipi_item_ves
    WHERE policy_id = p1_policy_id;

  v_item_no           gipi_item_ves.item_no%TYPE;
  v_vessel_cd         gipi_item_ves.vessel_cd%TYPE;
  v_geog_limit        gipi_item_ves.geog_limit%TYPE;
  v_rec_flag          gipi_item_ves.rec_flag%TYPE;
  v_deduct_text       gipi_item_ves.deduct_text%TYPE;
  v_dry_date          gipi_item_ves.dry_date%TYPE;
  v_dry_place         gipi_item_ves.dry_place%TYPE;
  v_message           varchar2(500);

BEGIN
  v_message         :=      'Copying item vessel info ...';
  OPEN item_ves_cur;
  LOOP
    FETCH item_ves_cur
     INTO v_item_no,v_vessel_cd,v_geog_limit,v_rec_flag,v_deduct_text,v_dry_date,v_dry_place;
     EXIT WHEN item_ves_cur%NOTFOUND;
   INSERT INTO gipi_witem_ves
              (par_id,
               item_no,
               vessel_cd,
               geog_limit,
               rec_flag,
               deduct_text,
               dry_date,
               dry_place)
       VALUES (p_par_id,
               v_item_no,
               v_vessel_cd,
               v_geog_limit,
               v_rec_flag,
               v_deduct_text,
               v_dry_date,
               v_dry_place);
  END LOOP;
  CLOSE item_ves_cur;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      NULL;
END;


PROCEDURE copy_item_ves_pack (p1_policy_id IN gipi_item_ves.policy_id%TYPE,
                              p_item_no    IN gipi_item.item_no%type,
                              p_par_id      IN number) IS
  CURSOR item_ves_cur IS
  SELECT item_no,vessel_cd,geog_limit,rec_flag,deduct_text,dry_date,dry_place
    FROM gipi_item_ves
   WHERE policy_id = p1_policy_id
     AND item_no = p_item_no;

  v_item_no               gipi_item_ves.item_no%TYPE;
  v_vessel_cd             gipi_item_ves.vessel_cd%TYPE;
  v_geog_limit            gipi_item_ves.geog_limit%TYPE;
  v_rec_flag              gipi_item_ves.rec_flag%TYPE;
  v_deduct_text           gipi_item_ves.deduct_text%TYPE;
  v_dry_date              gipi_item_ves.dry_date%TYPE;
  v_dry_place             gipi_item_ves.dry_place%TYPE;
  v_message               varchar2(500);

BEGIN
  v_message         :=  'Copying item vessel info ...';
  OPEN item_ves_cur;
  LOOP
    FETCH item_ves_cur
     INTO v_item_no,v_vessel_cd,v_geog_limit,v_rec_flag,
          v_deduct_text,v_dry_date,v_dry_place;
     EXIT WHEN item_ves_cur%NOTFOUND;
    INSERT INTO gipi_witem_ves
               (par_id,item_no,vessel_cd,geog_limit,rec_flag,deduct_text,dry_date,dry_place)
        VALUES (p_par_id,v_item_no,v_vessel_cd,v_geog_limit,v_rec_flag,v_deduct_text,v_dry_date,v_dry_place);
  END LOOP;
  CLOSE item_ves_cur;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      NULL;
END;

PROCEDURE copy_itmperil (p_policy_id     IN   GIPI_POLBASIC.policy_id%type,
                         p_line_cd       IN   GIPI_POLBASIC.line_cd%TYPE,
                         p_par_id        IN   GIPI_PARLIST.par_id%TYPE) 
IS
      CURSOR itmperil_cur IS
      SELECT item_no, peril_cd, line_cd, rec_flag, tarf_cd, prem_rt, tsi_amt,
             prem_amt, ann_tsi_amt, ann_prem_amt, comp_rem, discount_sw,
             ri_comm_rate, ri_comm_amt, surcharge_sw, aggregate_sw,
             no_of_days, base_amt
        FROM GIPI_ITMPERIL 
       WHERE policy_id = p_policy_id;

  v_item_no               GIPI_ITMPERIL.item_no%TYPE;
  v_peril_cd              GIPI_ITMPERIL.peril_cd%TYPE;
  v_line_cd               GIPI_ITMPERIL.line_cd%TYPE;
  v_rec_flag              GIPI_ITMPERIL.rec_flag%TYPE;
  v_tarf_cd               GIPI_ITMPERIL.tarf_cd%TYPE;
  v_prem_rt               GIPI_ITMPERIL.prem_rt%TYPE;
  v_tsi_amt               GIPI_ITMPERIL.tsi_amt%TYPE;
  v_prem_amt              GIPI_ITMPERIL.prem_amt%TYPE;
  v_ann_tsi_amt           GIPI_ITMPERIL.ann_tsi_amt%TYPE;
  v_ann_prem_amt          GIPI_ITMPERIL.ann_prem_amt%TYPE;
  v_comp_rem              GIPI_ITMPERIL.comp_rem%TYPE;
  v_discount_sw           GIPI_ITMPERIL.discount_sw%TYPE;
  v_ri_comm_rate          GIPI_ITMPERIL.ri_comm_rate%TYPE;
  v_ri_comm_amt           GIPI_ITMPERIL.ri_comm_amt%TYPE;
  v_surcharge_sw          GIPI_ITMPERIL.surcharge_sw%TYPE;
  v_aggregate_sw          GIPI_ITMPERIL.aggregate_sw%TYPE;
  v_no_of_days            GIPI_ITMPERIL.no_of_days%TYPE;
  v_base_amt              GIPI_ITMPERIL.base_amt%TYPE;
  v_inv_curr_rt           GIPI_WCARGO.inv_curr_rt%TYPE;
  v_invoice_value         GIPI_WCARGO.invoice_value%TYPE;
  v_markup_rate           GIPI_WCARGO.markup_rate%TYPE;
  v_line                  GIIS_LINE.menu_line_cd%TYPE;  
  v_message               VARCHAR2(500);
  
      CURSOR mn_cur IS
      SELECT NVL (inv_curr_rt, -1), NVL (invoice_value, -1), NVL (markup_rate, -1)
        FROM GIPI_CARGO
       WHERE policy_id = p_policy_id
         AND item_no = v_item_no;
  
BEGIN
  v_message             :=      'Copying item peril info ...';
  SELECT menu_line_cd
    INTO v_line
    FROM GIIS_LINE
   WHERE line_cd = p_line_cd;
   
  OPEN itmperil_cur;
  LOOP
    FETCH itmperil_cur
     INTO v_item_no,v_peril_cd,v_line_cd,v_rec_flag,v_tarf_cd,
          v_prem_rt,v_tsi_amt,v_prem_amt,v_ann_tsi_amt,v_ann_prem_amt,
          v_comp_rem,v_discount_sw,v_ri_comm_rate,v_ri_comm_amt,
          v_surcharge_sw, v_aggregate_sw, v_no_of_days, v_base_amt;
     EXIT WHEN itmperil_cur%NOTFOUND;
   OPEN mn_cur;
   
   LOOP
       FETCH mn_cur
        INTO v_inv_curr_rt, v_invoice_value, v_markup_rate;
        EXIT WHEN mn_cur%NOTFOUND;
   END LOOP;
   CLOSE mn_cur;
     
   IF (p_line_cd = 'MN' OR v_line = 'MN') AND GIISP.v ('MARINE_TSI_AMT') = 'Y'
               AND (    v_inv_curr_rt <> -1
                    AND v_invoice_value <> -1
                    AND v_markup_rate <> -1
                   ) THEN
          v_tsi_amt      := (v_invoice_value +(v_invoice_value *(v_markup_rate/100))) * v_inv_curr_rt; 
          v_prem_amt     := v_tsi_amt * (v_prem_rt * 0.01); 
          v_ann_tsi_amt  := v_tsi_amt;
          v_ann_prem_amt := v_prem_amt;
   
   
   END IF;
   --
       
   INSERT INTO GIPI_WITMPERL
              (par_id,item_no,line_cd,peril_cd,tarf_cd,
                 prem_rt,tsi_amt,prem_amt,ann_tsi_amt,ann_prem_amt,
               rec_flag,comp_rem,discount_sw,ri_comm_rate,ri_comm_amt,
               surcharge_sw, aggregate_sw, no_of_days, base_amt) 
       VALUES (p_par_id,v_item_no,v_line_cd,v_peril_cd,v_tarf_cd,
                 v_prem_rt,v_tsi_amt,v_prem_amt,v_ann_tsi_amt,v_ann_prem_amt,
                 v_rec_flag,v_comp_rem,v_discount_sw,v_ri_comm_rate,v_ri_comm_amt,
                 v_surcharge_sw, v_aggregate_sw, v_no_of_days, v_base_amt);
   END LOOP;
  
  IF (p_line_cd = 'MN' OR v_line = 'MN') AND GIISP.v ('MARINE_TSI_AMT') = 'Y'
               AND (    v_inv_curr_rt <> -1
                    AND v_invoice_value <> -1
                    AND v_markup_rate <> -1
                   ) THEN
    FOR gwi IN (SELECT DISTINCT item_no
                  FROM GIPI_WITEM
                 WHERE par_id = p_par_id)
    LOOP
        FOR gwip IN (SELECT SUM(tsi_amt) tsi_amt, SUM(prem_amt) prem_amt,
                            SUM(ann_tsi_amt) ann_tsi_amt, SUM(ann_prem_amt) ann_prem_amt
                       FROM GIPI_WITMPERL
                    WHERE par_id = p_par_id
                      AND item_no = gwi.item_no)
      LOOP
          UPDATE GIPI_WITEM
           SET tsi_amt      = gwip.tsi_amt,
               prem_amt     = gwip.prem_amt,
               ann_tsi_amt  = gwip.ann_tsi_amt,
               ann_prem_amt = gwip.ann_prem_amt
               WHERE par_id       = p_par_id 
              AND item_no      = gwi.item_no;
      END LOOP;
    END LOOP;
    
    FOR gwp IN (SELECT SUM(tsi_amt) tsi_amt, SUM(prem_amt) prem_amt,
                       SUM(ann_tsi_amt) ann_tsi_amt, SUM(ann_prem_amt) ann_prem_amt
                  FROM GIPI_WITEM
                 WHERE par_id = p_par_id)
    LOOP
        UPDATE GIPI_WPOLBAS
           SET tsi_amt      = gwp.tsi_amt,
               prem_amt     = gwp.prem_amt,
               ann_tsi_amt  = gwp.ann_tsi_amt,
               ann_prem_amt = gwp.ann_prem_amt
         WHERE par_id       = p_par_id;
    END LOOP;
  END IF;
   
  CLOSE itmperil_cur;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN 
      NULL;
END;

PROCEDURE copy_itmperil_beneficiary (
   p_policy_id         IN   gipi_polbasic.policy_id%TYPE,
   p_item_no           IN   gipi_item.item_no%TYPE,
   p_grouped_item_no   IN   gipi_grp_items_beneficiary.grouped_item_no%TYPE,
   p_par_id            IN   number
)
IS
   CURSOR itmperil_ben_cur
   IS
      SELECT item_no, grouped_item_no, beneficiary_no, line_cd, peril_cd,
             rec_flag, prem_rt, tsi_amt, prem_amt, ann_tsi_amt, ann_prem_amt
        FROM gipi_itmperil_beneficiary
       WHERE policy_id = p_policy_id
         AND item_no = p_item_no
         AND grouped_item_no = p_grouped_item_no;

   v_item_no           gipi_itmperil_beneficiary.item_no%TYPE;
   v_grouped_item_no   gipi_itmperil_beneficiary.grouped_item_no%TYPE;
   v_beneficiary_no    gipi_itmperil_beneficiary.beneficiary_no%TYPE;
   v_line_cd           gipi_itmperil_beneficiary.line_cd%TYPE;
   v_peril_cd          gipi_itmperil_beneficiary.peril_cd%TYPE;
   v_rec_flag          gipi_itmperil_beneficiary.rec_flag%TYPE;
   v_prem_rt           gipi_itmperil_beneficiary.prem_rt%TYPE;
   v_tsi_amt           gipi_itmperil_beneficiary.tsi_amt%TYPE;
   v_prem_amt          gipi_itmperil_beneficiary.prem_amt%TYPE;
   v_ann_tsi_amt       gipi_itmperil_beneficiary.ann_tsi_amt%TYPE;
   v_ann_prem_amt      gipi_itmperil_beneficiary.ann_prem_amt%TYPE;
   v_message           varchar2(500);
BEGIN
   v_message            :=      'Copying item peril beneficary information ...';

   OPEN itmperil_ben_cur;

   LOOP
      FETCH itmperil_ben_cur
       INTO v_item_no, v_grouped_item_no, v_beneficiary_no, v_line_cd,
            v_peril_cd, v_rec_flag, v_prem_rt, v_tsi_amt, v_prem_amt,
            v_ann_tsi_amt, v_ann_prem_amt;

      EXIT WHEN itmperil_ben_cur%NOTFOUND;

      INSERT INTO gipi_witmperl_beneficiary
                  (par_id, item_no, grouped_item_no,
                   beneficiary_no, line_cd, peril_cd, rec_flag,
                   prem_rt, tsi_amt, prem_amt, ann_tsi_amt,
                   ann_prem_amt
                  )
           VALUES (p_par_id, v_item_no, v_grouped_item_no,
                   v_beneficiary_no, v_line_cd, v_peril_cd, v_rec_flag,
                   v_prem_rt, v_tsi_amt, v_prem_amt, v_ann_tsi_amt,
                   v_ann_prem_amt
                  );
   END LOOP;

   CLOSE itmperil_ben_cur;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      NULL;
END;

PROCEDURE copy_itmperil_grouped (
   p_policy_id         IN   gipi_polbasic.policy_id%TYPE,
   p_item_no           IN   gipi_item.item_no%TYPE,
   p_grouped_item_no   IN   gipi_itmperil_grouped.grouped_item_no%TYPE,
   p_par_id            IN   number
)
IS
   CURSOR itmperil_grouped_cur
   IS
      SELECT item_no, grouped_item_no, line_cd, peril_cd, rec_flag, prem_rt,
             tsi_amt, prem_amt, ann_tsi_amt, ann_prem_amt, aggregate_sw,
             base_amt, ri_comm_rate, ri_comm_amt, no_of_days
        FROM gipi_itmperil_grouped
       WHERE policy_id = p_policy_id
         AND item_no = p_item_no
         AND grouped_item_no = p_grouped_item_no;

   v_item_no           gipi_itmperil_grouped.item_no%TYPE;
   v_peril_cd          gipi_itmperil_grouped.peril_cd%TYPE;
   v_line_cd           gipi_itmperil_grouped.line_cd%TYPE;
   v_rec_flag          gipi_itmperil_grouped.rec_flag%TYPE;
   v_prem_rt           gipi_itmperil_grouped.prem_rt%TYPE;
   v_tsi_amt           gipi_itmperil_grouped.tsi_amt%TYPE;
   v_prem_amt          gipi_itmperil_grouped.prem_amt%TYPE;
   v_ann_tsi_amt       gipi_itmperil_grouped.ann_tsi_amt%TYPE;
   v_ann_prem_amt      gipi_itmperil_grouped.ann_prem_amt%TYPE;
   v_grouped_item_no   gipi_itmperil_grouped.grouped_item_no%TYPE;
   v_aggregate_sw      gipi_itmperil_grouped.aggregate_sw%TYPE;
   v_ri_comm_rate      gipi_itmperil_grouped.ri_comm_rate%TYPE;
   v_ri_comm_amt       gipi_itmperil_grouped.ri_comm_amt%TYPE;
   v_base_amt          gipi_itmperil_grouped.base_amt%TYPE;
   v_no_of_days        gipi_itmperil_grouped.no_of_days%TYPE;
   v_message           varchar2(500);
BEGIN
   v_message        :=      'Copying item peril group info ...';

   OPEN itmperil_grouped_cur;

   LOOP
      FETCH itmperil_grouped_cur
       INTO v_item_no, v_grouped_item_no, v_line_cd, v_peril_cd, v_rec_flag,
            v_prem_rt, v_tsi_amt, v_prem_amt, v_ann_tsi_amt, v_ann_prem_amt,
            v_aggregate_sw, v_base_amt, v_ri_comm_rate, v_ri_comm_amt,
            v_no_of_days;

      EXIT WHEN itmperil_grouped_cur%NOTFOUND;

      INSERT INTO gipi_witmperl_grouped
                  (par_id, item_no, line_cd, peril_cd,
                   rec_flag, prem_rt, tsi_amt, prem_amt,
                   ann_tsi_amt, ann_prem_amt, grouped_item_no,
                   aggregate_sw, ri_comm_rate, ri_comm_amt,
                   base_amt, no_of_days
                  )
           VALUES (p_par_id, v_item_no, v_line_cd, v_peril_cd,
                   v_rec_flag, v_prem_rt, v_tsi_amt, v_prem_amt,
                   v_ann_tsi_amt, v_ann_prem_amt, v_grouped_item_no,
                   v_aggregate_sw, v_ri_comm_rate, v_ri_comm_amt,
                   v_base_amt, v_no_of_days
                  );
   END LOOP;

   CLOSE itmperil_grouped_cur;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      NULL;
END;


PROCEDURE copy_itmperil_pack (
   p_policy_id   IN   gipi_polbasic.policy_id%TYPE,
   p_item_no     IN   gipi_item.item_no%TYPE,
   p_par_id      IN   number
)
IS
   CURSOR itmperil_cur
   IS
      SELECT item_no, peril_cd, line_cd, rec_flag, tarf_cd, prem_rt, tsi_amt,
             prem_amt, ann_tsi_amt, ann_prem_amt, comp_rem, discount_sw,
             ri_comm_rate, ri_comm_amt, surcharge_sw, prt_flag, as_charge_sw,
             no_of_days, base_amt, aggregate_sw             
        FROM gipi_itmperil
       WHERE policy_id = p_policy_id AND item_no = p_item_no;

   v_item_no        gipi_itmperil.item_no%TYPE;
   v_peril_cd       gipi_itmperil.peril_cd%TYPE;
   v_line_cd        gipi_itmperil.line_cd%TYPE;
   v_rec_flag       gipi_itmperil.rec_flag%TYPE;
   v_tarf_cd        gipi_itmperil.tarf_cd%TYPE;
   v_prem_rt        gipi_itmperil.prem_rt%TYPE;
   v_tsi_amt        gipi_itmperil.tsi_amt%TYPE;
   v_prem_amt       gipi_itmperil.prem_amt%TYPE;
   v_ann_tsi_amt    gipi_itmperil.ann_tsi_amt%TYPE;
   v_ann_prem_amt   gipi_itmperil.ann_prem_amt%TYPE;
   v_comp_rem       gipi_itmperil.comp_rem%TYPE;
   v_discount_sw    gipi_itmperil.discount_sw%TYPE;
   v_ri_comm_rate   gipi_itmperil.ri_comm_rate%TYPE;
   v_ri_comm_amt    gipi_itmperil.ri_comm_amt%TYPE;
   v_surcharge_sw   gipi_itmperil.surcharge_sw%TYPE;
   v_prt_flag       gipi_itmperil.prt_flag%TYPE;
   v_as_charge_sw   gipi_itmperil.as_charge_sw%TYPE;
   v_no_of_days     gipi_itmperil.no_of_days%TYPE;
   v_base_amt       gipi_itmperil.base_amt%TYPE;
   v_aggregate_sw   gipi_itmperil.aggregate_sw%TYPE;
   v_message        varchar2(500);
BEGIN
   v_message        :=      'Copying item peril info ...';

   OPEN itmperil_cur;

   LOOP
      FETCH itmperil_cur
       INTO v_item_no, v_peril_cd, v_line_cd, v_rec_flag, v_tarf_cd,
            v_prem_rt, v_tsi_amt, v_prem_amt, v_ann_tsi_amt, v_ann_prem_amt,
            v_comp_rem, v_discount_sw, v_ri_comm_rate, v_ri_comm_amt,
            v_surcharge_sw, v_prt_flag, v_as_charge_sw, v_no_of_days,
            v_base_amt, v_aggregate_sw;

      EXIT WHEN itmperil_cur%NOTFOUND;

      INSERT INTO gipi_witmperl
                  (par_id, item_no, line_cd, peril_cd,
                   tarf_cd, prem_rt, tsi_amt, prem_amt,
                   ann_tsi_amt, ann_prem_amt, rec_flag, comp_rem,
                   discount_sw, ri_comm_rate, ri_comm_amt,
                   surcharge_sw, prt_flag, as_charge_sw, no_of_days,
                   base_amt, aggregate_sw
                  )
           VALUES (p_par_id, v_item_no, v_line_cd, v_peril_cd,
                   v_tarf_cd, v_prem_rt, v_tsi_amt, v_prem_amt,
                   v_ann_tsi_amt, v_ann_prem_amt, v_rec_flag, v_comp_rem,
                   v_discount_sw, v_ri_comm_rate, v_ri_comm_amt,
                   v_surcharge_sw, v_prt_flag, v_as_charge_sw, v_no_of_days,
                   v_base_amt, v_aggregate_sw
                  );
   END LOOP;

   CLOSE itmperil_cur;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      NULL;
END;

PROCEDURE copy_lim_liab (p_policy_id IN GIPI_POLBASIC.policy_id%TYPE,
                         p_par_id    IN GIPI_PARLIST.par_id%TYPE)
IS
v_message       varchar2(500);
BEGIN
   v_message            :=  'Copying limit liability info ...';

   INSERT INTO GIPI_WLIM_LIAB
               (par_id, line_cd, liab_cd, limit_liability, currency_cd,
                currency_rt)
      SELECT p_par_id, line_cd, liab_cd, limit_liability, currency_cd,
             currency_rt
        FROM GIPI_LIM_LIAB
       WHERE policy_id = p_policy_id;

EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      NULL;
   WHEN TOO_MANY_ROWS
   THEN
      NULL;
END;

PROCEDURE copy_lim_liab_pack (
   p_policy_id      IN   gipi_polbasic.policy_id%TYPE,
   p_pack_line_cd   IN   gipi_item.pack_line_cd%TYPE,
   p_par_id         IN number
)
IS
    v_message       varchar2(500);
BEGIN
   v_message        :=  'Copying limit liability info ...';

   INSERT INTO gipi_wlim_liab
               (par_id, line_cd, liab_cd, limit_liability, currency_cd,
                currency_rt)
      SELECT p_par_id, line_cd, liab_cd, limit_liability, currency_cd,
             currency_rt
        FROM gipi_lim_liab
       WHERE policy_id = p_policy_id AND line_cd = p_pack_line_cd;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      NULL;
   WHEN TOO_MANY_ROWS
   THEN
      NULL;
END;


PROCEDURE copy_aviation_cargo_hull( 
    p_policy_id  IN  GIPI_POLBASIC.policy_id%TYPE,
    p_line_cd    IN  GIPI_POLBASIC.line_cd%TYPE,
    p_subline_cd IN  GIPI_POLBASIC.subline_cd%TYPE,
    p_iss_cd     IN  GIPI_POLBASIC.iss_cd%TYPE,
    p_issue_yy   IN  GIPI_POLBASIC.issue_yy%TYPE,
    p_pol_seq_no IN  GIPI_POLBASIC.pol_seq_no%TYPE,
    p_par_id     IN  GIPI_PARLIST.par_id%TYPE,
    p_par_type   IN  GIPI_PARLIST.par_type%TYPE,
    p_renew_no   IN  GIPI_POLBASIC.renew_no%TYPE,
    p_user       IN  GIPI_POLBASIC.user_id%TYPE) IS
  
  v_subline_cd        GIPI_POLBASIC.subline_cd%TYPE;
  v_menu_line_cd    GIIS_LINE.menu_line_cd%TYPE;
  v_op_flag            GIIS_SUBLINE.op_flag%TYPE := 'N';
BEGIN
     FOR A IN (SELECT NVL(menu_line_cd,line_cd) menu_line_cd
                 FROM GIIS_LINE
                WHERE line_cd = p_line_cd)
     LOOP
          v_menu_line_cd := a.menu_line_cd;
          EXIT;
     END LOOP;
                        
   IF v_menu_line_cd = GIISP.v('LINE_CODE_MN') OR v_menu_line_cd = 'MN' THEN
      FOR B IN ( SELECT b.op_flag op_flag
                   FROM GIPI_POLBASIC A, GIIS_SUBLINE b
                               WHERE a.subline_cd = b.subline_cd
                                 AND a.line_cd = b.line_cd
                                 AND a.policy_id = p_policy_id)
      LOOP
          v_op_flag := b.op_flag;
          EXIT;
      END LOOP;                               
      IF v_op_flag = 'Y' THEN
         GIUTS008_PKG.copy_item(p_policy_id,p_line_cd,p_subline_cd,p_iss_cd,p_issue_yy,p_pol_seq_no,p_renew_no,p_par_type,p_par_id);   
         GIUTS008_PKG.copy_itmperil(p_policy_id,p_line_cd,p_par_id);  
         GIUTS008_PKG.copy_open_liab(p_policy_id,p_par_id);  
         GIUTS008_PKG.copy_open_cargo(p_policy_id,p_par_id);
         GIUTS008_PKG.copy_open_peril(p_policy_id,p_par_id);
      ELSE
         GIUTS008_PKG.copy_item(p_policy_id,p_line_cd,p_subline_cd,p_iss_cd,p_issue_yy,p_pol_seq_no,p_renew_no,p_par_type,p_par_id);    
         GIUTS008_PKG.copy_itmperil(p_policy_id,p_line_cd,p_par_id); 
         GIUTS008_PKG.copy_cargo(p_policy_id,p_par_id,p_user);
         GIUTS008_PKG.copy_item_ves(p_policy_id,p_par_id);   
         GIUTS008_PKG.copy_ves_air(p_policy_id,p_par_id);
         GIUTS008_PKG.copy_open_policy(p_policy_id,p_par_id);
         GIUTS008_PKG.copy_ves_accumulation(p_line_cd,p_subline_cd,p_iss_cd,p_issue_yy,p_pol_seq_no,p_par_id);
      END IF;   
   ELSIF v_menu_line_cd = GIISP.v('LINE_CODE_MH') OR v_menu_line_cd = 'MH' THEN
         GIUTS008_PKG.copy_item_ves(p_policy_id,p_par_id);   
   ELSIF v_menu_line_cd = GIISP.v('LINE_CODE_AV') OR v_menu_line_cd = 'AV' THEN
         GIUTS008_PKG.copy_aviation_item(p_policy_id,p_par_id);
   END IF;
END;


PROCEDURE copy_aviation_cargo_hull_pack (
   p_policy_id         IN   gipi_polbasic.policy_id%TYPE,
   p_pack_line_cd      IN   gipi_pack_line_subline.pack_line_cd%TYPE,
   p_pack_subline_cd   IN   gipi_pack_line_subline.pack_subline_cd%TYPE,
   p_iss_cd            IN   gipi_polbasic.iss_cd%TYPE,
   p_issue_yy          IN   gipi_polbasic.issue_yy%TYPE,
   p_pol_seq_no        IN   gipi_polbasic.pol_seq_no%TYPE,
   p_item_no           IN   gipi_item.item_no%TYPE,
   p_par_id            IN   number,
   p_line_cd           IN  varchar2,
   p_subline_cd        IN  varchar2,
   p_renew_no          IN  number
)
IS
   v_subline_cd     gipi_polbasic.subline_cd%TYPE;
   v_menu_line_cd   giis_line.menu_line_cd%TYPE;
   v_op_flag        giis_subline.op_flag%TYPE       := 'N';
BEGIN
   FOR a IN (SELECT menu_line_cd
               FROM giis_line
              WHERE line_cd = p_pack_line_cd)
   LOOP
      v_menu_line_cd := a.menu_line_cd;
      EXIT;
   END LOOP;

   IF p_pack_line_cd = v_menu_line_cd AND v_menu_line_cd = 'MN'
   THEN
      FOR b IN (SELECT op_flag
                  FROM giis_subline
                 WHERE line_cd = p_pack_line_cd
                   AND subline_cd = p_pack_subline_cd)
      LOOP
         v_op_flag := b.op_flag;
         EXIT;
      END LOOP;

      IF v_op_flag = 'Y'
      THEN
         GIUTS008_PKG.copy_open_liab (p_policy_id,p_par_id);
         GIUTS008_PKG.copy_open_cargo (p_policy_id,p_par_id);
         GIUTS008_PKG.copy_open_peril_pack (p_policy_id, p_pack_line_cd,p_par_id);
         GIUTS008_PKG.copy_open_policy_pack (p_policy_id, p_pack_line_cd,p_par_id);
      ELSE
         GIUTS008_PKG.copy_item_pack (p_policy_id, p_item_no,p_line_cd,p_subline_cd,p_iss_cd,p_issue_yy,p_pol_seq_no,p_renew_no,p_par_id);    
         GIUTS008_PKG.copy_cargo_pack (p_policy_id,p_item_no,p_par_id);
         GIUTS008_PKG.copy_item_ves_pack (p_policy_id,p_item_no,p_par_id);
         GIUTS008_PKG.copy_ves_air(p_policy_id,p_par_id);
         GIUTS008_PKG.copy_ves_accumulation_pack (p_line_cd,p_subline_cd,p_iss_cd,p_issue_yy,p_pol_seq_no,p_item_no,p_par_id);
      END IF;
   ELSIF p_pack_line_cd = v_menu_line_cd AND v_menu_line_cd = 'MH'
   THEN
         GIUTS008_PKG.copy_item_ves_pack(p_policy_id, p_item_no,p_par_id);
   ELSIF p_pack_line_cd = v_menu_line_cd AND v_menu_line_cd = 'AV'
   THEN
         GIUTS008_PKG.copy_aviation_item_pack(p_policy_id,p_item_no,p_par_id);
   END IF;
END;

PROCEDURE copy_aviation_item (
   p1_policy_id   IN   gipi_aviation_item.policy_id%TYPE,
   p_par_id       IN number
)
IS
   CURSOR aviation_item_cur
   IS
      SELECT item_no, vessel_cd, total_fly_time, qualification, purpose,
             geog_limit, deduct_text, rec_flag, fixed_wing, rotor,
             prev_util_hrs, est_util_hrs
        FROM gipi_aviation_item
       WHERE policy_id = p1_policy_id;

   v_item_no          gipi_aviation_item.item_no%TYPE;
   v_vessel_cd        gipi_aviation_item.vessel_cd%TYPE;
   v_total_fly_time   gipi_aviation_item.total_fly_time%TYPE;
   v_qualification    gipi_aviation_item.qualification%TYPE;
   v_purpose          gipi_aviation_item.purpose%TYPE;
   v_geog_limit       gipi_aviation_item.geog_limit%TYPE;
   v_deduct_text      gipi_aviation_item.deduct_text%TYPE;
   v_rec_flag         gipi_aviation_item.rec_flag%TYPE;
   v_fixed_wing       gipi_aviation_item.fixed_wing%TYPE;
   v_rotor            gipi_aviation_item.rotor%TYPE;
   v_prev_util_hrs    gipi_aviation_item.prev_util_hrs%TYPE;
   v_est_util_hrs     gipi_aviation_item.est_util_hrs%TYPE;
   v_message          varchar2(500);
BEGIN
   v_message            :=      'Copying aviation item info ...';

   OPEN aviation_item_cur;

   LOOP
      FETCH aviation_item_cur
       INTO v_item_no, v_vessel_cd, v_total_fly_time, v_qualification,
            v_purpose, v_geog_limit, v_deduct_text, v_rec_flag, v_fixed_wing,
            v_rotor, v_prev_util_hrs, v_est_util_hrs;

      EXIT WHEN aviation_item_cur%NOTFOUND;

      INSERT INTO gipi_waviation_item
                  (par_id, item_no, vessel_cd, total_fly_time,
                   qualification, purpose, geog_limit, deduct_text,
                   rec_flag, fixed_wing, rotor, prev_util_hrs,
                   est_util_hrs
                  )
           VALUES (p_par_id, v_item_no, v_vessel_cd, v_total_fly_time,
                   v_qualification, v_purpose, v_geog_limit, v_deduct_text,
                   v_rec_flag, v_fixed_wing, v_rotor, v_prev_util_hrs,
                   v_est_util_hrs
                  );
   END LOOP;

   CLOSE aviation_item_cur;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      NULL;
END;

PROCEDURE copy_aviation_item_pack (
   p1_policy_id   IN   gipi_aviation_item.policy_id%TYPE,
   p_item_no      IN   gipi_item.item_no%TYPE,
   p_par_id         IN number
)
IS
   CURSOR aviation_item_cur
   IS
      SELECT item_no, vessel_cd, total_fly_time, qualification, purpose,
             geog_limit, deduct_text, rec_flag, fixed_wing, rotor,
             prev_util_hrs, est_util_hrs
        FROM gipi_aviation_item
       WHERE policy_id = p1_policy_id AND item_no = p_item_no;

   v_item_no          gipi_aviation_item.item_no%TYPE;
   v_vessel_cd        gipi_aviation_item.vessel_cd%TYPE;
   v_total_fly_time   gipi_aviation_item.total_fly_time%TYPE;
   v_qualification    gipi_aviation_item.qualification%TYPE;
   v_purpose          gipi_aviation_item.purpose%TYPE;
   v_geog_limit       gipi_aviation_item.geog_limit%TYPE;
   v_deduct_text      gipi_aviation_item.deduct_text%TYPE;
   v_rec_flag         gipi_aviation_item.rec_flag%TYPE;
   v_fixed_wing       gipi_aviation_item.fixed_wing%TYPE;
   v_rotor            gipi_aviation_item.rotor%TYPE;
   v_prev_util_hrs    gipi_aviation_item.prev_util_hrs%TYPE;
   v_est_util_hrs     gipi_aviation_item.est_util_hrs%TYPE;
   v_message          varchar2(500);
BEGIN
   v_message            :=      'Copying aviation item info ...';

   OPEN aviation_item_cur;

   LOOP
      FETCH aviation_item_cur
       INTO v_item_no, v_vessel_cd, v_total_fly_time, v_qualification,
            v_purpose, v_geog_limit, v_deduct_text, v_rec_flag, v_fixed_wing,
            v_rotor, v_prev_util_hrs, v_est_util_hrs;

      EXIT WHEN aviation_item_cur%NOTFOUND;

      INSERT INTO gipi_waviation_item
                  (par_id, item_no, vessel_cd, total_fly_time,
                   qualification, purpose, geog_limit, deduct_text,
                   rec_flag, fixed_wing, rotor, prev_util_hrs,
                   est_util_hrs
                  )
           VALUES (p_par_id, v_item_no, v_vessel_cd, v_total_fly_time,
                   v_qualification, v_purpose, v_geog_limit, v_deduct_text,
                   v_rec_flag, v_fixed_wing, v_rotor, v_prev_util_hrs,
                   v_est_util_hrs
                  );
   END LOOP;

   CLOSE aviation_item_cur;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      NULL;
END;

PROCEDURE copy_beneficiary (p_policy_id   IN  GIPI_POLBASIC.policy_id%TYPE,
                            p_par_id      IN  GIPI_PARLIST.par_id%TYPE)
IS
   CURSOR benef_cur
   IS
      SELECT item_no, beneficiary_no, beneficiary_name, relation,
             beneficiary_addr, delete_sw, remarks, civil_status,
             date_of_birth, age, adult_sw, sex, position_cd
        FROM GIPI_BENEFICIARY
       WHERE policy_id = p_policy_id;

   v_item_no            GIPI_BENEFICIARY.item_no%TYPE;
   v_beneficiary_name   GIPI_BENEFICIARY.beneficiary_name%TYPE;
   v_beneficiary_no     GIPI_BENEFICIARY.beneficiary_no%TYPE;
   v_relation           GIPI_BENEFICIARY.relation%TYPE;
   v_beneficiary_addr   GIPI_BENEFICIARY.beneficiary_addr%TYPE;
   v_delete_sw          GIPI_BENEFICIARY.delete_sw%TYPE;
   v_remarks            GIPI_BENEFICIARY.remarks%TYPE;
   v_civil_status       GIPI_BENEFICIARY.civil_status%TYPE;
   v_date_of_birth      GIPI_BENEFICIARY.date_of_birth%TYPE;
   v_age                GIPI_BENEFICIARY.age%TYPE;
   v_adult_sw           GIPI_BENEFICIARY.adult_sw%TYPE;
   v_sex                GIPI_BENEFICIARY.sex%TYPE;
   v_position_cd        GIPI_BENEFICIARY.position_cd%TYPE;
   v_message            VARCHAR2(500);
BEGIN
    v_message       :=      'Copying beneficiary info ...';

   OPEN benef_cur;

   LOOP
      FETCH benef_cur
       INTO v_item_no, v_beneficiary_no, v_beneficiary_name, v_relation,
            v_beneficiary_addr, v_delete_sw, v_remarks, v_civil_status,
            v_date_of_birth, v_age, v_adult_sw, v_sex, v_position_cd;

      EXIT WHEN benef_cur%NOTFOUND;

      INSERT INTO GIPI_WBENEFICIARY
          (par_id, item_no, beneficiary_no,
           beneficiary_name, relation, beneficiary_addr,
           delete_sw, remarks, civil_status, date_of_birth,
           age, adult_sw, sex, position_cd
          )
       VALUES 
          (p_par_id, v_item_no, v_beneficiary_no,
           v_beneficiary_name, v_relation, v_beneficiary_addr,
           v_delete_sw, v_remarks, v_civil_status, v_date_of_birth,
           v_age, v_adult_sw, v_sex, v_position_cd);
   END LOOP;

   CLOSE benef_cur;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      NULL;
END;

PROCEDURE copy_beneficiary_pack (
   p_policy_id   IN   gipi_polbasic.policy_id%TYPE,
   p_item_no     IN   gipi_item.item_no%TYPE,
   p_par_id     IN number
)
IS
   CURSOR benef_cur
   IS
      SELECT item_no, beneficiary_no, beneficiary_name, relation,
             beneficiary_addr, delete_sw, remarks, adult_sw, age,
             civil_status, date_of_birth, position_cd, sex  
        FROM gipi_beneficiary
       WHERE policy_id = p_policy_id AND item_no = p_item_no;

   v_item_no            gipi_beneficiary.item_no%TYPE;
   v_beneficiary_name   gipi_beneficiary.beneficiary_name%TYPE;
   v_beneficiary_no     gipi_beneficiary.beneficiary_no%TYPE;
   v_relation           gipi_beneficiary.relation%TYPE;
   v_beneficiary_addr   gipi_beneficiary.beneficiary_addr%TYPE;
   v_delete_sw          gipi_beneficiary.delete_sw%TYPE;
   v_remarks            gipi_beneficiary.remarks%TYPE;
   v_adult_sw           gipi_beneficiary.adult_sw%TYPE;
   v_age                gipi_beneficiary.age%TYPE;
   v_civil_status       gipi_beneficiary.civil_status%TYPE;
   v_date_of_birth      gipi_beneficiary.date_of_birth%TYPE;
   v_position_cd        gipi_beneficiary.position_cd%TYPE;
   v_sex                gipi_beneficiary.sex%TYPE;
   v_message            varchar2(500);
BEGIN
   v_message        :=      'Copying beneficiary info ...';

   OPEN benef_cur;

   LOOP
      FETCH benef_cur
       INTO v_item_no, v_beneficiary_no, v_beneficiary_name, v_relation,
            v_beneficiary_addr, v_delete_sw, v_remarks, v_adult_sw, v_age,
            v_civil_status, v_date_of_birth, v_position_cd, v_sex;

      EXIT WHEN benef_cur%NOTFOUND;

      INSERT INTO gipi_wbeneficiary
                  (par_id, item_no, beneficiary_no,
                   beneficiary_name, relation, beneficiary_addr,
                   delete_sw, remarks, adult_sw, age,
                   civil_status, date_of_birth, position_cd, sex
                  )
           VALUES (p_par_id, v_item_no, v_beneficiary_no,
                   v_beneficiary_name, v_relation, v_beneficiary_addr,
                   v_delete_sw, v_remarks, v_adult_sw, v_age,
                   v_civil_status, v_date_of_birth, v_position_cd, v_sex
                  );
   END LOOP;

   CLOSE benef_cur;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      NULL;
END;

PROCEDURE copy_bond_basic (p_policy_id   IN  GIPI_POLBASIC.policy_id%TYPE,
                           p_par_id      IN  GIPI_PARLIST.par_id%TYPE)
IS
    v_message       VARCHAR2(500);
    v_long          VARCHAR(2000);  
BEGIN
   v_message        :=  'Copying bond basic info ...';

   SELECT bond_dtl
     INTO v_long
     FROM GIPI_BOND_BASIC
    WHERE policy_id = p_policy_id;

   INSERT INTO GIPI_WBOND_BASIC
               (par_id, obligee_no, prin_id, coll_flag, clause_type,
                val_period_unit, val_period, np_no, contract_dtl,
                contract_date, co_prin_sw, waiver_limit, indemnity_text,
                bond_dtl, endt_eff_date, remarks, plaintiff_dtl, defendant_dtl, civil_case_no)    -- jhing GENQA SR# 0005030 added plaintiff, defendant, civil case no.
      SELECT p_par_id, obligee_no, prin_id, coll_flag, clause_type,
             val_period_unit, val_period, np_no, contract_dtl, contract_date,
             co_prin_sw, waiver_limit, indemnity_text,v_long,
             endt_eff_date, remarks, plaintiff_dtl, defendant_dtl, civil_case_no
        FROM GIPI_BOND_BASIC
       WHERE policy_id = p_policy_id;
       
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      NULL;
END;

PROCEDURE copy_cargo (p_policy_id IN gipi_cargo.policy_id%TYPE,
                p_par_id        IN number,
                p_user          IN varchar2)
IS
   CURSOR cargo_cur
   IS
      SELECT item_no, vessel_cd, geog_cd, cargo_class_cd, voyage_no, bl_awb,
             rec_flag, origin, destn, etd, eta, lc_no, cargo_type,
             deduct_text, pack_method, tranship_origin, tranship_destination,
             print_tag, invoice_value, inv_curr_rt,
             markup_rate, inv_curr_cd                                      
        FROM gipi_cargo
       WHERE policy_id = p_policy_id;

   v_item_no           gipi_cargo.item_no%TYPE;
   v_vessel_cd         gipi_cargo.vessel_cd%TYPE;
   v_geog_cd           gipi_cargo.geog_cd%TYPE;
   v_voyage_no         gipi_cargo.voyage_no%TYPE;
   v_lc_no             gipi_cargo.lc_no%TYPE;
   v_cargo_class_cd    gipi_cargo.cargo_class_cd%TYPE;
   v_bl_awb            gipi_cargo.bl_awb%TYPE;
   v_rec_flag          gipi_cargo.rec_flag%TYPE;
   v_origin            gipi_cargo.origin%TYPE;
   v_destn             gipi_cargo.destn%TYPE;
   v_etd               gipi_cargo.etd%TYPE;
   v_eta               gipi_cargo.eta%TYPE;
   v_cargo_type        gipi_cargo.cargo_type%TYPE;
   v_deduct_text       gipi_cargo.deduct_text%TYPE;
   v_pack_method       gipi_cargo.pack_method%TYPE;
   v_tranship_origin   gipi_cargo.tranship_origin%TYPE;
   v_tranship_destn    gipi_cargo.tranship_destination%TYPE;
   v_print_tag         gipi_cargo.print_tag%TYPE;
   v_invoice_value     gipi_cargo.invoice_value%TYPE;
   v_inv_curr_rt       gipi_cargo.inv_curr_rt%TYPE;
   v_markup_rate       gipi_cargo.markup_rate%TYPE;
   v_inv_curr_cd        gipi_cargo.inv_curr_cd%TYPE ;  -- jhing GENQA SR# 0005030 inv_curr_cd
   v_message           varchar2(500);
BEGIN
   v_message        :=  'Copying cargo info ...';

   OPEN cargo_cur;

   LOOP
      FETCH cargo_cur
       INTO v_item_no, v_vessel_cd, v_geog_cd, v_cargo_class_cd, v_voyage_no,
            v_bl_awb, v_rec_flag, v_origin, v_destn, v_etd, v_eta, v_lc_no,
            v_cargo_type, v_deduct_text, v_pack_method, v_tranship_origin,
            v_tranship_destn, v_print_tag, v_invoice_value, v_inv_curr_rt,
            v_markup_rate, v_inv_curr_cd;                                    

      EXIT WHEN cargo_cur%NOTFOUND;

      INSERT INTO gipi_wcargo
                  (par_id, item_no, vessel_cd, geog_cd,
                   cargo_class_cd, voyage_no, bl_awb, rec_flag,
                   origin, destn, etd, eta, lc_no,
                   cargo_type, deduct_text, pack_method,
                   tranship_origin, tranship_destination, print_tag,
                   invoice_value, inv_curr_rt, markup_rate, inv_curr_cd 
                  )                                            
           VALUES (p_par_id, v_item_no, v_vessel_cd, v_geog_cd,
                   v_cargo_class_cd, v_voyage_no, v_bl_awb, v_rec_flag,
                   v_origin, v_destn, SYSDATE, (SYSDATE + 365), v_lc_no,
                   v_cargo_type, v_deduct_text, v_pack_method,
                   v_tranship_origin, v_tranship_destn, v_print_tag,
                   v_invoice_value, v_inv_curr_rt, v_markup_rate, v_inv_curr_cd
                  );                                           
   END LOOP;

        GIUTS008_PKG.copy_cargo_carrier(p_policy_id,p_user,p_par_id);

   CLOSE cargo_cur;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      NULL;
END;

PROCEDURE copy_cargo_carrier (
   p_policy_id   IN   gipi_cargo_carrier.policy_id%TYPE,
   p_user_id     IN   giis_users.user_id%TYPE,
   p_par_id     IN number
)
IS
   CURSOR cargo_cur
   IS
      SELECT item_no, vessel_cd, voy_limit, vessel_limit_of_liab, eta, etd,
             origin, destn
        FROM gipi_cargo_carrier
       WHERE policy_id = p_policy_id;

   v_item_no                gipi_cargo_carrier.item_no%TYPE;
   v_vessel_cd              gipi_cargo_carrier.vessel_cd%TYPE;
   v_voy_limit              gipi_cargo_carrier.voy_limit%TYPE;
   v_vessel_limit_of_liab   gipi_cargo_carrier.vessel_limit_of_liab%TYPE;
   v_etd                    gipi_cargo_carrier.etd%TYPE;
   v_eta                    gipi_cargo_carrier.eta%TYPE;
   v_origin                 gipi_cargo_carrier.origin%TYPE;
   v_destn                  gipi_cargo_carrier.destn%TYPE;
   v_message                varchar2(500);

BEGIN
   v_message        :=      'Copying cargo carrier info ...';

   OPEN cargo_cur;

   LOOP
      FETCH cargo_cur
       INTO v_item_no, v_vessel_cd, v_voy_limit, v_vessel_limit_of_liab,
            v_eta, v_etd, v_origin, v_destn;

      EXIT WHEN cargo_cur%NOTFOUND;

      INSERT INTO gipi_wcargo_carrier
                  (par_id, item_no, vessel_cd, user_id,
                   last_update, voy_limit, vessel_limit_of_liab, eta,
                   etd, origin, destn
                  )
           VALUES (p_par_id, v_item_no, v_vessel_cd, p_user_id,
                   SYSDATE, v_voy_limit, v_vessel_limit_of_liab, v_eta,
                   v_etd, v_origin, v_destn
                  );
   END LOOP;

   CLOSE cargo_cur;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      NULL;
END;


PROCEDURE copy_cargo_pack (
   p_policy_id   IN   gipi_cargo.policy_id%TYPE,
   p_item_no     IN   gipi_item.item_no%TYPE,
   p_par_id         IN number
)
IS
   CURSOR cargo_cur
   IS
      SELECT item_no, vessel_cd, geog_cd, cargo_class_cd, voyage_no, bl_awb,
             rec_flag, origin, destn, etd, eta, lc_no, cargo_type,
             deduct_text, pack_method, tranship_origin, tranship_destination,
             print_tag
        FROM gipi_cargo
       WHERE policy_id = p_policy_id AND item_no = p_item_no;

   v_item_no           gipi_cargo.item_no%TYPE;
   v_vessel_cd         gipi_cargo.vessel_cd%TYPE;
   v_geog_cd           gipi_cargo.geog_cd%TYPE;
   v_voyage_no         gipi_cargo.voyage_no%TYPE;
   v_lc_no             gipi_cargo.lc_no%TYPE;
   v_cargo_class_cd    gipi_cargo.cargo_class_cd%TYPE;
   v_bl_awb            gipi_cargo.bl_awb%TYPE;
   v_rec_flag          gipi_cargo.rec_flag%TYPE;
   v_origin            gipi_cargo.origin%TYPE;
   v_destn             gipi_cargo.destn%TYPE;
   v_etd               gipi_cargo.etd%TYPE;
   v_eta               gipi_cargo.eta%TYPE;
   v_cargo_type        gipi_cargo.cargo_type%TYPE;
   v_deduct_text       gipi_cargo.deduct_text%TYPE;
   v_pack_method       gipi_cargo.pack_method%TYPE;
   v_tranship_origin   gipi_cargo.tranship_origin%TYPE;
   v_tranship_destn    gipi_cargo.tranship_destination%TYPE;
   v_print_tag         gipi_cargo.print_tag%TYPE;
   v_message           varchar2(500);
BEGIN
   v_message        :=      'Copying cargo info ...';

   OPEN cargo_cur;

   LOOP
      FETCH cargo_cur
       INTO v_item_no, v_vessel_cd, v_geog_cd, v_cargo_class_cd, v_voyage_no,
            v_bl_awb, v_rec_flag, v_origin, v_destn, v_etd, v_eta, v_lc_no,
            v_cargo_type, v_deduct_text, v_pack_method, v_tranship_origin,
            v_tranship_destn, v_print_tag;

      EXIT WHEN cargo_cur%NOTFOUND;

      INSERT INTO gipi_wcargo
                  (par_id, item_no, vessel_cd, geog_cd,
                   cargo_class_cd, voyage_no, bl_awb, rec_flag,
                   origin, destn, etd, eta, lc_no,
                   cargo_type, deduct_text, pack_method,
                   tranship_origin, tranship_destination, print_tag
                  )
           VALUES (p_par_id, v_item_no, v_vessel_cd, v_geog_cd,
                   v_cargo_class_cd, v_voyage_no, v_bl_awb, v_rec_flag,
                   v_origin, v_destn, SYSDATE, (SYSDATE + 365), v_lc_no,
                   v_cargo_type, v_deduct_text, v_pack_method,
                   v_tranship_origin, v_tranship_destn, v_print_tag
                  );
   END LOOP;

   CLOSE cargo_cur;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      NULL;
END;

PROCEDURE copy_casualty_item (
   p_policy_id   IN   GIPI_CASUALTY_ITEM.policy_id%TYPE,
   p_par_id      IN   GIPI_PARLIST.par_id%TYPE
)
IS
   CURSOR casualty_item_cur
   IS
      SELECT item_no, section_line_cd, section_subline_cd,
             section_or_hazard_cd, capacity_cd, property_no_type,                                                          
             property_no, LOCATION, conveyance_info, interest_on_premises,
             limit_of_liability, section_or_hazard_info, location_cd /* jhing added location_cd 10.05.2015 GENQA SR# 0005030 */ 
        FROM GIPI_CASUALTY_ITEM
       WHERE policy_id = p_policy_id;

   v_item_no                  GIPI_CASUALTY_ITEM.item_no%TYPE;
   v_section_line_cd          GIPI_CASUALTY_ITEM.section_line_cd%TYPE;
   v_section_subline_cd       GIPI_CASUALTY_ITEM.section_subline_cd%TYPE;
   v_section_or_hazard_cd     GIPI_CASUALTY_ITEM.section_or_hazard_cd%TYPE;
   v_capacity_cd              GIPI_CASUALTY_ITEM.capacity_cd%TYPE;
   v_property_no_type         GIPI_CASUALTY_ITEM.property_no_type%TYPE;
   v_property_no              GIPI_CASUALTY_ITEM.property_no%TYPE;
   v_location                 GIPI_CASUALTY_ITEM.LOCATION%TYPE;
   v_conveyance_info          GIPI_CASUALTY_ITEM.conveyance_info%TYPE;
   v_interest_on_premises     GIPI_CASUALTY_ITEM.interest_on_premises%TYPE;
   v_limit_of_liability       GIPI_CASUALTY_ITEM.limit_of_liability%TYPE;
   v_section_or_hazard_info   GIPI_CASUALTY_ITEM.section_or_hazard_info%TYPE;
   v_location_cd                    GIPI_CASUALTY_ITEM.LOCATION_CD%type ;   -- jhing 10.05.2015   GENQA SR# 0005030
   v_message                  VARCHAR2(500);
BEGIN
   v_message        :=      'Copying casualty item info ...';

   OPEN casualty_item_cur;

   LOOP
      FETCH casualty_item_cur
       INTO v_item_no, v_section_line_cd, v_section_subline_cd,
            v_section_or_hazard_cd, v_capacity_cd, v_property_no_type,
            v_property_no, v_location, v_conveyance_info,
            v_interest_on_premises, v_limit_of_liability,
            v_section_or_hazard_info , v_location_cd ;

      EXIT WHEN casualty_item_cur%NOTFOUND;

      INSERT INTO GIPI_WCASUALTY_ITEM
              (par_id, item_no, section_line_cd,
               section_subline_cd, section_or_hazard_cd,
               capacity_cd, property_no_type, property_no,
               LOCATION, conveyance_info, interest_on_premises,
               limit_of_liability, section_or_hazard_info, location_cd -- jhing 10.05.2015   GENQA SR# 0005030 added location_cd
              )
       VALUES (p_par_id, v_item_no, v_section_line_cd,
               v_section_subline_cd, v_section_or_hazard_cd,
               v_capacity_cd, v_property_no_type, v_property_no,
               v_location, v_conveyance_info, v_interest_on_premises,
               v_limit_of_liability, v_section_or_hazard_info, v_location_cd
              );
   END LOOP;

   CLOSE casualty_item_cur;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      NULL;
END;

PROCEDURE copy_casualty_item_pack (
   p_policy_id   IN   gipi_casualty_item.policy_id%TYPE,
   p_item_no     IN   gipi_item.item_no%TYPE,
   p_par_id         IN number
)
IS
   CURSOR casualty_item_cur
   IS
      SELECT item_no, section_line_cd, section_subline_cd,
             section_or_hazard_cd, capacity_cd, property_no_type,
             property_no, LOCATION, conveyance_info, interest_on_premises,
             limit_of_liability, section_or_hazard_info
        FROM gipi_casualty_item
       WHERE policy_id = p_policy_id AND item_no = p_item_no;

   v_item_no                  gipi_casualty_item.item_no%TYPE;
   v_section_line_cd          gipi_casualty_item.section_line_cd%TYPE;
   v_section_subline_cd       gipi_casualty_item.section_subline_cd%TYPE;
   v_section_or_hazard_cd     gipi_casualty_item.section_or_hazard_cd%TYPE;
   v_capacity_cd              gipi_casualty_item.capacity_cd%TYPE;
   v_property_no_type         gipi_casualty_item.property_no_type%TYPE;
   v_property_no              gipi_casualty_item.property_no%TYPE;
   v_location                 gipi_casualty_item.LOCATION%TYPE;
   v_conveyance_info          gipi_casualty_item.conveyance_info%TYPE;
   v_interest_on_premises     gipi_casualty_item.interest_on_premises%TYPE;
   v_limit_of_liability       gipi_casualty_item.limit_of_liability%TYPE;
   v_section_or_hazard_info   gipi_casualty_item.section_or_hazard_info%TYPE;
   v_message                  varchar2(500);
BEGIN
   v_message        :=      'Copying casualty item info ...';

   OPEN casualty_item_cur;

   LOOP
      FETCH casualty_item_cur
       INTO v_item_no, v_section_line_cd, v_section_subline_cd,
            v_section_or_hazard_cd, v_capacity_cd, v_property_no_type,
            v_property_no, v_location, v_conveyance_info,
            v_interest_on_premises, v_limit_of_liability,
            v_section_or_hazard_info;

      EXIT WHEN casualty_item_cur%NOTFOUND;

      INSERT INTO gipi_wcasualty_item
                  (par_id, item_no, section_line_cd,
                   section_subline_cd, section_or_hazard_cd,
                   capacity_cd, property_no_type, property_no,
                   LOCATION, conveyance_info, interest_on_premises,
                   limit_of_liability, section_or_hazard_info
                  )
           VALUES (p_par_id, v_item_no, v_section_line_cd,
                   v_section_subline_cd, v_section_or_hazard_cd,
                   v_capacity_cd, v_property_no_type, v_property_no,
                   v_location, v_conveyance_info, v_interest_on_premises,
                   v_limit_of_liability, v_section_or_hazard_info
                  );
   END LOOP;

   CLOSE casualty_item_cur;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      NULL;
END;


PROCEDURE copy_casualty_personnel (
   p_policy_id   IN   GIPI_CASUALTY_ITEM.policy_id%TYPE,
   p_par_id      IN   GIPI_PARLIST.par_id%TYPE
)
IS
   CURSOR casualty_prsnl_cur
   IS
      SELECT item_no, personnel_no, NAME, include_tag, capacity_cd,
             amount_covered, remarks
        FROM GIPI_CASUALTY_PERSONNEL
       WHERE policy_id = p_policy_id;

   v_item_no          GIPI_CASUALTY_PERSONNEL.item_no%TYPE;
   v_personnel_no     GIPI_CASUALTY_PERSONNEL.personnel_no%TYPE;
   v_name             GIPI_CASUALTY_PERSONNEL.NAME%TYPE;
   v_include_tag      GIPI_CASUALTY_PERSONNEL.include_tag%TYPE;
   v_capacity_cd      GIPI_CASUALTY_PERSONNEL.capacity_cd%TYPE;
   v_amount_covered   GIPI_CASUALTY_PERSONNEL.amount_covered%TYPE;
   v_remarks          GIPI_CASUALTY_PERSONNEL.remarks%TYPE;
   v_message          VARCHAR2(500);
BEGIN
   v_message        :=      'Copying casualty item info ...';

   OPEN casualty_prsnl_cur;

   LOOP
      FETCH casualty_prsnl_cur
       INTO v_item_no, v_personnel_no, v_name, v_include_tag, v_capacity_cd,
            v_amount_covered, v_remarks;

      EXIT WHEN casualty_prsnl_cur%NOTFOUND;

      INSERT INTO GIPI_WCASUALTY_PERSONNEL
          (par_id, item_no, personnel_no, NAME,
           include_tag, capacity_cd, amount_covered, remarks
          )
       VALUES 
          (p_par_id, v_item_no, v_personnel_no, v_name,
           v_include_tag, v_capacity_cd, v_amount_covered, v_remarks);
           
   END LOOP;

   CLOSE casualty_prsnl_cur;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      NULL;
END;

PROCEDURE copy_casualty_personnel_pack (
   p_policy_id   IN   gipi_casualty_item.policy_id%TYPE,
   p_item_no     IN   gipi_item.item_no%TYPE,
   p_par_id     IN number
)
IS
   CURSOR casualty_prsnl_cur
   IS
      SELECT item_no, personnel_no, NAME, include_tag, capacity_cd,
             amount_covered, remarks
        FROM gipi_casualty_personnel
       WHERE policy_id = p_policy_id AND item_no = p_item_no;

   v_item_no          gipi_casualty_personnel.item_no%TYPE;
   v_personnel_no     gipi_casualty_personnel.personnel_no%TYPE;
   v_name             gipi_casualty_personnel.NAME%TYPE;
   v_include_tag      gipi_casualty_personnel.include_tag%TYPE;
   v_capacity_cd      gipi_casualty_personnel.capacity_cd%TYPE;
   v_amount_covered   gipi_casualty_personnel.amount_covered%TYPE;
   v_remarks          gipi_casualty_personnel.remarks%TYPE;
   v_message          varchar2(500);
BEGIN
   v_message        :=      'Copying casualty item info ...';

   OPEN casualty_prsnl_cur;

   LOOP
      FETCH casualty_prsnl_cur
       INTO v_item_no, v_personnel_no, v_name, v_include_tag, v_capacity_cd,
            v_amount_covered, v_remarks;

      EXIT WHEN casualty_prsnl_cur%NOTFOUND;

      INSERT INTO gipi_wcasualty_personnel
                  (par_id, item_no, personnel_no, NAME,
                   include_tag, capacity_cd, amount_covered, remarks
                  )
           VALUES (p_par_id, v_item_no, v_personnel_no, v_name,
                   v_include_tag, v_capacity_cd, v_amount_covered, v_remarks
                  );
   END LOOP;

   CLOSE casualty_prsnl_cur;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      NULL;
END;



PROCEDURE copy_comm_invoice (
   p1_policy_id    IN   gipi_comm_invoice.policy_id%TYPE,
   p_iss_cd        IN   gipi_comm_invoice.iss_cd%TYPE,
   p_prem_seq_no   IN   gipi_comm_invoice.prem_seq_no%TYPE,
   p_item_grp      IN   gipi_invoice.item_grp%TYPE,
   p_par_id        IN   number
)
IS
   CURSOR invoice_cur
   IS
      SELECT intrmdry_intm_no, share_percentage, premium_amt, commission_amt,
             wholding_tax, bond_rate, parent_intm_no
        FROM gipi_comm_invoice
       WHERE policy_id = p1_policy_id
         AND iss_cd = p_iss_cd
         AND prem_seq_no = p_prem_seq_no;

   v_intrmdry_intm_no   gipi_comm_invoice.intrmdry_intm_no%TYPE;
   v_share_percentage   gipi_comm_invoice.share_percentage%TYPE;
   v_premium_amt        gipi_comm_invoice.premium_amt%TYPE;
   v_commission_amt     gipi_comm_invoice.commission_amt%TYPE;
   v_wholding_tax       gipi_comm_invoice.wholding_tax%TYPE;
   v_parent_intm_no     gipi_comm_invoice.parent_intm_no%TYPE;
   v_bond_rate          gipi_comm_invoice.bond_rate%TYPE;
   v1_peril_cd          gipi_comm_inv_peril.peril_cd%TYPE;
   v1_premium_amt       gipi_comm_inv_peril.premium_amt%TYPE;
   v1_commission_amt    gipi_comm_inv_peril.commission_amt%TYPE;
   v1_wholding_tax      gipi_comm_inv_peril.wholding_tax%TYPE;
   v1_commission_rt     gipi_comm_inv_peril.commission_rt%TYPE;
   v_message            varchar2(500);
   v_message2           varchar2(2000);
BEGIN
   v_message        :=      'Copying comm invoice info ...';

   OPEN invoice_cur;

   LOOP
      FETCH invoice_cur
       INTO v_intrmdry_intm_no, v_share_percentage, v_premium_amt,
            v_commission_amt, v_wholding_tax, v_bond_rate, v_parent_intm_no;

      EXIT WHEN invoice_cur%NOTFOUND;

      INSERT INTO gipi_wcomm_invoices
                  (item_grp, par_id, intrmdry_intm_no,
                   share_percentage, premium_amt, commission_amt,
                   wholding_tax, bond_rate, parent_intm_no
                  )
           VALUES (p_item_grp,p_par_id, v_intrmdry_intm_no,
                   v_share_percentage, v_premium_amt, v_commission_amt,
                   v_wholding_tax, v_bond_rate, v_parent_intm_no
                  );

      DECLARE
         CURSOR invperl_cur
         IS
            SELECT peril_cd, premium_amt, commission_amt, wholding_tax,
                   commission_rt
              FROM gipi_comm_inv_peril
             WHERE policy_id = p1_policy_id
               AND iss_cd = p_iss_cd
               AND prem_seq_no = p_prem_seq_no
               AND intrmdry_intm_no = v_intrmdry_intm_no;
      BEGIN
         v_message      :=      'Copying comm invoice peril ...';

         OPEN invperl_cur;

         LOOP
            v_message2  := (   TO_CHAR (p_item_grp)
                       || '--'
                       || TO_CHAR (p_par_id)
                       || '--'
                       || TO_CHAR (v_intrmdry_intm_no)
                       || '--'
                       || TO_CHAR (v1_peril_cd)
                       || '--'
                       || TO_CHAR (v1_premium_amt)
                       || '--'
                       || TO_CHAR (v1_commission_amt)
                       || '--'
                       || TO_CHAR (v1_wholding_tax)
                       || '--'
                       || TO_CHAR (v1_commission_rt)
        
                      );

            FETCH invperl_cur
             INTO v1_peril_cd, v1_premium_amt, v1_commission_amt,
                  v1_wholding_tax, v1_commission_amt;

            EXIT WHEN invperl_cur%NOTFOUND;

            INSERT INTO gipi_wcomm_inv_perils
                        (item_grp, par_id, intrmdry_intm_no,
                         peril_cd, premium_amt, commission_amt,
                         wholding_tax, commission_rt
                        )
                 VALUES (p_item_grp,p_par_id, v_intrmdry_intm_no,
                         v1_peril_cd, v1_premium_amt, v1_commission_amt,
                         v1_wholding_tax, v1_commission_rt
                        );
         END LOOP;

         CLOSE invperl_cur;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;
   END LOOP;

   CLOSE invoice_cur;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      NULL;
END;

PROCEDURE copy_cosigntry (p_policy_id   IN  GIPI_POLBASIC.policy_id%TYPE,
                          p_par_id      IN  GIPI_PARLIST.par_id%TYPE)
IS
   CURSOR cosigntry_cur
   IS
      SELECT cosign_id, assd_no, indem_flag, bonds_flag, bonds_ri_flag
        FROM GIPI_COSIGNTRY
       WHERE policy_id = p_policy_id;

   v_prin_id         GIPI_COSIGNTRY.cosign_id%TYPE;
   v_assd_no         GIPI_COSIGNTRY.assd_no%TYPE;
   v_indem_flag      GIPI_COSIGNTRY.indem_flag%TYPE;
   v_bonds_flag      GIPI_COSIGNTRY.bonds_flag%TYPE;
   v_bonds_ri_flag   GIPI_COSIGNTRY.bonds_ri_flag%TYPE;
   v_message         VARCHAR2(500);
BEGIN
   v_message        :=      'Copying cosignatory info ...';

   OPEN cosigntry_cur;

   LOOP
      FETCH cosigntry_cur
       INTO v_prin_id, v_assd_no, v_indem_flag, v_bonds_flag,
            v_bonds_ri_flag;

      EXIT WHEN cosigntry_cur%NOTFOUND;

      INSERT INTO GIPI_WCOSIGNTRY
              (par_id, cosign_id, assd_no, indem_flag,
               bonds_flag, bonds_ri_flag
              )
       VALUES (p_par_id, v_prin_id, v_assd_no, v_indem_flag,
               v_bonds_flag, v_bonds_ri_flag
              );
   END LOOP;

   CLOSE cosigntry_cur;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      NULL;
END;


PROCEDURE copy_co_ins (p_policy_id   IN  GIUW_POL_DIST.policy_id%TYPE,
                       p_par_id      IN  GIPI_PARLIST.par_id%TYPE,
                       p_user_id     IN  GIPI_POLBASIC.user_id%TYPE)
IS

   CURSOR a1
   IS
      SELECT co_ri_cd, co_ri_shr_pct, co_ri_prem_amt, co_ri_tsi_amt
        FROM GIPI_CO_INSURER
       WHERE policy_id = p_policy_id;

   CURSOR a
   IS
      SELECT tsi_amt, prem_amt
        FROM GIPI_MAIN_CO_INS
       WHERE policy_id = p_policy_id;

   CURSOR c
   IS
      SELECT SYSDATE, NVL(p_user_id, USER)
        FROM SYS.DUAL;

   v_user       GIPI_CO_INSURER.user_id%TYPE;
   v_date       GIPI_CO_INSURER.last_update%TYPE;
   v_message    VARCHAR2(500);
   v_message2   VARCHAR2(500);
BEGIN
   BEGIN
      OPEN c;

      FETCH c
       INTO v_date, v_user;

      IF c%NOTFOUND
      THEN
         v_message  :=  'No row in table SYS.DUAL';
      END IF;

      CLOSE c;
   EXCEPTION
      WHEN OTHERS
      THEN
      null;
   END;

   BEGIN
      v_message2    :=  'Copying item peril information ...';
      FOR a1 IN a
      LOOP
         INSERT INTO GIPI_MAIN_CO_INS
                 (par_id, tsi_amt, prem_amt, user_id, last_update
                 )
          VALUES (p_par_id, a1.tsi_amt, a1.prem_amt, v_user, v_date
                 );

         IF SQL%NOTFOUND
         THEN
            EXIT;
         END IF;
      END LOOP;

   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         NULL;
   END;

   BEGIN

      FOR a3 IN a1
      LOOP
         INSERT INTO GIPI_CO_INSURER
                     (par_id, co_ri_cd, co_ri_shr_pct,
                      co_ri_prem_amt, co_ri_tsi_amt, user_id, last_update
                     )
              VALUES (p_par_id, a3.co_ri_cd, a3.co_ri_shr_pct,
                      a3.co_ri_prem_amt, a3.co_ri_tsi_amt, v_user, v_date
                     );

         IF SQL%NOTFOUND
         THEN
            EXIT;
         END IF;
      END LOOP;

   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         NULL;
   END;
END;

PROCEDURE copy_endttext (p_policy_id IN  GIPI_ENDTTEXT.policy_id%TYPE,
                         p_par_id    IN  GIPI_PARLIST.par_id%TYPE,
                         p_user_id   IN  GIPI_POLBASIC.user_id%TYPE) 
IS
v_long      GIPI_ENDTTEXT.endt_text%TYPE;

BEGIN

  SELECT endt_text
    INTO v_long
    FROM GIPI_ENDTTEXT
   WHERE policy_id = p_policy_id;
   
  INSERT INTO GIPI_WENDTTEXT
             (par_id, 
              endt_text, 
              user_id, 
              last_update)
      VALUES (p_par_id, 
              v_long, 
              p_user_id, 
              SYSDATE);
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      NULL;
END;


PROCEDURE copy_deductibles (p_policy_id   IN  GIPI_POLBASIC.policy_id%TYPE,
                            p_par_id      IN  GIPI_PARLIST.par_id%TYPE)
IS
   CURSOR deduct_cur
   IS
      SELECT item_no, ded_line_cd, ded_subline_cd, ded_deductible_cd,
             deductible_text, deductible_amt, deductible_rt, peril_cd
        FROM GIPI_DEDUCTIBLES
       WHERE policy_id = p_policy_id;

   v_item_no             GIPI_DEDUCTIBLES.item_no%TYPE;
   v_ded_line_cd         GIPI_DEDUCTIBLES.ded_line_cd%TYPE;
   v_ded_subline_cd      GIPI_DEDUCTIBLES.ded_subline_cd%TYPE;
   v_ded_deductible_cd   GIPI_DEDUCTIBLES.ded_deductible_cd%TYPE;
   v_deductible_amt      GIPI_DEDUCTIBLES.deductible_amt%TYPE;
   v_deductible_rt       GIPI_DEDUCTIBLES.deductible_rt%TYPE;
   v_peril_cd            GIPI_DEDUCTIBLES.peril_cd%TYPE;
   v_message             VARCHAR2(500);
   v_long                VARCHAR2(2000);
BEGIN
   v_message        :=      'Copying deductibles info ...';

   OPEN deduct_cur;

   LOOP
      FETCH deduct_cur
       INTO v_item_no, v_ded_line_cd, v_ded_subline_cd, v_ded_deductible_cd,
            v_long, v_deductible_amt, v_deductible_rt, v_peril_cd;

      EXIT WHEN deduct_cur%NOTFOUND;

      INSERT INTO GIPI_WDEDUCTIBLES
                  (par_id, item_no, ded_line_cd, ded_subline_cd,
                   ded_deductible_cd, deductible_text, deductible_amt,
                   deductible_rt, peril_cd
                  )
           VALUES (p_par_id, v_item_no, v_ded_line_cd, v_ded_subline_cd,
                   v_ded_deductible_cd, v_long, v_deductible_amt,
                   v_deductible_rt, v_peril_cd
                  );
   END LOOP;
   CLOSE deduct_cur;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      NULL;
END;
PROCEDURE copy_engg_basic (p_policy_id   IN  GIPI_ENGG_BASIC.policy_id%TYPE,
                           p_par_id      IN  GIPI_PARLIST.par_id%TYPE)
IS
v_message       VARCHAR2(500);
BEGIN
   v_message            :=  'Copying engineering basic info ...';

   INSERT INTO GIPI_WENGG_BASIC
               (par_id, engg_basic_infonum, contract_proj_buss_title,
                site_location, construct_start_date, construct_end_date,
                maintain_start_date, maintain_end_date, testing_start_date,
                testing_end_date,weeks_test, time_excess, mbi_policy_no)
      SELECT p_par_id, engg_basic_infonum, contract_proj_buss_title,
             site_location, construct_start_date, construct_end_date,
             maintain_start_date, maintain_end_date, testing_start_date,
             testing_end_date, weeks_test, time_excess, mbi_policy_no
        FROM GIPI_ENGG_BASIC
       WHERE policy_id = p_policy_id;

EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      NULL;
END;


PROCEDURE copy_fire (p_policy_id   IN  GIPI_POLBASIC.policy_id%TYPE,
                     p_par_id      IN  GIPI_PARLIST.par_id%TYPE)
IS
   CURSOR fire_item
   IS
      SELECT item_no, district_no, eq_zone, tarf_cd, block_no, fr_item_type,
             loc_risk1, loc_risk2, loc_risk3, tariff_zone, typhoon_zone,
             construction_cd, front, RIGHT, LEFT, rear, occupancy_cd,
             flood_zone, construction_remarks, occupancy_remarks, assignee,
             block_id,risk_cd, latitude, longitude                               
        FROM GIPI_FIREITEM
       WHERE policy_id = p_policy_id;

   v_item_no            GIPI_FIREITEM.item_no%TYPE;
   v_district_no        GIPI_FIREITEM.district_no%TYPE;
   v_eq_zone            GIPI_FIREITEM.eq_zone%TYPE;
   v_tarf_cd            GIPI_FIREITEM.tarf_cd%TYPE;
   v_block_no           GIPI_FIREITEM.block_no%TYPE;
   v_fr_item_type       GIPI_FIREITEM.fr_item_type%TYPE;
   v_loc_risk1          GIPI_FIREITEM.loc_risk1%TYPE;
   v_loc_risk2          GIPI_FIREITEM.loc_risk2%TYPE;
   v_loc_risk3          GIPI_FIREITEM.loc_risk3%TYPE;
   v_tariff_zone        GIPI_FIREITEM.tariff_zone%TYPE;
   v_typhoon_zone       GIPI_FIREITEM.typhoon_zone%TYPE;
   v_construction_cd    GIPI_FIREITEM.construction_cd%TYPE;
   v_construction_rem   GIPI_FIREITEM.construction_remarks%TYPE;
   v_front              GIPI_FIREITEM.front%TYPE;
   v_right              GIPI_FIREITEM.RIGHT%TYPE;
   v_left               GIPI_FIREITEM.LEFT%TYPE;
   v_rear               GIPI_FIREITEM.rear%TYPE;
   v_occupancy_cd       GIPI_FIREITEM.occupancy_cd%TYPE;
   v_occupancy_rem      GIPI_FIREITEM.occupancy_remarks%TYPE;
   v_flood_zone         GIPI_FIREITEM.flood_zone%TYPE;
   v_assignee           GIPI_FIREITEM.assignee%TYPE;
   v_block_id           GIPI_FIREITEM.block_id%TYPE;
   v_risk_cd            GIPI_FIREITEM.risk_cd%TYPE;
   v_latitude           GIPI_FIREITEM.latitude%TYPE; --Added by Jerome 11.14.2016 SR 5749
   v_longitude          GIPI_FIREITEM.longitude%TYPE; --Added by Jerome 11.14.2016 SR 5749
BEGIN

   OPEN fire_item;

   LOOP
      FETCH fire_item
       INTO v_item_no, v_district_no, v_eq_zone, v_tarf_cd, v_block_no,
            v_fr_item_type, v_loc_risk1, v_loc_risk2, v_loc_risk3,
            v_tariff_zone, v_typhoon_zone, v_construction_cd, v_front,
            v_right, v_left, v_rear, v_occupancy_cd, v_flood_zone,
            v_construction_rem, v_occupancy_rem, v_assignee, v_block_id,
            v_risk_cd, v_latitude, v_longitude;

      EXIT WHEN fire_item%NOTFOUND;

      INSERT INTO GIPI_WFIREITM
          (par_id, item_no, district_no, eq_zone,
           tarf_cd, block_no, fr_item_type, loc_risk1,
           loc_risk2, loc_risk3, tariff_zone, typhoon_zone,
           construction_cd, front, RIGHT, LEFT, rear,
           occupancy_cd, flood_zone, construction_remarks,
           occupancy_remarks, assignee, block_id,risk_cd, latitude, longitude
          )
       VALUES 
          (p_par_id, v_item_no, v_district_no, v_eq_zone,
           v_tarf_cd, v_block_no, v_fr_item_type, v_loc_risk1,
           v_loc_risk2, v_loc_risk3, v_tariff_zone, v_typhoon_zone,
           v_construction_cd, v_front, v_right, v_left, v_rear,
           v_occupancy_cd, v_flood_zone, v_construction_rem,
           v_occupancy_rem, v_assignee, v_block_id,v_risk_cd, v_latitude, v_longitude
          );
   END LOOP;

   CLOSE fire_item;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      NULL;
END;


PROCEDURE copy_fire_pack (
   p_policy_id   IN   gipi_polbasic.policy_id%TYPE,
   p_item_no     IN   gipi_fireitem.item_no%TYPE,
   p_par_id     IN number
)
IS
   CURSOR fire_item
   IS
      SELECT item_no, district_no, eq_zone, tarf_cd, block_no, fr_item_type,
             loc_risk1, loc_risk2, loc_risk3, tariff_zone, typhoon_zone,
             construction_cd, front, RIGHT, LEFT, rear, occupancy_cd,
             flood_zone, construction_remarks, occupancy_remarks, assignee,
             block_id,risk_cd 
        FROM gipi_fireitem
       WHERE policy_id = p_policy_id AND item_no = p_item_no;

   v_item_no            gipi_fireitem.item_no%TYPE;
   v_district_no        gipi_fireitem.district_no%TYPE;
   v_eq_zone            gipi_fireitem.eq_zone%TYPE;
   v_tarf_cd            gipi_fireitem.tarf_cd%TYPE;
   v_block_no           gipi_fireitem.block_no%TYPE;
   v_fr_item_type       gipi_fireitem.fr_item_type%TYPE;
   v_loc_risk1          gipi_fireitem.loc_risk1%TYPE;
   v_loc_risk2          gipi_fireitem.loc_risk2%TYPE;
   v_loc_risk3          gipi_fireitem.loc_risk3%TYPE;
   v_tariff_zone        gipi_fireitem.tariff_zone%TYPE;
   v_typhoon_zone       gipi_fireitem.typhoon_zone%TYPE;
   v_construction_cd    gipi_fireitem.construction_cd%TYPE;
   v_construction_rem   gipi_fireitem.construction_remarks%TYPE;
   v_front              gipi_fireitem.front%TYPE;
   v_right              gipi_fireitem.RIGHT%TYPE;
   v_left               gipi_fireitem.LEFT%TYPE;
   v_rear               gipi_fireitem.rear%TYPE;
   v_occupancy_cd       gipi_fireitem.occupancy_cd%TYPE;
   v_occupancy_rem      gipi_fireitem.occupancy_remarks%TYPE;
   v_flood_zone         gipi_fireitem.flood_zone%TYPE;
   v_assignee           gipi_fireitem.assignee%TYPE;
   v_block_id           gipi_fireitem.block_id%TYPE;
   v_risk_cd            gipi_fireitem.risk_cd%TYPE;
BEGIN
   OPEN fire_item;

   LOOP
      FETCH fire_item
       INTO v_item_no, v_district_no, v_eq_zone, v_tarf_cd, v_block_no,
            v_fr_item_type, v_loc_risk1, v_loc_risk2, v_loc_risk3,
            v_tariff_zone, v_typhoon_zone, v_construction_cd, v_front,
            v_right, v_left, v_rear, v_occupancy_cd, v_flood_zone,
            v_construction_rem, v_occupancy_rem, v_assignee, v_block_id,
            v_risk_cd;

      EXIT WHEN fire_item%NOTFOUND;

      INSERT INTO gipi_wfireitm
                  (par_id, item_no, district_no, eq_zone,
                   tarf_cd, block_no, fr_item_type, loc_risk1,
                   loc_risk2, loc_risk3, tariff_zone, typhoon_zone,
                   construction_cd, front, RIGHT, LEFT, rear,
                   occupancy_cd, flood_zone, construction_remarks,
                   occupancy_remarks, assignee, block_id,risk_cd
                  )
           VALUES (p_par_id, v_item_no, v_district_no, v_eq_zone,
                   v_tarf_cd, v_block_no, v_fr_item_type, v_loc_risk1,
                   v_loc_risk2, v_loc_risk3, v_tariff_zone, v_typhoon_zone,
                   v_construction_cd, v_front, v_right, v_left, v_rear,
                   v_occupancy_cd, v_flood_zone, v_construction_rem,
                   v_occupancy_rem, v_assignee, v_block_id,v_risk_cd
                  );
   END LOOP;

   CLOSE fire_item;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      NULL;
END;


PROCEDURE copy_grouped_items (p_policy_id   IN  GIPI_POLBASIC.policy_id%TYPE,
                              p_par_id      IN  GIPI_PARLIST.par_id%TYPE)
IS
   CURSOR gitm_cur
   IS
      SELECT item_no, grouped_item_no, grouped_item_title, include_tag,
             amount_coverage, remarks, line_cd, subline_cd, sex, position_cd,
             civil_status, date_of_birth, age, salary, salary_grade,
             group_cd, delete_sw, from_date, TO_DATE, payt_terms,
             pack_ben_cd, ann_tsi_amt, ann_prem_amt, control_cd,
             control_type_cd, tsi_amt, prem_amt, principal_cd
        FROM GIPI_GROUPED_ITEMS
       WHERE policy_id = p_policy_id;

   v_item_no              GIPI_WGROUPED_ITEMS.item_no%TYPE;
   v_grouped_item_no      GIPI_WGROUPED_ITEMS.grouped_item_no%TYPE;
   v_grouped_item_title   GIPI_WGROUPED_ITEMS.grouped_item_title%TYPE;
   v_include_tag          GIPI_WGROUPED_ITEMS.include_tag%TYPE;
   v_amount_covered       GIPI_WGROUPED_ITEMS.amount_covered%TYPE;
   v_remarks              GIPI_WGROUPED_ITEMS.remarks%TYPE;
   v_line_cd              GIPI_WGROUPED_ITEMS.line_cd%TYPE;
   v_subline_cd           GIPI_WGROUPED_ITEMS.subline_cd%TYPE;
   v_sex                  GIPI_WGROUPED_ITEMS.sex%TYPE;
   v_position_cd          GIPI_WGROUPED_ITEMS.position_cd%TYPE;
   v_civil_status         GIPI_WGROUPED_ITEMS.civil_status%TYPE;
   v_date_of_birth        GIPI_WGROUPED_ITEMS.date_of_birth%TYPE;
   v_age                  GIPI_WGROUPED_ITEMS.age%TYPE;
   v_salary               GIPI_WGROUPED_ITEMS.salary%TYPE;
   v_salary_grade         GIPI_WGROUPED_ITEMS.salary_grade%TYPE;
   v_group_cd             GIPI_WGROUPED_ITEMS.group_cd%TYPE;
   v_delete_sw            GIPI_WGROUPED_ITEMS.delete_sw%TYPE;
   v_from_date            GIPI_WGROUPED_ITEMS.from_date%TYPE;
   v_to_date              GIPI_WGROUPED_ITEMS.TO_DATE%TYPE;
   v_payt_terms           GIPI_WGROUPED_ITEMS.payt_terms%TYPE;
   v_pack_ben_cd          GIPI_WGROUPED_ITEMS.pack_ben_cd%TYPE;
   v_ann_tsi_amt          GIPI_WGROUPED_ITEMS.ann_tsi_amt%TYPE;
   v_ann_prem_amt         GIPI_WGROUPED_ITEMS.ann_prem_amt%TYPE;
   v_control_cd           GIPI_WGROUPED_ITEMS.control_cd%TYPE;
   v_control_type_cd      GIPI_WGROUPED_ITEMS.control_type_cd%TYPE;
   v_tsi_amt              GIPI_WGROUPED_ITEMS.tsi_amt%TYPE;
   v_prem_amt             GIPI_WGROUPED_ITEMS.prem_amt%TYPE;
   v_principal_cd         GIPI_WGROUPED_ITEMS.principal_cd%TYPE;
BEGIN
   OPEN gitm_cur;

   LOOP
      FETCH gitm_cur
       INTO v_item_no, v_grouped_item_no, v_grouped_item_title,
            v_include_tag, v_amount_covered, v_remarks, v_line_cd,
            v_subline_cd, v_sex, v_position_cd, v_civil_status,
            v_date_of_birth, v_age, v_salary, v_salary_grade, v_group_cd,
            v_delete_sw, v_from_date, v_to_date, v_payt_terms, v_pack_ben_cd,
            v_ann_tsi_amt, v_ann_prem_amt, v_control_cd, v_control_type_cd,
            v_tsi_amt, v_prem_amt, v_principal_cd;

      EXIT WHEN gitm_cur%NOTFOUND;

      INSERT INTO GIPI_WGROUPED_ITEMS
                  (par_id, item_no, grouped_item_no,
                   grouped_item_title, include_tag, amount_covered,
                   remarks, line_cd, subline_cd, sex, position_cd,
                   civil_status, date_of_birth, age, salary,
                   salary_grade, group_cd, delete_sw, from_date,
                   TO_DATE, payt_terms, pack_ben_cd, ann_tsi_amt,
                   ann_prem_amt, control_cd, control_type_cd,
                   tsi_amt, prem_amt, principal_cd
                  )
           VALUES (p_par_id, v_item_no, v_grouped_item_no,
                   v_grouped_item_title, v_include_tag, v_amount_covered,
                   v_remarks, v_line_cd, v_subline_cd, v_sex, v_position_cd,
                   v_civil_status, v_date_of_birth, v_age, v_salary,
                   v_salary_grade, v_group_cd, v_delete_sw, v_from_date,
                   v_to_date, v_payt_terms, v_pack_ben_cd, v_ann_tsi_amt,
                   v_ann_prem_amt, v_control_cd, v_control_type_cd,
                   v_tsi_amt, v_prem_amt, v_principal_cd
                  );

            GIUTS008_PKG.copy_grp_items_beneficiary(p_policy_id,v_item_no,v_grouped_item_no,p_par_id);
            GIUTS008_PKG.copy_itmperil_beneficiary(p_policy_id,v_item_no,v_grouped_item_no,p_par_id);
            GIUTS008_PKG.copy_itmperil_grouped (p_policy_id,v_item_no,v_grouped_item_no,p_par_id);
   END LOOP;

   CLOSE gitm_cur;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      NULL;
END;

PROCEDURE copy_grp_items_beneficiary (
   p_policy_id         IN   gipi_polbasic.policy_id%TYPE,
   p_item_no           IN   gipi_item.item_no%TYPE,
   p_grouped_item_no   IN   gipi_grp_items_beneficiary.grouped_item_no%TYPE,
   p_par_id     IN number
)
IS
   CURSOR grpd_itm_cur
   IS
      SELECT item_no, grouped_item_no, beneficiary_no, beneficiary_name,
             beneficiary_addr, relation, date_of_birth, age, civil_status,
             sex
        FROM gipi_grp_items_beneficiary
       WHERE policy_id = p_policy_id
         AND item_no = p_item_no
         AND grouped_item_no = p_grouped_item_no;

   v_item_no            gipi_grp_items_beneficiary.item_no%TYPE;
   v_grouped_item_no    gipi_grp_items_beneficiary.grouped_item_no%TYPE;
   v_beneficiary_no     gipi_grp_items_beneficiary.beneficiary_no%TYPE;
   v_beneficiary_name   gipi_grp_items_beneficiary.beneficiary_name%TYPE;
   v_beneficiary_addr   gipi_grp_items_beneficiary.beneficiary_addr%TYPE;
   v_relation           gipi_grp_items_beneficiary.relation%TYPE;
   v_sex                gipi_grp_items_beneficiary.sex%TYPE;
   v_civil_status       gipi_grp_items_beneficiary.civil_status%TYPE;
   v_date_of_birth      gipi_grp_items_beneficiary.date_of_birth%TYPE;
   v_age                gipi_grp_items_beneficiary.age%TYPE;
BEGIN
   OPEN grpd_itm_cur;

   LOOP
      FETCH grpd_itm_cur
       INTO v_item_no, v_grouped_item_no, v_beneficiary_no,
            v_beneficiary_name, v_beneficiary_addr, v_relation,
            v_date_of_birth, v_age, v_civil_status, v_sex;

      EXIT WHEN grpd_itm_cur%NOTFOUND;

      INSERT INTO gipi_wgrp_items_beneficiary
                  (par_id, item_no, grouped_item_no,
                   beneficiary_no, beneficiary_name, beneficiary_addr,
                   relation, date_of_birth, age, civil_status, sex
                  )
           VALUES (p_par_id, v_item_no, v_grouped_item_no,
                   v_beneficiary_no, v_beneficiary_name, v_beneficiary_addr,
                   v_relation, v_date_of_birth, v_age, v_civil_status, v_sex
                  );
   END LOOP;

   CLOSE grpd_itm_cur;

EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      NULL;
END;


PROCEDURE copy_inpolbas (p_policy_id IN  GIPI_POLBASIC.policy_id%TYPE,
                         p_par_id    IN  GIPI_PARLIST.par_id%TYPE,
                         p_user_id   IN  GIPI_POLBASIC.user_id%TYPE)
IS
   CURSOR inpolbas_cur
   IS
      SELECT accept_no, ri_cd, accept_date, ri_policy_no, ri_endt_no,
             ri_binder_no, writer_cd, offer_date, accept_by, orig_tsi_amt,
             orig_prem_amt, remarks, ref_accept_no, pack_accept_no, 
             amount_offered
        FROM GIRI_INPOLBAS
       WHERE policy_id = p_policy_id;

   v_accept_no        GIRI_INPOLBAS.accept_no%TYPE;
   v_ri_cd            GIRI_INPOLBAS.ri_cd%TYPE;
   v_accept_date      GIRI_INPOLBAS.accept_date%TYPE;
   v_ri_policy_no     GIRI_INPOLBAS.ri_policy_no%TYPE;
   v_ri_endt_no       GIRI_INPOLBAS.ri_endt_no%TYPE;
   v_ri_binder_no     GIRI_INPOLBAS.ri_binder_no%TYPE;
   v_writer_cd        GIRI_INPOLBAS.writer_cd%TYPE;
   v_offer_date       GIRI_INPOLBAS.offer_date%TYPE;
   v_accept_by        GIRI_INPOLBAS.accept_by%TYPE;
   v_orig_tsi_amt     GIRI_INPOLBAS.orig_tsi_amt%TYPE;
   v_orig_prem_amt    GIRI_INPOLBAS.orig_prem_amt%TYPE;
   v_remarks          GIRI_INPOLBAS.remarks%TYPE;
   v_ref_accept_no    GIRI_INPOLBAS.ref_accept_no%TYPE;
   v_pack_accept_no   GIRI_INPOLBAS.pack_accept_no%TYPE;
   v_amount_offered   GIRI_INPOLBAS.amount_offered%TYPE;
   v_seq              NUMBER;
   
BEGIN
   SELECT winpolbas_accept_no_s.NEXTVAL
     INTO v_seq
     FROM DUAL;


   OPEN inpolbas_cur;

   LOOP
      FETCH inpolbas_cur
       INTO v_accept_no, v_ri_cd, v_accept_date, v_ri_policy_no,
            v_ri_endt_no, v_ri_binder_no, v_writer_cd, v_offer_date,
            v_accept_by, v_orig_tsi_amt, v_orig_prem_amt, v_remarks,
            v_ref_accept_no,
            v_pack_accept_no ,
            v_amount_offered ;
      EXIT WHEN inpolbas_cur%NOTFOUND;

      INSERT INTO GIRI_WINPOLBAS
                  (par_id, accept_no, ri_cd, accept_date,
                   ri_policy_no, ri_endt_no, ri_binder_no,
                   writer_cd, offer_date, accept_by, orig_tsi_amt,
                   orig_prem_amt, remarks, ref_accept_no,
                   pack_accept_no ,
                   amount_offered 
                  )
           VALUES (p_par_id, v_seq, v_ri_cd, TRUNC (SYSDATE),
                   v_ri_policy_no, v_ri_endt_no, v_ri_binder_no,
                   v_writer_cd, v_offer_date, p_user_id, v_orig_tsi_amt,
                   v_orig_prem_amt, v_remarks, v_ref_accept_no,
                   v_pack_accept_no ,
                   v_amount_offered 
                  );
   END LOOP;

   CLOSE inpolbas_cur;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      NULL;
END;

PROCEDURE copy_installment (
   p_item_grp        IN   gipi_inv_tax.item_grp%TYPE,
   p_prem_seq_no     IN   gipi_inv_tax.prem_seq_no%TYPE,
   p_iss_cd          IN   gipi_inv_tax.iss_cd%TYPE,
   p_takeup_seq_no   IN   gipi_winstallment.takeup_seq_no%TYPE,
   p_par_id         IN number
)
IS
   CURSOR installment_cur
   IS
      SELECT item_grp, inst_no, share_pct, prem_amt, tax_amt
        FROM gipi_installment
       WHERE item_grp = p_item_grp
         AND prem_seq_no = p_prem_seq_no
         AND iss_cd = p_iss_cd;

   v_item_grp    gipi_winstallment.item_grp%TYPE;
   v_inst_no     gipi_winstallment.inst_no%TYPE;
   v_share_pct   gipi_winstallment.share_pct%TYPE;
   v_prem_amt    gipi_winstallment.prem_amt%TYPE;
   v_tax_amt     gipi_winstallment.tax_amt%TYPE;
BEGIN

   OPEN installment_cur;

   LOOP
      FETCH installment_cur
       INTO v_item_grp, v_inst_no, v_share_pct, v_prem_amt, v_tax_amt;

      EXIT WHEN installment_cur%NOTFOUND;

      INSERT INTO gipi_winstallment
                  (par_id, item_grp, inst_no, share_pct,
                   prem_amt, tax_amt, due_date, takeup_seq_no
                  )
           VALUES (p_par_id, v_item_grp, v_inst_no, v_share_pct,
                   v_prem_amt, v_tax_amt, NULL, p_takeup_seq_no
                  );
   END LOOP;

   CLOSE installment_cur;
END;

PROCEDURE copy_invoice_pack (p_policy_id   IN  GIPI_POLBASIC.policy_id%TYPE,
                             p_par_id      IN  GIPI_PARLIST.par_id%TYPE)
IS                                                                         --,
   CURSOR invoice_cur
   IS
      SELECT item_grp, payt_terms, prem_seq_no, prem_amt, tax_amt, property,
             insured, due_date, iss_cd, ri_comm_amt, currency_cd,
             currency_rt, remarks, other_charges, bond_rate, bond_tsi_amt,
             ri_comm_vat,multi_booking_mm, multi_booking_yy, no_of_takeup,
             dist_flag, changed_tag, takeup_seq_no
        FROM GIPI_INVOICE
       WHERE policy_id = p_policy_id;

   v_item_grp           GIPI_INVOICE.item_grp%TYPE;
   v_property           GIPI_INVOICE.property%TYPE;
   v_prem_amt           GIPI_INVOICE.prem_amt%TYPE;
   v_tax_amt            GIPI_INVOICE.tax_amt%TYPE;
   v_payt_terms         GIPI_INVOICE.payt_terms%TYPE;
   v_prem_seq_no        GIPI_INVOICE.prem_seq_no%TYPE;
   v_insured            GIPI_INVOICE.insured%TYPE;
   v_due_date           GIPI_INVOICE.due_date%TYPE;
   v_iss_cd             GIPI_INVOICE.iss_cd%TYPE;
   v_ri_comm_amt        GIPI_INVOICE.ri_comm_amt%TYPE;
   v_currency_cd        GIPI_INVOICE.currency_cd%TYPE;
   v_currency_rt        GIPI_INVOICE.currency_rt%TYPE;
   v_remarks            GIPI_INVOICE.remarks%TYPE;
   v_other_charges      GIPI_INVOICE.other_charges%TYPE;
   v_bond_rate          GIPI_INVOICE.bond_rate%TYPE;
   v_bond_tsi_amt       GIPI_INVOICE.bond_tsi_amt%TYPE;
   v_ri_comm_vat        GIPI_INVOICE.ri_comm_vat%TYPE;
   v_multi_booking_mm   GIPI_INVOICE.multi_booking_mm%TYPE;
   v_multi_booking_yy   GIPI_INVOICE.multi_booking_yy%TYPE;
   v_no_of_takeup       GIPI_INVOICE.no_of_takeup%TYPE;
   v_dist_flag          GIPI_INVOICE.dist_flag%TYPE;
   v_changed_tag        GIPI_INVOICE.changed_tag%TYPE;
   v_takeup_seq_no      GIPI_INVOICE.takeup_seq_no%TYPE;
BEGIN
   OPEN invoice_cur;

   LOOP
      FETCH invoice_cur
       INTO v_item_grp, v_payt_terms, v_prem_seq_no, v_prem_amt, v_tax_amt,
            v_property, v_insured, v_due_date, v_iss_cd, v_ri_comm_amt,
            v_currency_cd, v_currency_rt, v_remarks, v_other_charges,
            v_bond_rate, v_bond_tsi_amt, v_ri_comm_vat,v_multi_booking_mm,
            v_multi_booking_yy, v_no_of_takeup, v_dist_flag, v_changed_tag,
            v_takeup_seq_no;

      EXIT WHEN invoice_cur%NOTFOUND;

      INSERT INTO GIPI_WINVOICE
                  (par_id, item_grp, payt_terms, prem_amt,
                   tax_amt, property, insured, due_date, ri_comm_amt,
                   currency_cd, currency_rt, remarks, other_charges,
                   bond_rate, bond_tsi_amt, ri_comm_vat,
                   multi_booking_mm, multi_booking_yy, no_of_takeup,
                   dist_flag, changed_tag, takeup_seq_no
                  )
           VALUES (p_par_id, v_item_grp, v_payt_terms, v_prem_amt,
                   v_tax_amt, v_property, v_insured, SYSDATE, v_ri_comm_amt,
                   v_currency_cd, v_currency_rt, v_remarks, v_other_charges,
                   v_bond_rate, v_bond_tsi_amt, v_ri_comm_vat,
                   v_multi_booking_mm, v_multi_booking_yy, v_no_of_takeup,
                   v_dist_flag, v_changed_tag, NVL (v_takeup_seq_no, 1)
                  );
            GIUTS008_PKG.copy_invperil(v_item_grp,v_prem_seq_no,v_iss_cd,NVL(v_takeup_seq_no, 1),p_par_id);
            GIUTS008_PKG.copy_inv_tax(v_item_grp,v_prem_seq_no,v_iss_cd,NVL(v_takeup_seq_no, 1),p_par_id);
            GIUTS008_PKG.copy_installment(v_item_grp,v_prem_seq_no,v_iss_cd,NVL(v_takeup_seq_no, 1),p_par_id);
   END LOOP;

   CLOSE invoice_cur;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      NULL;
   WHEN DUP_VAL_ON_INDEX
   THEN
      NULL;
END;
PROCEDURE copy_invperil (
   p_item_grp        IN   gipi_inv_tax.item_grp%TYPE,
   p_prem_seq_no     IN   gipi_inv_tax.prem_seq_no%TYPE,
   p_iss_cd          IN   gipi_inv_tax.iss_cd%TYPE,
   p_takeup_seq_no   IN   gipi_winv_tax.takeup_seq_no%TYPE,
   p_par_id         IN  number
)
IS
   CURSOR invperil_cur
   IS
      SELECT iss_cd, prem_seq_no, peril_cd, tsi_amt, prem_amt, item_grp,
             ri_comm_amt, ri_comm_rt
        FROM gipi_invperil
       WHERE item_grp = p_item_grp
         AND prem_seq_no = p_prem_seq_no
         AND iss_cd = p_iss_cd;

   v_iss_cd        gipi_invperil.iss_cd%TYPE;
   v_prem_seq_no   gipi_invperil.prem_seq_no%TYPE;
   v_peril_cd      gipi_invperil.peril_cd%TYPE;
   v_tsi_amt       gipi_invperil.tsi_amt%TYPE;
   v_prem_amt      gipi_invperil.prem_amt%TYPE;
   v_item_grp      gipi_invperil.item_grp%TYPE;
   v_ri_comm_amt   gipi_invperil.ri_comm_amt%TYPE;
   v_ri_comm_rt    gipi_invperil.ri_comm_rt%TYPE;
BEGIN

   OPEN invperil_cur;

   LOOP
      FETCH invperil_cur
       INTO v_iss_cd, v_prem_seq_no, v_peril_cd, v_tsi_amt, v_prem_amt,
            v_item_grp, v_ri_comm_amt, v_ri_comm_rt;

      EXIT WHEN invperil_cur%NOTFOUND;

      INSERT INTO gipi_winvperl
                  (par_id, peril_cd, item_grp, tsi_amt,
                   prem_amt, ri_comm_amt, ri_comm_rt, takeup_seq_no
                  )
           VALUES (p_par_id, v_peril_cd, v_item_grp, v_tsi_amt,
                   v_prem_amt, v_ri_comm_amt, v_ri_comm_rt, p_takeup_seq_no
                  );
   END LOOP;

   CLOSE invperil_cur;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      NULL;
END;
PROCEDURE copy_inv_tax (
   p_item_grp        IN   gipi_inv_tax.item_grp%TYPE,
   p_prem_seq_no     IN   gipi_inv_tax.prem_seq_no%TYPE,
   p_iss_cd          IN   gipi_inv_tax.iss_cd%TYPE,
   p_takeup_seq_no   IN   gipi_winv_tax.takeup_seq_no%TYPE,
   p_par_id         IN number
)
IS
   CURSOR inv_tax_cur
   IS
      SELECT iss_cd, tax_cd, tax_amt, line_cd, item_grp, tax_id,
             tax_allocation, fixed_tax_allocation, rate     --Lems 07.07.2006
        FROM gipi_inv_tax
       WHERE item_grp = p_item_grp
         AND prem_seq_no = p_prem_seq_no
         AND iss_cd = p_iss_cd;

   v_iss_cd                 gipi_inv_tax.iss_cd%TYPE;
   v_tax_cd                 gipi_inv_tax.tax_cd%TYPE;
   v_tax_amt                gipi_inv_tax.tax_amt%TYPE;
   v_line_cd                gipi_inv_tax.line_cd%TYPE;
   v_item_grp               gipi_inv_tax.item_grp%TYPE;
   v_tax_id                 gipi_inv_tax.item_grp%TYPE;
   v_tax_allocation         gipi_inv_tax.tax_allocation%TYPE;
   v_fixed_tax_allocation   gipi_inv_tax.fixed_tax_allocation%TYPE;
   v_rate                   gipi_inv_tax.rate%TYPE;
   v_takeup_seq_no          gipi_winv_tax.takeup_seq_no%TYPE;
BEGIN

   OPEN inv_tax_cur;

   LOOP
      FETCH inv_tax_cur
       INTO v_iss_cd, v_tax_cd, v_tax_amt, v_line_cd, v_item_grp, v_tax_id,
            v_tax_allocation, v_fixed_tax_allocation, v_rate;

      EXIT WHEN inv_tax_cur%NOTFOUND;

      INSERT INTO gipi_winv_tax
                  (par_id, item_grp, tax_cd, line_cd, iss_cd,
                   tax_amt, tax_id, tax_allocation,
                   fixed_tax_allocation, rate, takeup_seq_no
                  )
           VALUES (p_par_id, v_item_grp, v_tax_cd, v_line_cd, v_iss_cd,
                   v_tax_amt, v_tax_id, v_tax_allocation,
                   v_fixed_tax_allocation, v_rate, p_takeup_seq_no
                  );
   END LOOP;

   CLOSE inv_tax_cur;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      NULL;
END;
PROCEDURE copy_line (
   v_policy_id         IN   gipi_polbasic.policy_id%TYPE,
   v_pack_line_cd      IN   gipi_item.pack_line_cd%TYPE,
   v_pack_subline_cd   IN   gipi_item.pack_subline_cd%TYPE,
   v_iss_cd            IN   gipi_polbasic.iss_cd%TYPE,
   v_issue_yy          IN   gipi_polbasic.issue_yy%TYPE,
   v_pol_seq_no        IN   gipi_polbasic.pol_seq_no%TYPE,
   v_item_no           IN   gipi_item.item_no%TYPE,
   v_item_grp          IN   gipi_item.item_grp%TYPE,
   p_line_cd           IN   varchar2,
   p_subline_cd        IN   varchar2,
   p_par_type          IN   varchar2,
   p_par_id            IN   number,
   p_iss_cd          IN varchar2,
   p_issue_yy        IN number,
   p_pol_seq_no      IN number,
   p_renew_no        IN number   
)
IS
   v_open_flag   giis_subline.op_flag%TYPE;
BEGIN
   FOR flag IN (SELECT op_flag
                  FROM giis_subline
                 WHERE line_cd = p_line_cd
                   AND subline_cd = p_subline_cd)
   LOOP
      v_open_flag := flag.op_flag;
      EXIT;
   END LOOP;

   IF v_pack_line_cd != 'MN' AND v_pack_subline_cd != 'MOP'
   THEN
      IF v_pack_line_cd != 'AC'
      THEN
        GIUTS008_PKG.copy_lim_liab_pack (v_policy_id, v_pack_line_cd,p_par_id);
      END IF;

      IF v_pack_line_cd != 'SU'
      THEN
        GIUTS008_PKG.copy_item_pack (v_policy_id, v_item_no,p_line_cd,p_subline_cd,p_iss_cd,p_issue_yy,p_pol_seq_no,p_renew_no,p_par_id); 

         IF p_par_type = 'P'
         THEN
            GIUTS008_PKG.copy_itmperil_pack (v_policy_id, v_item_no,p_par_id);
         END IF;
      END IF;

        GIUTS008_PKG.copy_invoice_pack (v_policy_id,p_par_id);
        
   END IF;

   IF v_pack_line_cd = 'AC'
   THEN
        GIUTS008_PKG.copy_beneficiary_pack (v_policy_id, v_item_no,p_par_id);
        GIUTS008_PKG.copy_accident_item_pack (v_policy_id, v_item_no,p_par_id);
   ELSIF v_pack_line_cd = 'CA'
   THEN
        GIUTS008_PKG.copy_casualty_item_pack (v_policy_id, v_item_no,p_par_id);
        GIUTS008_PKG.copy_casualty_personnel_pack (v_policy_id, v_item_no,p_par_id);
   ELSIF v_pack_line_cd = 'EN'
   THEN
        GIUTS008_PKG.copy_engg_basic (v_policy_id,p_par_id);
        GIUTS008_PKG.copy_location_pack(v_policy_id, v_item_no,p_par_id);
   ELSIF v_pack_line_cd = 'FI'
   THEN
        GIUTS008_PKG.copy_fire_pack (v_policy_id, v_item_no,p_par_id);
        GIUTS008_PKG.copy_peril_discount_pack(v_policy_id,v_pack_line_cd,v_item_no,p_par_id);
   ELSIF v_pack_line_cd = 'MC'
   THEN
   null;
       GIUTS008_PKG.copy_vehicle_pack(v_policy_id, v_item_no,p_par_id);
       GIUTS008_PKG.copy_mcacc_pack(v_policy_id, v_item_no,p_par_id);
   ELSIF v_pack_line_cd = 'SU'
   THEN
       GIUTS008_PKG.copy_bond_basic (v_policy_id,p_par_id);
       GIUTS008_PKG.copy_cosigntry(v_policy_id,p_par_id);
   ELSIF v_pack_line_cd IN ('MH', 'MN', 'AV')
   THEN
  
       GIUTS008_PKG.copy_aviation_cargo_hull_pack (v_policy_id,
                                    v_pack_line_cd,
                                    v_pack_subline_cd,
                                    v_iss_cd,
                                    v_issue_yy,
                                    v_pol_seq_no,
                                    v_item_no,
                                    p_par_id,
                                    p_line_cd,
                                    p_subline_cd,
                                    p_renew_no
                                   );
   END IF;

   IF v_open_flag = 'Y' AND v_pack_line_cd != 'MH'
   THEN
   null;
        GIUTS008_PKG.copy_open_liab(v_policy_id,p_par_id);
        GIUTS008_PKG.copy_open_peril_pack(v_policy_id,v_pack_line_cd,p_par_id);
   END IF;
END;

PROCEDURE copy_location (p_policy_id   IN  GIPI_POLBASIC.policy_id%TYPE,
                         p_par_id      IN  GIPI_PARLIST.par_id%TYPE)
IS
   CURSOR loc_cur
   IS
      SELECT item_no, region_cd, province_cd
        FROM GIPI_LOCATION
       WHERE policy_id = p_policy_id;

   v_item_no       GIPI_LOCATION.item_no%TYPE;
   v_region_cd     GIPI_LOCATION.region_cd%TYPE;
   v_province_cd   GIPI_LOCATION.province_cd%TYPE;
BEGIN

   OPEN loc_cur;

   LOOP
      FETCH loc_cur
       INTO v_item_no, v_region_cd, v_province_cd;

      EXIT WHEN loc_cur%NOTFOUND;

      INSERT INTO GIPI_WLOCATION
           (par_id, item_no, region_cd, province_cd)
       VALUES (p_par_id, v_item_no, v_region_cd, v_province_cd);
   END LOOP;

   CLOSE loc_cur;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      NULL;
END;


PROCEDURE copy_location_pack (
   p_policy_id   IN   gipi_polbasic.policy_id%TYPE,
   p_item_no     IN   gipi_item.item_no%TYPE,
   p_par_id     IN number
)
IS
   CURSOR loc_cur
   IS
      SELECT item_no, region_cd, province_cd
        FROM gipi_location
       WHERE policy_id = p_policy_id AND item_no = p_item_no;

   v_item_no       gipi_location.item_no%TYPE;
   v_region_cd     gipi_location.region_cd%TYPE;
   v_province_cd   gipi_location.province_cd%TYPE;
BEGIN

   OPEN loc_cur;

   LOOP
      FETCH loc_cur
       INTO v_item_no, v_region_cd, v_province_cd;

      EXIT WHEN loc_cur%NOTFOUND;

      INSERT INTO gipi_wlocation
                  (par_id, item_no, region_cd, province_cd
                  )
           VALUES (p_par_id, v_item_no, v_region_cd, v_province_cd
                  );
   END LOOP;

   CLOSE loc_cur;

EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      NULL;
END;

PROCEDURE copy_mcacc (p_policy_id   IN  GIPI_POLBASIC.policy_id%TYPE,
                      p_par_id      IN  GIPI_PARLIST.par_id%TYPE)
IS
   CURSOR mcacc_cur
   IS
      SELECT item_no, accessory_cd, acc_amt, user_id, last_update,
             delete_sw                                      
        FROM GIPI_MCACC
       WHERE policy_id = p_policy_id;

   v_item_no        GIPI_MCACC.item_no%TYPE;
   v_accessory_cd   GIPI_MCACC.accessory_cd%TYPE;
   v_acc_amt        GIPI_MCACC.acc_amt%TYPE;
   v_user_id        GIPI_MCACC.user_id%TYPE;
   v_last_update    GIPI_MCACC.last_update%TYPE;
   v_delete_sw      GIPI_MCACC.delete_sw%TYPE;
BEGIN

   OPEN mcacc_cur;

   LOOP
      FETCH mcacc_cur
       INTO v_item_no, v_accessory_cd, v_acc_amt, v_user_id, v_last_update,
            v_delete_sw;

      EXIT WHEN mcacc_cur%NOTFOUND;

      INSERT INTO GIPI_WMCACC
                  (par_id, item_no, accessory_cd, acc_amt,
                   user_id, last_update, delete_sw
                  )
           VALUES (p_par_id, v_item_no, v_accessory_cd, v_acc_amt,
                   v_user_id, v_last_update, v_delete_sw
                  );
   END LOOP;

   CLOSE mcacc_cur;

EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      NULL;
END;


PROCEDURE copy_mcacc_pack (
   p_policy_id   IN   gipi_polbasic.policy_id%TYPE,
   p_item_no     IN   gipi_item.item_no%TYPE,
   p_par_id     IN number
)
IS
   CURSOR mcacc_cur
   IS
      SELECT item_no, accessory_cd, acc_amt, user_id, last_update,
             delete_sw                            
        FROM gipi_mcacc
       WHERE policy_id = p_policy_id AND item_no = p_item_no;

   v_item_no        gipi_mcacc.item_no%TYPE;
   v_accessory_cd   gipi_mcacc.accessory_cd%TYPE;
   v_acc_amt        gipi_mcacc.acc_amt%TYPE;
   v_user_id        gipi_mcacc.user_id%TYPE;
   v_last_update    gipi_mcacc.last_update%TYPE;
   v_delete_sw      gipi_mcacc.delete_sw%TYPE;
BEGIN

   OPEN mcacc_cur;

   LOOP
      FETCH mcacc_cur
       INTO v_item_no, v_accessory_cd, v_acc_amt, v_user_id, v_last_update,
            v_delete_sw;

      EXIT WHEN mcacc_cur%NOTFOUND;

      INSERT INTO gipi_wmcacc
                  (par_id, item_no, accessory_cd, acc_amt,
                   user_id, last_update, delete_sw
                  )
           VALUES (p_par_id, v_item_no, v_accessory_cd, v_acc_amt,
                   v_user_id, v_last_update, v_delete_sw
                  );
   END LOOP;

   CLOSE mcacc_cur;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      NULL;
END;

PROCEDURE copy_mortgagee (p_policy_id   IN GIPI_POLBASIC.policy_id%TYPE,
                          p_par_id      IN GIPI_PARLIST.par_id%TYPE,
                          p_iss_cd      IN GIPI_POLBASIC.user_id%TYPE,
                          p_success     OUT VARCHAR2 --Added by Apollo Cruz 12.16.2014
                         )
IS
   CURSOR mort_cur
   IS
      SELECT iss_cd, mortg_cd, item_no, amount, remarks, user_id,
             last_update, delete_sw                        
        FROM GIPI_MORTGAGEE
       WHERE policy_id = p_policy_id 
         AND iss_cd = p_iss_cd;

   v_policy_id     GIPI_MORTGAGEE.policy_id%TYPE;
   v_iss_cd        GIPI_MORTGAGEE.iss_cd%TYPE;
   v_mortg_cd      GIPI_MORTGAGEE.mortg_cd%TYPE;
   v_item_no       GIPI_MORTGAGEE.item_no%TYPE;
   v_amount        GIPI_MORTGAGEE.amount%TYPE;
   v_remarks       GIPI_MORTGAGEE.remarks%TYPE;
   v_user_id       GIPI_MORTGAGEE.user_id%TYPE;
   v_last_update   GIPI_MORTGAGEE.last_update%TYPE;
   v_delete_sw     GIPI_MORTGAGEE.delete_sw%TYPE;
   v_new_iss_cd    GIPI_MORTGAGEE.iss_cd%TYPE;
   v_exists        VARCHAR2(1);
BEGIN

   --Added by Apollo Cruz 12.09.2014  new iss_cd must be copied 
   BEGIN
      SELECT iss_cd
        INTO v_new_iss_cd
        FROM gipi_parlist
       WHERE par_id = p_par_id; 
   END;
   
   --Added by Apollo Cruz 12.16.2014
   --records will not copied if one or more mortgagee in the old iss_cd does not exists in the new iss_cd
   OPEN mort_cur;
   LOOP
      FETCH mort_cur
       INTO v_iss_cd, v_mortg_cd, v_item_no, v_amount, v_remarks, v_user_id,
            v_last_update, v_delete_sw;
            
      EXIT WHEN mort_cur%NOTFOUND;      
      
      BEGIN   
         SELECT 'Y'
           INTO v_exists
           FROM giis_mortgagee
          WHERE iss_cd = v_new_iss_cd
            AND mortg_cd = v_mortg_cd;
      EXCEPTION WHEN NO_DATA_FOUND THEN
         v_exists := 'N';   
      END;
      
      IF v_exists = 'N' THEN
         EXIT;
      END IF;   
      
   END LOOP;
   CLOSE mort_cur;
   
   IF v_exists = 'Y' THEN
      OPEN mort_cur;

      LOOP
         FETCH mort_cur
          INTO v_iss_cd, v_mortg_cd, v_item_no, v_amount, v_remarks, v_user_id,
               v_last_update, v_delete_sw;

         EXIT WHEN mort_cur%NOTFOUND;

         INSERT INTO GIPI_WMORTGAGEE
                     (par_id, iss_cd, mortg_cd, item_no, amount,
                      remarks, user_id, last_update, delete_sw
                     )
              VALUES (p_par_id, v_new_iss_cd, v_mortg_cd, v_item_no, v_amount,
                      v_remarks, v_user_id, v_last_update, v_delete_sw
                     );
      END LOOP;

      CLOSE mort_cur;
   END IF;
   
   p_success := v_exists;

EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      NULL;
END;


PROCEDURE copy_open_cargo (p1_policy_id IN  GIPI_OPEN_CARGO.policy_id%TYPE,
                          p_par_id      IN  GIPI_PARLIST.par_id%TYPE)
IS
   CURSOR open_cur
   IS
      SELECT geog_cd, cargo_class_cd, rec_flag
        FROM GIPI_OPEN_CARGO
       WHERE policy_id = p1_policy_id;

   v_geog_cd          GIPI_OPEN_CARGO.geog_cd%TYPE;
   v_cargo_class_cd   GIPI_OPEN_CARGO.cargo_class_cd%TYPE;
   v_rec_flag         GIPI_OPEN_CARGO.rec_flag%TYPE;
BEGIN

   OPEN open_cur;

   LOOP
      FETCH open_cur
       INTO v_geog_cd, v_cargo_class_cd, v_rec_flag;

      EXIT WHEN open_cur%NOTFOUND;

      INSERT INTO GIPI_WOPEN_CARGO
                  (par_id, geog_cd, cargo_class_cd, rec_flag
                  )
           VALUES (p_par_id, v_geog_cd, v_cargo_class_cd, v_rec_flag
                  );
   END LOOP;

   CLOSE open_cur;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      NULL;
END;



PROCEDURE copy_open_liab (p1_policy_id  IN  GIPI_OPEN_LIAB.policy_id%TYPE,
                          p_par_id      IN  GIPI_PARLIST.par_id%TYPE)
IS
   CURSOR open_liab_cur
   IS
      SELECT geog_cd, rec_flag, limit_liability, currency_cd, currency_rt,
             voy_limit, prem_tag, with_invoice_tag, multi_geog_tag
        FROM GIPI_OPEN_LIAB
       WHERE policy_id = p1_policy_id;

   v_geog_cd            GIPI_OPEN_LIAB.geog_cd%TYPE;
   v_limit_liability    GIPI_OPEN_LIAB.limit_liability%TYPE;
   v_currency_cd        GIPI_OPEN_LIAB.currency_cd%TYPE;
   v_currency_rt        GIPI_OPEN_LIAB.currency_rt%TYPE;
   v_voy_limit          GIPI_OPEN_LIAB.voy_limit%TYPE;
   v_prem_tag           GIPI_OPEN_LIAB.prem_tag%TYPE;
   v_rec_flag           GIPI_OPEN_LIAB.rec_flag%TYPE;
   v_with_invoice_tag   GIPI_OPEN_LIAB.with_invoice_tag%TYPE;
   v_multi_geog_tag     GIPI_OPEN_LIAB.multi_geog_tag%TYPE;
BEGIN

   OPEN open_liab_cur;

   LOOP
      FETCH open_liab_cur
       INTO v_geog_cd, v_rec_flag, v_limit_liability, v_currency_cd,
            v_currency_rt, v_voy_limit, v_prem_tag, v_with_invoice_tag,
            v_multi_geog_tag;

      EXIT WHEN open_liab_cur%NOTFOUND;

      INSERT INTO GIPI_WOPEN_LIAB
                  (par_id, geog_cd, rec_flag, limit_liability,
                   currency_cd, currency_rt, voy_limit, prem_tag,
                   with_invoice_tag, multi_geog_tag
                  )
           VALUES (p_par_id, v_geog_cd, v_rec_flag, v_limit_liability,
                   v_currency_cd, v_currency_rt, v_voy_limit, v_prem_tag,
                   v_with_invoice_tag, v_multi_geog_tag
                  );
   END LOOP;

   CLOSE open_liab_cur;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      NULL;
END;


PROCEDURE copy_open_peril (p1_policy_id  IN  GIPI_OPEN_PERIL.policy_id%TYPE,
                           p_par_id      IN  GIPI_PARLIST.par_id%TYPE)
IS
   CURSOR open_peril_cur
   IS
      SELECT geog_cd, line_cd, peril_cd, rec_flag, prem_rate,
             with_invoice_tag, remarks
        FROM GIPI_OPEN_PERIL
       WHERE policy_id = p1_policy_id;

   v_geog_cd            GIPI_OPEN_PERIL.geog_cd%TYPE;
   v_line_cd            GIPI_OPEN_PERIL.line_cd%TYPE;
   v_peril_cd           GIPI_OPEN_PERIL.peril_cd%TYPE;
   v_rec_flag           GIPI_OPEN_PERIL.rec_flag%TYPE;
   v_prem_rate          GIPI_OPEN_PERIL.prem_rate%TYPE;
   v_with_invoice_tag   GIPI_OPEN_PERIL.with_invoice_tag%TYPE;
   v_remarks            GIPI_OPEN_PERIL.remarks%TYPE;
BEGIN
   OPEN open_peril_cur;
   LOOP
      FETCH open_peril_cur
       INTO v_geog_cd, v_line_cd, v_peril_cd, v_rec_flag, v_prem_rate,
            v_with_invoice_tag, v_remarks;
      EXIT WHEN open_peril_cur%NOTFOUND;
      
      INSERT INTO GIPI_WOPEN_PERIL
          (par_id, geog_cd, line_cd, peril_cd,
           rec_flag, prem_rate, with_invoice_tag, remarks
          )
       VALUES (p_par_id, v_geog_cd, v_line_cd, v_peril_cd,
               v_rec_flag, v_prem_rate, v_with_invoice_tag, v_remarks
              );
   END LOOP;

   CLOSE open_peril_cur;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      NULL;
END;


PROCEDURE copy_open_peril_pack (
   p1_policy_id     IN   gipi_open_peril.policy_id%TYPE,
   p_pack_line_cd   IN   gipi_item.pack_line_cd%TYPE,
   p_par_id         IN number
)
IS
   CURSOR open_peril_cur
   IS
      SELECT geog_cd, line_cd, peril_cd, rec_flag, prem_rate,
             with_invoice_tag, remarks
        FROM gipi_open_peril
       WHERE policy_id = p1_policy_id AND line_cd = p_pack_line_cd;

   v_geog_cd            gipi_open_peril.geog_cd%TYPE;
   v_line_cd            gipi_open_peril.line_cd%TYPE;
   v_peril_cd           gipi_open_peril.peril_cd%TYPE;
   v_rec_flag           gipi_open_peril.rec_flag%TYPE;
   v_prem_rate          gipi_open_peril.prem_rate%TYPE;
   v_with_invoice_tag   gipi_open_peril.with_invoice_tag%TYPE;
   v_remarks            gipi_open_peril.remarks%TYPE;
BEGIN
   OPEN open_peril_cur;
   LOOP
      FETCH open_peril_cur
       INTO v_geog_cd, v_line_cd, v_peril_cd, v_rec_flag, v_prem_rate,
            v_with_invoice_tag, v_remarks;

      EXIT WHEN open_peril_cur%NOTFOUND;

      INSERT INTO gipi_wopen_peril
                  (par_id, geog_cd, line_cd, peril_cd,
                   rec_flag, prem_rate, with_invoice_tag, remarks
                  )
           VALUES (p_par_id, v_geog_cd, v_line_cd, v_peril_cd,
                   v_rec_flag, v_prem_rate, v_with_invoice_tag, v_remarks
                  );
   END LOOP;

   CLOSE open_peril_cur;

EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      NULL;
END;


PROCEDURE copy_open_policy (
   p_open_policy_id   IN   gipi_open_policy.policy_id%TYPE,
   p_par_id         IN number
)
IS
   v_iss_cd gipi_parlist.iss_cd%TYPE;
BEGIN

   --Added by Apollo Cruz 12.09.2014  new iss_cd must be copied
   SELECT iss_cd
     INTO v_iss_cd
     FROM gipi_parlist
    WHERE par_id = p_par_id;

   INSERT INTO gipi_wopen_policy
               (par_id, line_cd, op_subline_cd, op_iss_cd, op_pol_seqno,
                decltn_no, op_issue_yy, eff_date, op_renew_no)
      SELECT p_par_id, line_cd, op_subline_cd, v_iss_cd, op_pol_seqno,
             decltn_no, op_issue_yy, eff_date, op_renew_no
        FROM gipi_open_policy
       WHERE policy_id = p_open_policy_id;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      NULL;
END;

PROCEDURE copy_open_policy_pack (
   p_open_policy_id   IN   gipi_open_policy.policy_id%TYPE,
   p_pack_line_cd     IN   gipi_item.pack_line_cd%TYPE,
   p_par_id         IN number
)
IS
BEGIN
   INSERT INTO gipi_wopen_policy
               (par_id, line_cd, op_subline_cd, op_iss_cd, op_pol_seqno,
                decltn_no, op_issue_yy, eff_date)
      SELECT p_par_id, line_cd, op_subline_cd, op_iss_cd, op_pol_seqno,
             decltn_no, op_issue_yy, eff_date
        FROM gipi_open_policy
       WHERE policy_id = p_open_policy_id AND line_cd = p_pack_line_cd;

EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      NULL;
END;

PROCEDURE copy_orig_invoice (p_policy_id   IN  GIPI_POLBASIC.policy_id%TYPE,
                             p_par_id      IN  GIPI_PARLIST.par_id%TYPE)
IS
   CURSOR orig_inv_cur
   IS
      SELECT item_grp, policy_id, iss_cd, prem_seq_no, prem_amt, tax_amt,
             other_charges, ref_inv_no, policy_currency, property, insured,
             ri_comm_amt, currency_cd, currency_rt, remarks
        FROM GIPI_ORIG_INVOICE
       WHERE policy_id = p_policy_id;

   v_item_grp          GIPI_ORIG_INVOICE.item_grp%TYPE;
   v_policy_id         GIPI_ORIG_INVOICE.policy_id%TYPE;
   v_iss_cd            GIPI_ORIG_INVOICE.iss_cd%TYPE;
   v_prem_seq_no       GIPI_ORIG_INVOICE.prem_seq_no%TYPE;
   v_prem_amt          GIPI_ORIG_INVOICE.prem_amt%TYPE;
   v_tax_amt           GIPI_ORIG_INVOICE.tax_amt%TYPE;
   v_other_charges     GIPI_ORIG_INVOICE.other_charges%TYPE;
   v_ref_inv_no        GIPI_ORIG_INVOICE.ref_inv_no%TYPE;
   v_policy_currency   GIPI_ORIG_INVOICE.policy_currency%TYPE;
   v_property          GIPI_ORIG_INVOICE.property%TYPE;
   v_insured           GIPI_ORIG_INVOICE.insured%TYPE;
   v_ri_comm_amt       GIPI_ORIG_INVOICE.ri_comm_amt%TYPE;
   v_currency_cd       GIPI_ORIG_INVOICE.currency_cd%TYPE;
   v_currency_rt       GIPI_ORIG_INVOICE.currency_rt%TYPE;
   v_remarks           GIPI_ORIG_INVOICE.remarks%TYPE;
BEGIN

   OPEN orig_inv_cur;

   LOOP
      FETCH orig_inv_cur
       INTO v_item_grp, v_policy_id, v_iss_cd, v_prem_seq_no, v_prem_amt,
            v_tax_amt, v_other_charges, v_ref_inv_no, v_policy_currency,
            v_property, v_insured, v_ri_comm_amt, v_currency_cd,
            v_currency_rt, v_remarks;

      EXIT WHEN orig_inv_cur%NOTFOUND;

      INSERT INTO GIPI_ORIG_INVOICE
                  (par_id, item_grp, iss_cd, prem_seq_no,
                   prem_amt, tax_amt, other_charges, ref_inv_no,
                   policy_currency, property, insured, ri_comm_amt,
                   currency_cd, currency_rt, remarks
                  )
           VALUES (p_par_id, v_item_grp, v_iss_cd, v_prem_seq_no,
                   v_prem_amt, v_tax_amt, v_other_charges, v_ref_inv_no,
                   v_policy_currency, v_property, v_insured, v_ri_comm_amt,
                   v_currency_cd, v_currency_rt, v_remarks
                  );
   END LOOP;

   CLOSE orig_inv_cur;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      NULL;
END;

PROCEDURE copy_orig_invperl (p_policy_id   IN  GIPI_POLBASIC.policy_id%TYPE,
                             p_par_id      IN  GIPI_PARLIST.par_id%TYPE)
IS
   CURSOR orig_invperl_cur
   IS
      SELECT item_grp, peril_cd, tsi_amt, prem_amt, ri_comm_amt, ri_comm_rt
        FROM GIPI_ORIG_INVPERL
       WHERE policy_id = p_policy_id;

   v_item_grp      GIPI_ORIG_INVPERL.item_grp%TYPE;
   v_peril_cd      GIPI_ORIG_INVPERL.peril_cd%TYPE;
   v_tsi_amt       GIPI_ORIG_INVPERL.tsi_amt%TYPE;
   v_prem_amt      GIPI_ORIG_INVPERL.prem_amt%TYPE;
   v_policy_id     GIPI_ORIG_INVPERL.policy_id%TYPE;
   v_ri_comm_amt   GIPI_ORIG_INVPERL.ri_comm_amt%TYPE;
   v_ri_comm_rt    GIPI_ORIG_INVPERL.ri_comm_rt%TYPE;
BEGIN

   OPEN orig_invperl_cur;

   LOOP
      FETCH orig_invperl_cur
       INTO v_item_grp, v_peril_cd, v_tsi_amt, v_prem_amt, v_ri_comm_amt,
            v_ri_comm_rt;

      EXIT WHEN orig_invperl_cur%NOTFOUND;

      INSERT INTO GIPI_ORIG_INVPERL
                  (par_id, item_grp, peril_cd, tsi_amt,
                   prem_amt, ri_comm_amt, ri_comm_rt
                  )
           VALUES (p_par_id, v_item_grp, v_peril_cd, v_tsi_amt,
                   v_prem_amt, v_ri_comm_amt, v_ri_comm_rt
                  );
   END LOOP;

   CLOSE orig_invperl_cur;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      NULL;
END;


PROCEDURE copy_orig_inv_tax (p_policy_id   IN  GIPI_POLBASIC.policy_id%TYPE,
                             p_par_id      IN  GIPI_PARLIST.par_id%TYPE)
IS
   CURSOR orig_invtax_cur
   IS
      SELECT item_grp, tax_cd, line_cd, tax_allocation, fixed_tax_allocation,
             iss_cd, tax_amt, tax_id, rate
        FROM GIPI_ORIG_INV_TAX
       WHERE policy_id = p_policy_id;

   v_item_grp               GIPI_ORIG_INV_TAX.item_grp%TYPE;
   v_tax_cd                 GIPI_ORIG_INV_TAX.tax_cd%TYPE;
   v_line_cd                GIPI_ORIG_INV_TAX.line_cd%TYPE;
   v_tax_allocation         GIPI_ORIG_INV_TAX.tax_allocation%TYPE;
   v_fixed_tax_allocation   GIPI_ORIG_INV_TAX.fixed_tax_allocation%TYPE;
   v_policy_id              GIPI_ORIG_INV_TAX.policy_id%TYPE;
   v_iss_cd                 GIPI_ORIG_INV_TAX.iss_cd%TYPE;
   v_tax_amt                GIPI_ORIG_INV_TAX.tax_amt%TYPE;
   v_tax_id                 GIPI_ORIG_INV_TAX.tax_id%TYPE;
   v_rate                   GIPI_ORIG_INV_TAX.rate%TYPE;
BEGIN

   OPEN orig_invtax_cur;

   LOOP
      FETCH orig_invtax_cur
       INTO v_item_grp, v_tax_cd, v_line_cd, v_tax_allocation,
            v_fixed_tax_allocation, v_iss_cd, v_tax_amt, v_tax_id, v_rate;

      EXIT WHEN orig_invtax_cur%NOTFOUND;

      INSERT INTO GIPI_ORIG_INV_TAX
                  (par_id, item_grp, tax_cd, line_cd,
                   tax_allocation, fixed_tax_allocation, iss_cd,
                   tax_amt, tax_id, rate
                  )
           VALUES (p_par_id, v_item_grp, v_tax_cd, v_line_cd,
                   v_tax_allocation, v_fixed_tax_allocation, v_iss_cd,
                   v_tax_amt, v_tax_id, v_rate
                  );
   END LOOP;

   CLOSE orig_invtax_cur;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      NULL;
END;

PROCEDURE copy_orig_itmperil (p_policy_id   IN  GIPI_POLBASIC.policy_id%TYPE,
                              p_par_id      IN  GIPI_PARLIST.par_id%TYPE)
IS
   CURSOR orig_itmperil_cur
   IS
      SELECT item_no, line_cd, peril_cd, rec_flag, prem_rt, prem_amt,
             tsi_amt, ann_prem_amt, ann_tsi_amt, comp_rem, discount_sw,
             ri_comm_rate, ri_comm_amt, surcharge_sw
        FROM GIPI_ORIG_ITMPERIL
       WHERE policy_id = p_policy_id;

   v_item_no        GIPI_ORIG_ITMPERIL.item_no%TYPE;
   v_line_cd        GIPI_ORIG_ITMPERIL.line_cd%TYPE;
   v_peril_cd       GIPI_ORIG_ITMPERIL.peril_cd%TYPE;
   v_rec_flag       GIPI_ORIG_ITMPERIL.rec_flag%TYPE;
   v_policy_id      GIPI_ORIG_ITMPERIL.policy_id%TYPE;
   v_prem_rt        GIPI_ORIG_ITMPERIL.prem_rt%TYPE;
   v_prem_amt       GIPI_ORIG_ITMPERIL.prem_amt%TYPE;
   v_tsi_amt        GIPI_ORIG_ITMPERIL.tsi_amt%TYPE;
   v_ann_prem_amt   GIPI_ORIG_ITMPERIL.ann_prem_amt%TYPE;
   v_ann_tsi_amt    GIPI_ORIG_ITMPERIL.ann_tsi_amt%TYPE;
   v_comp_rem       GIPI_ORIG_ITMPERIL.comp_rem%TYPE;
   v_discount_sw    GIPI_ORIG_ITMPERIL.discount_sw%TYPE;
   v_ri_comm_rate   GIPI_ORIG_ITMPERIL.ri_comm_rate%TYPE;
   v_ri_comm_amt    GIPI_ORIG_ITMPERIL.ri_comm_amt%TYPE;
   v_surcharge_sw   GIPI_ORIG_ITMPERIL.surcharge_sw%TYPE;
BEGIN

   OPEN orig_itmperil_cur;

   LOOP
      FETCH orig_itmperil_cur
       INTO v_item_no, v_line_cd, v_peril_cd, v_rec_flag, v_prem_rt,
            v_prem_amt, v_tsi_amt, v_ann_prem_amt, v_ann_tsi_amt, v_comp_rem,
            v_discount_sw, v_ri_comm_rate, v_ri_comm_amt, v_surcharge_sw;

      EXIT WHEN orig_itmperil_cur%NOTFOUND;

      INSERT INTO GIPI_ORIG_ITMPERIL
                  (par_id, item_no, line_cd, peril_cd,
                   rec_flag, prem_rt, prem_amt, tsi_amt,
                   ann_prem_amt, ann_tsi_amt, comp_rem, discount_sw,
                   ri_comm_rate, ri_comm_amt, surcharge_sw
                  )
           VALUES (p_par_id, v_item_no, v_line_cd, v_peril_cd,
                   v_rec_flag, v_prem_rt, v_prem_amt, v_tsi_amt,
                   v_ann_prem_amt, v_ann_tsi_amt, v_comp_rem, v_discount_sw,
                   v_ri_comm_rate, v_ri_comm_amt, v_surcharge_sw
                  );
   END LOOP;

   CLOSE orig_itmperil_cur;

EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      NULL;
END;

PROCEDURE copy_pack_line_subline (
   p_policy_id   IN   gipi_polbasic.policy_id%TYPE,
   p_par_id      IN   gipi_parlist.par_id%TYPE
)
IS
   CURSOR pack_line_subline_cur
   IS
      SELECT pack_line_cd, pack_subline_cd, line_cd, remarks
        FROM gipi_pack_line_subline
       WHERE policy_id = p_policy_id;

   v_pack_line_cd      gipi_pack_line_subline.pack_line_cd%TYPE;
   v_pack_subline_cd   gipi_pack_line_subline.pack_subline_cd%TYPE;
   v_line_cd           gipi_pack_line_subline.line_cd%TYPE;
   v_remarks           gipi_pack_line_subline.remarks%TYPE;
BEGIN
   /* removed by jdiago 07.28.2014
   FOR pack_line_subline_var IN pack_line_subline_cur
   LOOP
      INSERT INTO GIPI_WPACK_LINE_SUBLINE
              (par_id, pack_line_cd, pack_subline_cd,
               line_cd, remarks
              )
       VALUES (p_par_id, v_pack_line_cd, v_pack_subline_cd,
               v_line_cd, v_remarks
              );
   END LOOP;*/

   -- added by jdiago 07.28.2014
   OPEN pack_line_subline_cur;

   LOOP
      FETCH pack_line_subline_cur
       INTO v_pack_line_cd, v_pack_subline_cd, v_line_cd, v_remarks;

      EXIT WHEN pack_line_subline_cur%NOTFOUND;

      INSERT INTO gipi_wpack_line_subline
                  (par_id, pack_line_cd, pack_subline_cd, line_cd,
                   remarks
                  )
           VALUES (p_par_id, v_pack_line_cd, v_pack_subline_cd, v_line_cd,
                   v_remarks
                  );
   END LOOP;

   CLOSE pack_line_subline_cur;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      NULL;
   WHEN DUP_VAL_ON_INDEX
   THEN
      NULL;
END;


PROCEDURE copy_perilds (p_policy_id IN giuw_pol_dist.policy_id%TYPE,
            p_dist_no       IN number)
IS
   CURSOR perilds_cur
   IS
      SELECT dist_seq_no, peril_cd, line_cd, tsi_amt, prem_amt, ann_tsi_amt
        FROM giuw_perilds
       WHERE dist_no = (SELECT dist_no
                          FROM giuw_pol_dist
                         WHERE policy_id = p_policy_id);

   v_dist_seq_no   giuw_perilds.dist_seq_no%TYPE;
   v_peril_cd      giuw_perilds.peril_cd%TYPE;
   v_line_cd       giuw_perilds.line_cd%TYPE;
   v_tsi_amt       giuw_perilds.tsi_amt%TYPE;
   v_prem_amt      giuw_perilds.prem_amt%TYPE;
   v_ann_tsi_amt   giuw_perilds.ann_tsi_amt%TYPE;
BEGIN

   OPEN perilds_cur;

   LOOP
      FETCH perilds_cur
       INTO v_dist_seq_no, v_peril_cd, v_line_cd, v_tsi_amt, v_prem_amt,
            v_ann_tsi_amt;

      EXIT WHEN perilds_cur%NOTFOUND;

      INSERT INTO giuw_wperilds
                  (dist_no, dist_seq_no, peril_cd, line_cd,
                   tsi_amt, prem_amt, ann_tsi_amt, dist_flag
                  )
           VALUES (p_dist_no, v_dist_seq_no, v_peril_cd, v_line_cd,
                   v_tsi_amt, v_prem_amt, v_ann_tsi_amt, NULL
                  );
   END LOOP;

   CLOSE perilds_cur;

END;

PROCEDURE copy_perilds_dtl (p_policy_id IN giuw_pol_dist.policy_id%TYPE,
                p_dist_no       IN number)
IS
   v_dist_seq_no     giuw_perilds_dtl.dist_seq_no%TYPE;
   v_line_cd         giuw_perilds_dtl.line_cd%TYPE;
   v_peril_cd        giuw_perilds_dtl.peril_cd%TYPE;
   v_share_cd        giuw_perilds_dtl.share_cd%TYPE;
   v_dist_spct       giuw_perilds_dtl.dist_spct%TYPE;
   v_dist_spct1      giuw_perilds_dtl.dist_spct1%TYPE;     
   v_dist_tsi        giuw_perilds_dtl.dist_tsi%TYPE;
   v_dist_prem       giuw_perilds_dtl.dist_prem%TYPE;
   v_ann_dist_spct   giuw_perilds_dtl.ann_dist_spct%TYPE;
   v_ann_dist_tsi    giuw_perilds_dtl.ann_dist_tsi%TYPE;
   v_dist_grp        giuw_perilds_dtl.dist_grp%TYPE;
BEGIN

   FOR c1 IN (SELECT dist_no
                FROM giuw_pol_dist
               WHERE policy_id = p_policy_id)
   LOOP
      FOR c2 IN (SELECT line_cd, peril_cd
                   FROM giuw_wperilds
                  WHERE dist_no = c1.dist_no)
      LOOP
         FOR c3 IN (SELECT share_cd
                      FROM giuw_wperilds_dtl
                     WHERE dist_no = c1.dist_no
                       AND line_cd = c2.line_cd
                       AND peril_cd = c2.peril_cd)
         LOOP
            BEGIN
               INSERT INTO giuw_wperilds_dtl
                           (dist_no, dist_seq_no, line_cd, peril_cd,
                            share_cd, dist_spct, dist_tsi, dist_prem,
                            ann_dist_spct, dist_spct1, ann_dist_tsi,
                            dist_grp)
                  SELECT p_dist_no, dist_seq_no, line_cd, peril_cd,
                         share_cd, dist_spct, dist_tsi, dist_prem,
                         ann_dist_spct, dist_spct1, ann_dist_tsi, dist_grp
                    FROM giuw_perilds_dtl
                   WHERE dist_no = c1.dist_no
                     AND line_cd = c2.line_cd
                     AND peril_cd = c2.peril_cd
                     AND share_cd = c3.share_cd;
            END;
         END LOOP;
      END LOOP;
   END LOOP;

END;

PROCEDURE copy_peril_discount (
   p_policy_id   IN  GIPI_PERIL_DISCOUNT.policy_id%TYPE,
   p_par_id      IN  GIPI_PARLIST.par_id%TYPE
)
IS
   CURSOR peril_disc_cur
   IS
      SELECT line_cd, item_no, peril_cd, disc_rt, disc_amt, net_gross_tag,
             discount_tag, level_tag, subline_cd, orig_peril_prem_amt,
             net_prem_amt, SEQUENCE, remarks, last_update, surcharge_rt,
             surcharge_amt
        FROM GIPI_PERIL_DISCOUNT
       WHERE policy_id = p_policy_id;

   v_line_cd               GIPI_PERIL_DISCOUNT.line_cd%TYPE;
   v_item_no               GIPI_PERIL_DISCOUNT.item_no%TYPE;
   v_peril_cd              GIPI_PERIL_DISCOUNT.peril_cd%TYPE;
   v_disc_rt               GIPI_PERIL_DISCOUNT.disc_rt%TYPE;
   v_disc_amt              GIPI_PERIL_DISCOUNT.disc_amt%TYPE;
   v_net_gross_tag         GIPI_PERIL_DISCOUNT.net_gross_tag%TYPE;
   v_discount_tag          GIPI_PERIL_DISCOUNT.discount_tag%TYPE;
   v_level_tag             GIPI_PERIL_DISCOUNT.level_tag%TYPE;
   v_subline_cd            GIPI_PERIL_DISCOUNT.subline_cd%TYPE;
   v_orig_peril_prem_amt   GIPI_PERIL_DISCOUNT.orig_peril_prem_amt%TYPE;
   v_net_prem_amt          GIPI_PERIL_DISCOUNT.net_prem_amt%TYPE;
   v_sequence              GIPI_PERIL_DISCOUNT.SEQUENCE%TYPE;
   v_remarks               GIPI_PERIL_DISCOUNT.remarks%TYPE;
   v_last_update           GIPI_PERIL_DISCOUNT.last_update%TYPE;
   v_surcharge_rt          GIPI_PERIL_DISCOUNT.surcharge_rt%TYPE;
   v_surcharge_amt         GIPI_PERIL_DISCOUNT.surcharge_amt%TYPE;
BEGIN

   OPEN peril_disc_cur;

   LOOP
      FETCH peril_disc_cur
       INTO v_line_cd, v_item_no, v_peril_cd, v_disc_rt, v_disc_amt,
            v_net_gross_tag, v_discount_tag, v_level_tag, v_subline_cd,
            v_orig_peril_prem_amt, v_net_prem_amt, v_sequence, v_remarks,
            v_last_update, v_surcharge_rt, v_surcharge_amt;

      EXIT WHEN peril_disc_cur%NOTFOUND;

      INSERT INTO GIPI_WPERIL_DISCOUNT
                  (par_id, item_no, line_cd, peril_cd,
                   disc_rt, disc_amt, net_gross_tag, discount_tag,
                   level_tag, subline_cd, orig_peril_prem_amt,
                   net_prem_amt, SEQUENCE, remarks, last_update,
                   surcharge_rt, surcharge_amt
                  )
           VALUES (p_par_id, v_item_no, v_line_cd, v_peril_cd,
                   v_disc_rt, v_disc_amt, v_net_gross_tag, v_discount_tag,
                   v_level_tag, v_subline_cd, v_orig_peril_prem_amt,
                   v_net_prem_amt, v_sequence, v_remarks, v_last_update,
                   v_surcharge_rt, v_surcharge_amt
                  );
   END LOOP;

   CLOSE peril_disc_cur;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      NULL;
END;


PROCEDURE copy_peril_discount_pack (
   p_policy_id      IN   gipi_peril_discount.policy_id%TYPE,
   p_pack_line_cd   IN   gipi_item.pack_line_cd%TYPE,
   p_item_no        IN   gipi_item.item_no%TYPE,
   p_par_id         IN number
)
IS
   CURSOR peril_disc_cur
   IS
      SELECT line_cd, item_no, peril_cd, disc_rt, disc_amt, net_gross_tag,
             discount_tag, level_tag, subline_cd, orig_peril_prem_amt,
             net_prem_amt, surcharge_rt, surcharge_amt, SEQUENCE, remarks,
             last_update                                    
        FROM gipi_peril_discount
       WHERE policy_id = p_policy_id
         AND line_cd = p_pack_line_cd
         AND item_no = p_item_no;

   v_line_cd               gipi_peril_discount.line_cd%TYPE;
   v_item_no               gipi_peril_discount.item_no%TYPE;
   v_peril_cd              gipi_peril_discount.peril_cd%TYPE;
   v_disc_rt               gipi_peril_discount.disc_rt%TYPE;
   v_disc_amt              gipi_peril_discount.disc_amt%TYPE;
   v_net_gross_tag         gipi_peril_discount.net_gross_tag%TYPE;
   v_discount_tag          gipi_peril_discount.discount_tag%TYPE;
   v_level_tag             gipi_peril_discount.level_tag%TYPE;
   v_subline_cd            gipi_peril_discount.subline_cd%TYPE;
   v_orig_peril_prem_amt   gipi_peril_discount.orig_peril_prem_amt%TYPE;
   v_net_prem_amt          gipi_peril_discount.net_prem_amt%TYPE;
   v_surcharge_rt          gipi_peril_discount.surcharge_rt%TYPE;
   v_surcharge_amt         gipi_peril_discount.surcharge_amt%TYPE;
   v_sequence              gipi_peril_discount.SEQUENCE%TYPE;
   v_remarks               gipi_peril_discount.remarks%TYPE;
   v_last_update           gipi_peril_discount.last_update%TYPE;
BEGIN

   OPEN peril_disc_cur;

   LOOP
      FETCH peril_disc_cur
       INTO v_line_cd, v_item_no, v_peril_cd, v_disc_rt, v_disc_amt,
            v_net_gross_tag, v_discount_tag, v_level_tag, v_subline_cd,
            v_orig_peril_prem_amt, v_net_prem_amt, v_surcharge_rt,
            v_surcharge_amt, v_sequence, v_remarks, v_last_update;

      EXIT WHEN peril_disc_cur%NOTFOUND;

      INSERT INTO gipi_wperil_discount
                  (par_id, item_no, line_cd, peril_cd,
                   disc_rt, disc_amt, net_gross_tag, discount_tag,
                   level_tag, subline_cd, orig_peril_prem_amt,
                   net_prem_amt, surcharge_rt, surcharge_amt,
                   SEQUENCE, remarks, last_update
                  )
           VALUES (p_par_id, v_item_no, v_line_cd, v_peril_cd,
                   v_disc_rt, v_disc_amt, v_net_gross_tag, v_discount_tag,
                   v_level_tag, v_subline_cd, v_orig_peril_prem_amt,
                   v_net_prem_amt, v_surcharge_rt, v_surcharge_amt,
                   v_sequence, v_remarks, v_last_update
                  );
   END LOOP;

   CLOSE peril_disc_cur;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      NULL;
END;

PROCEDURE copy_pictures (
   p_policy_id   IN   GIPI_POLBASIC.policy_id%TYPE,
   p_item_no     IN   GIPI_PICTURES.item_no%TYPE,
   p_par_id      IN   GIPI_PARLIST.par_id%TYPE
)
IS
   CURSOR picture_cur
   IS
      SELECT item_no, file_name, file_type, file_ext, remarks, user_id,
             last_update
        FROM GIPI_PICTURES
       WHERE policy_id = p_policy_id 
         AND item_no = p_item_no;

   v_item_no       GIPI_PICTURES.item_no%TYPE;
   v_file_name     GIPI_PICTURES.file_name%TYPE;
   v_file_type     GIPI_PICTURES.file_type%TYPE;
   v_file_ext      GIPI_PICTURES.file_ext%TYPE;
   v_remarks       GIPI_PICTURES.remarks%TYPE;
   v_user_id       GIPI_PICTURES.user_id%TYPE;
   v_last_update   GIPI_PICTURES.last_update%TYPE;
BEGIN

   OPEN picture_cur;

   LOOP
      FETCH picture_cur
       INTO v_item_no, v_file_name, v_file_type, v_file_ext, v_remarks,
            v_user_id, v_last_update;

      EXIT WHEN picture_cur%NOTFOUND;

      INSERT INTO GIPI_WPICTURES
          (par_id, item_no, file_name, file_type,
           file_ext, remarks, user_id, last_update
          )
       VALUES (p_par_id, v_item_no, v_file_name, v_file_type,
               v_file_ext, v_remarks, v_user_id, v_last_update
              );
   END LOOP;

   CLOSE picture_cur;

EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      NULL;
END;

PROCEDURE copy_polbasic(p_policy_id         IN  GIPI_POLBASIC.policy_id%TYPE,
                        p_iss_cd            IN  GIPI_POLBASIC.iss_cd%TYPE,
                        p_nbt_iss_cd        IN  GIPI_POLBASIC.iss_cd%TYPE,
                        p_nbt_line_cd       IN  GIPI_POLBASIC.line_cd%TYPE,
                        p_nbt_subline_cd    IN  GIPI_POLBASIC.subline_cd%TYPE,
                        p_nbt_issue_yy      IN  GIPI_POLBASIC.issue_yy%TYPE,
                        p_nbt_pol_seq_no    IN  GIPI_POLBASIC.pol_seq_no%TYPE,
                        p_nbt_renew_no      IN  GIPI_POLBASIC.renew_no%TYPE,
                        p_par_id            IN  GIPI_PARLIST.par_id%TYPE,
                        p_user              IN  GIPI_POLBASIC.user_id%TYPE)
IS
   v_line_cd            GIPI_POLBASIC.line_cd%TYPE;
   v_subline_cd         GIPI_POLBASIC.subline_cd%TYPE;
   v_iss_cd             GIPI_POLBASIC.iss_cd%TYPE;
   v_issue_yy           GIPI_POLBASIC.issue_yy%TYPE;
   v_pol_seq_no         GIPI_POLBASIC.pol_seq_no%TYPE;
   v_endt_iss_cd        GIPI_POLBASIC.endt_iss_cd%TYPE;
   v_endt_yy            GIPI_POLBASIC.endt_yy%TYPE;
   v_endt_seq_no        GIPI_POLBASIC.endt_seq_no%TYPE;
   v_renew_no           GIPI_POLBASIC.renew_no%TYPE;
   v_endt_type          GIPI_POLBASIC.endt_type%TYPE;
   v_assd_no            GIPI_POLBASIC.assd_no%TYPE;
   v_designation        GIPI_POLBASIC.designation%TYPE;
   v_mortg_name         GIPI_POLBASIC.mortg_name%TYPE;
   v_tsi_amt            GIPI_POLBASIC.tsi_amt%TYPE;
   v_prem_amt           GIPI_POLBASIC.prem_amt%TYPE;
   v_ann_tsi_amt        GIPI_POLBASIC.ann_tsi_amt%TYPE;
   v_ann_prem_amt       GIPI_POLBASIC.ann_prem_amt%TYPE;
   v_invoice_sw         GIPI_POLBASIC.invoice_sw%TYPE;
   v_pool_pol_no        GIPI_POLBASIC.pool_pol_no%TYPE;
   v_address1           GIPI_POLBASIC.address1%TYPE;
   v_address2           GIPI_POLBASIC.address2%TYPE;
   v_address3           GIPI_POLBASIC.address3%TYPE;
   v_orig_policy_id     GIPI_POLBASIC.orig_policy_id%TYPE;
   v_endt_expiry_date   GIPI_POLBASIC.endt_expiry_date%TYPE;
   v_no_of_items        GIPI_POLBASIC.no_of_items%TYPE;
   v_subline_type_cd    GIPI_POLBASIC.subline_type_cd%TYPE;
   v_auto_renew_flag    GIPI_POLBASIC.auto_renew_flag%TYPE;
   v_prorate_flag       GIPI_POLBASIC.prorate_flag%TYPE;
   v_short_rt_percent   GIPI_POLBASIC.short_rt_percent%TYPE;
   v_prov_prem_tag      GIPI_POLBASIC.prov_prem_tag%TYPE;
   v_type_cd            GIPI_POLBASIC.type_cd%TYPE;
   v_acct_of_cd         GIPI_POLBASIC.acct_of_cd%TYPE;
   v_prov_prem_pct      GIPI_POLBASIC.prov_prem_pct%TYPE;
   v_pack_pol_flag      GIPI_POLBASIC.pack_pol_flag%TYPE;
   v_prem_warr_tag      GIPI_POLBASIC.prem_warr_tag%TYPE;
   v_ref_pol_no         GIPI_POLBASIC.ref_pol_no%TYPE;
   v_expiry_date        GIPI_POLBASIC.endt_expiry_date%TYPE;
   v_incept_date        GIPI_POLBASIC.endt_expiry_date%TYPE;
   v_discount_sw        GIPI_POLBASIC.discount_sw%TYPE;
   v_reg_policy_sw      GIPI_POLBASIC.reg_policy_sw%TYPE;
   v_co_insurance_sw    GIPI_POLBASIC.co_insurance_sw%TYPE;
   v_ref_open_pol_no    GIPI_POLBASIC.ref_open_pol_no%TYPE;
   v_fleet_print_tag    GIPI_POLBASIC.fleet_print_tag%TYPE;
   v_incept_tag         GIPI_POLBASIC.incept_tag%TYPE;
   v_expiry_tag         GIPI_POLBASIC.expiry_tag%TYPE;
   v_endt_expiry_tag    GIPI_POLBASIC.endt_expiry_tag%TYPE;
   v_foreign_acc_sw     GIPI_POLBASIC.foreign_acc_sw%TYPE;
   v_comp_sw            GIPI_POLBASIC.comp_sw%TYPE;
   v_with_tariff_sw     GIPI_POLBASIC.with_tariff_sw%TYPE;
   v_place_cd           GIPI_POLBASIC.place_cd%TYPE;
   v_subline_time       NUMBER;
   v_surcharge_sw       GIPI_POLBASIC.surcharge_sw%TYPE;
   v_region_cd          GIPI_POLBASIC.region_cd%TYPE;
   v_industry_cd        GIPI_POLBASIC.industry_cd%TYPE;
   v_cred_branch        GIPI_POLBASIC.cred_branch%TYPE;
   v_booking_mth        GIPI_WPOLBAS.booking_mth%TYPE;
   v_booking_year       GIPI_WPOLBAS.booking_year%TYPE;
   var_vdate            GIIS_PARAMETERS.param_value_n%TYPE;
   v_acct_of_cd_sw      GIPI_POLBASIC.acct_of_cd_sw%TYPE;
   v_back_stat          GIPI_POLBASIC.back_stat%TYPE;
   v_cancel_date        GIPI_POLBASIC.cancel_date%TYPE;
   v_eff_date           GIPI_POLBASIC.eff_date%TYPE;
   v_issue_date         GIPI_POLBASIC.issue_date%TYPE;
   v_label_tag          GIPI_POLBASIC.label_tag%TYPE;
   v_manual_renew_no    GIPI_POLBASIC.manual_renew_no%TYPE;
   v_takeup_term        GIPI_POLBASIC.takeup_term%TYPE;
   v_iss_place_exist    NUMBER;  -- added by gaaaaab
BEGIN

   BEGIN
      SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no,
             endt_iss_cd, endt_yy, endt_seq_no, renew_no,
             invoice_sw, auto_renew_flag, prov_prem_tag,
             pack_pol_flag, reg_policy_sw, co_insurance_sw,
             endt_type, incept_date, expiry_date, expiry_tag,
             assd_no, designation, address1, address2, address3,
             DECODE (p_iss_cd, p_nbt_iss_cd, mortg_name, NULL)mortg_name,
             tsi_amt, prem_amt, ann_tsi_amt, ann_prem_amt,
             pool_pol_no, foreign_acc_sw, discount_sw,
             orig_policy_id, endt_expiry_date, no_of_items,
             subline_type_cd, prorate_flag, short_rt_percent,
             type_cd, DECODE (acct_of_cd, 0, NULL, acct_of_cd),
             prov_prem_pct, prem_warr_tag, ref_pol_no,
             ref_open_pol_no, incept_tag, comp_sw, endt_expiry_tag,
             fleet_print_tag, with_tariff_sw, place_cd,
             surcharge_sw, region_cd, industry_cd, cred_branch,
             acct_of_cd_sw, back_stat, cancel_date, eff_date,
             issue_date, label_tag, manual_renew_no,takeup_term
        INTO v_line_cd, v_subline_cd, v_iss_cd, v_issue_yy, v_pol_seq_no,
             v_endt_iss_cd, v_endt_yy, v_endt_seq_no, v_renew_no,
             v_invoice_sw, v_auto_renew_flag, v_prov_prem_tag,
             v_pack_pol_flag, v_reg_policy_sw, v_co_insurance_sw,
             v_endt_type, v_incept_date, v_expiry_date, v_expiry_tag,
             v_assd_no, v_designation, v_address1, v_address2, v_address3,
             v_mortg_name,
             v_tsi_amt, v_prem_amt, v_ann_tsi_amt, v_ann_prem_amt,
             v_pool_pol_no, v_foreign_acc_sw, v_discount_sw,
             v_orig_policy_id, v_endt_expiry_date, v_no_of_items,
             v_subline_type_cd, v_prorate_flag, v_short_rt_percent,
             v_type_cd, v_acct_of_cd,
             v_prov_prem_pct, v_prem_warr_tag, v_ref_pol_no,
             v_ref_open_pol_no, v_incept_tag, v_comp_sw, v_endt_expiry_tag,
             v_fleet_print_tag, v_with_tariff_sw, v_place_cd,
             v_surcharge_sw, v_region_cd, v_industry_cd, v_cred_branch,
             v_acct_of_cd_sw, v_back_stat, v_cancel_date, v_eff_date,
             v_issue_date, v_label_tag, v_manual_renew_no,v_takeup_term
        FROM GIPI_POLBASIC
       WHERE policy_id = p_policy_id;

      FOR a IN (SELECT subline_time
                  FROM GIIS_SUBLINE
                 WHERE line_cd = p_nbt_line_cd
                   AND subline_cd = p_nbt_subline_cd)
      LOOP
         v_subline_time := TO_NUMBER (a.subline_time);
         EXIT;
      END LOOP;

      IF v_endt_seq_no != 0
      THEN
         v_endt_seq_no := 0;
         v_address1 := NULL;
         v_address2 := NULL;
         v_address3 := NULL;
         v_assd_no := NULL;
         v_designation := NULL;
         v_tsi_amt := 0;
         v_prem_amt := 0;

         FOR a1 IN (SELECT   b250.ann_tsi_amt tsi, b250.ann_prem_amt prem
                        FROM GIPI_POLBASIC b250
                       WHERE b250.line_cd = p_nbt_line_cd
                         AND b250.subline_cd = p_nbt_subline_cd
                         AND b250.iss_cd = p_nbt_iss_cd
                         AND b250.issue_yy = p_nbt_issue_yy
                         AND b250.pol_seq_no = p_nbt_pol_seq_no
                         AND b250.renew_no = p_nbt_renew_no
                         AND b250.pol_flag IN ('1', '2', '3')
                         AND b250.eff_date =
                                (SELECT MAX (b2501.eff_date)
                                   FROM GIPI_POLBASIC b2501
                                  WHERE b2501.line_cd = p_nbt_line_cd
                                    AND b2501.subline_cd = p_nbt_subline_cd
                                    AND b2501.iss_cd = p_nbt_iss_cd
                                    AND b2501.issue_yy = p_nbt_issue_yy
                                    AND b2501.pol_seq_no = p_nbt_pol_seq_no
                                    AND b2501.renew_no = p_nbt_renew_no
                                    AND b2501.pol_flag IN ('1', '2', '3'))
                    ORDER BY b250.last_upd_date DESC)
         LOOP
            v_ann_tsi_amt := a1.tsi;
            v_ann_prem_amt := a1.prem;
            EXIT;
         END LOOP;
      ELSE
         v_incept_date := TRUNC (SYSDATE) + (NVL (v_subline_time, 0) / 86400);
         v_expiry_date := ADD_MONTHS (v_incept_date, 12);
         v_pol_seq_no := NULL;
         v_issue_yy :=
                   TO_NUMBER (SUBSTR (TO_CHAR (SYSDATE, 'MM-DD-YYYY'), 9, 2));
      END IF;

      FOR c IN (SELECT param_value_n
                  FROM GIAC_PARAMETERS
                 WHERE param_name = 'PROD_TAKE_UP')
      LOOP
         var_vdate := c.param_value_n;
      END LOOP;


      IF var_vdate = 1 OR (var_vdate = 3 AND SYSDATE > v_incept_date)
      THEN
         FOR c IN
            (SELECT   booking_year,
                      TO_CHAR (TO_DATE (   '01-'
                                        || SUBSTR (booking_mth, 1, 3)
                                        || booking_year, 'DD-MONYYYY'
                                       ),
                               'MM'
                              ),
                      booking_mth
                 FROM giis_booking_month
                WHERE (NVL (booked_tag, 'N') != 'Y')
                  AND (   booking_year > TO_NUMBER (TO_CHAR (SYSDATE, 'YYYY'))
                       OR (    booking_year =
                                         TO_NUMBER (TO_CHAR (SYSDATE, 'YYYY'))
                           AND TO_NUMBER
                                    (TO_CHAR (TO_DATE (   '01-'
                                                       || SUBSTR (booking_mth,
                                                                  1,
                                                                  3
                                                                 )
                                                       || booking_year, 'DD-MONYYYY' -- edited by gab 08.20.2015
                                                      ),
                                              'MM'
                                             )
                                    ) >= TO_NUMBER (TO_CHAR (SYSDATE, 'MM'))
                          )
                      )
             ORDER BY 1, 2)
         LOOP
            v_booking_year := TO_NUMBER (c.booking_year);
            v_booking_mth := c.booking_mth;
            EXIT;
         END LOOP;
      ELSIF var_vdate = 2 OR (var_vdate = 3 AND SYSDATE <= v_incept_date)
      THEN
         FOR c IN
            (SELECT   booking_year,
                      TO_CHAR (TO_DATE (   '01-'
                                        || SUBSTR (booking_mth, 1, 3)
                                        || booking_year   , 'DD-MONYYYY'   -- jhing 10.05.2015 added date mask to prevent ORA-06512 for some machines (11G).
                                       ),
                               'MM'
                              ),
                      booking_mth
                 FROM giis_booking_month
                WHERE (NVL (booked_tag, 'N') <> 'Y')
                  AND (   booking_year >
                                   TO_NUMBER (TO_CHAR (v_incept_date, 'YYYY'))
                       OR (    booking_year =
                                   TO_NUMBER (TO_CHAR (v_incept_date, 'YYYY'))
                           AND TO_NUMBER
                                    (TO_CHAR (TO_DATE (   '01-'
                                                       || SUBSTR (booking_mth,
                                                                  1,
                                                                  3
                                                                 )
                                                       || booking_year, 'DD-MONYYYY' -- edited by gab 08.20.2015
                                                      ),
                                              'MM'
                                             )
                                    ) >=
                                     TO_NUMBER (TO_CHAR (v_incept_date, 'MM'))
                          )
                      )
             ORDER BY 1, 2)
         LOOP
            v_booking_year := TO_NUMBER (c.booking_year);
            v_booking_mth := c.booking_mth;
            EXIT;
         END LOOP;
      END IF;
      
     --edited by gab 08.28.2015
     IF v_place_cd is NOT NULL AND p_nbt_iss_cd != v_place_cd THEN
        BEGIN
           SELECT 1
             INTO v_iss_place_exist
             FROM giis_issource_place
            WHERE iss_cd = p_nbt_iss_cd AND place_cd = v_place_cd;
          EXCEPTION
           WHEN NO_DATA_FOUND
           THEN
              raise_application_error
                 (-20001,
                  'Geniisys Exception#I#Please setup issuing place "' || v_place_cd ||'" for issue source "'|| p_nbt_iss_cd ||'" before copying this PAR.'
                 );
        END;
     ELSE
        v_place_cd := NULL;
     END IF;
        
      INSERT INTO GIPI_WPOLBAS
                  (par_id, line_cd, subline_cd, iss_cd,
                   issue_yy, pol_seq_no, endt_iss_cd, endt_yy,
                   endt_seq_no, renew_no, endt_type, incept_date,
                   expiry_date, booking_year, booking_mth,
                   eff_date, issue_date, pol_flag, assd_no, designation,
                   mortg_name, tsi_amt, prem_amt, ann_tsi_amt,
                   ann_prem_amt, invoice_sw, pool_pol_no,
                   user_id, quotation_printed_sw, covernote_printed_sw,
                   address1, address2, address3, orig_policy_id,
                   endt_expiry_date, no_of_items, subline_type_cd,
                   auto_renew_flag, prorate_flag, short_rt_percent,
                   prov_prem_tag, type_cd, acct_of_cd, prov_prem_pct,
                   same_polno_sw, pack_pol_flag, prem_warr_tag, discount_sw,
                   reg_policy_sw, co_insurance_sw, ref_open_pol_no,
                   fleet_print_tag, incept_tag, expiry_tag,
                   endt_expiry_tag, foreign_acc_sw, comp_sw,
                   with_tariff_sw, place_cd, surcharge_sw, region_cd,
                   industry_cd, cred_branch, acct_of_cd_sw,
                   back_stat, cancel_date, label_tag,
                   manual_renew_no,
                                   takeup_term
                  )
           VALUES (p_par_id, v_line_cd, v_subline_cd, p_nbt_iss_cd, --p_iss_cd, Apollo 12.09.2014 - changed p_iss_cd to p_nbt_iss_cd
                   v_issue_yy, v_pol_seq_no, v_endt_iss_cd, v_endt_yy,
                   v_endt_seq_no, 00, v_endt_type, v_incept_date,
                   v_expiry_date, v_booking_year, v_booking_mth,
                   v_incept_date, SYSDATE, '1', v_assd_no, v_designation,
                   v_mortg_name, v_tsi_amt, v_prem_amt, v_ann_tsi_amt,
                   v_ann_prem_amt, v_invoice_sw, v_pool_pol_no,
                   p_user, 'N', 'N',
                   v_address1, v_address2, v_address3, v_orig_policy_id,
                   v_endt_expiry_date, v_no_of_items, v_subline_type_cd,
                   v_auto_renew_flag, v_prorate_flag, v_short_rt_percent,
                   v_prov_prem_tag, v_type_cd, v_acct_of_cd, v_prov_prem_pct,
                   'N', v_pack_pol_flag, v_prem_warr_tag, v_discount_sw,
                   v_reg_policy_sw, v_co_insurance_sw, v_ref_open_pol_no,
                   v_fleet_print_tag, v_incept_tag, v_expiry_tag,
                   v_endt_expiry_tag, v_foreign_acc_sw, NVL (v_comp_sw, 'N'),
                   v_with_tariff_sw, v_place_cd, v_surcharge_sw, v_region_cd,
                   v_industry_cd, v_cred_branch, v_acct_of_cd_sw,
                   v_back_stat, v_cancel_date, v_label_tag,
                   v_manual_renew_no, v_takeup_term
                  );

   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         NULL;
   END;
END;


FUNCTION validate_copypar_line_cd(p_line_cd         varchar2)
    RETURN varchar2
    IS
        v_exist1 varchar2(50);
    BEGIN
        FOR B IN (SELECT line_cd 
                              FROM giis_line
                             WHERE line_cd = p_line_cd)
         LOOP
             v_exist1 := 'Y';
         END LOOP;
      RETURN    v_exist1;
    END;
    
    /*
    **  Created by        : Veronica V. Raymundo
    **  Date Created      : 05.04.2013
    **  Reference By      : GIUTS008 - Copy Policy to PAR 
    */
    
    FUNCTION validate_line_cd
       (p_line_cd    giis_line.line_cd%TYPE,
        p_iss_cd    giis_issource.iss_cd%TYPE,
        p_user_id    giis_users.user_id%TYPE,
        p_module_id giis_modules.module_id%TYPE)
        RETURN VARCHAR2
    AS
        v_message    VARCHAR2(100) := 'SUCCESS';
        v_exist        VARCHAR2(1) := 'N';
    BEGIN
        FOR B IN (SELECT line_cd 
                     FROM giis_line
                    WHERE line_cd = p_line_cd)
        LOOP
             v_exist := 'Y';
         END LOOP;
        
        IF v_exist = 'N' THEN
            v_message := 'Line code entered is not valid.'; 
            RETURN v_message;
        ELSE
            IF check_user_per_line2(p_line_cd, p_iss_cd, NVL(p_module_id,'GIUTS023'), p_user_id) != 1 THEN
                v_message := 'You are not authorized to use this line.';
                RETURN v_message;
            END IF;
        END IF;
        
        RETURN v_message;
    END validate_line_cd;

FUNCTION check_op_flag(p_line_cd            varchar2,
                       p_subline_cd         varchar2)
    RETURN varchar2
    IS
        v_op_flag   varchar2(100);
    BEGIN
             FOR i IN(SELECT op_flag
                        FROM giis_subline
                       WHERE line_cd     = p_line_cd
                         AND subline_cd  = p_subline_cd)
             LOOP
                    v_op_flag       := i.op_flag;
             END LOOP;
         RETURN v_op_flag;
    END;

PROCEDURE insert_into_parlist(p_policy_id IN gipi_polbasic.policy_id%TYPE,
                               p_user       IN varchar2,
                               par_type     OUT varchar2,
                               p_par_id      IN number)
   IS
   v_par_id         gipi_parlist.par_id%TYPE;
   v_line_cd        gipi_parlist.line_cd%TYPE;
   v_iss_cd         gipi_parlist.iss_cd%TYPE;
   v_par_yy         gipi_parlist.par_yy%TYPE;
   v_quote_seq_no   gipi_parlist.quote_seq_no%TYPE;
   v_par_type       gipi_parlist.par_type%TYPE;
   v_assd_no        gipi_parlist.assd_no%TYPE;
   v_underwriter    gipi_parlist.underwriter%TYPE;
   v_assign_sw      gipi_parlist.assign_sw%TYPE;
   v_par_status     gipi_parlist.par_status%TYPE;
   v_address1       gipi_parlist.address1%TYPE;
   v_address2       gipi_parlist.address2%TYPE;
   v_address3       gipi_parlist.address3%TYPE;
   v_load_tag       gipi_parlist.load_tag%TYPE;
   
   BEGIN
         SELECT  a.line_cd, a.iss_cd,
                         TO_NUMBER (SUBSTR (TO_CHAR (SYSDATE, 'MM-DD-YYYY'), 9, 2)),
                         0,
                         b.par_type, b.assd_no, 'Y',
                         5, b.address1, b.address2, b.address3, 'C'
                    INTO  v_line_cd, v_iss_cd,
                         v_par_yy,v_quote_seq_no,
                         v_par_type, v_assd_no, v_assign_sw,
                         v_par_status, v_address1, v_address2, v_address3, v_load_tag
                    FROM gipi_polbasic a, gipi_parlist b
                   WHERE a.policy_id = p_policy_id 
                     AND a.par_id = b.par_id;
          
         v_par_id := p_par_id;
        BEGIN
             INSERT INTO gipi_parlist
                         (par_id, line_cd, iss_cd, par_yy,
                         quote_seq_no, par_type, assd_no, underwriter,
                         assign_sw, par_status, address1, address2,
                         address3, load_tag
                         )
                  VALUES (v_par_id, v_line_cd, v_iss_cd, v_par_yy,
                         v_quote_seq_no, v_par_type, v_assd_no, p_user,
                         v_assign_sw, v_par_status, v_address1, v_address2,
                         v_address3, v_load_tag
                         );
        END;
        FOR par IN (SELECT b.par_type TYPE
                 FROM gipi_polbasic a, gipi_parlist b
                WHERE a.policy_id = p_policy_id 
                  AND a.par_id = b.par_id)
        LOOP
            par_type := par.TYPE;
            
            EXIT;
        END LOOP;
        
       -- GIUTS008_PKG.insert_into_parhist(v_par_id);        
        
        
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         NULL;
      WHEN DUP_VAL_ON_INDEX 
      THEN 
        NULL;
   END;

FUNCTION validate_par_is_cd(p_iss_cd           varchar2,
                             p_line_cd         varchar2,
                             p_module_id       varchar2)
      RETURN exist_tab PIPELINED      
      IS
        v_exist    VARCHAR2(1) := 'N';
        v_exist1   VARCHAR2(1) := 'N';
        
        v_exist_ret     exist_type;
        
  BEGIN
        FOR B IN (SELECT iss_cd
                      FROM giis_issource
                   WHERE iss_cd = p_iss_cd) 
        LOOP         
            v_exist_ret.v_exist1 := 'Y';
        END LOOP;
        
        IF v_exist1 = 'N' THEN
           v_exist_ret.v_message        :=      'Issue Code entered is not valid .';            
        ELSE
            IF check_user_per_iss_cd(p_line_cd,p_iss_cd,p_module_id)=1 THEN
                  v_exist_ret.v_exist := 'Y';
             END IF;
               IF v_exist = 'N' THEN
                v_exist_ret.v_message       :=  'Issue Code entered is not allowed for the current user.'; 
               END IF;
        END IF;
      PIPE ROW(v_exist_ret);
    RETURN;
  END;
  
PROCEDURE insert_into_parhist(p_par_id          GIPI_PARLIST.par_id%TYPE,
                              p_user_id         GIPI_POLBASIC.user_id%TYPE) IS
BEGIN

   INSERT INTO GIPI_PARHIST
       (par_id, user_id, parstat_date, entry_source, parstat_cd)
   VALUES 
       (p_par_id, p_user_id, SYSDATE, 'DB', '1');
END;  

PROCEDURE copy_polgenin (p_policy_id      IN  GIPI_POLBASIC.policy_id%TYPE,
                         p_par_id         IN  GIPI_PARLIST.par_id%TYPE,
                         p_user_id        IN  GIPI_POLBASIC.user_id%TYPE)
IS
   v_first_info       GIPI_POLGENIN.first_info%TYPE;
   v_agreed_tag       GIPI_WPOLGENIN.agreed_tag%TYPE;
   v_genin_info_cd    GIPI_WPOLGENIN.genin_info_cd%TYPE;
   v_initial_info01   GIPI_WPOLGENIN.initial_info01%TYPE;
   v_initial_info02   GIPI_WPOLGENIN.initial_info02%TYPE;
   v_initial_info03   GIPI_WPOLGENIN.initial_info03%TYPE;
   v_initial_info04   GIPI_WPOLGENIN.initial_info04%TYPE;
   v_initial_info05   GIPI_WPOLGENIN.initial_info05%TYPE;
   v_initial_info06   GIPI_WPOLGENIN.initial_info06%TYPE;
   v_initial_info07   GIPI_WPOLGENIN.initial_info07%TYPE;
   v_initial_info08   GIPI_WPOLGENIN.initial_info08%TYPE;
   v_initial_info09   GIPI_WPOLGENIN.initial_info09%TYPE;
   v_initial_info10   GIPI_WPOLGENIN.initial_info10%TYPE;
   v_initial_info11   GIPI_WPOLGENIN.initial_info11%TYPE;
   v_initial_info12   GIPI_WPOLGENIN.initial_info12%TYPE;
   v_initial_info13   GIPI_WPOLGENIN.initial_info13%TYPE;
   v_initial_info14   GIPI_WPOLGENIN.initial_info14%TYPE;
   v_initial_info15   GIPI_WPOLGENIN.initial_info15%TYPE;
   v_initial_info16   GIPI_WPOLGENIN.initial_info16%TYPE;
   v_initial_info17   GIPI_WPOLGENIN.initial_info17%TYPE;
   v_long             GIPI_WPOLGENIN.gen_info%TYPE;
   v_gen01            GIPI_WPOLGENIN.gen_info01%TYPE;
   v_gen02            GIPI_WPOLGENIN.gen_info02%TYPE;
   v_gen03            GIPI_WPOLGENIN.gen_info03%TYPE;
   v_gen04            GIPI_WPOLGENIN.gen_info04%TYPE;
   v_gen05            GIPI_WPOLGENIN.gen_info05%TYPE;
   v_gen06            GIPI_WPOLGENIN.gen_info06%TYPE;
   v_gen07            GIPI_WPOLGENIN.gen_info07%TYPE;
   v_gen08            GIPI_WPOLGENIN.gen_info08%TYPE;
   v_gen09            GIPI_WPOLGENIN.gen_info09%TYPE;
   v_gen10            GIPI_WPOLGENIN.gen_info10%TYPE;
   v_gen11            GIPI_WPOLGENIN.gen_info11%TYPE;
   v_gen12            GIPI_WPOLGENIN.gen_info12%TYPE;
   v_gen13            GIPI_WPOLGENIN.gen_info13%TYPE;
   v_gen14            GIPI_WPOLGENIN.gen_info14%TYPE;
   v_gen15            GIPI_WPOLGENIN.gen_info15%TYPE;
   v_gen16            GIPI_WPOLGENIN.gen_info16%TYPE;
   v_gen17            GIPI_WPOLGENIN.gen_info17%TYPE;
   
   
BEGIN

   SELECT gen_info, gen_info01, gen_info02, gen_info03,
          gen_info04, gen_info05, gen_info06, gen_info07,
          gen_info08, gen_info09, gen_info10, gen_info11,
          gen_info12, gen_info13, gen_info14, gen_info15,
          gen_info16, gen_info17, first_info, agreed_tag,
          genin_info_cd, initial_info01, initial_info02,
          initial_info03, initial_info04, initial_info05,
          initial_info06, initial_info07, initial_info08,
          initial_info09, initial_info10, initial_info11,
          initial_info12, initial_info13, initial_info14,
          initial_info15, initial_info16, initial_info17
     INTO v_long,v_gen01,v_gen02,v_gen03,
          v_gen04,v_gen05,v_gen06,v_gen07,
          v_gen08,v_gen09,v_gen10,v_gen11,
          v_gen12,v_gen13,v_gen14,v_gen15,
          v_gen16,v_gen17, v_first_info, v_agreed_tag,
          v_genin_info_cd, v_initial_info01, v_initial_info02,
          v_initial_info03, v_initial_info04, v_initial_info05,
          v_initial_info06, v_initial_info07, v_initial_info08,
          v_initial_info09, v_initial_info10, v_initial_info11,
          v_initial_info12, v_initial_info13, v_initial_info14,
          v_initial_info15, v_initial_info16, v_initial_info17
     FROM GIPI_POLGENIN
    WHERE policy_id = p_policy_id;

   INSERT INTO GIPI_WPOLGENIN
               (par_id, gen_info, gen_info01, gen_info02,
                gen_info03, gen_info04, gen_info05, gen_info06,
                gen_info07, gen_info08, gen_info09, gen_info10,
                gen_info11, gen_info12, gen_info13, gen_info14,
                gen_info15, gen_info16, gen_info17, first_info,
                user_id, last_update, agreed_tag, genin_info_cd,
                initial_info01, initial_info02, initial_info03,
                initial_info04, initial_info05, initial_info06,
                initial_info07, initial_info08, initial_info09,
                initial_info10, initial_info11, initial_info12,
                initial_info13, initial_info14, initial_info15,
                initial_info16, initial_info17
               )
        VALUES (p_par_id,v_long,v_gen01,v_gen02,
                v_gen03,v_gen04,v_gen05,v_gen06,
                v_gen07,v_gen08,v_gen09,v_gen10,
                v_gen11,v_gen12,v_gen13,v_gen14,
                v_gen15,v_gen16,v_gen17, v_first_info,
                p_user_id, SYSDATE, v_agreed_tag, v_genin_info_cd,
                v_initial_info01, v_initial_info02, v_initial_info03,
                v_initial_info04, v_initial_info05, v_initial_info06,
                v_initial_info07, v_initial_info08, v_initial_info09,
                v_initial_info10, v_initial_info11, v_initial_info12,
                v_initial_info13, v_initial_info14, v_initial_info15,
                v_initial_info16, v_initial_info17
               );

EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      NULL;
END;
  

PROCEDURE copy_polwc (p_policy_id      IN  GIPI_POLBASIC.policy_id%TYPE,
                      p_par_id         IN  GIPI_PARLIST.par_id%TYPE)
IS
   CURSOR polwc_cur
   IS
      SELECT policy_id, line_cd, wc_cd, swc_seq_no, print_seq_no, wc_title,
             wc_remarks, wc_text01, wc_text02, wc_text03, wc_text04,
             wc_text05, wc_text06, wc_text07, wc_text08, wc_text09,
             wc_text10, wc_text11, wc_text12, wc_text13, wc_text14,
             wc_text15, wc_text16, wc_text17, rec_flag, change_tag,
             wc_title2, NVL (print_sw, 'N')            
        FROM GIPI_POLWC
       WHERE policy_id = p_policy_id;

   v_policy_id      GIPI_POLWC.policy_id%TYPE;
   v_line_cd        GIPI_POLWC.line_cd%TYPE;
   v_wc_cd          GIPI_POLWC.wc_cd%TYPE;
   v_swc_seq_no     GIPI_POLWC.swc_seq_no%TYPE;
   v_print_seq_no   GIPI_POLWC.print_seq_no%TYPE;
   v_wc_title       GIPI_POLWC.wc_title%TYPE;
   v_wc_title2      GIPI_POLWC.wc_title2%TYPE;
   v_wc_remarks     GIPI_POLWC.wc_remarks%TYPE;
   v_rec_flag       GIPI_POLWC.rec_flag%TYPE;
   v_wc_text01      GIPI_POLWC.wc_text01%TYPE;
   v_wc_text02      GIPI_POLWC.wc_text01%TYPE;
   v_wc_text03      GIPI_POLWC.wc_text01%TYPE;
   v_wc_text04      GIPI_POLWC.wc_text01%TYPE;
   v_wc_text05      GIPI_POLWC.wc_text01%TYPE;
   v_wc_text06      GIPI_POLWC.wc_text01%TYPE;
   v_wc_text07      GIPI_POLWC.wc_text01%TYPE;
   v_wc_text08      GIPI_POLWC.wc_text01%TYPE;
   v_wc_text09      GIPI_POLWC.wc_text01%TYPE;
   v_wc_text10      GIPI_POLWC.wc_text01%TYPE;
   v_wc_text11      GIPI_POLWC.wc_text01%TYPE;
   v_wc_text12      GIPI_POLWC.wc_text01%TYPE;
   v_wc_text13      GIPI_POLWC.wc_text01%TYPE;
   v_wc_text14      GIPI_POLWC.wc_text14%TYPE;
   v_wc_text15      GIPI_POLWC.wc_text15%TYPE;
   v_wc_text16      GIPI_POLWC.wc_text16%TYPE;
   v_wc_text17      GIPI_POLWC.wc_text17%TYPE;
   v_change_tag     GIPI_POLWC.change_tag%TYPE;
   v_print_sw       GIPI_POLWC.print_sw%TYPE;          
BEGIN

   OPEN polwc_cur;

   LOOP
      FETCH polwc_cur
       
      INTO  v_policy_id, v_line_cd, v_wc_cd, v_swc_seq_no, v_print_seq_no,
            v_wc_title, v_wc_remarks, v_wc_text01, v_wc_text02, v_wc_text03,
            v_wc_text04, v_wc_text05, v_wc_text06, v_wc_text07, v_wc_text08,
            v_wc_text09, v_wc_text10, v_wc_text11, v_wc_text12, v_wc_text13,
            v_wc_text14, v_wc_text15, v_wc_text16, v_wc_text17, v_rec_flag,
            v_change_tag, v_wc_title2, v_print_sw;       

      EXIT WHEN polwc_cur%NOTFOUND;

      INSERT INTO GIPI_WPOLWC
              (par_id, line_cd, wc_cd, swc_seq_no,
               print_seq_no, wc_title, wc_remarks, wc_text01,
               wc_text02, wc_text03, wc_text04, wc_text05,
               wc_text06, wc_text07, wc_text08, wc_text09,
               wc_text10, wc_text11, wc_text12, wc_text13,
               wc_text14, wc_text15, wc_text16, wc_text17,
               rec_flag, change_tag, wc_title2, print_sw
              )                                       
       VALUES (p_par_id, v_line_cd, v_wc_cd, v_swc_seq_no,
               v_print_seq_no, v_wc_title, v_wc_remarks, v_wc_text01,
               v_wc_text02, v_wc_text03, v_wc_text04, v_wc_text05,
               v_wc_text06, v_wc_text07, v_wc_text08, v_wc_text09,
               v_wc_text10, v_wc_text11, v_wc_text12, v_wc_text13,
               v_wc_text14, v_wc_text15, v_wc_text16, v_wc_text17,
               v_rec_flag, v_change_tag, v_wc_title2, v_print_sw
              );                                       
   END LOOP;

  
   CLOSE polwc_cur;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      NULL;
END;


PROCEDURE copy_principal (p_policy_id   IN  GIPI_PRINCIPAL.policy_id%TYPE,
                          p_par_id      IN  GIPI_PARLIST.par_id%TYPE)
IS
   CURSOR prin_cur
   IS
      SELECT principal_cd, engg_basic_infonum, subcon_sw
        FROM GIPI_PRINCIPAL
       WHERE policy_id = p_policy_id;

   v_principal_cd         GIPI_PRINCIPAL.principal_cd%TYPE;
   v_engg_basic_infonum   GIPI_PRINCIPAL.engg_basic_infonum%TYPE;
   v_subcon_sw            GIPI_PRINCIPAL.subcon_sw%TYPE;
BEGIN
   OPEN prin_cur;

   LOOP
      FETCH prin_cur
       INTO v_principal_cd, v_engg_basic_infonum, v_subcon_sw;

      EXIT WHEN prin_cur%NOTFOUND;

      INSERT INTO GIPI_WPRINCIPAL
          (par_id, principal_cd, engg_basic_infonum,
           subcon_sw
          )
       VALUES 
          (p_par_id, v_principal_cd, v_engg_basic_infonum,
           v_subcon_sw);
           
   END LOOP;
   CLOSE prin_cur;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      NULL;
END;

PROCEDURE copy_vehicle (p_policy_id   IN  GIPI_POLBASIC.policy_id%TYPE,
                        p_par_id      IN  GIPI_PARLIST.par_id%TYPE)
IS
   CURSOR vehicle_cur
   IS
      SELECT item_no, subline_cd, coc_yy, coc_seq_no, coc_type, repair_lim,
             color, motor_no, model_year, make, mot_type, est_value,
             serial_no, towing, assignee, plate_no, subline_type_cd,
             no_of_pass, tariff_zone, type_of_body_cd, car_company_cd,
             mv_file_no, acquired_from, ctv_tag, make_cd, series_cd,
             basic_color_cd, color_cd, unladen_wt, origin, destination,
             coc_serial_no, motor_coverage, mv_type, mv_prem_type, tax_type
        FROM GIPI_VEHICLE
       WHERE policy_id = p_policy_id;

   v_item_no           GIPI_VEHICLE.item_no%TYPE;
   v_subline_cd        GIPI_VEHICLE.subline_cd%TYPE;
   v_coc_yy            GIPI_VEHICLE.coc_yy%TYPE;
   v_coc_seq_no        GIPI_VEHICLE.coc_seq_no%TYPE;
   v_coc_type          GIPI_VEHICLE.coc_type%TYPE;
   v_repair_lim        GIPI_VEHICLE.repair_lim%TYPE;
   v_color             GIPI_VEHICLE.color%TYPE;
   v_motor_no          GIPI_VEHICLE.motor_no%TYPE;
   v_model_year        GIPI_VEHICLE.model_year%TYPE;
   v_make              GIPI_VEHICLE.make%TYPE;
   v_mot_type          GIPI_VEHICLE.mot_type%TYPE;
   v_est_value         GIPI_VEHICLE.est_value%TYPE;
   v_serial_no         GIPI_VEHICLE.serial_no%TYPE;
   v_towing            GIPI_VEHICLE.towing%TYPE;
   v_assignee          GIPI_VEHICLE.assignee%TYPE;
   v_plate_no          GIPI_VEHICLE.plate_no%TYPE;
   v_subline_type_cd   GIPI_VEHICLE.subline_type_cd%TYPE;
   v_no_of_pass        GIPI_VEHICLE.no_of_pass%TYPE;
   v_tariff_zone       GIPI_VEHICLE.tariff_zone%TYPE;
   v_type_of_body_cd   GIPI_VEHICLE.type_of_body_cd%TYPE;
   v_car_company_cd    GIPI_VEHICLE.car_company_cd%TYPE;
   v_mv_file_no        GIPI_VEHICLE.mv_file_no%TYPE;
   v_acquired_from     GIPI_VEHICLE.acquired_from%TYPE;
   v_ctv_tag           GIPI_VEHICLE.ctv_tag%TYPE;
   v_make_cd           GIPI_VEHICLE.make_cd%TYPE;
   v_series_cd         GIPI_VEHICLE.series_cd%TYPE;
   v_basic_color_cd    GIPI_VEHICLE.basic_color_cd%TYPE;
   v_color_cd          GIPI_VEHICLE.color_cd%TYPE;
   v_unladen_wt        GIPI_VEHICLE.unladen_wt%TYPE;
   v_origin            GIPI_VEHICLE.origin%TYPE;
   v_destination       GIPI_VEHICLE.destination%TYPE;
   v_coc_serial_no     GIPI_VEHICLE.coc_serial_no%TYPE;
   v_deduct            GIPI_DEDUCTIBLES.deductible_amt%TYPE;
   v_motor_coverage    GIPI_VEHICLE.motor_coverage%TYPE;
   v_mv_type		   GIPI_VEHICLE.mv_type%TYPE;
   v_mv_prem_type	   GIPI_VEHICLE.mv_prem_type%TYPE;
   v_tax_type	   	   GIPI_VEHICLE.tax_type%TYPE;
BEGIN
   OPEN vehicle_cur;

   LOOP
      FETCH vehicle_cur
       INTO v_item_no, v_subline_cd, v_coc_yy, v_coc_seq_no, v_coc_type,
            v_repair_lim, v_color, v_motor_no, v_model_year, v_make,
            v_mot_type, v_est_value, v_serial_no, v_towing, v_assignee,
            v_plate_no, v_subline_type_cd, v_no_of_pass, v_tariff_zone,
            v_type_of_body_cd, v_car_company_cd, v_mv_file_no,
            v_acquired_from, v_ctv_tag, v_make_cd, v_series_cd,
            v_basic_color_cd, v_color_cd, v_unladen_wt, v_origin,
            v_destination, v_coc_serial_no, v_motor_coverage, v_mv_type, 
            v_mv_prem_type, v_tax_type;

      EXIT WHEN vehicle_cur%NOTFOUND;

      FOR c IN (SELECT SUM (deductible_amt) deduct
                  FROM GIPI_DEDUCTIBLES
                 WHERE policy_id = p_policy_id AND item_no = v_item_no)
      LOOP
         v_deduct := c.deduct;
      END LOOP;

      INSERT INTO GIPI_WVEHICLE
                  (par_id, item_no, subline_cd, make, mot_type,
                   color, plate_no, repair_lim, serial_no,
                   motor_no, coc_seq_no, coc_type, assignee,
                   model_year, coc_issue_date, coc_yy, towing, est_value,
                   subline_type_cd, no_of_pass, tariff_zone,
                   type_of_body_cd, car_company_cd, mv_file_no,
                   acquired_from, ctv_tag, make_cd, series_cd,
                   basic_color_cd, color_cd, unladen_wt, origin,
                   destination, coc_serial_no, motor_coverage, mv_type, 
                   mv_prem_type, tax_type
                  )
           VALUES (p_par_id, v_item_no, v_subline_cd, v_make, v_mot_type,
                   v_color, v_plate_no, (v_towing + v_deduct), v_serial_no,
                   v_motor_no, v_coc_seq_no, v_coc_type, v_assignee,
                   v_model_year, SYSDATE, v_coc_yy, v_towing, v_est_value,
                   v_subline_type_cd, v_no_of_pass, v_tariff_zone,
                   v_type_of_body_cd, v_car_company_cd, v_mv_file_no,
                   v_acquired_from, v_ctv_tag, v_make_cd, v_series_cd,
                   v_basic_color_cd, v_color_cd, v_unladen_wt, v_origin,
                   v_destination, v_coc_serial_no, v_motor_coverage, v_mv_type, 
                   v_mv_prem_type, v_tax_type
                  );
   END LOOP;

   CLOSE vehicle_cur;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      NULL;
END;

PROCEDURE update_gipi_parlist(p_iss_cd    IN  gipi_parlist.iss_cd%TYPE,
                              p_par_id    IN  gipi_parlist.par_id%TYPE)
IS
BEGIN
   UPDATE gipi_parlist
      SET iss_cd = p_iss_cd,
          par_yy = TO_NUMBER (SUBSTR (TO_CHAR (SYSDATE, 'MM-DD-YYYY'), 9, 2))
    WHERE par_id = p_par_id;
END;


PROCEDURE update_gipi_wpolbas2(p_iss_cd   IN  gipi_wpolbas.iss_cd%TYPE,
                              p_par_id   IN  gipi_wpolbas.par_id%TYPE)
IS
BEGIN
   UPDATE gipi_wpolbas
      SET iss_cd = p_iss_cd,
          issue_yy =
                    TO_NUMBER (SUBSTR (TO_CHAR (SYSDATE, 'MM-DD-YYYY'), 9, 2))
    WHERE par_id = p_par_id;
END;

PROCEDURE update_all_tables(p_iss_cd   IN  GIPI_WPOLBAS.iss_cd%TYPE,
                            p_par_id   IN  GIPI_WPOLBAS.par_id%TYPE,
                            p_nbt_endt_iss_cd  IN  GIPI_WPOLBAS.endt_iss_cd%TYPE)
IS
BEGIN
   GIUTS008_PKG.update_gipi_parlist(p_iss_cd,p_par_id);

   IF p_nbt_endt_iss_cd IS NULL
   THEN
      GIUTS008_PKG.update_gipi_wpolbas2(p_iss_cd,p_par_id);
   END IF;
END;


PROCEDURE copy_vehicle_pack (
   p_policy_id   IN   gipi_polbasic.policy_id%TYPE,
   p_item_no     IN   gipi_item.item_no%TYPE,
   p_par_id      IN   number
)
IS
   CURSOR vehicle_cur
   IS
      SELECT item_no, subline_cd, coc_yy, coc_seq_no, coc_type, repair_lim,
             color, motor_no, model_year, make, mot_type, est_value,
             serial_no, towing, assignee, plate_no, subline_type_cd,
             no_of_pass, tariff_zone, type_of_body_cd, car_company_cd,
             mv_file_no, acquired_from, ctv_tag, make_cd, series_cd,
             basic_color_cd, color_cd, unladen_wt, origin, destination,
             coc_serial_no, coc_issue_date, coc_atcn,
             motor_coverage                                
        FROM gipi_vehicle
       WHERE policy_id = p_policy_id AND item_no = p_item_no;

   v_item_no           gipi_vehicle.item_no%TYPE;
   v_subline_cd        gipi_vehicle.subline_cd%TYPE;
   v_coc_yy            gipi_vehicle.coc_yy%TYPE;
   v_coc_seq_no        gipi_vehicle.coc_seq_no%TYPE;
   v_coc_type          gipi_vehicle.coc_type%TYPE;
   v_repair_lim        gipi_vehicle.repair_lim%TYPE;
   v_color             gipi_vehicle.color%TYPE;
   v_motor_no          gipi_vehicle.motor_no%TYPE;
   v_model_year        gipi_vehicle.model_year%TYPE;
   v_make              gipi_vehicle.make%TYPE;
   v_mot_type          gipi_vehicle.mot_type%TYPE;
   v_est_value         gipi_vehicle.est_value%TYPE;
   v_serial_no         gipi_vehicle.serial_no%TYPE;
   v_towing            gipi_vehicle.towing%TYPE;
   v_assignee          gipi_vehicle.assignee%TYPE;
   v_plate_no          gipi_vehicle.plate_no%TYPE;
   v_subline_type_cd   gipi_vehicle.subline_type_cd%TYPE;
   v_no_of_pass        gipi_vehicle.no_of_pass%TYPE;
   v_tariff_zone       gipi_vehicle.tariff_zone%TYPE;
   v_type_of_body_cd   gipi_vehicle.type_of_body_cd%TYPE;
   v_car_company_cd    gipi_vehicle.car_company_cd%TYPE;
   v_mv_file_no        gipi_vehicle.mv_file_no%TYPE;
   v_acquired_from     gipi_vehicle.acquired_from%TYPE;
   v_ctv_tag           gipi_vehicle.ctv_tag%TYPE;
   v_make_cd           gipi_vehicle.make_cd%TYPE;
   v_series_cd         gipi_vehicle.series_cd%TYPE;
   v_basic_color_cd    gipi_vehicle.basic_color_cd%TYPE;
   v_color_cd          gipi_vehicle.color_cd%TYPE;
   v_unladen_wt        gipi_vehicle.unladen_wt%TYPE;
   v_origin            gipi_vehicle.origin%TYPE;
   v_destination       gipi_vehicle.destination%TYPE;
   v_deduct            gipi_deductibles.deductible_amt%TYPE;
   v_coc_serial_no     gipi_vehicle.coc_serial_no%TYPE;
   v_coc_issue_date    gipi_vehicle.coc_issue_date%TYPE;
   v_coc_atcn          gipi_vehicle.coc_atcn%TYPE;
   v_motor_coverage    gipi_vehicle.motor_coverage%TYPE;
BEGIN
   FOR c IN (SELECT SUM (deductible_amt) deduct
               FROM gipi_deductibles
              WHERE policy_id = p_policy_id AND item_no = p_item_no)
   LOOP
      v_deduct := c.deduct;
   END LOOP;


   OPEN vehicle_cur;

   LOOP
      FETCH vehicle_cur
       INTO v_item_no, v_subline_cd, v_coc_yy, v_coc_seq_no, v_coc_type,
            v_repair_lim, v_color, v_motor_no, v_model_year, v_make,
            v_mot_type, v_est_value, v_serial_no, v_towing, v_assignee,
            v_plate_no, v_subline_type_cd, v_no_of_pass, v_tariff_zone,
            v_type_of_body_cd, v_car_company_cd, v_mv_file_no,
            v_acquired_from, v_ctv_tag, v_make_cd, v_series_cd,
            v_basic_color_cd, v_color_cd, v_unladen_wt, v_origin,
            v_destination, v_coc_serial_no, v_coc_issue_date, v_coc_atcn,
            v_motor_coverage;

      EXIT WHEN vehicle_cur%NOTFOUND;

      INSERT INTO gipi_wvehicle
                  (par_id, item_no, subline_cd, coc_yy,
                   coc_seq_no, coc_type, repair_lim,
                   color, motor_no, model_year, make, mot_type,
                   est_value, serial_no, towing, assignee,
                   plate_no, subline_type_cd, no_of_pass,
                   tariff_zone, type_of_body_cd, car_company_cd,
                   mv_file_no, acquired_from, ctv_tag, make_cd,
                   series_cd, basic_color_cd, color_cd, unladen_wt,
                   origin, destination, coc_serial_no, coc_issue_date,
                   coc_atcn, motor_coverage
                  )
           VALUES (p_par_id, v_item_no, v_subline_cd, v_coc_yy,
                   v_coc_seq_no, v_coc_type, (v_towing + v_deduct),
                   v_color, v_motor_no, v_model_year, v_make, v_mot_type,
                   v_est_value, v_serial_no, v_towing, v_assignee,
                   v_plate_no, v_subline_type_cd, v_no_of_pass,
                   v_tariff_zone, v_type_of_body_cd, v_car_company_cd,
                   v_mv_file_no, v_acquired_from, v_ctv_tag, v_make_cd,
                   v_series_cd, v_basic_color_cd, v_color_cd, v_unladen_wt,
                   v_origin, v_destination, v_coc_serial_no, SYSDATE,
                   v_coc_atcn, v_motor_coverage
                  );
   END LOOP;

   CLOSE vehicle_cur;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      NULL;
END;

PROCEDURE main_query_copy(p_policy_id           IN          number,
                          p_nbt_line_cd         IN          varchar2,
                          p_nbt_subline_cd      IN          varchar2,
                          p_nbt_endt_seq_no     IN          number,
                          p_line_cd             IN          varchar2,
                          p_iss_cd              IN          varchar2,
                          p_issue_yy            IN          number,
                         -- p_pol_seq_no          IN          number,
                          p_renew_no            IN          number,
                          p_nbt_iss_cd          IN          varchar2,
                          p_nbt_issue_yy        IN          number,
                          p_nbt_pol_seq_no      IN          number,
                          p_nbt_renew_no        IN          number,
                          p_nbt_endt_iss_cd     IN          varchar2,
                          p_nbt_endt_yy         IN          number,
                          p_user                IN          varchar2,
                          r_par_seq_no          OUT         number,
                          r_quote_seq_no        OUT         number,
                          par_id                OUT         number,
                          v_message             OUT      varchar2,
                          v_message2            OUT      varchar2,
                          v_message3            OUT      varchar2,
                          v_message4            OUT      varchar2)                   
        IS
        v_open_flag             varchar2(100);
        v_success VARCHAR2(1);
  BEGIN 
                  FOR FLAG IN(SELECT op_flag
                                FROM giis_subline
                               WHERE line_cd     = p_nbt_line_cd
                                 AND subline_cd  = p_nbt_subline_cd) 
                  LOOP
                    v_open_flag := flag.op_flag;
                    EXIT;
                  END LOOP;
          
          DECLARE
                    COUNTER                     NUMBER;
                    v_policy_id                 gipi_polbasic.policy_id%TYPE;
                    v_pol_flag                  gipi_polbasic.pol_flag%TYPE;
                    v_line_cd                   gipi_polbasic.line_cd%TYPE;
                    v_subline_cd                gipi_polbasic.subline_cd%TYPE;
                    v_iss_cd                    gipi_polbasic.iss_cd%TYPE;
                    v_issue_yy                  gipi_polbasic.issue_yy%TYPE;
                    v_pol_seq_no                gipi_polbasic.pol_seq_no%TYPE;
                    v_renew_no                  gipi_polbasic.renew_no%TYPE;
                    v_count                     NUMBER(10);
                    v_pack_pol_flag             giis_line.pack_pol_flag%TYPE;
                    v_pack_line_cd              gipi_item.pack_line_cd%TYPE;
                    v_pack_subline_cd           gipi_item.pack_subline_cd%TYPE;
                    v_item_grp                  gipi_item.item_grp%TYPE;
                    v_item_no                   gipi_item.item_no%TYPE;
                    v_item_exists               VARCHAR2(1) := 'N';
                    v_iss_cd_ri                    VARCHAR2(10);
                    par_type                    varchar2(100);
                    par_id                      number;
                    v_par_seq_no                number;
                    v_quote_seq_no              number;
                    v_menu_line_cd              varchar2(100);
                    v_long                      varchar2(2000);
                    v_subline_mop               varchar2(100);
                    v_line_ac                   varchar2(100);
                    v_line_av                   varchar2(100);
                    v_line_en                   varchar2(100);
                    v_line_mc                   varchar2(100);
                    v_line_fi                   varchar2(100);
                    v_line_ca                   varchar2(100);
                    v_line_mh                   varchar2(100);
                    v_line_mn                   varchar2(100);
                    v_line_su                   varchar2(100);
                    r_par_seq_no                number;
                    r_quote_seq_no              number;
                    
                    
                    CURSOR cur_flag IS
                    SELECT pack_line_cd,pack_subline_cd,item_grp,item_no
                      FROM gipi_item
                     WHERE policy_id = p_policy_id
                     ORDER BY item_grp;
                     
                    
                      
              
          BEGIN 
                      SELECT param_value_v
                        INTO v_line_ac
                        FROM giis_parameters
                       WHERE param_name = 'LINE_CODE_AC';
                           
                      SELECT param_value_v
                        INTO v_line_av
                        FROM giis_parameters
                       WHERE param_name = 'LINE_CODE_AV';

                      SELECT param_value_v
                        INTO v_line_en
                        FROM giis_parameters
                       WHERE param_name = 'LINE_CODE_EN';

                      SELECT param_value_v
                        INTO v_line_mc
                        FROM giis_parameters
                       WHERE param_name = 'LINE_CODE_MC';

                      SELECT param_value_v
                        INTO v_line_fi
                        FROM giis_parameters
                       WHERE param_name = 'LINE_CODE_FI';

                      SELECT param_value_v
                        INTO v_line_ca
                        FROM giis_parameters
                       WHERE param_name = 'LINE_CODE_CA';

                      SELECT param_value_v
                        INTO v_line_mh
                        FROM giis_parameters
                       WHERE param_name = 'LINE_CODE_MH';

                      SELECT param_value_v
                        INTO v_line_mn
                        FROM giis_parameters
                       WHERE param_name = 'LINE_CODE_MN';

                      SELECT param_value_v
                        INTO v_line_su
                        FROM giis_parameters
                       WHERE param_name = 'LINE_CODE_SU';

                      SELECT param_value_v
                        INTO v_subline_mop
                        FROM giis_parameters
                       WHERE param_name = 'SUBLINE_MN_MOP';    
                       
                       v_policy_id := p_policy_id;
                       
                    SELECT parlist_par_id_s.nextval
                      INTO par_id
                      FROM DUAL;
                
                 IF p_nbt_endt_seq_no > 0 THEN
                   GIUTS008_PKG.check_endt(p_line_cd,p_nbt_subline_cd,p_iss_cd,p_issue_yy,p_nbt_pol_seq_no,p_renew_no,p_nbt_endt_iss_cd,p_nbt_endt_yy,p_nbt_endt_seq_no);
                    SELECT policy_id, pol_flag, line_cd, subline_cd, iss_cd,
                           issue_yy, pol_seq_no, renew_no
                      INTO v_policy_id, v_pol_flag, v_line_cd, v_subline_cd, v_iss_cd,
                           v_issue_yy, v_pol_seq_no, v_renew_no
                      FROM gipi_polbasic
                     WHERE line_cd = p_nbt_line_cd
                       AND subline_cd = p_nbt_subline_cd
                       AND iss_cd = p_nbt_iss_cd
                       AND issue_yy = p_nbt_issue_yy
                       AND pol_seq_no = p_nbt_pol_seq_no
                       AND renew_no = p_nbt_renew_no
                       AND endt_iss_cd = p_nbt_endt_iss_cd
                       AND endt_yy = p_nbt_endt_yy
                       AND endt_seq_no = p_nbt_endt_seq_no;
                ELSE 
                    GIUTS008_PKG.check_policy(p_nbt_line_cd,p_nbt_subline_cd,p_nbt_iss_cd,p_nbt_issue_yy,p_nbt_pol_seq_no,p_nbt_renew_no);
                    SELECT policy_id, pol_flag, line_cd, subline_cd, iss_cd,
                           issue_yy, pol_seq_no, renew_no
                      INTO v_policy_id, v_pol_flag, v_line_cd, v_subline_cd, v_iss_cd,
                           v_issue_yy, v_pol_seq_no, v_renew_no
                      FROM gipi_polbasic
                     WHERE line_cd = p_nbt_line_cd
                       AND subline_cd = p_nbt_subline_cd
                       AND iss_cd = p_nbt_iss_cd
                       AND issue_yy = p_nbt_issue_yy
                       AND pol_seq_no = p_nbt_pol_seq_no
                       AND renew_no = p_nbt_renew_no
                       AND endt_seq_no = 0;
                END IF;
                
                GIUTS008_PKG.insert_into_parlist(v_policy_id,p_user,par_type,par_id);               
                GIUTS008_PKG.insert_into_parhist(par_id, p_user);
                
               FOR hh IN(SELECT DISTINCT par_seq_no,quote_seq_no
                           FROM gipi_parlist
                          WHERE par_id = par_id)
               LOOP
                    r_par_seq_no        := hh.par_seq_no;
                    r_quote_seq_no      := hh.quote_seq_no;
               END LOOP;
                
                
                 
                SELECT giisp.v('ISS_CD_RI') 
                  INTO v_iss_cd_ri
                  FROM DUAL;
                  
            IF v_iss_cd = 'RI' OR v_iss_cd = v_iss_cd_ri THEN   
                GIUTS008_PKG.copy_inpolbas(v_policy_id,par_id, p_user);
            END IF;
            
                GIUTS008_PKG.copy_polbasic(v_policy_id,p_iss_cd,p_nbt_iss_cd,p_nbt_line_cd,p_nbt_subline_cd,p_nbt_issue_yy,p_nbt_pol_seq_no,p_nbt_renew_no,par_id,p_user);
                GIUTS008_PKG.copy_mortgagee(v_policy_id,par_id,p_nbt_iss_cd, v_success);
                GIUTS008_PKG.copy_polgenin(v_policy_id,par_id, p_user);
                GIUTS008_PKG.copy_polwc(v_policy_id,par_id);
                GIUTS008_PKG.copy_endttext(v_policy_id,par_id,v_long);
                
                SELECT pack_pol_flag
                  INTO v_pack_pol_flag
                  FROM giis_line
                 WHERE line_cd = p_nbt_line_cd;
                COUNTER := 0;
                FOR A IN (SELECT menu_line_cd
                            FROM giis_line
                           WHERE line_cd = p_nbt_line_cd)
                LOOP
                  v_menu_line_cd := a.menu_line_cd;
                  EXIT;
                END LOOP;   
                
                IF v_pack_pol_flag = 'Y' THEN
                   GIUTS008_PKG.copy_pack_line_subline(v_policy_id,par_id);
                   FOR var_flag IN cur_flag LOOP
                       v_pack_line_cd := var_flag.pack_line_cd;
                       v_pack_subline_cd := var_flag.pack_subline_cd;  
                       v_item_grp  := var_flag.item_grp;
                       v_item_no   := var_flag.item_no;
                       GIUTS008_PKG.copy_line(v_policy_id,v_pack_line_cd,v_pack_subline_cd,v_iss_cd,v_issue_yy,v_pol_seq_no,v_item_no,v_item_grp,p_nbt_line_cd,p_nbt_subline_cd,par_type,par_id,p_iss_cd,p_issue_yy,r_par_seq_no,p_renew_no);   
                       v_item_exists := 'Y';
                   END LOOP; 
                ELSE         
                   IF      
                      (NVL(v_menu_line_cd,v_line_cd) != 'MN' AND  
                         p_nbt_subline_cd != v_subline_mop) THEN
                      
                      IF v_line_cd != v_line_ac OR
                            v_menu_line_cd != 'AC' THEN
                         GIUTS008_PKG.copy_lim_liab(v_policy_id,par_id);
                      END IF;          
                      
                      GIUTS008_PKG.copy_item(v_policy_id,p_nbt_line_cd,p_nbt_subline_cd,p_nbt_iss_cd,p_nbt_issue_yy,p_nbt_pol_seq_no,p_nbt_renew_no,par_type,par_id);
                      IF par_type = 'P' THEN  
                         GIUTS008_PKG.copy_itmperil(v_policy_id,p_nbt_line_cd,par_id);             
                      END IF;
                      
                      IF par_type = 'P' THEN  
                         GIUTS008_PKG.copy_peril_discount(v_policy_id,par_id);             
                         GIUTS008_PKG.copy_item_discount(v_policy_id,par_id);
                         GIUTS008_PKG.copy_polbas_discount(v_policy_id,par_id);
                      END IF;              
                   END IF;    
                   
                   IF v_line_cd = v_line_ac OR
                      v_menu_line_cd = 'AC' THEN
                      GIUTS008_PKG.copy_beneficiary(v_policy_id,par_id);          
                      GIUTS008_PKG.copy_accident_item(v_policy_id,par_id);
                   ELSIF v_line_cd = v_line_ca OR
                      v_menu_line_cd = 'CA' THEN
                     GIUTS008_PKG.copy_casualty_item(v_policy_id,par_id);
                     GIUTS008_PKG.copy_casualty_personnel(v_policy_id,par_id);
                   ELSIF v_line_cd = v_line_en OR
                      v_menu_line_cd = 'EN' THEN
                      GIUTS008_PKG.copy_engg_basic(v_policy_id,par_id);
                      GIUTS008_PKG.copy_location(v_policy_id,par_id);
                      GIUTS008_PKG.copy_principal(v_policy_id,par_id);
                   ELSIF v_line_cd = v_line_fi OR
                      v_menu_line_cd = 'FI' THEN
                      GIUTS008_PKG.copy_fire(v_policy_id,par_id);
                     ELSIF v_line_cd = v_line_mc OR
                      v_menu_line_cd = 'MC' THEN
                      GIUTS008_PKG.copy_vehicle(v_policy_id,par_id);
                      GIUTS008_PKG.copy_mcacc(v_policy_id,par_id);
                   ELSIF v_line_cd = v_line_su THEN
                      GIUTS008_PKG.copy_bond_basic(v_policy_id,par_id);
                      GIUTS008_PKG.copy_cosigntry(v_policy_id,par_id);
                   ELSIF v_line_cd IN (v_line_mh,
                        v_line_mn,v_line_av) OR v_menu_line_cd IN 
                        ('MH','MN','AV')THEN
                      GIUTS008_PKG.copy_aviation_cargo_hull(v_policy_id,v_line_cd,v_subline_cd,v_iss_cd,v_issue_yy,v_pol_seq_no,par_id,par_type,p_renew_no,p_user);
                   END IF;
                    GIUTS008_PKG.copy_deductibles(v_policy_id,par_id);
                    GIUTS008_PKG.copy_grouped_items(v_policy_id,par_id);  
                    GIUTS008_PKG.copy_pictures(v_policy_id, v_item_no,par_id);
                   IF v_open_flag = 'Y' AND (
                        NVL(v_menu_line_cd,v_line_cd) != 'MN')THEN 
                      GIUTS008_PKG.copy_open_liab(v_policy_id,par_id);
                      GIUTS008_PKG.copy_open_peril(v_policy_id,par_id);
                   END IF;
                END IF;
                
                GIUTS008_PKG.copy_orig_invoice(v_policy_id,par_id);
                GIUTS008_PKG.copy_orig_invperl(v_policy_id,par_id);
                GIUTS008_PKG.copy_orig_inv_tax(v_policy_id,par_id);
                GIUTS008_PKG.copy_orig_itmperil(v_policy_id,par_id);
                GIUTS008_PKG.copy_co_ins(v_policy_id,par_id, p_user); 
                
                IF v_item_exists = 'N' THEN        
                     GIUTS008_PKG.copy_invoice_pack(v_policy_id,par_id);
                END IF;
                
                GIUTS008_PKG.update_all_tables(p_iss_cd,par_id,p_nbt_endt_iss_cd);
                
               FOR rec IN (SELECT 'X'
                          FROM gipi_witmperl
                         WHERE par_id = par_id)
                LOOP
                  IF v_open_flag = 'N' THEN
                     IF par_type = 'P' THEN             
                        create_winvoice(0, 0 , 0, par_id, p_nbt_line_cd, p_nbt_iss_cd);            
                        cr_bill_dist.get_tsi(par_id);            
                     END IF;
                  ELSE
                     UPDATE gipi_parlist
                        SET par_status = 6
                      WHERE par_id = par_id;
                  END IF;
                  EXIT;
                END LOOP;    
          END;
  END;
  
  PROCEDURE copy_ves_air (p_policy_id IN gipi_ves_air.policy_id%TYPE,
                        p_par_id    IN      number)
IS
   CURSOR ves_air_cur
   IS
      SELECT vessel_cd, vescon, voy_limit, rec_flag
        FROM gipi_ves_air
       WHERE policy_id = p_policy_id;

   v_vessel_cd   gipi_ves_air.vessel_cd%TYPE;
   v_vescon      gipi_ves_air.vescon%TYPE;
   v_voy_limit   gipi_ves_air.voy_limit%TYPE;
   v_rec_flag    gipi_ves_air.rec_flag%TYPE;
BEGIN
   OPEN ves_air_cur;

   LOOP
      FETCH ves_air_cur
       INTO v_vessel_cd, v_vescon, v_voy_limit, v_rec_flag;

      EXIT WHEN ves_air_cur%NOTFOUND;

      INSERT INTO gipi_wves_air
                  (par_id, vessel_cd, vescon, voy_limit,
                   rec_flag
                  )
           VALUES (p_par_id, v_vessel_cd, v_vescon, v_voy_limit,
                   v_rec_flag
                  );
   END LOOP;

   CLOSE ves_air_cur;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      NULL;
END;
  

PROCEDURE copy_ves_accumulation (
   p_line_cd      IN   gipi_ves_accumulation.line_cd%TYPE,
   p_subline_cd   IN   gipi_ves_accumulation.subline_cd%TYPE,
   p_iss_cd       IN   gipi_ves_accumulation.iss_cd%TYPE,
   p_issue_yy     IN   gipi_ves_accumulation.issue_yy%TYPE,
   p_pol_seq_no   IN   gipi_ves_accumulation.pol_seq_no%TYPE,
   p_par_id       IN   number
)
IS
   CURSOR ves_acc_cur
   IS
      SELECT item_no, vessel_cd, eta, etd, tsi_amt, rec_flag, eff_date
        FROM gipi_ves_accumulation
       WHERE line_cd = p_line_cd
         AND subline_cd = p_subline_cd
         AND iss_cd = p_iss_cd
         AND issue_yy = p_issue_yy
         AND pol_seq_no = p_pol_seq_no;

   v_item_no     gipi_ves_accumulation.item_no%TYPE;
   v_vessel_cd   gipi_ves_accumulation.vessel_cd%TYPE;
   v_eta         gipi_ves_accumulation.eta%TYPE;
   v_etd         gipi_ves_accumulation.etd%TYPE;
   v_tsi_amt     gipi_ves_accumulation.tsi_amt%TYPE;
   v_rec_flag    gipi_ves_accumulation.rec_flag%TYPE;
   v_eff_date    gipi_ves_accumulation.eff_date%TYPE;
BEGIN
   OPEN ves_acc_cur;

   LOOP
      FETCH ves_acc_cur
       INTO v_item_no, v_vessel_cd, v_eta, v_etd, v_tsi_amt, v_rec_flag,
            v_eff_date;

      EXIT WHEN ves_acc_cur%NOTFOUND;

      INSERT INTO gipi_wves_accumulation
                  (par_id, item_no, vessel_cd, eta,
                   etd, tsi_amt, rec_flag, eff_date
                  )
           VALUES (p_par_id, v_item_no, v_vessel_cd, SYSDATE,
                   (SYSDATE + 365
                   ), v_tsi_amt, v_rec_flag, v_eff_date
                  );
   END LOOP;

   CLOSE ves_acc_cur;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      NULL;
END;


PROCEDURE copy_ves_accumulation_pack (
   p_line_cd      IN   gipi_ves_accumulation.line_cd%TYPE,
   p_subline_cd   IN   gipi_ves_accumulation.subline_cd%TYPE,
   p_iss_cd       IN   gipi_ves_accumulation.iss_cd%TYPE,
   p_issue_yy     IN   gipi_ves_accumulation.issue_yy%TYPE,
   p_pol_seq_no   IN   gipi_ves_accumulation.pol_seq_no%TYPE,
   p_item_no      IN   gipi_item.item_no%TYPE,
   p_par_id       IN   number
)
IS
   CURSOR ves_acc_cur
   IS
      SELECT item_no, vessel_cd, eta, etd, tsi_amt, rec_flag, eff_date
        FROM gipi_ves_accumulation
       WHERE line_cd = p_line_cd
         AND subline_cd = p_subline_cd
         AND iss_cd = p_iss_cd
         AND issue_yy = p_issue_yy
         AND pol_seq_no = p_pol_seq_no
         AND item_no = p_item_no;

   v_item_no     gipi_ves_accumulation.item_no%TYPE;
   v_vessel_cd   gipi_ves_accumulation.vessel_cd%TYPE;
   v_eta         gipi_ves_accumulation.eta%TYPE;
   v_etd         gipi_ves_accumulation.etd%TYPE;
   v_tsi_amt     gipi_ves_accumulation.tsi_amt%TYPE;
   v_rec_flag    gipi_ves_accumulation.rec_flag%TYPE;
   v_eff_date    gipi_ves_accumulation.eff_date%TYPE;
BEGIN
   OPEN ves_acc_cur;

   LOOP
      FETCH ves_acc_cur
       INTO v_item_no, v_vessel_cd, v_eta, v_etd, v_tsi_amt, v_rec_flag,
            v_eff_date;

      EXIT WHEN ves_acc_cur%NOTFOUND;

      INSERT INTO gipi_wves_accumulation
                  (par_id, item_no, vessel_cd, eta,
                   etd, tsi_amt, rec_flag, eff_date
                  )
           VALUES (p_par_id, v_item_no, v_vessel_cd, SYSDATE,
                   (SYSDATE + 365
                   ), v_tsi_amt, v_rec_flag, v_eff_date
                  );
   END LOOP;

   CLOSE ves_acc_cur;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      NULL;
END;


FUNCTION get_copypolicy_id(p_line_cd            varchar2,
                           p_subline_cd         varchar2,
                           p_iss_cd             varchar2,
                           p_issue_yy           number,
                           p_pol_seq_no         number,
                           p_renew_no           number)
   RETURN number
        IS
            v_policy_id     number;
  BEGIN
       FOR i IN(SELECT a.policy_id
                  FROM gipi_polbasic a
                 WHERE a.line_cd = p_line_cd
                   AND a.subline_cd = p_subline_cd
                   AND a.iss_cd = p_iss_cd
                   AND a.issue_yy = p_issue_yy
                   AND a.pol_seq_no = p_pol_seq_no
                   AND a.renew_no = p_renew_no)
       LOOP
            v_policy_id     := i.policy_id;
       END LOOP;
     RETURN v_policy_id;
  END;


FUNCTION main_query1(p_policy_id           IN          number,
                     p_nbt_line_cd         IN          varchar2,
                     p_nbt_subline_cd      IN          varchar2,
                     p_nbt_endt_seq_no     IN          number,
                     p_line_cd             IN          varchar2,
                     p_iss_cd              IN          varchar2,
                     p_issue_yy            IN          number,
                     p_renew_no            IN          number,
                     p_nbt_iss_cd          IN          varchar2,
                     p_nbt_issue_yy        IN          number,
                     p_nbt_pol_seq_no      IN          number,
                     p_nbt_renew_no        IN          number,
                     p_nbt_endt_iss_cd     IN          varchar2,
                     p_nbt_endt_yy         IN          number,
                     p_user                IN          varchar2)
        RETURN main_query_tab PIPELINED        
        IS 
         v_open_flag             varchar2(100);
         main_quer main_query_type;
         
      BEGIN
          FOR FLAG IN(SELECT op_flag
                                FROM giis_subline
                               WHERE line_cd     = p_nbt_line_cd
                                 AND subline_cd  = p_nbt_subline_cd) 
                  LOOP
                    v_open_flag := flag.op_flag;
                    EXIT;
                  END LOOP;
          
          DECLARE
                    --COUNTER                     NUMBER(10);
                    v_policy_id                 gipi_polbasic.policy_id%TYPE;
                    v_pol_flag                  gipi_polbasic.pol_flag%TYPE;
                    v_line_cd                   gipi_polbasic.line_cd%TYPE;
                    v_subline_cd                gipi_polbasic.subline_cd%TYPE; 
                    v_iss_cd                    gipi_polbasic.iss_cd%TYPE;
                    v_issue_yy                  gipi_polbasic.issue_yy%TYPE;
                    v_pol_seq_no                gipi_polbasic.pol_seq_no%TYPE;
                    v_renew_no                  gipi_polbasic.renew_no%TYPE;
                    v_count                     NUMBER(10);
                    v_pack_pol_flag             giis_line.pack_pol_flag%TYPE;
                    v_pack_line_cd              gipi_item.pack_line_cd%TYPE;
                    v_pack_subline_cd           gipi_item.pack_subline_cd%TYPE;
                    v_item_grp                  gipi_item.item_grp%TYPE;
                    v_item_no                   gipi_item.item_no%TYPE;
                    v_item_exists               VARCHAR2(1) := 'N';
                    v_iss_cd_ri                 VARCHAR2(10);
                    par_type                    varchar2(100);
                    par_id                      number(10);
                    v_message                   varchar2(500);
                    v_message2                  varchar2(500);
                    v_message3                  varchar2(500);
                    v_par_seq_no                number(10);
                    v_quote_seq_no              number(10);
                    v_menu_line_cd              varchar2(100);
                    v_long                      varchar2(2000);
                    v_subline_mop               varchar2(100);
                    v_line_ac                   varchar2(100);
                    v_line_av                   varchar2(100);
                    v_line_en                   varchar2(100);
                    v_line_mc                   varchar2(100);
                    v_line_fi                   varchar2(100);
                    v_line_ca                   varchar2(100);
                    v_line_mh                   varchar2(100);
                    v_line_mn                   varchar2(100);
                    v_line_su                   varchar2(100);
                    r_par_seq_no                number(10);
                    r_quote_seq_no              number(10);
                    
                    
                    
                    CURSOR cur_flag IS
                    SELECT pack_line_cd,pack_subline_cd,item_grp,item_no
                      FROM gipi_item
                     WHERE policy_id = p_policy_id
                     ORDER BY item_grp;
                     
                    
                      
              
          BEGIN 
          
--                        v_open_flag            :=            '';
--                        COUNTER                :=            0;
--                        v_policy_id            :=            0;
--                        v_pol_flag             :=            '';
--                        v_line_cd              :=            '';
--                        v_subline_cd           :=            '';
--                        v_iss_cd               :=            '';
--                        v_issue_yy             :=            0;
--                        v_pol_seq_no           :=            0;
--                        v_renew_no             :=            0;
--                        v_count                :=            0;
--                        v_pack_pol_flag        :=            '';
--                        v_pack_line_cd         :=            '';
--                        v_pack_subline_cd      :=            '';
--                        v_item_grp             :=            0;
--                        v_item_no              :=            0;
--                        v_item_exists          :=            '';
--                        v_iss_cd_ri            :=            '';
--                        par_type               :=            '';
--                        par_id                 :=            0;
--                        v_message              :=            '';
--                        v_message2             :=            '';
--                        v_message3             :=            '';
--                        v_par_seq_no           :=            0;
--                        v_quote_seq_no         :=            0;
--                        v_menu_line_cd         :=            '';
--                        v_long                 :=            '';
--                        v_subline_mop          :=            '';
--                        v_line_ac              :=            '';
--                        v_line_av              :=            '';
--                        v_line_en              :=            '';
--                        v_line_mc              :=            '';
--                        v_line_fi              :=            '';
--                        v_line_ca              :=            '';
--                        v_line_mh              :=            '';
--                        v_line_mn              :=            '';
--                        v_line_su              :=            '';
--                        r_par_seq_no           :=            0;
--                        r_quote_seq_no         :=            0;

                        par_type := GIUTS008_PKG.get_par_type(p_policy_id);
--                        
                      SELECT param_value_v
                        INTO v_line_ac
                        FROM giis_parameters
                       WHERE param_name = 'LINE_CODE_AC';
                           
                      SELECT param_value_v
                        INTO v_line_av
                        FROM giis_parameters
                       WHERE param_name = 'LINE_CODE_AV';

                      SELECT param_value_v
                        INTO v_line_en
                        FROM giis_parameters
                       WHERE param_name = 'LINE_CODE_EN';

                      SELECT param_value_v
                        INTO v_line_mc
                        FROM giis_parameters
                       WHERE param_name = 'LINE_CODE_MC';

                      SELECT param_value_v
                        INTO v_line_fi
                        FROM giis_parameters
                       WHERE param_name = 'LINE_CODE_FI';

                      SELECT param_value_v
                        INTO v_line_ca
                        FROM giis_parameters
                       WHERE param_name = 'LINE_CODE_CA';

                      SELECT param_value_v
                        INTO v_line_mh
                        FROM giis_parameters
                       WHERE param_name = 'LINE_CODE_MH';

                      SELECT param_value_v
                        INTO v_line_mn
                        FROM giis_parameters
                       WHERE param_name = 'LINE_CODE_MN';

                      SELECT param_value_v
                        INTO v_line_su
                        FROM giis_parameters
                       WHERE param_name = 'LINE_CODE_SU';

                      SELECT param_value_v
                        INTO v_subline_mop
                        FROM giis_parameters
                       WHERE param_name = 'SUBLINE_MN_MOP';    
                       
                       v_policy_id := p_policy_id;
                       
                    SELECT parlist_par_id_s.nextval
                      INTO par_id
                      FROM DUAL;
                
                IF p_nbt_endt_seq_no > 0 THEN
                   GIUTS008_PKG.check_endt(p_line_cd,p_nbt_subline_cd,p_iss_cd,p_issue_yy,p_nbt_pol_seq_no,p_renew_no,p_nbt_endt_iss_cd,p_nbt_endt_yy,p_nbt_endt_seq_no);
                    SELECT policy_id, pol_flag, line_cd, subline_cd, iss_cd,
                           issue_yy, pol_seq_no, renew_no
                      INTO v_policy_id, v_pol_flag, v_line_cd, v_subline_cd, v_iss_cd,
                           v_issue_yy, v_pol_seq_no, v_renew_no
                      FROM gipi_polbasic
                     WHERE line_cd = p_nbt_line_cd
                       AND subline_cd = p_nbt_subline_cd
                       AND iss_cd = p_nbt_iss_cd
                       AND issue_yy = p_nbt_issue_yy
                       AND pol_seq_no = p_nbt_pol_seq_no
                       AND renew_no = p_nbt_renew_no
                       AND endt_iss_cd = p_nbt_endt_iss_cd
                       AND endt_yy = p_nbt_endt_yy
                       AND endt_seq_no = p_nbt_endt_seq_no;
                ELSE 
                  GIUTS008_PKG.check_policy(p_nbt_line_cd,p_nbt_subline_cd,p_nbt_iss_cd,p_nbt_issue_yy,p_nbt_pol_seq_no,p_nbt_renew_no);
                    SELECT policy_id, pol_flag, line_cd, subline_cd, iss_cd,
                           issue_yy, pol_seq_no, renew_no
                      INTO v_policy_id, v_pol_flag, v_line_cd, v_subline_cd, v_iss_cd,
                           v_issue_yy, v_pol_seq_no, v_renew_no
                      FROM gipi_polbasic
                     WHERE line_cd = p_nbt_line_cd
                       AND subline_cd = p_nbt_subline_cd
                       AND iss_cd = p_nbt_iss_cd
                       AND issue_yy = p_nbt_issue_yy
                       AND pol_seq_no = p_nbt_pol_seq_no
                       AND renew_no = p_nbt_renew_no
                       AND endt_seq_no = 0;
               END IF;
                
                    main_quer.open_flag                 :=      nvl(v_open_flag,'');
                    --main_quer.COUNTER                   :=      nvl(COUNTER,0);
                    main_quer.policy_id                 :=      nvl(v_policy_id,0);
                    main_quer.pol_flag                  :=      nvl(v_pol_flag,'');
                    main_quer.line_cd                   :=      nvl(v_line_cd,'');
                    main_quer.subline_cd                :=      nvl(v_subline_cd,'');
                    main_quer.iss_cd                    :=      nvl(v_iss_cd,'');
                    main_quer.issue_yy                  :=      nvl(v_issue_yy,'');
                    main_quer.pol_seq_no                :=      nvl(v_pol_seq_no,0);
                    main_quer.renew_no                  :=      nvl(v_renew_no,0);
                    main_quer.count                     :=      nvl(v_count,0);
                    main_quer.pack_pol_flag             :=      nvl(v_pack_pol_flag,'');
                    main_quer.pack_line_cd              :=      nvl(v_pack_line_cd,'');
                    main_quer.pack_subline_cd           :=      nvl(v_pack_subline_cd,'');
                    main_quer.item_grp                  :=      nvl(v_item_grp,0);
                    main_quer.item_no                   :=      nvl(v_item_no,0);
                    main_quer.item_exist                :=      nvl(v_item_exists,'');
                    main_quer.iss_cd_ri                 :=      nvl(v_iss_cd_ri,'');
                    main_quer.par_type                  :=      nvl(par_type,'');
                    main_quer.par_id                    :=      nvl(par_id,0);
                    main_quer.message                   :=      nvl(v_message,'');
                    main_quer.message2                  :=      nvl(v_message2,'');
                    main_quer.message3                  :=      nvl(v_message3,'');
                    main_quer.par_seq_no                :=      nvl(v_par_seq_no,0);
                    main_quer.quote_seq_no              :=      nvl(v_quote_seq_no,0);
                    main_quer.menu_line_cd              :=      nvl(v_menu_line_cd,'');
                    main_quer.long1                     :=      nvl(v_long,'');
                    main_quer.subline_mop               :=      nvl(v_subline_mop,'');
                    main_quer.line_ac                   :=      nvl(v_line_ac,'');
                    main_quer.line_av                   :=      nvl(v_line_av,'');
                    main_quer.line_en                   :=      nvl(v_line_en,'');
                    main_quer.line_mc                   :=      nvl(v_line_mc,'');
                    main_quer.line_fi                   :=      nvl(v_line_fi,'');
                    main_quer.line_ca                   :=      nvl(v_line_ca,'');
                    main_quer.line_mh                   :=      nvl(v_line_mh,'');
                    main_quer.line_mn                   :=      nvl(v_line_mn,'');
                    main_quer.line_su                   :=      nvl(v_line_su,'');
                    main_quer.r_par_seq_no              :=      nvl(r_par_seq_no,0);
                    main_quer.r_quote_seq_no            :=      nvl(r_quote_seq_no,0);
          END;
          
           
           PIPE ROW(main_quer);
          RETURN;
      END;
      

FUNCTION main_query2(p_par_id       number)
        RETURN main_query_tab PIPELINED        
        IS 
               
        main_quer                   main_query_type;
        r_par_seq_no                NUMBER;
        r_quote_seq_no              NUMBER;
        v_iss_cd_ri                 varchar2(100); 
        
      BEGIN
           
        BEGIN
          FOR hh IN(SELECT DISTINCT par_seq_no,quote_seq_no
                           FROM gipi_parlist
                          WHERE par_id = par_id)
               LOOP
                    r_par_seq_no        := nvl(hh.par_seq_no,0);
                    r_quote_seq_no      := nvl(hh.quote_seq_no,0);
               END LOOP;
                
                
                 
                SELECT giisp.v('ISS_CD_RI') 
                  INTO v_iss_cd_ri
                  FROM DUAL;
          END;
          
            
            main_quer.iss_cd_ri                 :=      v_iss_cd_ri;
            
            main_quer.par_seq_no              :=      r_par_seq_no;
            main_quer.quote_seq_no            :=      r_quote_seq_no;
           PIPE ROW(main_quer);
          RETURN;
      END;      
 
      
      FUNCTION main_query3(
                     p_nbt_line_cd         IN          varchar2
                     )
        RETURN main_query_tab PIPELINED        
        IS 
        
        main_quer                   main_query_type;
        v_pack_pol_flag             varchar2(100);
        v_menu_line_cd              varchar2(100);
        COUNTER                     number;
      BEGIN
      
        
        BEGIN
          SELECT pack_pol_flag
                  INTO v_pack_pol_flag
                  FROM giis_line
                 WHERE line_cd = p_nbt_line_cd;
                COUNTER := 0;
                FOR A IN (SELECT menu_line_cd
                            FROM giis_line
                           WHERE line_cd = p_nbt_line_cd)
                LOOP
                  v_menu_line_cd := a.menu_line_cd;
                  EXIT;
                END LOOP; 
          END;
          
            
            main_quer.pack_pol_flag             :=      v_pack_pol_flag;
            main_quer.menu_line_cd              :=      v_menu_line_cd;            
           PIPE ROW(main_quer);
          RETURN;
      END;     



PROCEDURE main_query4(p_par_id             number,
                      p_nbt_line_cd         varchar2,
                      p_nbt_iss_cd         varchar2,
                      v_open_flag           varchar2,
                      par_type              varchar2)
        --RETURN main_query_tab PIPELINED        
        IS 
                
        main_quer                   main_query_type;
        v_pack_pol_flag             varchar2(100);
        v_menu_line_cd              varchar2(100);
        COUNTER                     number;
        
            
                CURSOR cur_x IS
                SELECT 'X'
                  FROM gipi_witmperl
                 WHERE par_id = p_par_id;
      BEGIN
                 
          FOR c1 IN cur_x            
          LOOP
             IF v_open_flag = 'N' THEN
             
                     IF par_type = 'P' THEN             
                        create_winvoice(0, 0 , 0, p_par_id, p_nbt_line_cd, p_nbt_iss_cd);            
                        cr_bill_dist.get_tsi(p_par_id);                                 
                     END IF;
                     
             ELSE
                     UPDATE gipi_parlist
                        SET par_status = 6
                      WHERE par_id = p_par_id;
             END IF;
                  
                  EXIT;
          END LOOP;
                
              
          
          -- PIPE ROW(main_quer);
          
          
          RETURN;
          
          
      END;    


FUNCTION cur_query(
                     p_policy_id                   number
                     )
        RETURN main_query_tab PIPELINED        
        IS 
        
        main_quer                   main_query_type;
        v_pack_pol_flag             varchar2(100);
        v_menu_line_cd              varchar2(100);
        COUNTER                     number;
      BEGIN
      
        
               FOR i IN(
                    SELECT pack_line_cd,pack_subline_cd,item_grp,item_no
                      FROM gipi_item
                     WHERE policy_id = p_policy_id
                     ORDER BY item_grp)
                LOOP
                  
                    main_quer.pack_line_cd                  :=      i.pack_line_cd;
                    main_quer.pack_subline_cd               :=      i.pack_subline_cd; 
                    main_quer.item_grp                      :=      i.item_grp;
                    main_quer.item_no                       :=      i.item_no; 
                  EXIT;
                END LOOP; 
          
                       
           PIPE ROW(main_quer);
          RETURN;
      END;
      
      
FUNCTION get_validation_details(p_policy_id           IN          number,
                     p_nbt_line_cd         IN          varchar2,
                     p_nbt_subline_cd      IN          varchar2,
                     p_nbt_endt_seq_no     IN          number,
                     p_line_cd             IN          varchar2,
                     p_iss_cd              IN          varchar2,
                     p_issue_yy            IN          number,
                     p_renew_no            IN          number,
                     p_nbt_iss_cd          IN          varchar2,
                     p_nbt_issue_yy        IN          number,
                     p_nbt_pol_seq_no      IN          number,
                     p_nbt_renew_no        IN          number,
                     p_nbt_endt_iss_cd     IN          varchar2,
                     p_nbt_endt_yy         IN          number,
                     p_user                IN          varchar2)
        RETURN main_query_tab PIPELINED 
         IS 
         v_open_flag             varchar2(100);
         main_quer main_query_type;
        BEGIN
            DECLARE
                    v_policy_id                 gipi_polbasic.policy_id%TYPE;
                    v_pol_flag                  gipi_polbasic.pol_flag%TYPE;
                    v_line_cd                   gipi_polbasic.line_cd%TYPE;
                    v_subline_cd                gipi_polbasic.subline_cd%TYPE; 
                    v_iss_cd                    gipi_polbasic.iss_cd%TYPE;
                    v_issue_yy                  gipi_polbasic.issue_yy%TYPE;
                    v_pol_seq_no                gipi_polbasic.pol_seq_no%TYPE;
                    v_renew_no                  gipi_polbasic.renew_no%TYPE;
                    v_count                     NUMBER(10);
                    v_pack_pol_flag             giis_line.pack_pol_flag%TYPE;
                    v_pack_line_cd              gipi_item.pack_line_cd%TYPE;
                    v_pack_subline_cd           gipi_item.pack_subline_cd%TYPE;
                    v_item_grp                  gipi_item.item_grp%TYPE;
                    v_item_no                   gipi_item.item_no%TYPE;
                    v_item_exists               VARCHAR2(1) := 'N';
                    v_iss_cd_ri                 VARCHAR2(10);
                    par_type                    varchar2(100);
                    par_id                      number(10);
                    v_message                   varchar2(500);
                    v_message2                  varchar2(500);
                    v_message3                  varchar2(500);
                    v_par_seq_no                number(10);
                    v_quote_seq_no              number(10);
                    v_menu_line_cd              varchar2(100);
                    v_long                      varchar2(2000);
                    v_subline_mop               varchar2(100);
                    v_line_ac                   varchar2(100);
                    v_line_av                   varchar2(100);
                    v_line_en                   varchar2(100);
                    v_line_mc                   varchar2(100);
                    v_line_fi                   varchar2(100);
                    v_line_ca                   varchar2(100);
                    v_line_mh                   varchar2(100);
                    v_line_mn                   varchar2(100);
                    v_line_su                   varchar2(100);
                    r_par_seq_no                number(10);
                    r_quote_seq_no              number(10);
           BEGIN 
             FOR i IN(SELECT policy_id, pol_flag, line_cd, subline_cd, iss_cd,
                           issue_yy, pol_seq_no, renew_no
                      INTO v_policy_id, v_pol_flag, v_line_cd, v_subline_cd, v_iss_cd,
                           v_issue_yy, v_pol_seq_no, v_renew_no
                      FROM gipi_polbasic
                     WHERE line_cd = p_nbt_line_cd
                       AND subline_cd = p_nbt_subline_cd
                       AND iss_cd = p_nbt_iss_cd
                       AND issue_yy = p_nbt_issue_yy
                       AND pol_seq_no = p_nbt_pol_seq_no
                       AND renew_no = p_nbt_renew_no
                       AND endt_iss_cd = p_nbt_endt_iss_cd
                       AND endt_yy = p_nbt_endt_yy
                       AND endt_seq_no = p_nbt_endt_seq_no)
            LOOP
                main_quer.open_flag                 :=      nvl(v_open_flag,'');
                    --main_quer.COUNTER                   :=      nvl(COUNTER,0);
                    main_quer.policy_id                 :=      nvl(v_policy_id,0);
                    main_quer.pol_flag                  :=      nvl(v_pol_flag,'');
                    main_quer.line_cd                   :=      nvl(v_line_cd,'');
                    main_quer.subline_cd                :=      nvl(v_subline_cd,'');
                    main_quer.iss_cd                    :=      nvl(v_iss_cd,'');
                    main_quer.issue_yy                  :=      nvl(v_issue_yy,'');
                    main_quer.pol_seq_no                :=      nvl(v_pol_seq_no,0);
                    main_quer.renew_no                  :=      nvl(v_renew_no,0);
                    main_quer.count                     :=      nvl(v_count,0);
                    main_quer.pack_pol_flag             :=      nvl(v_pack_pol_flag,'');
                    main_quer.pack_line_cd              :=      nvl(v_pack_line_cd,'');
                    main_quer.pack_subline_cd           :=      nvl(v_pack_subline_cd,'');
                    main_quer.item_grp                  :=      nvl(v_item_grp,0);
                    main_quer.item_no                   :=      nvl(v_item_no,0);
                    main_quer.item_exist                :=      nvl(v_item_exists,'');
                    main_quer.iss_cd_ri                 :=      nvl(v_iss_cd_ri,'');
                    main_quer.par_type                  :=      nvl(par_type,'');
                    main_quer.par_id                    :=      nvl(par_id,0);
                    main_quer.message                   :=      nvl(v_message,'');
                    main_quer.message2                  :=      nvl(v_message2,'');
                    main_quer.message3                  :=      nvl(v_message3,'');
                    main_quer.par_seq_no                :=      nvl(v_par_seq_no,0);
                    main_quer.quote_seq_no              :=      nvl(v_quote_seq_no,0);
                    main_quer.menu_line_cd              :=      nvl(v_menu_line_cd,'');
                    main_quer.long1                     :=      nvl(v_long,'');
                    main_quer.subline_mop               :=      nvl(v_subline_mop,'');
                    main_quer.line_ac                   :=      nvl(v_line_ac,'');
                    main_quer.line_av                   :=      nvl(v_line_av,'');
                    main_quer.line_en                   :=      nvl(v_line_en,'');
                    main_quer.line_mc                   :=      nvl(v_line_mc,'');
                    main_quer.line_fi                   :=      nvl(v_line_fi,'');
                    main_quer.line_ca                   :=      nvl(v_line_ca,'');
                    main_quer.line_mh                   :=      nvl(v_line_mh,'');
                    main_quer.line_mn                   :=      nvl(v_line_mn,'');
                    main_quer.line_su                   :=      nvl(v_line_su,'');
                    main_quer.r_par_seq_no              :=      nvl(r_par_seq_no,0);
                    main_quer.r_quote_seq_no            :=      nvl(r_quote_seq_no,0);
            END LOOP;
            
            PIPE ROW(main_quer);
          RETURN;
       END;      
    END;
    
    
FUNCTION get_validation_policy_details(p_policy_id           IN          number,
                     p_nbt_line_cd         IN          varchar2,
                     p_nbt_subline_cd      IN          varchar2,
                     p_nbt_endt_seq_no     IN          number,
                     p_line_cd             IN          varchar2,
                     p_iss_cd              IN          varchar2,
                     p_issue_yy            IN          number,
                     p_renew_no            IN          number,
                     p_nbt_iss_cd          IN          varchar2,
                     p_nbt_issue_yy        IN          number,
                     p_nbt_pol_seq_no      IN          number,
                     p_nbt_renew_no        IN          number,
                     p_nbt_endt_iss_cd     IN          varchar2,
                     p_nbt_endt_yy         IN          number,
                     p_user                IN          varchar2)
        RETURN main_query_tab PIPELINED 
         IS 
         v_open_flag             varchar2(100);
         main_quer main_query_type;
       BEGIN
            DECLARE
                    v_policy_id                 gipi_polbasic.policy_id%TYPE;
                    v_pol_flag                  gipi_polbasic.pol_flag%TYPE;
                    v_line_cd                   gipi_polbasic.line_cd%TYPE;
                    v_subline_cd                gipi_polbasic.subline_cd%TYPE; 
                    v_iss_cd                    gipi_polbasic.iss_cd%TYPE;
                    v_issue_yy                  gipi_polbasic.issue_yy%TYPE;
                    v_pol_seq_no                gipi_polbasic.pol_seq_no%TYPE;
                    v_renew_no                  gipi_polbasic.renew_no%TYPE;
                    v_count                     NUMBER(10);
                    v_pack_pol_flag             giis_line.pack_pol_flag%TYPE;
                    v_pack_line_cd              gipi_item.pack_line_cd%TYPE;
                    v_pack_subline_cd           gipi_item.pack_subline_cd%TYPE;
                    v_item_grp                  gipi_item.item_grp%TYPE;
                    v_item_no                   gipi_item.item_no%TYPE;
                    v_item_exists               VARCHAR2(1) := 'N';
                    v_iss_cd_ri                 VARCHAR2(10);
                    par_type                    varchar2(100);
                    par_id                      number(10);
                    v_message                   varchar2(500);
                    v_message2                  varchar2(500);
                    v_message3                  varchar2(500);
                    v_par_seq_no                number(10);
                    v_quote_seq_no              number(10);
                    v_menu_line_cd              varchar2(100);
                    v_long                      varchar2(2000);
                    v_subline_mop               varchar2(100);
                    v_line_ac                   varchar2(100);
                    v_line_av                   varchar2(100);
                    v_line_en                   varchar2(100);
                    v_line_mc                   varchar2(100);
                    v_line_fi                   varchar2(100);
                    v_line_ca                   varchar2(100);
                    v_line_mh                   varchar2(100);
                    v_line_mn                   varchar2(100);
                    v_line_su                   varchar2(100);
                    r_par_seq_no                number(10);
                    r_quote_seq_no              number(10);
           BEGIN
             FOR i IN(SELECT policy_id, pol_flag, line_cd, subline_cd, iss_cd,
                           issue_yy, pol_seq_no, renew_no
                      INTO v_policy_id, v_pol_flag, v_line_cd, v_subline_cd, v_iss_cd,
                           v_issue_yy, v_pol_seq_no, v_renew_no
                      FROM gipi_polbasic
                     WHERE line_cd = p_nbt_line_cd
                       AND subline_cd = p_nbt_subline_cd
                       AND iss_cd = p_nbt_iss_cd
                       AND issue_yy = p_nbt_issue_yy
                       AND pol_seq_no = p_nbt_pol_seq_no
                       AND renew_no = p_nbt_renew_no
                       AND endt_seq_no = 0)
            LOOP
                main_quer.open_flag                 :=      nvl(v_open_flag,'');
                    --main_quer.COUNTER                   :=      nvl(COUNTER,0);
                    main_quer.policy_id                 :=      nvl(v_policy_id,0);
                    main_quer.pol_flag                  :=      nvl(v_pol_flag,'');
                    main_quer.line_cd                   :=      nvl(v_line_cd,'');
                    main_quer.subline_cd                :=      nvl(v_subline_cd,'');
                    main_quer.iss_cd                    :=      nvl(v_iss_cd,'');
                    main_quer.issue_yy                  :=      nvl(v_issue_yy,'');
                    main_quer.pol_seq_no                :=      nvl(v_pol_seq_no,0);
                    main_quer.renew_no                  :=      nvl(v_renew_no,0);
                    main_quer.count                     :=      nvl(v_count,0);
                    main_quer.pack_pol_flag             :=      nvl(v_pack_pol_flag,'');
                    main_quer.pack_line_cd              :=      nvl(v_pack_line_cd,'');
                    main_quer.pack_subline_cd           :=      nvl(v_pack_subline_cd,'');
                    main_quer.item_grp                  :=      nvl(v_item_grp,0);
                    main_quer.item_no                   :=      nvl(v_item_no,0);
                    main_quer.item_exist                :=      nvl(v_item_exists,'');
                    main_quer.iss_cd_ri                 :=      nvl(v_iss_cd_ri,'');
                    main_quer.par_type                  :=      nvl(par_type,'');
                    main_quer.par_id                    :=      nvl(par_id,0);
                    main_quer.message                   :=      nvl(v_message,'');
                    main_quer.message2                  :=      nvl(v_message2,'');
                    main_quer.message3                  :=      nvl(v_message3,'');
                    main_quer.par_seq_no                :=      nvl(v_par_seq_no,0);
                    main_quer.quote_seq_no              :=      nvl(v_quote_seq_no,0);
                    main_quer.menu_line_cd              :=      nvl(v_menu_line_cd,'');
                    main_quer.long1                     :=      nvl(v_long,'');
                    main_quer.subline_mop               :=      nvl(v_subline_mop,'');
                    main_quer.line_ac                   :=      nvl(v_line_ac,'');
                    main_quer.line_av                   :=      nvl(v_line_av,'');
                    main_quer.line_en                   :=      nvl(v_line_en,'');
                    main_quer.line_mc                   :=      nvl(v_line_mc,'');
                    main_quer.line_fi                   :=      nvl(v_line_fi,'');
                    main_quer.line_ca                   :=      nvl(v_line_ca,'');
                    main_quer.line_mh                   :=      nvl(v_line_mh,'');
                    main_quer.line_mn                   :=      nvl(v_line_mn,'');
                    main_quer.line_su                   :=      nvl(v_line_su,'');
                    main_quer.r_par_seq_no              :=      nvl(r_par_seq_no,0);
                    main_quer.r_quote_seq_no            :=      nvl(r_quote_seq_no,0);
            END LOOP;
            
            PIPE ROW(main_quer);
          RETURN;
         END;
       END;
       
    /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : May 5, 2013
    **  Reference By  : GIUTS008 - Copy Policy / Endorsement to PAR
    **  Description   : Retrieve necessary info in copying policy
    */ 
       
     PROCEDURE initialize_copy_variables
    (p_nbt_line_cd      IN      GIPI_POLBASIC.line_cd%TYPE,
     p_nbt_subline_cd   IN      GIPI_POLBASIC.subline_cd%TYPE,
     p_menu_line_cd     OUT     GIIS_LINE.menu_line_cd%TYPE,
     p_line_ac          OUT     GIIS_PARAMETERS.param_value_v%TYPE,
     p_line_av          OUT     GIIS_PARAMETERS.param_value_v%TYPE,
     p_line_en          OUT     GIIS_PARAMETERS.param_value_v%TYPE,
     p_line_mc          OUT     GIIS_PARAMETERS.param_value_v%TYPE,
     p_line_fi          OUT     GIIS_PARAMETERS.param_value_v%TYPE,
     p_line_mh          OUT     GIIS_PARAMETERS.param_value_v%TYPE,
     p_line_mn          OUT     GIIS_PARAMETERS.param_value_v%TYPE,
     p_line_su          OUT     GIIS_PARAMETERS.param_value_v%TYPE,
     p_subline_mop      OUT     GIIS_PARAMETERS.param_value_v%TYPE,
     p_iss_cd_ri        OUT     GIIS_PARAMETERS.param_value_v%TYPE,
     p_open_flag        OUT     GIIS_SUBLINE.op_flag%TYPE,
     p_pack_pol_flag    OUT     GIIS_LINE.pack_pol_flag%TYPE) IS
     
    BEGIN
        BEGIN
            SELECT param_value_v
              INTO p_line_ac
              FROM GIIS_PARAMETERS
             WHERE param_name = 'LINE_CODE_AC';
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                p_line_ac := 'AC';
        END;
        
        BEGIN
            SELECT param_value_v
              INTO p_line_av
              FROM GIIS_PARAMETERS
             WHERE param_name = 'LINE_CODE_AV';
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                p_line_av := 'AV';
        END;
        
        BEGIN
            SELECT param_value_v
              INTO p_line_en
              FROM GIIS_PARAMETERS
             WHERE param_name = 'LINE_CODE_EN';
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                p_line_en := 'EN';
        END;
        
        BEGIN
            SELECT param_value_v
              INTO p_line_mc
              FROM GIIS_PARAMETERS
             WHERE param_name = 'LINE_CODE_MC';
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                p_line_mc := 'MC';
        END;
        
        BEGIN
            SELECT param_value_v
              INTO p_line_fi
              FROM GIIS_PARAMETERS
             WHERE param_name = 'LINE_CODE_FI';
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                p_line_fi := 'FI';
        END;
        
        BEGIN
            SELECT param_value_v
              INTO p_line_mh
              FROM GIIS_PARAMETERS
             WHERE param_name = 'LINE_CODE_MH';
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                p_line_mh := 'MH';
        END;
        
        BEGIN
            SELECT param_value_v
              INTO p_line_mn
              FROM GIIS_PARAMETERS
             WHERE param_name = 'LINE_CODE_MN';
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                p_line_mn := 'MN';
        END;
        
        BEGIN
            SELECT param_value_v
              INTO p_line_su
              FROM GIIS_PARAMETERS
             WHERE param_name = 'LINE_CODE_SU';
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                p_line_su := 'SU';
        END;
        
        BEGIN
            SELECT param_value_v
              INTO p_subline_mop
              FROM GIIS_PARAMETERS
             WHERE param_name = 'SUBLINE_MN_MOP';
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                p_subline_mop := '';
        END;
        
        BEGIN
            SELECT param_value_v
              INTO p_iss_cd_ri
              FROM GIIS_PARAMETERS
             WHERE param_name = 'ISS_CD_RI';
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                p_iss_cd_ri := '';
        END;
        
        p_open_flag     := 'N'; 
        p_pack_pol_flag := 'N';
        
        FOR i IN (SELECT pack_pol_flag, 
                         NVL(menu_line_cd, line_cd) menu_line_cd
                    FROM GIIS_LINE
                   WHERE line_cd = p_nbt_line_cd)
        LOOP
            p_pack_pol_flag := i.pack_pol_flag;
            p_menu_line_cd  := i.menu_line_cd;
            EXIT;
        END LOOP;
        
        FOR FLAG IN(SELECT op_flag
                    FROM GIIS_SUBLINE
                   WHERE line_cd     = p_nbt_line_cd
                     AND subline_cd  = p_nbt_subline_cd) 
        LOOP
            p_open_flag := flag.op_flag;
            EXIT;
        END LOOP;
        
    END initialize_copy_variables;
    
    /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : May 5, 2013
    **  Reference By  : GIUTS008 - Copy Policy / Endorsement to PAR
    **  Description   : Check if policy is existing and its status
    */ 
      
    PROCEDURE check_existing_policy
    (p_line_cd          IN OUT  GIPI_POLBASIC.line_cd%TYPE,
     p_subline_cd       IN OUT  GIPI_POLBASIC.subline_cd%TYPE,
     p_iss_cd           IN OUT  GIPI_POLBASIC.iss_cd%TYPE,
     p_issue_yy         IN OUT  GIPI_POLBASIC.issue_yy%TYPE,
     p_pol_seq_no       IN OUT  GIPI_POLBASIC.pol_seq_no%TYPE,
     p_renew_no         IN OUT  GIPI_POLBASIC.renew_no%TYPE,
     p_nbt_endt_iss_cd  IN      GIPI_POLBASIC.endt_iss_cd%TYPE,
     p_nbt_endt_yy      IN      GIPI_POLBASIC.endt_yy%TYPE,
     p_nbt_endt_seq_no  IN      GIPI_POLBASIC.endt_seq_no%TYPE,
     p_policy_id        OUT     GIPI_POLBASIC.policy_id%TYPE,
     p_pol_flag         OUT     GIPI_POLBASIC.pol_flag%TYPE) IS
     
    BEGIN

        IF p_nbt_endt_seq_no > 0 THEN
           GIUTS008_PKG.check_endt(p_line_cd,p_subline_cd,p_iss_cd,p_issue_yy,p_pol_seq_no,p_renew_no,p_nbt_endt_iss_cd,p_nbt_endt_yy,p_nbt_endt_seq_no);
           SELECT policy_id, pol_flag, line_cd, subline_cd,
                  iss_cd, issue_yy, pol_seq_no, renew_no
             INTO p_policy_id, p_pol_flag, p_line_cd, p_subline_cd,
                  p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no
             FROM GIPI_POLBASIC
            WHERE line_cd     = p_line_cd
              AND subline_cd  = p_subline_cd
              AND iss_cd      = p_iss_cd
              AND issue_yy    = p_issue_yy
              AND pol_seq_no  = p_pol_seq_no
              AND renew_no    = p_renew_no
              AND endt_iss_cd = p_nbt_endt_iss_cd
              AND endt_yy     = p_nbt_endt_yy
              AND endt_seq_no = p_nbt_endt_seq_no;
        ELSE 
           GIUTS008_PKG.check_policy(p_line_cd,p_subline_cd,p_iss_cd,p_issue_yy,p_pol_seq_no,p_renew_no);
           SELECT policy_id, pol_flag, line_cd, subline_cd,
                  iss_cd, issue_yy, pol_seq_no, renew_no
             INTO p_policy_id, p_pol_flag, p_line_cd, p_subline_cd,
                  p_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no
             FROM GIPI_POLBASIC
            WHERE line_cd     = p_line_cd
              AND subline_cd  = p_subline_cd
              AND iss_cd      = p_iss_cd
              AND issue_yy    = p_issue_yy
              AND pol_seq_no  = p_pol_seq_no
              AND renew_no    = p_renew_no
              AND endt_seq_no = 0;
        END IF;
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
          RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#I#Policy number does not exist.');

    END;
       
    /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : May 5, 2013
    **  Reference By  : GIUTS008 - Copy Policy / Endorsement to PAR
    **  Description   : Insert record in GIPI_PARLIST
    */ 
    PROCEDURE insert_into_parlist_2 
    (p_policy_id    IN   GIPI_POLBASIC.policy_id%TYPE,
     p_user_id      IN   GIPI_POLBASIC.user_id%TYPE,
     p_par_iss_cd   IN   GIPI_PARLIST.iss_cd%TYPE,                              
     p_par_id       OUT  GIPI_PARLIST.par_id%TYPE,
     p_par_type     OUT  GIPI_PARLIST.par_type%TYPE) IS
      
      v_par_id          GIPI_PARLIST.par_id%TYPE;
      v_line_cd         GIPI_PARLIST.line_cd%TYPE;  
      v_iss_cd          GIPI_PARLIST.iss_cd%TYPE;
      v_par_yy          GIPI_PARLIST.par_yy%TYPE;
      v_quote_seq_no    GIPI_PARLIST.quote_seq_no%TYPE;
      v_par_type        GIPI_PARLIST.par_type%TYPE;
      v_assd_no         GIPI_PARLIST.assd_no%TYPE;
      v_underwriter     GIPI_PARLIST.underwriter%TYPE;
      v_assign_sw       GIPI_PARLIST.assign_sw%TYPE;
      v_par_status      GIPI_PARLIST.par_status%TYPE; 
      v_address1        GIPI_PARLIST.address1%TYPE;
      v_address2        GIPI_PARLIST.address2%TYPE;
      v_address3        GIPI_PARLIST.address3%TYPE;
      v_load_tag        GIPI_PARLIST.load_tag%TYPE; 
      
    BEGIN
       BEGIN
        SELECT parlist_par_id_s.NEXTVAL
          INTO p_par_id
          FROM DUAL;            
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Cannot generate new PAR ID.');
      END;

      
      BEGIN
          SELECT p_par_id,      a.line_cd,  a.iss_cd,   TO_NUMBER(SUBSTR(TO_CHAR(SYSDATE,'MM-DD-YYYY'),9,2)),
                 0,             b.par_type, b.assd_no,  p_user_id,
                 'Y',           5,
                 b.address1,    b.address2, b.address3, 'C'
           INTO  v_par_id,      v_line_cd,  v_iss_cd,   v_par_yy,
                 v_quote_seq_no,v_par_type, v_assd_no,  v_underwriter,
                 v_assign_sw,   v_par_status, 
                 v_address1,    v_address2, v_address3, v_load_tag
           FROM GIPI_POLBASIC a, 
                GIPI_PARLIST b
          WHERE a.policy_id = p_policy_id 
            AND a.par_id    = b.par_id; 
      EXCEPTION 
          WHEN NO_DATA_FOUND THEN 
            --MESSAGE('There is no existing record.');
            NULL;
      END;
      
      BEGIN
          INSERT INTO GIPI_PARLIST
                    (par_id,line_cd,iss_cd,par_yy,
                     quote_seq_no,par_type,assd_no,underwriter,
                     assign_sw,par_status, 
                     address1, address2, address3,
                     load_tag)
             VALUES(v_par_id,v_line_cd, p_par_iss_cd,v_par_yy,
                    v_quote_seq_no,v_par_type,v_assd_no,v_underwriter,
                    v_assign_sw,v_par_status, 
                    v_address1,v_address2,v_address3,
                    v_load_tag); 
      END;
       
      FOR par in
          (SELECT b.par_type par_type
             FROM GIPI_POLBASIC a, 
                  GIPI_PARLIST b
            WHERE a.policy_id = p_policy_id
              AND a.par_id    = b.par_id) 
      LOOP
          p_par_type := par.par_type;
          EXIT;
      END LOOP;
       
    END;
    
    /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : May 5, 2013
    **  Reference By  : GIUTS008 - Copy Policy / Endorsement to PAR
    **  Description   : Insert records for Package Items
    */ 
    
    PROCEDURE copy_pack_items
    (p_policy_id         IN  GIPI_POLBASIC.policy_id%TYPE,
     p_nbt_line_cd       IN  GIPI_POLBASIC.line_cd%TYPE,
     p_nbt_subline_cd    IN  GIPI_POLBASIC.subline_cd%TYPE,
     p_nbt_iss_cd        IN  GIPI_POLBASIC.iss_cd%TYPE,
     p_nbt_issue_yy      IN  GIPI_POLBASIC.issue_yy%TYPE,
     p_nbt_pol_seq_no    IN  GIPI_POLBASIC.pol_seq_no%TYPE,
     p_nbt_renew_no      IN  GIPI_POLBASIC.renew_no%TYPE,
     p_iss_cd            IN  GIPI_POLBASIC.iss_cd%TYPE,
     p_par_id            IN  GIPI_PARLIST.par_id%TYPE,
     p_par_type          IN  GIPI_PARLIST.par_type%TYPE,   
     p_user_id           IN  GIPI_POLBASIC.user_id%TYPE,
     p_item_exists       OUT VARCHAR2) IS

    v_pack_line_cd      GIPI_ITEM.pack_line_cd%TYPE;
    v_pack_subline_cd   GIPI_ITEM.pack_subline_cd%TYPE;
    v_item_grp          GIPI_ITEM.item_grp%TYPE;
    v_item_no           GIPI_ITEM.item_no%TYPE;
    v_item_exists       VARCHAR2(1) := 'N';

    CURSOR cur_flag IS
        SELECT pack_line_cd,pack_subline_cd,item_grp,item_no
          FROM GIPI_ITEM
         WHERE policy_id = p_policy_id
         ORDER BY item_grp;
         
    BEGIN
        FOR var_flag IN cur_flag LOOP
           v_pack_line_cd := var_flag.pack_line_cd;
           v_pack_subline_cd := var_flag.pack_subline_cd;  
           v_item_grp  := var_flag.item_grp;
           v_item_no   := var_flag.item_no;
           
           giis_users_pkg.app_user := p_user_id;
           
           GIUTS008_PKG.copy_line (p_policy_id,      v_pack_line_cd,     v_pack_subline_cd, 
                                   p_nbt_iss_cd,     p_nbt_issue_yy,     p_nbt_pol_seq_no,      
                                   v_item_no,        v_item_grp,         p_nbt_line_cd,         
                                   p_nbt_subline_cd, p_par_type,         p_par_id,          
                                   p_iss_cd,         p_nbt_issue_yy,     p_nbt_pol_seq_no,   
                                   p_nbt_renew_no );
           
           v_item_exists := 'Y';
        END LOOP;
        
        p_item_exists := v_item_exists;

    END;

  
    /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : May 5, 2013
    **  Reference By  : GIUTS008 - Copy Policy / Endorsement to PAR
    **  Description   : Create Invoice and update par_status
    */ 
     PROCEDURE update_invoice
     (p_par_id    IN  GIPI_WPOLBAS.par_id%TYPE,
      p_line_cd   IN  GIPI_WPOLBAS.line_cd%TYPE,  
      p_iss_cd    IN  GIPI_WPOLBAS.iss_cd%TYPE,
      p_par_type  IN  GIPI_PARLIST.par_type%TYPE,
      p_open_flag IN  VARCHAR2) IS
      
     BEGIN
     
        FOR rec IN (SELECT 'X'
                      FROM GIPI_WITMPERL
                     WHERE par_id = p_par_id)
        LOOP
          IF NVL(p_open_flag, 'N') = 'N' THEN
             IF NVL(p_par_type, 'P') = 'P' THEN             
                CREATE_WINVOICE(0, 0 , 0, p_par_id, p_line_cd, p_iss_cd);            
                CR_BILL_DIST.get_tsi(p_par_id);            
             END IF;
          ELSE
             UPDATE GIPI_PARLIST
                SET par_status = 6
              WHERE par_id = p_par_id;
          END IF;
          EXIT;
        END LOOP;
        
     END update_invoice;
     
     
     /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : May 5, 2013
    **  Reference By  : GIUTS008 - Copy Policy / Endorsement to PAR
    **  Description   : Get details of Copied PAR
    */ 
     PROCEDURE get_copied_par_details
    (p_policy_id     IN   GIPI_POLBASIC.policy_id%TYPE,
     p_par_id        IN   GIPI_PARLIST.par_id%TYPE,
     p_par_yy        OUT  GIPI_PARLIST.quote_seq_no%TYPE,
     p_par_seq_no    OUT  GIPI_PARLIST.par_seq_no%TYPE,
     p_quote_seq_no  OUT  GIPI_PARLIST.quote_seq_no%TYPE,
     p_par_status    OUT  GIPI_PARLIST.par_status%TYPE,
     p_old_policy_no OUT  VARCHAR2,
     p_new_par_no    OUT  VARCHAR2) IS
     
BEGIN    
    
    BEGIN
        SELECT (RTRIM(line_cd) || '-' ||
                RTRIM(iss_cd) || '-' || 
                LTRIM(TO_CHAR(par_yy,'09')) || '-' ||
                LTRIM(TO_CHAR(par_seq_no,'099999')) || '-' ||
                LTRIM(TO_CHAR(quote_seq_no,'09'))) new_par_no, 
               par_yy, par_status, 
               par_seq_no,quote_seq_no
          INTO p_new_par_no,
               p_par_yy, p_par_status,
               p_par_seq_no,p_quote_seq_no 
          FROM GIPI_PARLIST
         WHERE par_id = p_par_id;
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#Copying policy is not successful.');
    END;
    
    BEGIN
        SELECT (RTRIM(line_cd) || '-' || 
                RTRIM(subline_cd) ||'-' ||
                RTRIM(iss_cd) || '-' || 
                LTRIM(TO_CHAR(issue_yy,'09')) || '-' ||
                LTRIM(TO_CHAR(pol_seq_no,'0999999')) || '-' ||
                LTRIM(TO_CHAR(renew_no,'09'))) 
          INTO p_old_policy_no
          FROM GIPI_POLBASIC
         WHERE policy_id = p_policy_id;
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
        NULL;
    END;
    
END;

END GIUTS008_PKG;
/
