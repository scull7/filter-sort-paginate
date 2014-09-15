"use strict"
var path        = require('path'),
    rewire      = require('rewire');
global.sinon    = require('sinon');
global.chai     = require('chai');
global.should   = require('chai').should();
global.expect   = require('chai').expect;
global.rewire   = rewire;
global.AssertionError = require('chai').AssertionError;

global.requireTarget  = function (target) {
  return require( path.join(__dirname, '../', target) );
};

global.rewireTarget     = function (target) {
    return rewire( path.join(__dirname, '../', target) );
};

global.swallow  = function (thrower) {
  try {
    thrower();
  } catch (e) {}
};

var sinonChai = require('sinon-chai');
chai.use(sinonChai);
