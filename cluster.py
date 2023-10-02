#################################################### 绘制用户各等级占比分布的饼图 #######################################

import plotly.express as px
import pandas as pd
from collections import Counter

# 数据集rfm
fig = px.pie(rfm, names='rfm_value', values='rfm_level_num', title='RFM Clustering Result',
             hole=0.3, color_discrete_sequence=px.colors.sequential.Teal)
fig.update_traces(textinfo='percent+label')  # textposition='inside'
fig.update_layout(width=500, height=500, showlegend=False, title_x=0.5, title_y=0.95, margin=dict(t=2))
fig.show()



##################################################### K-Means聚类 #####################################################
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



##################################################### 聚类结果可视化 #####################################################

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



##################################################### 绘制用户各层占比分布的饼图 #####################################################

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


