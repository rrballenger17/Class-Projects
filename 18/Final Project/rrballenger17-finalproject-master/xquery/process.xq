xquery version "3.0" encoding "UTF-8";

declare variable $col_path := request:get-attribute('collection_path');
declare variable $col := collection($col_path);

declare variable $noResults := request:get-parameter('noResults', '*');
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

declare variable $pageNumber := request:get-parameter('pageNumber','0');

(: function to produce information for the current search :)
declare function local:searchCriterias()
{
    let $sequence := ('a')
    for $s in $sequence
    return <criterias>
            <criteria>{$deptCode}</criteria>
            <criteria>{$groupCode}</criteria>
            <criteria>{$term}</criteria>
            <criteria>{$time}</criteria>
            <criteria>{$day}</criteria>
            <criteria>{$professor}</criteria>
            <criteria>{$keywords}</criteria>
        </criterias>
};

<result>
    <top>
    
    <!--data passed to make the pdf file for the current search -->
    <pdf
        deptCode="{$deptCode}"
        groupCode="{$groupCode}"
        term="{$term}"
        time="{$time}"
        professor="{$professor}"
        keywords="{$keywords}"
        day="{$day}"

        sdepartment="{$sdepartment}"
        sgroup="{$sgroup}"
        sterm="{$sterm}"
        stype="{$stype}"
        stime="{$stime}"
        sdays="{$sdays}"
     />
     
    <search>
    
    <!-- get all department names for a user search -->
    <dnames>
    <dname>All</dname>
    {    
        let $depts := $col/courses/course/catalog_info/department

        for $name in distinct-values($depts)
            where $name ne ''
            order by $name
            return <dname>{$name}</dname>
    }
    </dnames>
    
    <!-- get all course group names for a user search -->
    <cgnames>
    <cgname>All</cgname>
    {    
        let $groups := $col/courses/course/catalog_info/course_group

        for $name in distinct-values($groups)
            where $name ne ''
            order by $name
            return <cgname>{$name}</cgname>
    }
    </cgnames>
    
    <!-- get all term names for a user search -->
    <terms>
    <term>All</term>
    {    
        let $terms := $col/courses/course/@term_code

        for $name in distinct-values($terms)
            where $name ne ''
            order by $name
            return <term>{$name}</term>
    }
    </terms>

    <!-- get all class start times for a user search -->
    <times>
    <time>All</time>
    {    
        let $times := $col/courses/course/catalog_info/meeting_schedule/meeting/@start_time

        for $time in distinct-values($times)
            order by $time
            return <time>{$time}</time>
    }
    </times>
    
    <!-- get all days for a user search -->
    <days>
        <day>All</day>
        <day>Monday</day>
        <day>Tuesday</day>
        <day>Wednesday</day>
        <day>Thursday</day>
        <day>Friday</day>
        <day>Saturday</day>
        <day>Sunday</day>
    </days>
    
    <!-- get all professor names a user search. Convert to last, first format -->
    <professors>
    <professor name="All">All</professor>
    {    
        let $profs := $col/courses/course/staff/person/display_name

        for $prof in distinct-values($profs)
            order by replace($prof, '.* ', '')
            return <professor name="{$prof}">{concat(replace($prof, '.* ', ''), ', ', replace($prof, ' [^\s]*$', '')) }</professor>
    }
    </professors>
    </search>
    
    <!-- current search data to display to user -->
    <searchResults>
        {local:searchCriterias()}
    </searchResults>
    
    <!-- current search data to be passed if a sort is called -->
    <sortInfo>
        {local:searchCriterias()}
    </sortInfo>
    
    </top>

    {    
        (: return no results option after the search link is click :)
        if($noResults eq '*') then(
    
        (: get all courses that match the search :)
    	subsequence(
    	   for $course in $col/courses/course
    	 
			let $course_number := replace($course/catalog_info/title/@short_title, '\D', '')
			let $course_sort_number := if (matches($course_number, '^\d+')) then
    			xs:integer($course_number)
			else
    			0
    	
    	   let $meetings := 
                for $meeting in $course/catalog_info/meeting_schedule/meeting
                return concat(replace($meeting/@days_of_week, ' ', ','), ':', $meeting/@start_time, ' to ', $meeting/@end_time, ';')
    	
    	   let $timeCheck := 
    		  for $classTime in $course/catalog_info/meeting_schedule/meeting/@start_time
    		  where $classTime eq $time
    		  return $classTime
    		
    		let $dayCheck := 
    		  for $classDay in $course/catalog_info/meeting_schedule/meeting/@days_of_week
    		  where contains($classDay, $day)
    		  return $classDay
    		
    		(: check time and day, searched by user, are within the same class meeting :)
    		let $timeDayCheck :=
    		     for $meeting in $meetings
    		     where contains($meeting, $day) and contains($meeting, $time)
    		     return $meeting
    	
    		let $professorCheck := 
    		  for $classTime in $course/staff/person/display_name
    		  where $classTime eq $professor
    		  return $classTime

            (: get the first time the class occurs :)
            let $firstTime := 
    		  (for $classTime in $course/catalog_info/meeting_schedule/meeting/@start_time
    		  order by $classTime
    		  return $classTime)[1]
    		
    		(: get the first day the class occurs. Convert thurs and fri to arrange in alaphbetical order :)
    		let $firstDay := 
    		  (for $classDay in $course/catalog_info/meeting_schedule/meeting/@days_of_week
    		  return replace(replace($classDay, 'Thurs', 'Wedt'), 'Fri', 'Wedu'))[1]

            (: courses that match current search data. 
               if not data given for a field, include all courses with true()
            :)
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
            and (if($professor ne '*' and string-length($professor) > 0 and $professor ne 'All') then (
                not(empty($professorCheck))
            )else(true()))
            and (if($keywords ne '*' and string-length($keywords) > 0) then (
                contains(lower-case($course/catalog_info/description), lower-case($keywords)) or
                contains(lower-case($course/catalog_info/title), lower-case($keywords))
            )else(true())) 
            and (if($time ne '*' and string-length($time) > 0 and $time ne 'All' ) then (
                not(empty($timeCheck))
            )else(true()))
            and (if($day ne '*' and string-length($day) > 0 and $day ne 'All' ) then (
                not(empty($dayCheck))
            )else(true()))
            (: if time and date are both specified, they must occur during the same meeting :)
            and (if($time ne '*' and string-length($time) > 0 and $time ne 'All'  and $day ne '*' and string-length($day) > 0 and $day ne 'All' ) then (
                not(empty($timeDayCheck))
            )else(true()))

            (: order by criteria specified by user.
               after user's criteria, order by department, course group, and lastly the short title:)
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
			
			(: return info on matching course :)
			return <course short_title="{$course/catalog_info/title/@short_title}" term_code="{$course/@term_code}" course_group="{$course/catalog_info/course_group}" course_type="{$course/catalog_info/course_type}" 
			     days="{
                    (for $meeting in $course/catalog_info/meeting_schedule/meeting
                    return concat(replace($meeting/@days_of_week, ' ', ','), ':', $meeting/@start_time, ' to ', $meeting/@end_time, ';'))
			     }" 
			     
			     professor="{
			         (for $teacher in distinct-values($course/staff/person/display_name)
		                  return concat($teacher, ','))
			     }"
			     >{$course/catalog_info/title/text()}</course>
		,20*number($pageNumber) + 1,20)
		)else()
    }
    
    <!-- search and sort data to be forwarded when next page called -->
    <nextPage
        deptCode="{$deptCode}"
        groupCode="{$groupCode}"
        term="{$term}"
        time="{$time}"
        professor="{$professor}"
        keywords="{$keywords}"
        day="{$day}"

        sdepartment="{$sdepartment}"
        sgroup="{$sgroup}"
        sterm="{$sterm}"
        stype="{$stype}"
        stime="{$stime}"
        sdays="{$sdays}"
        
        pageNumber="{$pageNumber}"
     />
    
</result>






