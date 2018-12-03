/*
Skrevet av Jan Helge Helgesen (kandidatnr: 120)
Kontrollert av Joakim Selvik (kandidatnr: 118)
 */

// Funksjon som skjuler/viser den respektive tabellen basert på knappetrykk
function changeTable() {
    var airportTable = document.querySelector(".divBox2");
    var weatherTable = document.querySelector(".divBox3");
    var changeTable = document.getElementById("changeTable");
    var reloadAjax = document.getElementById("reloadAjax");
    var divBox = document.querySelector(".divBox");

    if(airportTable.style.display == 'block'){
        changeTable.value = 'Check airport data';
        airportTable.style.display = 'none';
        weatherTable.style.display = 'block';
        reloadAjax.style.backgroundColor = "transparent";
        reloadAjax.value = "";
        reloadAjax.style.cursor = "none";
        reloadAjax.style.pointerEvents = "none";
        divBox.style.height = "555px";
    }else{
        changeTable.value = 'Check weather data';
        airportTable.style.display = 'block';
        weatherTable.style.display = 'none';
        reloadAjax.style.backgroundColor = 'orange';
        reloadAjax.value = "Reload list with new airports";
        reloadAjax.style.cursor = "pointer";
        reloadAjax.style.pointerEvents = "auto";
        divBox.style.height = "485px";
    }
}

// Oppretter en array som fylles med flyhavner
var flyhavner = [];

// Setter variabelen getXML til en AJAX funksjon med parametere for domenet og callback
var getXML = function (dom, cb) {
    var xhr = new XMLHttpRequest();
    xhr.open("GET", dom);
    xhr.setRequestHeader("Content-type", "text/xml");

    xhr.onreadystatechange = function () {
        if(xhr.readyState === 4 && xhr.status === 200) {
            cb(xhr.responseXML);
        }
    };
    xhr.send();
};

// Oppretter en funksjon som kjøres når siden lastes eller blir kalt på
run();
function run(){
    // Gjemmer og viser diverse elementer i siden
    document.querySelector(".hide").style.display = "none";
    document.getElementById("minInput").value = "";
    document.getElementById("myList").innerHTML = "";
    document.querySelector(".divBox3").style.display = "none";
    document.querySelector(".divBox2").style.display = "block";
    // Setter arrayet flyhavner til tom
    flyhavner = [];
    // Kaller variabelen getXML og gir den vår samlede fil, samt en xml callback
    getXML("merged.xml", function (xml) {
        var airport, element, list, item, link, id, row, nodes, getInput, inputen, filter, ul, li, a;

        // Henter elementene airport i xml fila, går gjennom den og for hvert element så sjekkes det om attributtet "name" eksisterer. Om den gjør det så legges flyhavnen til i arrayet
        airport = xml.getElementsByTagName("airport");
        for (var i = 0; i < airport.length; i++) {
            element = airport[i];
            if (element.getAttribute("name")) {
                flyhavner.push(element.getAttribute("name"));
            }
            // Oppretter lista og setter attributter
            list = document.createElement('ul');
            list.setAttribute("tabindex", "1");
            list.setAttribute("id", "minUL");
        }

        // Henter verdiene i arrayet og oppretter liste elementer og setter en anchor tag til disse. Lista settes inn i et div element på nettsiden
        for (var j = 0; j < flyhavner.length; j++) {
            item = document.createElement('li');
            item.setAttribute("id", flyhavner[j]);
            link = document.createElement('a');
            item.appendChild(link);
            link.appendChild(document.createTextNode(flyhavner[j]));
            list.appendChild(item);
            document.getElementById('myList').appendChild(list);

            // Funksjon som setter elementene man trykker på til aktiv
            function setActive(evt) {
                var elements = document.querySelector(".active");
                if(elements !== null){
                    elements.classList.remove("active");
                }
                evt.target.className = "active";
            }
            // Gir lista setActive funksjonen
            list.addEventListener('click', setActive, false);

            // Funksjon som går gjennom flight elementene i xml fila og sjekker om childNodes av disse er lik tastetrykket.
            function listeTrykk(evt) {
                // Gjemmer og viser noen elementer
                document.getElementById("velkommen").style.display = "none";
                document.querySelector(".hide").style.display = "block";
                id = evt.target.id;
                var flight = xml.getElementsByTagName("flight");
                for (var i = 0; i < flight.length; i++) {
                    element = flight[i];
                    row = document.getElementsByClassName("tr2")[i];
                    nodes = element.childNodes[11];

                    if (nodes.textContent === id) {
                        row.style.display = "block";
                    } else {
                        row.style.display = "none";
                    }
                }
            }
            // Gir lista listeTrykk funksjonen
            list.addEventListener('click', listeTrykk, false);

            // Henter input feltet
            getInput = document.getElementById("minInput");

            // Funksjon som filtrerer for søk i lista
            function filtrerSok() {
                inputen = document.getElementById("minInput");
                filter = inputen.value.toUpperCase();
                ul = document.getElementById("minUL");
                li = ul.getElementsByTagName("li");
                for (var i = 0; i < li.length; i++) {
                    a = li[i].getElementsByTagName("a")[0];
                    if (a.innerHTML.toUpperCase().indexOf(filter) > -1) {
                        li[i].style.display = "";
                    } else {
                        li[i].style.display = "none";
                    }
                }
            }
            // Gir inputen funksjonen filtrerSok
            getInput.addEventListener('keyup', filtrerSok, false);
        }
    });
}



