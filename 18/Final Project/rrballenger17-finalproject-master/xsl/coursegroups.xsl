<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:import href="./common.xsl"/>

    <xsl:output method="html" doctype-system="about:legacy-compat"/>

    <xsl:template match="result">
        <h5>Course Groups</h5>
        <form action="otherlist" method="get">
            <input type="submit" value="PDF VERSION"/>
        </form>
        <ul>
            <xsl:for-each select="coursegroup">
                <li>
                    <xsl:element name="a">
                        <xsl:attribute name="href">
                            search?group=<xsl:value-of select="encode-for-uri(text())"/>
                        </xsl:attribute>
                        <xsl:value-of select="text()"/>
                    </xsl:element>
                </li>
            </xsl:for-each>
        </ul>
    </xsl:template>

    <xsl:template match="text()"/>
</xsl:stylesheet>
