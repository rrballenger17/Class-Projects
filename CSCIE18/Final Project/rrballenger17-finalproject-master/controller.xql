xquery version "3.0";

(: exist variables :)
declare variable $exist:path external;
declare variable $exist:resource external;
declare variable $exist:controller external;
declare variable $exist:prefix external;
declare variable $exist:root external;

(: Other variables :)
declare variable $home-page-url := "index";
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
                url="departments"/>
        </dispatch>
        
        (: test page :)
else
        if (matches($exist:resource, '\.pdf$')) then
            <dispatch
                xmlns="http://exist.sourceforge.net/NS/exist">
                <forward
                    url="{$exist:controller}/xquery/courselistpdf.xq">

                <set-attribute
                    name="collection_path"
                    value="{$collection_path}"/>
                <set-attribute
                    name="exist.root"
                    value="{$exist:root}"/>
                <set-attribute
                    name="exist.path"
                    value="{$exist:path}"/>
                <set-attribute
                    name="exist.resource"
                    value="{$exist:resource}"/>
                <set-attribute
                    name="exist.controller"
                    value="{$exist:controller}"/>
                <set-attribute
                    name="exist.prefix"
                    value="{$exist:prefix}"/>

                </forward>
            </dispatch>
else
        if (matches($exist:resource, 'otherlist')) then
            <dispatch
                xmlns="http://exist.sourceforge.net/NS/exist">
                <forward
                    url="{$exist:controller}/xquery/other-listing-fo.xq">

                <set-attribute
                    name="collection_path"
                    value="{$collection_path}"/>
                <set-attribute
                    name="exist.root"
                    value="{$exist:root}"/>
                <set-attribute
                    name="exist.path"
                    value="{$exist:path}"/>
                <set-attribute
                    name="exist.resource"
                    value="{$exist:resource}"/>
                <set-attribute
                    name="exist.controller"
                    value="{$exist:controller}"/>
                <set-attribute
                    name="exist.prefix"
                    value="{$exist:prefix}"/>

                </forward>
            </dispatch>

else
    if ($exist:resource eq 'test') then
        <dispatch
            xmlns="http://exist.sourceforge.net/NS/exist">
            <forward
                url="{$exist:controller}/xquery/test.xq">
                <set-attribute
                    name="collection_path"
                    value="{$collection_path}"/>
                <set-attribute
                    name="exist.root"
                    value="{$exist:root}"/>
                <set-attribute
                    name="exist.path"
                    value="{$exist:path}"/>
                <set-attribute
                    name="exist.resource"
                    value="{$exist:resource}"/>
                <set-attribute
                    name="exist.controller"
                    value="{$exist:controller}"/>
                <set-attribute
                    name="exist.prefix"
                    value="{$exist:prefix}"/>
            </forward>
            <view>
                <forward
                    servlet="XSLTServlet">
                    <set-attribute
                        name="xslt.stylesheet"
                        value="{concat($exist:root, $exist:controller, "/xsl/test.xsl")}"/>
                </forward>
            </view>
        </dispatch>
else
    if ($exist:resource eq 'departments') then
        <dispatch
            xmlns="http://exist.sourceforge.net/NS/exist">
            <forward
                url="{$exist:controller}/xquery/departments.xq">
                <set-attribute
                    name="collection_path"
                    value="{$collection_path}"/>
                <set-attribute
                    name="exist.root"
                    value="{$exist:root}"/>
                <set-attribute
                    name="exist.path"
                    value="{$exist:path}"/>
                <set-attribute
                    name="exist.resource"
                    value="{$exist:resource}"/>
                <set-attribute
                    name="exist.controller"
                    value="{$exist:controller}"/>
                <set-attribute
                    name="exist.prefix"
                    value="{$exist:prefix}"/>
            </forward>
            <view>
                <forward
                    servlet="XSLTServlet">
                    <set-attribute
                        name="xslt.stylesheet"
                        value="{concat($exist:root, $exist:controller, "/xsl/departments.xsl")}"/>
                </forward>
            </view>
        </dispatch>

else
    if ($exist:resource eq 'coursegroups') then
        <dispatch
            xmlns="http://exist.sourceforge.net/NS/exist">
            <forward
                url="{$exist:controller}/xquery/coursegroups.xq">
                <set-attribute
                    name="collection_path"
                    value="{$collection_path}"/>
                <set-attribute
                    name="exist.root"
                    value="{$exist:root}"/>
                <set-attribute
                    name="exist.path"
                    value="{$exist:path}"/>
                <set-attribute
                    name="exist.resource"
                    value="{$exist:resource}"/>
                <set-attribute
                    name="exist.controller"
                    value="{$exist:controller}"/>
                <set-attribute
                    name="exist.prefix"
                    value="{$exist:prefix}"/>
            </forward>
            <view>
                <forward
                    servlet="XSLTServlet">
                    <set-attribute
                        name="xslt.stylesheet"
                        value="{concat($exist:root, $exist:controller, "/xsl/coursegroups.xsl")}"/>
                </forward>
            </view>
        </dispatch>

else
    if ($exist:resource eq 'search') then
        <dispatch
            xmlns="http://exist.sourceforge.net/NS/exist">
            <forward
                url="{$exist:controller}/xquery/process.xq">
                <set-attribute
                    name="collection_path"
                    value="{$collection_path}"/>
                <set-attribute
                    name="exist.root"
                    value="{$exist:root}"/>
                <set-attribute
                    name="exist.path"
                    value="{$exist:path}"/>
                <set-attribute
                    name="exist.resource"
                    value="{$exist:resource}"/>
                <set-attribute
                    name="exist.controller"
                    value="{$exist:controller}"/>
                <set-attribute
                    name="exist.prefix"
                    value="{$exist:prefix}"/>
            </forward>
            <view>
                <forward
                    servlet="XSLTServlet">
                    <set-attribute
                        name="xslt.stylesheet"
                        value="{concat($exist:root, $exist:controller, "/xsl/project.xsl")}"/>
                </forward>
            </view>
        </dispatch>


else
    if ($exist:resource eq 'course') then
        <dispatch
            xmlns="http://exist.sourceforge.net/NS/exist">
            <forward
                url="{$exist:controller}/xquery/course.xq">
                <set-attribute
                    name="collection_path"
                    value="{$collection_path}"/>
                <set-attribute
                    name="exist.root"
                    value="{$exist:root}"/>
                <set-attribute
                    name="exist.path"
                    value="{$exist:path}"/>
                <set-attribute
                    name="exist.resource"
                    value="{$exist:resource}"/>
                <set-attribute
                    name="exist.controller"
                    value="{$exist:controller}"/>
                <set-attribute
                    name="exist.prefix"
                    value="{$exist:prefix}"/>
            </forward>
            <view>
                <forward
                    servlet="XSLTServlet">
                    <set-attribute
                        name="xslt.stylesheet"
                        value="{concat($exist:root, $exist:controller, "/xsl/course.xsl")}"/>
                </forward>
            </view>
        </dispatch>

           
(: everything is passed through :)
else
    <dispatch
        xmlns="http://exist.sourceforge.net/NS/exist">
        <cache-control
            cache="yes"/>
    </dispatch>
