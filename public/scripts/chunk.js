(function() {
  var Chunk, exports, require,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  if (typeof window !== "undefined" && window !== null) {
    exports = window.exports;
    require = window.require;
  }

  Chunk = (function() {

    function Chunk(nbt) {
      this.nbt = nbt;
      this.getBlockAt = __bind(this.getBlockAt, this);
    }

    Chunk.prototype.getBlockAt = function(x, y, z) {
      var blockpos, section, sectionnum;
      return null;
      if (!(this.nbt.root.Level.Sections != null)) return;
      sectionnum = Math.floor(y / 16);
      blockpos = y * 16 * 16 + z * 16 + x;
      section = this.nbt.root.Level.Sections[sectionnum];
      if (!(section != null) || (!((section != null ? section.Blocks : void 0) != null))) {
        return -1;
      } else {
        return section.Blocks[blockpos];
      }
    };

    return Chunk;

  })();

  exports.Chunk = Chunk;

}).call(this);
