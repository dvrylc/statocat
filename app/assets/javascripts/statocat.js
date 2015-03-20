Chart.defaults.global.animation = false;
Chart.defaults.global.responsive = true;

$(document).on("page:change", function() {

    if ($(".username").text().trim() != "") {
        
        // Get user's statistics and create charts!
        $.ajax({
            method: "get",
            url: document.URL + "/statistics",
            dataType: "json",
            success: function(data) {

                // Grab JSON arrays from data
                var repoData = data.repo_lang;
                var codeData = data.code_lang;

                // Create repo languages chart
                var repoLanguagesData = [];
                for (var i = 0; i < Object.keys(repoData).length; i++) {
                    repoLanguagesData.push({
                        value: repoData[Object.keys(repoData)[i]],
                        color: githubLangs[Object.keys(repoData)[i]],
                        label: Object.keys(repoData)[i]
                    });
                }
                var repoLanguagesCanvas = $(".repo-languages").get(0).getContext("2d");
                var repoLanguagesChart = new Chart(repoLanguagesCanvas).Pie(repoLanguagesData);
                $(".repo-languages-label").text("");

                // Create code languages chart
                var codeLanguagesData = [];
                for (var i = 0; i < Object.keys(codeData).length; i++) {
                    codeLanguagesData.push({
                        value: codeData[Object.keys(codeData)[i]],
                        color: githubLangs[Object.keys(codeData)[i]],
                        label: Object.keys(codeData)[i]
                    });
                }
                var codeLanguagesCanvas = $(".code-languages").get(0).getContext("2d");
                var codeLanguagesChart = new Chart(codeLanguagesCanvas).Pie(codeLanguagesData);

            }
        });

    }

});