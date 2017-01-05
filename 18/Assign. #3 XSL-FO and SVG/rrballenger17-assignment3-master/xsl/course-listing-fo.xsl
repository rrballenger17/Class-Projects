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
		<xsl:attribute name="text-align">center</xsl:attribute>
		<xsl:attribute name="padding">1em</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="course-title">
		<xsl:attribute name="font-family">Times, serif</xsl:attribute>
		<xsl:attribute name="font-size">18pt</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="course-title-skinny">
		<xsl:attribute name="font-family">Times, serif</xsl:attribute>
		<xsl:attribute name="font-size">18pt</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="small">
		<xsl:attribute name="font-family">Times, serif</xsl:attribute>
		<xsl:attribute name="font-size">9pt</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="normal">
		<xsl:attribute name="font-family">Times, serif</xsl:attribute>
		<xsl:attribute name="font-size">12pt</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="info">
		<xsl:attribute name="font-family">Times, serif</xsl:attribute>
		<xsl:attribute name="font-size">10pt</xsl:attribute>
		<xsl:attribute name="padding-top">1em</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="info-no-padding">
		<xsl:attribute name="font-family">Times, serif</xsl:attribute>
		<xsl:attribute name="font-size">10pt</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="bold">
		<xsl:attribute name="font-family">Times, serif</xsl:attribute>
		<xsl:attribute name="font-size">12pt</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="bold-small">
		<xsl:attribute name="font-family">Times, serif</xsl:attribute>
		<xsl:attribute name="font-size">10pt</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
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
						Courses, Page
						<fo:page-number/>
						<xsl:text> of </xsl:text>
						<fo:page-number-citation ref-id="theEnd"/>
					</fo:block>
				</fo:static-content>

				<fo:flow flow-name="xsl-region-body">
					<fo:block>
						<fo:block xsl:use-attribute-sets="toc-title">Courses</fo:block>
						<fo:block>
							<xsl:apply-templates select="/courses" mode="toc"/>
						</fo:block>
						<xsl:apply-templates select="/courses" mode="main"/>
					</fo:block>
					<fo:block id="theEnd"></fo:block>
				</fo:flow>
			</fo:page-sequence>
		</fo:root>
	</xsl:template>

	<xsl:template match="courses" mode="main">
		
		<!-- get instances of "several classes of the same couse" -->
		<xsl:variable name="moreThanOneClass">
			<xsl:for-each-group select="course" group-by="catalog_info/title/@short_title">
				<xsl:if test= "count(current-group()) ne 1">
					<saved title="{current-grouping-key()}"></saved>
				</xsl:if> 
			</xsl:for-each-group>
		</xsl:variable>
		
		<xsl:for-each select="course">
			<!-- sort by course group, numeric part of short title, and by section -->
			<xsl:sort select="catalog_info/course_group"/>
			<xsl:sort select="xs:integer(replace(catalog_info/title/@short_title, '\D', ''))"/>
			<xsl:sort select="@section"/>
			
			<!-- title -->
			<fo:block id="{generate-id()}" break-before="page" xsl:use-attribute-sets="course-title">
					<fo:inline xsl:use-attribute-sets="bold">Title: </fo:inline>
					<xsl:value-of select="catalog_info/title/text()"/>
			</fo:block>
			
			<!-- short title -->
			<fo:block xsl:use-attribute-sets="course-title-skinny">
					<fo:inline xsl:use-attribute-sets="bold">Short title: </fo:inline>
					<xsl:value-of select="catalog_info/title/@short_title"/>
			</fo:block>
			
			<!-- section if multiple instances of the same course -->
			<xsl:variable name="var" select="catalog_info/title/@short_title"/>
			<xsl:variable name="var2" select="@section"/>
			<xsl:for-each select="$moreThanOneClass/saved">
				<xsl:if test="@title eq $var">
					<fo:block xsl:use-attribute-sets="normal">
						<fo:inline xsl:use-attribute-sets="bold">Section: </fo:inline>
						<xsl:value-of select="$var2"/>
					</fo:block>
				</xsl:if>
			</xsl:for-each>
			
			<!-- instructors -->
			<fo:block xsl:use-attribute-sets="normal">
				<fo:inline xsl:use-attribute-sets="bold">Instructor: </fo:inline>
				<xsl:variable name="count" select="count(staff/person)"/>
				<xsl:for-each select="staff/person">
					<!-- sort by role and then by seniority -->
					<xsl:sort select="number(@role)"/>
					<xsl:sort select="number(@seniority_sort)"/>
					<xsl:value-of select="display_name"/>
					<xsl:if test="$count ne 1 and position() ne $count">
						<xsl:text>, </xsl:text>
					</xsl:if>
				</xsl:for-each>
			</fo:block>
			
			<!-- term -->
			<fo:block xsl:use-attribute-sets="normal">
					<fo:inline xsl:use-attribute-sets="bold">Term: </fo:inline>
					<xsl:value-of select="@term_code"/>
			</fo:block>
				
			<!-- days and times -->
			<fo:block xsl:use-attribute-sets="normal">
					<fo:inline xsl:use-attribute-sets="bold">Days: </fo:inline>
					<xsl:variable name="count" select="count(catalog_info/meeting_schedule/meeting)"/>
					<xsl:for-each select="catalog_info/meeting_schedule/meeting">
						<xsl:value-of select="replace(@days_of_week, ' ', ', ')"/>
						<xsl:text> </xsl:text>
						<xsl:value-of select="@start_time"/> to <xsl:value-of select="@end_time"/>
						<xsl:if test="$count ne 1 and position() ne $count">
							<xsl:text>, </xsl:text>
						</xsl:if>
					</xsl:for-each>
			</fo:block>
			
			<!-- description -->
			<fo:block xsl:use-attribute-sets="info">
					<fo:inline xsl:use-attribute-sets="bold-small">Description: </fo:inline>
					<xsl:value-of select="catalog_info/description"/>
			</fo:block>
				
			<!-- notes -->
			<fo:block xsl:use-attribute-sets="info-no-padding">
					<fo:inline xsl:use-attribute-sets="bold-small">Notes: </fo:inline>
					<xsl:value-of select="catalog_info/notes"/>
			</fo:block>
			
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="courses" mode="toc">
		<!-- get instances of "several classes of the same couse" -->
		<xsl:variable name="moreThanOneClass">
			<xsl:for-each-group select="course" group-by="catalog_info/title/@short_title">
				<xsl:if test= "count(current-group()) ne 1">
					<saved title="{current-grouping-key()}"></saved>
				</xsl:if> 
			</xsl:for-each-group>
		</xsl:variable>
		
		<xsl:for-each select="course">
			<xsl:sort select="catalog_info/course_group"/>
			<xsl:sort select="xs:integer(replace(catalog_info/title/@short_title, '\D', ''))"/>
			<xsl:sort select="@section"/>
		
			<fo:block text-align-last="justify" xsl:use-attribute-sets="small">
				<fo:basic-link>
					<!-- create link -->
					<xsl:attribute name="internal-destination">
						<xsl:value-of select="generate-id()"/>
					</xsl:attribute>
					
					<!-- short title -->
					<xsl:value-of select="catalog_info/title/@short_title"/>
					
					<!-- section if multiple instances of course -->
					<xsl:variable name="shortTitle" select="catalog_info/title/@short_title"/>
					<xsl:variable name="section" select="@section"/>
					<xsl:for-each select="$moreThanOneClass/saved">
						<xsl:if test="@title eq $shortTitle">
							<xsl:text>, </xsl:text>
							<xsl:value-of select="$section"/>
						</xsl:if>
					</xsl:for-each>
					<xsl:text>, </xsl:text>
					
					<!-- full course name -->
					<xsl:value-of select="catalog_info/title/text()"/>
				
					<!-- dots and page number class info -->
					<fo:leader leader-pattern="dots"/>
					<fo:page-number-citation>
						<xsl:attribute name="ref-id">
							<xsl:value-of select="generate-id()"/>
						</xsl:attribute>
					</fo:page-number-citation>
				</fo:basic-link>
			</fo:block>
		</xsl:for-each>
	</xsl:template>

</xsl:stylesheet>

