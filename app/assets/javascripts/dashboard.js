/*global $, AmCharts, console */

function ageChart(question_id, index, title) {
  var chart, graph, categoryAxis;
  $.get('/admin/reports/question_responses.json?question_id=' + question_id, function (data, textStatus, jqXHR) {
    if (data.reports.length > 0) {
      var html = '<div class="blank_slate" id="chart_' + index + '" style="width: 95%; height: 400px;"></div>';
      $('.column:nth(' + (index % 2) + ')').append(html);

      chart = new AmCharts.AmPieChart();
      chart.balloon = { 'fixedPosition': true };
      chart.addTitle(title);
      chart.dataProvider = data.reports;
      chart.labelRadius = 4;
      // chart.labelText = '[[percents]]%';
      chart.innerRadius = 50;
      chart.pullOutRadius = 20;
      chart.titleField = 'the_cat';
      chart.valueField = 'value';
      chart.write('chart_' + index);
    }
  });
}

function usersByAttribute(data, label, index) {
  var html = '<div class="blank_slate" id="chart_users_by_' + label + '" style="width: 95%; height: 400px;"></div>';
  $('.column:nth(' + (index % 2) + ')').append(html);
  var chart = AmCharts.makeChart("", {
    "type": "pie",
    "theme": "light",
    "dataProvider": data,
    "labelRadius": 1,
    "valueField": "users_count",
    "titleField": "question",
    "balloon":{
      "fixedPosition":true
    },
    "groupPercent": 1.5,
    "groupedPulled": true,
    "groupedTitle": '< 1.5%',
    "innerRadius": 50,
    "pullOutRadius": 20,
  });
  chart.addTitle('Users by ' + label);
  chart.write('chart_users_by_' + label);
};

$(document).ready(function () {
  if ($('.admin_dashboard').length === 1) {
    AmCharts.ready(function () {
      AmCharts.theme = AmCharts.themes.light;
      $.get('/admin/reports/question_with_answers.json', function (data, textStatus, jqXHR) {
        $.each(data.reports, function (index, value) {
          ageChart(value.id, index, value.text);
        });
      });
      var index = 0;
      $.get('/admin/reports/users_statistics.json', function (data, textStatus, jqXHR) {
        $.each(data, function( key, value ) {
          usersByAttribute(value, key, index);
          index++;
        });
      });

    });
  }
});
