<!--
Laget av Jan Helge
Kontrollert av Joakim Selvik
-->
<?php
ini_set('max_execution_time', 300);
$merged = new DOMDocument("1.0", "UTF-8");
$xmlLufthavner = array();
$xmlVaer = array();

$nettsideKoder = array("DLD", "OSL", "GLL", "ALF", "BVG", "BJF", "HFT", "HAA", "HVG", "KKN", "LKL", "MEH", "VDS",
    "VAW", "HMR", "BGO", "SRP", "KSU", "MOL", "HOV", "AES", "ANX", "BOO", "BNN", "EVE", "LKN", "MQN", "MJF", "NVK",
    "RET", "SSJ", "SKN", "SVJ", "VRY", "VDB", "HAU", "SVG", "FRO", "FDE", "SDN", "SOG", "LYR", "OSY", "RVK", "TRD",
    "RRS", "OLA", "NTB", "SKE", "BDU", "SOJ", "TOS", "FAN", "KRS", "TRF");


$vaerdataKoder = array("Oslo/Oslo/Akershus_fylke","Aust-Agder/Arendal/Aust-Agder_fylke","Buskerud/Drammen/Buskerud_fylke",
    "Finnmark/Vadsø/Finnmark_fylke","Hedmark/Hamar/Hedmark_fylke","Hordaland/Bergen/Hordaland_fylke","Jan_Mayen/Jan_Mayen_målestasjon",
    "Møre_og_Romsdal/Molde/Møre_og_Romsdal_fylke","Nordland/Bodø/Nordland_fylke","Trøndelag/Steinkjer/Nord-Trøndelag_fylke",
    "Oppland/Lillehammer/Oppland_fylke","Oslo/Oslo/Oslo_fylke","Rogaland/Stavanger/Rogaland_fylke","Sogn_og_Fjordane/Leikanger/Sogn_og_Fjordane_fylke",
    "Svalbard/Svalbard_lufthavn_målestasjon","Trøndelag/Trondheim/Sør-Trøndelag_fylke","Telemark/Skien/Telemark_fylke","Troms/Tromsø/Troms_fylke",
    "Vest-Agder/Kristiansand/Vest-Agder_fylke","Vestfold/Tønsberg/Vestfold_fylke","Østfold/Sarpsborg/Østfold_fylke");

$cacheName = 'cached.xml';
$ageInSeconds = 6000;


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

    $rootElement = $merged->createElement("Data");
    $merged->appendChild($rootElement);
    $root = $merged->getElementsByTagName('Data')->item(0);




    for($i = 0; $i < count($xmlLufthavner); $i++){
        $value = $xmlLufthavner[$i];
        $items = $value->getElementsByTagName('airport');
        for($j = 0; $j <$items->length; $j++){
                $item2 = $items->item($j);
                $item1 = $merged->importNode($item2, true);
                $root->appendChild($item1);
        }
    }



    for($i = 0; $i < count($xmlVaer); $i++){
        $value = $xmlVaer[$i];
        $items = $value->getElementsByTagName('weatherdata');
        for($j = 0; $j < $items->length; $j++){
            $item2 = $items->item($j);
            $item1 = $merged->importNode($item2, true);
            $root->appendChild($item1);
        }
    }

    $merged->save('merged.xml');

    $xml = new DOMDocument();
    $xml->load("merged.xml");

    $contents = file_get_contents('merged.xml');
    file_put_contents($cacheName, $contents);
}


$xsl = new DOMDocument();
$xsl->load("dataInnhenting.xsl");


$xslt = new XSLTProcessor();
$xslt->importStylesheet($xsl);
echo $xslt->transformToXML($xml);





?>

