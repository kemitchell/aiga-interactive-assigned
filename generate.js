process.stdout.write(
  require('plaintemplate')(
    require('fs').readFileSync('/dev/stdin').toString(),
    { 'Monthly Maintenance': ( process.argv[2].toLowerCase() === 'monthly' ) },
    undefined, // default plaintemplate directives
    { open: '((', close: '))', start: 'start', end: 'end' }))
