from flask import Flask
import pickle
#import request
import numpy as np
from datetime import datetime,date
import pandas as pd
app = Flask(__name__)



@app.route('/' ,methods= ['GET','POST'])
def home():
    #if request.method == 'POST':
    current_date = pd.Series([date.today()])
    current_date = pd.to_datetime(current_date)
    day_26 = get_day_26_mapping(current_date)[0]

    model = pickle.load(open('gp_model.pkl','rb'))
    predicted = model.predict_y(np.linspace(datetime.timestamp(day_26)/3600, datetime.timestamp(day_26)/3600, 1).reshape(1, 1) )
    print(predicted[0].numpy()[0][0])
    print(date.today())
    return 'Predicted value: '+str(predicted[0].numpy()[0][0])

@app.route('/api' ,methods= ['GET','POST'])
def predict_spending():
    #if request.method == 'POST':
    predicted_output = {}
    
    #getting current date
    current_date = pd.Series([date.today()])
    current_date = pd.to_datetime(current_date)
    day_26 = get_day_26_mapping(current_date)[0]

    model = pickle.load(open('gp_model.pkl','rb'))
    predicted = model.predict_y(np.linspace(datetime.timestamp(day_26)/3600, datetime.timestamp(day_26)/3600, 1).reshape(1, 1) )
    
    predicted_output['output'] = str(predicted[0].numpy()[0][0])
    return predicted_output


def get_day_26_mapping(date):
    import datetime
    new_date = []
    for m,d,y in zip(date.dt.month,date.dt.day,date.dt.year):
        #print(m,d,y)
        new_d = 0
        new_m = 0
        new_y = 0
        if d<=26:
            new_d = 26
            new_m = m
            new_y = y
        else:
            new_d = 26
            if m+1>12:
                new_d = 26
                new_m = 1
                new_y = y + 1
            else:
                new_d = 26
                new_m = m + 1
                new_y = y
        #print(d,m,y)
        #print(new_d,new_m,)
        new_date.append(datetime.datetime(new_y,new_m,new_d))
    return new_date

if __name__ == '__main__':
    app.run(debug=True)
