# <font color = 'green' > **基于改进的RFM模型对用户价值等级分层** </font>
<br>

## <font color = 'blue' > **一、项目重述** </font>

&emsp;&emsp;现有的对用户价值等级划分方法（`dw.ol_rs_meta_feature_rfm_model`）是根据用户历史的度假签约订单数据，基于RFM模型来衡量用户度假产品的商业价值。本文在RFM模型的基础上，针对RFM模型存在的问题进行改进，提出了LRFMP模型，以期更好地衡量用户在度假产品方面的商业价值，从而对用户分层。  
&emsp;&emsp;首先，进行数据开发，构建LRFMP用户分层模型，得到所有用户的L（生命周期）、R（消费活跃度）、F（消费频率）、M（平均消费金额）、P（平均消费利润）值；然后，汇总得到LRFMP值；最后，LRFMC模型构建之后使用了经典的聚类算法-K-Means算法来对客户进行细分，而不是传统的来与参考值对比进行手工分类，提高准确率和效率，从而实现用户价值等级分层，进行精准的价格和服务设置。

<br>

## <font color = 'blue' > **二、改进的RFM模型** </font>

+ <font size=3>**原始RFM模型分层逻辑：**</font>

&emsp;&emsp;RFM就是一种典型的对客户分类然后针对性营销的模型，是客户关系管理（CRM）领域照片中的一种定量分析模型。它是由R(最近消费时间间隔)、F(消费频次)和M(消费总额)三个指标构成，通过该模型识别出高价值客户。  
&emsp;&emsp;`dw.ol_rs_meta_feature_rfm_model`运用RFM模型，考察用户关于度假订单的相关数据，计算如下指标：

<style type="text/css">
.tg  {border-collapse:collapse;border-spacing:0;}
.tg td{border-color:black;border-style:solid;border-width:1px;font-family:Arial, sans-serif;font-size:14px;
  overflow:hidden;padding:10px 5px;word-break:normal;}
.tg th{border-color:black;border-style:solid;border-width:1px;font-family:Arial, sans-serif;font-size:14px;
  font-weight:normal;overflow:hidden;padding:10px 5px;word-break:normal;}
.tg .tg-baqh{text-align:center;vertical-align:top}
.tg .tg-zm63{background-color:#B7DCFB;font-weight:bold;text-align:center;vertical-align:top}
.tg .tg-amwm{font-weight:bold;text-align:center;vertical-align:top}
.tg .tg-0lax{text-align:left;vertical-align:top}
</style>
<table class="tg">
<thead>
  <tr>
    <th class="tg-zm63"><span style="font-weight:bold">指标</span></th>
    <th class="tg-zm63"><span style="font-weight:bold">含义</span></th>
    <th class="tg-zm63"><span style="font-weight:bold">分值</span></th>
    <th class="tg-zm63"><span style="font-weight:bold">含义</span></th>
  </tr>
</thead>
<tbody>
  <tr>
    <td class="tg-amwm" rowspan="5"><span style="font-weight:bold">R(Recency)</span></td>
    <td class="tg-0lax" rowspan="5">活跃度，指最新一次下单距离当前的时间</td>
    <td class="tg-baqh">3</td>
    <td class="tg-0lax">在[0, 180)半年内签约过度假订单</td>
  </tr>
  <tr>
    <td class="tg-baqh">2.5</td>
    <td class="tg-0lax">在[180, 360)一年内签约过度假订单</td>
  </tr>
  <tr>
    <td class="tg-baqh">2</td>
    <td class="tg-0lax">在[360, 720)两年内签约过度假订单</td>
  </tr>
  <tr>
    <td class="tg-baqh">1.5</td>
    <td class="tg-0lax">在[720, 1080)三年内签约过度假订单</td>
  </tr>
  <tr>
    <td class="tg-baqh">1</td>
    <td class="tg-0lax">在[1080, +∞)三年以上签约过度假订单</td>
  </tr>
  <tr>
    <td class="tg-amwm" rowspan="3"><span style="font-weight:bold">F(</span><span style="font-weight:bold;background-color:#F7F7F7">Frequency</span><span style="font-weight:bold">)</span></td>
    <td class="tg-0lax" rowspan="3">消费频次，指历史累计订单数量</td>
    <td class="tg-baqh">1</td>
    <td class="tg-0lax">度假签约订单量为1</td>
  </tr>
  <tr>
    <td class="tg-baqh">2</td>
    <td class="tg-0lax">度假签约订单量为2</td>
  </tr>
  <tr>
    <td class="tg-baqh">3</td>
    <td class="tg-0lax">度假签约订单量在3单以上，包括3</td>
  </tr>
  <tr>
    <td class="tg-amwm" rowspan="5"><span style="font-weight:bold">M(Money)</span></td>
    <td class="tg-0lax" rowspan="5">消费金额，指历史累计订单总金额</td>
    <td class="tg-baqh">1</td>
    <td class="tg-0lax">消费总金额在(-∞, 2000)之间</td>
  </tr>
  <tr>
    <td class="tg-baqh">1.5</td>
    <td class="tg-0lax">消费总金额在[2000, 7000)之间</td>
  </tr>
  <tr>
    <td class="tg-baqh">2</td>
    <td class="tg-0lax">消费总金额在[7000, 15000)之间</td>
  </tr>
  <tr>
    <td class="tg-baqh">2.5</td>
    <td class="tg-0lax">消费总金额在[15000, 50000)之间</td>
  </tr>
  <tr>
    <td class="tg-baqh">3</td>
    <td class="tg-0lax">消费总金额在[50000, +∞)之间</td>
  </tr>
</tbody>
</table>

&emsp;&emsp;然后将三指标值求和得到用户度假的RFM值，即 $ RFM = R + F + M $。原始数据库中根据RFM取值将用户价值等级分为了13个等级，分别为$ \{3, 3.5, 4, 4.5, 5, 5.5, 6, 6.5, 7, 7.5, 8, 8.5, 9\} $，用户等级分布情况如下图所示。

<div align="center"> 
  <a href="https://raw.githubusercontent.com/5FiveFISH/Figure/main/img/202309270925559.png">
    <img src="https://raw.githubusercontent.com/5FiveFISH/Figure/main/img/202309270925559.png" alt="" width="500" />
  </a>
</div>  

&emsp;&emsp;RFM模型在反映客户消费偏好方面和客户价值方面具有良好的表征性，此处R值越大或者F指越大或者M值越大，客户越有可能与平台达成度假产品的交易。

``` python 
import plotly.express as px
import pandas as pd
from collections import Counter

# 用户各等级占比分布
fig = px.pie(rfm, names='rfm_value', values='rfm_level_num', title='RFM Clustering Result',
             hole=0.3, color_discrete_sequence=px.colors.sequential.Teal)
fig.update_traces(textinfo='percent+label')  # textposition='inside'
fig.update_layout(width=500, height=500, showlegend=False, title_x=0.5, title_y=0.95, margin=dict(t=2))
fig.show()
```


+ <font size=3>**RFM改进方向：**</font>  
&emsp;&emsp;**传统RFM模型的问题及改进：**  
  1. 仅考虑了一定时间内客户消费的活跃度情况，未考虑到用户的生命周期。在一定时间内，新用户（注册时长低）的活跃度高，但这可能只是昙花一现，粘合度低，长期贡献的消费很低，给平台带来的收入低，那这种用户并不是平台要关注的最优用户。平台应更关注那些注册时长高、活跃度虽然较低，但粘合度高，长期贡献价值高的客户群体。  
   ***改进：*** **在原模型的基础上增加L(Lifetime)来衡量客户的生命周期。**  
  2. 消费总金额是单次消费额的累计，消费次数越多，消费金额相对来说也越高，所以F（消费次数）与M（消费总金额）之间存在多重共线性。  
   ***改进：*** **将M更改为历史度假订单的平均消费金额。**  
  3. 仅考虑消费额，并非考虑的是利润。高的销售额虽然可以提高企业的资金周转率，但是给企业带来根本利益的是利润，高消费金额不一定是高利润，低消费金额不一定是低利润。仅考虑销售额会产生这样的情况：若某两个度假产品的销售额差不多，但两者产生的利润相差很多，那么平台的营销方向更倾向于利润高的度假产品；若两个度假产品的销售额相差较多，高销售额产品的利润很低，而低销售额产品的利润很高，那么平台也更倾向于增加利润高的产品的营销成本投入。  
   ***改进：*** **在原模型的基础上增加P(Profit)，根据利润来衡量客户生命周期的总价值量。**  
<br>

&emsp;&emsp;对RFM进行适当的升级，参考了航空客户价值分析特色**LRFMC模型**，在原来R、F、M三个值的基础上增加了**L(Lifetime)** 生命周期和**P(Profit)** 平均消费利润两个值，形成了本文的**LRFMP**用户分层模型。  

> &emsp;&emsp;航空业最常用的根据客户价值分析特色LRFMC模型，将客户聚类为重要保持客户，重要发展客户，重要挽留客户，一般客户，低价值客户，从而针对每种类别的客户制定对应的价格和服务。
>> LRFMC模型指标含义：
>> + L：会员入会时间距观测窗口结束的月数。
>> + R：客户最近一次乘坐公司飞机距离观测窗口结束的月数。
>> + F：客户在观测窗口内乘坐公司飞机的次数。
>> + M：客户在观测窗口内累计的飞行里程碑。
>> + C：客户在观测窗口内乘坐仓位所对应的折扣系数的平均值。

<style type="text/css">
.tg  {border-collapse:collapse;border-spacing:0;}
.tg td{border-color:black;border-style:solid;border-width:1px;font-family:Arial, sans-serif;font-size:14px;
  overflow:hidden;padding:10px 5px;word-break:normal;}
.tg th{border-color:black;border-style:solid;border-width:1px;font-family:Arial, sans-serif;font-size:14px;
  font-weight:normal;overflow:hidden;padding:10px 5px;word-break:normal;}
.tg .tg-baqh{text-align:center;vertical-align:top}
.tg .tg-zm63{background-color:#B7DCFB;font-weight:bold;text-align:center;vertical-align:top}
.tg .tg-amwm{font-weight:bold;text-align:center;vertical-align:top}
.tg .tg-0lax{text-align:left;vertical-align:top}
</style>
<table class="tg">
<thead>
  <tr>
    <th class="tg-zm63"><span style="font-weight:bold">指标</span></th>
    <th class="tg-zm63"><span style="font-weight:bold">含义</span></th>
    <th class="tg-zm63"><span style="font-weight:bold">分值</span></th>
    <th class="tg-zm63"><span style="font-weight:bold">含义</span></th>
  </tr>
</thead>
<tbody>
  <tr>
    <td class="tg-amwm" rowspan="5"><span style="font-weight:bold">L(Lifetime)</span></td>
    <td class="tg-0lax" rowspan="5">生命周期，指注册时间至当前的时间</td>
    <td class="tg-baqh">3</td>
    <td class="tg-0lax">注册时间在[0, 360)一年内</td>
  </tr>
  <tr>
    <td class="tg-baqh">2.5</td>
    <td class="tg-0lax">注册时间在[360, 720)两年内</td>
  </tr>
  <tr>
    <td class="tg-baqh">2</td>
    <td class="tg-0lax">注册时间在[720, 1080)三年内</td>
  </tr>
  <tr>
    <td class="tg-baqh">1.5</td>
    <td class="tg-0lax">注册时间在[1080, 1800)五年内</td>
  </tr>
  <tr>
    <td class="tg-baqh">1</td>
    <td class="tg-0lax">注册时间在[1800, +∞)五年以上</td>
  </tr>
  <tr>
    <td class="tg-amwm" rowspan="5"><span style="font-weight:bold">R(Recency)</span></td>
    <td class="tg-0lax" rowspan="5">活跃度，指最新一次下单距离当前的时间</td>
    <td class="tg-baqh">3</td>
    <td class="tg-0lax">在[0, 180)半年内签约过度假订单</td>
  </tr>
  <tr>
    <td class="tg-baqh">2.5</td>
    <td class="tg-0lax">在[180, 360)一年内签约过度假订单</td>
  </tr>
  <tr>
    <td class="tg-baqh">2</td>
    <td class="tg-0lax">在[360, 720)两年内签约过度假订单</td>
  </tr>
  <tr>
    <td class="tg-baqh">1.5</td>
    <td class="tg-0lax">在[720, 1080)三年内签约过度假订单</td>
  </tr>
  <tr>
    <td class="tg-baqh">1</td>
    <td class="tg-0lax">在[1080, +∞)三年以上签约过度假订单</td>
  </tr>
  <tr>
    <td class="tg-amwm" rowspan="3"><span style="font-weight:bold">F(</span><span style="font-weight:bold;background-color:#F7F7F7">Frequency</span><span style="font-weight:bold">)</span></td>
    <td class="tg-0lax" rowspan="3">消费频次，指历史累计订单数量</td>
    <td class="tg-baqh">1</td>
    <td class="tg-0lax">度假签约订单量为1</td>
  </tr>
  <tr>
    <td class="tg-baqh">2</td>
    <td class="tg-0lax">度假签约订单量为2</td>
  </tr>
  <tr>
    <td class="tg-baqh">3</td>
    <td class="tg-0lax">度假签约订单量在3单以上，包括3</td>
  </tr>
  <tr>
    <td class="tg-amwm" rowspan="5"><span style="font-weight:bold">M(Money)</span></td>
    <td class="tg-0lax" rowspan="5">平均消费金额，指历史平均订单金额</td>
    <td class="tg-baqh">1</td>
    <td class="tg-0lax">消费总金额在(-∞, 0)之间</td>
  </tr>
  <tr>
    <td class="tg-baqh">1.5</td>
    <td class="tg-0lax">消费总金额在[0, 2000)之间</td>
  </tr>
  <tr>
    <td class="tg-baqh">2</td>
    <td class="tg-0lax">消费总金额在[2000, 7000)之间</td>
  </tr>
  <tr>
    <td class="tg-baqh">2.5</td>
    <td class="tg-0lax">消费总金额在[7000, 20000)之间</td>
  </tr>
  <tr>
    <td class="tg-baqh">3</td>
    <td class="tg-0lax">消费总金额在[20000, +∞)之间</td>
  </tr>
  <tr>
    <td class="tg-amwm" rowspan="5"><span style="font-weight:bold">P(Profit)</span></td>
    <td class="tg-0lax" rowspan="5">平均消费利润，指历史平均订单利润</td>
    <td class="tg-baqh">1</td>
    <td class="tg-0lax">平均消费利润在(-∞, 0)之间</td>
  </tr>
  <tr>
    <td class="tg-baqh">1.5</td>
    <td class="tg-0lax">平均消费利润在[0, 100)之间</td>
  </tr>
  <tr>
    <td class="tg-baqh">2</td>
    <td class="tg-0lax">平均消费利润在[100, 300)之间</td>
  </tr>
  <tr>
    <td class="tg-baqh">2.5</td>
    <td class="tg-0lax">平均消费利润在[300, 1000)之间</td>
  </tr>
  <tr>
    <td class="tg-baqh">3</td>
    <td class="tg-0lax">平均消费利润在[1000, +∞)之间</td>
  </tr>
</tbody>
</table>

<br>

## <font color = 'blue' > **三、构建LRFMP模型** </font>

&emsp;&emsp;该项目的数据开发是在`ol_rs_meta_feature_rfm_model.sh`的基础上进行的修改，开发逻辑基本一致，修改之处在于在原RFM模型特征的基础上增加了***L***生命周期特征和***P***平均利润特征。选取的数据时间范围截止至2023-9-24。

``` sql 
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
```

``` sql 
--剔除黄牛、分销会员
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
```

``` sql 
--计算指标
--L(注册时间 入会至当前时间的时间分段)
--R(活跃度 最新一次下单距离当前的时间分段)
--F(消费频次 历史累计订单数量分段)
--M(历史平均消费金额 历史平均累计订单金额分段)
--P(历史平均消费利润 历史平均累计订单利润分段)

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
```

``` sql 
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
```

``` sql 
--结果进表
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
```

&emsp;&emsp;根据LRFMP值将用户价值等级分为了21个等级，分别为 $ \{5, 5.5, 6, 6.5, 7, 7.5, 8, 8.5, 9, 9.5, 10, 10.5, 11, 11.5, 12, 12.5, 13, 13.5, 14, 14.5, 15\} $，用户等级分布情况如下图所示。

<div align="center"> 
  <a href="https://raw.githubusercontent.com/5FiveFISH/Figure/main/img/202309270928777.png">
    <img src="https://raw.githubusercontent.com/5FiveFISH/Figure/main/img/202309270928777.png" alt="" width="500" />
  </a>
</div>

<br>

## <font color = 'blue' > **四、K-Means聚类** </font>

&emsp;&emsp;聚类就是将物理或抽象对象的集合分成多个相似的数据子集，同一个子集内的对象之间具有较高的相似度，而不同子集内的对象差别较大。K-means算法作为一种基于划分的动态聚类算法，它以距离的误差平方和SSE作为聚类准则函数，具有简单有效、收敛速度较快、便于处理大型数据集等优点。  
&emsp;&emsp;选取LRFMC模型的五个指标，类簇数目为5类，距离度量使用默认的欧式距离，选择“K-means++”方法定义初始聚类中心。

``` python 
import pandas as pd
from sklearn.cluster import KMeans


colnames = ['cust_id', 'rg_days', 'l_value', 'ord_days', 'r_value', 'ord_num', 'f_value', 'gmv', 'm_value', 'profit', 'p_value']
data = pd.read_csv("/opt/****/jupyter/****/tmp_data/tmp_ol_rs_meta_feature_lrfmp_model_4.csv", encoding='utf-8', sep=chr(1), names=colnames, na_values='\\N')
# data

## K-Means聚类
columns = ['l_value', 'r_value', 'f_value', 'm_value', 'p_value']
kmeans = KMeans(n_clusters=5, init='k-means++', n_init=1, max_iter=300, tol=0.0001, random_state=0).fit(data[columns])

# 聚类结果
data['lrfmp'] = kmeans.labels_
data[['cust_id', 'l_value', 'r_value', 'f_value', 'm_value', 'p_value', 'lrfmp']]

# # 聚类中心
# centers = kmeans.cluster_centers_
# print("聚类中心：\n", centers)
# # 误差平方和
# sse = kmeans.inertia_
# print("误差平方和：", sse)
```

&emsp;&emsp;将用户划分为5类，即 $ lrfmp∈\{0, 1, 2, 3, 4\} $，聚类结果如下：

<div align="center"> 
  <a href="https://raw.githubusercontent.com/5FiveFISH/Figure/main/img/202309270938579.png">
    <img src="https://raw.githubusercontent.com/5FiveFISH/Figure/main/img/202309270938579.png" alt="" width="600" />
  </a>
</div>

&emsp;&emsp;对得到的聚类结果进行用户价值分析，按 *L、R、F、M、P* 五个维度绘制这五类用户的基本情况。

``` python 
import matplotlib.pyplot as plt
import numpy as np


cluster_labels = kmeans.labels_  #聚类结果
num_features = 5   # 数据集有5个特征

# 计算每个簇的平均值
cluster_means = []
for cluster_label in set(cluster_labels):
    cluster_data = data[cluster_labels == cluster_label].loc[:, columns]
    cluster_mean = cluster_data.mean().values
    cluster_means.append(cluster_mean)

# 转换成numpy数组
cluster_means = np.array(cluster_means)

# 创建雷达图
labels = columns
angles = np.linspace(0, 2 * np.pi, num_features, endpoint=False).tolist()
angles += angles[:1]

# 设置雷达图的圈的取值
plt.figure(figsize=(8, 6))
ax = plt.subplot(111, polar=True)
ax.set_xticks(angles[:-1])
ax.set_yticks([1, 1.5, 2, 2.5, 3])
ax.set_rlabel_position(0)

# 绘制雷达图
for i in range(len(cluster_means)):
    values = cluster_means[i].tolist()
    values += values[:1]
    plt.polar(angles, values, label=f'Cluster {i}')

# 添加特征标签
plt.xticks(angles[:-1], labels)

# 添加图例
plt.legend(loc='upper right', bbox_to_anchor=(1.3, 1.1))

# 显示雷达图
plt.title('Radar Chart of K-means Clusters')
plt.show()
```

<div align="center"> 
  <a href="https://raw.githubusercontent.com/5FiveFISH/Figure/main/img/202309270929457.png">
    <img src="https://raw.githubusercontent.com/5FiveFISH/Figure/main/img/202309270929457.png" alt="" width="600" />
  </a>
</div>

&emsp;&emsp;**客户价值分析：**

<style type="text/css">
.tg  {border-collapse:collapse;border-spacing:0;}
.tg td{border-color:black;border-style:solid;border-width:1px;font-family:Arial, sans-serif;font-size:14px;
  overflow:hidden;padding:10px 5px;word-break:normal;}
.tg th{border-color:black;border-style:solid;border-width:1px;font-family:Arial, sans-serif;font-size:14px;
  font-weight:normal;overflow:hidden;padding:10px 5px;word-break:normal;}
.tg .tg-xl8s{color:#25272A;text-align:left;vertical-align:top}
.tg .tg-lhgv{color:#25272A;font-weight:bold;text-align:center;vertical-align:top}
.tg .tg-zm63{background-color:#B7DCFB;font-weight:bold;text-align:center;vertical-align:top}
.tg .tg-amwm{font-weight:bold;text-align:center;vertical-align:top}
</style>
<table class="tg">
<thead>
  <tr>
    <th class="tg-zm63"><span style="font-weight:bold">用户价值</span></th>
    <th class="tg-zm63"><span style="font-weight:bold">用户分层</span></th>
    <th class="tg-zm63"><span style="font-weight:bold">群体特征</span></th>
    <th class="tg-zm63"><span style="font-weight:bold">总结与建议</span></th>
  </tr>
</thead>
<tbody>
  <tr>
    <td class="tg-lhgv"><span style="font-weight:bold;color:#25272A">重要保持客户</span></td>
    <td class="tg-amwm"><span style="font-weight:bold">Cluster 4</span></td>
    <td class="tg-xl8s"><span style="color:#25272A">L（生命周期）较高</span><br><span style="color:#25272A">R（活跃度）高</span><br><span style="color:#25272A">F（消费频率）高</span><br><span style="color:#25272A">M（平均消费金额）较高</span><br><span style="color:#25272A">P（平均利润）较高</span></td>
    <td class="tg-xl8s"><span style="color:#25272A">最优先的目标，</span><br><span style="color:#25272A">这类用户各项数据均较高，说明用户对平台的粘性很高，进行差异化管理，延长用户生命周期，提高满意度。</span></td>
  </tr>
  <tr>
    <td class="tg-lhgv"><span style="font-weight:bold;color:#25272A">重要发展客户</span></td>
    <td class="tg-amwm"><span style="font-weight:bold">Cluster 0</span></td>
    <td class="tg-xl8s"><span style="color:#25272A">L（生命周期）高</span><br><span style="color:#25272A">R（活跃度）低</span><br><span style="color:#25272A">F（消费频率）高</span><br><span style="color:#25272A">M（平均消费金额）较高</span><br><span style="color:#25272A">P（平均利润）较高</span></td>
    <td class="tg-xl8s"><span style="color:#25272A">这类用户的消费频率和价值均较高，但活跃度低，有很大的发展潜力，考虑对该群体进行重点维护，提高用户活跃度。</span></td>
  </tr>
  <tr>
    <td class="tg-lhgv"><span style="font-weight:bold;color:#25272A">重要挽留客户</span></td>
    <td class="tg-amwm"><span style="font-weight:bold">Cluster 3</span></td>
    <td class="tg-xl8s"><span style="color:#25272A">L（生命周期）高</span><br><span style="color:#25272A">R（活跃度）低</span><br><span style="color:#25272A">F（消费频率）低</span><br><span style="color:#25272A">M（平均消费金额）高</span><br><span style="color:#25272A">P（平均利润）高</span></td>
    <td class="tg-xl8s"><span style="color:#25272A">虽然这类用户的活跃度和消费频率低，但其生命周期和用户价值高，考虑增加与这类客户的互动，了解情况，提高用户的活跃度和消费频率，提高该群体对平台的粘性。</span></td>
  </tr>
  <tr>
    <td class="tg-lhgv"><span style="font-weight:bold;color:#25272A">一般客户</span></td>
    <td class="tg-amwm"><span style="font-weight:bold">Cluster 2</span></td>
    <td class="tg-xl8s"><span style="color:#25272A">L（生命周期）低</span><br><span style="color:#25272A">R（活跃度）高</span><br><span style="color:#25272A">F（消费频率）较低</span><br><span style="color:#25272A">M（平均消费金额）较低</span><br><span style="color:#25272A">P（平均利润）中等</span></td>
    <td class="tg-xl8s"><span style="color:#25272A">虽然这类用户的活跃度很高，但该群体的生命周期短，且用户价值不高，大多为注册不久、且有度假产品购买意向的新用户，他们可能在产品有活动促销时会进行消费，可以进行精准营销。</span></td>
  </tr>
  <tr>
    <td class="tg-lhgv"><span style="font-weight:bold;color:#25272A">低价值客户</span></td>
    <td class="tg-amwm"><span style="font-weight:bold">Cluster 1</span></td>
    <td class="tg-xl8s"><span style="color:#25272A">L（生命周期）高</span><br><span style="color:#25272A">R（活跃度）低</span><br><span style="color:#25272A">F（消费频率）低</span><br><span style="color:#25272A">M（平均消费金额）低</span><br><span style="color:#25272A">P（平均利润）低</span></td>
    <td class="tg-xl8s"><span style="color:#25272A">该群体各方面的数据都是比较低的，可能是注册时间很久、平台使用频率不高或已不再使用的用户。</span></td>
  </tr>
</tbody>
</table>

<div align="center"> 
  <a href="https://raw.githubusercontent.com/5FiveFISH/Figure/main/img/202309270929397.png">
    <img src="https://raw.githubusercontent.com/5FiveFISH/Figure/main/img/202309270929397.png" alt="" width="500" />
  </a>
</div>

&emsp;&emsp;上图是使用K-Means聚类的5类用户分布情况。约为一半的用户为低价值客户，占比最大；重要保持客户占比最少，仅有2.87%的用户；重要发展客户和重要挽留客户占比相差不大，均在20%左右。

``` python 
import plotly.express as px
import pandas as pd
from collections import Counter


# 创建标签映射字典
label_mapping = {
    4: "重要保持客户",
    0: "重要发展客户",
    3: "重要挽留客户",
    2: "一般客户",
    1: "低价值客户"
}
# 使用字典将原始标签映射为新的类别名称
new_labels = [label_mapping[label] for label in cluster_labels]
# 使用Counter统计每个簇的样本数量
cluster_counts = dict(Counter(new_labels))

# 将统计结果转换为DataFrame
cluster_df = pd.DataFrame({'Cluster': list(cluster_counts.keys()), 'Count': list(cluster_counts.values())})

# 用户分层分布情况
fig = px.pie(cluster_df, names='Cluster', values='Count', title='K-means Clustering Result',
             hole=0.3, color_discrete_sequence=px.colors.sequential.Teal)
fig.update_traces(textinfo='percent+label', rotation=90)  # textposition='inside'
fig.update_layout(width=500, height=500, showlegend=False, title_x=0.5, title_y=0.95, margin=dict(t=2))
fig.show()
```

<br>

