Smarter Classifieds aka GitHub Job Search Tool
========================

This job search CLI allows users to search for jobs using the GitHub jobs API. Users can search based on their skillset and location and save jobs they are interested in.

![classifieds](https://media.giphy.com/media/l4Epe8gPvTodwd8CQ/giphy.gif)

Happy job hunting!

---

## Minimum Program Requirements

macOS:

- [Ruby](https://www.ruby-lang.org/en/documentation/installation/)

- [Homebrew](https://brew.sh/)

---

## Installation and Setup

To download the CLI application clone the repository from GitHub and change your current directory to the cloned repository

Next you will need to install a few gems. Run the following in your terminal from the top of the project directory:


```ruby
run setup.rb #installs dependencies  
bundle install #this will install all required gems
```

Next you will need to setup the database. Run the following commands in your terminal at the top of the directory:

```ruby
rake db:setup_db
```


Now you're all setup to run the program!

## Running the Program

![business penguin](https://media.giphy.com/media/gr5qY4qj8G96o/giphy.gif)

To start the program run the following command in your terminal at the top of the directory:

```ruby
ruby bin/run.rb
```

The main menu will display options for commands you can make to the program. If you would like to exit out of the program from the main menu just type quit.

---screenshot of main menu---

Below you will find a video that demonstrates how you can use the program:

---insert video here---



#### License

---license information---
