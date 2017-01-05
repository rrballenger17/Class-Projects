xquery version "3.0" encoding "UTF-8";

declare variable $col_path := request:get-attribute('collection_path');
declare variable $col := collection($col_path);

<result>
    {    

		for $cg in distinct-values($col/courses/course/catalog_info/course_group)

    		where $cg ne ''

    		order by $cg

			return <coursegroup>{$cg}</coursegroup>
    }
</result>
