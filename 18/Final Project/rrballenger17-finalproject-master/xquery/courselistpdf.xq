xquery version "3.0" encoding "UTF-8";

declare variable $col_path := request:get-attribute('collection_path');
declare variable $col := collection($col_path);

declare variable $deptCode := request:get-parameter('department','*');
declare variable $groupCode := request:get-parameter('group','*');
declare variable $term := request:get-parameter('term','*');
declare variable $time := request:get-parameter('time','*');
declare variable $professor := request:get-parameter('professor','*');
declare variable $keywords := request:get-parameter('keywords','*');
declare variable $day := request:get-parameter('days','*');

declare variable $sdepartment := request:get-parameter('s_department','*');
declare variable $sgroup := request:get-parameter('s_course_group','*');
declare variable $sterm := request:get-parameter('s_term','*');
declare variable $stype := request:get-parameter('s_type','*');
declare variable $stime := request:get-parameter('s_start_time','*');
declare variable $sdays := request:get-parameter('s_days','*');

declare variable $shortTitle := request:get-parameter('shortTitle','*');


let $source-document as document-node() := (

    <courses>
    {   
     if($shortTitle ne '*') then (
        for $course in $col/courses/course
        where $course/catalog_info/title/@short_title eq $shortTitle
        return $course
     )else(
    
    	for $course in $col/courses/course
    	 
			let $course_number := replace($course/catalog_info/title/@short_title, '\D', '')
			let $course_sort_number := if (matches($course_number, '^\d+')) then
    			xs:integer($course_number)
			else
    			0
    			
    		let $timeCheck := 
    		  for $classTime in $course/catalog_info/meeting_schedule/meeting/@start_time
    		  where $classTime eq $time
    		  return $classTime
    		
    		let $dayCheck := 
    		  for $classDay in $course/catalog_info/meeting_schedule/meeting/@days_of_week
    		  where contains($classDay, $day)
    		  return $classDay
    		  
    	
    		let $professorCheck := 
    		  for $classTime in $course/staff/person/display_name
    		  where $classTime eq $professor
    		  return $classTime

            let $firstTime := 
    		  (for $classTime in $course/catalog_info/meeting_schedule/meeting/@start_time
    		  order by $classTime
    		  return $classTime)[1]
    		  
    		let $firstDay := 
    		  (for $classDay in $course/catalog_info/meeting_schedule/meeting/@days_of_week
    		  return replace(replace($classDay, 'Thurs', 'Wedt'), 'Fri', 'Wedu'))[1]


    		where (if($deptCode ne '*' and string-length($deptCode) > 0 and $deptCode ne 'All') then (
                $course/catalog_info/department eq $deptCode
            )
        	else(true()))
        	and (if($groupCode ne '*' and string-length($groupCode) > 0 and $groupCode ne 'All') then (
                $course/catalog_info/course_group eq $groupCode
            )else(true()))
            and (if($term ne '*' and string-length($term) > 0 and $term ne 'All') then (
                $course/@term_code eq $term
            )else(true()))
            and (if($time ne '*' and string-length($time) > 0 and $time ne 'All' ) then (
                not(empty($timeCheck))
            )else(true()))
            and (if($professor ne '*' and string-length($professor) > 0 and $professor ne 'All') then (
                not(empty($professorCheck))
            )else(true()))
            and (if($keywords ne '*' and string-length($keywords) > 0) then (
                contains(lower-case($course/catalog_info/description), lower-case($keywords)) or
                contains(lower-case($course/catalog_info/title), lower-case($keywords))
            )else(true())) 
            and (if($day ne '*' and string-length($day) > 0 and $day ne 'All' ) then (
                not(empty($dayCheck))
            )else(true()))

			order by 
			if($sterm ne '*') then 
			     $course/@term_code
			else(1),
			
			if($stype ne '*') then (
			     $course/catalog_info/course_type/text()
			     (: $course/catalog_info/department/text() :)
			)else(1),
            if($sdays ne '*') then (
			     $firstDay
			)else(1),
		    if($stime ne '*') then (
			     $firstTime
			)else(1),
			$course/catalog_info/department/text(),
		    $course/catalog_info/course_group/text(),
		    $course_sort_number
			
			return $course
	  )
    }

    </courses>
)

let $xslt-document as document-node() := doc('../xsl/course-listing-fo.xsl')
let $xslfo-document as document-node() := transform:transform($source-document,$xslt-document,())

let $media-type as xs:string := "application/pdf"
return
    response:stream-binary(
        xslfo:render($xslfo-document, $media-type, ()),
        $media-type,
        "courses.pdf"
    )




