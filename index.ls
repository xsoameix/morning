data = require './data.json'
comments = data.groups[0].comments ++ data.groups[1].comments
questions = data.questions.slice 0, 7
questionsDom = questions.map (question, i) ->
  React.createElement 'div', {key: i, className: 'ui vertical segment'},
    React.createElement('div', {className: 'ui medium header'}, question),
    React.createElement('div', {id: 'container' + i}, null)
questionsDom ++=
  React.createElement 'div', {key: 7, className: 'ui vertical segment'},
    React.createElement('div', {className: 'ui medium header'},
      data.questions[7]),
    React.createElement('div', {id: 'container' + 7 + 0}, null),
    React.createElement('div', {id: 'container' + 7 + 1}, null),
questionsDom ++=
  for i from 8 to 9
    React.createElement 'div', {key: i, className: 'ui vertical segment'},
      React.createElement('div', {className: 'ui medium header'},
        data.questions[i]),
      comments.filter (comment) ->
        /^(|無|未知)$/ != comment[i]
      .map (comment) ->
        React.createElement 'div', {className: 'ui segment'},
          React.createElement 'p', {}, comment[i]
root =
  React.createElement 'div', {}, questionsDom

ReactDOM.render root, document.getElementById('app'), ->
  questions.forEach (question, i) ->
    counts = Array 4 .fill 0
    comments.forEach (comment) ->
      counts[comment[i] - 1]++
    Highcharts.chart 'container' + i, do
      chart: {renderTo: 'container', type: 'column'}
      tooltip:
        headerFormat: '<p style="font-size: 12pt">{point.key}</p><br>'
        style:
          fontSize: '12pt'
      title: {text: ''}
      xAxis:
        labels: {style: {fontSize: '16pt'}}
        categories: ['非常同意', '同意', '不同意', '非常不同意']
      yAxis: {title: {text: null}}
      series: [{showInLegend: false, name: '票數', data: counts}]
  pieColors = do ->
    colors = []
    base = Highcharts.getOptions!colors[0]
    for i from 0 til 40
      colors.push Highcharts.Color(base).brighten((8 - i) / 40).get!
    colors
  genPie = (id) ->
    groups = {}
    comments.forEach (comment) ->
      label = comment[7][id]
      if label == ''
        label = '沒意見'
      if groups[label] == undefined
        groups[label] = 1
      else
        groups[label]++
    total = 0
    for k, v of groups
      total += v
    percents = []
    for k, v of groups
      percents.push do
        name: k
        y: v / total
    percents = percents.sort (a, b) ->
      a = a.y
      b = b.y
      if a < b
        return -1
      if a > b
        return 1
      0
    Highcharts.chart 'container' + 7 + id, do
      chart: {type: 'pie'}
      title: {text: ['夏', '冬'][id]}
      plotOptions:
        pie:
          colors: pieColors
          dataLabels:
            enabled: true
            format: '<b>{point.name}</b>: {point.percentage:.1f} %'
      series: [{showInLegend: false, name: '票數', data: percents}]
  genPie 0
  genPie 1
