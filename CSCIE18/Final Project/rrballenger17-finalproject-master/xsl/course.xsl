<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:import href="./common.xsl"/>

    <xsl:output method="html" doctype-system="about:legacy-compat"/>

    <xsl:template match="pdf">
        <form action="courselistpdf.pdf" method="get">
            <input type="hidden" name="shortTitle" value="{@shortTitle}"/>
            <input type="submit" value="PDF VIEW"/>
        </form>
        <br/>
    </xsl:template>
   
    <xsl:template match="result">
            <xsl:apply-templates/>
            <table>
                <tr>
                    <td class="disappear">Title
                    </td>
                    <td>Short Title
                    </td>
                    <td>Professor(s)
                    </td>
                    <td>Term
                    </td>
                    <td>Day and Time
                    </td>
                    <td class="disappear">Description
                    </td>
                    <td class="disappear">Notes
                    </td>
                </tr>
             <xsl:for-each select="course">
                <tr>
                    <td class="disappear"><xsl:value-of select="@title"/>
                    </td>
                    <td><xsl:value-of select="@shortTitle"/>
                    </td>
                    <td><xsl:value-of select="@professor"/>
                    </td>
                    <td><xsl:value-of select="@term"/>
                    </td>
                    <td><xsl:value-of select="replace(@days, ';$', '')"/>
                    </td>
                    <td class="disappear"><xsl:value-of select="@description"/>
                    </td>
                    <td class="disappear"><xsl:value-of select="@notes"/>
                    </td>
                </tr>
                 
                 <tr class="noShow appear">
                     <td colspan="4">
                         <br/>
                         <b>Description</b>
                         <br/>
                         <xsl:value-of select="@description"/>
                     </td>
                 </tr>
             </xsl:for-each>
            
            </table>
 
            
    </xsl:template>

    <xsl:template match="text()"/>
</xsl:stylesheet>

