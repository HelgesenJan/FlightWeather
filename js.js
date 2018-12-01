/*
Laget av Jan Helge
Kontrollert av Joakim Selvik
 */


var flyhavner = [];


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

function run(){
    document.getElementById("minInput").value = "";
    document.getElementById("myList").innerHTML = "";
    flyhavner = [];
    getXML("merged.xml", function (xml) {
        var airport, element, list, item, link, nyListe, id, row, getInput, inputen, filter, ul, li, a;


        airport = xml.getElementsByTagName("airport");
        for (var i = 0; i < airport.length; i++) {
            element = airport[i];
            if (element.getAttribute("name")) {
                flyhavner.push(element.getAttribute("name"));
            }
            list = document.createElement('ul');
            list.setAttribute("tabindex", "1");
            list.setAttribute("id", "minUL");
        }


        for (var j = 0; j < flyhavner.length; j++) {
            item = document.createElement('li');
            item.setAttribute("id", flyhavner[j]);
            link = document.createElement('a');
            item.appendChild(link);
            link.appendChild(document.createTextNode(flyhavner[j]));

            list.appendChild(item);
            document.getElementById('myList').appendChild(list);

            nyListe = document.getElementById(flyhavner[j]);
            nyListe.addEventListener('click', setActive, false);


            function setActive(evt) {
                var elements = document.querySelector(".active");
                if(elements !== null){
                    elements.classList.remove("active");
                }
                evt.target.className = "active";
            }

            nyListe.addEventListener('click', listeTrykk, false);
            function listeTrykk(evt) {
                document.querySelector(".hide").style.display = "block";
                airport = xml.getElementsByTagName("airport");
                for (var i = 0; i < airport.length; i++) {
                    element = airport[i];
                    id = evt.target.id;

                    row = document.getElementsByClassName("tr2")[i];

                    if(row != null){
                        if (element.textContent === id) {
                            row.style.display = "block";
                        }else{
                            row.style.display = "none";
                        }
                    }else{
                    }
                }
            }

            getInput = document.getElementById("minInput");
            getInput.addEventListener('keyup', filtrerSok, false);
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
        }
    });
}
run();

