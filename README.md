# helpline-app
[![FOSSA Status](https://app.fossa.io/api/projects/git%2Bgithub.com%2FAbhith%2Fhelpline-app.svg?type=shield)](https://app.fossa.io/projects/git%2Bgithub.com%2FAbhith%2Fhelpline-app?ref=badge_shield)

Simple (Boring) app which basically lists helpline numbers of events. Now only event added is "Kerala Rain Disaster".
<a href="https://play.google.com/store/apps/details?id=net.abhith.helplineapp">
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



## License
[![FOSSA Status](https://app.fossa.io/api/projects/git%2Bgithub.com%2FAbhith%2Fhelpline-app.svg?type=large)](https://app.fossa.io/projects/git%2Bgithub.com%2FAbhith%2Fhelpline-app?ref=badge_large)