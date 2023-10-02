----------------------
--取度假品类签约订单
----------------------

drop table if exists  tmp_ol_rs_meta_feature_lrfmp_model_1;
create table tmp_ol_rs_meta_feature_lrfmp_model_1
as
select
    order_id,
    t.cust_id,
    rg_time,
    create_time,
    sign_date,
    travel_sign_amount,
    sign_income,
    one_producttype_name,
    two_producttype_name,
    dest_class_name
from dw.kn2_ord_order_detail_all t
join dw.kn2_dim_route_product_sale t1
on t.route_id = t1.route_id
and t.book_city = t1.book_city
and t.dt='20230924'
and t.cancel_flag=0 and t.sign_flag=1 and t.cancel_sign_flag=0  --已签约订单
and t.cust_id >0
and t.distribution_flag in (0,3,4,5)
and t.is_sub = 0                          --剔除子订单
and t1.producttype_class_id = 2
left join dw.kn1_usr_cust_attribute t2
on t.cust_id = t2.cust_id
where t2.cust_id is not null              --剔除已注销用户
;


----------------------
--剔除黄牛、分销会员
----------------------

drop table if exists  tmp_ol_rs_meta_feature_lrfmp_model_2;
create table tmp_ol_rs_meta_feature_lrfmp_model_2
as
select
    t.*
from tmp_ol_rs_meta_feature_lrfmp_model_1 t 
left join dw.kn1_usr_nebula_tb_tag_relation_cust_redundance t1
on t.cust_id = t1.cust_id
and t1.dt='20230924'
and t1.tag_val_id in (326,515)  --剔除326黄牛会员、515分销会员
where t1.cust_id is null
;


--------------------------------------------
--计算指标
--L(注册时间 入会至当前时间的时间分段)
--R(活跃度 最新一次下单距离当前的时间分段)
--F(消费频次 历史累计订单数量分段)
--M(历史平均消费金额 历史平均累计订单金额分段)
--P(历史平均消费利润 历史平均累计订单利润分段)
--------------------------------------------

--取会员注册时间、最近一次下单时间、订单数、平均gmv、平均利润
drop table if exists tmp_ol_rs_meta_feature_lrfmp_model_3;
create table tmp_ol_rs_meta_feature_lrfmp_model_3
as
select
    cust_id,
    datediff('2023-09-24',to_date(rg_time)) rg_days,
    datediff('2023-09-24',max(to_date(create_time))) as ord_days,
    sum(1) as ord_num,
    sum(travel_sign_amount) / sum(1) as gmv,
    sum(sign_income) / sum(1) profit
from tmp_ol_rs_meta_feature_lrfmp_model_2
group by
    cust_id, datediff('2023-09-24',to_date(rg_time))
;


--对注册时间、最近一次下单时间、订单数、平均gmv、平均利润进行分段
drop table if exists  tmp_ol_rs_meta_feature_lrfmp_model_4;
create table tmp_ol_rs_meta_feature_lrfmp_model_4
as
select 
    cust_id,
    rg_days,
    case when rg_days>=0 and rg_days<=360 then 3
        when rg_days>360 and rg_days<=720 then 2.5
        when rg_days>720 and rg_days<=1080 then 2
        when rg_days>1080 and rg_days<=1800 then 1.5
        when rg_days>1800 then 1
    end as l_value,
    ord_days,
    case when ord_days>=0 and ord_days<=180 then 3
        when ord_days>180 and ord_days<=360 then 2.5
        when ord_days>360 and ord_days<=720 then 2
        when ord_days>720 and ord_days<=1080 then 1.5
        when ord_days>1080 then 1
    end as r_value,
    ord_num,
    case when ord_num=1 then 1.0
        when ord_num=2 then 2.0
        when ord_num>=3 then 3.0
    end as f_value,
    gmv,
    case when gmv<0 then 1
        when gmv>=0 and gmv<2000 then 1.5
        when gmv>=2000 and gmv<7000 then 2
        when gmv>=7000 and gmv<20000 then 2.5
        when gmv>=20000 then 3
    end as m_value,
    profit,
    case when profit<0 then 1
        when profit>=0 and profit<100 then 1.5
        when profit>=100 and profit<300 then 2
        when profit>=300 and profit<1000 then 2.5
        when profit>=1000 then 3
    end as p_value    
from tmp_ol_rs_meta_feature_lrfmp_model_3 
;


----------------------
--结果进表
----------------------

drop table if exists  tmp_ol_rs_meta_feature_lrfmp_model;
create table tmp_ol_rs_meta_feature_lrfmp_model
as
select 
       cust_id,
       0 as one_class_code,
       '行为特征' as one_class_name,
       0 as two_class_code,
       '用户商业价值（度假lrfmp）' as two_class_name,
       0 as three_class_code,
       'L（注册时长）' as three_class_name, 
        l_value as feature_name,
        1 as feature_value,
        from_unixtime(unix_timestamp(),'yyyy-MM-dd HH:mm:ss') as etl_time
  from tmp_ol_rs_meta_feature_lrfmp_model_4
 where l_value>0
union all
select 
       cust_id,
       0 as one_class_code,
       '行为特征' as one_class_name,
       0 as two_class_code,
       '用户商业价值（度假lrfmp）' as two_class_name,
       0 as three_class_code,
       'R（活跃度）' as three_class_name, 
        r_value as feature_name,
        1 as feature_value,
        from_unixtime(unix_timestamp(),'yyyy-MM-dd HH:mm:ss') as etl_time
  from tmp_ol_rs_meta_feature_lrfmp_model_4
 where r_value>0
union all
select 
       cust_id,
       0 as one_class_code,
       '行为特征' as one_class_name,
       0 as two_class_code,
       '用户商业价值（度假lrfmp）' as two_class_name,
       0 as three_class_code,
       'F（消费频次）' as three_class_name, 
        f_value as feature_name,
        1 as feature_value,
        from_unixtime(unix_timestamp(),'yyyy-MM-dd HH:mm:ss') as etl_time
  from tmp_ol_rs_meta_feature_lrfmp_model_4
 where f_value>0
union all
select 
       cust_id,
       0 as one_class_code,
       '行为特征' as one_class_name,
       0 as two_class_code,
       '用户商业价值（度假lrfmp）' as two_class_name,
       0 as three_class_code,
       'M（历史平均消费金额）' as three_class_name, 
        m_value as feature_name,
        1 as feature_value,
        from_unixtime(unix_timestamp(),'yyyy-MM-dd HH:mm:ss') as etl_time
  from tmp_ol_rs_meta_feature_lrfmp_model_4
 where m_value>0
union all
select 
       cust_id,
       0 as one_class_code,
       '行为特征' as one_class_name,
       0 as two_class_code,
       '用户商业价值（度假lrfmp）' as two_class_name,
       0 as three_class_code,
       'P（历史平均消费利润）' as three_class_name, 
        p_value as feature_name,
        1 as feature_value,
        from_unixtime(unix_timestamp(),'yyyy-MM-dd HH:mm:ss') as etl_time
  from tmp_ol_rs_meta_feature_lrfmp_model_4
 where p_value>0
union all
select 
       cust_id,
       0 as one_class_code,
       '行为特征' as one_class_name,
       0 as two_class_code,
       '用户商业价值（度假lrfmp）' as two_class_name,
       0 as three_class_code,
       'lrfmp值' as three_class_name, 
       (l_value + m_value + f_value + r_value + p_value) as feature_name,
       1 as feature_value,
       from_unixtime(unix_timestamp(),'yyyy-MM-dd HH:mm:ss') as etl_time
  from tmp_ol_rs_meta_feature_lrfmp_model_4
 where l_value>0 or r_value>0 or f_value>0 or m_value>0 or p_value>0
;

