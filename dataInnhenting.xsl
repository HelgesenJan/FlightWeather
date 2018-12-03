<?xml version="1.0" encoding="UTF-8"?>

<!--
Laget av Joakim Selvik (kandidatnr: 118)
Kontrollert av Jan Helge Helgesen (kandidatnr: 120)
-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <!--Oppretter et html dokument og lager et template for å kunne hente data fra XML dokumentet -->
    <xsl:output method="html" />
    <xsl:template match="Data">
        <html>
            <head>
                <title>Flyplass oversikt</title>
                <link rel="stylesheet" type="text/css" href="css.css"/>
            </head>
            <body id="body">
                <header>
                </header>
                <!--Opprettet en divBox som inneholder en listefunksjon, søkefunksjon og knapper for
                 å bytte til værdata og for å laste inn flyplasser på nytt (Ajax)-->
                <div class="divBox">
                    <input id="changeTable" type="button" onclick="changeTable()" value="Check weather data"/>
                    <input id="minInput" placeholder="Search for airport.."/>
                    <div id="myList"/>
                    <input id="reloadAjax" type="button" onclick="run()" value="Reload list with new airports"/>
                </div>

                <!--Opprettet en ny divBox som inneholder tabellen for flydata-->
                <div class="divBox2">
                    <form id="table">
                        <div class="planeTable">
                            <!--En border som inneholder tabellrad for informasjon om hva som ligger i tabellen-->
                            <div class="border1">
                                <div class="tr1">
                                    <div class="tc tcO">Date</div>
                                    <div class="tc tcO">Time</div>
                                    <div class="tc tcO">Destination</div>
                                    <div class="tc tcO">Flight</div>
                                    <div class="tc tcO">Gate</div>
                                </div>
                            </div>
                            <!--En ny border som inneholder tabellrader for visning av xml data-->
                            <div class="border2">
                                <!--Velkomstmelding som dukker opp når man laster inn siden, og forklarer hvordan ting fungerer-->
                                <div id="velkommen">
                                    <h1>Welcome!</h1>
                                    <p>This website is part of the XML course at the University of South-Eastern Norway.</p>
                                    <p>The website allows the user to check out Avinor's flight data for each norwegian airport and Yr's weather data forecast for 6 hour intervals.</p>
                                </div>
                                <div class="hide">
                                <!--For-each løkke som går igjennom merged.xml/chached.xml og henter inn valgte flydata-->
                                <xsl:for-each select="airport/flights/flight">
                                    <!--sorterer dataen på dato-->
                                    <xsl:sort select="schedule_time"/>
                                    <!--Ny tabellrad for valgte flydata (dato, klokkeslett, destinasjon, flightnummer og gate)-->
                                    <div class="tr2">
                                        <div class="tc tcY"><xsl:value-of select="substring-before(schedule_time, 'T')"/></div>
                                        <div class="tc tcF"><xsl:value-of select="substring(schedule_time, 12 , 8)"/></div>
                                        <div class="tc tcY"><xsl:value-of select="airport"/></div>
                                        <div class="tc tcF"><xsl:value-of select="flight_id"/></div>
                                        <div class="tc tcY"><xsl:value-of select="gate"/></div>
                                    </div>
                                </xsl:for-each>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>

                <!--Variabel for stien til dataen for værmelding for å spare lengde på kode-->
                <xsl:variable name="wholePath" select="weatherdata/forecast/tabular/time"/>
                <!--Oppretter en divBox for en tabell som inneholder Fylke og værvarsel for de neste 24 timene, fordelt utover en periode på 6 timer-->
                <div class="divBox3">
                    <form id="table2">
                        <div class="weatherTable">
                            <!--En border som inneholder tabellrad for informasjon om hva som ligger i tabellen-->
                            <div class="border1">
                                <!--Opprettet en tabellrad som viser 'County', og kl slett for de neste periodene. Kl. slett endrer seg dynamisk (ved oppdatering av xml)-->
                                <div class="tr3">
                                    <div class="tc tcO">County</div>
                                    <div class="tc tcO">Kl. <xsl:value-of select="substring($wholePath[position()=1]/@from, 12, 2)"/> - <xsl:value-of select="substring($wholePath[position()=1]/@to, 12, 2)"/></div>
                                    <div class="tc tcO">Kl. <xsl:value-of select="substring($wholePath[position()=2]/@from, 12, 2)"/> - <xsl:value-of select="substring($wholePath[position()=2]/@to, 12, 2)"/></div>
                                    <div class="tc tcO">Kl. <xsl:value-of select="substring($wholePath[position()=3]/@from, 12, 2)"/> - <xsl:value-of select="substring($wholePath[position()=3]/@to, 12, 2)"/></div>
                                    <div class="tc tcO">Kl. <xsl:value-of select="substring($wholePath[position()=4]/@from, 12, 2)"/> - <xsl:value-of select="substring($wholePath[position()=4]/@to, 12, 2)"/></div>
                                </div>
                            </div>

                            <!--En ny border som inneholder tabellrader for visning av xml data-->
                            <div class="border2">
                                <!--Variabel for stien til dataen for værmelding for å spare lengde på kode-->
                                <xsl:variable name="forecastPath" select="weatherdata/forecast"/>
                                <!--For-each løkke som går igjennom merged.xml/chached.xml og henter inn valgte flydata-->
                                <xsl:for-each select="$forecastPath">
                                    <xsl:sort select="text/location/@name"/>
                                    <!--Ny tabellrad for valgte værdata (Fylke, Type vær og temperatur på de forskjellige tidspunkter)-->
                                    <div class="tr4">
                                        <xsl:variable name="timePath" select="tabular/time"/>
                                        <div class="tc tcY"><xsl:value-of select="substring-before(text/location/@name, 'fylke')"/></div>
                                        <div class="tc tcF"><xsl:value-of select="$timePath[position()=1]/symbol/@name"/>&#160;&#160;<xsl:value-of select="$timePath[position()=1]/temperature/@value"/>&#x2103;</div>
                                        <div class="tc tcF"><xsl:value-of select="$timePath[position()=2]/symbol/@name"/>&#160;&#160;<xsl:value-of select="$timePath[position()=2]/temperature/@value"/>&#x2103;</div>
                                        <div class="tc tcF"><xsl:value-of select="$timePath[position()=3]/symbol/@name"/>&#160;&#160;<xsl:value-of select="$timePath[position()=3]/temperature/@value"/>&#x2103;</div>
                                        <div class="tc tcF"><xsl:value-of select="$timePath[position()=4]/symbol/@name"/>&#160;&#160;<xsl:value-of select="$timePath[position()=4]/temperature/@value"/>&#x2103;</div>
                                    </div>
                                </xsl:for-each>
                            </div>
                        </div>
                    </form>
                </div>

                <!--Informasjon om hvor vi har hentet data med lenker til sidene-->
                <footer>
                    Flight data gathered from <a id="link" target="_blank" href="https://avinor.no/">www.avinor.no</a> &#160;&#160;&#160;<a id="link" target="_blank" href="https://avinor.no/"><img src="./Bilde/avinor.png" class="avinor" alt="avinor"/></a>  &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;
                    Weather forecast from <a id="link" target="_blank" href="https://yr.no/">www.yr.no</a>, delivered by the Norwegian Meteorological Institute and NRK &#160;&#160;&#160;<a id="link" target="_blank" href="https://yr.no/"><img src="./Bilde/yr.png" class="avinor" alt="avinor"/></a>
                </footer>
            </body>

            <script language="javascript" src="js.js" defer="true">
            </script>
        </html>

    </xsl:template>

</xsl:stylesheet>