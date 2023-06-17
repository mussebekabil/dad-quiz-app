# Device-Agnostic Design Course Project I - eca927f4-b000-4091-8075-1d76c43f7a04

Write your documentation for the project below.

## Name of the application
DAD Quiz App

## Brief description of the application

- The application fetches list of quiz topics and show them in the landing page. 
- Clicking each topics redirects to question page where it shows random question under that category. 
- Selecting the option for the question checked. If the selected answer is wrong it shows incorrect answer message. When the right answer is given, the page shows a button to fetch another question from the same topic category. 
- If the question is selected from "Dog breeds" category and the question has image, it fetches image of the dog. 
- Statistics page shows total count of correct answers. Besides, it shows list of correct answers per topic. 
- The "Generic practice" option in the list of topics always redirect to the list answered topic category. Every time the question under that topic answered, it checks the total statistics and allows to choose the next question from the list answered topic category. 
- Unit tests for the screens and api endpoints are added. 

## Three key challenges faced and key learning moments from working on the project
Generally, there was some time gap after finishing the course module to start the projects. So the concepts I learned from the materials were not fresh in my head when I start working the projects. I had to refer the contents again and again to resolve the issues I faced while doing the projects. 

- The first challenge was working on questions page when handling the async values. But I managed to resolve it using ConsumerStatefulWidget
- The second challenge was working on Statistics page. First I did the totalCount in the SharedPreference. Then when I tried to implement the merits requirement for statistics page, it gets messy. I had to rewrite statistics provider using StateNotifier. 
- The last challenging part was writing unit tests. Again, here I was trying to override the statistics provider in the test, for some reason, I couldn't find it working. Then I refactored again the provider implementation that I can test the functionalities.
  - the tests in Questions screen was also a bit challenging. I still couldn't resolve the issue I faced when testing "Choose question" functionality. I left the code commented. 

## List of dependencies and their versions
Here are list of dependencies and their versions used for this project.

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.2
  go_router: ^6.0.1
  flutter_riverpod: ^2.3.6
  shared_preferences: ^2.0.17
  http: ^0.13.5
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^2.0.0
  nock: ^1.2.2
```
