## FieldBackend

This repository contains a Rails app that serves as the backend for the
[FieldApp](https://github.com/truefootprint/field-app) and
[FieldAdmin](https://github.com/truefootprint/field-admin) applications. It
contains a rich domain model and exposes an API that can be used to send and
receive data and to administer projects, users, etc. It is deployed to AWS and
runs on an 'all-in-one' EC2 instance whose image is created by the
[infrastructure](https://github.com/truefootprint/infrastructure) repository.

### Documentation

In addition to this README which contains setup instructions, the [doc/](doc/)
directory contains these useful resources:

1. [Project history](doc/project_history.md): When the project began. Who built it. Information about throwaway projects.
2. [Overview](doc/overview.md): A listing of the API's endpoints with an explanation of what they're used for.
3. [Domain model](doc/domain_model.md): A high-level explanation of the different models and how they relate to each other.
4. [API tokens](doc/api_tokens.md): An explanation of how users/admins authenticate. An example curl request.
5. [Visibility](doc/visibility.md): Which users see which projects, questions, etc. Includes an example scenario.
6. [Question types](doc/question_types.md): What are the different types of question. How responses are interpreted.
7. [Image uploads](doc/image_uploads.md): How image uploads work. How records are synchronized. An explanation of data formats.
8. [Translations](doc/translations.md): An overview of how translations work and some ideas for future work.
9. [Encryption](doc/encryption.md): How database encryption works. Blind indexes. Adding new encrypted fields.

### Setting up the app

1. Ensure you have a working Ruby installation on your system
2. Ensure you have installed a recent version of Postgres (`brew install postgresql`) and that it is running
3. Install the specific version of Ruby used by the project, found in the [.ruby-version](.ruby-version) file
4. Make sure that the Ruby version is 'active' and you have installed the 'bundler' gem for it
5. Clone this repository from GitHub
6. Run `bundle` to install gems that are the application's dependencies
7. Run `bundle exec rake db:create db:migrate` to create the database schema
8. Run `bundle exec rake db:seed` to populate the database with some sample data
9. Run `bundle exec rake` to run the test suite
10. Run `bundle exec rails server` to start the application
11. Visit [localhost:3000/translations](http://localhost:3000/translations) in your browser to check if it is running

If everything has worked, the ~350 tests have passed and you're served some JSON then you are set up for development.

### License

Copyright 2020, [TrueFootprint Limited](https://www.truefootprint.com/), All Rights Reserved
