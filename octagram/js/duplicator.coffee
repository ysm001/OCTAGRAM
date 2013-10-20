class Duplicator
  @copyOctagramObject : (local) ->
    for key, value of local.parent.octagram
      console.log('duplicate : ' + 'octagram.' + key)
      local[key] = value
