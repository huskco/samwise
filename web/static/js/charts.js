const highChartsOptions = {
  chart: {
    backgroundColor: 'transparent',
    zoomType: 'x'
  },
  colors: ['#c76baa', '#5fbae9', '#bfd849', '#f15729', '#f4da5c', '#66ddd2'],
  legend: {
    enabled: false
  },
  plotOptions: {
    areaspline: {
      fillColor: {
        linearGradient: [0, 0, 0, 300],
        stops: [
          [0, 'rgba(199, 107, 170, 0.5)'],
          [1, 'rgba(199, 107, 170, 0.0)']
         ]
       },
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
      this.point.events.forEach(function(event) {
        eventsList = eventsList + `<li>${event.name}: ${fevent.amount}</li>`;
      });
      return `<header>${formatDate(new Date(this.x))}</header>
        <ul>${eventsList}</ul>
        <footer><strong>Balance:</strong> ${this.y}</footer>`;
    },
    padding: 12,
    style: {"color": "#FFF"},
    useHTML: true
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
  }
};
