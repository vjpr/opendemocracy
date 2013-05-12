Faker = require 'Faker'
uuid = require 'node-uuid'
redback = require('redback').createClient()
cache = redback.createCache('opendem-dev')
_ = require 'underscore'
config = require('config')()
path = require 'path'

# Libs.
{ParlInfo} = require 'op-tools/aph/parlinfo'

#filesPath = (p) -> path.join path.resolve(config.law.filesPath), p

# Number of files to show.
defaultLimit = 5

paginate = (req, res, items) ->
  page = parseInt(req.query.page) or 1
  pageSize = parseInt(req.query.pageSize) or defaultLimit
  num = page * pageSize
  total = items.length
  res.locals
    total: total
    pages: Math.ceil total / pageSize
    page: page
    from: num
    to: num + pageSize
  if res.locals.from - pageSize > 0 then res.locals prev: true
  if res.locals.to < total then res.locals next: true
  links = {}
  links.prev = "/props?page=#{res.locals.page - 1}" if res.locals.prev
  links.next = "/props?page=#{res.locals.page + 1}" if res.locals.next
  links.first = "/props?page=0"
  links.last = "/props?page=#{res.locals.pages}"
  res.links links

module.exports = class Prop

  @index: (req, res, next) ->
    key = 'initiative/index'
    send = (bills) ->
      bills = JSON.parse bills
      paginate req, res, bills
      console.log 'Showing bills from', res.locals.from, res.locals.to
      res.send bills.slice res.locals.from, res.locals.to

    #res.send generateFakeInitiatives()
    #cache.flush key
    await cache.get key, defer e, bills
    return next e if e; return send bills if bills
    await ParlInfo.search {query: 'Dataset:billsCurBef'}, defer e, bills
    return next e if e
    cache.set key, JSON.stringify(bills), ->
    send bills

  @show: (req, res, next) ->
    bill = require 'op-tools/aph/test/fixtures'
    fs = require 'fs'
    path = require 'path'
    #html = fs.readFileSync path.join(process.cwd(), 'test/server/fixtures/ndis-bill.html'), 'utf-8'

    file = path.join(config.law.repoPath, '/m/Marriage-Act-1961/index.md')
    md = fs.readFileSync file, 'utf8'
    marked = require 'marked'
    html = marked md
    cheerio = require 'cheerio'
    $ = cheerio.load html
    $('p').each -> @html "<span>#{@html()}</span>"
    html = $.html()
    # Proper indents for ensp;
    html = html.replace /([\u2002]+)/g, (match, p1, offset) ->
      count = p1.match(/\u2002/g)?.length
      "<span style='width: #{count}em'></span>"

    res.send
      name: 'National Disability Insurance Scheme 2013'
      prop: bill
      html: html

generateFakeInitiatives = ->
  (for i in [0..100]
        id: uuid.v4()
        title: Faker.Lorem.sentences 1
  )
