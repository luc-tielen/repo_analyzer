
const requestAnimationFrame = window.requestAnimationFrame
  || window.mozRequestAnimationFrame
  || window.webkitRequestAnimationFrame
  || window.msRequestAnimationFrame

let chart = null

// Helper function that does the actual drawing using ChartJS.
drawChartImpl = (deltas) => {
  if (chart) { chart.destroy() }
  chart = new Chart(document.getElementById("deltas-chart"), {
    type: 'line',
    data: {
      labels: deltas.map(delta => new Date(delta.time)),
      datasets: [
        {
          data: deltas.map(delta => delta.additions),
          label: "Additions",
          pointBackgroundColor: "green",
          backgroundColor: "green",
          borderColor: "green",
          fill: false
        },
        {
          data: deltas.map(delta => delta.deletions),
          label: "Deletions",
          pointBackgroundColor: "red",
          backgroundColor: "red",
          borderColor: "red",
          fill: false
        }
      ]
    },
    options: {
      title: { display: false },
      legend: {
        display: false,
      },
      datasetFill: true,
      tooltips: {
        custom: (tooltip) => {
          if (!tooltip) return
          tooltip.displayColors = false
        },
        callbacks: {
          title: (item, data) => { return null },
          label: (item, data) => {
            const delta = deltas[item.index]
            const timestamp = new Date(delta.time).toDateString()
            return [
              `Author: ${delta.author}`,
              `Commit: ${delta.commit}`,
              `Timestamp: ${timestamp}`,
              `Additions: ${delta.additions}`,
              `Deletions: ${delta.deletions}`,
              '',
              'Summary:',
            ].concat(delta.summary.split("\n"))
          }
        }
      },
      elements: {
        line: {
          cubicInterpolationMode: 'monotone'
        },
        point: {
          radius: 2
        }
      },
      scales: {
        xAxes: [{
          ticks: {
            autoSkip: false,
            maxRotation: 90,
            minRotation: 90
          },
          type: 'time',
          time: {
            displayFormats: {
              day: 'MMM D YYYY'
            }
          }
        }],
        yAxes: [{
          ticks: {
            beginAtZero: true
          },
          scaleLabel: {
            display: true,
            labelString: 'Deltas (LOC)',
          }
        }]
      },
      animation: { duration: 0 },
      hover: { animationDuration: 0 },
      responsiveAnimationDuration: 0
    }
  })
}

// Helper function for drawing a chart using Chart.js
drawChart = (deltas) => {
  // wait for DOM to be rendered
  let reversed_deltas = deltas.reverse()
  requestAnimationFrame(() => {
    drawChartImpl(reversed_deltas)
  })
}

