select
    mod_no,
    ID,
    modelno,
    pl_no,
    modelno_group,
    DECODE(NVL(MODELNO_GROUP,0),0,0,1) AS MODELNO_GROUP_FLAG,
    category,
    '' as cg,
    '' as cat1,
    '' as cat2,
    '' as cat3,
    '' as cat4,
    ca_code,
    ca_dept_mcode,
    ca_dept_code,
    ca_dept_dcode,
    ca_lcode_ran,
    ca_mcode_ran,
    ca_scode_ran,
    ca_dcode_ran,
    shop_code,
    shop_name,
    shop_name_code,
    modelnm,
    modelnm2,
    factory,
    brand,
    popular,
    popular2,
    sale_cnt,
    '' as model_factory,
    minprice,
    maxprice,
    minprices,
    C_DATE,
    mallcnt,
    DECODE(NVL(MALLCNT,0),0,0,1) AS MALLCNT_FLAG,
    spec,
    openexpectflag,
    condiname,
    KEYWORD,
    keyword2,
    BRANDCODE1,
    BRANDCODE2,
    SPECOPT,
    bookflag,
    useflag,
    weight,
    minprice3,
    minprice2,
    maxprice3,
    mobile_flag,
    minprice4,
    store_flag,
    bbs_num,
    zum_check,
    service_gubun,
    minprice5,
    ext_condi_flag,
    MODELNM || ' ' || FACTORY || ' ' || SPEC || ' ' || KEYWORD || ' ' || KEYWORD2 || ' ' || CONDINAME AS to_all
from (

select
    mod_no,
    ID,
    modelno,
    pl_no,
    modelno_group,
    CASE WHEN service_gubun='2' AND store_flag='1' AND ca_dept_code IS NOT NULL THEN RTRIM(category || ' '  || ca_dept_code) ELSE category END AS category,
    ca_code,
    CASE WHEN SUBSTR(RTRIM(ca_dept_code),3,8)='000000' OR SUBSTR(RTRIM(ca_dept_code),3,8) IS NULL THEN '' ELSE SUBSTR(RTRIM(ca_dept_code),0,4) END AS ca_dept_mcode,
    CASE WHEN SUBSTR(RTRIM(ca_dept_code),5,8)='0000' OR SUBSTR(RTRIM(ca_dept_code),5,8) IS NULL THEN '' ELSE SUBSTR(RTRIM(ca_dept_code),0,6) END AS ca_dept_code,
    CASE WHEN SUBSTR(RTRIM(ca_dept_code),7,8)='00' OR SUBSTR(RTRIM(ca_dept_code),7,8) IS NULL THEN '' ELSE SUBSTR(RTRIM(ca_dept_code),0,8) END AS ca_dept_dcode,
    ca_lcode_ran,
    ca_mcode_ran,
    ca_scode_ran,
    ca_dcode_ran,
    shop_code,    
    shop_name,    
    shop_name_code,
    modelnm,
    modelnm2,
    factory,
    brand,
    popular,
    popular2,
    sale_cnt,
    model_factory,
    minprice,
    maxprice,
    replace(minprices, ' ', '    ') as minprices,
    C_DATE,
    mallcnt,
    replace(replace(spec,',',' '),'/',' ') spec,
    openexpectflag,
    replace(condiname, ' ', '    ') as condiname,    
    CASE WHEN socialprice=0 THEN keyword ELSE keyword || ' ' || UDF_SOCIAL_GOODSNM(modelno_group,modelno) END AS KEYWORD,    
    keyword2,
    BRANDCODE1,
    BRANDCODE2,
    SPECOPT,
    bookflag,
    useflag,
    weight,
    minprice3,
    minprice2,
    maxprice3,
    mobile_flag,
    minprice4,
    store_flag,
    bbs_num,
    zum_check,
    service_gubun,
    minprice5,
    ext_condi_flag
FROM tmp_es_price_data_31
WHERE mod_no = 1

)
