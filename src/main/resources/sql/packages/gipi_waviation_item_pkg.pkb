CREATE OR REPLACE PACKAGE BODY CPI.Gipi_Waviation_Item_Pkg
AS
    /*
    **  Created by        : Jerome Orio
    **  Date Created     : 04.14.2010
    **  Reference By     : (GIPIS019- Item Information - Aviation)
    **  Description     : Returns PAR record listing for AVIATION
    */
    FUNCTION get_gipi_waviation_item (p_par_id GIPI_WAVIATION_ITEM.par_id%TYPE)
    RETURN gipi_waviation_tab PIPELINED  IS
        v_gipi_par_av      gipi_waviation_type;
    BEGIN
        FOR i IN (SELECT a.par_id,                a.item_no,                a.item_title,            a.item_grp,
                         a.item_desc,            a.item_desc2,            a.tsi_amt,                a.prem_amt,
                         a.ann_prem_amt,        a.ann_tsi_amt,            a.rec_flag,                a.currency_cd,
                         a.currency_rt,            a.group_cd,                a.from_date,            a.TO_DATE,
                         a.pack_line_cd,        a.pack_subline_cd,        a.discount_sw,            a.coverage_cd,
                         a.other_info,            a.surcharge_sw,            a.region_cd,            a.changed_tag,
                         a.prorate_flag,        a.comp_sw,                a.short_rt_percent,        a.pack_ben_cd,
                         a.payt_terms,            a.risk_no,                a.risk_item_no,            b.currency_desc,
                         c.vessel_cd,            c.total_fly_time,        c.qualification,        c.purpose,
                         c.geog_limit,            c.deduct_text,            c.rec_flag rec_flag_av, c.fixed_wing,
                         c.rotor,                c.prev_util_hrs,        c.est_util_hrs,            d.coverage_desc
                   FROM  GIPI_WITEM a,
                           GIIS_CURRENCY b,
                         GIPI_WAVIATION_ITEM c,
                         GIIS_COVERAGE d
                    WHERE  a.par_id = p_par_id
                    AND  a.currency_cd = b.main_currency_cd(+)
                    AND  a.par_id = c.par_id(+)
                       AND  a.item_no = c.item_no(+)
                       AND  a.coverage_cd = d.coverage_cd(+)
                    ORDER BY     a.par_id, a.item_no)
        LOOP
            v_gipi_par_av.par_id            := i.par_id;
            v_gipi_par_av.item_no            := i.item_no;
            v_gipi_par_av.item_title        := i.item_title;
            v_gipi_par_av.item_grp            := i.item_grp;
            v_gipi_par_av.item_desc            := i.item_desc;
            v_gipi_par_av.item_desc2        := i.item_desc2;
            v_gipi_par_av.tsi_amt            := NVL(i.tsi_amt, 0);
            v_gipi_par_av.prem_amt            := NVL(i.prem_amt, 0);
            v_gipi_par_av.ann_prem_amt        := NVL(i.ann_prem_amt, 0);
            v_gipi_par_av.ann_tsi_amt        := NVL(i.ann_tsi_amt, 0);
            v_gipi_par_av.rec_flag            := i.rec_flag;
            v_gipi_par_av.currency_cd        := i.currency_cd;
            v_gipi_par_av.currency_rt        := i.currency_rt;
            v_gipi_par_av.group_cd            := i.group_cd;
            v_gipi_par_av.from_date            := i.from_date;
            v_gipi_par_av.TO_DATE            := i.TO_DATE;
            v_gipi_par_av.pack_line_cd        := i.pack_line_cd;
            v_gipi_par_av.pack_subline_cd    := i.pack_subline_cd;
            v_gipi_par_av.discount_sw        := i.discount_sw;
            v_gipi_par_av.coverage_cd        := i.coverage_cd;
            v_gipi_par_av.other_info        := i.other_info;
            v_gipi_par_av.surcharge_sw        := i.surcharge_sw;
            v_gipi_par_av.region_cd            := i.region_cd;
            v_gipi_par_av.changed_tag        := i.changed_tag;
            v_gipi_par_av.prorate_flag        := i.prorate_flag;
            v_gipi_par_av.comp_sw            := i.comp_sw;
            v_gipi_par_av.short_rt_percent    := i.short_rt_percent;
            v_gipi_par_av.pack_ben_cd        := i.pack_ben_cd;
            v_gipi_par_av.payt_terms        := i.payt_terms;
            v_gipi_par_av.risk_no            := i.risk_no;
            v_gipi_par_av.risk_item_no        := i.risk_item_no;
            v_gipi_par_av.vessel_cd            := i.vessel_cd;
            v_gipi_par_av.total_fly_time    := i.total_fly_time;
            v_gipi_par_av.qualification        := i.qualification;
            v_gipi_par_av.purpose            := i.purpose;
            v_gipi_par_av.geog_limit        := i.geog_limit;
            v_gipi_par_av.deduct_text        := i.deduct_text;
            v_gipi_par_av.rec_flag_av        := i.rec_flag_av;
            v_gipi_par_av.fixed_wing        := i.fixed_wing;
            v_gipi_par_av.rotor                := i.rotor;
            v_gipi_par_av.prev_util_hrs        := i.prev_util_hrs;
            v_gipi_par_av.est_util_hrs        := i.est_util_hrs;
            v_gipi_par_av.currency_desc        := i.currency_desc;
            v_gipi_par_av.coverage_desc        := i.coverage_desc;
            v_gipi_par_av.itmperl_grouped_exists := GIPI_WITMPERL_GROUPED_PKG.gipi_witmperl_grouped_exist(p_par_id, i.item_no);
          PIPE ROW (v_gipi_par_av);
        END LOOP;
        RETURN;
    END;

    /*    Date        Author                    Description
    **    ==========    ====================    ===================
    **    03.02.2011    Jerome Orio             Returns PAR record listing for AVIATION
    **                                        Reference By : (GIPIS019- Item Information - Aviation)
    **    12.08.2011    mark jm                    modified sql statement to include vessel_name, rpc_no, and air_desc
    */
    FUNCTION get_gipi_waviation_item (
        p_par_id    GIPI_WAVIATION_ITEM.par_id%TYPE,
        p_item_no   GIPI_WAVIATION_ITEM.item_no%TYPE)
    RETURN gipi_waviation_par_tab PIPELINED  IS
        v_gipi_par_av      gipi_waviation_par_type;
    BEGIN
        FOR i IN (
            SELECT c.vessel_cd,        c.total_fly_time,    c.qualification,        c.purpose,
                   c.geog_limit,    c.deduct_text,        c.rec_flag rec_flag_av, c.fixed_wing,
                   c.rotor,            c.prev_util_hrs,    c.est_util_hrs,         c.par_id,
                   c.item_no,         a.vessel_name,         a.rpc_no,                 b.air_desc
              FROM giis_vessel a,
                   giis_air_type b,
                   gipi_waviation_item c
             WHERE c.par_id = p_par_id
               AND c.item_no = p_item_no
               AND a.vessel_cd = c.vessel_cd(+)
               AND a.air_type_cd = b.air_type_cd(+)
          ORDER BY c.par_id, c.item_no)
        LOOP
            v_gipi_par_av.vessel_cd            := i.vessel_cd;
            v_gipi_par_av.total_fly_time    := i.total_fly_time;
            v_gipi_par_av.qualification        := i.qualification;
            v_gipi_par_av.purpose            := i.purpose;
            v_gipi_par_av.geog_limit        := i.geog_limit;
            v_gipi_par_av.deduct_text        := i.deduct_text;
            v_gipi_par_av.rec_flag_av        := i.rec_flag_av;
            v_gipi_par_av.fixed_wing        := i.fixed_wing;
            v_gipi_par_av.rotor                := i.rotor;
            v_gipi_par_av.prev_util_hrs        := i.prev_util_hrs;
            v_gipi_par_av.est_util_hrs        := i.est_util_hrs;
            v_gipi_par_av.par_id            := i.par_id;
            v_gipi_par_av.item_no            := i.item_no;
            v_gipi_par_av.vessel_name        := i.vessel_name;
            v_gipi_par_av.rpc_no            := i.rpc_no;
            v_gipi_par_av.air_desc            := i.air_desc;

            PIPE ROW (v_gipi_par_av);
        END LOOP;
        RETURN;
    END;

    Procedure get_gipi_waviation_item_exist (p_par_id  IN GIPI_WAVIATION_ITEM.par_id%TYPE,
                                               p_exist   OUT NUMBER)
            IS
      v_exist                    NUMBER := 0;
    BEGIN
      FOR a IN (SELECT 1
                  FROM GIPI_WAVIATION_ITEM
                   WHERE par_id = p_par_id)
      LOOP
        v_exist := 1;
      END LOOP;
      p_exist := v_exist;
    END;

    /*
    **  Created by        : Jerome Orio
    **  Date Created     : 04.14.2010
    **  Reference By     : (GIPIS019- Item Information - Aviation)
    **  Description     : Insert PAR record listing for AVIATION
    */
    Procedure set_gipi_waviation_item(
         p_par_id                 GIPI_WITEM.par_id%TYPE,
         p_item_no                 GIPI_WITEM.item_no%TYPE,
         p_vessel_cd            GIPI_WAVIATION_ITEM.vessel_cd%TYPE,
         p_total_fly_time          GIPI_WAVIATION_ITEM.total_fly_time%TYPE,
         p_qualification         GIPI_WAVIATION_ITEM.qualification%TYPE,
         p_purpose                 GIPI_WAVIATION_ITEM.purpose%TYPE,
         p_geog_limit            GIPI_WAVIATION_ITEM.geog_limit%TYPE,
         p_deduct_text             GIPI_WAVIATION_ITEM.deduct_text%TYPE,
         p_rec_flag_av             GIPI_WAVIATION_ITEM.rec_flag%TYPE,
         --p_fixed_wing            GIPI_WAVIATION_ITEM.fixed_wing%TYPE,
         --p_rotor                GIPI_WAVIATION_ITEM.rotor%TYPE,
         p_prev_util_hrs        GIPI_WAVIATION_ITEM.prev_util_hrs%TYPE,
         p_est_util_hrs            GIPI_WAVIATION_ITEM.est_util_hrs%TYPE
        ) IS
    BEGIN
        MERGE INTO GIPI_WAVIATION_ITEM
        USING dual ON (par_id = p_par_id
                    AND item_no = p_item_no)
        WHEN NOT MATCHED THEN
            INSERT (
                   par_id,               item_no,          vessel_cd,
                   total_fly_time,     qualification,      purpose,
                   geog_limit,         deduct_text,      rec_flag,
                   prev_util_hrs,     est_util_hrs
                   )
            VALUES (
                   p_par_id,         p_item_no,          p_vessel_cd,
                   p_total_fly_time, p_qualification, p_purpose,
                   p_geog_limit,     p_deduct_text,      p_rec_flag_av,
                   p_prev_util_hrs,     p_est_util_hrs
                   )
        WHEN MATCHED THEN
            UPDATE SET
                   vessel_cd         = p_vessel_cd,
                   total_fly_time     = p_total_fly_time,
                   qualification     = p_qualification,
                   purpose             = p_purpose,
                   geog_limit         = p_geog_limit,
                   deduct_text         = p_deduct_text,
                   rec_flag             = p_rec_flag_av,
                   prev_util_hrs     = p_prev_util_hrs,
                   est_util_hrs         = p_est_util_hrs;
    END;

    /*
    **  Created by        : Jerome Orio
    **  Date Created     : 04.14.2010
    **  Reference By     : (GIPIS019- Item Information - Aviation)
    **  Description     : Delete PAR record listing for AVIATION
    */
    Procedure del_gipi_waviation_item(
                  p_par_id    GIPI_WAVIATION_ITEM.par_id%TYPE,
                  p_item_no   GIPI_WAVIATION_ITEM.item_no%TYPE
                )
        IS
    BEGIN
       DELETE   GIPI_WAVIATION_ITEM
        WHERE   par_id   =   p_par_id
          AND   item_no  =   p_item_no;
    END;

    /*
    **  Created by        : Mark JM
    **  Date Created     : 06.01.2010
    **  Reference By     : (GIPIS031 - Endt Basic Information)
    **  Description     : This procedure deletes record based on the given par_id
    */
    Procedure del_gipi_waviation_item(p_par_id IN GIPI_WAVIATION_ITEM.par_id%TYPE)
    IS
    BEGIN
        DELETE GIPI_WAVIATION_ITEM
         WHERE par_id = p_par_id;
    END del_gipi_waviation_item;

    /*
    **  Created by        : Mark JM
    **  Date Created     : 06.03.2010
    **  Reference By     : (GIPIS031- Endt Basic Information)
    **  Description     : Insert PAR record listing for AVIATION (complete columns)
    */
    Procedure set_gipi_waviation_item(
         p_par_id                 GIPI_WITEM.par_id%TYPE,
         p_item_no                 GIPI_WITEM.item_no%TYPE,
         p_vessel_cd            GIPI_WAVIATION_ITEM.vessel_cd%TYPE,
         p_total_fly_time          GIPI_WAVIATION_ITEM.total_fly_time%TYPE,
         p_qualification         GIPI_WAVIATION_ITEM.qualification%TYPE,
         p_purpose                 GIPI_WAVIATION_ITEM.purpose%TYPE,
         p_geog_limit            GIPI_WAVIATION_ITEM.geog_limit%TYPE,
         p_deduct_text             GIPI_WAVIATION_ITEM.deduct_text%TYPE,
         p_rec_flag_av             GIPI_WAVIATION_ITEM.rec_flag%TYPE,
         p_fixed_wing            GIPI_WAVIATION_ITEM.fixed_wing%TYPE,
         p_rotor                GIPI_WAVIATION_ITEM.rotor%TYPE,
         p_prev_util_hrs        GIPI_WAVIATION_ITEM.prev_util_hrs%TYPE,
         p_est_util_hrs            GIPI_WAVIATION_ITEM.est_util_hrs%TYPE)
    IS
    BEGIN
        MERGE INTO GIPI_WAVIATION_ITEM
        USING dual ON (par_id = p_par_id
                    AND item_no = p_item_no)
        WHEN NOT MATCHED THEN
            INSERT (
                   par_id,              item_no,        vessel_cd,
                   total_fly_time,    qualification,    purpose,
                   geog_limit,        deduct_text,    rec_flag,
                   fixed_wing,        rotor,            prev_util_hrs,
                   est_util_hrs)
            VALUES (
                   p_par_id,            p_item_no,            p_vessel_cd,
                   p_total_fly_time,    p_qualification,    p_purpose,
                   p_geog_limit,        p_deduct_text,        p_rec_flag_av,
                   p_fixed_wing,        p_rotor,            p_prev_util_hrs,
                   p_est_util_hrs)
        WHEN MATCHED THEN
            UPDATE SET
                   vessel_cd        = p_vessel_cd,
                   total_fly_time    = p_total_fly_time,
                   qualification    = p_qualification,
                   purpose            = p_purpose,
                   geog_limit        = p_geog_limit,
                   deduct_text        = p_deduct_text,
                   rec_flag            = p_rec_flag_av,
                   fixed_wing        = p_fixed_wing,
                   rotor            = p_rotor,
                   prev_util_hrs    = p_prev_util_hrs,
                   est_util_hrs        = p_est_util_hrs;
    END set_gipi_waviation_item;

    /*
    **  Created by        : Mark JM
    **  Date Created    : 03.21.2011
    **  Reference By    : (GIPIS095 - Package Policy Items)
    **  Description     : Retrieve rows from gipi_waviation_item based on the given parameters
    */
    FUNCTION get_gipi_waviation_pack_pol (
        p_par_id IN gipi_waviation_item.par_id%TYPE,
        p_item_no IN gipi_waviation_item.item_no%TYPE)
    RETURN gipi_waviation_par_tab PIPELINED
    IS
        v_gipi_av_item      gipi_waviation_par_type;
    BEGIN
        FOR i IN (
            SELECT par_id, item_no
              FROM gipi_waviation_item
             WHERE par_id = p_par_id
               AND item_no = p_item_no)
        LOOP
            v_gipi_av_item.par_id     := i.par_id;
            v_gipi_av_item.item_no    := i.item_no;

            PIPE ROW(v_gipi_av_item);
        END LOOP;

        RETURN;
    END get_gipi_waviation_pack_pol;
END;
/


