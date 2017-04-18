DROP PROCEDURE CPI.TO_CSV_TABLES;

CREATE OR REPLACE PROCEDURE CPI.to_csv_tables (
   v_filename   IN   VARCHAR2,
   v_csv_path   IN   VARCHAR2,
   v_upload     IN   NUMBER
)
IS
/* petermkaw 01212010
** created procedure to_tables that would
** acquire the csv file and input it's values to
** the respective tables created for table updating
** (stores the data in gipi_itmfloater_csv and gipi_perlfloater_csv
**  depending on what file is uploaded)
*/
   output_file                UTL_FILE.file_type;
   line_to_insert             VARCHAR2 (10000);
   input_file                 UTL_FILE.file_type;
   v_record_no                NUMBER (18);                       --NUMBER(9);
   v_item_no                  NUMBER (18);                       --NUMBER(9);
   v_item_title               VARCHAR2 (100);                 --VARCHAR2(50);
   v_currency_cd              NUMBER (4);                        --NUMBER(2);
   v_currency_rt              NUMBER (24, 18);                --NUMBER(12,9);
   v_item_desc                VARCHAR2 (4000);              --VARCHAR2(2000);
   v_item_desc2               VARCHAR2 (4000);              --VARCHAR2(2000);
   v_location_cd              NUMBER (10);                       --NUMBER(5);
   v_region_cd                NUMBER (4);                        --NUMBER(2);
   v_location                 VARCHAR2 (300);                --VARCHAR2(150);
   v_limit_of_liability       VARCHAR2 (1000);               --VARCHAR2(500);
   v_interest_on_premises     VARCHAR2 (1000);               --VARCHAR2(500);
   v_section_or_hazard_info   VARCHAR2 (4000);              --VARCHAR2(2000);
   v_conveyance_info          VARCHAR2 (120);                 --VARCHAR2(60);
   v_property_no_type         VARCHAR2 (2);                    --VARCHAR2(1);
   v_property_no              VARCHAR2 (60);                  --VARCHAR2(30);
   v_peril_cd                 NUMBER (10);                       --NUMBER(5);
   v_prem_rt                  NUMBER (24, 18);                --NUMBER(12,9);
   v_tsi_amt                  NUMBER (32, 4);                 --NUMBER(16,2);
   v_prem_amt                 NUMBER (32, 4);                 --NUMBER(12,2);
   v_aggregate_sw             VARCHAR2 (2);                    --VARCHAR2(1);
   v_ri_comm_rate             NUMBER (24, 18);                --NUMBER(12,9);
   v_ri_comm_amt              NUMBER (28, 4);                 --NUMBER(14,2);
   v_ded_deductible_cd        VARCHAR2 (10);                   --VARCHAR2(5);
   v_upload_no                NUMBER (12);                       --NUMBER(9);
BEGIN
   input_file := UTL_FILE.fopen (v_csv_path, v_filename, 'R');

   LOOP
      BEGIN
         UTL_FILE.get_line (input_file, line_to_insert);

         IF INSTR (line_to_insert, 'RECORD_NO') = 1
         THEN
            NULL;
         ELSIF UPPER (v_filename) LIKE '%FLOATER%ITEM%'
         THEN
            --split_itmfloater will acquire the values from the csv (petermkaw)
            upd_floater_csv_pkg.split_itmfloater (line_to_insert,
                                                  v_record_no,
                                                  v_item_no,
                                                  v_item_title,
                                                  v_currency_cd,
                                                  v_currency_rt,
                                                  v_item_desc,
                                                  v_item_desc2,
                                                  v_location_cd,
                                                  v_region_cd,
                                                  v_location,
                                                  v_limit_of_liability,
                                                  v_interest_on_premises,
                                                  v_section_or_hazard_info,
                                                  v_conveyance_info,
                                                  v_property_no_type,
                                                  v_property_no,
                                                  v_ded_deductible_cd
                                                 );

            --values acquired will be inserted in the table (petermkaw)
            INSERT INTO gipi_itmfloater_csv
                 VALUES (v_record_no, v_item_no, v_item_title, v_currency_cd,
                         v_currency_rt, v_item_desc, v_item_desc2,
                         v_location_cd, v_region_cd, v_location,
                         v_limit_of_liability, v_interest_on_premises,
                         v_section_or_hazard_info, v_conveyance_info,
                         v_property_no_type, v_property_no,
                         v_ded_deductible_cd, v_upload);
         ELSIF UPPER (v_filename) LIKE '%FLOATER%PERIL%'
         THEN
            upd_floater_csv_pkg.split_perlfloater (line_to_insert,
                                                   v_record_no,
                                                   v_item_no,
                                                   v_item_title,
                                                   v_currency_cd,
                                                   v_currency_rt,
                                                   v_item_desc,
                                                   v_item_desc2,
                                                   v_location_cd,
                                                   v_region_cd,
                                                   v_location,
                                                   v_limit_of_liability,
                                                   v_interest_on_premises,
                                                   v_section_or_hazard_info,
                                                   v_conveyance_info,
                                                   v_property_no_type,
                                                   v_property_no,
                                                   v_peril_cd,
                                                   v_prem_rt,
                                                   v_tsi_amt,
                                                   v_prem_amt,
                                                   v_aggregate_sw,
                                                   v_ri_comm_rate,
                                                   v_ri_comm_amt,
                                                   v_ded_deductible_cd
                                                  );

            INSERT INTO gipi_perlfloater_csv
                 VALUES (v_record_no, v_item_no, v_item_title, v_currency_cd,
                         v_currency_rt, v_item_desc, v_item_desc2,
                         v_location_cd, v_region_cd, v_location,
                         v_limit_of_liability, v_interest_on_premises,
                         v_section_or_hazard_info, v_conveyance_info,
                         v_property_no_type, v_property_no, v_peril_cd,
                         v_prem_rt, v_tsi_amt, v_prem_amt, v_aggregate_sw,
                         v_ri_comm_rate, v_ri_comm_amt, v_ded_deductible_cd,
                         v_upload);
         END IF;
      EXCEPTION
         WHEN OTHERS
         THEN
            EXIT;
      END;
   END LOOP;

   UTL_FILE.fclose (input_file);
EXCEPTION
   WHEN OTHERS
   THEN
      UTL_FILE.fclose (input_file);
END;
/


