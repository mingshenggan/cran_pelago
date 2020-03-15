# Intro

![Documentation](https://github.com/mingsheng88/cran_pelago/blob/master/app/assets/images/erd.png?raw=true)

# Stack

```
Ruby 2.6.5
Rails 6.0
Delayed Job
RSpec
```

# Getting Started

## Path 1: Barebones Setup

1. Install [rbenv](https://github.com/rbenv/rbenv#installation)
1. Install [Ruby 2.6.5](https://github.com/rbenv/rbenv#installing-ruby-versions)
1. Install [bundler](https://bundler.io/)
1. Install [postgresql](http://postgresguide.com/setup/install.html)
1. Run `bundle install`
1. Start background worker: `bin/delayed_job start`
1. Run server: `rails s`

## Path 2: Docker Compose

1. Install [docker](https://docs.docker.com/install/)
1. Install [docker-compose](https://docs.docker.com/compose/install/)

```
docker-compose up
```

# Application Logic

## Run crawler

1. Start rails console
```
# 1. If using local setup
$ rails c

# 2. If using docker-compose
$ docker-compose run app /bin/sh
```

2. TriggerCrawler
```
irb(main):001:0> FetchPackagesJob.perform_later("https://cran.r-project.org/src/contrib/")

...

If you have delayed job running in the background, the crawling of details will start automatically in the background.
```

## Search

1. Start rails server
```
$ rails s
```
2. Hit url @ `http://localhost:3000/search?q=something`
