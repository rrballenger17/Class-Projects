<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:import href="./common.xsl"/>

    <xsl:output method="html" doctype-system="about:legacy-compat"/>

    <xsl:template match="department">
        <a href="departments"> Home </a>
        <h3>
            <xsl:value-of select="text()"/>
        </h3>
    </xsl:template>

    <xsl:template match="result">
        <br/>
        <xsl:apply-templates/>
        <table>
            <tr>
                <td>Course Group</td>
                <td>Course</td>
                <td>Term</td>
                <td>Title</td>
                <td>Type</td>
            </tr>
            <xsl:for-each select="course">
                <tr>
                    <td><xsl:value-of select="@course_group"/>
                    </td>
                    <td><xsl:value-of select="@short_title"/>
                    </td>
                    <td><xsl:value-of select="@term_code"/>
                    </td>
                    <td class="courseName"><xsl:value-of select="text()"/>
                    </td>
                    <td><xsl:value-of select="@course_type"/>
                    </td>
                </tr>
            </xsl:for-each>
        </table>
    </xsl:template>

    <xsl:template match="text()"/>
</xsl:stylesheet>

