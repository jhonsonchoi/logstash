select
    ID,
    modelno,
    pl_no,
    modelno_group,
    DECODE(NVL(MODELNO_GROUP,0),0,0,1) AS MODELNO_GROUP_FLAG,
    UDF_CATEGORY_ALL(CATEGORY) AS category,
    CASE WHEN SERVICE_GUBUN = 1 THEN UDF_CATEGORY_SUB(CATEGORY,4) ELSE UDF_CATEGORY_SUB(CATEGORY,2) END AS CG,
    UDF_CATEGORY_SUB(CATEGORY,2) AS CAT1,
    UDF_CATEGORY_SUB(CATEGORY,4) AS CAT2,
    UDF_CATEGORY_SUB(CATEGORY,2) AS CAT3,
    UDF_CATEGORY_SUB(CATEGORY,2) AS CAT4,
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
    CASE WHEN SERVICE_GUBUN = 1 THEN REPLACE(MODELNM || ' ' || FACTORY, '-', '') ELSE '' END AS model_factory,
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
search_key as ID,
CASE WHEN service_flag='1' THEN modelno ELSE pl_no END AS modelno,
pl_no,
group_flag as modelno_group,
CASE WHEN service_flag='2' AND store_flag='1' AND ca_dept_code IS NOT NULL THEN RTRIM(category || ' ' || ca_dept_code) ELSE category END AS category,
ca_code,
CASE WHEN service_flag='1' THEN SUBSTR(ca_code,0,2) ELSE '' END ca_lcode_ran,
CASE WHEN service_flag='1' THEN SUBSTR(ca_code,0,4) ELSE '' END ca_mcode_ran,
CASE WHEN service_flag='1' THEN SUBSTR(ca_code,0,6) ELSE '' END ca_scode_ran,
CASE WHEN service_flag='1' THEN SUBSTR(ca_code,0,8) ELSE '' END ca_dcode_ran,
shop_code,
'' as shop_name,
'' as shop_name_code,
modelnm,
CASE WHEN service_flag='1' THEN modelnm2 WHEN service_flag='2' AND SUBSTR(ca_code,0,4)='1219' THEN UDF_GOODSNM_REMOVE(modelnm) ELSE '' END modelnm2, 
factory,
brand,
popular,
popular2,
sale_cnt,
CASE WHEN service_flag='1' THEN modelnm2 ELSE '' END AS model_factory,
minprice,
maxprice,
replace(minprices, ' ', '    ') as minprices,
C_DATE,
mallcnt,
spec,
openexpectflag,
replace(condiname, ' ', ' ') as condiname,
keyword1 as KEYWORD,
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
CASE WHEN service_flag='1' OR (service_flag='2' AND minprice3 > 0) THEN '1' ELSE '0' END AS mobile_flag,
minprice4,
store_flag,
CASE WHEN SUBSTR(RTRIM(ca_dept_code),3,8)='000000' OR SUBSTR(RTRIM(ca_dept_code),3,8) IS NULL THEN '' ELSE SUBSTR(RTRIM(ca_dept_code),0,4) END AS ca_dept_mcode,
CASE WHEN SUBSTR(RTRIM(ca_dept_code),5,8)='0000' OR SUBSTR(RTRIM(ca_dept_code),5,8) IS NULL THEN '' ELSE SUBSTR(RTRIM(ca_dept_code),0,6) END AS ca_dept_code,
CASE WHEN SUBSTR(RTRIM(ca_dept_code),7,8)='00' OR SUBSTR(RTRIM(ca_dept_code),7,8) IS NULL THEN '' ELSE SUBSTR(RTRIM(ca_dept_code),0,8) END AS ca_dept_dcode,
bbs_num,
CASE WHEN service_flag='1' THEN '1' ELSE UDF_ZUM_CHECK(shop_code) END AS zum_check,
service_flag as service_gubun,
CASE WHEN service_flag='1' THEN UDF_MODEL_GROUP_MINPRICE_ETC(modelno,5) ELSE minprice END AS minprice5,
CASE WHEN service_flag='1' THEN UDF_MODELGROUP_EXTCONDIFLAG_DQ(modelno) ELSE '' END AS ext_condi_flag,
status
from
-- DBENURI.TBL_SEARCH_LOG
( select row_number() over(partition by search_key order by regdate desc) as rank, t.* from TBL_SEARCH_LOG t )
where
-- (case when modelno=0 then mod(pl_no, 3) else mod(modelno, 3) end) = 0
-- and regdate < (select stime from DBENURI.ir_inc_index_timestamp where collection_name = 'ENURI_0')
 rank=1

)
