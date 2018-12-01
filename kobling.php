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

$cacheName = 'cached.xml';
$ageInSeconds = 700;


if (file_exists($cacheName) && (filemtime($cacheName) > (time() - $ageInSeconds ))) {
    $xml = new DOMDocument();
    $xml->load("cached.xml");
}else{
    for($i = 0; $i < count($nettsideKoder); $i++){
        $dom = new DOMDocument();
        array_push($xmlLufthavner, $dom);

        $dom->load("https://flydata.avinor.no/XmlFeed.asp?TimeFrom=1&TimeTo=7&airport=" . $nettsideKoder[$i] . "&direction=D&lastUpdate=2009-03-10T15:03:00Z");
    }


    $rootElement = $merged->createElement("Data");
    $merged->appendChild($rootElement);
    $root = $merged->getElementsByTagName('Data')->item(0);


    for($i = 0; $i < count($xmlLufthavner); $i++){
        $value = $xmlLufthavner[$i];
        $items = $value->getElementsByTagName('airport');
        for($o = 0; $o <$items->length; $o++){
                $item2 = $items->item($o);
                $item1 = $merged->importNode($item2, true);
                $root->appendChild($item1);
        }
    }

    for($i = 0; $i < count($xmlVaer); $i++){
        $value = $xmlVaer[$i];
        $items = $value->getElementsByTagName('weatherdata');
        for($j = 0; $o < $items->length; $j++){
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

