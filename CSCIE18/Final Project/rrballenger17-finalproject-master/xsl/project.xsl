<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:import href="./common.xsl"/>

    <xsl:output method="html" doctype-system="about:legacy-compat"/>

    <!-- data passed when next or previous page called -->
    <xsl:template match="nextPage">
        Page: <xsl:value-of select="number(@pageNumber) + 1"/>
        <br/>
        <form action="search" method="get">
            <input type="hidden" name="department" value="{@deptCode}"/>
            <input type="hidden" name="group" value="{@groupCode}"/>
            <input type="hidden" name="term" value="{@term}"/>
            <input type="hidden" name="time" value="{@time}"/>
            <input type="hidden" name="professor" value="{@professor}"/>
            <input type="hidden" name="keywords" value="{@keywords}"/>
            <input type="hidden" name="days" value="{@day}"/>
            
            <input type="hidden" name="s_department" value="{@sdepartment}"/>
            <input type="hidden" name="s_course_group" value="{@sgroup}"/>
            <input type="hidden" name="s_term" value="{@sterm}"/>
            <input type="hidden" name="s_type" value="{@stype}"/>
            <input type="hidden" name="s_start_time" value="{@stime}"/>
            <input type="hidden" name="s_days" value="{@sdays}"/>
            
            <input type="hidden" name="pageNumber" value="{number(@pageNumber) + 1}"/>
            
            <input type="submit" value="Next Page"/>
        </form>
        
        <form action="search" method="get">
            <input type="hidden" name="department" value="{@deptCode}"/>
            <input type="hidden" name="group" value="{@groupCode}"/>
            <input type="hidden" name="term" value="{@term}"/>
            <input type="hidden" name="time" value="{@time}"/>
            <input type="hidden" name="professor" value="{@professor}"/>
            <input type="hidden" name="keywords" value="{@keywords}"/>
            <input type="hidden" name="days" value="{@day}"/>
            
            <input type="hidden" name="s_department" value="{@sdepartment}"/>
            <input type="hidden" name="s_course_group" value="{@sgroup}"/>
            <input type="hidden" name="s_term" value="{@sterm}"/>
            <input type="hidden" name="s_type" value="{@stype}"/>
            <input type="hidden" name="s_start_time" value="{@stime}"/>
            <input type="hidden" name="s_days" value="{@sdays}"/>
            
            <input type="hidden" name="pageNumber" value="{
                if(number(@pageNumber) eq 0) then(number(0))
                else(number(@pageNumber) - 1)}"/>
            
            <input type="submit" value="Previous Page"/>
        </form>
    </xsl:template>

    <!-- search and sort data passed to make pdf -->
    <xsl:template match="pdf">
        <form action="courselistpdf.pdf" method="get">
            <input type="hidden" name="department" value="{@deptCode}"/>
            <input type="hidden" name="group" value="{@groupCode}"/>
            <input type="hidden" name="term" value="{@term}"/>
            <input type="hidden" name="time" value="{@time}"/>
            <input type="hidden" name="professor" value="{@professor}"/>
            <input type="hidden" name="keywords" value="{@keywords}"/>
            <input type="hidden" name="days" value="{@day}"/>
            
            <input type="hidden" name="s_department" value="{@sdepartment}"/>
            <input type="hidden" name="s_course_group" value="{@sgroup}"/>
            <input type="hidden" name="s_term" value="{@sterm}"/>
            <input type="hidden" name="s_type" value="{@stype}"/>
            <input type="hidden" name="s_start_time" value="{@stime}"/>
            <input type="hidden" name="s_days" value="{@sdays}"/>
            
            <input type="submit" value="PDF VIEW"/>
        </form>
    </xsl:template>

   
    <xsl:template match="search">
        <h4>Search</h4>
        <form action="search" method="get" id="searchform">
            <xsl:apply-templates/> 
            Phrase: <input type="text" name="keywords" value=""/>
            <br/>
            <input type="submit" value="Submit"/>
            <br/>
        </form>
        <br/>
    </xsl:template>
   
   <!-- department names in select input for search -->
    <xsl:template match="dnames">
        <h6>Departments</h6>
            <select name="department">
                <xsl:for-each select="dname">
                    <option>
                        <xsl:value-of select="text()"/>
                    </option>
                </xsl:for-each>
            </select>
        <br/>
    </xsl:template>
    
    <!-- course groups names in select input for search -->
    <xsl:template match="cgnames">
        <h6>Course Groups</h6>
            <select name="group">
                <xsl:for-each select="cgname">
                    <option>
                        <xsl:value-of select="text()"/>
                    </option>
                </xsl:for-each>
            </select>
        <br/>
    </xsl:template>
    
    <!-- terms in select input for search -->
    <xsl:template match="terms">
        <h6>Terms</h6>
            <select name="term">
                <xsl:for-each select="term">
                    <option>
                        <xsl:value-of select="text()"/>
                    </option>
                </xsl:for-each>
            </select>
        <br/>
    </xsl:template>

    <!-- all course start time in select input for search -->
    <xsl:template match="times">
        <h6>Start Times</h6>
            <select name="time">
                <xsl:for-each select="time">
                    <option>
                        <xsl:value-of select="text()"/>
                    </option>
                </xsl:for-each>
            </select>
        <br/>
    </xsl:template>
    
    <!-- all days in select input for search -->
    <xsl:template match="days">
        <h6>Days</h6>
        <select name="days">
            <xsl:for-each select="day">
                <option>
                    <xsl:value-of select="text()"/>
                </option>
            </xsl:for-each>
        </select>
        <br/>
    </xsl:template>
    
    <!-- all professors in select input for search -->
    <xsl:template match="professors">
        <h6>Professor</h6>
        <select name="professor">
            <xsl:for-each select="professor">           
                <option>
                    <xsl:attribute name="value">
                        <xsl:value-of select="@name" />
                    </xsl:attribute>

                    <xsl:value-of select="text()"/>
                </option>
            </xsl:for-each>
        </select>
        <br/>
    </xsl:template>
    
    <!-- display data about previous search -->
    <xsl:template match="searchResults">
        <br/>
        <h3>Search Criteria:</h3>
            <xsl:for-each select="criterias">
            <xsl:for-each select="criteria">
                <b>
                <xsl:choose>
                    <xsl:when test="position() eq 1">
                        Department:
                    </xsl:when>
                    <xsl:when test="position() eq 2">
                        Course Group: 
                    </xsl:when>
                    <xsl:when test="position() eq 3">
                        Term: 
                    </xsl:when>
                    <xsl:when test="position() eq 4">
                        Time:
                    </xsl:when>
                    <xsl:when test="position() eq 5">
                        Days: 
                    </xsl:when>
                    <xsl:when test="position() eq 6">
                        Professor:
                    </xsl:when>
                    <xsl:when test="position() eq 7">
                        Phrase: 
                    </xsl:when>
                    <xsl:otherwise>
                        Oops:
                    </xsl:otherwise>
                </xsl:choose>
                </b>
                
                <xsl:if test="position() eq 7 and string-length(text()) eq 0">
                    -
                </xsl:if>

                <xsl:value-of select="text()"/>
            </xsl:for-each>
            </xsl:for-each>
    </xsl:template>
    
    <!-- data to send to next page if sort is called -->
    <xsl:template match="sortInfo">
        
        <form action="search" method="get">
            
        <xsl:for-each select="criterias">
        <xsl:for-each select="criteria">
            <xsl:choose>
                <xsl:when test="position() eq 1">
                    <input type="hidden" name="department">
                        <xsl:attribute name="value">
                            <xsl:value-of select="text()"/>
                        </xsl:attribute>
                    </input>
                </xsl:when>
                <xsl:when test="position() eq 2">
                    <input type="hidden"  name="group">
                        <xsl:attribute name="value">   
                            <xsl:value-of select="text()"/>
                        </xsl:attribute>
                    </input>
                </xsl:when>
                <xsl:when test="position() eq 3">
                    <input type="hidden"  name="term">
                        <xsl:attribute name="value">   
                            <xsl:value-of select="text()"/>
                        </xsl:attribute>
                     </input>
                </xsl:when>
                <xsl:when test="position() eq 4">
                    <input type="hidden"  name="time">
                        <xsl:attribute name="value">   
                            <xsl:value-of select="text()"/>
                        </xsl:attribute>
                    </input>
                </xsl:when>
                <xsl:when test="position() eq 5">
                    <input type="hidden"  name="days">
                        <xsl:attribute name="value">   
                            <xsl:value-of select="text()"/>
                        </xsl:attribute>
                    </input>
                </xsl:when>
                <xsl:when test="position() eq 6">
                    <input type="hidden" name="professor">
                        <xsl:attribute name="value">   
                            <xsl:value-of select="text()"/>
                        </xsl:attribute>
                    </input>
                </xsl:when>
                <xsl:when test="position() eq 7">
                    <input type="hidden" name="keywords">
                        <xsl:attribute name="value">   
                            <xsl:value-of select="text()"/>
                        </xsl:attribute>
                    </input>
                </xsl:when>
                <xsl:otherwise>
                        Oops:
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
        </xsl:for-each>
            
            <br/>
            <h3>Sort By:</h3>
            Term: <input type="checkbox" name="s_term"/>
            Type: <input type="checkbox" name="s_type"/>
            Start Time: <input type="checkbox" name="s_start_time" />
            Days: <input type="checkbox" name="s_days" />
            <input type="submit" value="Submit"/>

        </form>
    </xsl:template>
    
    <xsl:template match="top">
       <xsl:apply-templates/>
    </xsl:template>    

    <xsl:template match="result">
        <br/>
        <xsl:apply-templates select="top"/>
        <br/>
        
        <!-- display info on courses matching search -->
        <table>
            <tr>
                <td class="disappear">Course Group</td>
                <td>Course</td>
                <td class="disappear">Term</td>
                <td>Title</td>
                <td class="disappear">Type</td>
                <td class="disappear">Days</td>
                <td>Professor</td>
            </tr>
            <xsl:for-each select="course">
                <tr>
                    <td class="disappear"><xsl:value-of select="@course_group"/>
                    </td>
                    <td>
                        <a>
                            <xsl:attribute name="href">
                                <xsl:value-of select="concat('course?shortTitle=', encode-for-uri(@short_title))"/>  
                            </xsl:attribute>    
                           <xsl:value-of select="@short_title"/>
                        </a>
                    </td>
                    <td class="disappear"><xsl:value-of select="@term_code"/>
                    </td>
                    <td class="courseName">
                        <a>
                            <xsl:attribute name="href">
                                <xsl:value-of select="concat('course?shortTitle=', encode-for-uri(@short_title))"/>  
                            </xsl:attribute>    
                            <xsl:value-of select="text()"/>
                        </a>
                    </td>
                    <td class="disappear"><xsl:value-of select="@course_type"/>
                    </td>
                    <td class="disappear"><xsl:value-of select="replace(@days, ';$', '')"/>
                    </td>
                    <td><xsl:value-of select="replace(@professor, ',$', '')"/>
                    </td>
                 
                </tr>
            </xsl:for-each>
        </table>
        <xsl:apply-templates select="nextPage"/>
    
    </xsl:template>

    <xsl:template match="text()"/>
</xsl:stylesheet>

