if window?
  exports = window.exports
  require = window.require

dataview = require 'dataview'

tags = 
  '_0' : 'TAG_End'
  '_1' : 'TAG_Byte'
  '_2' : 'TAG_Short'
  '_3' : 'TAG_Int'
  '_4' : 'TAG_Long'
  '_5' : 'TAG_Float'
  '_6' : 'TAG_Double'
  '_7' : 'TAG_Byte_Array'
  '_8' : 'TAG_String'
  '_9' : 'TAG_List'
  '_10' : 'TAG_Compound'   
  '_11' : 'TAG_Int_Array'

class TAG
  constructor: (@reader) ->
  readName: =>
    tagName = new TAG_String(@reader)
    @name = tagName.read()
    @name

class TAG_End extends TAG
  readName: => 'END'
  read: => '=END='

class TAG_Unknown extends TAG
  read: => 'unknown tag type'
  
class TAG_Int extends TAG 
  read: => @reader.getInt32()

class TAG_Float extends TAG
  read: => @reader.getFloat32()

class TAG_Double extends TAG
  read: => @reader.getFloat64()

class TAG_Byte extends TAG
  read: @reader.getInt8()

class TAG_Short extends TAG
  read: @reader.getInt16()

class TAG_String extends TAG
  read: =>
    if not @reader? then return 0
    length = @reader.getInt16()
    @reader.getString length

class TAG_Long extends TAG
  read: => @reader.getFloat64()

class TAG_List extends TAG
  read: =>
    type = @reader.getInt8()
    length = @reader.getInt32()
    arr = []
    for i in [0..length-1]
      tag = @reader.read type, '_'+i.toString()
      arr.push tag    
    arr

class TAG_Byte_Array extends TAG
  read: =>
    type = 1
    length = @reader.getInt32()
    @reader.getInt8 length

class TAG_Int_Array extends TAG
  read: =>    
    length = @reader.getInt32()
    @reader.getInt32 length



class TAG_Compound extends TAG
  read: =>
    obj ={}     
    i = 0
    tag = 'dummy'
    while tag? and tag isnt '=END=' and i < 16
      tag = @reader.read()
      if tag? and tag isnt '=END='
        for key, val of tag
          obj[key] = val
      i++
    obj    


class NBTReader extends dataview.jDataView
  read: (typespec) =>
    type = null
    if not typespec?
      type = @getUint8()
      if not type? then return null
    else
      type = typespec    

    typeStr = '_'+type.toString()
    name = tags[typeStr];

    switch name
      when 'TAG_End'        then tag = new TAG_End(this)
      when 'TAG_Byte'       then tag = new TAG_Byte(this)
      when 'TAG_Short'      then tag = new TAG_Short(this)
      when 'TAG_Int'        then tag = new TAG_Int(this)
      when 'TAG_Long'       then tag = new TAG_Long(this)
      when 'TAG_Float'      then tag = new TAG_Float(this)
      when 'TAG_Double'     then tag = new TAG_Double(this)
      when 'TAG_Byte_Array' then tag = new TAG_Byte_Array(this)
      when 'TAG_Int_Array'  then tag = new TAG_Int_Array(this)
      when 'TAG_String'     then tag = new TAG_String(this)
      when 'TAG_List'       then tag = new TAG_List(this)
      when 'TAG_Compound'   then tag = new TAG_Compound(this)
      else                       tag = new TAG_Unknown(this)
        
    ret = {}
    name2 = ''
    if not typespec?
      name2 = tag.readName()
      if name is 'TAG_Compound' and name2 is ''
        name2 = 'root'
      ret[name2] = tag.read()
    else
      ret = tag.read()
    ret

exports.NBTReader = NBTReader
