xquery version "3.0";

(: exist variables :)
declare variable $exist:path external;
declare variable $exist:resource external;
declare variable $exist:controller external;
declare variable $exist:prefix external;
declare variable $exist:root external;

(: Other variables :)
declare variable $home-page-url := "index.html";
declare variable $collection_path := concat($exist:root, '/', $exist:controller, '/data/courses');

(: If trailing slash is missing, put it there and do a browser-redirect :)
if ($exist:path eq "") then
    <dispatch
        xmlns="http://exist.sourceforge.net/NS/exist">
        <redirect
            url="{request:get-uri()}/"/>
    </dispatch>
    
    (: If there is no resource specified, browser-redirect to home page.
 : change this from "test" :)
else
    if ($exist:resource eq "") then
        <dispatch
            xmlns="http://exist.sourceforge.net/NS/exist">
            <redirect
                url="{$home-page-url}"/>
        </dispatch>
        
        (: test page :)
    else
        if (matches($exist:resource, '\.pdf$')) then
            <dispatch
                xmlns="http://exist.sourceforge.net/NS/exist">
                <forward
                    url="{$exist:controller}/xquery/pdf.xq">
                    <set-attribute
                        name="exist.resource"
                        value="{$exist:resource}"/>
                </forward>
            </dispatch>
        
        else
            if ($exist:resource eq 'top25courses') then
                <dispatch
                    xmlns="http://exist.sourceforge.net/NS/exist">
                    <forward
                        url="{$exist:controller}/xquery/top25courses.xq">
                    </forward>
                </dispatch>
                 
                (: everything is passed through :)
            else
                <dispatch
                    xmlns="http://exist.sourceforge.net/NS/exist">
                    <cache-control
                        cache="yes"/>
                </dispatch>
