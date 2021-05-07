var Sentencer = require('sentencer');
var express = require('express');
var app = express();


/**
 * When we get a request we send an array of cool names.
 */
app.get('/', function(req, res){
    res.send(generateCoolNames());
});

/**
 * Accept request on port 3000.
 */
app.listen(3000, function(){
    console.log("Accepting HTTP requests on port 3000!");
});

/**
 * This functions generates between 0 and 10 names (adj adj noun)
 * @returns Array containing the names.
 */
function generateCoolNames()
{
    var numberOfNames = Math.floor((Math.random() * 10) + 1);

    var names = [];

    for(var i = 0; i < numberOfNames; ++i)
    {
        names.push({coolName: Sentencer.make("{{ adjective }} {{ adjective }} {{ noun }}")})
    }

    return names;
}