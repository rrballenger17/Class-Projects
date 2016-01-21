xquery version "3.0" encoding "UTF-8";

declare variable $col_path := request:get-attribute('collection_path');
declare variable $col := collection($col_path);

<result>
    {    

		for $dept in distinct-values($col/courses/course/catalog_info/department)

    		where $dept ne ''

    		order by $dept

			return <department>{$dept}</department>
    }
</result>
