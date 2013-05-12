Faker = require 'Faker'
uuid = require 'node-uuid'
redback = require('redback').createClient()
cache = redback.createCache('opendem-dev')
_ = require 'underscore'
config = require('config')()
path = require 'path'
logger = require('onelog').get 'PropController'

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
    filter = req.query.filter
    key = 'initiative/index'
    send = (bills) ->
      bills = JSON.parse bills
      paginate req, res, bills

      bills = switch filter
        when 'actionRequired'
          bills
        when 'reviewed'
          # Debug.
          bills.map (item) ->
            rand = Math.floor((Math.random()*2)+1);
            item.vote = switch rand
              when 1
                grade: 'Yes'
                delegate: 'Malcolm Turnbull'
                delegateAvatar: 'https://si0.twimg.com/profile_images/3077056429/d4ba7af0567e896bb9eb7bad10ffa54d.jpeg'
              when 2
                grade: 'No'
                delegate: 'Tony Abbott'
                delegateAvatar: 'https://si0.twimg.com/profile_images/1703647247/2267.jpg'
            item
        when 'past'
          bills

      logger.debug 'Showing bills from', res.locals.from, res.locals.to
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
    id = req.params.prop

    bill = require 'op-tools/aph/test/fixtures'
    fs = require 'fs'
    path = require 'path'
    #html = fs.readFileSync path.join(process.cwd(), 'test/server/fixtures/ndis-bill.html'), 'utf-8'

    safeId = 'Marriage-Act-1961'
    safeId = id.replace /[^a-zA-Z0-9_\-\.]/g, '-'
    firstLetter = safeId.charAt(0)

    file = path.join config.law.repoPath, "/#{firstLetter}/#{safeId}/index.md"
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
      name: id
      prop: bill
      html: html

generateFakeInitiatives = ->
  (for i in [0..100]
        id: uuid.v4()
        title: Faker.Lorem.sentences 1
  )
