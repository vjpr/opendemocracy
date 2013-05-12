# Install

See https://code.google.com/p/plv8js/wiki/PLV8

createdb opendemocracy
createdb opendemocracy-test

psql -d opendemocracy -c 'create extension plv8'
psql -d opendemocracy-test -c 'create extension plv8'

createlang -d opendemocracy plv8
createlang -d opendemocracy-test plv8
