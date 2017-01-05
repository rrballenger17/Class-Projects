xquery version "3.0";
declare namespace svg="http://www.w3.org/2000/svg";
declare namespace xlink="http://www.w3.org/1999/xlink";
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:omit-xml-declaration "no";
declare option output:method "xml";
declare option output:indent "yes";
declare option output:doctype-public "-//W3C//DTD SVG 1.1//EN";
declare option output:doctype-system "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd";
declare variable $data as document-node() := doc('../data/enrollment.xml');

let $sorted-courses := 
    for $course in $data/enrollment/course
    order by number($course/@total_enrollment) descending
    return <course title="{$course/@short_title}" enroll="{$course/@total_enrollment}"></course>

return
    <svg xmlns="http://www.w3.org/2000/svg" 
        xmlns:xlink="http://www.w3.org/1999/xlink"
        version="1.1" height="8000" width="10000">
     
     {
        for $course at $position in subsequence($sorted-courses, 1, 25)
        return  <rect x="150" y="{20*$position}" height="15" width="{number($course/@enroll/string())}"
        style="fill:green; stroke: black;"/>
     }
     
     {
        for $course at $position in subsequence($sorted-courses, 1, 25)
        return  <text x="100" y="{12 + 20*$position}" style="text-anchor:middle;fill:red;font-size:10pt;font-weight:bold;">{$course/@title/string()}</text>
     }
     
     {
        for $course at $position in subsequence($sorted-courses, 1, 25)
        return  <text x="{135 + number($course/@enroll/string())}" y="{12 + 20*$position}" style="text-anchor:middle;fill:white;font-size:10pt;">{$course/@enroll/string()}</text>
     }
     
    </svg>

    