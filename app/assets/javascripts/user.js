/* External functions */
function numberWithCommas(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

function kFormatter(num) {
    return num > 999 ? (num/1000).toFixed(1) + 'k' : num
}

function lineFormatter(num) {
    return (num / 30).toFixed(0);
}

/* Utility functions */
function colorGenerator(key) {
    if (githubLangs[key])
        return githubLangs[key]
    else 
        return "#666";
}

function repoLabelHelper(array) {

    var result = "";
    var keys = Object.keys(array);

    for (var i = 0; i < keys.length; i++) {

        // value
        result += kFormatter(array[keys[i]]);

        // is/are
        if (array[keys[i]] > 1) {
            result += " are ";
        } else {
            result += " is ";
        }

        // key
        result += "<strong><span style=\"color: " + colorGenerator(keys[i]) + "\">" + keys[i] + "</span></strong>";

        // , and .
        if (i+2 < keys.length) {
            result += ", "
        } else if (i+2 == keys.length) {
            result += " and "
        } else {
            result += ". "
        }

    }

    return result;

}

function codeRepoHelper(array) {

    var result = "";
    var keys = Object.keys(array);

    for (var i = 0; i < keys.length; i++) {

        // value
        result += kFormatter(lineFormatter(array[keys[i]]));

        // is/are
        if (array[keys[i]] > 1) {
            result += " are ";
        } else {
            result += " is ";
        }

        // key
        result += "<strong><span style=\"color: " + colorGenerator(keys[i]) + "\">" + keys[i]+ "</span></strong>";

        // , and .
        if (i+2 < keys.length) {
            result += ", "
        } else if (i+2 == keys.length) {
            result += " and "
        } else {
            result += ". "
        }

    }

    return result;

}

function chartHelper(array) {

    var result = []
    var keys = Object.keys(array);

    for (var i = 0; i < keys.length; i++) {
        result.push({
            name: keys[i],
            color: colorGenerator(keys[i]),
            y: array[keys[i]]
        });
    }

    return result;

}

function redirect() {
    if ($(".search-input").val() != "") {
        window.location.href = "/u/" + $(".search-input").val();
    }
}

$(document).on("page:change", function() {

    /* GA */
    (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
    (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
    m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
    })(window,document,'script','//www.google-analytics.com/analytics.js','ga');
    ga('create', 'UA-61019072-1', 'auto');
    ga('send', 'pageview');

    $(".search-input").keyup(function (e) {
        if (e.keyCode == 13) {
            redirect();
        }
    });

    $(".glyphicon-search").click(function() {
        redirect();
    });

    if ($(".username").text().trim() != "") {

        // spin.js
        var opts = {
            lines: 9, // The number of lines to draw
            length: 0, // The length of each line
            width: 12, // The line thickness
            radius: 40, // The radius of the inner circle
            corners: 1, // Corner roundness (0..1)
            rotate: 0, // The rotation offset
            direction: 1, // 1: clockwise, -1: counterclockwise
            color: '#000', // #rgb or #rrggbb or array of colors
            speed: 1.3, // Rounds per second
            trail: 36, // Afterglow percentage
            shadow: false, // Whether to render a shadow
            hwaccel: true, // Whether to use hardware acceleration
            className: 'spinner', // The CSS class to assign to the spinner
            zIndex: 2e9, // The z-index (defaults to 2000000000)
            top: '50%', // Top position relative to parent
            left: '50%' // Left position relative to parent
        };
        var target = document.getElementById("spin");;
        var spinner = new Spinner(opts).spin(target);

        setTimeout(function() {
            $(".loading-message").fadeIn();
        }, 5000);
        
        // Get user's statistics and create charts!
        $.ajax({
            method: "get",
            url: document.URL + "/statistics",
            dataType: "json",
            success: function(data) {

                spinner.stop();
                $(".loading").hide();
                $(".loading-message").remove();
                $(".statistics").fadeIn(function() {

                    // Grab arrays from data
                    var repoData = data.repo_lang;
                    var codeData = data.code_lang;

                    // Create repo languages chart
                    $(".repo-languages .chart").highcharts({
                        credits: {
                            enabled: false
                        },
                        chart: {
                            backgroundColor: "transparent"
                        },
                        title: {
                            text: null
                        },
                        tooltip: {
                            formatter: function() {
                                var x = "● <strong>Repos:</strong> " + this.y + " (" + this.percentage.toFixed(1) + "%)";
                                return x;
                            }
                        },
                        series: [{
                            type: "pie",
                            name: "Repos",
                            data: chartHelper(repoData),
                            dataLabels: {
                                enabled: true
                            }
                        }]
                    });
                    var repoLanguagesLabel = "Of  " + data.total_repos + " repos, " + 
                        repoLabelHelper(repoData) + "The rest were too small to be identified.";
                    $(".repo-languages p").html(repoLanguagesLabel);

                    // Create code languages chart
                    $(".code-languages .chart").highcharts({
                        credits: {
                            enabled: false
                        },
                        chart: {
                            backgroundColor: "transparent"
                        },
                        title: {
                            text: null
                        },
                        tooltip: {
                            formatter: function() {
                                var x = "● <strong>Characters:</strong> " + numberWithCommas(this.y) + 
                                    "<br>● <strong>Lines:</strong> " +  numberWithCommas((this.y / 30).toFixed(0));
                                return x;
                            }
                        },
                        series: [{
                            type: "pie",
                            name: "Characters",
                            data: chartHelper(codeData),
                            dataLabels: {
                                enabled: true
                            }
                        }]
                    });
                    var codeLanguagesLabel = "A total of " + kFormatter(lineFormatter(data.total_characters)) + 
                        " lines, of which " + codeRepoHelper(codeData);
                    $(".code-languages p").html(codeLanguagesLabel);

                    // Populate stars
                    $(".stars table td").first().html(kFormatter(data.total_stars));
                    $(".stars table td").last().html(kFormatter(data.average_stars));

                    // Populate forks
                    $(".forks table td").first().html(kFormatter(data.total_forks));
                    $(".forks table td").last().html(kFormatter(data.average_forks));

                    // Populate pages
                    $(".pages table td").first().html(data.total_pages);
                    $(".pages table td").last().html((data.percentage_pages*100).toFixed(0) + "%");

                    // Populate issues
                    $(".issues table td").first().html(data.total_issues);
                    $(".issues table td").last().html(data.average_issues);

                });

            }
        });

    }

});
