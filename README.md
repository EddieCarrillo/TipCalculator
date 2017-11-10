# Pre-work - *Tippy*

**Tippy** is a tip calculator application for iOS.

Submitted by: **Eduardo Cariillo**

Time spent: **15** hours spent in total

## User Stories

The following **required** functionality is complete:

* [x] User can enter a bill amount, choose a tip percentage, and see the tip and total values.
* [x] Settings page to change the default tip percentage.

The following **optional** features are implemented:
* [x] UI animations
* [x] Remembering the bill amount across app restarts (if <10mins)
* [x] Using locale-specific currency and currency thousands separators.
* [x] Making sure the keyboard is always visible and the bill amount is always the first responder. This way the user doesn't have to tap anywhere to use this app. Just launch the app and start typing.

The following **additional** features are implemented:

- [x] Light, Dark, and Blue color themes
- [x] App icon for app start up
- [x] Custom settings button icon


## Video Walkthrough 

Here's a walkthrough of implemented user stories:

<img src='http://i.imgur.com/zdjSLG8.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

Describe any challenges encountered while building the app.
I had an annoying bug. Whenever I attempted to use UserDefaults to save the bill across app restarts it would fail to do so. This was odd because I had UserDefaults in other parts of the app succesfully. So, I was confused and after more searching I realized I did not call synchronize after saving the bill. So I made sure to make a call to synchronize after saving the bill value. Still no success. So after a painful few hours I figured that I was making the call to calculateTip in the viewWillLoad lifecycle function and it always returned a 0. This was because the view never finshed being created an always returned an invalid string and then 0. Moving my call to calculateBill viewDidAppear end up fixing the bug. (I made a call to calculateBill manually so that if the default tip was changed that the tip and the total reflected that change when the user switched back to the main screen.)
## License

    Copyright [2016] [Eduardo Carrillo]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
