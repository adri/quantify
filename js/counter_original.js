/**
 * A counter has a name and multiple data points
 */
function Counter(name, counts) {
  if (!(this instanceof arguments.callee)) {
    return new arguments.callee(arguments);
  }
  var self = this;
  self.name = name;
  self.counts = counts;

  /**
   * Adds a count for current counter
   */
  self.count = function() {
    counts.push({time: new Date()});
  };

  /**
   * Returns counters current value
   */
  self.value = function() {
    return counts.length;
  };

  /**
   * Clears all counts
   */
  self.clear = function() {
    counts = [];
  };
}

/**
 * CounterList contains multiple counters
 */
function CounterList(listId) {
  if (!(this instanceof arguments.callee)) {
    return new arguments.callee(arguments);
  }

  var self = this;
  self.counters = [];

  /**
   * Add a new counter
   * @param string Name
   * @param string (optional) Start counters
   */
  self.add = function(name, counts) {
      if (typeof counts == "undefined") {
        counts = [];
      }
      self.counters.push(new Counter(name, counts));
  };

  /**
   * Store all counters
   */
  self.saveCounters = function () {
    localStorage.setItem("counter_list", JSON.stringify(self.counters));
  };

  /**
   * Load counters from storage
   */
  self.loadCounters = function () {
    var counterList = JSON.parse(localStorage.getItem("counter_list"));

    for (var i in counterList){
      self.add(counterList[i].name,
               counterList[i].counts);
    }
  };

  /**
   * Deletes all counters
   */
  self.deleteCounters = function () {
    localStorage.setItem("counter_list", null);
  };

  /**
   * Display counters and bind events
   * @param string CSS selector where the counters should be drawn in
   */
  self.draw = function() {
    // unbind previous elements
    $(listId).children().each(function(i, listItem) {
      $(listItem).unbind();
      $(listItem).remove();
    });

    // add elements
    $(self.counters).each(function (i, counter) {
      // add element
      $(listId).append('<li class="counter">'
        + '<div class="counts">' + counter.counts.length + '</div>'
        + '<div class="name">' + counter.name + '</div>'
        + '</li>');

      // bind event
      var listItem = $('#counter_list').children().last().find('.counts');
      listItem.click($.proxy(function(e) {
        this.count();
        $(e.target).html(this.value());
        self.saveCounters();
      }, counter));

    });

  };

  self.debug = function() {
    var counter;
    for (var i in self.counters) {
      counter = self.counters[i];
    }
  };
}