<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:fo="http://www.w3.org/1999/XSL/Format" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0">
<!-- XSLT that should produce XSL-FO content from Course data for rendering to PDF-->
<!-- submitted -->

	<xsl:attribute-set name="toc-title">
		<xsl:attribute name="font-family">Times, serif</xsl:attribute>
		<xsl:attribute name="font-size">18pt</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="normal">
		<xsl:attribute name="font-family">Times, serif</xsl:attribute>
		<xsl:attribute name="font-size">12pt</xsl:attribute>
	</xsl:attribute-set>
	

	<xsl:template match="/">
		<fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format">
			<fo:layout-master-set>
				<fo:simple-page-master master-name="simple" page-height="11in" page-width="8.5in" margin-top="1.0in" margin-bottom="1.0in" margin-left="1.25in" margin-right="1.25in">
					<fo:region-body margin-top="0.25in"/>
					<fo:region-before extent="0.5in"/>
				</fo:simple-page-master>
			</fo:layout-master-set>

			<fo:page-sequence master-reference="simple">
				<fo:static-content flow-name="xsl-region-before">
					<fo:block font-size="8pt" text-align="end">
						Page
						<fo:page-number/>
						<xsl:text> of </xsl:text>
						<fo:page-number-citation ref-id="theEnd"/>
					</fo:block>
				</fo:static-content>

				<fo:flow flow-name="xsl-region-body">
					<fo:block>
						<xsl:apply-templates select="/datapoints" mode="main"/>
					</fo:block>
					<fo:block id="theEnd"></fo:block>
				</fo:flow>
			</fo:page-sequence>
		</fo:root>
	</xsl:template>

	<xsl:template match="datapoints" mode="main">
		
		<xsl:for-each select="datapoint">
			<fo:block>
				<xsl:choose>
					<xsl:when test="number(position()) eq 1">
						<fo:inline xsl:use-attribute-sets="toc-title">
							<xsl:value-of select="text()"/>
							<br/>
						</fo:inline>
					</xsl:when>
					<xsl:otherwise>
						<fo:inline xsl:use-attribute-sets="normal">
							<xsl:value-of select="text()"/>
						</fo:inline>
					</xsl:otherwise>
					
				</xsl:choose>
				
				
			</fo:block>
			
			
		</xsl:for-each>
	</xsl:template>
	
	
	

</xsl:stylesheet>

