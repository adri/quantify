class Counter
    @type = 'default'

    constructor: (name, counts) ->
        @name = name
        @counts = counts

    count: ->
        @counts.push({time: new Date()});

    clear: ->
        @counts = []

    getAmount: ->
        @counts.length

class CurrencyCounter extends Counter
    @type = 'currency'

class WeightCounter extends Counter
    @type = 'weight'

class DurationCounter extends Counter
    @type = 'duration'


class CounterFactory
    create: (counter) ->
        new Counter(counter.name, counter.counts)

class CounterList
    constructor: (storage) ->
        @counterList = []
        @storage = storage
        @load()

    add: (counter) ->
        @counterList.push CounterFactory.create(counter)

    persist: ->
        @storage.setItem("counter_list", self.counters);

    load: ->
        for counter in @storage.getItemOrElse("counter_list", [])
            @add(counter)

    getCounterList: ->
        @counterList

class LocalStorageJson
    setItem: (name, value) ->
        JSON.stringify(localStorage.setItem(name, value))

    getItem: (name) ->
        JSON.parse(localStorage.getItem(name))

    getItemOrElse: (name, returnValue) ->
        return @getItem(name) if @getItem(name)
        returnValue

class CounterListView
    @id = '#counter_list'

    constructor: (counterList) ->
        @model = counterList

    render: ->
        for item in @getListItems()
            $(item).unbind()
            $(item).remove()

        for i, counter of @model.getCounterList()# ...
            # add dom element
            $(listId).append('<li class="counter">' +
                '<div class="counts">' + counter.counts.length + '</div>' +
                '<div class="name">' + counter.name + '</div>' +
                '</li>');

            # bind events
            @getListItems().last().find('.counts').click () -> $.proxy(() ->
                @count();
                $(e.target).html(@value());
                @model.persist();
            , counter);

    getListItems: ->
        $(@id).children

class CounterAddView
    @form = '#new_counter'
    @nameField = '#name'

    constructor: (counterList) ->
        @model = counterList

    render: ->
        $(@form).submit (e) ->
            debugger
            e.preventDefault();
            name = $(@nameField).val();
            if name.length == 0
                $(@).removeClass('active')
                $(@nameField).focus()
                return false

            $('#add .back').click();
            @model.add(CounterFactory.create({name: name, type: 'default'}));
            @model.persist();
            @reset();

class Quantify
    constructor: () ->
        @storage = new LocalStorageJson()
        @counterList = new CounterList(@storage)
        @counterListView = new CounterListView(@counterList)
        @counterAddView = new CounterAddView(@counterList)

    run: ->
        console.debug @counterList
        @counterListView.render()
        @counterAddView.render()

