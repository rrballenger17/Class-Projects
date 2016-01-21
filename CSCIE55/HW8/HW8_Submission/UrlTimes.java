/** {@code UrlTimes} finds the URLs that were visited during a user-inputted time frame. All the URLs from the 
 *  data are analyzed. If its time is within the specified frame, the map method adds the URL and an IntWritable
 *  value of 1 to the context. The reduce method counts the number of IntWritable's to figure out how many times
 *  the URL was visited. It then writes each URL within the time frame and the number of visits to the context. 
 *  @author Ryan Ballenger
 *  @version 1.0
 *  @since December 16, 2015
 */

package cscie55.hw8;

import java.io.IOException;
import java.util.*;

import java.util.HashMap;
import java.text.*;
import java.util.Date;

import org.apache.hadoop.conf.*;
import org.apache.hadoop.fs.*;
import org.apache.hadoop.conf.*;
import org.apache.hadoop.io.*;
import org.apache.hadoop.mapreduce.*;
import org.apache.hadoop.mapreduce.lib.input.*;
import org.apache.hadoop.mapreduce.lib.output.*;
import org.apache.hadoop.util.*;



public class UrlTimes extends Configured implements Tool {

	private static Long startmilliseconds;
	private static Long endmilliseconds;

    public static void main(String args[]) throws Exception {

    	// write the input start and end time to the configuration as described in lecture
    	SimpleDateFormat simpleDateFormat = new SimpleDateFormat("dd-MM-yyyy");
    	simpleDateFormat.setTimeZone(TimeZone.getTimeZone("EST"));
    	
    	Date startDate = simpleDateFormat.parse(args[6]);
    	startmilliseconds = startDate.getTime()/1000;

    	Date endDate = simpleDateFormat.parse(args[7]);
    	endmilliseconds = endDate.getTime()/1000;

		int res = ToolRunner.run(new UrlTimes(), args);
		System.exit(res);
    }

    public int run(String[] args) throws Exception {
	Path inputPath = new Path(args[0]);
	Path outputPath = new Path(args[1]);

	Configuration conf = getConf();
	conf.set("start", "" + startmilliseconds);
	conf.set("end", "" + endmilliseconds);

	Job job = new Job(conf, this.getClass().toString());

	FileInputFormat.setInputPaths(job, inputPath);
	FileOutputFormat.setOutputPath(job, outputPath);

	job.setJobName("UrlTimes");
	job.setJarByClass(UrlTimes.class);
	job.setInputFormatClass(TextInputFormat.class);
	job.setOutputFormatClass(TextOutputFormat.class);
	// adjusted
	job.setMapOutputKeyClass(Text.class);
	job.setMapOutputValueClass(IntWritable.class);
	// adjusted
	job.setOutputKeyClass(Text.class);
	job.setOutputValueClass(IntWritable.class);

	job.setMapperClass(Map.class);
	//job.setCombinerClass(Reduce.class);
	job.setReducerClass(Reduce.class);

	return job.waitForCompletion(true) ? 0 : 1;
    }

    //adjusted 
    public static class Map extends Mapper<LongWritable, Text, Text, IntWritable> {
		private final static IntWritable one = new IntWritable(1);
		private Text word = new Text();

		/**
		 *  map retrieves the start and end time from the Configuration for the job. It then parses 
		 *  the line of data and gets the URL and timestamp. If the timestamp is between the start and end
		 *  time, it adds it to the context with an IntWritable value of 1.
		 *  @param key, unused
		 *  @param value the line from the input file
		 *  @param context the MapReduce context where the map method writes to
		 */ 
    	@Override
		public void map(LongWritable key, Text value, Mapper.Context context) throws IOException, InterruptedException {
			
			Configuration con = context.getConfiguration();
			Long start = Long.parseLong(con.get("start"));
			Long end = Long.parseLong(con.get("end"));

			Link a = Link.parse(value.toString());

			// skip blank lines
			if(a == null) return;

			String url = a.url();
			Long time = a.timestamp();
			
			if(time >= start && time <= end){
	    		context.write(new Text(url), new IntWritable(1));
			}

    	}
    }

    //adjusted
    public static class Reduce extends Reducer<Text, IntWritable, Text, IntWritable> {

    @Override
    /**
	  *  reduce sums the numbers of occurences of the URL in the timeframe. It then writes to the context
	  *  the URL and the number of times it occurred.
	  *  @param key URL
	  *  @param value number of occurences of the key URL
	  *  @param context the MapReduce context where the reduce method writes to
	  */ 
	public void reduce(Text key, Iterable<IntWritable> values, Context context) throws IOException, InterruptedException {

		int count = 0;

		for(IntWritable s: values){
			count++;
		}

		context.write(key, new IntWritable(count));

    }
    }

}





