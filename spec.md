# Specifications for the Sinatra Assessment

Specs:
- [x] Use Sinatra to build the app: Require Sinatra gem, use Sinatra DSL in controllers to define routes
- [x] Use ActiveRecord for storing information in a database: Use Rake tasks to build migrations, create tables, and migrate changes; Use ActiveRecord macros in class definitions to build object associations
- [x] Include more than one model class (e.g. User, Post, Category): Define User, Deck, and Card classes
- [x] Include at least one has_many relationship on your User model (e.g. User has_many Posts): User has_many decks
- [x] Include at least one belongs_to relationship on another model (e.g. Post belongs_to User): Decks belongs_to Users
- [x] Include user accounts with unique login attribute (username or email): User class attributes include
- [x] Ensure that the belongs_to resource has routes for Creating, Reading, Updating and Destroying: CRUD routes defined in DecksController
- [x] Ensure that users can't modify content created by other users: All read, update, and destroy routes enforce user relationship to content
- [x] Include user input validations: User password authenticated with Bcrypt
- [ ] BONUS - not required - Display validation failures to user with error message (example form URL e.g. /posts/new)
- [ ] Your README.md includes a short description, install instructions, a contributors guide and a link to the license for your code

Confirm
- [x] You have a large number of small Git commits
- [x] Your commit messages are meaningful
- [x] You made the changes in a commit that relate to the commit message
- [x] You don't include changes in a commit that aren't related to the commit message
