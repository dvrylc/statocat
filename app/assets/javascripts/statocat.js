Chart.defaults.global.animation = false;

$(document).on("page:change", function() {

    if ($(".username").text().trim() != "") {
        
        // Repos
        $.ajax({
            method: "get",
            url: document.URL + "/repo-languages",
            dataType: "json",
            success: function(data) {

                var repoLanguagesData = [];
                
                for (var i = 0; i < Object.keys(data).length; i++) {
                    repoLanguagesData.push({
                        value: data[Object.keys(data)[i]],
                        color: '#'+(Math.random()*0xFFFFFF<<0).toString(16),
                        label: Object.keys(data)[i]
                    });
                }
                var repoLanguagesCanvas = $(".repo-languages").get(0).getContext("2d");

                var repoLanguagesChart = new Chart(repoLanguagesCanvas).Pie(repoLanguagesData);

            }
        })

        // Languages
        $.ajax({
            method: "get",
            url: document.URL + "/code-languages",
            success: function(data) {
                
                var codeLanguagesData = [];

                for (var i = 0; i < Object.keys(data).length; i++) {
                    codeLanguagesData.push({
                        value: data[Object.keys(data)[i]],
                        color: '#'+(Math.random()*0xFFFFFF<<0).toString(16),
                        label: Object.keys(data)[i]
                    });
                }

                var codeLanguagesCanvas = $(".code-languages").get(0).getContext("2d");

                var codeLanguagesChart = new Chart(codeLanguagesCanvas).Pie(codeLanguagesData);

            }
        })

    }

});