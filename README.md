# README
Questions and Answers

This project is an analog of Stackoverflow built as part of education program at Thinknetica (c).

Goal: create project using TDD and BDD

Main user stories:
  - User can create questions
  - User can create answers
  - User can authentificate
  - Only authentificated user can create answers and questions
  - Author can delete only own question or answer
  - Author of question can choose best answer for his question. Author can change best answer.
  - Users can attach files to their qustions and answers
  - Users can add links to their questions and answers. Links are validated. If link is gist gist is shown.
  - Users can edit or delete attached files and links.
  - Author of question can create award for his question and user who answers can get it for the best answer.
      (award has a name and attached picture)
  - Users can vote for questions and answers. Questions and answers has own rating.
  - Users can comment questions and answers. 
  - All users can see new questions, answers and comments, when it appear without refreshing the page.
  - Users can authentcate with Github VK and Facebook
  - Users can subscribe for questions
  - Users get everyday digest of new questions and answers on the questions they subscribed in their emails
  - Users can search questions, answers, comments and other users. 

Main features:
  - Authentication with Devise and OAuth
  - Authorization with CanCanCan
  - Fulltext search with Sphinx
  - Sidekiq for jobs
  - Rspec for tests
  - Amazon Storage for files
  - Application has own API (OAuth functionality provided with Doorkeeper)
  - Capistrano for deployment
  - ActionCable for rendering answers and comments
