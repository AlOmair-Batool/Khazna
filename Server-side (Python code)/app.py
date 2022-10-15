from flask import Flask
from flask import request
import pickle
import numpy as np
import pandas as pd
from datetime import datetime,date
## new 
from nltk.tokenize import RegexpTokenizer
from nltk import pos_tag
import nltk
from nltk.corpus import stopwords
from sklearn.feature_extraction.text import TfidfVectorizer
import re
import tensorflow as tf
import gpflow
from firebase_admin import credentials
from firebase_admin import firestore
import firebase_admin
#import matplotlib.pyplot as plt
import firebase_admin
from firebase_admin import credentials
import json
import os

app = Flask(__name__)



@app.route('/' ,methods= ['GET','POST'])
def home():
    #if request.method == 'POST':
    current_date = pd.Series([date.today()])
    current_date = pd.to_datetime(current_date)
    day_26 = get_day_26_mapping(current_date)[0]

    #model = trained_model()
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
    first_day_26 = get_day_26_mapping(current_date)[0]
    last_day_26 = get_day_26_mapping(current_date,True)[0]

    model = pickle.load(open('gp_model.pkl','rb'))
    predicted = model.predict_y(np.linspace(datetime.timestamp(first_day_26)/3600, datetime.timestamp(last_day_26)/3600,24).reshape(24, 1))
    
    predicted_output['output'] = str(sum(predicted[0]).numpy()[0])
    return predicted_output


def get_day_26_mapping(date, last=False):
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

        if(last):
            new_date.append(datetime.datetime(new_y,new_m,new_d,23,59,59))
        else:
            new_date.append(datetime.datetime(new_y,new_m,new_d,0,0,0))
            
        return new_date
####new 
        
@app.route('/type' ,methods= ['GET','POST'])
def predict_msg_type():
    
    request_data = request.get_json()
    test_msg1 = request_data['msg']
    predicted_msg_type = {}

    if check_language(test_msg1) == 'English':
        #getting current date
        msg = prepare_all(test_msg1)

        model = pickle.load(open('SVM_model.pkl','rb'))
        predicted = model.predict(msg)
        predicted_msg_type['msg_type'] = str(predicted[0])
    else:
        model = pickle.load(open('SVM_model_Ar.pkl','rb'))
        predicted = model.predict([test_msg1])
        predicted_msg_type['msg_type'] = str(predicted[0])
        

    return predicted_msg_type

def check_language(msg):
    arr_msg = msg.split(' ')[0];
    regexPattern = "^[A-Za-z0-9]+";
    if re.search(regexPattern,arr_msg) and arr_msg != '':
        return "English"
    return "Arabic"
    

def remove_arabic(msg):
    arr_msg = msg.split(' ');
    regexPattern = "^[A-Za-z0-9]+";
    english_arr_msg = [ i for i in arr_msg if re.search(regexPattern,i) and i != '']
    space = " "
    return space.join(english_arr_msg)

def prepare_predict_msg(test_msg):
    transactions = pd.read_csv("newtransactions.csv",encoding='latin-1')
    transactions.columns = transactions.columns.str.replace('ï»¿', '')

    
    test_msg_lower = test_msg.lower()
    test_msg_lower_no_arabic =  remove_arabic(test_msg_lower)
    tokenizer = RegexpTokenizer("[\w+|\$[\d\.]+|\S+]+")
    test_msg_tokenize = tokenizer.tokenize(test_msg_lower_no_arabic) 

    nltk.download('wordnet')
    nltk.download('omw-1.4')
    nltk.download('averaged_perceptron_tagger')
    nltk.download('stopwords')

    Final_words = []

    for word, tag in pos_tag(test_msg_tokenize):
        # Below condition is to check for Stop words and consider only alphabets
        if word not in stopwords.words('english') and word.isalpha():
            Final_words.append(word)
    # The final processed set of words for each iteration will be stored in 'sms_final'
    test_msg_tokenize_final = str(Final_words)
    

    return test_msg_tokenize_final

def prepare_all(test_msg):
    transactions = pd.read_csv("newtransactions.csv",encoding='latin-1')
    transactions.columns = transactions.columns.str.replace('ï»¿', '')

    
    transactions['sms'] = [entry.lower() for entry in transactions['sms']]
    transactions['sms'] = [remove_arabic(entry) for entry in transactions['sms']]
    tokenizer = RegexpTokenizer("[\w+|\$[\d\.]+|\S+]+")        
    transactions['sms']= [tokenizer.tokenize(entry) for entry in transactions['sms']]

    nltk.download('wordnet')
    nltk.download('omw-1.4')
    nltk.download('averaged_perceptron_tagger')
    nltk.download('stopwords')


    for index,entry in enumerate(transactions['sms']):
        # Declaring Empty List to store the words that follow the rules for this step
        Final_words = []
        # Initializing WordNetLemmatizer()
        # pos_tag function below will provide the 'tag' i.e if the word is Noun(N) or Verb(V) or something else.

        for word, tag in pos_tag(entry):
            # Below condition is to check for Stop words and consider only alphabets
            if word not in stopwords.words('english') and word.isalpha():
                Final_words.append(word)
        # The final processed set of words for each iteration will be stored in 'sms_final'
        transactions.loc[index,'sms_final'] = str(Final_words)
    
    Tfidf_vect = TfidfVectorizer(max_features=5000)
    Tfidf_vect.fit(transactions['sms_final'])

    test_msg_Tfidf = Tfidf_vect.transform([prepare_predict_msg(test_msg)])
    return test_msg_Tfidf
   

#plt.rcParams["figure.figsize"] = (12, 6)


def get_day_26_mapping_model(date):
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
    
    
    
@app.route('/predict' ,methods= ['GET','POST'])
def gp_model():
    

    if not firebase_admin._apps:
        cred = credentials.Certificate('sim1-ac95f-firebase-adminsdk-3hy48-80b6b88451.json') 
        default_app = firebase_admin.initialize_app(cred)
    
    
    
    
    os.environ["GOOGLE_APPLICATION_CREDENTIALS"]="sim1-ac95f-firebase-adminsdk-3hy48-80b6b88451.json"
    cred = r"sim1-ac95f-firebase-adminsdk-3hy48-80b6b88451.json"
    login = credentials.Certificate(cred)
    
    db = firestore.client()
    transaction = db.collection("Test").stream()

    
    dict_users = {"userid":[],"type":[], "amount":[],"time":[],"date":[]}
    
    count=0
    for trans in transaction:
        try:
            us = json.loads(str(trans.to_dict()).replace("'",'"').replace(" ","").lower())
            dict_users["userid"].append(us["userid"])
            dict_users["type"].append(us["type"])
            dict_users["amount"].append(us["amount"])
            dict_users["time"].append(us["time"])
            dict_users["date"].append(us["date"])
        except:
            continue
    ##
    df = pd.DataFrame.from_dict(dict_users)

    
    ##
    #df = pd.read_csv('trans.csv') # when you add transcation to the dataset add them from the earliest to the latest so 0 should be the earliest transaction
    df["date"] = pd.to_datetime(df['date']+" "+df["time"],errors='coerce')
    df["amount"] = df["amount"].astype(float)
    df['day_26_mapping_date'] = get_day_26_mapping_model(df['date'])
    
    df = df.drop(df[(df.amount >= 1000)].index).reset_index()
    

    

    df['amount'] = tf.cast(df['amount'], tf.float64)
    condition = df["type"] == 'withdrawal'
    df.loc[condition, ['amount']] *= -1
    
    for x in ['amount']:
        q75,q25 = np.percentile(df.loc[:,x],[75,25])
        intr_qr = q75-q25
     
        max = q75+(1.5*intr_qr)
        min = q25-(1.5*intr_qr)
     
        df.loc[df[x] < min,x] = np.nan
        df.loc[df[x] > max,x] = np.nan
    
    df = df.dropna(axis = 0)

    df["unix_date"] = [datetime.timestamp(dt)/3600 for dt in df["date"]]
    df["unix_date"] =tf.cast(df["unix_date"] , tf.float64)
    X = df[["unix_date"]]
    X = tf.cast(X, tf.float64) 
    
    Y = df[['amount']]
    Y = tf.cast(Y, tf.float64) 
    
    
    X_train = np.reshape(X,(-1, 1))
    Y_train = np.reshape(Y,(-1, 1))
    
    k = gpflow.kernels.RBF()
    m = gpflow.models.GPR(data=(X_train, Y_train), kernel=k, mean_function=None)
    opt = gpflow.optimizers.Scipy()
    opt_logs = opt.minimize(m.training_loss, m.trainable_variables, options=dict(maxiter=10000))
    
    
    #creating testing data
    last_trans = X.numpy().max()
    # mapping the last date of transaction to day_26_mapping_date column to get day 26
    day_26 = df[last_trans== df["unix_date"]]['day_26_mapping_date']
    print( df["unix_date"])

 
    print(day_26)
    # converting day_26 to the to unix timestamp
    day_26_unix_time = datetime.timestamp(pd.to_datetime(day_26.values[0]))/3600

    

    #generates points from the first transaction till  the nearst day 26 of the last transaction
    X_test = np.linspace(X.numpy().min(), day_26_unix_time , 100).reshape(100, 1) #doxum

    mean, var = m.predict_f(X_test)
    #generate 10 samples from posterior
    tf.random.set_seed(1)  # for reproducibility
    samples = m.predict_f_samples(X_test, 10)  # shape (10, 100, 1)
    #plot
    '''
    plt.figure(figsize=(12, 6))
    plt.plot(X_train, Y_train, "kx", mew=2)
    plt.plot(X_test, mean, "C0", lw=2)
    plt.fill_between(
        X_test[:, 0],
        mean[:, 0] - 1.96 * np.sqrt(var[:, 0]),
        mean[:, 0] + 1.96 * np.sqrt(var[:, 0]),
        color="C0",
        alpha=0.2,
    )
    _=plt.plot(X_test, samples[:, :, 0].numpy().T, "C0", linewidth=0.5)
    '''
    X_train = [[datetime.utcfromtimestamp(dt[0]*3600).strftime('%Y-%m-%d %H:%M:%S')] for dt in  X_train]
    X_test = [[datetime.utcfromtimestamp(dt[0]*3600).strftime('%Y-%m-%d %H:%M:%S')] for dt in  X_test]

    pickle.dump(m, open('gp_model_test.pkl', 'wb'))
    return { "X_train":X_train,
            "Y_train":Y_train.tolist(),
            "X_test":X_test,
            "mean": mean.numpy().tolist()
            }
    
if __name__ == "__main__":
    app.run(host='0.0.0.0', port=9900)

    
    
    