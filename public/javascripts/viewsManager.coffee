define ->
  class ViewsManager
    @show: (view) ->
      @view.remove() if @view?
      @view = view
      @$el.html view.el
      view.render()
