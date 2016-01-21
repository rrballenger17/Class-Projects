<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:output method="html" doctype-system="about:legacy-compat"/>

<xsl:template match="/">
    <html>
        <head>
            <title>Department Page</title>
            <style>
            	table {
            		border-collapse: collapse;
            		border: 3px solid black;
            	}

            	table tr td {
            		padding-left: 3px;
            		padding-right: 3px;
            		border: 1px solid black;
            	}

            	table tr:first-child td {
    				font-weight: bold;
				}

            	h1 {
            		color: red;
            		font-variant: small-caps;
            	}

            	a {
            		text-decoration: none;
            	}

            	.courseName {
            		font-weight: bold;
            	}

            </style>
        </head>
        <body>
            <h1>Harvard University <br/>
            Faculty of Arts &amp; Sciences</h1>
            <br/>
            <xsl:apply-templates/>
        </body>
    </html>
</xsl:template>

</xsl:stylesheet>
