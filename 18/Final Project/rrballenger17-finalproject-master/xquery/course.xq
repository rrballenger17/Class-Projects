xquery version "3.0" encoding "UTF-8";

declare variable $col_path := request:get-attribute('collection_path');
declare variable $col := collection($col_path);

declare variable $shortTitle := request:get-parameter('shortTitle','*');

<result>
    <pdf shortTitle="{$shortTitle}"/>
    
    {    
        (:let $classes := $col/courses/course:)
        
        

        for $class in $col/courses/course
            let $meetings := 
                for $meeting in $class/catalog_info/meeting_schedule/meeting
                return concat(replace($meeting/@days_of_week, ' ', ','), ':', $meeting/@start_time, ' to ', $meeting/@end_time, ';')
        
            where $class/catalog_info/title/@short_title eq $shortTitle
            
            return 
            <course
                title="{$class/catalog_info/title/text()}"
                shortTitle="{$class/catalog_info/title/@short_title}"
                professor="{$class/staff/person/display_name}"
                term="{$class/@term_code}"
                days="{$meetings}"
                description="{$class/catalog_info/description}"
                notes="{$class/catalog_info/notes}"/>
            
    }
   
</result>






