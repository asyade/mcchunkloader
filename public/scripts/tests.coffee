if window?
  exports = window.exports
  require = window.require

data = undefined

binaryhttp = require 'binaryhttp'
region = require 'region'
chunkdata = require 'chunkdata'
render = require 'render'
nbt = require 'nbt'

whichChunks = (region) ->
  count = 0
  chunks = {}

onProgress = (evt) ->

done = (arraybuffer) ->
  data = arraybuffer
  console.log arraybuffer
  testregion = new region.Region(data)
  console.log testregion
  whichChunks testregion
  renderer = new render.RegionRenderer(testregion)

exports.runTests = ->
  binaryhttp.loadBinary '/r.0.0.mca', onProgress, done
   