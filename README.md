# Multiple Accounts Detector

This is a prototype of a web application which aims to detect and stop a user
from creating multiple accounts.

The web application is hosted on Heroku and can be accessed under the
following link:
<https://madetector.herokuapp.com/>

## Prerequisites

This project requires Ruby v3.1.1 to be installed. The Gemfile is bundled
with Bundler v2.3.11. For information on how to setup the project locally,
please follow the next steps. Most of the work will be done automatically by
`bin/setup`.

## Setup

In your console, run the following commands in order to clone and setup
the project:

```sh
git clone git@github.com:edmunteanu/madetector.git
cd madetector
bin/setup
```

### Configuration

Configure the following:

* config/application.yml

### Run

The project can be run locally by running the following script:

```sh
bin/run
```

### Linters and tests

In order to run all the linters and tests you can run the following script:

```sh
bin/check
```
