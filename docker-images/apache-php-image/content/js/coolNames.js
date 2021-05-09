$(function() {

    console.log("loading cool names");
    function loadCoolNames(){
            $.getJSON("/api/names/", function( names ){
                    console.log( names );

                    var message = "";
                    for(i = 0; i < names.length; i++){
                            message +="<h3>"+ names[i].coolName + "</h3><br/>";
                    }

                    console.log(message);

                    $(".coolNamesClass").html(message);

            });
    };

    loadCoolNames();
    setInterval(loadCoolNames, 5000);
});