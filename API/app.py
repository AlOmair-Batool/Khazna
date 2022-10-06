from flask import Flask
from flask import request
import pickle
import numpy as np
import pandas as pd
from datetime import datetime,date
## new 
from nltk.tokenize import word_tokenize
from nltk.tokenize import RegexpTokenizer
from nltk import pos_tag
import nltk
from nltk.corpus import stopwords
from collections import defaultdict
from nltk.corpus import wordnet as wn
from sklearn.feature_extraction.text import TfidfVectorizer
from nltk.corpus import wordnet
import re


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
if __name__ == "__main__":
    app.run(host='0.0.0.0', port=8000)

    
    
    