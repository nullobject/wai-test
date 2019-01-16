import { Signal } from 'bulb'

const eventSource = new EventSource('/eschan')

const s = Signal
  .fromEvent('message', eventSource)
  .map(a => new Date(parseInt(a.data)))

s.subscribe(a => {
  document.getElementById('results').textContent = a.toUTCString()
})
