DROP PROCEDURE CPI.GIPIS002A_B540_WHEN_CREA_REC_B;

CREATE OR REPLACE PROCEDURE CPI.GIPIS002A_B540_WHEN_CREA_REC_B
   (b240_line_cd                    IN VARCHAR2,
	b240_iss_cd                     IN VARCHAR2,
	b240_assd_no                    IN NUMBER,
	variables_def_cred_branch       IN VARCHAR2,
    b540_pack_pol_flag              OUT VARCHAR2,
    b540_nbt_ind_desc               OUT VARCHAR2,
    b540_industry_cd                OUT NUMBER,
    b540_nbt_region_desc            OUT VARCHAR2,
    b540_region_cd                  OUT NUMBER,
    var_display_def_cred_branch     OUT VARCHAR2,
    b540_dsp_cred_branch            OUT VARCHAR2,
    b540_cred_branch                OUT VARCHAR2
    ) 
IS
BEGIN
    BEGIN
        FOR A IN (SELECT   pack_pol_flag 
                    FROM   giis_line
                   WHERE   line_cd  =  b240_line_cd) 
        LOOP
           b540_pack_pol_flag :=  A.pack_pol_flag;
           EXIT;
        END LOOP;
    END;

    /* default values for industry and region --jpc 08/02/2001*/
    BEGIN
        FOR j IN (SELECT industry_nm, industry_cd
                  FROM giis_industry
                  WHERE industry_cd = (SELECT industry_cd 
                                       FROM giis_assured 
                                       WHERE assd_no = b240_assd_no))
        LOOP
             b540_nbt_ind_desc  := j.industry_nm;
             b540_industry_cd   := j.industry_cd;
             EXIT;
        END LOOP;

        FOR x IN (SELECT region_desc, region_cd
                  FROM giis_region
                  WHERE region_cd = (SELECT region_cd 
                                     FROM giis_issource
                                     WHERE iss_cd = b240_iss_cd))
        LOOP
             b540_nbt_region_desc   := x.region_desc;
             b540_region_cd         := x.region_cd;
             EXIT;
        END LOOP;
    END;

    --to populate crediting branch
    --if parameter is based on AGENT, 
    --crediting branch will be populated after entering the intermediary 
    --added check if a default crediting branch will be supplied
    
    BEGIN
        FOR x IN (SELECT c.param_value_v cp
                    FROM giis_parameters c
                   WHERE c.param_name = 'DISPLAY_DEF_CRED_BRANCH')
        LOOP
            var_display_def_cred_branch := x.cp;
            EXIT;
        END LOOP;
        IF variables_def_cred_branch = 'ISS_CD' AND var_display_def_cred_branch = 'Y' THEN
           FOR var IN (SELECT iss_name
                         FROM giis_issource
                        WHERE iss_cd = b240_iss_cd)
           LOOP
             b540_dsp_cred_branch   := var.iss_name;
             b540_cred_branch       := b240_iss_cd;
           
           END LOOP;
        END IF;
    END;
END;
/


