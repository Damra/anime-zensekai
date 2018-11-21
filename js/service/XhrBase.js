var BASE_URL = "http://animerisuto-we-ds.azurewebsites.net/api/";


function func(method, controller, c, json) {
    var url  = BASE_URL + controller + "/" + method;
    var xhr  = new XMLHttpRequest()
    xhr.open('GET', url, true)
    xhr.onreadystatechange  = function () {
        var users = JSON.parse(xhr.responseText);
        if (xhr.readyState === XMLHttpRequest.DONE && xhr.status === "200") {
            console.table(users);
        } else {
            console.error(users);
        }
    }
    xhr.send(json);
}
