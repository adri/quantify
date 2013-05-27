
class Counter
    @type = 'default'

    constructor: (name, counts = []) ->
        @name = name
        @counts = counts

    count: ->
        @counts.push({time: new Date()});

    clear: ->
        @counts = []

    getAmount: ->
        @counts.length

# class CurrencyCounter extends Counter
#     @type = 'currency'

# class WeightCounter extends Counter
#     @type = 'weight'

# class DurationCounter extends Counter
#     @type = 'duration'


class CounterFactory
    @create: (counter) ->
        new Counter(counter.name, counter.counts)

class CounterList
    counterListId: "counter_list"

    constructor: (storage) ->
        @counterList = []
        @storage = storage
        @load()

    add: (counter) ->
        @counterList.push CounterFactory.create(counter)

    persist: ->
        @storage.setItem(@counterListId, @counterList);

    load: ->
        counters = @storage.getItemOrElse(@counterListId, [])
        for counter in counters
            @add(counter)

    getCounterList: ->
        @counterList

class LocalStorageJson
    setItem: (name, value) ->
        localStorage.setItem(name, JSON.stringify(value))

    getItem: (name) ->
        item = localStorage.getItem(name)
        return JSON.parse(item) if item?

    getItemOrElse: (name, defaultValue) ->
        return @getItem(name) if @getItem(name)?
        defaultValue

class CounterListView
    listId: '#counter_list'

    constructor: (counterList) ->
        @model = counterList

    render: ->
        for item in @getListItems()
            $(item).unbind()
            $(item).remove()

        for i, counter of @model.getCounterList()# ...
            # add dom element
            $(@listId).append("""
                <li class="counter">
                    <div class="counts">#{counter.counts.length}</div>
                    <div class="name">#{counter.name}</div>
                </li>
            """);

            # bind events
            @getLastListItem().find('.counts').bind 'click', counter, @clickOnCounter

    clickOnCounter: (event) =>
        counter = event.data
        counter.count()
        $(event.target).html counter.getAmount()
        @model.persist()

    getListItems: ->
        $(@listId).children()

    getLastListItem: ->
        @getListItems().last()

class CounterAddView
    addForm: '#add form'
    nameField: '#name'

    constructor: (counterList) ->
        @model = counterList

    render: ->
        $(@addForm).submit (e) =>
            e.preventDefault();
            name = $(@nameField).val();
            if name.length == 0
                $(@).removeClass('active')
                $(@nameField).focus()
                return false

            $('#add .back').click();
            @model.add(
                name: name
                type: 'default'
            );
            @model.persist();
            @reset();

    reset: ->
        $(@name_field).val();

class @Quantify
    constructor: () ->
        @storage = new LocalStorageJson()
        @counterList = new CounterList(@storage)
        @counterListView = new CounterListView(@counterList)
        @counterAddView = new CounterAddView(@counterList)

    run: ->
        @counterListView.render()
        @counterAddView.render()

