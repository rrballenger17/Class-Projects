xquery version "3.0" encoding "UTF-8";

declare variable $col_path := request:get-attribute('collection_path');
declare variable $col := collection($col_path);

declare variable $department := request:get-parameter('department','*');


let $source-document as document-node() := (

    <datapoints>
    {
    if($department ne '*') then (
        <datapoint>Departments</datapoint>
     )else(
        <datapoint>Course Groups</datapoint>
	 )
    }
    
    {   
     if($department ne '*') then (
        
        for $dept in distinct-values($col/courses/course/catalog_info/department)
        
        order by $dept
        
        return <datapoint>{$dept}</datapoint>
     )else(
    
    	for $cg in distinct-values($col/courses/course/catalog_info/course_group)
        
        order by $cg
        
        return <datapoint>{$cg}</datapoint>
	  )
    }
    </datapoints>
)

let $xslt-document as document-node() := doc('../xsl/other-listing-fo.xsl')
let $xslfo-document as document-node() := transform:transform($source-document,$xslt-document,())

let $media-type as xs:string := "application/pdf"
return
    response:stream-binary(
        xslfo:render($xslfo-document, $media-type, ()),
        $media-type,
        "listing.pdf"
    )




