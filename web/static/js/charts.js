window.chartOptions = {
  colors: ['#c76baa', '#5fbae9', '#bfd849', '#f15729', '#f4da5c', '#66ddd2'],
  plotOptions: {
    areaspline: {
       marker: {
        radius: 2
       },
       lineWidth: 1,
       states: {
        hover: {
          lineWidth: 1
        }
      },
      threshold: null
    },
    pie: {
      allowPointSelect: true,
      cursor: 'pointer',
      dataLabels: {
          enabled: false
      },
      showInLegend: true
    }
  },
  title: {
    text: '',
  },
  tooltip: {
    backgroundColor: 'rgba(0, 0, 0, 0.7)',
    borderWidth: 0,
    formatter: function() {
      let eventsList = '';
      //this.point.events.forEach(function(event) {
        //eventsList = eventsList + `<li>${event.name}: ${event.amount}</li>`;
      //});
      return `<header>${this.x}</header>
        <ul>${eventsList}</ul>
        <footer><strong>Balance:</strong> $${this.y}</footer>`;
    },
    padding: 12,
    style: {"color": "#FFF"},
    useHTML: true
  },
  yAxis: {
    gridLineColor: '#c76baa1A',
    labels: {
      formatter: function() {
        return `$${this.value / 1000}k`;
      }
    },
    min: 0,
    title: {
      text: '',
    },
  },
  xAxis: {
    labels: {
      format: '{value:%b %d}'
    },
    lineColor: '#c76baa80',
    tickColor: '#c76baa40',
    title: {
      text: '',
    },
    type: 'datetime'
  },
};
