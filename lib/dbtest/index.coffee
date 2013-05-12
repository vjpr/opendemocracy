require 'iced-coffee-script'

console.log 'hello!'

pg = require 'pg'

#config = require('config')()
#console.log config.database.sequelizePostgres

connString = 'postgres://postgres@localhost/opendemocracy'

client = new pg.Client connString
await client.connect defer e
throw e if e

q = """
  DROP FUNCTION IF EXISTS plv8_test(text[], text[]);
  CREATE OR REPLACE FUNCTION plv8_test(keys text[], vals text[])
  RETURNS json
  AS $$
  o = {}
  for key, i in keys
    o[key] = vals[i]
  return o
  $$ LANGUAGE plcoffee IMMUTABLE STRICT;

  SELECT plv8_test(ARRAY['name', 'age'], ARRAY['Tom', '29']);
  """

#q = 'select now() as "theTime"'
await client.query q, defer e, result
throw e if e
console.log result
console.log result.rows[0].plv8_test.name
