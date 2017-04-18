CREATE OR REPLACE PACKAGE BODY CPI.Gipi_Wvehicle_Pkg
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 02.10.2010
	**  Reference By 	: (GIPIS010 - Item Information)
	**  Description     : Contains insert / update / delete procedure of table GIPI_WVEHICLE
    */
    FUNCTION get_gipi_wvehicle (p_par_id      GIPI_WVEHICLE.par_id%TYPE,
                              p_item_no       GIPI_WVEHICLE.item_no%TYPE)
    RETURN gipi_wvehicle_tab PIPELINED  IS    
        v_gipi_par_mc      gipi_wvehicle_type;        
    BEGIN  
        FOR i IN (
            SELECT     a.par_id,                            a.item_no,                        a.item_title,                        a.item_grp,
                    a.item_desc,                        a.item_desc2,                    a.tsi_amt,                            a.prem_amt,
                    a.ann_prem_amt,                        a.ann_tsi_amt,                    a.rec_flag,                            a.currency_cd,
                    a.currency_rt,                        a.group_cd,                        a.from_date,                        a.TO_DATE,
                    a.pack_line_cd,                        a.pack_subline_cd,                a.discount_sw,                        a.coverage_cd,
                    a.other_info,                        a.surcharge_sw,                    a.region_cd,                        a.changed_tag,
                    a.prorate_flag,                        a.comp_sw,                        a.short_rt_percent,                    a.pack_ben_cd,
                    a.payt_terms,                        a.risk_no,                        a.risk_item_no,                        g.currency_desc,
                    h.coverage_desc,        
                    b.plate_no,                            b.motor_no, 
                    b.serial_no,                        b.subline_type_cd,                b.mot_type,                            b.car_company_cd, 
                    b.coc_yy,                            b.coc_seq_no,                    b.coc_serial_no,                    b.coc_type, 
                    Gipi_Wvehicle_Pkg.get_item_deductible_amount(b.par_id, b.item_no) + NVL(b.towing,0)  repair_lim, 
                    b.color,                            b.model_year,                    b.make,                                b.est_value, 
                    b.towing,                            b.assignee,                        b.no_of_pass,                        b.tariff_zone, 
                    b.coc_issue_date,                    b.mv_file_no,                    b.acquired_from,                    b.ctv_tag, 
                    b.type_of_body_cd,                    b.unladen_wt,                    b.make_cd,                            b.series_cd, 
                    b.basic_color_cd,                    b.color_cd,                        b.origin,                            b.destination, 
                    b.coc_atcn,                            b.coc_serial_sw,                b.motor_coverage,                    b.subline_cd, 
                    c.subline_type_desc,                d.car_company,                    e.basic_color,                        f.type_of_body, 
                    Gipi_Wvehicle_Pkg.get_item_deductible_amount(a.par_id, a.item_no) deductible_amt
              FROM     GIPI_WITEM a, 
                    GIPI_WVEHICLE b, 
                    GIIS_MC_SUBLINE_TYPE c,
                    GIIS_MC_CAR_COMPANY d,
                    GIIS_MC_COLOR e,
                    GIIS_TYPE_OF_BODY f,
                    GIIS_CURRENCY g,
                    GIIS_COVERAGE h                    
             WHERE     a.par_id = b.par_id(+) 
               AND    a.item_no = b.item_no(+)               
               AND    b.subline_cd = c.subline_cd(+) 
               AND    b.subline_type_cd = c.subline_type_cd(+)
               AND    b.car_company_cd = d.car_company_cd(+)
               AND    b.basic_color_cd = e.basic_color_cd(+)
               AND    b.color_cd = e.color_cd(+)
               AND    b.type_of_body_cd = f.type_of_body_cd(+)
               AND    a.currency_cd = g.main_currency_cd(+)
               AND    a.coverage_cd = h.coverage_cd(+)
               AND    a.par_id = p_par_id
               AND    a.item_no = p_item_no
          ORDER BY     a.par_id, a.item_no)
        LOOP
            v_gipi_par_mc.par_id            := i.par_id;
            v_gipi_par_mc.item_no            := i.item_no;
            v_gipi_par_mc.item_title        := i.item_title;
            v_gipi_par_mc.item_grp            := i.item_grp;
            v_gipi_par_mc.item_desc            := i.item_desc;
            v_gipi_par_mc.item_desc2        := i.item_desc2;
            v_gipi_par_mc.tsi_amt            := NVL(i.tsi_amt, 0);
            v_gipi_par_mc.prem_amt            := NVL(i.prem_amt, 0);
            v_gipi_par_mc.ann_prem_amt        := NVL(i.ann_prem_amt, 0);
            v_gipi_par_mc.ann_tsi_amt        := NVL(i.ann_tsi_amt, 0);
            v_gipi_par_mc.rec_flag            := i.rec_flag;
            v_gipi_par_mc.currency_cd        := i.currency_cd;
            v_gipi_par_mc.currency_rt        := i.currency_rt;
            v_gipi_par_mc.group_cd            := i.group_cd;
            v_gipi_par_mc.from_date            := i.from_date;
            v_gipi_par_mc.TO_DATE            := i.TO_DATE;
            v_gipi_par_mc.pack_line_cd        := i.pack_line_cd;
            v_gipi_par_mc.pack_subline_cd    := i.pack_subline_cd;
            v_gipi_par_mc.discount_sw        := i.discount_sw;
            v_gipi_par_mc.coverage_cd        := i.coverage_cd;
            v_gipi_par_mc.other_info        := i.other_info;
            v_gipi_par_mc.surcharge_sw        := i.surcharge_sw;
            v_gipi_par_mc.region_cd            := i.region_cd;
            v_gipi_par_mc.changed_tag        := i.changed_tag;
            v_gipi_par_mc.prorate_flag        := i.prorate_flag;
            v_gipi_par_mc.comp_sw            := i.comp_sw;
            v_gipi_par_mc.short_rt_percent    := i.short_rt_percent;
            v_gipi_par_mc.pack_ben_cd        := i.pack_ben_cd;
            v_gipi_par_mc.payt_terms        := i.payt_terms;
            v_gipi_par_mc.risk_no            := i.risk_no;
            v_gipi_par_mc.risk_item_no        := i.risk_item_no;
            v_gipi_par_mc.currency_desc        := i.currency_desc;
            v_gipi_par_mc.coverage_desc        := i.coverage_desc;            
            v_gipi_par_mc.plate_no            := i.plate_no;
            v_gipi_par_mc.motor_no            := i.motor_no;
            v_gipi_par_mc.serial_no            := i.serial_no;
            v_gipi_par_mc.subline_type_cd    := i.subline_type_cd;
            v_gipi_par_mc.mot_type            := i.mot_type;
            v_gipi_par_mc.car_company_cd    := i.car_company_cd;
            v_gipi_par_mc.coc_yy            := i.coc_yy;
            v_gipi_par_mc.coc_seq_no        := i.coc_seq_no;
            v_gipi_par_mc.coc_serial_no        := i.coc_serial_no;
            v_gipi_par_mc.coc_type            := i.coc_type;
            v_gipi_par_mc.repair_lim        := NVL(i.repair_lim, 0);
            v_gipi_par_mc.color                := i.color;
            v_gipi_par_mc.model_year        := i.model_year;
            v_gipi_par_mc.make                := i.make;
            v_gipi_par_mc.est_value            := NVL(i.est_value, 0);
            v_gipi_par_mc.towing            := NVL(i.towing, 0);
            v_gipi_par_mc.assignee            := i.assignee;
            v_gipi_par_mc.no_of_pass        := i.no_of_pass;
            v_gipi_par_mc.tariff_zone        := i.tariff_zone;
            v_gipi_par_mc.coc_issue_date    := i.coc_issue_date;
            v_gipi_par_mc.mv_file_no        := i.mv_file_no;
            v_gipi_par_mc.acquired_from        := i.acquired_from;
            v_gipi_par_mc.ctv_tag            := i.ctv_tag;
            v_gipi_par_mc.type_of_body_cd    := i.type_of_body_cd;
            v_gipi_par_mc.unladen_wt        := i.unladen_wt;
            v_gipi_par_mc.make_cd            := i.make_cd;
            v_gipi_par_mc.series_cd            := i.series_cd;
            v_gipi_par_mc.basic_color_cd    := i.basic_color_cd;
            v_gipi_par_mc.color_cd            := i.color_cd;
            v_gipi_par_mc.origin            := i.origin;
            v_gipi_par_mc.destination        := i.destination;
            v_gipi_par_mc.coc_atcn            := i.coc_atcn;
            v_gipi_par_mc.coc_serial_sw        := i.coc_serial_sw;
            v_gipi_par_mc.subline_cd        := i.subline_cd;
            v_gipi_par_mc.motor_coverage    := i.motor_coverage;
            v_gipi_par_mc.subline_type_desc    := i.subline_type_desc;
            v_gipi_par_mc.car_company        := i.car_company;
            v_gipi_par_mc.basic_color        := i.basic_color;
            v_gipi_par_mc.type_of_body        := i.type_of_body;
            /*v_gipi_par_mc.engine_series        := i.engine_series;*/
            v_gipi_par_mc.deductible_amt    := NVL(i.deductible_amt, 0);        
            PIPE ROW (v_gipi_par_mc);
        END LOOP;
        RETURN;  
    END get_gipi_wvehicle;
 
    FUNCTION get_all_gipi_wvehicle (p_par_id      GIPI_WVEHICLE.par_id%TYPE)
    RETURN gipi_wvehicle_tab PIPELINED  IS    
        v_gipi_par_mc      gipi_wvehicle_type;    
    BEGIN  
        FOR i IN (
            SELECT     a.par_id,                            a.item_no,                        a.item_title,                        a.item_grp,
                    a.item_desc,                        a.item_desc2,                    a.tsi_amt,                            a.prem_amt,
                    a.ann_prem_amt,                        a.ann_tsi_amt,                    a.rec_flag,                            a.currency_cd,
                    a.currency_rt,                        a.group_cd,                        a.from_date,                        a.TO_DATE,
                    a.pack_line_cd,                        a.pack_subline_cd,                a.discount_sw,                        a.coverage_cd,
                    a.other_info,                        a.surcharge_sw,                    a.region_cd,                        a.changed_tag,
                    a.prorate_flag,                        a.comp_sw,                        a.short_rt_percent,                    a.pack_ben_cd,
                    a.payt_terms,                        a.risk_no,                        a.risk_item_no,                        g.currency_desc,
                    h.coverage_desc,        
                    b.plate_no,                            b.motor_no, 
                    b.serial_no,                        b.subline_type_cd,                b.mot_type,                            b.car_company_cd, 
                    b.coc_yy,                            b.coc_seq_no,                    b.coc_serial_no,                    b.coc_type, 
                    Gipi_Wvehicle_Pkg.get_item_deductible_amount(b.par_id, b.item_no) + NVL(b.towing,0)  repair_lim, 
                    b.color,                            b.model_year,                    b.make,                                b.est_value, 
                    b.towing,                            b.assignee,                        b.no_of_pass,                        b.tariff_zone, 
                    b.coc_issue_date,                    b.mv_file_no,                    b.acquired_from,                    b.ctv_tag, 
                    b.type_of_body_cd,                    b.unladen_wt,                    b.make_cd,                            b.series_cd, 
                    b.basic_color_cd,                    b.color_cd,                        b.origin,                            b.destination, 
                    b.coc_atcn,                            b.coc_serial_sw,                b.motor_coverage,                    b.subline_cd, 
                    c.subline_type_desc,                d.car_company,                    e.basic_color,                        f.type_of_body, 
                    Gipi_Wvehicle_Pkg.get_item_deductible_amount(a.par_id, a.item_no) deductible_amt
              FROM     GIPI_WITEM a, 
                    GIPI_WVEHICLE b, 
                    GIIS_MC_SUBLINE_TYPE c,
                    GIIS_MC_CAR_COMPANY d,
                    GIIS_MC_COLOR e,
                    GIIS_TYPE_OF_BODY f,
                    GIIS_CURRENCY g,
                    GIIS_COVERAGE h
             WHERE     a.par_id = b.par_id(+) 
               AND    a.item_no = b.item_no(+)              
               AND    b.subline_cd = c.subline_cd(+) 
               AND    b.subline_type_cd = c.subline_type_cd(+)
               AND    b.car_company_cd = d.car_company_cd(+)
               AND    b.basic_color_cd = e.basic_color_cd(+)
               AND    b.color_cd = e.color_cd(+)
               AND    b.type_of_body_cd = f.type_of_body_cd(+)
               AND    a.currency_cd = g.main_currency_cd(+)
               AND    a.coverage_cd = h.coverage_cd(+)               
               AND    a.par_id = p_par_id
        ORDER BY     a.par_id, a.item_no)
        LOOP
            v_gipi_par_mc.par_id            := i.par_id;
            v_gipi_par_mc.item_no            := i.item_no;
            v_gipi_par_mc.item_title        := i.item_title;
            v_gipi_par_mc.item_grp            := i.item_grp;
            v_gipi_par_mc.item_desc            := i.item_desc;
            v_gipi_par_mc.item_desc2        := i.item_desc2;
            v_gipi_par_mc.tsi_amt            := NVL(i.tsi_amt, 0);
            v_gipi_par_mc.prem_amt            := NVL(i.prem_amt, 0);
            v_gipi_par_mc.ann_prem_amt        := NVL(i.ann_prem_amt, 0);
            v_gipi_par_mc.ann_tsi_amt        := NVL(i.ann_tsi_amt, 0);
            v_gipi_par_mc.rec_flag            := i.rec_flag;
            v_gipi_par_mc.currency_cd        := i.currency_cd;
            v_gipi_par_mc.currency_rt        := i.currency_rt;
            v_gipi_par_mc.group_cd            := i.group_cd;
            v_gipi_par_mc.from_date            := i.from_date;
            v_gipi_par_mc.TO_DATE            := i.TO_DATE;
            v_gipi_par_mc.pack_line_cd        := i.pack_line_cd;
            v_gipi_par_mc.pack_subline_cd    := i.pack_subline_cd;
            v_gipi_par_mc.discount_sw        := i.discount_sw;
            v_gipi_par_mc.coverage_cd        := i.coverage_cd;
            v_gipi_par_mc.other_info        := i.other_info;
            v_gipi_par_mc.surcharge_sw        := i.surcharge_sw;
            v_gipi_par_mc.region_cd            := i.region_cd;
            v_gipi_par_mc.changed_tag        := i.changed_tag;
            v_gipi_par_mc.prorate_flag        := i.prorate_flag;
            v_gipi_par_mc.comp_sw            := i.comp_sw;
            v_gipi_par_mc.short_rt_percent    := i.short_rt_percent;
            v_gipi_par_mc.pack_ben_cd        := i.pack_ben_cd;
            v_gipi_par_mc.payt_terms        := i.payt_terms;
            v_gipi_par_mc.risk_no            := i.risk_no;
            v_gipi_par_mc.risk_item_no        := i.risk_item_no;                
            v_gipi_par_mc.currency_desc        := i.currency_desc;
            v_gipi_par_mc.coverage_desc        := i.coverage_desc;            
            v_gipi_par_mc.plate_no            := i.plate_no;
            v_gipi_par_mc.motor_no            := i.motor_no;
            v_gipi_par_mc.serial_no            := i.serial_no;
            v_gipi_par_mc.subline_type_cd    := i.subline_type_cd;
            v_gipi_par_mc.mot_type            := i.mot_type;
            v_gipi_par_mc.car_company_cd    := i.car_company_cd;
            v_gipi_par_mc.coc_yy            := i.coc_yy;
            v_gipi_par_mc.coc_seq_no        := i.coc_seq_no;
            v_gipi_par_mc.coc_serial_no        := i.coc_serial_no;
            v_gipi_par_mc.coc_type            := i.coc_type;
            v_gipi_par_mc.repair_lim        := NVL(i.repair_lim, 0);
            v_gipi_par_mc.color                := i.color;
            v_gipi_par_mc.model_year        := i.model_year;
            v_gipi_par_mc.make                := i.make;
            v_gipi_par_mc.est_value            := NVL(i.est_value, 0);
            v_gipi_par_mc.towing            := NVL(i.towing, 0);
            v_gipi_par_mc.assignee            := i.assignee;
            v_gipi_par_mc.no_of_pass        := i.no_of_pass;
            v_gipi_par_mc.tariff_zone        := i.tariff_zone;
            v_gipi_par_mc.coc_issue_date    := i.coc_issue_date;
            v_gipi_par_mc.mv_file_no        := i.mv_file_no;
            v_gipi_par_mc.acquired_from        := i.acquired_from;
            v_gipi_par_mc.ctv_tag            := i.ctv_tag;
            v_gipi_par_mc.type_of_body_cd    := i.type_of_body_cd;
            v_gipi_par_mc.unladen_wt        := i.unladen_wt;
            v_gipi_par_mc.make_cd            := i.make_cd;
            v_gipi_par_mc.series_cd            := i.series_cd;
            v_gipi_par_mc.basic_color_cd    := i.basic_color_cd;
            v_gipi_par_mc.color_cd            := i.color_cd;
            v_gipi_par_mc.origin            := i.origin;
            v_gipi_par_mc.destination        := i.destination;
            v_gipi_par_mc.coc_atcn            := i.coc_atcn;
            v_gipi_par_mc.coc_serial_sw        := i.coc_serial_sw;
            v_gipi_par_mc.subline_cd        := i.subline_cd;
            v_gipi_par_mc.motor_coverage    := i.motor_coverage;
            v_gipi_par_mc.subline_type_desc    := i.subline_type_desc;
            v_gipi_par_mc.car_company        := i.car_company;
            v_gipi_par_mc.basic_color        := i.basic_color;
            v_gipi_par_mc.type_of_body        := i.type_of_body;
            /*v_gipi_par_mc.engine_series        := i.engine_series;*/
            v_gipi_par_mc.deductible_amt    := NVL(i.deductible_amt, 0);
            PIPE ROW (v_gipi_par_mc);
        END LOOP;
        RETURN;  
    END get_all_gipi_wvehicle;
    
    FUNCTION get_item_deductible_amount (
        p_par_id    GIPI_WDEDUCTIBLES.par_id%TYPE,
        p_item_no    GIPI_WDEDUCTIBLES.item_no%TYPE)
    RETURN NUMBER
    IS
      v_deductible_amount NUMBER(24,4) := 0;
    BEGIN
        SELECT NVL(SUM(deductible_amt), 0)
          INTO v_deductible_amount
          FROM GIPI_WDEDUCTIBLES
         WHERE par_id = p_par_id
           AND item_no = p_item_no
           AND peril_cd = 0;
        
        RETURN v_deductible_amount;
    END get_item_deductible_amount;        
    
    Procedure set_gipi_vehicle (p_par_item_mc            GIPI_WVEHICLE%ROWTYPE)
    IS    
    BEGIN       
        MERGE INTO GIPI_WVEHICLE
        USING dual ON (par_id = p_par_item_mc.par_id
                    AND item_no = p_par_item_mc.item_no)
        WHEN NOT MATCHED THEN
            INSERT (par_id,                item_no,            subline_cd,
                    motor_no,            plate_no,            est_value,
                    make,                mot_type,            color,
                    repair_lim,            serial_no,            coc_seq_no,
                    coc_serial_no,        coc_type,            assignee,
                    model_year,            coc_issue_date,        coc_yy,
                    towing,                subline_type_cd,    no_of_pass,
                    tariff_zone,        mv_file_no,            acquired_from,
                    ctv_tag,            car_company_cd,        type_of_body_cd,
                    unladen_wt,            make_cd,            series_cd,
                    basic_color_cd,        color_cd,            origin,
                    destination,        coc_atcn,            motor_coverage,
                    coc_serial_sw)
            VALUES (p_par_item_mc.par_id,            p_par_item_mc.item_no,            p_par_item_mc.subline_cd,              
                    p_par_item_mc.motor_no,            p_par_item_mc.plate_no,            p_par_item_mc.est_value,   
                    p_par_item_mc.make,                p_par_item_mc.mot_type,            p_par_item_mc.color,
                    p_par_item_mc.repair_lim,        p_par_item_mc.serial_no,        p_par_item_mc.coc_seq_no,
                    p_par_item_mc.coc_serial_no,    p_par_item_mc.coc_type,            p_par_item_mc.assignee,            
                    p_par_item_mc.model_year,        p_par_item_mc.coc_issue_date,    p_par_item_mc.coc_yy,    
                    p_par_item_mc.towing,            p_par_item_mc.subline_type_cd,    p_par_item_mc.no_of_pass,
                    p_par_item_mc.tariff_zone,        p_par_item_mc.mv_file_no,        p_par_item_mc.acquired_from,
                    p_par_item_mc.ctv_tag,            p_par_item_mc.car_company_cd,   p_par_item_mc.type_of_body_cd,
                    p_par_item_mc.unladen_wt,        p_par_item_mc.make_cd,            p_par_item_mc.series_cd,         
                    p_par_item_mc.basic_color_cd,    p_par_item_mc.color_cd,            p_par_item_mc.origin,
                    p_par_item_mc.destination,        p_par_item_mc.coc_atcn,            p_par_item_mc.motor_coverage,
                    p_par_item_mc.coc_serial_sw)
        WHEN MATCHED THEN
            UPDATE SET  subline_cd        = p_par_item_mc.subline_cd,
                        motor_no          = p_par_item_mc.motor_no, 
                        plate_no          = p_par_item_mc.plate_no,     
                        est_value         = p_par_item_mc.est_value,
                        make              = p_par_item_mc.make,
                        mot_type          = p_par_item_mc.mot_type,
                        color             = p_par_item_mc.color,
                        repair_lim        = p_par_item_mc.repair_lim,                        
                        serial_no         = p_par_item_mc.serial_no,
                        coc_seq_no        = p_par_item_mc.coc_seq_no,
                        coc_serial_no     = p_par_item_mc.coc_serial_no,
                        coc_type          = p_par_item_mc.coc_type,
                        assignee          = p_par_item_mc.assignee,
                        model_year        = p_par_item_mc.model_year,
                        coc_issue_date    = p_par_item_mc.coc_issue_date,
                        coc_yy            = p_par_item_mc.coc_yy,
                        towing            = p_par_item_mc.towing,
                        subline_type_cd   = p_par_item_mc.subline_type_cd,
                        no_of_pass        = p_par_item_mc.no_of_pass,
                        tariff_zone       = p_par_item_mc.tariff_zone,
                        mv_file_no        = p_par_item_mc.mv_file_no,
                        acquired_from     = p_par_item_mc.acquired_from,
                        ctv_tag           = p_par_item_mc.ctv_tag,
                        car_company_cd    = p_par_item_mc.car_company_cd,                        
                        type_of_body_cd   = p_par_item_mc.type_of_body_cd,
                        unladen_wt        = p_par_item_mc.unladen_wt,                        
                        make_cd           = p_par_item_mc.make_cd,
                        series_cd         = p_par_item_mc.series_cd,                        
                        basic_color_cd    = p_par_item_mc.basic_color_cd,
                        color_cd          = p_par_item_mc.color_cd,                        
                        origin            = p_par_item_mc.origin,
                        destination       = p_par_item_mc.destination,                        
                        coc_atcn          = p_par_item_mc.coc_atcn,
                        motor_coverage    = p_par_item_mc.motor_coverage,
                        coc_serial_sw     = p_par_item_mc.coc_serial_sw;    
        /*COMMIT;*/
    END set_gipi_vehicle;
    
    Procedure set_gipi_wvehicle_1 (
        p_par_id            IN GIPI_WVEHICLE.par_id%TYPE,
        p_item_no            IN GIPI_WVEHICLE.item_no%TYPE,
        p_subline_cd        IN GIPI_WVEHICLE.subline_cd%TYPE,
        p_motor_no            IN GIPI_WVEHICLE.motor_no%TYPE,
        p_plate_no            IN GIPI_WVEHICLE.plate_no%TYPE,
        p_est_value            IN GIPI_WVEHICLE.est_value%TYPE,
        p_make                IN GIPI_WVEHICLE.make%TYPE,
        p_mot_type            IN GIPI_WVEHICLE.mot_type%TYPE,
        p_color                IN GIPI_WVEHICLE.color%TYPE,
        p_repair_lim        IN GIPI_WVEHICLE.repair_lim%TYPE,
        p_serial_no            IN GIPI_WVEHICLE.serial_no%TYPE,
        p_coc_seq_no        IN GIPI_WVEHICLE.coc_seq_no%TYPE,
        p_coc_serial_no        IN GIPI_WVEHICLE.coc_serial_no%TYPE,
        p_coc_type            IN GIPI_WVEHICLE.coc_type%TYPE,
        p_assignee            IN GIPI_WVEHICLE.assignee%TYPE,
        p_model_year        IN GIPI_WVEHICLE.model_year%TYPE,
        p_coc_issue_date    IN GIPI_WVEHICLE.coc_issue_date%TYPE,
        p_coc_yy            IN GIPI_WVEHICLE.coc_yy%TYPE,
        p_towing            IN GIPI_WVEHICLE.towing%TYPE,
        p_subline_type_cd    IN GIPI_WVEHICLE.subline_type_cd%TYPE,
        p_no_of_pass        IN GIPI_WVEHICLE.no_of_pass%TYPE,
        p_tariff_zone        IN GIPI_WVEHICLE.tariff_zone%TYPE,
        p_mv_file_no        IN GIPI_WVEHICLE.mv_file_no%TYPE,
        p_acquired_from        IN GIPI_WVEHICLE.acquired_from%TYPE,
        p_ctv_tag            IN GIPI_WVEHICLE.ctv_tag%TYPE,
        p_car_company_cd    IN GIPI_WVEHICLE.car_company_cd%TYPE,
        p_type_of_body_cd    IN GIPI_WVEHICLE.type_of_body_cd%TYPE,
        p_unladen_wt        IN GIPI_WVEHICLE.unladen_wt%TYPE,
        p_make_cd            IN GIPI_WVEHICLE.make_cd%TYPE,
        p_series_cd            IN GIPI_WVEHICLE.series_cd%TYPE,
        p_basic_color_cd    IN GIPI_WVEHICLE.basic_color_cd%TYPE,
        p_color_cd            IN GIPI_WVEHICLE.color_cd%TYPE,
        p_origin            IN GIPI_WVEHICLE.origin%TYPE,
        p_destination        IN GIPI_WVEHICLE.destination%TYPE,
        p_coc_atcn            IN GIPI_WVEHICLE.coc_atcn%TYPE,
        p_motor_coverage    IN GIPI_WVEHICLE.motor_coverage%TYPE,
        p_coc_serial_sw        IN GIPI_WVEHICLE.coc_serial_sw%TYPE)
    IS
    BEGIN
        IF validate_mc_upload(p_subline_cd, p_subline_type_cd, p_car_company_cd, p_make_cd, p_make, p_series_cd, p_color, p_basic_color_cd, p_color_cd, p_par_id, p_item_no)
        THEN
            MERGE INTO GIPI_WVEHICLE
            USING dual ON (par_id = p_par_id
                        AND item_no = p_item_no)
            WHEN NOT MATCHED THEN
                INSERT (
                    par_id,                item_no,            subline_cd,
                    motor_no,            plate_no,            est_value,
                    make,                mot_type,            color,
                    repair_lim,            serial_no,            coc_seq_no,
                    coc_serial_no,        coc_type,            assignee,
                    model_year,            coc_issue_date,        coc_yy,
                    towing,                subline_type_cd,    no_of_pass,
                    tariff_zone,        mv_file_no,            acquired_from,
                    ctv_tag,            car_company_cd,        type_of_body_cd,
                    unladen_wt,            make_cd,            series_cd,
                    basic_color_cd,        color_cd,            origin,
                    destination,        coc_atcn,            motor_coverage,
                    coc_serial_sw)
                VALUES (
                    p_par_id,            p_item_no,            p_subline_cd,
                    p_motor_no,            p_plate_no,            p_est_value,
                    p_make,                p_mot_type,            p_color,
                    p_repair_lim,        p_serial_no,        p_coc_seq_no,
                    p_coc_serial_no,    p_coc_type,            p_assignee,
                    p_model_year,        p_coc_issue_date,    p_coc_yy,
                    p_towing,            p_subline_type_cd,    p_no_of_pass,
                    p_tariff_zone,        p_mv_file_no,        p_acquired_from,
                    p_ctv_tag,            p_car_company_cd,   p_type_of_body_cd,
                    p_unladen_wt,        p_make_cd,            p_series_cd,
                    p_basic_color_cd,    p_color_cd,            p_origin,
                    p_destination,        p_coc_atcn,            p_motor_coverage,
                    p_coc_serial_sw)
            WHEN MATCHED THEN
                UPDATE SET  subline_cd        = p_subline_cd,
                            motor_no          = p_motor_no, 
                            plate_no          = p_plate_no,     
                            est_value         = p_est_value,
                            make              = p_make,
                            mot_type          = p_mot_type,
                            color             = p_color,
                            repair_lim        = p_repair_lim,
                            serial_no         = p_serial_no,
                            coc_seq_no        = p_coc_seq_no,
                            coc_serial_no     = p_coc_serial_no,
                            coc_type          = p_coc_type,
                            assignee          = p_assignee,
                            model_year        = p_model_year,
                            coc_issue_date    = p_coc_issue_date,
                            coc_yy            = p_coc_yy,
                            towing            = p_towing,
                            subline_type_cd   = p_subline_type_cd,
                            no_of_pass        = p_no_of_pass,
                            tariff_zone       = p_tariff_zone,
                            mv_file_no        = p_mv_file_no,
                            acquired_from     = p_acquired_from,
                            ctv_tag           = p_ctv_tag,
                            car_company_cd    = p_car_company_cd,
                            type_of_body_cd   = p_type_of_body_cd,
                            unladen_wt        = p_unladen_wt,
                            make_cd           = p_make_cd,
                            series_cd         = p_series_cd,
                            basic_color_cd    = p_basic_color_cd,
                            color_cd          = p_color_cd,
                            origin            = p_origin,
                            destination       = p_destination,
                            coc_atcn          = p_coc_atcn,
                            motor_coverage    = p_motor_coverage,
                            coc_serial_sw     = p_coc_serial_sw;                       
        END IF;   
    END    set_gipi_wvehicle_1;
	
	/*
	**  Created by    : Veronica V. Raymundo
	**  Date Created  : October 16, 2012
	**  Reference By  : GIPIS010 - Motor Car Item Information
	**  Description   : Save record to GIPI_WVEHICLE with the additional
	**					columns needed for COC authentication
	*/
    
	Procedure set_gipi_wvehicle_new (
        p_par_id            IN GIPI_WVEHICLE.par_id%TYPE,
        p_item_no           IN GIPI_WVEHICLE.item_no%TYPE,
        p_subline_cd        IN GIPI_WVEHICLE.subline_cd%TYPE,
        p_motor_no          IN GIPI_WVEHICLE.motor_no%TYPE,
        p_plate_no          IN GIPI_WVEHICLE.plate_no%TYPE,
        p_est_value         IN GIPI_WVEHICLE.est_value%TYPE,
        p_make              IN GIPI_WVEHICLE.make%TYPE,
        p_mot_type          IN GIPI_WVEHICLE.mot_type%TYPE,
        p_color             IN GIPI_WVEHICLE.color%TYPE,
        p_repair_lim        IN GIPI_WVEHICLE.repair_lim%TYPE,
        p_serial_no         IN GIPI_WVEHICLE.serial_no%TYPE,
        p_coc_seq_no        IN GIPI_WVEHICLE.coc_seq_no%TYPE,
        p_coc_serial_no     IN GIPI_WVEHICLE.coc_serial_no%TYPE,
        p_coc_type          IN GIPI_WVEHICLE.coc_type%TYPE,
        p_assignee          IN GIPI_WVEHICLE.assignee%TYPE,
        p_model_year        IN GIPI_WVEHICLE.model_year%TYPE,
        p_coc_issue_date    IN GIPI_WVEHICLE.coc_issue_date%TYPE,
        p_coc_yy            IN GIPI_WVEHICLE.coc_yy%TYPE,
        p_towing            IN GIPI_WVEHICLE.towing%TYPE,
        p_subline_type_cd   IN GIPI_WVEHICLE.subline_type_cd%TYPE,
        p_no_of_pass        IN GIPI_WVEHICLE.no_of_pass%TYPE,
        p_tariff_zone       IN GIPI_WVEHICLE.tariff_zone%TYPE,
        p_mv_file_no        IN GIPI_WVEHICLE.mv_file_no%TYPE,
        p_acquired_from     IN GIPI_WVEHICLE.acquired_from%TYPE,
        p_ctv_tag           IN GIPI_WVEHICLE.ctv_tag%TYPE,
        p_car_company_cd    IN GIPI_WVEHICLE.car_company_cd%TYPE,
        p_type_of_body_cd   IN GIPI_WVEHICLE.type_of_body_cd%TYPE,
        p_unladen_wt        IN GIPI_WVEHICLE.unladen_wt%TYPE,
        p_make_cd           IN GIPI_WVEHICLE.make_cd%TYPE,
        p_series_cd         IN GIPI_WVEHICLE.series_cd%TYPE,
        p_basic_color_cd    IN GIPI_WVEHICLE.basic_color_cd%TYPE,
        p_color_cd          IN GIPI_WVEHICLE.color_cd%TYPE,
        p_origin            IN GIPI_WVEHICLE.origin%TYPE,
        p_destination       IN GIPI_WVEHICLE.destination%TYPE,
        p_coc_atcn          IN GIPI_WVEHICLE.coc_atcn%TYPE,
        p_motor_coverage    IN GIPI_WVEHICLE.motor_coverage%TYPE,
        p_coc_serial_sw     IN GIPI_WVEHICLE.coc_serial_sw%TYPE,
		p_reg_type			IN GIPI_WVEHICLE.reg_type%TYPE,
		p_mv_type			IN GIPI_WVEHICLE.mv_type%TYPE,
		p_mv_prem_type		IN GIPI_WVEHICLE.mv_prem_type%TYPE)
    IS
    BEGIN
        MERGE INTO GIPI_WVEHICLE
        USING dual ON (par_id = p_par_id
                    AND item_no = p_item_no)
        WHEN NOT MATCHED THEN
            INSERT (
                par_id,              item_no,            subline_cd,
                motor_no,            plate_no,           est_value,
                make,                mot_type,           color,
                repair_lim,          serial_no,          coc_seq_no,
                coc_serial_no,       coc_type,           assignee,
                model_year,          coc_issue_date,     coc_yy,
                towing,              subline_type_cd,    no_of_pass,
                tariff_zone,         mv_file_no,         acquired_from,
                ctv_tag,             car_company_cd,     type_of_body_cd,
                unladen_wt,          make_cd,            series_cd,
                basic_color_cd,      color_cd,           origin,
                destination,         coc_atcn,           motor_coverage,
                coc_serial_sw,       reg_type,			 mv_type,
				mv_prem_type,		 tax_type)
            VALUES (
                p_par_id,            p_item_no,          p_subline_cd,
                p_motor_no,          p_plate_no,         p_est_value,
                p_make,              p_mot_type,         p_color,
                p_repair_lim,        p_serial_no,        p_coc_seq_no,
                p_coc_serial_no,     p_coc_type,         p_assignee,
                p_model_year,        p_coc_issue_date,   p_coc_yy,
                p_towing,            p_subline_type_cd,  p_no_of_pass,
                p_tariff_zone,       p_mv_file_no,       p_acquired_from,
                p_ctv_tag,           p_car_company_cd,   p_type_of_body_cd,
                p_unladen_wt,        p_make_cd,          p_series_cd,
                p_basic_color_cd,    p_color_cd,         p_origin,
                p_destination,       p_coc_atcn,         p_motor_coverage,
                p_coc_serial_sw,     p_reg_type,	     p_mv_type,
				p_mv_prem_type, 	 gipi_wvehicle_pkg.get_par_vat_tag(p_par_id))
        WHEN MATCHED THEN
            UPDATE SET  subline_cd        = p_subline_cd,
                        motor_no          = p_motor_no, 
                        plate_no          = p_plate_no,     
                        est_value         = p_est_value,
                        make              = p_make,
                        mot_type          = p_mot_type,
                        color             = p_color,
                        repair_lim        = p_repair_lim,
                        serial_no         = p_serial_no,
                        coc_seq_no        = p_coc_seq_no,
                        coc_serial_no     = p_coc_serial_no,
                        coc_type          = p_coc_type,
                        assignee          = p_assignee,
                        model_year        = p_model_year,
                        coc_issue_date    = p_coc_issue_date,
                        coc_yy            = p_coc_yy,
                        towing            = p_towing,
                        subline_type_cd   = p_subline_type_cd,
                        no_of_pass        = p_no_of_pass,
                        tariff_zone       = p_tariff_zone,
                        mv_file_no        = p_mv_file_no,
                        acquired_from     = p_acquired_from,
                        ctv_tag           = p_ctv_tag,
                        car_company_cd    = p_car_company_cd,
                        type_of_body_cd   = p_type_of_body_cd,
                        unladen_wt        = p_unladen_wt,
                        make_cd           = p_make_cd,
                        series_cd         = p_series_cd,
                        basic_color_cd    = p_basic_color_cd,
                        color_cd          = p_color_cd,
                        origin            = p_origin,
                        destination       = p_destination,
                        coc_atcn          = p_coc_atcn,
                        motor_coverage    = p_motor_coverage,
                        coc_serial_sw     = p_coc_serial_sw,
						reg_type		  = p_reg_type,
						mv_type			  = p_mv_type,
						mv_prem_type	  = p_mv_prem_type,
						tax_type		  = gipi_wvehicle_pkg.get_par_vat_tag(p_par_id);
    END    set_gipi_wvehicle_new;
	
    Procedure delete_gipi_par_item (
        p_par_id        GIPI_WITEM.par_id%TYPE,
        p_item_no    GIPI_WITEM.item_no%TYPE)
    IS
    BEGIN
        DELETE 
          FROM GIPI_WITEM
         WHERE par_id = p_par_id
           AND item_no = p_item_no;
           
        DELETE
          FROM GIPI_WVEHICLE
         WHERE par_id = p_par_id
           AND item_no = p_item_no;
           
        /*COMMIT;*/
    END delete_gipi_par_item;    
    
    /*
    **  Created by        : Mark JM
    **  Date Created     : 03.04.2010
    **  Reference By     : (GIPIS010 - Item Information)
    **  Description     : Contains delete procedure on table GIPI_WVEHICLE based on par_id and item_no
    */
    Procedure del_gipi_wvehicle (
        p_par_id    GIPI_WVEHICLE.par_id%TYPE,
        p_item_no    GIPI_WVEHICLE.item_no%TYPE)
    IS
    BEGIN
        DELETE FROM GIPI_WVEHICLE
         WHERE par_id = p_par_id
           AND item_no = p_item_no;
    END del_gipi_wvehicle;
    
    /*
    **  Created by        : Mark JM
    **  Date Created     : 06.01.2010
    **  Reference By     : (GIPIS031 - Endt Basic Information)
    **  Description     : This procedure deletes record based on the given par_id    
    */
    Procedure del_gipi_wvehicle (p_par_id IN GIPI_WVEHICLE.par_id%TYPE)
    IS
    BEGIN
        DELETE GIPI_WVEHICLE
         WHERE par_id = p_par_id;
    END del_gipi_wvehicle;
    
    /*
    **  Created by        : Mark JM
    **  Date Created     : 12.02.2010
    **  Reference By     : (GIPIS010 - Item Information - Motorcar)
    **  Description     : Retrieves record on GIPI_WVEHICLE based on the given par_id and item_no
    */
    FUNCTION get_gipi_wvehicle1(
        p_par_id    IN gipi_wvehicle.par_id%TYPE,
        p_item_no    IN gipi_wvehicle.item_no%TYPE)
    RETURN gipi_wvehicle_tab_all_cols PIPELINED
    IS
        v_gipi_wvehicle_tab gipi_wvehicle_par_type;
    BEGIN
        FOR i IN (
            SELECT a.par_id,            a.item_no,            a.subline_cd,        a.motor_no,            a.plate_no,
                   a.est_value,            a.make,                a.mot_type,            a.color,            a.repair_lim,
                   a.serial_no,            a.coc_seq_no,        a.coc_serial_no,    a.coc_type,            a.assignee,
                   a.model_year,        a.coc_issue_date,    a.coc_yy,            a.towing,            a.subline_type_cd,
                   a.no_of_pass,        a.tariff_zone,        a.mv_file_no,        a.acquired_from,    a.ctv_tag,
                   a.car_company_cd,    a.type_of_body_cd,    a.unladen_wt,        a.make_cd,            a.series_cd,
                   a.basic_color_cd,    a.color_cd,            a.origin,            a.destination,        a.coc_atcn,
                   a.motor_coverage,    a.coc_serial_sw,	  a.reg_type,		 a.mv_type,				a.mv_prem_type, a.tax_type,
                   b.mv_prem_type_desc,
                   c.rv_meaning mv_type_desc,
                   d.car_company,
                   e.engine_series,
                   f.basic_color,
                   f.color color_desc
              FROM gipi_wvehicle a,
                   giis_mv_prem_type b,
                   cg_ref_codes c,
                   giis_mc_car_company d,
                   giis_mc_eng_series e,
                   giis_mc_color f
             WHERE a.par_id = p_par_id
               AND a.item_no = p_item_no
               AND a.mv_type = b.mv_type_cd(+)
               AND a.mv_prem_type = b.mv_prem_type_cd(+)
               AND a.mv_type = c.rv_low_value(+)
               AND 'GIPI_VEHICLE.MV_TYPE' = c.rv_domain(+)
               AND a.car_company_cd = d.car_company_cd(+)
               AND a.car_company_cd = e.car_company_cd(+)
               AND a.make_cd = e.make_cd(+)
               AND a.series_cd = e.series_cd(+)
               AND a.basic_color_cd = f.basic_color_cd(+)
               AND a.color_cd = f.color_cd(+))
        LOOP
            v_gipi_wvehicle_tab.par_id            := i.par_id;
            v_gipi_wvehicle_tab.item_no            := i.item_no;
            v_gipi_wvehicle_tab.subline_cd        := i.subline_cd;
            v_gipi_wvehicle_tab.motor_no        := i.motor_no;
            v_gipi_wvehicle_tab.plate_no        := i.plate_no;
            v_gipi_wvehicle_tab.est_value        := i.est_value;
            v_gipi_wvehicle_tab.make            := i.make;
            v_gipi_wvehicle_tab.mot_type        := i.mot_type;
            v_gipi_wvehicle_tab.color            := i.color;
            v_gipi_wvehicle_tab.repair_lim        := i.repair_lim;
            v_gipi_wvehicle_tab.serial_no        := i.serial_no;
            v_gipi_wvehicle_tab.coc_seq_no        := i.coc_seq_no;
            v_gipi_wvehicle_tab.coc_serial_no    := i.coc_serial_no;
            v_gipi_wvehicle_tab.coc_type        := i.coc_type;
            v_gipi_wvehicle_tab.assignee        := i.assignee;
            v_gipi_wvehicle_tab.model_year        := i.model_year;
            v_gipi_wvehicle_tab.coc_issue_date    := i.coc_issue_date;
            v_gipi_wvehicle_tab.coc_yy            := i.coc_yy;
            v_gipi_wvehicle_tab.towing            := i.towing;
            v_gipi_wvehicle_tab.subline_type_cd    := i.subline_type_cd;
            v_gipi_wvehicle_tab.no_of_pass        := i.no_of_pass;
            v_gipi_wvehicle_tab.tariff_zone        := i.tariff_zone;
            v_gipi_wvehicle_tab.mv_file_no        := i.mv_file_no;
            v_gipi_wvehicle_tab.acquired_from    := i.acquired_from;
            v_gipi_wvehicle_tab.ctv_tag            := i.ctv_tag;
            v_gipi_wvehicle_tab.car_company_cd    := i.car_company_cd;
            v_gipi_wvehicle_tab.type_of_body_cd    := i.type_of_body_cd;
            v_gipi_wvehicle_tab.unladen_wt        := i.unladen_wt;
            v_gipi_wvehicle_tab.make_cd            := i.make_cd;
            v_gipi_wvehicle_tab.series_cd        := i.series_cd;
            v_gipi_wvehicle_tab.basic_color_cd    := i.basic_color_cd;
            v_gipi_wvehicle_tab.color_cd        := i.color_cd;
            v_gipi_wvehicle_tab.origin            := i.origin;
            v_gipi_wvehicle_tab.destination        := i.destination;
            v_gipi_wvehicle_tab.coc_atcn        := i.coc_atcn;
            v_gipi_wvehicle_tab.motor_coverage    := i.motor_coverage;
            v_gipi_wvehicle_tab.coc_serial_sw    := i.coc_serial_sw;
            v_gipi_wvehicle_tab.car_company        := i.car_company;
            v_gipi_wvehicle_tab.engine_series    := i.engine_series;
            v_gipi_wvehicle_tab.basic_color        := i.basic_color;
            v_gipi_wvehicle_tab.color_desc           := i.color_desc;
            
			--added additional columns for COC authentication Nica 10.18.2012
            v_gipi_wvehicle_tab.tax_type    	   := i.tax_type;
			v_gipi_wvehicle_tab.reg_type    	   := i.reg_type;
            v_gipi_wvehicle_tab.mv_type        	   := i.mv_type;
            v_gipi_wvehicle_tab.mv_type_desc  	   := i.mv_type_desc;
            v_gipi_wvehicle_tab.mv_prem_type       := i.mv_prem_type; 
            v_gipi_wvehicle_tab.mv_prem_type_desc  := i.mv_prem_type_desc;

			
            PIPE ROW(v_gipi_wvehicle_tab);
        END LOOP;
        
        RETURN;
    END get_gipi_wvehicle1;
    
    /*
    **  Created by        : Mark JM
    **  Date Created    : 03.21.2011
    **  Reference By    : (GIPIS095 - Package Policy Items)
    **  Description     : Retrieve records from gipi_wvehicle based on the given parameters
    */
    FUNCTION get_gipi_wvehicle_pack_pol (
        p_par_id    IN gipi_wvehicle.par_id%TYPE,
        p_item_no    IN gipi_wvehicle.item_no%TYPE)
    RETURN gipi_wvehicle_tab_all_cols PIPELINED
    IS
        v_gipi_wvehicle gipi_wvehicle_par_type;
    BEGIN
        FOR i IN (
            SELECT par_id, item_no
              FROM gipi_wvehicle
             WHERE par_id = p_par_id
               AND item_no = p_item_no)
        LOOP
            v_gipi_wvehicle.par_id    := i.par_id;
            v_gipi_wvehicle.item_no    := i.item_no;
            
            PIPE ROW(v_gipi_wvehicle);
        END LOOP;
        
        RETURN;
    END get_gipi_wvehicle_pack_pol;
    
    /*
    **  Created by        : D.Alcantara
    **  Date Created     : 03.05.2012
    **  Reference By     : (GIPIS198 - Upload Fleet Data)
    **  Description     : Saves items from an uploaded file
    */
    PROCEDURE set_vehicle_on_mcupload (
        p_par_id            IN GIPI_WVEHICLE.par_id%TYPE,
        p_item_no            IN GIPI_WVEHICLE.item_no%TYPE,
        p_subline_cd        IN GIPI_WVEHICLE.subline_cd%TYPE,
        p_motor_no            IN GIPI_WVEHICLE.motor_no%TYPE,
        p_plate_no            IN GIPI_WVEHICLE.plate_no%TYPE,
        p_est_value            IN GIPI_WVEHICLE.est_value%TYPE,
        p_make                IN GIPI_WVEHICLE.make%TYPE,
        p_mot_type            IN GIPI_WVEHICLE.mot_type%TYPE,
        p_color                IN GIPI_WVEHICLE.color%TYPE,
        p_repair_lim        IN GIPI_WVEHICLE.repair_lim%TYPE,
        p_serial_no            IN GIPI_WVEHICLE.serial_no%TYPE,
        p_coc_seq_no        IN GIPI_WVEHICLE.coc_seq_no%TYPE,
        p_coc_serial_no        IN GIPI_WVEHICLE.coc_serial_no%TYPE,
        p_coc_type            IN GIPI_WVEHICLE.coc_type%TYPE,
        p_assignee            IN GIPI_WVEHICLE.assignee%TYPE,
        p_model_year        IN GIPI_WVEHICLE.model_year%TYPE,
        p_coc_issue_date    IN GIPI_WVEHICLE.coc_issue_date%TYPE,
        p_coc_yy            IN GIPI_WVEHICLE.coc_yy%TYPE,
        p_towing            IN GIPI_WVEHICLE.towing%TYPE,
        p_subline_type_cd    IN GIPI_WVEHICLE.subline_type_cd%TYPE,
        p_no_of_pass        IN GIPI_WVEHICLE.no_of_pass%TYPE,
        p_tariff_zone        IN GIPI_WVEHICLE.tariff_zone%TYPE,
        p_mv_file_no        IN GIPI_WVEHICLE.mv_file_no%TYPE,
        p_acquired_from        IN GIPI_WVEHICLE.acquired_from%TYPE,
        p_ctv_tag            IN GIPI_WVEHICLE.ctv_tag%TYPE,
        p_car_company_cd    IN GIPI_WVEHICLE.car_company_cd%TYPE,
        p_type_of_body_cd    IN GIPI_WVEHICLE.type_of_body_cd%TYPE,
        p_unladen_wt        IN GIPI_WVEHICLE.unladen_wt%TYPE,
        p_make_cd            IN GIPI_WVEHICLE.make_cd%TYPE,
        p_series_cd            IN GIPI_WVEHICLE.series_cd%TYPE,
        p_basic_color_cd    IN GIPI_WVEHICLE.basic_color_cd%TYPE,
        p_color_cd            IN GIPI_WVEHICLE.color_cd%TYPE,
        p_origin            IN GIPI_WVEHICLE.origin%TYPE,
        p_destination        IN GIPI_WVEHICLE.destination%TYPE,
        p_coc_atcn            IN GIPI_WVEHICLE.coc_atcn%TYPE,
        p_motor_coverage    IN GIPI_WVEHICLE.motor_coverage%TYPE,
        p_coc_serial_sw        IN GIPI_WVEHICLE.coc_serial_sw%TYPE
    ) IS
        v_check       NUMBER := 0;
    BEGIN 
        FOR i IN (
            SELECT 1 FROM GIPI_WVEHICLE
             WHERE par_id = p_par_id
               AND item_no = p_item_no
        ) LOOP
            v_check := 1;
        END LOOP;
        
        IF v_check = 0 THEN 
            GIPI_WVEHICLE_PKG.set_gipi_wvehicle_1(
                p_par_id, p_item_no, p_subline_cd, p_motor_no, p_plate_no,
                p_est_value, p_make, p_mot_type, p_color, p_repair_lim,
                p_serial_no, p_coc_seq_no, p_coc_serial_no, p_coc_type,
                p_assignee, p_model_year, p_coc_issue_date, p_coc_yy,
                p_towing, p_subline_type_cd, p_no_of_pass, p_tariff_zone,
                p_mv_file_no, p_acquired_from, p_ctv_tag, p_car_company_cd,
                p_type_of_body_cd, p_unladen_wt, p_make_cd, p_series_cd,
                p_basic_color_cd, p_color_cd, p_origin, p_destination,
                p_coc_atcn, p_motor_coverage, p_coc_serial_sw);
        END IF;
    END set_vehicle_on_mcupload;
    
    /*
    **  Created by        : D.Alcantara
    **  Date Created     : 03.05.2012
    **  Reference By     : (GIPIS198 - Upload Fleet Data)
    **  Description     : Retrieves saved gipi vehicles
    */
    FUNCTION get_vehicles_GIPIS198(
        p_par_id    IN gipi_wvehicle.par_id%TYPE)
    RETURN gipi_wvehicle_tab_all_cols PIPELINED IS
        v_vehicle   gipi_wvehicle_par_type;
    BEGIN
        FOR i IN (
            SELECT par_id, item_no FROM gipi_wvehicle
             WHERE par_id = p_par_id
        ) LOOP
            v_vehicle.par_id := i.par_id;
            v_vehicle.item_no := i.item_no;
            PIPE ROW(v_vehicle);
        END LOOP;
    END get_vehicles_GIPIS198;
    
	/*
	**  Created by		: Gzelle
	**  Date Created 	: 09.24.2014
	**  Reference By 	: (GIPIS010 - Item Information)
	**  Description 	: MC Fleet Upload - checks if entered codes are existing in maintenance tables
    */
    FUNCTION validate_mc_upload(
        p_subline_cd        giis_mc_subline_type.subline_cd%TYPE,
        p_subline_type_cd   giis_mc_subline_type.subline_type_cd%TYPE,
        p_car_company_cd    giis_mc_car_company.car_company_cd%TYPE,
        p_make_cd           giis_mc_make.make_cd%TYPE,
        p_make              giis_mc_make.make%TYPE,
        p_series_cd         giis_mc_eng_series.series_cd%TYPE,
        p_color             giis_mc_color.color%TYPE,
        p_basic_color_cd    giis_mc_color.basic_color_cd%TYPE,
        p_color_cd          giis_mc_color.color_cd%TYPE,
        p_par_id            gipi_witem.par_id%TYPE,
        p_item_no           gipi_witem.item_no%TYPE
    )
        RETURN BOOLEAN IS
        
        v_subline_type      NUMBER         := 0;
        v_car_comp          NUMBER         := 0;
        v_make              NUMBER         := 0;
        v_mc_eng            NUMBER         := 0;
        v_mc_color          NUMBER         := 0;     
        v_rec_flag          gipi_witem.rec_flag%TYPE;
        v_par_type          gipi_parlist.par_type%TYPE; 
    BEGIN    
       IF p_subline_type_cd IS NOT NULL AND p_subline_cd IS NOT NULL
       THEN
          BEGIN
             SELECT 1
               INTO v_subline_type
               FROM giis_mc_subline_type
              WHERE subline_cd = p_subline_cd
                AND subline_type_cd = p_subline_type_cd;
          EXCEPTION
             WHEN NO_DATA_FOUND
             THEN
                v_subline_type := 0;
          END;
       ELSE
          v_subline_type := 1;      
       END IF;

       IF p_car_company_cd IS NOT NULL
       THEN
          BEGIN
             SELECT 1
               INTO v_car_comp
               FROM giis_mc_car_company
              WHERE car_company_cd = p_car_company_cd;
          EXCEPTION
             WHEN NO_DATA_FOUND
             THEN
                v_car_comp := 0;
          END;
       ELSE
          v_car_comp := 1;      
       END IF;

       IF p_make_cd IS NOT NULL AND p_make IS NOT NULL AND p_car_company_cd IS NOT NULL
       THEN
          BEGIN
             SELECT 1
               INTO v_make
               FROM giis_mc_make
              WHERE make_cd = p_make_cd
                AND UPPER (TRIM (make)) = UPPER (TRIM (p_make))
                AND car_company_cd = p_car_company_cd;
          EXCEPTION
             WHEN NO_DATA_FOUND
             THEN
                v_make := 0;
          END;
       ELSIF p_make_cd IS NULL AND p_make IS NULL AND p_car_company_cd IS NOT NULL
       THEN
          v_make := 1;
       ELSIF p_make_cd IS NULL AND p_make IS NULL AND p_car_company_cd IS NULL
       THEN
          v_make := 1;      
       ELSE
          v_make := 0;      
       END IF;

       IF     p_series_cd IS NOT NULL
          AND p_car_company_cd IS NOT NULL
          AND p_make_cd IS NOT NULL
       THEN
          BEGIN
             SELECT 1
               INTO v_mc_eng
               FROM giis_mc_eng_series
              WHERE car_company_cd = p_car_company_cd
                AND make_cd = p_make_cd
                AND series_cd = p_series_cd;
          EXCEPTION
             WHEN NO_DATA_FOUND
             THEN
                v_mc_eng := 0;
          END;
       ELSE
          v_mc_eng := 1;
       END IF;
       
       IF     p_color_cd IS NOT NULL
          AND p_color IS NOT NULL   
          AND p_basic_color_cd IS NOT NULL
       THEN
          BEGIN
             SELECT 1
               INTO v_mc_color
               FROM giis_mc_color
              WHERE color_cd = p_color_cd
                AND basic_color_cd = p_basic_color_cd
                AND UPPER (TRIM (color)) = UPPER (TRIM (p_color));
          EXCEPTION
             WHEN NO_DATA_FOUND
             THEN
                v_mc_color := 0;
          END;
       ELSIF p_color_cd IS NULL AND p_color IS NULL AND p_basic_color_cd IS NOT NULL
       THEN
          BEGIN
             SELECT 1
               INTO v_mc_color
               FROM giis_mc_color
              WHERE basic_color_cd = p_basic_color_cd
                AND ROWNUM = 1;
          EXCEPTION
             WHEN NO_DATA_FOUND
             THEN
                v_mc_color := 0;
          END;   
       ELSIF p_color_cd IS NOT NULL AND p_color IS NOT NULL AND p_basic_color_cd IS NULL
       THEN         
          BEGIN
             SELECT 1
               INTO v_mc_color
               FROM giis_mc_color
              WHERE color_cd = p_color_cd
                AND UPPER (TRIM (color)) = UPPER (TRIM (p_color))
                AND ROWNUM = 1;
          EXCEPTION
             WHEN NO_DATA_FOUND
             THEN
                v_mc_color := 0;
          END;
       ELSIF p_color_cd IS NULL AND p_color IS NULL AND p_basic_color_cd IS NULL
       THEN       
          v_mc_color := 1;         
       ELSE
          v_mc_color := 0; 
       END IF;
       
       BEGIN
          SELECT a.rec_flag, b.par_type
            INTO v_rec_flag, v_par_type
            FROM gipi_witem a, gipi_parlist b
           WHERE a.par_id = p_par_id
             AND a.par_id = b.par_id
             AND a.item_no = p_item_no;
       EXCEPTION
          WHEN NO_DATA_FOUND
          THEN
            v_rec_flag := NULL;
            v_par_type := NULL;
       END;
       
       IF v_rec_flag <> 'A' AND v_par_type = 'E'
       THEN
          v_car_comp := 1;
       END IF;

       IF     v_subline_type = 1
          AND v_car_comp = 1
          AND v_make = 1
          AND v_mc_eng = 1
          AND v_mc_color = 1
       THEN
          RETURN TRUE;
       ELSE
            raise_application_error
                (-20001,
                 'Geniisys Exception#E#Some values does not exists in maintenance tables. subline type :'||v_subline_type||'- car company: '||v_car_comp||'- make: '||v_make||'- engine series: '||v_mc_eng||'- color: '||v_mc_color
                );  
       END IF;
    END;   
          
    FUNCTION get_par_vat_tag(
        p_par_id            gipi_wvehicle.par_id%TYPE
    )
    RETURN VARCHAR2
    IS
        v_vat_tag giis_assured.vat_tag%TYPE;
    BEGIN
        SELECT vat_tag INTO v_vat_tag
        FROM GIIS_ASSURED
         WHERE assd_no = (SELECT assd_no from gipi_wpolbas WHERE par_id = p_par_id);
    
        RETURN v_vat_tag;
    
    END;
    
END Gipi_Wvehicle_Pkg;
/


