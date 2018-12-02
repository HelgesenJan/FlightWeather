<?xml version="1.0" encoding="UTF-8"?>

<!--
Laget av Joakim Selvik
Kontrollert av Jan Helge Helgesen
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
                    <input id="reloadAjax" type="button" onclick="run()" value="Reload airport information"/>
                </div>

                <table id="vaertable">

                </table>



                <div class="divBox2">
                    <form id="table">
                        <div class="planeTable">
                            <div class="border1">
                                <div class="tr1">
                                    <div class="tc tcO">Date</div>
                                    <div class="tc tcO">Time</div>
                                    <div class="tc tcO">Arrival</div>
                                    <div class="tc tcO">Flight</div>
                                    <div class="tc tcO">Gate</div>
                                </div>
                            </div>
                            <div class="border2">
                                <div id="velkommen">
                                    <h1>Welcome!</h1>
                                    <p>Select an airport for information <br></br>
                                        about when and where <br></br>
                                        airplanes travel from that airport</p>
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
                    <form id="table">
                        <div class="planeTable">
                            <div class="border1">
                                <div class="tr1">
                                    <div class="tc tcO">Date</div>
                                    <div class="tc tcO">Time</div>
                                    <div class="tc tcO">Arrival</div>
                                    <div class="tc tcO">Flight</div>
                                    <div class="tc tcO">Gate</div>
                                    <div class="tc tcO">LOL</div>
                                </div>
                            </div>
                            <div class="border2">
                                <div id="velkommen">
                                    <h1>Welcome!</h1>
                                    <p>Select an airport for information <br></br>
                                        about when and where <br></br>
                                        airplanes travel from that airport</p>
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

                <footer>
                    <img src="./Bilde/avinor.jpg" class="avinor" alt="avinor"/>
                    Flightdata gathered from <a id="link" target="_blank" href="https://avinor.no/">www.avinor.no</a>.
                    <img src="./Bilde/avinor.jpg" class="avinor" alt="avinor"/>
                </footer>
            </body>

            <script language="javascript" src="js.js" defer="true">
            </script>
        </html>

    </xsl:template>

</xsl:stylesheet>