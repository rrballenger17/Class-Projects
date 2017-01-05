xquery version "1.0" encoding "UTF-8";

import module namespace xslfo="http://exist-db.org/xquery/xslfo";

let $resource := replace(request:get-attribute('exist.resource'),'\.pdf','')

let $source-document as document-node() := doc(concat('../data/', $resource ,'.xml'))
let $xslt-document as document-node() := doc('../xsl/course-listing-fo.xsl')
let $xslfo-document as document-node() := transform:transform($source-document,$xslt-document,())

let $media-type as xs:string := "application/pdf"
return
    response:stream-binary(
        xslfo:render($xslfo-document, $media-type, ()),
        $media-type,
        "courses.pdf"
    )