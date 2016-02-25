# Mahanenko.ru

The app represents the main content (news and books) from http://mahanenko.ru via http-api with responses in JSON format

## Build & Run

No specific requirements. API does not requires any keys or passwords.

Should work on any iOS device (iPhones & iPads)

## Description

### Expected common behaviour

+ In case of large screen width (iPad or large iPhone), the App's layoyt should behave as Split Screen View controller – with the Menu View on the left part
+ With the first run, the App should use English language in case if system language selected to any of "en" locales (`en`, `en-US`, `en-*`)
+ For other locales App will use Russian language
+ With the second and next runs, app will use saved language depending on Language selector in Menu View (English or Russian)
+ On start, the App shows the Menu View and then automatically switch to the News list
+ All data (news list, news details, books list, books details, all images) for both languages should be saved in CoreData DB after first fetch
+ In case if data already saved, App should work as usual without any network connection
+ Manual lists update (with pull gesture) should re-fetch data from the server and update stored data in CoreData
+ All images loads asynchronouosly – should be a spinning loader until image load
+ Images shows alert icon in case if fetching fails
+ in case if fetching fails, image should re-fetch itself on next try

### Possible views

#### Menu / Меню

shows menu with 3 items

1. `News` / `Новости`: opens the news list
2. `Books` / `Книги`: opens the books list
3. `About` / `О программе`: opens a view with app version & build number

There is language change button in the navigation bar.
Could have 2 states:
+ `English`: switch content to English language
+ `Русский`: switch content to Russian language

Language button behaviour:
+ Language should be saved between App launches
+ On language button tap it switches the content language and shows the News list in selected language
+ UI language is not changed automatically
+ After app re-launch (completely close and launch again), UI language should correspond to the selected content language

#### News / Новости

+ Has a navigation button to go back to the `Menu`
+ Shows a news list sorted by date (news on top, old on bottom)
+ list pull triggers the news update (fetch from server)
+ Each item have a date on top, then image and text (layout depends on screen size/orientation)
+ Item height depends on the content
+ tap on item opens `News Details` view
+ The view has a tags selector on the right navigation button
+ Tags selector shows the news tags list
+ Tag selection should update the news list to show only selected items

#### News Detail

+ Has a navigation button to go back to the `News` list
+ Shows a news date on top (in a red line)
+ layout depends on screen size & orientation (in some cases I made it looks not so nice, say iPhone 5 + horizontal)
+ Shows news text; allows to scroll in case of long text
+ Text may contain links: on link tap it should open a default web-browser with this link
+ Shows image or images; allows to scroll through it in case of multiple images

#### Books / Книги

+ Has a navigation button to go back to the `Menu`
+ Layout depends on screen size & orientation
+ list pull triggers the books update (fetch from server)
+ Minimal columns count should be 2, even on smallest screens
+ Item height depends on the title length (it could be in multiple lines for long titles)
+ Items content is aligned to top even in case of different heights
+ tap on item opens `Book Details` view
+ The view has a Seria selector on the right navigation button
+ Seria selector shows the news tags list
+ Seria selection should update the news list to show only selected items

#### Book Details

+ Has a navigation button to go back to the `Books` list
+ Has the book title on top (could be multiple lines in case of long title)
+ Has book's image, seria title and description
+ Description text allows to scroll in case of long text
+ Tap on the image scales the image depending on screen and title sizes
+ When image is large, text could be hidden completely or visible only few lines (in case of short book's title)
+ When image is large, tap on image or on the text (if visible), scales image back to small size and shows text

#### About / О программе

+ Shows the App version and build number
+ Build number is generated automatically on build depending on last Git's commit hash
