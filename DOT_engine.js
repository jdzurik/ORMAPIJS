var doT = require('dot');
doT.templateSettings = {
  evaluate:    /\{\{([\s\S]+?)\}\}/g,
  interpolate: /\{\{=([\s\S]+?)\}\}/g,
  encode:      /\{\{!([\s\S]+?)\}\}/g,
  use:         /\{\{#([\s\S]+?)\}\}/g,
  define:      /\{\{##\s*([\w\.$]+)\s*(\:|=)([\s\S]+?)#\}\}/g,
  conditional: /\{\{\?(\?)?\s*([\s\S]*?)\s*\}\}/g,
  iterate:     /\{\{~\s*(?:\}\}|([\s\S]+?)\s*\:\s*([\w$]+)\s*(?:\:\s*([\w$]+))?\s*\}\})/g,
  varname: 'it',
  strip: false,
  append: true,
  selfcontained: false
};

//var result ="ww";
/* required process.on event to take in data message from Gentron */
process.on('message', (m) => {

  /* Standared variables templateText aray and jsonObj passed in message m */
  var template = doT.template(m.templateTexts[0]);
  var result = template(m.jsonObj);

  /* sends data back to Gentron */
  process.send(result);

});


