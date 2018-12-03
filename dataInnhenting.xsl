<?xml version="1.0" encoding="UTF-8"?>

<!--
Laget av Joakim Selvik (kandidatnr: 118)
Kontrollert av Jan Helge Helgesen (kandidatnr: 120)
-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

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
                <div class="divBox">
                    <input id="changeTable" type="button" onclick="changeTable()" value="Check weather data"/>
                    <input id="minInput" placeholder="Search for airport..">

                    </input>
                    <div id="myList">

                    </div>
                    <input id="reloadAjax" type="button" onclick="run()" value="Reload list with new airports"/>
                </div>


                <div class="divBox2">
                    <form id="table">
                        <div class="planeTable">
                            <div class="border1">
                                <div class="tr1">
                                    <div class="tc tcO">Date</div>
                                    <div class="tc tcO">Time</div>
                                    <div class="tc tcO">Destination</div>
                                    <div class="tc tcO">Flight</div>
                                    <div class="tc tcO">Gate</div>
                                </div>
                            </div>
                            <div class="border2">
                                <div id="velkommen">
                                    <h1>Welcome!</h1>
                                    <p>This website is part of the XML course at the University of South-Eastern Norway.</p>
                                    <p>The website allows the user to check out Avinor's flight data for each norwegian airport and Yr's weather data forecast for 6 hour intervals.</p>
                                </div>
                                <div class="hide">
                                <xsl:for-each select="airport/flights/flight">
                                    <xsl:sort select="schedule_time"/>
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

                <div class="divBox3">
                    <form id="table2">
                        <div class="weatherTable">
                            <div class="border1">
                                <div class="tr3">
                                    <div class="tc tcO">County</div>
                                    <div class="tc tcO">Kl. <xsl:value-of select="substring(weatherdata/forecast/tabular/time[position()=1]/@from, 12, 2)"/> - <xsl:value-of select="substring(weatherdata/forecast/tabular/time[position()=1]/@to, 12, 2)"/></div>
                                    <div class="tc tcO">Kl. <xsl:value-of select="substring(weatherdata/forecast/tabular/time[position()=2]/@from, 12, 2)"/> - <xsl:value-of select="substring(weatherdata/forecast/tabular/time[position()=2]/@to, 12, 2)"/></div>
                                    <div class="tc tcO">Kl. <xsl:value-of select="substring(weatherdata/forecast/tabular/time[position()=3]/@from, 12, 2)"/> - <xsl:value-of select="substring(weatherdata/forecast/tabular/time[position()=3]/@to, 12, 2)"/></div>
                                    <div class="tc tcO">Kl. <xsl:value-of select="substring(weatherdata/forecast/tabular/time[position()=4]/@from, 12, 2)"/> - <xsl:value-of select="substring(weatherdata/forecast/tabular/time[position()=4]/@to, 12, 2)"/></div>
                                </div>
                            </div>
                            <div class="border2">
                                <xsl:for-each select="weatherdata/forecast">
                                    <xsl:sort select="text/location/@name"/>
                                    <div class="tr4">
                                        <div class="tc tcY"><xsl:value-of select="substring-before(text/location/@name, 'fylke')"/></div>
                                        <div class="tc tcF"><xsl:value-of select="tabular/time[position()=1]/symbol/@name"/>&#160;&#160;<xsl:value-of select="tabular/time[position()=1]/temperature/@value"/>&#x2103;</div>
                                        <div class="tc tcF"><xsl:value-of select="tabular/time[position()=2]/symbol/@name"/>&#160;&#160;<xsl:value-of select="tabular/time[position()=2]/temperature/@value"/>&#x2103;</div>
                                        <div class="tc tcF"><xsl:value-of select="tabular/time[position()=3]/symbol/@name"/>&#160;&#160;<xsl:value-of select="tabular/time[position()=3]/temperature/@value"/>&#x2103;</div>
                                        <div class="tc tcF"><xsl:value-of select="tabular/time[position()=4]/symbol/@name"/>&#160;&#160;<xsl:value-of select="tabular/time[position()=4]/temperature/@value"/>&#x2103;</div>
                                    </div>
                                </xsl:for-each>
                            </div>
                        </div>
                    </form>
                </div>




                <footer>

                    Flightdata gathered from <a id="link" target="_blank" href="https://avinor.no/">www.avinor.no</a> &#160;&#160;&#160;<a id="link" target="_blank" href="https://avinor.no/"><img src="./Bilde/avinor.png" class="avinor" alt="avinor"/></a>  &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;
                    Weather forecast from <a id="link" target="_blank" href="https://yr.no/">www.yr.no</a>, delivered by the Norwegian Meteorological Institute and NRK &#160;&#160;&#160;<a id="link" target="_blank" href="https://yr.no/"><img src="./Bilde/yr.png" class="avinor" alt="avinor"/></a>

                </footer>
            </body>

            <script language="javascript" src="js.js" defer="true">
            </script>
        </html>

    </xsl:template>

</xsl:stylesheet>