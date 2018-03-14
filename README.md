# Limited

[![Build Status](https://travis-ci.org/snada/limited.svg?branch=master)](https://travis-ci.org/snada/limited) [![Maintainability](https://api.codeclimate.com/v1/badges/69f8201470965b4d7828/maintainability)](https://codeclimate.com/github/snada/limited/maintainability) [![Test Coverage](https://api.codeclimate.com/v1/badges/69f8201470965b4d7828/test_coverage)](https://codeclimate.com/github/snada/limited/test_coverage)

Simple Rails request limiter sample.

## Setup

Rename the files `config/database.yml.example` and `config/secrets.yml.example` and fill it to match your local environment.

Once that is done, install dependencies by running `bundle install`.

Simply run `bundle exec rails s` and check the application running at `http://localhost:3000`.

## Tests

This project uses RSpec for testing.

Run `bundle exec rspec` or `bundle exec rake` to see them pass.

A small code coverage tool is included: once tests finished running, open the `coverage/index.html` file to see the report.

Code quality and code coverage are enforced by [Travis CI](https://travis-ci.org/snada/limited) and [Codeclimate](https://codeclimate.com/github/snada/limited) integrations.

## Development notes

### Project structure

This repository follows the [git-flow](https://danielkummer.github.io/git-flow-cheatsheet/) branching model, and every feature has been tracked as a Github issue and linked to the code fixing it.

Releases follow [semantic versioning](https://semver.org/).

### Code insights

The actual limiter logic is inside a small library located in `lib/rate_limit.rb`.

This code leverages the framework's cache to save the number of performed requests from an initial moment for a given resource (a generic "scope") and a resource consumer (by "identifier").

The main application controller requires this library and exposes a very simple method, mapping by default the mentioned scope with the path requested and the consumer identifier with the remote ip of the incoming request.

This should keep things easy enough to edit and mantain and integrate with future possible features, like limiting by authenticated user, sharing the same scope between calls or adding black/white lists.
