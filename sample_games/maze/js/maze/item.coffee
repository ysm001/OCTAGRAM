

class Item
  constructor: (@name = "item") ->

class Key extends Item
  constructor: () ->
    super("key")


