#!/usr/bin/env python
# coding: utf-8

# In[ ]:





# In[6]:


import numpy as np
import pandas as pd
#import matplotlib.pyplot as plt
from pyxlsb import convert_date
import warnings
warnings.filterwarnings('ignore')


# In[7]:


##


# In[8]:


data = pd.read_excel('1_英国2020年12月7日-2021年4月30日疫情数据.xlsx', header=0)


# In[9]:


data = data.rename(columns={
    '日期':'date', '新增确诊人数':'newly_confirmed', '累计确诊人数':'cumulative_confirmed', 
    '现有确诊人数':'existing_confirmed', '累计治愈人数':'cumulative_cured', 
    '新增治愈人数':'new_cured', '累计死亡人数':'cumulative_death',
       '新增死亡人数':'new_death_toll'})


# In[10]:


data["date"] = data['date'].apply(lambda x: convert_date(x))
data = data.sort_values(by="date")


# In[11]:


data.info()


# In[12]:


data.describe()


# In[13]:


#Missing Data Points
data.isnull().sum()


# In[14]:


###
data['date'].min()


# In[15]:


###
data['date'].max()


# In[ ]:





# In[16]:


import pandas as pd 
import numpy as np 
import plotly_express as px 
import plotly.graph_objects as go 
from plotly.subplots import make_subplots 
get_ipython().run_line_magic('matplotlib', 'inline')
from sklearn import metrics
from xgboost import XGBRegressor 
import warnings 
warnings.filterwarnings('ignore')


# In[ ]:





# In[17]:


#EDA


# In[18]:


# Boxplots


# In[19]:


plot_data1 = data.copy()
plot_data1 = plot_data1.set_index('date')
plot_data1.head()


# In[20]:


cum_data1 = plot_data1[['newly_confirmed', 'new_cured', 'new_death_toll']].stack()
cum_data1 = cum_data1.reset_index()
cum_data1 = cum_data1.rename(columns={'level_1':'level',0:'Cases'})
cum_data1.head()


# In[21]:


fig = px.box(cum_data1[cum_data1['level']=='newly_confirmed'], 
             x='level', y='Cases', color='level', title='')#'COVID19 Cases')
fig.update_layout(hovermode='closest', template='seaborn', width=550, height = 600,
                  xaxis=dict(mirror=True,linewidth=2,linecolor='black',showgrid=True,showticklabels= False),
                 yaxis=dict(mirror=True,linewidth=2,linecolor='black'),
                 legend=dict( yanchor="top", y=0.8, xanchor="right", x=0.5),
                 legend_font=dict(size=18))
fig.show()


# In[22]:


fig = px.box(cum_data1[cum_data1['level'] != 'newly_confirmed'], 
             x='level', y='Cases', color='level', title='')#'COVID19 Cases')
fig.update_layout(hovermode='closest', template='seaborn', width=700, height = 600,
                  xaxis=dict(mirror=True,linewidth=2,linecolor='black',showgrid=True, showticklabels= False),
                 yaxis=dict(mirror=True,linewidth=2,linecolor='black'),
                 legend=dict( yanchor="top", y=0.8, xanchor="right", x=0.4),
                 legend_font=dict(size=20))
fig.show()


# In[ ]:





# In[23]:


#Line


# In[24]:


plot_data1.columns


# In[25]:


cum_data2 = plot_data1[['cumulative_confirmed', 'existing_confirmed', 'cumulative_cured', 'cumulative_death']]#.stack()
cum_data2 = cum_data2.reset_index()
cum_data2 = cum_data2.rename(columns={'level_1':'level',0:'Cases'})
cum_data2.head()


# In[26]:


fig = make_subplots(specs=[[{"secondary_y": True}]])
fig.add_trace(go.Scatter(name='Cumulative Confirmed Cases',x=cum_data2.date, y= cum_data2.cumulative_confirmed , 
                         mode='lines', line=dict(width=0.5,color='#EA4335')),
              secondary_y=False)
fig.add_trace(go.Scatter(name='Cumulative Cured Cases',x=cum_data2.date,y= cum_data2.cumulative_cured , 
                         mode='lines', line=dict(width=0.5,color='#4285F4')),
              secondary_y=True)

fig.update_yaxes(title_text='Confirmed Cases', title_font=dict(color='#EA4335'), secondary_y=False,nticks=5,
                 tickfont=dict(color='#EA4335'),linewidth=5,linecolor='black',gridcolor='darkgray',
                 zeroline=False)

fig.update_yaxes(title_text='Cured Cases',title_font=dict(color='#4285F4'),secondary_y=True,nticks=5,
                 tickfont=dict(color='#4285F4'),linewidth=4,linecolor='black',gridcolor='darkgray',
                 zeroline=False)

fig.update_layout(title='',height=500,width=800, margin=dict(l=0,r=0,t=60,b=30),hovermode='x', 
                  legend=dict(x=0.01,y=0.99,bordercolor='black',borderwidth=1,bgcolor='#EED8E4',
                              font=dict(family='arial',size=10)),
                  xaxis=dict(mirror=True,linewidth=2,linecolor='black',gridcolor='darkgray'),
                  plot_bgcolor='rgb(255,255,255)',
                 legend_font=dict(size=20))
fig.show()


# In[27]:


fig = make_subplots(specs=[[{"secondary_y": True}]])
fig.add_trace(go.Scatter(name='Cumulative Confirmed Cases',x=cum_data2.date, y= cum_data2.cumulative_confirmed , 
                         mode='lines', line=dict(width=0.5,color='#EA4335')),
              secondary_y=False)
fig.add_trace(go.Scatter(name='Cumulative Deaths',x=cum_data2.date,y= cum_data2.cumulative_death, 
                         mode='lines', line=dict(width=0.5,color='#4285F4')),
              secondary_y=True)

fig.update_yaxes(title_text='Cumulative Confirmed Cases', title_font=dict(color='#EA4335'), secondary_y=False,nticks=5,
                 tickfont=dict(color='#EA4335'),linewidth=4,linecolor='black',gridcolor='darkgray',
                 zeroline=False)

fig.update_yaxes(title_text='Deaths',title_font=dict(color='#4285F4'),secondary_y=True,nticks=5,
                 tickfont=dict(color='#4285F4'),linewidth=4,linecolor='black',gridcolor='darkgray',
                 zeroline=False)

fig.update_layout(title='',height=500,width=800, margin=dict(l=0,r=0,t=60,b=30),hovermode='x', 
                  legend=dict(x=0.01,y=0.99,bordercolor='black',borderwidth=1,bgcolor='#EED8E4',
                              font=dict(family='arial',size=10)),
                  xaxis=dict(mirror=True,linewidth=2,linecolor='black',gridcolor='darkgray'),
                  plot_bgcolor='rgb(255,255,255)',
                 legend_font=dict(size=20))
fig.show()


# In[28]:


#Daily


# In[29]:


cum_data3 = plot_data1[['newly_confirmed', 'new_cured', 'new_death_toll']].stack()
cum_data3 = cum_data3.reset_index()
cum_data3 = cum_data3.rename(columns={'level_1':'level',0:'Cases'})
cum_data3.head()


# In[30]:


fig = px.line(cum_data3, x='date', y='Cases', color='level', title='COVID19 Cases', log_y=False)
fig.update_layout(hovermode='closest', template='seaborn', width=1000, height = 600,
                  xaxis=dict(mirror=True,linewidth=2,linecolor='black',showgrid=True),
                 yaxis=dict(mirror=True,linewidth=2,linecolor='black'),
                 legend=dict( yanchor="top", y=0.99, xanchor="right", x=0.9))
fig.show()


# In[31]:


fig = px.bar(cum_data3, x='date', y='Cases', color='level', title='COVID19 Cases', log_y=False, barmode="group")
fig.update_layout(hovermode='closest', template='seaborn', width=1000, height = 600,
                  xaxis=dict(mirror=True,linewidth=2,linecolor='black',showgrid=True),
                 yaxis=dict(mirror=True,linewidth=2,linecolor='black'),
                 legend=dict( yanchor="top", y=0.99, xanchor="right", x=0.9))
fig.show()


# In[ ]:





# In[32]:


#MA


# In[33]:


def rolling_mean_graph(df,x,y1,y2,title,days=7):
    #colors = dict(case='#4285F4',death='#EA4335')
    df['cases_rolling_avg'] = df[y1].rolling(days).mean()
    df['deaths_rolling_avg'] = df[y2].rolling(days).mean()
    #fig = plt.figure(figsize=(15, 5))
    fig = make_subplots(specs=[[{"secondary_y": True}]])
    fig.add_trace(go.Scatter(name='Daily Cases',x=df[x],y=df[y1],mode='lines',
                             line=dict(width=0.5,color='#4285F4')),
                 secondary_y=False)
    fig.add_trace(go.Scatter(name='Daily Deaths',x=df[x],y=df[y2],mode='lines',
                             line=dict(width=0.5,color='#EA4335')),
                 secondary_y=True)
    fig.add_trace(go.Scatter(name='Cases: <br>'+str(days)+'-Day Rolling average',
                             x=df[x],y=df['cases_rolling_avg'],mode='lines',
                             line=dict(width=3,color='#4285F4')),
                 secondary_y=False)
    fig.add_trace(go.Scatter(name='Deaths: <br>'+str(days)+'-Day rolling average',
                             x=df[x],y=df['deaths_rolling_avg'],mode='lines',
                             line=dict(width=3,color='#EA4335')),
                 secondary_y=True)
    
    fig.update_yaxes(title_text='Cases',title_font=dict(color='#4285F4'),secondary_y=False,nticks=5,
                     tickfont=dict(color='#4285F4'),linewidth=2,linecolor='black',gridcolor='darkgray',
                    zeroline=False)
    fig.update_yaxes(title_text='Deaths',title_font=dict(color='#EA4335'),secondary_y=True,nticks=5,
                     tickfont=dict(color='#EA4335'),linewidth=2,linecolor='black',gridcolor='darkgray',
                    zeroline=False)

    fig.update_layout(title=title,height=500,width=900,
                      margin=dict(l=0,r=0,t=60,b=30),hovermode='x',
                      legend=dict(x=0.51,y=0.89,bordercolor='black',borderwidth=1,bgcolor='#EED8E4',
                                  font=dict(family='arial',size=10)),
                     xaxis=dict(mirror=True,linewidth=2,linecolor='black',gridcolor='darkgray'),
                     plot_bgcolor='rgb(255,255,255)',
                 legend_font=dict(size=20))
    return fig


# In[34]:


fig = rolling_mean_graph(
    data,
    'date',
    'newly_confirmed',
    'new_death_toll',
    '<b>Daily Cases & Deaths</b><br>   With 7-Day Rolling averages')
fig.show()


# In[ ]:





# In[35]:


#data['log(ConfirmedCases)'] = np.log(data.cumulative_confirmed + 1) # Added 1 to remove error due to log(0)
#data['log(Fatalities)'] = np.log(data.cumulative_death + 1)


# In[36]:


#plot_data2 = data.copy()
#plot_data2 = plot_data2.set_index('date')
#plot_data2['log(ConfirmedCases)'] = np.log(plot_data2.cumulative_confirmed + 1) # Added 1 to remove error due to log(0)
#plot_data2['log(Fatalities)'] = np.log(plot_data2.cumulative_death + 1)
#plot_data2.head()


# In[37]:


#cum_data5 = plot_data2[['log(ConfirmedCases)','log(Fatalities)']].stack()
#cum_data5 = cum_data5.reset_index()
#cum_data5 = cum_data5.rename(columns={'level_1':'level',0:'Cases'})
#cum_data5.head()


# In[38]:


#fig = px.line(cum_data5, x='date',y='Cases', color='level', title='COVID19 Cases', log_y=False)
#fig.update_layout(hovermode='closest', template='seaborn', width=1000, height = 600,
 #                 xaxis=dict(mirror=True,linewidth=2,linecolor='black',showgrid=True),
  #               yaxis=dict(mirror=True,linewidth=2,linecolor='black'),
   #              legend=dict( yanchor="top", y=0.99, xanchor="right", x=0.9))
#fig.show()


# In[ ]:





# In[39]:


#Mortality


# In[40]:


data['Mortality Rate%'] = round((data.new_death_toll/data.newly_confirmed)*100,2)


# In[41]:


fig = px.line(data, x='date', y='Mortality Rate%', 
              title='Mortality Rate%')
fig.update_layout(hovermode='closest',template='seaborn', width=1000, height=600, 
                  xaxis=dict(mirror=True,linewidth=2,linecolor='black',showgrid=False),
                 yaxis=dict(mirror=True,linewidth=2,linecolor='black'))
fig.show()


# In[ ]:





# In[42]:


#Feature Engineering


# In[43]:


data.corr()


# In[ ]:





# In[ ]:





# In[ ]:





# In[44]:


#Preprocess


# In[45]:


def date_extract(df):
    df['day'] = df['date'].dt.day
    df['month'] = df['date'].dt.month
    df['dayofweek'] = df['date'].dt.dayofweek
    df['dayofyear'] = df['date'].dt.dayofyear
    df['quarter'] = df['date'].dt.quarter
    df['weekofyear'] = df['date'].dt.weekofyear
    return df


# In[46]:


model_data = data[['date', 'newly_confirmed', 'new_death_toll']].copy()
model_data = date_extract(model_data)
model_data = model_data[['date', 'day', 'month', 'dayofweek', 'dayofyear', 'quarter', 'weekofyear', 
                        'newly_confirmed', 'new_death_toll']]


# In[47]:


model_data.head()


# In[ ]:





# In[48]:


#aa = model_data.head()
#bb = pd.DataFrame(data=aa)
#bb.to_csv("say.csv")


# In[ ]:





# In[49]:


from sklearn.model_selection import TimeSeriesSplit
from sklearn.metrics import r2_score, explained_variance_score, mean_absolute_error, mean_squared_error
#from sklearn.tree import DecisionTreeRegressor
from sklearn import linear_model

tscv = TimeSeriesSplit(n_splits=6)


# In[50]:


y_list_conf = pd.DataFrame()
y_list_fatl = pd.DataFrame()

exp_var1 = []
exp_var2 = []

ma_e1 = []
ma_e2 = []

r2_1 = []
r2_2 = []

mse_1 = []
mse_2 = []

num_scores = 0

for train_index, test_index in tscv.split(model_data):
    print("TRAIN len:", len(train_index), "TEST length:", len(test_index))
    X_train, X_test = model_data.iloc[train_index,[1,2,3,4,5,6]], model_data.iloc[test_index,[1,2,3,4,5,6]]
    y_train, y_test = model_data.iloc[train_index,7], model_data.iloc[test_index,7]
    y_train2, y_test2 = model_data.iloc[train_index,8], model_data.iloc[test_index,8]

    #model1 for predicting Confirmed Cases
    model1 = XGBRegressor(n_estimators=10000, eta=0.05, booster='gbtree', gamma=0.9)
    model1.fit(X_train, y_train)
    
    #model2 for predicting Fatalities
    model2 = XGBRegressor(n_estimators=10000, eta=0.05, booster='gbtree', gamma=0.9) #DecisionTreeRegressor(max_depth=200)
    model2.fit(X_train, y_train2)
    
    #Get the predictions
    y_pred1 = model1.predict(X_test)
    y_pred2 = model2.predict(X_test)
    
    y_list_conf[num_scores] = y_pred1
    y_list_fatl[num_scores] = y_pred2
    
    exp_var1.append(explained_variance_score(y_test, y_pred1))#best possible score is 1.0, lower values are worse
    exp_var2.append(explained_variance_score(y_test2, y_pred2))
    
    ma_e1.append(mean_absolute_error(y_test, y_pred1))
    ma_e2.append(mean_absolute_error(y_test, y_pred1))
    
    r2_1.append(r2_score(y_test, y_pred1))# Best possible score is 1.0 & can be negative (coz model can be arbitrarily worse)
    r2_2.append(r2_score(y_test2, y_pred2))
    
    mse_1.append(mean_squared_error(y_test, y_pred1))
    mse_2.append(mean_squared_error(y_test2, y_pred2))
    
    num_scores += 1


# In[51]:


#Newly Confirmed Cases
print('explained_variance: ', round(sum(exp_var1)/num_scores,4))    
print('r2: ', round(sum(r2_1)/num_scores,4))
print('MAE: ', round(sum(ma_e1)/num_scores,4))
print('MSE: ', round(sum(mse_1)/num_scores,4))
print('RMSE: ', round(sum(np.array([np.sqrt(x) for x in mse_1]))/num_scores), 4)


# In[52]:


#Death Toll
print('explained_variance: ', round(sum(exp_var2)/num_scores,4))    
print('r2: ', round(sum(r2_2)/num_scores,4))
print('MAE: ', round(sum(ma_e2)/num_scores,4))
print('MSE: ', round(sum(mse_2)/num_scores,4))
print('RMSE: ', round(sum(np.array([np.sqrt(x) for x in mse_2]))/num_scores), 4)


# In[53]:


y_list_conf.head(2)


# In[54]:


y_list_fatl.head(2)


# In[55]:


#model_data_pred = model_data.iloc[test_index,:]
#model_data_pred['Predicted New Confirmed'] = np.array(y_list_conf.mean(axis=1))
#model_data_pred['Predicted Death'] = np.array(y_list_fatl.mean(axis=1))

#There is a higher variation if we use the time split approach that caters for means across the prediction so we
#proceed with using the indexing based upon indices of final split of the timeSplitmodel implemented above


# In[ ]:





# In[56]:


#Index Based


# In[57]:


train_index = range(127)
teat_index = range(127, len(model_data)+1)
#range([x for x in range(int(len(model_data)*0.8))][-1]+1,len(model_data)+1)

#print("TRAIN:", train_index, "TEST:", test_index)
X_train, X_test = model_data.iloc[train_index,[1,2,3,4,5,6]], model_data.iloc[test_index,[1,2,3,4,5,6]]
y_train, y_test = model_data.iloc[train_index,7], model_data.iloc[test_index,7]
y_train2, y_test2 = model_data.iloc[train_index,8], model_data.iloc[test_index,8]

#model1 for predicting Confirmed Cases
model1 = XGBRegressor(n_estimators=10000, eta=0.01, booster='gbtree', gamma=0.9)
model1.fit(X_train, y_train)

#model2 for predicting Fatalities
model2 = XGBRegressor(n_estimators=10000, eta=0.01, booster='gbtree', gamma=0.9) #DecisionTreeRegressor(max_depth=200)
model2.fit(X_train, y_train2)

#Get the predictions
y_pred1 = model1.predict(X_test)
y_pred2 = model2.predict(X_test)

print('explained_variance: ',explained_variance_score(y_test, y_pred1))#best possible score is 1.0, lower values are worse
print('explained_variance: ',explained_variance_score(y_test2, y_pred2))

print('MAE: ',mean_absolute_error(y_test, y_pred1))
print('MAE :',mean_absolute_error(y_test, y_pred2))

print('R_2: ', r2_score(y_test, y_pred1))# Best possible score is 1.0 & can be negative (coz model can be arbitrarily worse)
print('R_2: ',r2_score(y_test2, y_pred2))

print('MSE :', mean_squared_error(y_test, y_pred1))
print('MSE :', mean_squared_error(y_test2, y_pred2))

print('RMSE: ', np.sqrt(mean_squared_error(y_test, y_pred1)))
print('RMSE: ', np.sqrt(mean_squared_error(y_test, y_pred2)))


# In[58]:


met_all = pd.DataFrame()


met_all['explained_variance New Confirmed'] = pd.Series(explained_variance_score(y_test, y_pred1))
met_all['explained_variance Death'] = pd.Series(explained_variance_score(y_test2, y_pred2))

met_all['MAE New Confirmed'] = pd.Series(mean_absolute_error(y_test, y_pred1))
met_all['MAE Death'] = pd.Series(mean_absolute_error(y_test, y_pred2))

met_all['R_2 New Confirmed'] = pd.Series(r2_score(y_test, y_pred1))
met_all['R_2 Death'] = pd.Series(r2_score(y_test2, y_pred2))

met_all['MSE New Confirmed'] = pd.Series(mean_squared_error(y_test, y_pred1))
met_all['MSE Death'] = pd.Series(mean_squared_error(y_test2, y_pred2))

met_all['RMSE New Confirmed'] = pd.Series(np.sqrt(mean_squared_error(y_test, y_pred1)))
met_all['RMSE Death'] = pd.Series(np.sqrt(mean_squared_error(y_test, y_pred2)))


# In[59]:


met_all


# In[60]:


#met_all.T.to_csv("say.csv")


# In[ ]:





# In[61]:


model_data_pred = model_data.iloc[test_index,:]
model_data_pred['Predicted New Confirmed'] = np.round(y_pred1,0)
model_data_pred['Predicted Death'] = np.round(y_pred2,0)


# In[62]:


model_data_pred


# In[63]:


#Training and Prediction


# In[64]:


fig = go.Figure(data=[
    go.Bar(name='New Confirmed', x=model_data_pred['date'], y=model_data_pred['newly_confirmed']),
    go.Bar(name='New Confirmed Forecasted', x=model_data_pred['date'], y=model_data_pred['Predicted New Confirmed'])
])
# Change the bar mode
fig.update_layout(barmode='group', title='New Confirmed Cases + Predicted New Confirmed Cases',
                 legend=dict( yanchor="top", y=0.99, xanchor="right", x=0.9))
fig.show()


# In[ ]:





# In[65]:


fig = go.Figure(data=[
    go.Bar(name='New Deaths', x=model_data_pred['date'], y=model_data_pred['new_death_toll']),
    go.Bar(name='New Deaths Forecasted', x=model_data_pred['date'], y=model_data_pred['Predicted Death'])
])
# Change the bar mode
fig.update_layout(barmode='group', title='New Deaths + Predicted Deaths',
                 legend=dict( yanchor="top", y=0.99, xanchor="right", x=0.9))
fig.show()


# In[ ]:





# In[ ]:





# In[ ]:





# In[66]:


#Time Split Based


# In[67]:


#model_data_pred = model_data.iloc[test_index,:]
#model_data_pred['Predicted New Confirmed'] = np.array(y_list_conf.mean(axis=1))
#model_data_pred['Predicted Death'] = np.array(y_list_fatl.mean(axis=1))

#Opted for indexing

