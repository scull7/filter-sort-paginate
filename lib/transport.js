// `FSPTransport`
// ==============
// This is the FSP Transport object.  This object
// represents the encoding of the FSP instructions
// and response.

function FSPTransport () {
  this.fields   = [];
  this.items    = [];
  this.total    = 0;
  this.sorts    = [];
  this.filters  = [];
  this.limit    = 100;
  this.page     = 1;
}
FSPTransport.prototype = {

};

module.exports = FSPTransport;