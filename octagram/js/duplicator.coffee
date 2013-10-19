class Duplicator
  @copyOctagramObject : (local) ->
    ignores = ['Resources', 'TipUtil']
  
    for key, value of local.parent.octagram
      if !(key in ignores)
        console.log('duplicate : ' + 'octagram.' + key)
        local[key] = value
      else console.log('ignore : ' + 'octagram.' + key)

  @copyEnchantObject : (local) ->
    targets = ['Sprite']
  
    for key, value of local.parent.enchant
      if (key in targets)
        console.log('duplicate : ' + 'enchant.' + key)
        local[key] = value
      else console.log('ignore : ' + 'enchant.' + key)
