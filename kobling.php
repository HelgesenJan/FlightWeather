<!--
Skrevet av Jan Helge Helgesen (kandidatnr: 120)
Kontrollert av Joakim Selvik (kandidatnr: 118)
-->
<?php
// Setter opp den maksimale lastetiden i ini-filen
ini_set('max_execution_time', 300);
$merged = new DOMDocument("1.0", "UTF-8");

// Oppretter tomme arrays som fylles med data
$xmlLufthavner = array();
$xmlVaer = array();

// Oppretter arrays som inneholder delen av URL
//$nettsideKoder = array("DLD", "OSL", "GLL", "ALF", "BVG", "BJF", "HFT", "HAA", "HVG", "KKN", "LKL", "MEH", "VDS",
//    "VAW", "HMR", "BGO", "SRP", "KSU", "MOL", "HOV", "AES", "ANX", "BOO", "BNN", "EVE", "LKN", "MQN", "MJF", "NVK",
//    "RET", "SSJ", "SKN", "SVJ", "VRY", "VDB", "HAU", "SVG", "FRO", "FDE", "SDN", "SOG", "LYR", "OSY", "RVK", "TRD",
//    "RRS", "OLA", "NTB", "SKE", "BDU", "SOJ", "TOS", "FAN", "KRS", "TRF");

$vaerdataKoder = array("Aust-Agder/Arendal/Aust-Agder_fylke","Buskerud/Drammen/Buskerud_fylke","Finnmark/Vadsø/Finnmark_fylke",
    "Hedmark/Hamar/Hedmark_fylke","Hordaland/Bergen/Hordaland_fylke","Trøndelag/Trondheim/Sør-Trøndelag_fylke","Telemark/Skien/Telemark_fylke",
    "Møre_og_Romsdal/Molde/Møre_og_Romsdal_fylke","Nordland/Bodø/Nordland_fylke","Oslo/Oslo/Akershus_fylke","Trøndelag/Steinkjer/Nord-Trøndelag_fylke",
    "Vestfold/Tønsberg/Vestfold_fylke","Østfold/Sarpsborg/Østfold_fylke","Oppland/Lillehammer/Oppland_fylke","Oslo/Oslo/Oslo_fylke",
    "Rogaland/Stavanger/Rogaland_fylke","Sogn_og_Fjordane/Leikanger/Sogn_og_Fjordane_fylke","Troms/Tromsø/Troms_fylke","Vest-Agder/Kristiansand/Vest-Agder_fylke");

$nettsideKoder = array("AES","ALF","ANX","BDU","BGO","BJF","BNN","BOO","BVG","DLD","EVE","FAN","FDE","FRO",
    "GLL","HAA","HAU","HFT","HMR","HOV","HVG","KKN","KRS","KSU","LKL","LKN","LYR","MEH",
    "MJF","MOL","MQN","NTB","NVK","OLA","OSL","OSY","RET","RRS","RVK","SDN","SKE","SKN",
    "SOG","SOJ","SRP","SSJ","SVG","SVJ","TOS","TRD","TRF","VAW","VDB","VDS","VRY");

//$vaerdataKoder = array("Oslo/Oslo/Akershus_fylke","Aust-Agder/Arendal/Aust-Agder_fylke","Buskerud/Drammen/Buskerud_fylke",
//    "Finnmark/Vadsø/Finnmark_fylke","Hedmark/Hamar/Hedmark_fylke","Hordaland/Bergen/Hordaland_fylke",
//    "Møre_og_Romsdal/Molde/Møre_og_Romsdal_fylke","Nordland/Bodø/Nordland_fylke","Trøndelag/Steinkjer/Nord-Trøndelag_fylke",
//    "Oppland/Lillehammer/Oppland_fylke","Oslo/Oslo/Oslo_fylke","Rogaland/Stavanger/Rogaland_fylke","Sogn_og_Fjordane/Leikanger/Sogn_og_Fjordane_fylke",
//    "Svalbard/Svalbard_lufthavn_målestasjon","Trøndelag/Trondheim/Sør-Trøndelag_fylke","Telemark/Skien/Telemark_fylke","Troms/Tromsø/Troms_fylke",
//    "Vest-Agder/Kristiansand/Vest-Agder_fylke","Vestfold/Tønsberg/Vestfold_fylke","Østfold/Sarpsborg/Østfold_fylke");

// Oppretter en cache fil og setter ventetiden til 1 time
$cacheName = 'cached.xml';
$ageInSeconds = 6000;

// Sjekker om en cache fil allerede eksisterer og om tiden ikke er utløpt. Da laster den fra cache fila, hvis ikke så laster den ny data fra kildene
if (file_exists($cacheName) && (filemtime($cacheName) > (time() - $ageInSeconds ))) {
    $xml = new DOMDocument();
    $xml->load("cached.xml");
}else{
    for($i = 0; $i < count($nettsideKoder); $i++){
        $dom = new DOMDocument();
        array_push($xmlLufthavner, $dom);
        $dom->load("https://flydata.avinor.no/XmlFeed.asp?TimeFrom=1&TimeTo=7&airport=" . $nettsideKoder[$i] . "&direction=D&lastUpdate=2009-03-10T15:03:00Z");
    }

    for($i = 0; $i < count($vaerdataKoder); $i++){
        $dom = new DOMDocument();
        array_push($xmlVaer, $dom);
        $dom->load("https://www.yr.no/sted/Norge/" . $vaerdataKoder[$i] . "/varsel.xml");
    }

    // Oppretter et root element
    $rootElement = $merged->createElement("Data");
    $merged->appendChild($rootElement);
    $root = $merged->getElementsByTagName('Data')->item(0);

    // Går gjennom dataen i arrayet og legger til all dataen for hvert airport element
    for($i = 0; $i < count($xmlLufthavner); $i++){
        $value = $xmlLufthavner[$i];
        $items = $value->getElementsByTagName('airport');
        for($j = 0; $j <$items->length; $j++){
                $item2 = $items->item($j);
                $item1 = $merged->importNode($item2, true);
                $root->appendChild($item1);
        }
    }

    // Går gjennom dataen i arrayet og legger til all dataen for hvert weatherdata element
    for($i = 0; $i < count($xmlVaer); $i++){
        $value = $xmlVaer[$i];
        $items = $value->getElementsByTagName('weatherdata');
        for($j = 0; $j < $items->length; $j++){
            $item2 = $items->item($j);
            $item1 = $merged->importNode($item2, true);
            $root->appendChild($item1);
        }
    }

    // Lagrer resultatet til i en ny fil og laster denne
    $merged->save('merged.xml');
    $xml = new DOMDocument();
    $xml->load("merged.xml");

    // Setter den i merged fila til cache fila
    $contents = file_get_contents('merged.xml');
    file_put_contents($cacheName, $contents);
}

// Laster XSL fila våre
$xsl = new DOMDocument();
$xsl->load("dataInnhenting.xsl");

// Oppretter XSLT prosessor, importerer stylesheet og transformerer til XML
$xslt = new XSLTProcessor();
$xslt->importStylesheet($xsl);
echo $xslt->transformToXML($xml);





?>

