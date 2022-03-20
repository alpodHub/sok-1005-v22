#!/usr/bin/env python
# coding: utf-8

# In[ ]:


# SOK-1005
# Kandidatnr: 72


# In[6]:


# import blotto
import numpy as np


# In[7]:


def player_strategy(n_battalions,n_fields):
    battalions = np.random.multinomial(100, np.ones(6)/6, size=1)[0]

    #asserting that all and no more than all battalions are used:
    battalions=battalions[np.random.rand(n_fields).argsort()]
    assert sum(battalions)==n_battalions
    
    return battalions


# In[8]:


def computer_strategy(n_battalions,n_fields):
    battalions=np.zeros(n_fields,dtype=int)
    battalions[0:1]=8
    battalions[1:4]=30
    battalions[4:]=1
    assert sum(battalions)==n_battalions
    return battalions


# In[9]:


# blotto.run(6, 100, player_strategy, computer_strategy)


# In[10]:


def call_battle(n_battalions,n_fields, player_strategy, computer_strategy):
    c_battlions=computer_strategy(n_battalions,n_fields)
    p_battlions=player_strategy(n_battalions,n_fields)

    diff=p_battlions-c_battlions
    points=sum(diff>0)-sum(diff<0)
 
    return int(points>0)-int(points<0)


# In[11]:


def test_strategies(n_fields,n_battalions,player_strategy, computer_strategy):
    n_tests=100000
    r=0
    record=[]
    for i in range(n_tests):
        p=call_battle(n_battalions,n_fields,
            player_strategy, computer_strategy)
        record.append(p)
        r+=p
    return r/n_tests

test_strategies(6,100,player_strategy, computer_strategy)

