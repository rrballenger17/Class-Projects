<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:import href="./common.xsl"/>

    <xsl:output method="html" doctype-system="about:legacy-compat"/>

    <xsl:template match="result">
        <h5> Departments</h5>
        <ul>
            <xsl:for-each select="department">
                <li>
                    <xsl:element name="a">
                        <xsl:attribute name="href">
                            courses?department=<xsl:value-of select="@code"/>
                        </xsl:attribute>
                        <xsl:value-of select="text()"/>
                    </xsl:element>
                </li>
            </xsl:for-each>
        </ul>
    </xsl:template>

    <xsl:template match="text()"/>
</xsl:stylesheet>
