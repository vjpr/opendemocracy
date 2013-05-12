#= require jquery/jquery
#= require underscore/underscore
#= require backbone/backbone
#= require jade-runtime
#= require_tree ../templates
#= require backbone.marionette/lib/backbone.marionette
#= require backbone-pageable
#= require jquery-timeago/jquery.timeago
#= require holderjs
#= require jquery.infinitescroll
# require debug/debug

# Workaround jade-runtime's use of `require`.
require = -> readFileSync: -> ''

# Convenience.
window.BM = Backbone.Marionette
window.B = Backbone

$(document).ready ->

  # Enable Socket.IO.
  window.socket = io.connect()
  socket.on 'msg', (msg) ->
    console.log 'Received socket.io message', msg
  # Send a test message to server on connection.
  socket.on 'connect', ->
    socket.emit 'hello', 'Hello, World!'

  window.app =
    collections: {}
    models: {}
    views: {}
    mixins: {}

  # Main.
  app.views.main = new MainLayout
  app.views.main.render()

  new Router
  B.history.start pushState: false

class Router extends B.Router

  routes:
    'props': 'props'
    'props/:id': 'prop'

  prop: =>
    console.log '!'
    model = new PropModel id: 1
    view  = new PropView {model}
    model.fetch()
    app.views.main.content.show view

  props: =>
    app.collections.props = new PropsCollection
    app.views.propsCollectionView = new PropsCollectionView
      collection: app.collections.props.fullCollection
      model: new B.Model title: 'Propositions'
    app.collections.props.getFirstPage()
    app.views.main.content.show app.views.propsCollectionView

class MainLayout extends BM.Layout
  el: '#main'
  template: JST['main']
  regions:
    content: '.content'

# Proposition
# ---

class PropModel extends B.Model
  urlRoot: '/props'

class PropsCollection extends B.PageableCollection
  model: PropModel
  url: '/props'
  mode: 'infinite'
  state:
    firstPage: 1
    currentPage: 1
    #pageSize: 20

  queryParams:
    currentPage: 'page'
    pageSize: 'pageSize'

class PropRowView extends BM.ItemView
  template: JST['props/item']
  onRender: =>
    @setElement @$el.children()
    @$('abbr.timeago').timeago()

class PropsCollectionView extends BM.CompositeView
  template: JST['props/table']
  itemView: PropRowView
  itemViewContainer: 'tbody'
  ui:
    prev: '.js-prev'
    next: '.js-next'

  _initialEvents: =>
    console.log 'hello', @collection
    return unless @collection?
    @listenTo @collection, "add", @addChildView, this
    @listenTo @collection, "remove", @removeItemView, this
    @listenToOnce @collection, "reset", @_renderChildren, this

  onRender: =>
    @ui.prev.on 'click', ->
      app.collections.props.getPreviousPage()
    @ui.next.on 'click', ->
      app.collections.props.getNextPage()

    # Scrolling.
    @isLoading = false
    buffer = 200
    $window = $(window)
    $window.scroll =>

      # Before the bottom of the viewport...
      bottomOfViewport = $window.scrollTop() + $window.height()
      # passes the bottom of the list of elements minus a buffer...
      bottomOfCollectionView = @$el.offset().top + @$el.height() - buffer
      # we should re-render.

      if not @isLoading and bottomOfViewport > bottomOfCollectionView
        console.log 'Loading more results'
        @isLoading = true
        @collection.pageableCollection.getNextPage(silent: false).success (data, status, jgXHR) =>
          @isLoading = false

class PropView extends BM.Layout
  template: JST['prop']
  modelEvents:
    change: 'render'
  onRender: =>
    console.log @model.toJSON()
    html = @model.toJSON().html
    #@$('iframe').attr src: "data:text/html;charset=utf-8," + html
    @$('.js-bill').html html
