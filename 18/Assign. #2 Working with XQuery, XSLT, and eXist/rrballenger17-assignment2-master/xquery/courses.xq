xquery version "3.0" encoding "UTF-8";

declare variable $col_path := request:get-attribute('collection_path');
declare variable $col := collection($col_path);

declare variable $deptCode := request:get-parameter('department','*');

<result>
	{    
		let $deptCourses :=
   			for $courses in $col/courses/course
   			where $courses/catalog_info/department/@code eq $deptCode
   			return $courses

		for $item in subsequence($deptCourses, 1, 1)
		return
   			<department>{$item/catalog_info/department/text()}</department>
    }
	
	
    {    
    	for $course in $col/courses/course
			let $course_number := replace($course/catalog_info/title/@short_title, '\D', '')
			let $course_sort_number := if (matches($course_number, '^\d+')) then
    			xs:integer($course_number)
			else
    			0

    		where $course/catalog_info/department/@code eq $deptCode

			order by $course/catalog_info/course_group/text(),
				$course_sort_number

			return <course short_title="{$course/catalog_info/title/@short_title}" term_code="{$course/@term_code}" course_group="{$course/catalog_info/course_group}" course_type="{$course/catalog_info/course_type}">{$course/catalog_info/title/text()}</course>	
    }

</result>



