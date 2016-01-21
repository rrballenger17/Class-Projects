<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:output method="html" doctype-system="about:legacy-compat"/>

<xsl:template match="/">
    <html>
        <head>
            <title>Department Page</title>
        	<meta charset="utf-8"/>
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
            		float: left;
            		padding-bottom: 20px;
            	}

            	a {
            		text-decoration: none;
            	}

            	.courseName {
            		font-weight: bold;
            	}
            	
            	h3{
            		text-decoration: underline;
            	}

                h4, h6, h3{
                    display: inline;
                }

				.navigation{
					background-color:red;
					float:left;
					font-weight: bold;
					font-size: 2em;
					width: 33%;
					border-top: 3px solid black;
					border-bottom: 3px solid black;
				}
				
				.navigationLast{
					width: 34%;
				}
				
				.navigation a{
					color: black;
					text-decoration: none;
				}
				
				.clear{
					clear: left;
				}
				
				#searchform{
					border: 3px solid black;
					background-color: white;
					padding: 15px;
				}
				
				#belowNav{
					background-color: #e6e6e6;
					padding: 10px;
					padding-bottom: 40px;
				}
				
				#emblem{
					
					float: left;
					height: 100px;
				}
				
				#footer{
					background-color: red;
					border: 3px solid black;
					padding: 10px;
					padding-top: 20px;
					font-family: verdana;
				
				}
				
				.noShow{
					display: none;
				}
				
            </style>
        	
        	<link rel="stylesheet" media="only screen and (max-width: 850px)" type="text/css" href="css/mobile.css"/>
        	
        </head>
        <body>
        	
        	<img src="images/emblem.png" alt="emblem" id="emblem" class="disappear"/>
            <h1 class="disappear">Harvard University <br/>
            Faculty of Arts &amp; Sciences</h1>
        	<br class="disappear"/>
        	<div class="disappear clear"/>
        	<div class="floatNav navigation"><a href="departments">Departments</a></div>
        	<div class="floatNav navigation"><a href="coursegroups">Course Groups</a></div>
        	<div class="floatNav navigationLast navigation"><a href="search?noResults=on">Search</a></div>
        	<div class="clear"/>

			<div id="belowNav">
            <xsl:apply-templates/>
			</div>
        	
        	<div id="footer" class="disappear">
        		Copyright 2015.<br/>
        		All Rights Reserved by Harvard University FAS.
        		<br/>
        		<br/>
        		Contact:<br/>
        		Office of the Registrar<br/>
        		Faculty of Arts and Sciences<br/>
        		Harvard University<br/>
        		Richard A. and Susan F. Smith Campus Center Office<br/>
        		1350 Massachusetts Avenue, Suite 450<br/>
        		Cambridge, Massachusetts 02138<br/>
        	</div>
        </body>
    </html>
</xsl:template>

</xsl:stylesheet>
