var fs = require('fs')

var directions = JSON.parse(fs.readFileSync(process.argv[2]))
var blanks = JSON.parse(fs.readFileSync(process.argv[3]))

process.stdout.write(
  JSON.stringify(
    Object.keys(blanks)
      .reduce(function(output, key) {
        var value = blanks[key]
        directions
          .filter(function(direction) {
            return direction.identifier === key })
          .forEach(function(direction) {
            output.push({
              blank: direction.path,
              value: value }) })
        return output },
        [ ])))
