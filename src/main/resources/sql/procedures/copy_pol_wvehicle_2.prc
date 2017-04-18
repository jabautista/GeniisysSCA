CREATE OR REPLACE PROCEDURE CPI.copy_pol_wvehicle_2(
    p_old_pol_id    gipi_vehicle.policy_ID%TYPE,
    p_new_policy_id gipi_vehicle.policy_ID%TYPE
) 
IS
  CURSOR c1 IS SELECT item_no,plate_no,subline_cd,motor_no,est_value,
                      make,mot_type,color,repair_lim,serial_no,
                      coc_seq_no,coc_serial_no,coc_type,assignee,
                      model_year,coc_issue_date,
                      NVL(coc_yy,TO_NUMBER(TO_CHAR(SYSDATE,'RR'))) coc_yy,towing,
                      subline_type_cd,no_of_pass,tariff_zone,ctv_tag,
                      mv_file_no, acquired_from, car_company_cd, type_of_body_cd,
                      make_cd, series_cd, basic_color_cd, color_cd, unladen_wt,
                      origin,destination, motor_coverage, reg_type, mv_type,
                      mv_prem_type, tax_type
                 FROM gipi_vehicle
                WHERE policy_id = p_old_pol_id;
  v_coc_type          gipi_wvehicle.coc_type%TYPE;
  v_coc_serial_no     gipi_wvehicle.coc_serial_no%TYPE;
  v_coc_seq_no        gipi_wvehicle.coc_seq_no%TYPE;  
  v_coc_yy            gipi_wvehicle.coc_yy%TYPE;
  /* Revised to have conformity with the objects in the database;
  ** the columns in the policy table should not be indicated to determine
  ** whether the inserted records maintain their integrity with the objects
  ** in the database.
  ** Updated by   : Daphne
  ** Last Update  : 060798
  */
BEGIN
  /*
  **  Created by   : Robert Virrey
  **  Date Created : 10-13-2011  
  **  Reference By : (GIEXS004 - TAG EXPIRED POLICIES FOR RENEWAL) 
  **  Description  : copy_pol_wvehicle program unit 
  */
  --CLEAR_MESSAGE;
  --MESSAGE('Copying Vehicle info...',NO_ACKNOWLEDGE);
  --SYNCHRONIZE;
  FOR c1_rec IN c1 LOOP 
      v_coc_type        := c1_rec.coc_type;
      v_coc_serial_no   := NVL(c1_rec.coc_serial_no,0);
      v_coc_seq_no      := NVL(c1_rec.coc_seq_no,0);
      v_coc_yy          := NVL(c1_rec.coc_yy,0);
      --generate_COC_SEQ_NO(c1_rec.item_no);--UNDER STUDY--
          GENERATE_COC_SEQ_NO(p_new_policy_id,
                              c1_rec.item_no,
                              v_coc_type,
                              v_coc_serial_no,
                              v_coc_seq_no,
                              v_coc_yy);
      --generate_COC_SEQ_NO(c1_rec.item_no);--UNDER STUDY--
      INSERT INTO gipi_vehicle    
           (policy_id,item_no,subline_cd,coc_yy,coc_seq_no,coc_serial_no,
          coc_type,repair_lim,color,motor_no,model_year,make,mot_type,
          est_value,serial_no,towing,assignee,plate_no,subline_type_cd,
          no_of_pass,tariff_zone,ctv_tag,
          mv_file_no, acquired_from, car_company_cd, type_of_body_cd,
          make_cd, series_cd, basic_color_cd, color_cd, unladen_wt,
          origin,destination, motor_coverage, reg_type, mv_type,
          mv_prem_type, tax_type)
      VALUES
         (p_new_policy_id,c1_rec.item_no,c1_rec.subline_cd,v_coc_yy,v_coc_seq_no,v_coc_serial_no,
          v_coc_type,c1_rec.repair_lim,c1_rec.color,c1_rec.motor_no,c1_rec.model_year,c1_rec.make,
          c1_rec.mot_type,c1_rec.est_value,c1_rec.serial_no,c1_rec.towing,
          c1_rec.assignee,c1_rec.plate_no,c1_rec.subline_type_cd,
          c1_rec.no_of_pass,c1_rec.tariff_zone,c1_rec.ctv_tag,
          c1_rec.mv_file_no, c1_rec.acquired_from, c1_rec.car_company_cd, c1_rec.type_of_body_cd,
          c1_rec.make_cd, c1_rec.series_cd, c1_rec.basic_color_cd, c1_rec.color_cd, c1_rec.unladen_wt,
          c1_rec.origin,c1_rec.destination, c1_rec.motor_coverage, c1_rec.reg_type, c1_rec.mv_type,
          c1_rec.mv_prem_type, c1_rec.tax_type);
  END LOOP;
END;
/


