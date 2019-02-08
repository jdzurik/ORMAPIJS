var doT = require('dot');
//var result ="ww";
/* required process.on event to take in data message from Gentron */
process.on('message', (m) => {

  /* Standared variables templateText aray and jsonObj passed in message m */
  var template = doT.template(m.templateTexts[0]);
  var result = template(m.jsonObj);
  //console.log("m2");

  /* sends data back to Gentron */
  process.send(result);

});


