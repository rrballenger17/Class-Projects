xquery version "3.0" encoding "UTF-8";

declare variable $col_path := request:get-attribute('collection_path');
declare variable $col := collection($col_path);

<result>
    {    
    	let $depts := $col/courses/course/catalog_info/department

		for $code in distinct-values($depts/@code),
    		$name in distinct-values($depts[@code = $code])

    		where $name ne ''

    		order by $name

			return <department code="{encode-for-uri($code)}">{$name}</department>
    }
</result>
