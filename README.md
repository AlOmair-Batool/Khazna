# Khazna

## Introduction
Khazna is an android application that automatically retrieves all user’s related financial transactions from SMS messages to predict the current cash flow. The goal of our application is to suggest a spending plan for the user to help him manage his spending and achieve his saving goals without user intervention. It will build a knowledge based using the amount and the type (withdraw or deposit) of each transaction.

![khaznaphone](https://user-images.githubusercontent.com/90303853/160221293-70af8806-8885-466b-81b4-97a51a83c230.png)


## Launching

1- Install Khazna as zip file in your cumputer or clone Khazna repository on Android Studio:

```
https://github.com/AlOmair-Batool/Khazna.git
```

2- Download dependencies from the terminal:

```
flutter pub get
```

3- From Run/Debug configurations in Additional run args input add the following:

```
--no-sound-null-safety
```

4- Run the program:

![main-toolbar](https://user-images.githubusercontent.com/90303853/161403815-a752af48-5af6-4002-940e-14d262e1c830.png)


## Languages
<p align="center">
<img src="https://raw.githubusercontent.com/github/explore/80688e429a7d4ef2fca1e82350fe8e3517d3494d/topics/python/python.png" alt="Python" height="40" style="vertical-align:top; margin:4px">
<img src="https://user-images.githubusercontent.com/90303853/161399797-28b8c234-c69b-4384-bdc8-c667265e9663.png"height="40" style="vertical-align:top; margin:4px">
<img src="https://user-images.githubusercontent.com/90303853/161399854-c671d1a5-c1e7-4f43-a386-faf2ffde19cc.png"height="40" style="vertical-align:top; margin:4px">
</p>

## Features
-	Automatic retrieval of financial transactions via SMS messages.
-	Transaction categorization based on vendors information.
-	Reports that visualize financials.
-	Predicts the total amount of money at the user account on the 26th of the month.
-	Create a saving plan that send a daily encouragements notification and show the daily allowance to the user.
-	Real-Time financial transaction tracking where all information updated at receiving new financial SMS.
-	The user can specify the optimal saving point instead of using the 20% default saving point based on 50/30/20 budging rule.

