window.chartOptions = {
  colors: ['#c76baa', '#5fbae9', '#bfd849', '#f15729', '#f4da5c', '#66ddd2'],
  plotOptions: {
    areaspline: {
      type: "datetime",
      fillColor: {
        linearGradient: [0, 0, 0, 300],
        stops: [
          [0, 'rgba(199, 107, 170, 0.33)'],
          [1, 'rgba(199, 107, 170, 0.0)']
         ]
       },
       marker: {
        radius: 1
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
    backgroundColor: 'rgba(51, 49, 47, 0.7)',
    borderWidth: 0,
    formatter: function() {
      return `<header>${this.key}</header>
        <footer><strong>Balance:</strong> $${this.y.toFixed(2)}</footer>`;
    },
    padding: 12,
    style: {"color": "#FFF"},
    useHTML: true
  },
  xAxis: {
    labels: {
      formatter: function() {
        return ``;
      }
    },
    lineColor: '#eeeeee',
    tickColor: '#eeeeee',
    title: {
      text: '',
    }
  },
  yAxis: {
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
};
