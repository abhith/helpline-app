# helpline-app
Simple (Boring) app which basically lists helpline numbers of events. Now only event added is "Kerala Floods".

## Download
[http://bit.ly/helpline-app](http://bit.ly/helpline-app)

## Technical Notes
- Consumes Google Firestore realtime database. So we can add/edit or even can delete helpline numbers REALTIME. 
- Offline usage: One the app connected to the internet for the first time, it caches data. 
And the data can still accessible if user is offline.

## Firestore Database Structure

|-events  
|--|-name (string)  
|--|-contacts  
|--|--|-name (string)  
|--|--|-phone (string)  
|--|--|-type (string) (landline/ mobile)  

