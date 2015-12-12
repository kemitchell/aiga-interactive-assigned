var plaintemplate = require('plaintemplate')

var monthly = ( process.argv[2].toLowerCase() === 'monthly' )
var options = { 'Monthly Maintenance': monthly }

var template = require('fs').readFileSync('/dev/stdin').toString()
process.stdout.write(
  plaintemplate(
    template,
    options,
    undefined,
    { open: '((',
      close: '))',
      start: 'start',
      end: 'end' }))
