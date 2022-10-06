import re
from flask import Flask,request,jsonify
import joblib 
import numpy as np
model=joblib.load('pipModel')
app=Flask(__name__)

@app.route('/')
def home():
	return "Hello world"

@app.route('/predict',methods=['POST'])
def predict():
	txt=request.form.get('txt')
	res=model.predict([txt])[0]
	temp = re.findall(r'SAR [\d\.\d]+|[\d\.\d]+ SAR', txt)
	if len(temp)==0:
		temp.append('SAR 0')
	
	return jsonify({'placement':str(res),'mony':temp[0]})



if __name__ =='__main__':
	app.run(debug=True)