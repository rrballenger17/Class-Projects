/** {@code UrlTags} reads files about URL views and collects all the user-generated tags. The data parsed
 *  with the Link class in this package. The URL and each tag are written to the context by the map part of the
 *  MapReduce program. The reduce part eliminates duplicate tags and writes each URL with all its distinct user-
 *  generated tags. 
 *  @author Ryan Ballenger
 *  @version 1.0
 *  @since December 16, 2015
 */
package cscie55.hw8;

import java.io.IOException;
import java.util.*;

import java.util.HashMap;

import org.apache.hadoop.conf.*;
import org.apache.hadoop.fs.*;
import org.apache.hadoop.conf.*;
import org.apache.hadoop.io.*;
import org.apache.hadoop.mapreduce.*;
import org.apache.hadoop.mapreduce.lib.input.*;
import org.apache.hadoop.mapreduce.lib.output.*;
import org.apache.hadoop.util.*;

public class UrlTags extends Configured implements Tool {

    public static void main(String args[]) throws Exception {
	int res = ToolRunner.run(new UrlTags(), args);
	System.exit(res);
    }

    public int run(String[] args) throws Exception {
	Path inputPath = new Path(args[0]);
	Path outputPath = new Path(args[1]);

	Configuration conf = getConf();
	Job job = new Job(conf, this.getClass().toString());

	FileInputFormat.setInputPaths(job, inputPath);
	FileOutputFormat.setOutputPath(job, outputPath);

	job.setJobName("UrlTags");
	job.setJarByClass(UrlTags.class);
	job.setInputFormatClass(TextInputFormat.class);
	job.setOutputFormatClass(TextOutputFormat.class);
	// adjusted
	job.setMapOutputKeyClass(Text.class);
	job.setMapOutputValueClass(Text.class);
	// adjusted
	job.setOutputKeyClass(Text.class);
	job.setOutputValueClass(Text.class);

	job.setMapperClass(Map.class);
	//job.setCombinerClass(Reduce.class);
	job.setReducerClass(Reduce.class);

	return job.waitForCompletion(true) ? 0 : 1;
    }

    //adjusted 
    public static class Map extends Mapper<LongWritable, Text, Text, Text> {
		private final static IntWritable one = new IntWritable(1);
		private Text word = new Text();

		/**
		 *  The map method parses lines with the Link class. For each tag retrieved from the Link object
		 *  it writes to the context the URL and that tag.
		 *  @param key, unused
		 *  @param value the line from the input file
		 *  @param context the MapReduce context where the map method writes to
		 */ 
    	@Override
		public void map(LongWritable key, Text value, Mapper.Context context) throws IOException, InterruptedException {
			
			// creates a link object from the line
			Link a = Link.parse(value.toString());
			if(a == null) return;

			String url = a.url();
			List<String> tags = a.tags();
		
			// writes the url and each word to the context
			for (String tag: tags) {
	    		context.write(new Text(url), new Text(tag));
			}

    	}
    }

    //adjusted
    public static class Reduce extends Reducer<Text, Text, Text, Text> {


    /**
	  *  reduce method adds all the tags per the URL key to a set to eliminate duplicates. It then 
	  *  combines all the distinct tags with a comma into a concatenated string. It write the URL
	  *  and the concatenated tags to the context. 
	  *  @param key, unused
	  *  @param value the line from the input file
	  *  @param context the MapReduce context where the map method writes to
	  */ 
    @Override
	public void reduce(Text key, Iterable<Text> values, Context context) throws IOException, InterruptedException {

		String sum = "";
		Set<String> present = new HashSet<String>();

		// adds each tag to the set to eliminate duplicates
		for(Text s: values){
			present.add(s.toString());
		}

		// combines tags into a string
		int count = 0;
		for(String s: present){
			if(count != 0) sum += ",";
			sum += s;
			count++;
		}

		// writes URL and comma separated terms to the context
		context.write(key, new Text(sum));

    }
    }

}





