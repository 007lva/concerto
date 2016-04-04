#!/bin/bash
bundle install --without development production
cp config/database.yml.gitlab-ci config/database.yml
