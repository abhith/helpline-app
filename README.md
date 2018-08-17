# helpline-app
Simple (Boring) app which basically lists helpline numbers of events. Now only event added is "Kerala Rain Disaster".

## Download
<a href="https://play.google.com/store/apps/details?id=https://play.google.com/store/apps/details?id=net.abhith.helplineapp&rdid=net.abhith.helplineapp">
  <img alt="Android app on Google Play"
       src="https://developer.android.com/images/brand/en_app_rgb_wo_45.png" />
</a>

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

